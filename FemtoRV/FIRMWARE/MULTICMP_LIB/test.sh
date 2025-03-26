#!/bin/bash

#LENGTHS=(0 31 67 131 251 1022 2051 4056 8188 19871)
LENGTHS=(19871)

genstr () {
	local n=$1
	STR=""
	for ((i = 0; i < n; ++i)); do
		STR="${STR} 0x61,"
	done
	for i in {1..32}; do
		STR="${STR} 0x00,"
	done
	echo "volatile const char str[] = {${STR}};" > target.h
}

for LENGTH in ${LENGTHS[@]}; do
	genstr $LENGTH
	rm main.hex
	make RV_USERLIBS="multicmp.elf ctz.elf" main.hex 1>/dev/null 2>/dev/null
	if [[ $LENGTHS -lt 10000 ]]; then
		DURATION=600000
	else
		DURATION=1200000
	fi
	sed -i "s/DURATION=[1-9][0-9]*/DURATION=${DURATION}/" ../../BOARDS/bench.mk
	make -C ../../ BENCH.icarus
done
