#include <femtorv32.h>
#include <stdint.h>
#include <stddef.h>

#include "multicmp.h"
#include "ctz.h"

volatile const char str[] = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\0\0\0\0\0\0\0\0";

int main(void)
{
	uint32_t x;
	size_t len = 0;
	while (1) {
		x = multicmp8(str + len, 0);
		if (x == 0)
			len += 8;
		else
			break;
	}
	len += ctz(x);
	print_dec((int) len);
	while (1);
	return 0;
}
