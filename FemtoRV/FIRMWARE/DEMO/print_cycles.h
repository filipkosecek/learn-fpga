#include <femtorv32.h>

void print_cycles(uint64_t cycle_count)
{
        print_string("Clock cycle count: ");
        print_dec(cycle_count);
        putchar('\n');
}

void print_length(unsigned length)
{
	print_string("String's length: ");
	print_dec(length);
	putchar('\n');
}
