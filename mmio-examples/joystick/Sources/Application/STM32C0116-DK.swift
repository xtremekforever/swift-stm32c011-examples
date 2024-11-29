import Common
import CortexM
import MMIO

struct STM32C0116_DK {
    /// PA4
    let JOYSTICK_PIN = 4
    /// PA8
    let JOYSTICK_ADC_CHANNEL = 8

    // PB6
    let LED3 = 6

    var joystickVoltage: UInt32 = 0

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

        // Configure JOYSTICK_PIN as analog
        gpioa.configure(
            pin: JOYSTICK_PIN,
            as: .init(mode: .analog, outputType: .pushPull, outputSpeed: .high, pull: .none)
        )

        // Configure LED3 as an output with a pull-down
        gpiob.configure(
            pin: LED3,
            as: .init(mode: .output, outputType: .pushPull, outputSpeed: .high, pull: .down)
        )

        // Configure global ADC features
        adc.configure(
            as: .init(resolution: .bits12, overrunMode: .preserved, clockMode: .pclkDiv4)
        )

        // Calibrate
        adc.calibrate()

        // Configure the ADC channels
        adc.configureChannel(channel: JOYSTICK_ADC_CHANNEL, samplingTime: .cycle39_5)

        // Enable the ADC
        adc.enable()
    }

    var ledState: Bool {
        gpiob.get(pin: LED3) == 0 ? true : false
    }

    func setLed(on: Bool) {
        gpiob.set(pin: LED3, value: on ? 0 : 1)
    }

    func blinkLed(for ticks: Int) {
        setLed(on: true)
        systick.delay(ticks: ticks)
        setLed(on: false)
        systick.delay(ticks: ticks)
    }

    mutating func readVoltages() {
        adc.start()
        joystickVoltage = adc.getValue()
    }

    enum JoystickState {
        case select
        case left
        case down
        case up
        case right
        case none
    }

    // These values were copied from the STM32CubeC0 "stm32c0316_discovery.c" file
    let joystickVoltageSelect: Range<UInt32> = 0..<10
    let joystickVoltageLeft: Range<UInt32> = 709..<955
    let joystickVoltageDown: Range<UInt32> = 1514..<1762
    let joystickVoltageUp: Range<UInt32> = 2370..<2618
    let joystickVoltageRight: Range<UInt32> = 3000..<3312

    var joystickState: JoystickState {
        switch joystickVoltage {
        case joystickVoltageSelect:
            return .select
        case joystickVoltageLeft:
            return .left
        case joystickVoltageDown:
            return .down
        case joystickVoltageUp:
            return .up
        case joystickVoltageRight:
            return .right
        default:
            return .none
        }
    }
}
