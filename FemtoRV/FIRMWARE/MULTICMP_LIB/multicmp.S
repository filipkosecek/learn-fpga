.text

.global multicmp8
multicmp8:
lw t0, 0(a0)
lw t1, 4(a0)
nop # multicmp8 a0, a1
jalr t1, ra, 0
