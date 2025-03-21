# Configuration file for femtoRV32 firmware compilation
#
# Note: this file is getting much more complicated than I wished,
# but it makes life easier by automating different things.


#####################################################################
# Base directory of the firmware

FIRMWARE_DIR=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(FIRMWARE_DIR)/config.mk
DEVICES_ASM=$(subst -D,-defsym ,$(DEVICES))

show_config:
	@echo "ARCH=$(ARCH)"
	@echo "ABI=$(ABI)" 
	@echo "OPTIMIZE=$(OPTIMIZE)" 
	@echo "DEVICES=$(DEVICES)"
	@echo "DEVICES_ASM=$(DEVICES_ASM)"	

################################################################################

uname := $(shell uname)
uname_m := $(shell uname -m)

ifeq ($(uname),Darwin)
    $(info Configuring for Mac)
    TOOLCHAIN_WEB=https://github.com/xpack-dev-tools/riscv-none-embed-gcc-xpack/releases/download/v10.1.0-1.1
    TOOLCHAIN_VER=xpack-riscv-none-embed-gcc-10.1.0-1.1
    TOOLCHAIN_DL_SUFFIX=-darwin-x64
    TOOLCHAIN_GCC_VER=10.1.0
    RVTOOLCHAIN_BIN_PREFIX=riscv-none-embed
else
    ifeq ($(uname_m),aarch64)
        $(info Configuring for ARM64)
        TOOLCHAIN_WEB=https://github.com/xpack-dev-tools/riscv-none-embed-gcc-xpack/releases/download/v10.1.0-1.1
        TOOLCHAIN_VER=xpack-riscv-none-embed-gcc-10.1.0-1.1
        TOOLCHAIN_DL_SUFFIX=-linux-arm64
        TOOLCHAIN_GCC_VER=10.1.0
        RVTOOLCHAIN_BIN_PREFIX=riscv-none-embed
    else ifeq ($(uname_m),armv7l)
        $(info Configuring for Raspberry Pi)
        TOOLCHAIN_WEB=https://github.com/xpack-dev-tools/riscv-none-embed-gcc-xpack/releases/download/v8.3.0-2.3
        TOOLCHAIN_VER=xpack-riscv-none-embed-gcc-8.3.0-2.3
        TOOLCHAIN_DL_SUFFIX=-linux-arm
        TOOLCHAIN_GCC_VER=8.3.0
        RVTOOLCHAIN_BIN_PREFIX=riscv-none-embed
    else
        $(info Configuring for Linux x86_64)
        TOOLCHAIN_WEB=https://static.dev.sifive.com/dev-tools
        TOOLCHAIN_DL_SUFFIX=-x86_64-linux-ubuntu14
        TOOLCHAIN_VER=riscv64-unknown-elf-gcc-8.3.0-2020.04.0
        TOOLCHAIN_GCC_VER=8.3.0
        RVTOOLCHAIN_BIN_PREFIX=riscv64-unknown-elf
    endif
endif

RVTOOLCHAIN_DIR=$(FIRMWARE_DIR)/TOOLCHAIN/$(TOOLCHAIN_VER)$(TOOLCHAIN_DL_SUFFIX)
RVTOOLCHAIN_BIN_DIR=$(RVTOOLCHAIN_DIR)/bin

RVTOOLCHAIN_LIB_DIR=$(RVTOOLCHAIN_DIR)/$(RVTOOLCHAIN_BIN_PREFIX)/lib/$(ARCH)/$(ABI)
RVTOOLCHAIN_GCC_LIB_DIR=$(RVTOOLCHAIN_DIR)/lib/gcc/$(RVTOOLCHAIN_BIN_PREFIX)/$(TOOLCHAIN_GCC_VER)/$(ARCH)/$(ABI)

RVAS=$(RVTOOLCHAIN_BIN_DIR)/$(RVTOOLCHAIN_BIN_PREFIX)-as
RVLD=$(RVTOOLCHAIN_BIN_DIR)/$(RVTOOLCHAIN_BIN_PREFIX)-ld
RVOBJCOPY=$(RVTOOLCHAIN_BIN_DIR)/$(RVTOOLCHAIN_BIN_PREFIX)-objcopy
RVOBJDUMP=$(RVTOOLCHAIN_BIN_DIR)/$(RVTOOLCHAIN_BIN_PREFIX)-objdump
RVGCC=$(RVTOOLCHAIN_BIN_DIR)/$(RVTOOLCHAIN_BIN_PREFIX)-gcc
RVGPP=$(RVTOOLCHAIN_BIN_DIR)/$(RVTOOLCHAIN_BIN_PREFIX)-g++
RVAR=$(RVTOOLCHAIN_BIN_DIR)/$(RVTOOLCHAIN_BIN_PREFIX)-ar
RVRANLIB=$(RVTOOLCHAIN_BIN_DIR)/$(RVTOOLCHAIN_BIN_PREFIX)-ranlib

RV_BINARIES=$(RVAS) $(RVLD) $(RVOBJCOPY) $(RVOBJDUMP) $(RVGCC) \
            $(RVAR) $(RVRANLIB)

# Note: it is also possible to comment this line, and use replacement functions
# for a small subset of libc, see comments in LIBFEMTOC/Makefile. 
RVGCC_LIB= $(RVTOOLCHAIN_LIB_DIR)/libc.a \
           $(RVTOOLCHAIN_LIB_DIR)/libm.a \
	   $(RVTOOLCHAIN_GCC_LIB_DIR)/libgcc.a

# My utility that converts elf executables into a format understood by Verilog
FIRMWARE_WORDS=$(FIRMWARE_DIR)/TOOLS/firmware_words

ifeq ($(BOARD),icesugar_nano)
    TOOLCHAIN_PROG_CMD=icesprog -o 0x20000 
else
    ifeq ($(BOARD),ice40hx8k_evb)
        TOOLCHAIN_PROG_CMD=iceprogduino -o 0x30000
    else
        TOOLCHAIN_PROG_CMD=iceprog -o 128k
    endif
endif

################################################################################

RVINCS=-I$(FIRMWARE_DIR)/LIBFEMTOGL -I$(FIRMWARE_DIR)/LIBFEMTORV32 -I$(FIRMWARE_DIR)/LIBFEMTOC
RVCFLAGS=$(OPTIMIZE) $(RVINCS) $(DEVICES) -fno-pic -march=$(ARCH) -mabi=$(ABI) \
         -fno-stack-protector -w -Wl,--no-relax 
        # Note: --no-relax because I'm using gp for fast access to mapped IO.
RVASFLAGS=-march=$(ARCH) -mabi=$(ABI) $(DEVICES_ASM) $(RVINCS)
RVLDFLAGS=-m elf32lriscv -b elf32-littleriscv --no-relax --print-memory-usage
RVCPPFLAGS=-fno-exceptions -fno-enforce-eh-specs

#Rule to compile C objects
.c.o: $< $(RV_BINARIES)
	$(RVGCC) $(RVCFLAGS) $(RVUSERCFLAGS) -c $<

#Rule to compile C++ objects
.cpp.o: $< $(RV_BINARIES)
	$(RVGPP) $(RVCFLAGS) $(RVUSERCFLAGS) $(RVCPPFLAGS) -c $<

#Rule to compile ASM objects
.S.o: $< $(RV_BINARIES)
	$(RVAS) $(RVASFLAGS) $(RVUSERASFLAGS) $< -o $@ 

# Libraries to link with standard executables
FEMTORV32_LIBS=$(FIRMWARE_DIR)/CRT/syscalls.o \
	       -L$(RVTOOLCHAIN_LIB_DIR)\
               -L$(FIRMWARE_DIR)/CRT\
	       -L$(FIRMWARE_DIR)/LIBFEMTOGL\
	       -L$(FIRMWARE_DIR)/LIBFEMTORV32\
	       -L$(FIRMWARE_DIR)/LIBFEMTOC\
   	       -lfemtoGL -lfemtorv32 -lfemtoc -lm 

# Libraries to link with small executable 
# (e.g., ".hex" memory image for IceStick)
FEMTORV32_LIBS_SMALL=-L$(RVTOOLCHAIN_LIB_DIR)\
                     -L$(FIRMWARE_DIR)/CRT\
 	             -L$(FIRMWARE_DIR)/LIBFEMTOGL\
	             -L$(FIRMWARE_DIR)/LIBFEMTORV32\
	             -L$(FIRMWARE_DIR)/LIBFEMTOC\
   	             -lfemtoGL -lfemtorv32 -lfemtoc 

# Generate a "bare metal elf", to be loaded from address 0 (rule for conversion to .hex file in makefile.inc)
# The generated ".hex" file is directly included in the Verilog files, for memory initialization
%.baremetal.elf: %.o $(RV_BINARIES)
	$(RVLD) $(RVLDFLAGS) -T$(FIRMWARE_DIR)/CRT/baremetal.ld $< -o $@ $(FEMTORV32_LIBS_SMALL) $(RVGCC_LIB)

# Generate a "femtOS elf executable", to be loaded from address 0x10000 (rule for conversion to .bin file in makefile.inc)
%.elf: %.o $(RV_BINARIES)
	$(RVGPP) $(RVCFLAGS) $(RVCPPFLAGS) -nostdlib $< -o $@ -Wl,-gc-sections $(FEMTORV32_LIBS) -lsupc++ $(RVGCC_LIB) $(FIRMWARE_DIR)/CRT/crt0_baremetal.o

# Generate a "spi elf", to be loaded from address 0x810000 
%.spiflash.elf: %.o $(RV_BINARIES) 
	$(RVLD) $(RVLDFLAGS) -T$(FIRMWARE_DIR)/CRT/spiflash_$(BOARD).ld $< -o $@ $(FEMTORV32_LIBS) -lsupc++ $(RVGCC_LIB)

# Converts the ELF executable to flat binary form, ready to be sent to SPI flash.
%.spiflash.bin: %.spiflash.elf
	$(RVOBJCOPY) $< $@ -O binary

# Sends the generated executable in flat binary form to SPI flash
%.prog: %.spiflash.bin
	$(TOOLCHAIN_PROG_CMD) $<

# Generate a disassembly (for inspection if need be)
%.list: %.baremetal.elf
	$(RVOBJDUMP) -Mnumeric -D $< > $@

#Rule to convert a .elf executable into a .hex file for verilog 'readmemh()'
# command, using my 'firmware_words' utility to parse the .elf executable.
# It is used for "bare metal" executables, compiled with linker script,
# starting at address 0 (firmware for IceStick, or femtOS commander.c for ULX3S)
# max_addr is set to 64k, because standard elf are meant to be run from 64k offset
# (then on the ULX3S, there is room for both femtOS in the first 64ks and the loaded
#  user executable)

%.hex: %.baremetal.elf $(FIRMWARE_DIR)/TOOLS/firmware_words 
	$(FIRMWARE_DIR)/TOOLS/firmware_words $< -ram $(RAM_SIZE) -max_addr 65535 -out $@
	cp $@ $(FIRMWARE_DIR)/firmware.hex
	echo $@ > $(FIRMWARE_DIR)/firmware.txt

################################################################################
.PHONY: root clean all get_riscv_toolchain

root: all

clean:
	rm -f *.o *.elf *.hex *.exe *~ *.a *.bin *.list

#Generating the conversion utility for hex files

FIRMWARE_WORDS_SRC= $(FIRMWARE_DIR)/TOOLS/FIRMWARE_WORDS_SRC/firmware_words.cpp\
                    $(FIRMWARE_DIR)/LIBFEMTORV32/femto_elf.c
		    
$(FIRMWARE_DIR)/TOOLS/firmware_words: $(FIRWARE_WORDS_SRC)
	g++ -I$(FIRMWARE_DIR)/LIBFEMTORV32 -DSTANDALONE_FEMTOELF $(FIRMWARE_WORDS_SRC) -o $@

################################################################################
#RISCV toolchain, get it from the web, automatically

$(RVAS):
	make get_riscv_toolchain

$(RVLD):
	make get_riscv_toolchain

$(RVOBJCOPY):
	make get_riscv_toolchain

$(RVOBJDUMP):
	make get_riscv_toolchain

$(RVGCC):
	make get_riscv_toolchain

$(RVAR):
	make get_riscv_toolchain

$(RVRANLIB):
	make get_riscv_toolchain

get_riscv_toolchain:
	mkdir -p $(FIRMWARE_DIR)/TOOLCHAIN
	@echo "Installing RISC-V toolchain for $(uname) $(uname_m) in $(FIRMWARE_DIR)/TOOLCHAIN"
	(cd $(FIRMWARE_DIR)/TOOLCHAIN; \
	    wget $(TOOLCHAIN_WEB)/$(TOOLCHAIN_VER)$(TOOLCHAIN_DL_SUFFIX).tar.gz -O \
	        $(TOOLCHAIN_VER)$(TOOLCHAIN_DL_SUFFIX).tar.gz; \
	    tar xfz $(TOOLCHAIN_VER)$(TOOLCHAIN_DL_SUFFIX).tar.gz; \
	    if [ -d $(TOOLCHAIN_VER) ]; then mv $(TOOLCHAIN_VER) $(TOOLCHAIN_VER)$(TOOLCHAIN_DL_SUFFIX); fi)
