extension GPIO {
    enum Mode: UInt32 {
        case input = 0x0
        case output = 0x1
        case alternateFunction = 0x2
        case analog = 0x3
    }

    enum OutputType: UInt32 {
        case pushPull = 0x0
        case openDrain = 0x1
    }

    enum OutputSpeed: UInt32 {
        case low = 0x0
        case medium = 0x1
        case high = 0x2
        case max = 0x3
    }

    enum Pull: UInt32 {
        case `none` = 0x0
        case up = 0x1
        case down = 0x2
    }

    struct Configuration {
        var mode: Mode
        var outputType: OutputType
        var outputSpeed: OutputSpeed
        var pull: Pull
        var alternateFunction: UInt32
    }

    func get(pin: Int) -> UInt32 {
        return self.idr.read().raw.storage.get(
            mask: 0b1,
            offset: UInt8(pin)
        )
    }

    func set(pin: Int, value: UInt32) {
        self.odr.modify { rw in
            rw.raw.storage.set(
                value: value,
                mask: 0b1,
                offset: pin
            )
        }
    }

    func configure(pin: Int, as configuration: Configuration) {
        self.moder.modify { rw in
            rw.raw.storage.set(
                value: configuration.mode.rawValue,
                mask: 0b11,
                offset: pin * 2
            )
        }

        // Comprised of 16 x 1 bit fields.
        self.otyper.modify { rw in
            rw.raw.storage.set(
                value: configuration.outputType.rawValue,
                mask: 0b1,
                offset: pin
            )
        }

        // Comprised of 16 x 2 bit fields.
        self.ospeedr.modify { rw in
            rw.raw.storage.set(
                value: configuration.outputSpeed.rawValue,
                mask: 0b11,
                offset: pin * 2
            )
        }

        // Comprised of 16 x 2 bit fields.
        self.pupdr.modify { rw in
            rw.raw.storage.set(
                value: configuration.pull.rawValue,
                mask: 0b11,
                offset: pin * 2
            )
        }

        // Comprised of 16 x 4 bit fields, split across 2 registers.
        if pin < 8 {
            self.afrl.modify { rw in
                rw.raw.storage.set(
                    value: configuration.alternateFunction,
                    mask: 0b1111,
                    offset: pin * 4
                )
            }
        } else {
            self.afrh.modify { rw in
                rw.raw.storage.set(
                    value: configuration.alternateFunction,
                    mask: 0b1111,
                    offset: (pin - 8) * 4
                )
            }
        }
    }
}
