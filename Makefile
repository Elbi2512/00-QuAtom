CLANG ?= clang
OBJCOPY ?= $(or \
	$(shell command -v llvm-objcopy 2>/dev/null), \
	$(shell command -v llvm-objcopy-18 2>/dev/null), \
	$(shell command -v llvm-objcopy-17 2>/dev/null), \
	$(shell command -v llvm-objcopy-16 2>/dev/null))

BUILD_DIR := build
SRC_DIR := src
LINKER_SCRIPT := linker.ld
IMAGE := kernel8.img
ELF := $(BUILD_DIR)/kernel8.elf
MAP := $(BUILD_DIR)/kernel8.map

SRCS := $(SRC_DIR)/boot.S $(SRC_DIR)/main.c
OBJS := $(SRCS:$(SRC_DIR)/%=$(BUILD_DIR)/%)
OBJS := $(OBJS:.S=.o)
OBJS := $(OBJS:.c=.o)

CFLAGS := --target=aarch64-none-elf -mcpu=cortex-a53 -ffreestanding -fno-builtin -fno-stack-protector -Wall -Wextra -MMD -MP
LDFLAGS := --target=aarch64-none-elf -nostdlib -fuse-ld=lld -Wl,-T,$(LINKER_SCRIPT) -Wl,-Map,$(MAP)

ifeq ($(strip $(OBJCOPY)),)
$(error Unable to find llvm-objcopy. Install llvm-objcopy or invoke make with OBJCOPY=/path/to/llvm-objcopy)
endif

.PHONY: all clean

all: $(IMAGE)

$(IMAGE): $(ELF)
	$(OBJCOPY) -O binary $< $@

$(ELF): $(OBJS) $(LINKER_SCRIPT)
	@mkdir -p $(BUILD_DIR)
	$(CLANG) $(LDFLAGS) $(OBJS) -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.S
	@mkdir -p $(dir $@)
	$(CLANG) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CLANG) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR) $(IMAGE)

-include $(OBJS:.o=.d)
