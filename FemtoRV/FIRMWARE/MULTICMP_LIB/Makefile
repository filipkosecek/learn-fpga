include ../makefile.inc

ASFLAGS=-march=rv32i -mabi=ilp32

multicmp.elf: multicmp.S
	$(RVAS) $(ASFLAGS) $< -o $@
	xxd multicmp.elf multicmp.hex
#	for i in {0..7}; do sed -i -z "s/1300 0000/0005 9550/" multicmp.hex; done
	for i in {0..7}; do sed -i -z "s/1300 0000/5095 0500/" multicmp.hex; done
	xxd -r multicmp.hex multicmp.elf

ctz.elf: ctz.S
	$(RVAS) $(ASFLAGS) $< -o $@
	xxd ctz.elf ctz.hex
#	sed -i -z "s/1300 0000/5485 0e00/" ctz.hex
#	sed -i -z "s/1300 0000/0005 0554/" ctz.hex
	sed -i -z "s/1300 0000/5405 0500/" ctz.hex
	xxd -r ctz.hex ctz.elf
