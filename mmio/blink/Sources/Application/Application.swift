import CortexM
import STM32C011

@main
struct Main {
    typealias Board = STM32C0116_DK

    static func main() {
        let board = Board()

        // Configure peripherals that are used
        board.configureLed()

        while true {
            board.setLed(.on)
            systick.delay(ticks: 100)
            board.setLed(.off)
            systick.delay(ticks: 300)
        }
    }
}
