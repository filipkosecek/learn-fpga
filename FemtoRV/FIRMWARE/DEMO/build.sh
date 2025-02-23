#!/bin/bash

LENGTH=1025
REGCOUNT=8
CHUNK=$(($REGCOUNT * 4))

replace_nops () {
	local INSTR_PARAM=$(($REGCOUNT - 1))
	local MULTICMP="8000${INSTR_PARAM}ec0"
	local BITMANIP="000e8550"
	sed "s/00000013/${MULTICMP}/;s/00000013/${BITMANIP}/g" main.hex > tmp.hex
	cat tmp.hex > ../firmware.hex
	rm tmp.hex
}

genstr () {
	local n=$1
	STR=""
	for ((i = 0; i < n; ++i)); do
		STR="${STR}a"
	done
	for i in {1..32}; do
		STR="${STR}\\0"
	done
	echo "volatile const char str[] = \"${STR}\";" > target_string.h
}

build () {
	rm -f main.hex
	make RVUSERCFLAGS="-DSTRINGA${LENGTH} -DSTRLEN_VECTORIZED${CHUNK}" main.hex
	replace_nops
}

if [[ $# -eq 2 ]]; then
	LENGTH=$1
	REGCOUNT=$2
	CHUNK=$(($REGCOUNT * 4))
fi
echo "String's length set to ${LENGTH}."
echo "Chunk size set to ${CHUNK}."

genstr $LENGTH
build

make -C ../../ BENCH.icarus
