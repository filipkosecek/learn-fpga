#include <femtorv32.h>
#include <stdint.h>
#include <stddef.h>

#include "multicmp.h"
#include "ctz.h"
#include "target.h"

#define mcmp(multicmp_func, block_size) \
	size_t len = 0; \
	uint32_t x; \
	uint64_t beg, end; \
	beg = cycles(); \
	while (1) { \
		x = (multicmp_func)(str + len); \
		if (x == 0) \
			len += (block_size); \
		else \
			break; \
	} \
	len += ctz(x); \
	end = cycles(); \
	print_result(len, end - beg);

static print_result(int length, int cycle_count)
{
	printf("String length: %d\r\n", length);
	printf("Cycle count: %d\r\n", cycle_count);
	putchar('\r');
	putchar('\n');
}

static void test_mcmp4(void)
{
	puts("MULTICMP4");
	mcmp(multicmp4_imm0, 4)
}

static void test_mcmp8(void)
{
	puts("MULTICMP8");
	mcmp(multicmp8_imm0, 8)
}

static void test_mcmp12(void)
{
	puts("MULTICMP12");
	mcmp(multicmp12_imm0, 12)
}

static void test_mcmp16(void)
{
	puts("MULTICMP16");
	mcmp(multicmp16_imm0, 16)
}

static void test_mcmp20(void)
{
	puts("MULTICMP20");
	mcmp(multicmp20_imm0, 20)
}

static void test_mcmp24(void)
{
	puts("MULTICMP24");
	mcmp(multicmp24_imm0, 24)
}

static void test_mcmp28(void)
{
	puts("MULTICMP28");
	mcmp(multicmp28_imm0, 28)
}

static void test_mcmp32(void)
{
	puts("MULTICMP32");
	mcmp(multicmp32_imm0, 32)
}

static void test_strlen(void)
{
	uint64_t beg, end;
	size_t len;
	beg = cycles();
	len = strlen(str);
	end = cycles();
	puts("STRLEN");
	print_result(len, end - beg);
}

int main(void)
{
	test_strlen();
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
