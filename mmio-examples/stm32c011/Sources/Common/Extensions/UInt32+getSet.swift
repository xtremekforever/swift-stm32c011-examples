extension UInt32 {
    func get(mask: Self, offset: UInt8) -> Self {
        let mask = mask &<< offset
        return (self & mask) &>> offset
    }

    mutating func set(value: Self, mask: Self, offset: Int) {
        let mask = mask &<< offset
        let oldValue: UInt32 = self & ~mask
        let newValue: UInt32 = (value &<< offset) & mask
        self = oldValue | newValue
    }
}
