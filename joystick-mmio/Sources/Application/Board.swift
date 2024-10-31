import CortexM
import MMIO

struct STM32C0116_DK {
    let LED3 = 6

    init() {
        // Enable GPIOs
        rcc.iopenr.modify { rw in
            rw.raw.gpioaen = 1
            rw.raw.gpioben = 1
        }

        // Enable ADC
        rcc.apbenr2.modify { rw in
            rw.raw.adcen = 1
        }

        // Configure systick register + enable
        systick.configure(reload: 1500)
        systick.setState(.enabled)

        // Configure LED3 as an output with a pull-down
        gpiob.configure(
            pin: LED3,
            as: GPIO.Configuration(
                mode: .output, outputType: .pushPull, outputSpeed: .high,
                pull: .down, alternateFunction: 0
            )
        )
    }

    var ledState: UInt32 {
        gpiob.get(pin: LED3)
    }

    func setLed(value: UInt32) {
        gpiob.set(pin: LED3, value: value)
    }
}
