#!/bin/bash

echo "Updating packages..."
sudo dnf update

echo "Installing dependencies needed to build and flash..."
sudo dnf install -y make arm-none-eabi-gcc-cs arm-none-eabi-newlib stlink
