import CortexM

@main
struct Main {
    typealias Board = STM32C0116_DK

    static func main() {
        let board = Board()
        while true {
            board.setLed(value: 0)
            systick.delay(ticks: 100)
            board.setLed(value: 1)
            systick.delay(ticks: 300)
        }
    }
}
