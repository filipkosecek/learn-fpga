#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "Supply the string's length." 1>&2
	exit 1
fi

echo -n "volatile const char str[] = {"
for (( i = 0; i < $1; ++i )); do
	echo -n ' 0x61,'
done
for i in {1..32}; do
	echo -n ' 0x00,'
done
echo "};"
