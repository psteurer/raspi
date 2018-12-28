# Raspberry Pi with HAT Display

Basic installation steps to get a Raspberry Pi with a HAT display up and running.

## Getting Started

Here is a list of hardware and software that you will need to get started. There are plenty of options, below is just what I have been using.

### Hardware

- Raspberry Pi, e.g. [Raspberry Pi 3B+](https://www.raspberrypi.org/products/raspberry-pi-3-model-b-plus/)
- Raspberry Pi Case, e.g. [official Raspberry Pi case for 3B](https://www.raspberrypi.org/products/raspberry-pi-3-case/)
- Display, e.g. [4DPI-24-HAT, 2.4" HAT Primary Display](https://www.4dsystems.com.au/product/4DPi_24_HAT/)
- microSD Card
- Power supply and micro USB cable

### Software

- [Raspbian](http://www.raspbian.org) a Debian-based operating system tailored to the Raspberry Pi.
- [PiBakery](https://www.pibakery.org), a tool to configure and flash OS images to SD cards

## Setting up the Raspberry Pi

For automating the setup, I am using [PiBakery](https://www.pibakery.org). It comes with the latest Raspbian OS images, can flash OS images onto SD cards, and execute scripts that can configure some basic settings. I typically use Raspbian Stretch Lite and configure a few things to my liking upon first boot:

1) Enable ssh access
2) Set hostname
3) Set user password (don't use defaults)
4) Set boot option to console
5) Add publish ssh key from my host machine
6) Connect to predefined WiFi
7) Reboot Raspberry Pi to ensure changes are permanent

You will find the corresponding PiBakery recipe in *os/prepare_os.xml*.
Alternatively, you can use [Etcher](https://www.balena.io/etcher), a tool to flash OS images to SD cards, and then write your own scripts to achieve the automation.

### Generate ssh key for password less access

For accessing the Raspberry Pi via ssh without typing a password, you need an ssh key. The above steps assume that such a key exits on your host machine. If you don't have an ssh key yet, you can generate one with the following command. 

```bash
# Generate ssh key at default location
ssh-keygen -t rsa -C pi@raspi
```

## Update Raspberry Pi and install display driver

At this point, the basic OS is available and configured. It is time to get the latest updates and install the display driver. You can achieve this through the following steps if you want to do this manually.

```bash
# update package list
sudo apt-get update

# upgrade entire operating system
sudo apt-get dist-upgrade

# download display driver
wget http://www.4dsystems.com.au/downloads/4DPi/All/gen4-hats_4-14-34_v1.1.tar.gz

# unpack and deploy it
sudo tar -xzvf gen4-hats_4-14-34_v1.1.tar.gz -C /

# after power off, connect the display and power up Raspberry Pi again
sudo poweroff 

```

However, you can also use a bash script to do these steps automatically for you. For that purpose, I am using the script *drivers/install_drivers.sh*. If you remotely wanted to execute the script, you would need to enable root-access without password. As this imposes some unnecessary security issues if permanently enabled, I decided to just copy the script and then run the script manually on the Raspberry Pi. Note that you will need root permissions for the OS update and installing the drivers. The below example uses *icpi* as hostname for the Raspberry Pi.

```bash
# secure copy script to Raspberry Pi
scp ./install_drivers.sh pi@icpi.local:~/

# connect to Raspberry Pi
ssh pi@icpi

# execute script as root
sudo ~/install_drivers.sh all
```

## References

[1] If you reside in Switzerland, [pi-shop.ch](https://www.pi-shop.ch) is a good retailer for Raspberry Pi hardware and accessories. For example, you can find [Raspberry Pi 3 Model B+](https://www.pi-shop.ch/raspberry-pi-3-model-b), [Official Raspberry Pi Case](https://www.pi-shop.ch/offizielles-gehaeuse-der-raspberry-pi-foundation-fuer-pi-3-weiss-rot), and [2.4 Inch HAT Display for Raspberry Pi](https://www.pi-shop.ch/2-4-zoll-hat-display-fuer-raspberry-pi) among many other things. However, you may want to check alternative retailers for comparing prices.
