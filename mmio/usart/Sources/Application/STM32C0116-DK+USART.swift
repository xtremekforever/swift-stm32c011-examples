import STM32C011

extension STM32C0116_DK {
    func configureUsart(baud: UInt32) {
        // Enable GPIOA
        rcc.iopenr.modify { rw in
            rw.raw.gpioaen = 1
        }

        // Enable APB clock to usart 2
        rcc.apbenr1.modify { rw in
            rw.raw.usart2en = 1
        }

        // PA2: USART2_TX
        gpioa.configure(
            pin: 2,
            as: .init(
                mode: .alternateFunction, outputType: .pushPull, outputSpeed: .low, pull: .none,
                alternateFunction: 1
            )
        )

        // PA3: USART2_RX
        gpioa.configure(
            pin: 3,
            as: .init(
                mode: .alternateFunction, outputType: .pushPull, outputSpeed: .low, pull: .none,
                alternateFunction: 1
            )
        )

        usart2.configure(baud: baud)
        usart2.enable()
    }
}

@_cdecl("getchar")
public func getchar() -> CInt {
    usart2.waitRxBufferFull()
    let byte = usart2.rx()
    return CInt(byte)
}

public func putchar(_ value: CInt) -> CInt {
    usart2.waitTxBufferEmpty()
    usart2.tx(value: UInt8(value))
    usart2.waitTxBufferEmpty()
    return 0
}
