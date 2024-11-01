import CortexM

@main
struct Main {
    typealias Board = STM32C0116_DK

    static func main() {
        var board = Board()
        while true {
            // Read voltages of the configured ADCs (JOYSTICK_ADC_CHANNEL)
            board.readVoltages()

            // Set LED based on joystick state
            switch board.joystickState {
            case .select:
                board.setLed(on: true)
            case .up:
                board.blinkLed(for: 25)
            case .right:
                board.blinkLed(for: 50)
            case .down:
                board.blinkLed(for: 75)
            case .left:
                board.blinkLed(for: 100)
            case .none:
                board.setLed(on: false)
            }
        }
    }
}
