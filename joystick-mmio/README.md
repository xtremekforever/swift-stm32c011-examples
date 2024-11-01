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

Run the `make` command in this directory to create a release build. The binary is found at `.build/release/joystick.bin`.

If running with a Swift 6.1 nightly toolchain or in the devcontainer, you can create a release build with `make CONFIGURATION=debug`, and the binary will be found at `.build/debug/joystick.bin`.

## Flashing

See the main [README.md](../README.md#flashing) for instructions on flashing.
