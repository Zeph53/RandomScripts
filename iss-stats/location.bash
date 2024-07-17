#!/bin/bash

# Get the current time in the local timezone
current_time=$(TZ="$(date +%Z)" date -u +"%Y-%m-%dT%H:%M:%S")

# Fetch current ISS position data
iss_data=$(curl -s http://api.open-notify.org/iss-now.json)

# Extract latitude and longitude from the fetched data using string manipulation
latitude=$(echo "$iss_data" | grep -oP '"latitude":.*?[^\\]",' | grep -oP '[-+]?([0-9]*\.[0-9]+|[0-9]+)' | head -1)
longitude=$(echo "$iss_data" | grep -oP '"longitude":.*?[^\\]",' | grep -oP '[-+]?([0-9]*\.[0-9]+|[0-9]+)' | head -1)

# Display current ISS position
echo ""
echo "Current ISS Position:"
echo "Latitude (Degrees): $latitude"
echo "Longitude (Degrees): $longitude"

# Check if latitude and longitude are valid numbers
if ! [[ $latitude =~ ^[+-]?[0-9]*[.]?[0-9]+$ ]] || ! [[ $longitude =~ ^[+-]?[0-9]*[.]?[0-9]+$ ]]; then
    echo "Error: Latitude or longitude is not a valid number."
    exit 1
fi

# Convert latitude and longitude to radians
latitude_rad=$(echo "$latitude * 0.0174533" | bc -l)
longitude_rad=$(echo "$longitude * 0.0174533" | bc -l)

# Output latitude and longitude in radians
echo "Latitude (Radians): $latitude_rad radians"
echo "Longitude (Radians): $longitude_rad radians"

# Rest of your script remains unchanged...


# Fetch the ISS data and process to find the next closest maneuver
next_maneuver=$(curl -s https://nasa-public-data.s3.amazonaws.com/iss-coords/current/ISS_OEM/ISS.OEM_J2K_EPH.txt \
| grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}' \
| awk -v current="$current_time" '$1 > current' \
| head -n 1)

# Display the closest upcoming maneuver
echo ""
echo "Next maneuver:"
echo "$next_maneuver" | awk -F ' ' '{printf("Timestamp: %s\nOrbit-X: %s\nOrbit-Y: %s\nOrbit-Z: %s\n", $1, $2, $3, $4)}'

if [ -n "$next_maneuver" ]; then
    # Extract longitude and latitude based on Orbit-X, Orbit-Y, and Orbit-Z coordinates
    orbit_x=$(echo "$next_maneuver" | awk '{printf("%.10f\n", $2)}')
    orbit_y=$(echo "$next_maneuver" | awk '{printf("%.10f\n", $3)}')
    orbit_z=$(echo "$next_maneuver" | awk '{printf("%.10f\n", $4)}')

    # Calculate longitude in radians
    longitude_rad=$(echo "scale=10; s($orbit_y / sqrt($orbit_x^2 + $orbit_y^2))" | bc -l)

    # Calculate latitude in radians
    radius=$(echo "sqrt($orbit_x^2 + $orbit_y^2 + $orbit_z^2)" | bc -l)
    latitude_rad=$(echo "scale=10; a($orbit_z / $radius)" | bc -l)

    # Convert latitude to degrees
    latitude_deg=$(echo "$latitude_rad * 180 / (a(1))" | bc -l)

    # Normalize latitude to the -90 to +90 range
    if (( $(echo "$latitude_deg > 90" | bc -l) )); then
        latitude_deg=$(echo "90 - ($latitude_deg - 90)" | bc -l)
    elif (( $(echo "$latitude_deg < -90" | bc -l) )); then
        latitude_deg=$(echo "-90 - ($latitude_deg + 90)" | bc -l)
    fi

    # Limit latitude to 10 decimals
    formatted_latitude_deg=$(printf "%.10f" $latitude_deg)

    # Output latitude in degrees
    echo "Latitude (Degrees): $formatted_latitude_deg"

    # Output latitude in radians
    printf "Latitude (Radians): %.10f\n" $latitude_rad

    # Normalize longitude to the -180 to +180 range
    longitude_deg=$(echo "$longitude_rad * 180 / (a(1))" | bc -l)

    # Output longitude in degrees
    printf "Longitude (Degrees): %.10f\n" $longitude_deg

    # Output longitude in radians
    printf "Longitude (Radians): %.10f\n" $longitude_rad

    # Extract and display velocity components with units (km/s)
    echo "$next_maneuver" | awk -F ' ' '{printf("Velocity-X: %.16f km/s\nVelocity-Y: %.16f km/s\nVelocity-Z: %.16f km/s\n", $5, $6, $7)}'

    # Calculate velocity magnitude in meters per second (converting from km/s to m/s)
    velocity=$(echo "$next_maneuver" | awk -F ' ' '{printf("%.16f\n", sqrt($5^2 + $6^2 + $7^2)*1000)}')

    # Output velocity in meters per second
    echo "Magnitude of Velocity: $velocity m/s"
fi

# Display the system and userspace time
if [ -n "$next_maneuver" ]; then
    next_maneuver_time=$(echo "$next_maneuver" | awk '{print $1}')
    system_time_message="The system time at the maneuver:"
    formatted_system_time=$(date -u -d "$next_maneuver_time" +'%Y-%m-%d %I:%M:%S %p UTC')
    user_timezone=$(date +"%Z")
    local_time=$(TZ=":$user_timezone" date -d "$next_maneuver_time UTC" +'%Y-%m-%d %I:%M:%S %p %Z')
    echo ""
    echo "$system_time_message $formatted_system_time."
    echo "Your userspace time will be: $local_time."
fi
