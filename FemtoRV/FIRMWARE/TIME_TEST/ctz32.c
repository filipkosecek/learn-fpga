#include <femtorv32.h>
#include <stdint.h>
#include <stddef.h>

#include "multicmp.h"
#include "ctz.h"
#include "target.h"

#define ITERCOUNT 10000
#define LED 0x400004
volatile static uint32_t *led = LED;

static size_t test_mcmp32(void)
{
	size_t len;
	uint32_t x;

	for (size_t i = 0; i < ITERCOUNT; ++i) {
		len = 0;
		while (1) {
			x = multicmp32_imm0(str + len);
			if (x == 0)
				len += 32;
			else
				break;
		}
		len += ctz(x);
	}
	return len;
}

int main(void)
{
	size_t len;

	delay(500);
	for (;;) {
		// sync character
		putchar(getchar());

		len = test_mcmp32();
		putchar('#');

		// Verify the string's length calculation is correct
		if (len != (sizeof(str) - 32))
			printf("xx");
	}

	return 0;
}
