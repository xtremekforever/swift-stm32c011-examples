
# Determine file paths
OUTPUT_NAME := blink
PRJROOT := .
SRCROOT := $(PRJROOT)/Sources
BUILDROOT := $(PRJROOT)/.build/release

# Target and build flags
ARCH := armv6m
TARGET := $(ARCH)-none-none-eabi

# Tools and utilties
SWIFT_BUILD := swift build

OBJCOPY  = arm-none-eabi-objcopy
OBJDUMP  = arm-none-eabi-objdump

.PHONY: all build map lst bin clean
all: build lst map bin
build:
	@echo "compiling..."
	swift build \
		--configuration release \
		--swift-sdks-path ../swift-sdks \
		--swift-sdk stm32c0xx \
		--verbose

	@echo "linking..."
	arm-none-eabi-gcc $(BUILDROOT)/libApplication.a -o $(BUILDROOT)/$(OUTPUT_NAME).elf \
		-mcpu=cortex-m0plus -mthumb -mfloat-abi=soft \
		-ffreestanding -fdata-sections -ffunction-sections -fno-builtin -fno-common -fshort-enums -std=gnu11 \
		--specs=nano.specs --specs=nosys.specs \
		-Wl,--gc-sections \
		-T$(SRCROOT)/Support/STM32C011F6.ld

lst: $(BUILDROOT)/$(OUTPUT_NAME).elf
	@echo "Extracting lst file..."
	$(OBJDUMP) -S $^ > $(BUILDROOT)/$(OUTPUT_NAME).lst

map: $(BUILDROOT)/$(OUTPUT_NAME).elf
	@echo "Extracting map file..."
	$(OBJDUMP) -t $^ > $(BUILDROOT)/$(OUTPUT_NAME).map

bin: $(BUILDROOT)/$(OUTPUT_NAME).elf
	@echo "Extracting bin file..."
	$(OBJCOPY) -O binary $^ $(BUILDROOT)/$(OUTPUT_NAME).bin
	ls -al $(BUILDROOT)/$(OUTPUT_NAME).bin

flash:
	@echo "Flashing STM32 at address 0x8000000..."
	@st-flash write $(BUILDROOT)/$(OUTPUT_NAME).bin 0x8000000

clean:
	@echo "cleaning..."
	@swift package clean
