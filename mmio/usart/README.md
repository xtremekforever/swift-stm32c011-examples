# Usart MMIO Demo

This demo reads from USART1 on the STM32C0116-DK and echoes back everything it receives. This demo requires additional hardware:

- A UART 232 adapter, such as the [HiLetgo CP2102](https://www.amazon.com/gp/product/B00LZVEQEY/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1).
- Grove connector cable, such as this one from [Seeed Studio](https://www.amazon.com/gp/product/B074MDM36N/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1).

## Setup

Once you have the needed hardware, connect the Grove connector to the device. Connect the pins in the table below from the CN4 connector to the corresponding pin on the UART 232 adapter (regardless of which model):

| Pin Number | Grove (CN4) | UART 232 |
| ---------- | ----------- | -------- |
| 1          | RXD         | -> TXD   |
| 2          | TXD         | -> RXD   |
| 3          | 3V3         | -> 3V3   |
| 4          | GND         | -> GND   |

Pin Number 1 is the pin on the CN4 connector that is closest to the edge of the board.

If using the `HiLetgo CP2102` adapter, ensure that the [DIP switches are in the USB to 232 position](https://m.media-amazon.com/images/I/51uXK2VxdXL.jpg).

## Building

Run the `make` command in this directory to create a release build:

```bash
$ make
compiling (please be patient, this may take a few minutes)...
swift build \
        --configuration release \
        --swift-sdks-path ./.build/checkouts/swift-stm32c011/SDKs \
        --swift-sdk stm32c0xx \

[1/1] Planning build
Building for production...
[30/30] Archiving libApplication.a
Build complete! (392.49s)
linking...
arm-none-eabi-gcc ./.build/release/libApplication.a -o ./.build/release/usart.elf \
        -mcpu=cortex-m0plus -mthumb -mfloat-abi=soft \
        -ffreestanding -fdata-sections -ffunction-sections -fno-builtin -fno-common -fshort-enums -std=gnu11 \
        --specs=nano.specs --specs=nosys.specs \
        -Wl,--gc-sections \
        -T./.build/checkouts/swift-stm32c011/Scripts/STM32C011F6.ld
Extracting map file...
arm-none-eabi-objdump -t .build/release/usart.elf | swift demangle > ./.build/release/usart.map
Extracting lst file...
arm-none-eabi-objdump -S .build/release/usart.elf | swift demangle > ./.build/release/usart.lst
Extracting & printing sizes...
arm-none-eabi-size .build/release/usart.elf -G > ./.build/release/usart.size
      text       data        bss      total filename
      1092        240       1536       2868 .build/release/usart.elf
Extracting bin file...
arm-none-eabi-objcopy -O binary .build/release/usart.elf ./.build/release/usart.bin
-rwxr-xr-x 1 vscode vscode 1.4K Jan  4 19:08 ./.build/release/usart.bin
```

If running with a Swift 6.1 nightly toolchain or in the devcontainer, you can create a debug build with `make CONFIGURATION=debug`, and the binary will be found at `.build/debug/usart.bin`.

## Flashing

See the main [README.md](../README.md#flashing) for instructions on flashing.

## Running

Once the UART connection is established as shown in the [Setup](#setup) section, use [TeraTerm](https://github.com/TeraTermProject/teraterm/releases) in Windows, or `minicom`/`picocom` in macOS and Linux to connect to the TTY of the USB to 232 adapter.

The following settings are used:

- Baud: `115200`
- Parity: `None`
- Data Bits: `8`
- Stop Bits: `1`
- Flow Control: `None`

By default in macOS or Linux, the USB to 232 device should appear as `/dev/ttyUSB0`. Here's an example of connecting to the port using `picocom`:

```bash
$ picocom /dev/ttyUSB0 -b 115200
picocom v3.1

port is        : /dev/ttyUSB0
flowcontrol    : none
baudrate is    : 115200
parity is      : none
databits are   : 8
stopbits are   : 1
escape is      : C-a
local echo is  : no
noinit is      : no
noreset is     : no
hangup is      : no
nolock is      : no
send_cmd is    : sz -vv
receive_cmd is : rz -vv -E
imap is        : 
omap is        : 
emap is        : crcrlf,delbs,
logfile is     : none
initstring     : none
exit_after is  : not set
exit is        : no

Type [C-a] [C-h] to see available commands
Terminal ready
```

On power up, the firmware should print a message to the terminal:

```
Hello Embedded Swift
```

Any characters typed into the terminal will be echoed back. Also, `LED3` should blink on each character it receives to let the user know of activity. This is a good way to tell if the board is receiving data when debugging the UART connection.
