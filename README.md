# Swift Examples for STM32C011

These are a couple of examples for the STM32C011 built using Swift for Embedded that is available in Swift 6.0 and later.
In particular, these demos are built for the [STM32C0116-DK](https://www.st.com/en/evaluation-tools/stm32c0116-dk.html) which is a simple development kit that contains a few peripherals to play with, such as an LED, 5-way joystick, UART, and LCD connectors.

## Prerequisites

All of these examples can be built under macOS or Linux (Ubuntu) using a Swift 6.0.0 toolchain or later.
They are made to work with the `arm-none-eabi` that are available for cross-compiling to ARM.

NOTE: In order to build `blink-mmio` in "debug" mode (`make CONFIGURATION=debug`) you will need to have
a recent trunk snapshot which automatically enables whole module optimization for embedded projects.
However, release mode builds (which are the default) should work fine with Swift 6.0 or later.

### macOS

Install the following tools with homebrew:

```bash
brew install gcc-arm-embedded stlink
```

### Linux

On a Ubuntu host (20.04-24.04), install the following dependencies:

```bash
sudo apt install build-essential gcc-arm-none-eabi stlink-tools
```

For RHEL/Fedora, install the following dependencies:

```bash
sudo dnf install make arm-none-eabi-gcc-cs arm-none-eabi-newlib stlink
```

## Compiling

Each project can be built using the `make` command. Also, for each project, build artifacts are found in the `.build` subdirectory, which will include *.elf, *.map, *.lst, and *.bin files.
