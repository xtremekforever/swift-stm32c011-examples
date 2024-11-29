
# Defaults to release build
CONFIGURATION := release

# Determine file paths
PRJROOT := .
SRCROOT := $(PRJROOT)/Sources
BUILDROOT := $(PRJROOT)/.build/$(CONFIGURATION)

# Target and build flags
ARCH := armv6m
TARGET := $(ARCH)-none-none-eabi

# Tools and utilties
SWIFT_BUILD := swift build

OBJCOPY  = arm-none-eabi-objcopy
OBJDUMP  = arm-none-eabi-objdump
SIZE     = arm-none-eabi-size
DEMANGLE = swift demangle

.PHONY: all build link map lst size bin flash clean
all: build link lst map size bin
build:
	@echo "compiling (please be patient, this may take a few minutes)..."
	swift build \
		--configuration $(CONFIGURATION) \
		--swift-sdks-path ../stm32c011/SDKs \
		--swift-sdk stm32c0xx \
		$(EXTRA_FLAGS)

link:
	@echo "linking..."
	arm-none-eabi-gcc $(BUILDROOT)/libApplication.a -o $(BUILDROOT)/$(OUTPUT_NAME).elf \
		-mcpu=cortex-m0plus -mthumb -mfloat-abi=soft \
		-ffreestanding -fdata-sections -ffunction-sections -fno-builtin -fno-common -fshort-enums -std=gnu11 \
		--specs=nano.specs --specs=nosys.specs \
		-Wl,--gc-sections \
		-T../stm32c011/$(LINK_SCRIPT)

lst: $(BUILDROOT)/$(OUTPUT_NAME).elf
	@echo "Extracting lst file..."
	$(OBJDUMP) -S $^ | $(DEMANGLE) > $(BUILDROOT)/$(OUTPUT_NAME).lst

map: $(BUILDROOT)/$(OUTPUT_NAME).elf
	@echo "Extracting map file..."
	$(OBJDUMP) -t $^ | $(DEMANGLE) > $(BUILDROOT)/$(OUTPUT_NAME).map

size: $(BUILDROOT)/$(OUTPUT_NAME).elf
	@echo "Extracting & printing sizes..."
	$(SIZE) $^ -G > $(BUILDROOT)/$(OUTPUT_NAME).size
	@cat $(BUILDROOT)/$(OUTPUT_NAME).size

bin: $(BUILDROOT)/$(OUTPUT_NAME).elf
	@echo "Extracting bin file..."
	$(OBJCOPY) -O binary $^ $(BUILDROOT)/$(OUTPUT_NAME).bin
	@ls -alh $(BUILDROOT)/$(OUTPUT_NAME).bin

flash:
	@echo "Flashing STM32 at address 0x8000000..."
	@st-flash write $(BUILDROOT)/$(OUTPUT_NAME).bin 0x8000000

clean:
	@echo "cleaning..."
	@swift package clean
