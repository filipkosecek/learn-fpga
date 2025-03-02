#!/bin/bash

LENGTH=1025
MAXREGCOUNT=8
REGCOUNT=8
CHUNK=$(($REGCOUNT * 4))

replace_nops () {
	local INSTR_PARAM=$(($REGCOUNT - 1))
	local MULTICMP="8000${INSTR_PARAM}ec0"
	local BITMANIP="000e8554"
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
	make RVUSERCFLAGS="-DSTRINGA${LENGTH} -DSTRLEN_VECTORIZED${CHUNK}" main.hex
	replace_nops
}

setup_CPU () {
	sed -i "s/\\(parameter SIMD_REG_COUNT = \\)\\([2-8]\\);/\\1${MAXREGCOUNT};/g" ../../RTL/PROCESSOR/femtorv32_quark_simd.v
}

ISRANDOM=
if [[ $# -lt 3 ]] || [[ $# -gt 4 ]]; then
	echo "Wrong argument count." 1>&2
	exit 1
else
	LENGTH=$1
	MAXREGCOUNT=$2
	REGCOUNT=$3
	CHUNK=$(($REGCOUNT * 4))
	if [[ $# -eq 4 ]]; then
		ISRANDOM=$4
	fi
fi
echo "String's length set to ${LENGTH}."
echo "Chunk size set to ${CHUNK}."

if [[ -n $ISRANDOM ]]; then
	genstr_rand $LENGTH
else
	genstr $LENGTH
fi

setup_CPU
build_program
make -C ../../ BENCH.icarus
