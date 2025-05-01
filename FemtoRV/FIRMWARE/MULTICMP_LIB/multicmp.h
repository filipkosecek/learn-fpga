#include <stdint.h>

uint32_t multicmp4_imm0(const void *mem);
uint32_t multicmp8_imm0(const void *mem);
uint32_t multicmp12_imm0(const void *mem);
uint32_t multicmp16_imm0(const void *mem);
uint32_t multicmp20_imm0(const void *mem);
uint32_t multicmp24_imm0(const void *mem);
uint32_t multicmp28_imm0(const void *mem);
uint32_t multicmp32_imm0(const void *mem);

uint32_t multicmp4(const void *mem, uint8_t byte_val);
uint32_t multicmp8(const void *mem, uint8_t byte_val);
uint32_t multicmp12(const void *mem, uint8_t byte_val);
uint32_t multicmp16(const void *mem, uint8_t byte_val);
uint32_t multicmp20(const void *mem, uint8_t byte_val);
uint32_t multicmp24(const void *mem, uint8_t byte_val);
uint32_t multicmp28(const void *mem, uint8_t byte_val);

uint32_t ctz(uint32_t target);
