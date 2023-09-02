#!/bin/bash

# Installing the necessary packages
sudo apt-get update
sudo apt-get install -y wget gpg

# Downloading and importing a Microsoft GPG key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
rm -f packages.microsoft.gpg

# Adding the VS Code repository to the system
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

# Installing apt-transport-https, updating the package list and installing Visual Studio Code
sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y code # или code-insiders для версии Insiders

# Displaying a message about a successful installation
echo "Microsoft Visual Studio Code is installed successfully."





