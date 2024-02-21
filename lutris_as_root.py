#!/usr/bin/env python3

import os
import sys

def custom_exit(code=None):
    pass  # Do nothing when sys.exit() is called

# Replace sys.exit with custom_exit
sys.exit = custom_exit

def main():
    if os.geteuid() == 0:
        print("NoticeDialog: Do not run Lutris as root.")
        # sys.exit(2)  # This line will be overridden by custom_exit

if __name__ == "__main__":
    main()
