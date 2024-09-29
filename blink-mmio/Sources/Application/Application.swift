import MMIO
import Support

let LED3 = 6;

struct Board {
    init() {
        // Enable GPIOB
        rcc.iopenr.modify { rw in
            rw.raw.gpioben = 1
        }

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

    @inline(never)
    static func delay(miliseconds: Int) {
        for _ in 0..<3000 * miliseconds {
            nop()
        }
    }
}

@main
struct Main {
    static func main() {
        let board = Board()
        while true {
            board.setLed(value: 1)
            Board.delay(miliseconds: 100)
            board.setLed(value: 0)
            Board.delay(miliseconds: 300)
        }
    }
}
