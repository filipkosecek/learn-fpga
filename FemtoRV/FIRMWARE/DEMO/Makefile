include ../makefile.inc

.PHONY: test

target_string.h:
	./gen_string.sh > $@

test_vectorized: target_string.h
	rm -f main.hex
	make main.hex
	./replace_nops.sh

test_normal: target_string.h
	rm -f main.hex
	make main.hex
