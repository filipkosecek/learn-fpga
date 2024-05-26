YOSYS_TINYFPGA_BX_OPT=-DTINY -q -p "synth_ice40 -top $(PROJECTNAME) -json $(PROJECTNAME).json"
NEXTPNR_TINYFPGA_BX_OPT=--json $(PROJECTNAME).json --pcf BOARDS/tinyfpga_bx.pcf --asc $(PROJECTNAME).asc \
			--freq 16 --lp8k --package cm81

TINYFPGA_BX: TINYFPGA_BX.firmware_config TINYFPGA_BX.synth TINYFPGA_BX.prog

TINYFPGA_BX.synth:
	yosys $(YOSYS_TINYFPGA_BX_OPT) $(VERILOGS)
	nextpnr-ice40 $(NEXTPNR_TINYFPGA_BX_OPT)
	icetime -p BOARDS/tinyfpga_bx.pcf -P cm81 -r $(PROJECTNAME).timings -d lp8k -t $(PROJECTNAME).asc
	icepack -s $(PROJECTNAME).asc $(PROJECTNAME).bin

TINYFPGA_BX.prog:
	tinyprog -p $(PROJECTNAME).bin

TINYFPGA_BX.firmware_config:
	BOARD=tinyfpga TOOLS/make_config.sh -DTINY
	(cd FIRMWARE; make libs)
