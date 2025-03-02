#!/bin/bash

LENGTH=1025
MAXREGCOUNT=8
REGCOUNT=8
CHUNK=$(($REGCOUNT * 4))

replace_nops () {
	local INSTR_PARAM=$(($REGCOUNT - 1))
	local MULTICMP="8000${INSTR_PARAM}ec0"
	local BITMANIP="000e8554"
	sed -i -z "s/00000013/${MULTICMP}/" main.hex
	sed -i -z "s/00000013/${BITMANIP}/" main.hex
	cat main.hex > ../firmware.hex
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

genstr_rand () {
	echo -n "volatile const char str[] = {" > target_string.h
	head -c $1 /dev/urandom | xxd -i >> target_string.h
	# append a null byte in case there was no in the stream
	for i in {1..32}; do
		C_HEADER="${C_HEADER}, 0x00"
	done
	echo "${C_HEADER}};" >> target_string.h
}

build_program () {
	rm -f main.hex
	make RVUSERCFLAGS="-DSTRLEN_VECTORIZED${CHUNK}" main.hex
	replace_nops
}

setup_CPU () {
	sed -i "s/\\(parameter SIMD_REG_COUNT = \\)\\([2-8]\\);/\\1${MAXREGCOUNT};/g" ../../RTL/PROCESSOR/femtorv32_quark_simd.v
}

LENGTHS=(0 31 67 131 251 1022 2051 4056)
REGCOUNTS=(2 4 6 8)
ISRANDOM=
echo "String's length set to ${LENGTH}."
echo "Chunk size set to ${CHUNK}."
setup_CPU
for LENGTH in ${LENGTHS[@]}; do
	genstr $LENGTH
	for REGCOUNT in ${REGCOUNTS[@]}; do
		CHUNK=$(($REGCOUNT * 4))
		build_program
		make -sC ../../ BENCH.icarus
	done
done
