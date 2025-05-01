include ../makefile.inc

REPLACEMENTS=(00058550 00059550 0005a550 0005b550 0005c550 0005d550 0005e550 0005f550)

ASFLAGS=-march=rv32i -mabi=ilp32

all: $(RVGCC) libmulticmp.a

multicmp.elf: multicmp.S
	$(RVGCC) -E -o multicmp_preprocessed.S $<
	$(RVAS) $(ASFLAGS) multicmp_preprocessed.S -o $@
	rm multicmp_preprocessed.S
	xxd multicmp.elf multicmp.hex
	python3 replace_nops.py < multicmp.hex | xxd -r > multicmp.elf
	rm -f multicmp.hex

ctz.elf: ctz.S
	$(RVAS) $(ASFLAGS) $< -o $@
	xxd ctz.elf ctz.hex
#	sed -i -z "s/1300 0000/0005 0554/" ctz.hex
	sed -i -z "s/1300 0000/5405 0500/" ctz.hex
	xxd -r ctz.hex ctz.elf

libmulticmp.a: multicmp.elf ctz.elf
	ar rcs $@ $^
