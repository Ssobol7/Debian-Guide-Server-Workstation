#!/bin/bash

# Creating a temporary directory and moving to it
mkdir ~/tmp
cd ~/tmp

# Downloading JupyterLab Desktop
sudo wget https://github.com/jupyterlab/jupyterlab-desktop/releases/latest/download/JupyterLab-Setup-Debian.deb

# Installing JupyterLab Desktop
sudo apt install -y ./JupyterLab-Setup-Debian.deb

# Clearing temporary files
rm -f JupyterLab-Setup-Debian.deb

# Displaying a message about a successful installation
echo "JupyterLab Desktop is installed successfully."
