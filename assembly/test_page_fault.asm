
test_page_fault.elf:     file format elf32-littleriscv


Disassembly of section .text:

80000000 <__BSS_END__-0x100c>:
80000000:	800002b7          	lui	t0,0x80000
80000004:	0002a023          	sw	zero,0(t0) # 80000000 <__global_pointer$+0xffffe7f4>
80000008:	00008067          	ret
