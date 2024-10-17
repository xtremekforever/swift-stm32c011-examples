import CortexM
import MMIO
import Support

let LED3 = 6

struct Board {
    init() {
        // Enable GPIOB
        rcc.iopenr.modify { rw in
            rw.raw.gpioben = 1
        }

        // Enable systick register with default configuration
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

    func setLed(value: UInt32) {
        gpiob.set(pin: LED3, value: value)
    }
}

@main
struct Main {
    static func main() {
        let board = Board()
        while true {
            board.setLed(value: 1)
            systick.delay(ticks: 100)
            board.setLed(value: 0)
            systick.delay(ticks: 300)
        }
    }
}
