#include <femtorv32.h>
#include <stddef.h>

#define ITERCOUNT 10000

int main(void)
{
	delay(500);
	for (;;) {
		// start, ack
		putchar(getchar());

		// how long it takes to transmit two timestamps without any computation between
		for (size_t i = 0; i < ITERCOUNT; ++i) {
			putchar('#');
		}
	}

	return 0;
}
