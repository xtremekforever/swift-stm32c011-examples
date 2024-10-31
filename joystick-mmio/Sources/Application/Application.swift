import CortexM

@main
struct Main {
    typealias Board = STM32C0116_DK

    static func main() {
        let board = Board()
        while true {
            board.setLed(value: ~board.ledState)
            systick.delay(ticks: 500)
        }
    }
}
