# Joystick MMIO Demo

This demo reads the joystick on the STM32C0116-DK and flashes the LED at different rates depending
on what direction is depressed on the joystick.

| Joystick  | Blink Rate   |
| --------- | ------------ |
| `Select`  | Solid ON     |
| `Up`      | 25ms ON/OFF  |
| `Right`   | 50ms ON/OFF  |
| `Down`    | 75ms ON/OFF  |
| `Left`    | 100ms ON/OFF |
| `None`    | Solid OFF    |

It should be noted that the `Up` direction on the STM32C0116-DK is towards the MCU on the board and towards the USB connector. Also, `Select` is when the joystick is pressed down in the middle.

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
Build complete! (3.92s)
linking...
arm-none-eabi-gcc ./.build/release/libApplication.a -o ./.build/release/joystick.elf \
        -mcpu=cortex-m0plus -mthumb -mfloat-abi=soft \
        -ffreestanding -fdata-sections -ffunction-sections -fno-builtin -fno-common -fshort-enums -std=gnu11 \
        --specs=nano.specs --specs=nosys.specs \
        -Wl,--gc-sections \
        -T./Sources/Support/STM32C011F6.ld
Extracting lst file...
arm-none-eabi-objdump -S .build/release/joystick.elf | swift demangle > ./.build/release/joystick.lst
arm-none-eabi-objdump: Warning: Unrecognized form: 0x23
arm-none-eabi-objdump: DWARF error: invalid or unhandled FORM value: 0x23
Extracting map file...
arm-none-eabi-objdump -t .build/release/joystick.elf | swift demangle > ./.build/release/joystick.map
arm-none-eabi-objdump: Warning: Unrecognized form: 0x23
Extracting & printing sizes...
arm-none-eabi-size .build/release/joystick.elf -G > ./.build/release/joystick.size
      text       data        bss      total filename
      1300        264          0       1564 .build/release/joystick.elf
Extracting bin file...
arm-none-eabi-objcopy -O binary .build/release/joystick.elf ./.build/release/joystick.bin
-rwxrwxr-x 1 xtremek xtremek 1.6K Nov  1 09:06 ./.build/release/joystick.bin
```

If running with a Swift 6.1 nightly toolchain or in the devcontainer, you can create a debug build with `make CONFIGURATION=debug`, and the binary will be found at `.build/debug/joystick.bin`.

## Flashing

See the main [README.md](../README.md#flashing) for instructions on flashing.
