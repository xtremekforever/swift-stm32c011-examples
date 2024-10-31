extension ADC {
    enum ClockMode: UInt32 {
        case adcClk = 0x0
        case pclkDiv2 = 0x1
        case pclkDiv4 = 0x2
        case pclk = 0x3
    }

    enum Resolution: UInt32 {
        case bits12 = 0x0
        case bits10 = 0x1
        case bits8 = 0x2
        case bits6 = 0x3
    }

    enum DataAlignment: UInt32 {
        case right = 0x0
        case left = 0x1
    }

    enum ScanDirection: UInt32 {
        case upward = 0x0
        case backward = 0x1
    }

    enum OverrunMode: UInt32 {
        case preserved = 0x0
        case overwritten = 0x1
    }

    enum ExternalTriggerEdge: UInt32 {
        case disabled = 0x0
        case rising = 0x1
        case falling = 0x2
        case risingAndFalling = 0x3
    }

    enum ExternalTrigger: UInt32 {
        /// Software Trigger
        case trg0 = 0x0
        case trg1 = 0x1
        case trg2 = 0x2
        case trg3 = 0x3
        case trg4 = 0x4
        case trg5 = 0x5
        case trg6 = 0x6
        case trg7 = 0x7
    }

    enum EnableDisable: UInt32 {
        case disabled = 0x0
        case enabled = 0x1
    }

    struct Configuration {
        // CFGR1
        var scanDirection: ScanDirection = .upward
        var resolution: Resolution
        var dataAlignment: DataAlignment = .right
        var externalTrigger: ExternalTrigger = .trg0
        var externalTriggerEdge: ExternalTriggerEdge = .disabled
        var overrunMode: OverrunMode = .preserved
        var continuousMode: EnableDisable = .disabled
        var waitConversionMode: EnableDisable = .disabled
        var autoOffMode: EnableDisable = .disabled
        var discontinuousMode: EnableDisable = .disabled

        // CFGR2
        var oversamplingMode: EnableDisable = .disabled
        var lowFrequencyTrigger: EnableDisable = .disabled
        var clockMode: ClockMode
    }

    enum SamplingTime: UInt32 {
        case cycle1_5 = 0x0
        case cycle3_5 = 0x1
        case cycle7_5 = 0x2
        case cycle12_5 = 0x3
        case cycle19_5 = 0x4
        case cycle39_5 = 0x5
        case cycle79_5 = 0x6
        case cycle106_5 = 0x7
    }

    func enable() {
        // Enable ADC
        self.cr.modify { rw in
            rw.raw.aden = 1
        }

        while self.cr.read().raw.aden != 1 {
            // wait for ADC to be enabled/disabled
        }
    }

    func disable() {
        // Disable ADC
        self.cr.modify { rw in
            rw.raw.addis = 1
        }
    }

    func start() {
        // Start conversion
        self.cr.modify { rw in
            rw.raw.adstart = 1
        }
    }

    func getValue() -> UInt32 {
        // Wait for conversion complete
        while self.isr.read().raw.eoc != 1 {
        }

        // Return value
        return self.dr.read().raw.data
    }

    func configure(as configuration: Configuration) {
        self.cfgr1.modify { rw in
            rw.raw.scandir = configuration.scanDirection.rawValue
            rw.raw.res = configuration.resolution.rawValue
            rw.raw.align = configuration.dataAlignment.rawValue
            rw.raw.extsel = configuration.externalTrigger.rawValue
            rw.raw.extsel = configuration.externalTriggerEdge.rawValue
            rw.raw.ovrmod = configuration.overrunMode.rawValue
            rw.raw.cont = configuration.continuousMode.rawValue
            rw.raw.wait = configuration.waitConversionMode.rawValue
            rw.raw.autoff = configuration.autoOffMode.rawValue
            rw.raw.discen = configuration.discontinuousMode.rawValue
        }

        self.cfgr2.modify { rw in
            rw.raw.ovse = configuration.oversamplingMode.rawValue
            rw.raw.lftrig = configuration.lowFrequencyTrigger.rawValue
            rw.raw.ckmode = configuration.clockMode.rawValue
        }
    }

    func calibrate(calibrationCount: Int = 8) {
        // Put ADC into correct state
        self.cr.modify { rw in
            rw.raw.aden = 0
            rw.raw.advregen = 1  // enable internval voltage regulator
        }
        self.cfgr1.modify { rw in
            rw.raw.autoff = 0
            rw.raw.dmaen = 0
        }

        var calibrationAccumulated: UInt32 = 0
        for _ in 0..<calibrationCount {
            // Start calibration
            self.cr.modify { rw in
                rw.raw.adcal = 1
            }

            // Wait for calibration to complete
            var waitLoopIndex = 0
            let adcCalibrationTimeout = 178176
            while self.cr.read().raw.adcal != 0 {
                waitLoopIndex += 1
                if waitLoopIndex >= adcCalibrationTimeout {
                    break
                }
            }

            calibrationAccumulated += self.calfact.read().raw.calfact_field
        }

        calibrationAccumulated /= UInt32(calibrationCount)

        // We have to enable the ADC before setting calibration factor
        self.enable()

        // Set calibration factor
        self.calfact.modify { rw in
            rw.raw.calfact_field = calibrationAccumulated
        }

        // Disable when done
        self.disable()
    }

    func configureChannel(channel: Int, samplingTime: SamplingTime) {
        // Set channel selection
        self.chselr0.modify { rw in
            rw.raw.storage.set(
                value: 1,
                mask: 0b1,
                offset: channel
            )
        }

        // Set sample frequency
        self.smpr.modify { rw in
            rw.raw.smp1 = samplingTime.rawValue
        }
    }
}
