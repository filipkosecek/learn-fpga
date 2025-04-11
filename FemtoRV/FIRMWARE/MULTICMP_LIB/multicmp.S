// MULTICMP register block
// expanded by C preprocessor
#ifdef VECTOR_BLOCK_BRAM

#define REG1 x7
#define REG2 x5
#define REG3 x6
#define REG4 x29
#define REG5 x30
#define REG6 x15
#define REG7 x16
#define REG8 x31

#else

#define REG1 x5
#define REG2 x6
#define REG3 x7
#define REG4 x28
#define REG5 x29
#define REG6 x30
#define REG7 x31
#define REG8 x17

#endif

.text

.global multicmp4_imm0
multicmp4_imm0:
lw REG1, 0(a0)
nop # multicmp4 a0, 0
jalr t1, ra, 0

.global multicmp8_imm0
multicmp8_imm0:
lw REG1, 0(a0)
lw REG2, 4(a0)
nop # multicmp8 a0, 0
jalr t1, ra, 0

.global multicmp12_imm0
multicmp12_imm0:
lw REG1, 0(a0)
lw REG2, 4(a0)
lw REG3, 8(a0)
nop # multicmp12 a0, 0
jalr t1, ra, 0

.global multicmp16_imm0
multicmp16_imm0:
lw REG1, 0(a0)
lw REG2, 4(a0)
lw REG3, 8(a0)
lw REG4, 12(a0)
nop # multicmp16 a0, 0
jalr t1, ra, 0

.global multicmp20_imm0
multicmp20_imm0:
lw REG1, 0(a0)
lw REG2, 4(a0)
lw REG3, 8(a0)
lw REG4, 12(a0)
lw REG5, 16(a0)
nop # multicmp20 a0, 0
jalr t1, ra, 0

.global multicmp24_imm0
multicmp24_imm0:
lw REG1, 0(a0)
lw REG2, 4(a0)
lw REG3, 8(a0)
lw REG4, 12(a0)
lw REG5, 16(a0)
lw REG6, 20(a0)
nop # multicmp24 a0, 0
jalr t1, ra, 0

.global multicmp28_imm0
multicmp28_imm0:
lw REG1, 0(a0)
lw REG2, 4(a0)
lw REG3, 8(a0)
lw REG4, 12(a0)
lw REG5, 16(a0)
lw REG6, 20(a0)
lw REG7, 24(a0)
nop # multicmp28 a0, 0
jalr t1, ra, 0

.global multicmp32_imm0
multicmp32_imm0:
lw REG1, 0(a0)
lw REG2, 4(a0)
lw REG3, 8(a0)
lw REG4, 12(a0)
lw REG5, 16(a0)
lw REG6, 20(a0)
lw REG7, 24(a0)
lw REG8, 28(a0)
nop # multicmp32 a0, 0
jalr t1, ra, 0

.global multicmp4
multicmp4:
lw REG1, 0(a0)
nop # multicmp4 a0, a1
jalr t1, ra, 0

.global multicmp8
multicmp8:
lw REG1, 0(a0)
lw REG2, 4(a0)
nop # multicmp8 a0, a1
jalr t1, ra, 0

.global multicmp12
multicmp12:
lw REG1, 0(a0)
lw REG2, 4(a0)
lw REG3, 8(a0)
nop # multicmp12 a0, a1
jalr t1, ra, 0

.global multicmp16
multicmp16:
lw REG1, 0(a0)
lw REG2, 4(a0)
lw REG3, 8(a0)
lw REG4, 12(a0)
nop # multicmp16 a0, a1
jalr t1, ra, 0

.global multicmp20
multicmp20:
lw REG1, 0(a0)
lw REG2, 4(a0)
lw REG3, 8(a0)
lw REG4, 12(a0)
lw REG5, 16(a0)
nop # multicmp20 a0, a1
jalr t1, ra, 0

.global multicmp24
multicmp24:
lw REG1, 0(a0)
lw REG2, 4(a0)
lw REG3, 8(a0)
lw REG4, 12(a0)
lw REG5, 16(a0)
lw REG6, 20(a0)
nop # multicmp24 a0, a1
jalr t1, ra, 0

.global multicmp28
multicmp28:
lw REG1, 0(a0)
lw REG2, 4(a0)
lw REG3, 8(a0)
lw REG4, 12(a0)
lw REG5, 16(a0)
lw REG6, 20(a0)
lw REG7, 24(a0)
nop # multicmp28 a0, a1
jalr t1, ra, 0
