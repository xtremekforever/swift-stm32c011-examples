enum STM23C011F6Board {
    static func initialize() {
        // Configure pin B6 as an LED
        // (1) IOPENR[1] = 1 ... enable IO clock for GPIOB
        setRegisterBit(baseAddress: RCC.BaseAddress, offset: RCC.Offsets.IOPENR, bit: 1, value: 1)
        // (2) MODER[5] = 1 ... set mode to output
        setRegisterTwoBitField(
            baseAddress: GPIO.GPIOb_BaseAddress, offset: GPIO.Offsets.MODER, bitsStartingAt: 12,
            value: 1)
        // (3) OTYPER[5] = 0 ... output type is push-pull
        setRegisterBit(
            baseAddress: GPIO.GPIOb_BaseAddress, offset: GPIO.Offsets.OTYPER, bit: 6, value: 0)
        // (4) OSPEEDR[5] = 2 ... speed is high
        setRegisterTwoBitField(
            baseAddress: GPIO.GPIOb_BaseAddress, offset: GPIO.Offsets.OSPEEDR, bitsStartingAt: 10,
            value: 2)
        // (5) PUPDR[5] = 2 ... set pull to down
        setRegisterTwoBitField(
            baseAddress: GPIO.GPIOb_BaseAddress, offset: GPIO.Offsets.PUPDR, bitsStartingAt: 12,
            value: 2)

        ledOff()
    }

    static func ledOn() {
        // ODR[5] = 1
        setRegisterBit(
            baseAddress: GPIO.GPIOb_BaseAddress, offset: GPIO.Offsets.ODR, bit: 6, value: 0)
    }

    static func ledOff() {
        // ODR[5] = 0
        setRegisterBit(
            baseAddress: GPIO.GPIOb_BaseAddress, offset: GPIO.Offsets.ODR, bit: 6, value: 1)
    }

    @inline(never)
    static func delay(miliseconds: Int) {
        for _ in 0..<10_000 * miliseconds {
            nop()
        }
    }
}

@main
struct Main {
    typealias Board = STM23C011F6Board

    static func main() {
        Board.initialize()

        while true {
            Board.ledOn()
            Board.delay(miliseconds: 100)
            Board.ledOff()
            Board.delay(miliseconds: 300)
        }
    }
}
