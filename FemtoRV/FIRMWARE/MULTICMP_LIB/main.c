#include <femtorv32.h>
#include <stdint.h>
#include <stddef.h>

#include "multicmp.h"
#include "ctz.h"

#define mcmp(multicmp_func, block_size) \
	size_t len = 0; \
	uint32_t x; \
	while (1) { \
		x = (multicmp_func)(str + len); \
		if (x == 0) \
			len += (block_size); \
		else \
			break; \
	} \
	len += ctz(x); \
	print_dec((int) len); \
	putchar('\n');


volatile const char str[] = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";

void test_mcmp4(void)
{
	mcmp(multicmp4_imm0, 4)
}

void test_mcmp8(void)
{
	mcmp(multicmp8_imm0, 8)
}

void test_mcmp12(void)
{
	mcmp(multicmp12_imm0, 12)
}

void test_mcmp16(void)
{
	mcmp(multicmp16_imm0, 16)
}

void test_mcmp20(void)
{
	mcmp(multicmp20_imm0, 20)
}

void test_mcmp24(void)
{
	mcmp(multicmp24_imm0, 24)
}

void test_mcmp28(void)
{
	mcmp(multicmp28_imm0, 28)
}

void test_mcmp32(void)
{
	mcmp(multicmp32_imm0, 32)
}

int main(void)
{
	test_mcmp4();
	test_mcmp8();
	test_mcmp12();
	test_mcmp16();
	test_mcmp20();
	test_mcmp24();
	test_mcmp28();
	test_mcmp32();
	while (1);
	return 0;
}
