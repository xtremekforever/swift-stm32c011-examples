import CortexM
import MMIO

struct STM32C0116_DK {
    let LED3 = 6

    init() {
        // Enable GPIOB
        rcc.iopenr.modify { rw in
            rw.raw.gpioben = 1
        }

        // Configure systick register + enable
        systick.configure(reload: 1500)
        systick.setState(.enabled)

        // Configure LED3 as an output with a pull-down
        gpiob.configure(
            pin: LED3,
            as: GPIOB.Configuration(
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
