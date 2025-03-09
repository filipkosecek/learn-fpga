#!/bin/bash

LENGTHS=(0 31 67 131 251 1022 2051 4056)
REGCOUNTS=(2 4 6 8)
LENGTH=1025
MAXREGCOUNT=8
REGCOUNT=8
CHUNK=$(($REGCOUNT * 4))
MAXLEN=8092

# String generation deterministic/random
genstr () {
	local n=$1
	STR=""
	for ((i = 0; i < n; ++i)); do
		STR="${STR} 0x61,"
	done
	for i in {2..32}; do
		STR="${STR} 0x00,"
	done
	echo "volatile const char str[] = {${STR}};" > target_string.h
}

setup_CPU () {
	sed -i "s/\\(parameter SIMD_REG_COUNT = \\)\\([2-8]\\);/\\1${MAXREGCOUNT};/g" ../../RTL/PROCESSOR/femtorv32_quark_simd.v
}

replace_nops () {
	local INSTR_PARAM=$(($REGCOUNT - 1))
	local MULTICMP="8000${INSTR_PARAM}ec0"
	local BITMANIP="000e8554"
	sed -i -z "s/00000013/${MULTICMP}/" main.hex
	sed -i -z "s/00000013/${BITMANIP}/" main.hex
	cat main.hex > ../firmware.hex
}

build_program () {
	local RVUSERCFLAGS=$1
	rm -f main.hex
	make RVUSERCFLAGS=$RVUSERCFLAGS main.hex > /dev/null 2>/dev/null
}

benchmark_basic () {
	LENGTH=$1
	REGCOUNT=$2
	CHUNK=$(($REGCOUNT * 4))
	setup_CPU
	genstr $LENGTH
	build_program "-DSTRLEN_VECTORIZED${CHUNK}"
	replace_nops
	make -sC ../../ BENCH.icarus 2>&1 | grep "Clock cycle count:\|String's length:"
}

benchmark () {
	for LENGTH in ${LENGTHS[@]}; do
		genstr $LENGTH

		echo "STRLEN NAIVE"
		echo "STRING SIZE: ${LENGTH}"
		build_program "-DSTRLEN_NAIVE"
		make -sC ../../ BENCH.icarus 2>&1 | grep "Clock cycle count:\|String's length:"
		echo

		echo "STRLEN LIBRARY"
		echo "STRING SIZE: ${LENGTH}"
		build_program "-DSTRLEN_LIB"
		make -sC ../../ BENCH.icarus 2>&1 | grep "Clock cycle count:\|String's length:"
		echo

		for REGCOUNT in ${REGCOUNTS[@]}; do
			CHUNK=$(($REGCOUNT * 4))
			echo "STRLEN VECTORIZED${CHUNK}"
			echo "STRING SIZE: ${LENGTH}"
			build_program "-DSTRLEN_VECTORIZED${CHUNK}"
			replace_nops
			make -sC ../../ BENCH.icarus 2>&1 | grep "Clock cycle count:\|String's length:"
			echo
		done
	done
}

if [[ $# -eq 2 ]]; then
	basic_test $1 $2
elif [[ $# -eq 0 ]] || [[ $# -eq 1 ]]; then
	if [[ $# -eq 1 ]]; then
		for (( j = 0; j < ${#LENGTHS[@]}; ++j )); do
			rand=$RANDOM
			while [[ $rand -lt 0 ]]; do
				rand=$RANDOM
			done
			LENGTHS[$j]=$((rand % MAXLEN))
		done
	fi
	benchmark
else
	echo "Wrong number of arguments." 1>&2
	exit 1
fi
