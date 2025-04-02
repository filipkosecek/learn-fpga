#!/bin/bash

MAXLEN=20000
IS_RANDOM=
LENGTHS=(0 31 67 131 251 1022 2051 4056 8188 19871)
n=${#LENGTHS[@]}

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

get_random_length () {
	rand=$(shuf -i 0-20000 -n 1)
	echo $rand
	return $rand
}


if [[ $# -eq 2 ]]; then
	if [[ $1 != "-r" ]]; then
		echo "The only supported option is -r." 1>&2
		exit 1
	fi
	IS_RANDOM=r
	n=$2
fi

for ((j = 0; j < n; ++j)); do
	if [[ -z $IS_RANDOM ]]; then
		LENGTH=${LENGTHS[$j]}
	else
		LENGTH=$(shuf -i 0-20000 -n 1)
	fi
	genstr $LENGTH
	rm main.hex
	make RV_USERLIBS="multicmp.elf ctz.elf" RVUSERCFLAGS="-DBENCH" main.hex 1>/dev/null 2>/dev/null
	if [[ $LENGTH -lt 8000 ]]; then
		DURATION=500000
	elif [[ $LENGTH -lt 10000 ]]; then
		DURATION=800000
	else
		DURATION=1500000
	fi
	sed -i "s/DURATION=[1-9][0-9]*/DURATION=${DURATION}/" ../../BOARDS/bench.mk
	make -C ../../ BENCH.icarus
done
sed -i 's/DURATION=[1-9][0-9]*/DURATION=600000/' ../../BOARDS/bench.mk
