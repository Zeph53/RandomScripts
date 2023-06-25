'printf "\n$(curl -s https://nasa-public-data.s3.amazonaws.com/iss-coords/current/ISS_OEM/ISS.OEM_J2K_EPH.txt | grep "$(printf "$(date "+%Y-%m-%dT%H:%M" | sed 's/.$//g')")" | tail -n 1)\n"'
