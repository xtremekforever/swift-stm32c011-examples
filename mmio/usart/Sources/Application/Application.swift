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

        print("Hello Embedded Swift\r")

        while true {
            let byte = getchar()

            board.setLed(.on)

            // Echo back
            putchar(byte)

            // Send a "\n" if the byte is a "\r"
            if UInt8(byte) == UInt8(ascii: "\r") {
                putchar(CInt(UInt8(ascii: "\n")))
            }

            systick.delay(ticks: 5)

            board.setLed(.off)
        }
    }
}
