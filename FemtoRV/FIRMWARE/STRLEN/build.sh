#!/bin/bash

LENGTHS=(0 31 67 131 251 1022 2051 4056)
REGCOUNTS=(2 4 6 8)
LENGTH=1025
MAXREGCOUNT=8
REGCOUNT=8
CHUNK=$(($REGCOUNT * 4))
ISRANDOM=

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

genstr_rand () {
	echo -n "volatile const char str[] = {" > target_string.h
	head -c $1 /dev/urandom | xxd -i >> target_string.h
	# append a null byte in case there was no in the stream
	for i in {1..32}; do
		C_HEADER="${C_HEADER}, 0x00"
	done
	echo "${C_HEADER}};" >> target_string.h
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

build_vectorized_program () {
	rm -f main.hex
	make RVUSERCFLAGS="-DSTRLEN_VECTORIZED${CHUNK}" main.hex > /dev/null 2>/dev/null
	replace_nops
}

benchmark_vectorized () {
	echo "/***************************************/"
	echo "Testing vectorized strlen implementation."
	echo "/***************************************/"
	echo "String's length set to ${LENGTH}."
	echo "Chunk size set to ${CHUNK}."
	setup_CPU
	for LENGTH in ${LENGTHS[@]}; do
		genstr $LENGTH
		for REGCOUNT in ${REGCOUNTS[@]}; do
			CHUNK=$(($REGCOUNT * 4))
			build_vectorized_program
			make -sC ../../ BENCH.icarus | grep "Clock cycle count:\|String's length:"
		done
	done
}

benchmark_basic () {
	LENGTH=$1
	REGCOUNT=$2
	CHUNK=$(($REGCOUNT * 4))
	setup_CPU
	genstr $LENGTH
	build_vectorized_program
	make -sC ../../ BENCH.icarus
}

benchmark_std () {
	echo "/**********************************/"
	echo "Testing naive strlen implementation."
	echo "/**********************************/"
	for LENGTH in ${LENGTHS[@]}; do
		genstr $LENGTH
		rm main.hex
		make RVUSERCFLAGS="-DSTRLEN_NAIVE" main.hex > /dev/null
		make -sC ../../ BENCH.icarus | grep "Clock cycle count:\|String's length:"
	done

	echo "/************************************/"
	echo "Testing library strlen implementation."
	echo "/************************************/"
	for LENGTH in ${LENGTHS[@]}; do
		genstr $LENGTH
		rm main.hex
		make -s RVUSERCFLAGS="-DSTRLEN_LIB" main.hex
		make -sC ../../ BENCH.icarus
	done
}

if [[ $# -eq 2 ]]; then
	basic_test $1 $2
elif [[ $# -eq 0 ]]; then
	benchmark_std
	benchmark_vectorized
else
	echo "Wrong number of arguments." 1>&2
	exit 1
fi
