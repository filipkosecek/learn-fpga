#include <femtorv32.h>
#include <stdint.h>
#include <stddef.h>

#include "target.h"

#define ITERCOUNT 10000
#define LED 0x400004
volatile static uint32_t *led = LED;

static void test_strlen(void)
{
	volatile size_t len;
	for (size_t i = 0; i < ITERCOUNT; ++i) {
		len = strlen(str);
	}
}

int main(void)
{
	delay(500);
	for (;;) {
		putchar(getchar());
		test_strlen();
		putchar('#');
	}
	return 0;
}
