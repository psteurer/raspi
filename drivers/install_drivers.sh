#! /bin/bash
# Script executes a few configuration steps and updates after a fresh installation of a Raspberry Pi based on Raspbian.
# The script assumes that you completed the initial Raspbian installation and setup.

# Informs about missing arguments and displays help
function PrintArgumentsHelp {
    echo "No or invalid arguments supplied. Valid arguments are:"
    echo "  info:       show current hardware and operating system"
    echo "  update:     update operating system"
    echo "  install:    install display driver"
    echo "  all:        perform all of the above steps at once"
}

# Print OS info such as if script is running on an ARM processor and Linux
function PrintOSInfo {
    echo "Checking machine hardware name, operating system and release"
    CURRENT_MACHINE_HW_NAME=$(uname -m)
    CURRENT_OS_NAME=$(uname -s)
    CURRENT_RELEASE=$(uname -r)
    echo "Running $CURRENT_OS_NAME on $CURRENT_MACHINE_HW_NAME release $CURRENT_RELEASE"
}

# Print OS info such as if script is running on an ARM processor and Linux
function ExitIfNotRunningOnArmAndLinux {
    if [[ $CURRENT_MACHINE_HW_NAME == "arm"* ]] && [ $CURRENT_OS_NAME == "Linux" ]; then
        echo "Running on ARM and Linux"
    else
        echo "Not running on ARM and Linux -> scripts exits immediately"
        exit
    fi
}

# Update operating system
function UpdateOS {
    echo "Updating operating system"
    sudo apt-get update
    sudo apt-get dist-upgrade
}

# Install HAT display driver
function InstallDispayDriver { 
    echo "Installing HAT display driver"
    wget http://www.4dsystems.com.au/downloads/4DPi/All/gen4-hats_4-14-34_v1.1.tar.gz
    sudo tar -xzvf gen4-hats_4-14-34_v1.1.tar.gz -C /
    rm -f gen4-hats_4-14-34_v1.1.tar.gz
    echo "Raspi will shutdown. This may take a while since many files have to be written from cache to disk."
    echo "Unplug the raspi from power. Connect the display. Power up raspi again."
    sudo poweroff
}

# Check if an argument was provided
if [ -z "$1" ]; then
    PrintArgumentsHelp
    exit
fi

# Evaluate command line arguments and run desired function
if [ $1 = "info" ]; then
    PrintOSInfo
elif [ $1 = "update" ]; then 
    PrintOSInfo
    ExitIfNotRunningOnArmAndLinux
    UpdateOS
elif [ $1 = "install" ]; then 
    PrintOSInfo
    ExitIfNotRunningOnArmAndLinux
    InstallDispayDriver
elif [ $1 = "all" ]; then 
    PrintOSInfo
    ExitIfNotRunningOnArmAndLinux
    UpdateOS
    InstallDispayDriver
else
    PrintArgumentsHelp
    exit
fi