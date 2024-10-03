# Swift Examples for STM32C011

These are a couple of examples for the STM32C011 built using Swift for Embedded that is available in Swift 6.0 and later.
In particular, these demos are built for the [STM32C0116-DK](https://www.st.com/en/evaluation-tools/stm32c0116-dk.html) which is a simple development kit that contains a few peripherals to play with, such as an LED, 5-way joystick, UART, and LCD connectors.

## Prerequisites

All of these examples are built under a Ubuntu host (20.04 or later) and as such are made to work with the `arm-none-eabi` tools that are available in the package repositories. To compile these projects, an installation of the Swift 6.0 toolchain or later is required. Then, the following packages should be installed:

```bash
sudo apt install build-essential gcc-arm-none-eabi stlink-tools
```

## Compiling

Each project can be built using the `make` command. Also, for each project, build artifacts are found in the `.build` subdirectory, which will include *.elf, *.map, *.lst, and *.bin files.
