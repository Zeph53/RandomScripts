// preload.c
#define _GNU_SOURCE
#include <dlfcn.h>
#include <unistd.h>

// Define the function signature for the original geteuid()
typedef uid_t (*geteuid_func)(void);

// Define the replacement function for geteuid()
uid_t geteuid(void) {
    // Pointer to hold the original geteuid() function
    geteuid_func original_geteuid;

    // Load the original geteuid() function
    original_geteuid = (geteuid_func)dlsym(RTLD_NEXT, "geteuid");

    // Override the behavior here, return a fake value
    return 1000;  // Return a non-root user ID (e.g., 1000)
}
