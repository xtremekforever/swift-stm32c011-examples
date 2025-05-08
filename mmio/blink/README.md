# Blink MMIO Demo

This is a very simple demo that blinks the LED (LED3) on the STM32C0116-DK using a specific pattern of `100ms ON` and `300ms OFF`.

For this demo, the [swift-cortex-m](https://github.com/xtremekforever/swift-cortex-m") library is used to enable and use the `SysTick` peripheral, which provides a relatively-accurate timing of ~1ms per tick. This is used for the 100ms/300ms delays for the blink pattern.

## Building

Resolve dependencies before building:

```bash
swift package resolve
```

Then, run the `make` command in this directory to create a release build:

```bash
$ make
compiling (please be patient, this may take a few minutes)...
swift build \
        --configuration release \
        --swift-sdks-path ../swift-sdks \
        --swift-sdk stm32c0xx \

[1/1] Planning build
Building for production...
[3/3] Write swift-version--71903000615C161C.txt
Build complete! (2.92s)
linking...
arm-none-eabi-gcc ./.build/release/libApplication.a -o ./.build/release/blink.elf \
        -mcpu=cortex-m0plus -mthumb -mfloat-abi=soft \
        -ffreestanding -fdata-sections -ffunction-sections -fno-builtin -fno-common -fshort-enums -std=gnu11 \
        --specs=nano.specs --specs=nosys.specs \
        -Wl,--gc-sections \
        -T./Sources/Support/STM32C011F6.ld
Extracting lst file...
arm-none-eabi-objdump -S .build/release/blink.elf | swift demangle > ./.build/release/blink.lst
arm-none-eabi-objdump: Warning: Unrecognized form: 0x23
arm-none-eabi-objdump: DWARF error: invalid or unhandled FORM value: 0x23
Extracting map file...
arm-none-eabi-objdump -t .build/release/blink.elf | swift demangle > ./.build/release/blink.map
arm-none-eabi-objdump: Warning: Unrecognized form: 0x23
Extracting & printing sizes...
arm-none-eabi-size .build/release/blink.elf -G > ./.build/release/blink.size
      text       data        bss      total filename
       496        248          0        744 .build/release/blink.elf
Extracting bin file...
arm-none-eabi-objcopy -O binary .build/release/blink.elf ./.build/release/blink.bin
-rwxrwxr-x 1 xtremek xtremek 744 Nov  1 09:04 ./.build/release/blink.bin
```

If running with a Swift 6.1 nightly toolchain or in the devcontainer, you can create a debug build with `make CONFIGURATION=debug`, and the binary will be found at `.build/debug/blink.bin`.

## Flashing

See the main [README.md](../README.md#flashing) for instructions on flashing.
