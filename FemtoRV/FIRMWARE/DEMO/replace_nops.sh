#!/bin/bash

MULTICMP="01c3bec0"
BITMANIP="000e8550"

sed "s/00000013/${MULTICMP}/;s/00000013/${BITMANIP}/g" main.hex > tmp.hex
cat tmp.hex > ../firmware.hex
rm tmp.hex
