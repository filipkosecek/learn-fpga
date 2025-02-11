#include <femtorv32.h>
#include <stdint.h>
#include <femtostdlib.h>
#include "print_cycles.h"

static volatile uint32_t *const led = 0x400004;
static volatile const char str[] = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";

/*
 * first nop replacement: 01c3bec0
 * second nop replacement: 000e8550
 *
 * x10 - arg - string pointer/ return value
 * x31 - string pointer
 * x28 - explicit rs2 register
 * x5 - implicit rs3 register
 * x6 - implicit rs4 register
 * x7 - explicit rs1 register
 * x29 - ctz result storage
 * x30 - dummy register used for garbage values
 */
__attribute__((naked)) unsigned vector_strlen(const char *str) {
	asm volatile (
		"vector_strlen:\n\t"
		"addi x31, x10, 0\n\t"
		"lui x30, 0\n\t"
		"jal x5, loop\n\t"
		"inc:\n\t"
		"addi x30, x30, 16\n\t"
		"addi x31, x31, 16\n\t"
		"loop:\n\t"
		"lw x28, 0(x31)\n\t"
		"lw x5, 4(x31)\n\t"
		"lw x6, 8(x31)\n\t"
		"lw x7, 12(x31)\n\t"
		"nop\n\t"
		"beq x29, x0, inc\n\t"
		"nop\n\t"
		"ret:\n\t"
		"add x10, x10, x30\n\t"
		"jalr x30, x1, 0\n\t"
	);
}

#define VECTORIZED

int main(void)
{
	volatile unsigned i = 0;
	volatile uint64_t beg, end;
	beg = cycles();
#ifdef VECTORIZED
	i = vector_strlen(str);
#else
	for (i = 0; str[i] != 0; ++i);
#endif
	end = cycles();
	print_cycles(end - beg);
	print_length(i);
	while (1);
	return 0;
}
