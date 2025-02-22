#!/bin/bash

LENGTH=1024

STRING=$(head -c $LENGTH /dev/urandom | xxd -i)
# append a null byte in case there was no in the stream
C_HEADER="const char str[] = {${STRING}"
for i in {1..32}; do
	C_HEADER="${C_HEADER}, 0x00"
done
echo "${C_HEADER}};"
