.text

.global multicmp4_imm0
multicmp4_imm0:
lw t0, 0(a0)
nop # multicmp4 a0, 0
jalr t1, ra, 0

.global multicmp8_imm0
multicmp8_imm0:
lw t0, 0(a0)
lw t1, 4(a0)
nop # multicmp8 a0, 0
jalr t1, ra, 0

.global multicmp12_imm0
multicmp12_imm0:
lw t0, 0(a0)
lw t1, 4(a0)
lw t2, 8(a0)
nop # multicmp12 a0, 0
jalr t1, ra, 0

.global multicmp16_imm0
multicmp16_imm0:
lw t0, 0(a0)
lw t1, 4(a0)
lw t2, 8(a0)
lw t3, 12(a0)
nop # multicmp16 a0, 0
jalr t1, ra, 0

.global multicmp20_imm0
multicmp20_imm0:
lw t0, 0(a0)
lw t1, 4(a0)
lw t2, 8(a0)
lw t3, 12(a0)
lw t4, 16(a0)
nop # multicmp20 a0, 0
jalr t1, ra, 0

.global multicmp24_imm0
multicmp24_imm0:
lw t0, 0(a0)
lw t1, 4(a0)
lw t2, 8(a0)
lw t3, 12(a0)
lw t4, 16(a0)
lw t5, 20(a0)
nop # multicmp24 a0, 0
jalr t1, ra, 0

.global multicmp28_imm0
multicmp28_imm0:
lw t0, 0(a0)
lw t1, 4(a0)
lw t2, 8(a0)
lw t3, 12(a0)
lw t4, 16(a0)
lw t5, 20(a0)
lw t6, 24(a0)
nop # multicmp28 a0, 0
jalr t1, ra, 0

.global multicmp32_imm0
multicmp32_imm0:
lw t0, 0(a0)
lw t1, 4(a0)
lw t2, 8(a0)
lw t3, 12(a0)
lw t4, 16(a0)
lw t5, 20(a0)
lw t6, 24(a0)
lw a0, 28(a0)
nop # multicmp32 a0, 0
jalr t1, ra, 0

.global multicmp4
multicmp4:
lw t0, 0(a0)
nop # multicmp4 a0, a1
jalr t1, ra, 0

.global multicmp8
multicmp8:
lw t0, 0(a0)
lw t1, 4(a0)
nop # multicmp8 a0, a1
jalr t1, ra, 0

.global multicmp12
multicmp12:
lw t0, 0(a0)
lw t1, 4(a0)
lw t2, 8(a0)
nop # multicmp12 a0, a1
jalr t1, ra, 0

.global multicmp16
multicmp16:
lw t0, 0(a0)
lw t1, 4(a0)
lw t2, 8(a0)
lw t3, 12(a0)
nop # multicmp16 a0, a1
jalr t1, ra, 0

.global multicmp20
multicmp20:
lw t0, 0(a0)
lw t1, 4(a0)
lw t2, 8(a0)
lw t3, 12(a0)
lw t4, 16(a0)
nop # multicmp20 a0, a1
jalr t1, ra, 0

.global multicmp24
multicmp24:
lw t0, 0(a0)
lw t1, 4(a0)
lw t2, 8(a0)
lw t3, 12(a0)
lw t4, 16(a0)
lw t5, 20(a0)
nop # multicmp24 a0, a1
jalr t1, ra, 0

.global multicmp28
multicmp28:
lw t0, 0(a0)
lw t1, 4(a0)
lw t2, 8(a0)
lw t3, 12(a0)
lw t4, 16(a0)
lw t5, 20(a0)
lw t6, 24(a0)
nop # multicmp28 a0, a1
jalr t1, ra, 0

.global multicmp32
multicmp32:
lw t0, 0(a0)
lw t1, 4(a0)
lw t2, 8(a0)
lw t3, 12(a0)
lw t4, 16(a0)
lw t5, 20(a0)
lw t6, 24(a0)
lw a0, 28(a0)
nop # multicmp32 a0, a1
jalr t1, ra, 0
