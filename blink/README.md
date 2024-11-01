# Blink Demo

This is an extremely simple demo that binks the LED (LED3) on the STM32C011-DK using a specific pattern of `100ms ON` and `300ms OFF`. Please note that ASM `nop` instructions are used for delays, so the timing is likely not very accurate.

However, this demo shows off using Swift to compile for embedded with no external dependencies, while also compiling and linking needed C code as well.

## Building

Run the `make` command in this directory:

```bash
$ make
# Build Swift sources
swiftc -target armv6m-none-none-eabi -Osize -import-bridging-header ./BridgingHeader.h -wmo -enable-experimental-feature Embedded -Xcc -ffreestanding -Xfrontend -function-sections -Xcc -mcpu=cortex-m0plus -Xcc -mfloat-abi=soft -Xcc -mthumb -Xcc -fshort-enums -c Main.swift Registers.swift -o .build/blink.o
# Link objects into executable
arm-none-eabi-gcc -Wl,--gc-sections -T./STM32C011F6.ld -mcpu=cortex-m0plus -mthumb -mfloat-abi=soft -ffreestanding -fdata-sections -ffunction-sections -fno-builtin -fno-common -fshort-enums -std=gnu11 --specs=nano.specs --specs=nosys.specs .build/blink.o .build/Startup.o -o .build/blink.elf
# Extract sections from executable into flashable binary
arm-none-eabi-objcopy -O binary .build/blink.elf .build/blink.bin
# Echo final binary path
ls -al ./.build/blink.bin
-rwxrwxr-x 1 xtremek xtremek 488 Nov  1 09:15 ./.build/blink.bin
# Export decompiled asm from executable
arm-none-eabi-objdump -S .build/blink.elf > ./.build/blink.lst
# Export memory map of executable
arm-none-eabi-objdump -t .build/blink.elf > ./.build/blink.map
```

## Flashing

See the main [README.md](../README.md#flashing) for instructions on flashing.
