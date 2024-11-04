#!/bin/bash

STLINK_VERSION=1.8.0
STLINK_DEB=stlink_$STLINK_VERSION-1_amd64.deb

echo "Updating packages..."
sudo apt-get update -y

echo "Removing incompatible stlink-tools..."
sudo apt-get remove -y stlink-tools

echo "Installing dependencies needed to build and flash..."
sudo apt-get install -y make gcc-arm-none-eabi kmod linux-headers-$(uname -r)

echo "Downloading latest stlink release for Ubuntu..."
wget https://github.com/stlink-org/stlink/releases/download/v$STLINK_VERSION/$STLINK_DEB

echo "Installing $STLINK_DEB..."
sudo apt-get install -y ./$STLINK_DEB

echo "Cleaning up..."
rm $STLINK_DEB
