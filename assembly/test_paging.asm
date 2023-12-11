
test_paging.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__BSS_END__+0x7fffefd8>:
   0:	00000293          	li	t0,0
   4:	06400313          	li	t1,100
   8:	00000393          	li	t2,0
   c:	00128293          	addi	t0,t0,1
  10:	007283b3          	add	t2,t0,t2
  14:	00628463          	beq	t0,t1,1c <__global_pointer$+0x7fffe7f4>
  18:	fe000ae3          	beqz	zero,c <__global_pointer$+0x7fffe7e4>
  1c:	800002b7          	lui	t0,0x80000
  20:	1072a023          	sw	t2,256(t0) # 80000100 <__global_pointer$+0xffffe8d8>
  24:	00008067          	ret
