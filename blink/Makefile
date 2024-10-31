# Determine file paths
SRCROOT := .
BUILDROOT := $(SRCROOT)/.build

# Compilers and tools
OBJCOPY  = arm-none-eabi-objcopy
OBJDUMP  = arm-none-eabi-objdump

# Target and build flags
TARGET := armv6m-none-none-eabi
CPU_FLAGS := -mcpu=cortex-m0plus -mthumb -mfloat-abi=soft
COMMON_FLAGS := -ffreestanding -fdata-sections -ffunction-sections -fno-builtin -fno-common -fshort-enums -std=gnu11

SWIFT_EXEC := swiftc
SWIFT_FLAGS := -target $(TARGET) -Osize -import-bridging-header $(SRCROOT)/BridgingHeader.h -wmo -enable-experimental-feature Embedded -Xcc -ffreestanding -Xfrontend -function-sections -Xcc -mcpu=cortex-m0plus -Xcc -mfloat-abi=soft -Xcc -mthumb -Xcc -fshort-enums

CLANG_EXEC := clang
CLANG_FLAGS := -target $(TARGET) -Os $(CPU_FLAGS) $(COMMON_FLAGS)

# /usr/bin/ld.gold: fatal error: .build/blink.o: unsupported ELF machine number 40
#LD_EXEC := $(CLANG_EXEC)
#LD_FLAGS := --target=$(TARGET) -nostdlib -static -Wl,-gc-sections -Wl,-T,$(SRCROOT)/STM32C011F6.ld

# ld.lld: error: undefined symbol: __aeabi_lmul
#LD_EXEC := $(CLANG_EXEC)
#LD_FLAGS := --target=$(TARGET) -fuse-ld=lld -nostdlib -static -Wl,-gc-sections -Wl,-T,$(SRCROOT)/STM32C011F6.ld

# This works fine
LD_EXEC := arm-none-eabi-gcc
LD_FLAGS := -Wl,--gc-sections -T$(SRCROOT)/STM32C011F6.ld $(CPU_FLAGS) $(COMMON_FLAGS) --specs=nano.specs --specs=nosys.specs

.PHONY: all flash
all: $(BUILDROOT)/blink.bin $(BUILDROOT)/blink.lst $(BUILDROOT)/blink.map
clean:
	rm -rf $(BUILDROOT)/*

$(BUILDROOT):
	# Create build directory
	mkdir -p $(BUILDROOT)

$(BUILDROOT)/blink.o: $(SRCROOT)/*.swift | $(BUILDROOT)
	# Build Swift sources
	$(SWIFT_EXEC) $(SWIFT_FLAGS) -c $^ -o $@

$(BUILDROOT)/Startup.o: $(SRCROOT)/Startup.c | $(BUILDROOT)
	# Build C sources
	$(CLANG_EXEC) $(CLANG_FLAGS) -c $^ -o $@

$(BUILDROOT)/blink.elf: $(BUILDROOT)/blink.o $(BUILDROOT)/Startup.o
	# Link objects into executable
	$(LD_EXEC) $(LD_FLAGS) $^ -o $@

$(BUILDROOT)/blink.lst: $(BUILDROOT)/blink.elf
	# Export decompiled asm from executable
	$(OBJDUMP) -S $^ > $(BUILDROOT)/blink.lst

$(BUILDROOT)/blink.map: $(BUILDROOT)/blink.elf
	# Export memory map of executable
	$(OBJDUMP) -t $^ > $(BUILDROOT)/blink.map

$(BUILDROOT)/blink.bin: $(BUILDROOT)/blink.elf
	# Extract sections from executable into flashable binary
	$(OBJCOPY) -O binary $^ $@
	# Echo final binary path
	ls -al $(BUILDROOT)/blink.bin

flash:
	@echo "Flashing STM32 at address 0x8000000..."
	@st-flash write $(BUILDROOT)/blink.bin 0x8000000
