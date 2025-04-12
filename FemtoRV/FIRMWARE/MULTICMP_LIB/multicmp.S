// MULTICMP register block
// expanded by C preprocessor
#ifdef VECTOR_BLOCK_BRAM

#define RS2 x7
#define RS3 x5
#define RS4 x6
#define RS5 x29
#define RS6 x30
#define RS7 x15
#define RS8 x16
#define RS1 x31

#else

#define RS2 x5
#define RS3 x6
#define RS4 x7
#define RS5 x28
#define RS6 x29
#define RS7 x30
#define RS8 x31
#define RS1 x17

#endif

.text

.global multicmp4_imm0
multicmp4_imm0:
lw RS2, 0(a0)
nop # multicmp4 a0, 0
jalr t1, ra, 0

.global multicmp8_imm0
multicmp8_imm0:
lw RS2, 0(a0)
lw RS3, 4(a0)
nop # multicmp8 a0, 0
jalr t1, ra, 0

.global multicmp12_imm0
multicmp12_imm0:
lw RS2, 0(a0)
lw RS3, 4(a0)
lw RS4, 8(a0)
nop # multicmp12 a0, 0
jalr t1, ra, 0

.global multicmp16_imm0
multicmp16_imm0:
lw RS2, 0(a0)
lw RS3, 4(a0)
lw RS4, 8(a0)
lw RS5, 12(a0)
nop # multicmp16 a0, 0
jalr t1, ra, 0

.global multicmp20_imm0
multicmp20_imm0:
lw RS2, 0(a0)
lw RS3, 4(a0)
lw RS4, 8(a0)
lw RS5, 12(a0)
lw RS6, 16(a0)
nop # multicmp20 a0, 0
jalr t1, ra, 0

.global multicmp24_imm0
multicmp24_imm0:
lw RS2, 0(a0)
lw RS3, 4(a0)
lw RS4, 8(a0)
lw RS5, 12(a0)
lw RS6, 16(a0)
lw RS7, 20(a0)
nop # multicmp24 a0, 0
jalr t1, ra, 0

.global multicmp28_imm0
multicmp28_imm0:
lw RS2, 0(a0)
lw RS3, 4(a0)
lw RS4, 8(a0)
lw RS5, 12(a0)
lw RS6, 16(a0)
lw RS7, 20(a0)
lw RS8, 24(a0)
nop # multicmp28 a0, 0
jalr t1, ra, 0

.global multicmp32_imm0
multicmp32_imm0:
lw RS2, 0(a0)
lw RS3, 4(a0)
lw RS4, 8(a0)
lw RS5, 12(a0)
lw RS6, 16(a0)
lw RS7, 20(a0)
lw RS8, 24(a0)
lw RS1, 28(a0)
nop # multicmp32 a0, 0
jalr t1, ra, 0

.global multicmp4
multicmp4:
lw RS2, 0(a0)
nop # multicmp4 a0, a1
jalr t1, ra, 0

.global multicmp8
multicmp8:
lw RS2, 0(a0)
lw RS3, 4(a0)
nop # multicmp8 a0, a1
jalr t1, ra, 0

.global multicmp12
multicmp12:
lw RS2, 0(a0)
lw RS3, 4(a0)
lw RS4, 8(a0)
nop # multicmp12 a0, a1
jalr t1, ra, 0

.global multicmp16
multicmp16:
lw RS2, 0(a0)
lw RS3, 4(a0)
lw RS4, 8(a0)
lw RS5, 12(a0)
nop # multicmp16 a0, a1
jalr t1, ra, 0

.global multicmp20
multicmp20:
lw RS2, 0(a0)
lw RS3, 4(a0)
lw RS4, 8(a0)
lw RS5, 12(a0)
lw RS6, 16(a0)
nop # multicmp20 a0, a1
jalr t1, ra, 0

.global multicmp24
multicmp24:
lw RS2, 0(a0)
lw RS3, 4(a0)
lw RS4, 8(a0)
lw RS5, 12(a0)
lw RS6, 16(a0)
lw RS7, 20(a0)
nop # multicmp24 a0, a1
jalr t1, ra, 0

.global multicmp28
multicmp28:
lw RS2, 0(a0)
lw RS3, 4(a0)
lw RS4, 8(a0)
lw RS5, 12(a0)
lw RS6, 16(a0)
lw RS7, 20(a0)
lw RS8, 24(a0)
nop # multicmp28 a0, a1
jalr t1, ra, 0
