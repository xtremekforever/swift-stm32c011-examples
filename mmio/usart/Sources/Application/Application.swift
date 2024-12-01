import CortexM
import STM32C011

@main
struct Main {
    typealias Board = STM32C0116_DK

    static func main() {
        let board = Board()

        // Configure peripherals that are used
        board.configureLed()
        board.configureUsart(baud: 115200)

        //print("Hello Embedded Swift")

        while true {

            // Wait for input byte
            usart2.waitRxBufferFull()

            // Read byte
            let byte = usart2.rx()

            board.setLed(.on)

            // Echo back
            usart2.tx(value: byte)
            usart2.waitTxBufferEmpty()

            // Send a "\n" if the byte is a "\r"
            if byte == UInt8(ascii: "\r") {
                usart2.tx(value: UInt8(ascii: "\n"))
                usart2.waitTxBufferEmpty()
            }

            systick.delay(ticks: 5)

            board.setLed(.off)
        }
    }
}
