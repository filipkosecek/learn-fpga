include ../makefile.inc

REPLACEMENTS=(00058550 00059550 0005a550 0005b550 0005c550 0005d550 0005e550 0005f550)

ASFLAGS=-march=rv32i -mabi=ilp32

multicmp.elf: multicmp.S
	$(RVAS) $(ASFLAGS) $< -o $@
#	xxd multicmp.elf multicmp.hex
#	for i in {0..7}; do sed -i -z "s/1300 0000/0005 9550/" multicmp.hex; done
#	for i in {0..7}; do sed -z "s/1300 0000/5095 0500/" multicmp.hex > tmi; done
#	xxd -r multicmp.hex multicmp.elf

ctz.elf: ctz.S
	$(RVAS) $(ASFLAGS) $< -o $@
	xxd ctz.elf ctz.hex
#	sed -i -z "s/1300 0000/0005 0554/" ctz.hex
	sed -i -z "s/1300 0000/5405 0500/" ctz.hex
	xxd -r ctz.hex ctz.elf
