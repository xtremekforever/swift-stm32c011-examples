extension UnsafeMutablePointer where Pointee == UInt32 {
    func volatileLoad() -> Pointee {
        return volatile_load_uint32_t(self)
    }

    func volatileStore(_ value: Pointee) {
        volatile_store_uint32_t(self, value)
    }
}

enum RCC {
    static let BaseAddress = UnsafeMutablePointer<UInt32>(bitPattern: 0x40021000 as UInt)!
    enum Offsets {
        static let CR = 0x0
        static let ISRCFG = 0x4
        static let CFGR = 0x8
        static let RES1 = 0xc
        static let RES2 = 0xc10
        static let RES3 = 0x14
        static let CEIR = 0x18
        static let CIFR = 0x1C
        static let CICR = 0x20
        static let IOPRSTR = 0x24
        static let AHBRSTR = 0x28
        static let APBRSTR1 = 0x2C
        static let APBRSTR2 = 0x30
        static let IOPENR = 0x34
        static let AHBENR = 0x38
        static let APBENR1 = 0x3C
        static let APBENR2 = 0x40
        static let IOPSMENR = 0x44
        static let AHBSMENR = 0x48
        static let APBSMENR1 = 0x4C
        static let APBSMENR2 = 0x50
        static let CCIPR = 0x54
        static let RESERVED2 = 0x58
        static let CSR1 = 0x5C
        static let CSR2 = 0x60
    }
}

enum GPIO {
    static let GPIOa_BaseAddress = UnsafeMutablePointer<UInt32>(bitPattern: 0x50000000 as UInt)!
    static let GPIOb_BaseAddress = UnsafeMutablePointer<UInt32>(bitPattern: 0x50000400 as UInt)!
    static let GPIOc_BaseAddress = UnsafeMutablePointer<UInt32>(bitPattern: 0x50000800 as UInt)!
    static let GPIOf_BaseAddress = UnsafeMutablePointer<UInt32>(bitPattern: 0x50001400 as UInt)!

    enum Offsets {
        static let MODER = 0x0
        static let OTYPER = 0x4
        static let OSPEEDR = 0x8
        static let PUPDR = 0xc
        static let IDR = 0x10
        static let ODR = 0x14
        static let BSRR = 0x18
        static let LCKR = 0x1c
        static let AFRL = 0x20
        static let AFRH = 0x24
        static let BRR = 0x28
    }
}

func setRegisterBit(baseAddress: UnsafeMutablePointer<UInt32>, offset: Int, bit: Int, value: Int) {
    precondition(offset % 4 == 0)
    precondition(bit >= 0 && bit < 32)
    precondition(value >= 0 && value < 2)
    let p = baseAddress.advanced(by: offset / 4)
    let previousValue: UInt32 = p.volatileLoad()
    let newValue: UInt32 = previousValue & ~(1 << UInt32(bit)) | (UInt32(value) << UInt32(bit))
    p.volatileStore(newValue)
}

func setRegisterTwoBitField(baseAddress: UnsafeMutablePointer<UInt32>, offset: Int, bitsStartingAt: Int, value: Int) {
    precondition(offset % 4 == 0)
    precondition(bitsStartingAt >= 0 && bitsStartingAt < 16)
    precondition(value >= 0 && value < 4)
    let p = baseAddress.advanced(by: offset / 4)
    let previousValue: UInt32 = p.volatileLoad()
    let newValue: UInt32 = previousValue & ~(0b11 << UInt32(bitsStartingAt)) | (UInt32(value) << UInt32(bitsStartingAt))
    p.volatileStore(newValue)
}