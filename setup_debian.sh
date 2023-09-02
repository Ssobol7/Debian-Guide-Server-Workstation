#!/bin/bash

# Updating the package list and installing the necessary utilities
su -
apt update
apt install -y wget gpg sudo

# Editing a file sources.list
nano /etc/apt/sources.list

# Adding a 32-bit architecture (for 64-bit systems)
dpkg --add-architecture i386

# Installing the necessary packages
apt update
apt install -y cut nano wget qt5ct qt5-style-plugins lightdm-gtk-greeter-settings

# Setting up sudo:
echo "Enter your username:"
read username
adduser $username sudo

# Setting up automatic login
nano /etc/lightdm/lightdm.conf

# Installing themes and icons
echo "Make sure that your favorite themes and icons are installed in /usr/share/themes and /usr/share/icons"

# Syncing GTK Theme with Qt
apt install -y qt5ct qt5-style-plugins

# System update
sudo apt update
sudo apt upgrade -y

# Reboot system
reboot
