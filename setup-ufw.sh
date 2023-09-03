#!/bin/bash

# Installing ufw (if it is not already installed)
sudo apt install ufw

# Enabling ufw
sudo ufw enable

# SSH Access Permission
sudo ufw allow OpenSSH

# HTTP and HTTPS permission
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Checking the current rules
sudo ufw status

# Enabling ufw at boot
sudo systemctl enable ufw
