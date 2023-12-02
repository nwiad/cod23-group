
rv32ui-p-fence_i：     文件格式 elf32-littleriscv


Disassembly of section .text.init:

80000000 <_start>:
80000000:	04c0006f          	j	8000004c <reset_vector>

80000004 <loop>:
80000004:	0000006f          	j	80000004 <loop>

80000008 <trap_vector>:
80000008:	34202f73          	csrr	t5,mcause
8000000c:	00800f93          	li	t6,8
80000010:	03ff0863          	beq	t5,t6,80000040 <write_tohost>
80000014:	00900f93          	li	t6,9
80000018:	03ff0463          	beq	t5,t6,80000040 <write_tohost>
8000001c:	00b00f93          	li	t6,11
80000020:	03ff0063          	beq	t5,t6,80000040 <write_tohost>
80000024:	00000f13          	li	t5,0
80000028:	000f0463          	beqz	t5,80000030 <trap_vector+0x28>
8000002c:	000f0067          	jr	t5
80000030:	34202f73          	csrr	t5,mcause
80000034:	000f5463          	bgez	t5,8000003c <handle_exception>
80000038:	0040006f          	j	8000003c <handle_exception>

8000003c <handle_exception>:
8000003c:	5391e193          	ori	gp,gp,1337

80000040 <write_tohost>:
80000040:	00001f17          	auipc	t5,0x1
80000044:	fc3f2023          	sw	gp,-64(t5) # 80001000 <tohost>
80000048:	ff9ff06f          	j	80000040 <write_tohost>

8000004c <reset_vector>:
8000004c:	00000093          	li	ra,0
80000050:	00000113          	li	sp,0
80000054:	00000193          	li	gp,0
80000058:	00000213          	li	tp,0
8000005c:	00000293          	li	t0,0
80000060:	00000313          	li	t1,0
80000064:	00000393          	li	t2,0
80000068:	00000413          	li	s0,0
8000006c:	00000493          	li	s1,0
80000070:	00000513          	li	a0,0
80000074:	00000593          	li	a1,0
80000078:	00000613          	li	a2,0
8000007c:	00000693          	li	a3,0
80000080:	00000713          	li	a4,0
80000084:	00000793          	li	a5,0
80000088:	00000813          	li	a6,0
8000008c:	00000893          	li	a7,0
80000090:	00000913          	li	s2,0
80000094:	00000993          	li	s3,0
80000098:	00000a13          	li	s4,0
8000009c:	00000a93          	li	s5,0
800000a0:	00000b13          	li	s6,0
800000a4:	00000b93          	li	s7,0
800000a8:	00000c13          	li	s8,0
800000ac:	00000c93          	li	s9,0
800000b0:	00000d13          	li	s10,0
800000b4:	00000d93          	li	s11,0
800000b8:	00000e13          	li	t3,0
800000bc:	00000e93          	li	t4,0
800000c0:	00000f13          	li	t5,0
800000c4:	00000f93          	li	t6,0
800000c8:	06f00693          	li	a3,111
800000cc:	00002517          	auipc	a0,0x2
800000d0:	f3451503          	lh	a0,-204(a0) # 80002000 <begin_signature>
800000d4:	00002597          	auipc	a1,0x2
800000d8:	f2e59583          	lh	a1,-210(a1) # 80002002 <begin_signature+0x2>
800000dc:	00000013          	nop
800000e0:	00000013          	nop
800000e4:	00000013          	nop
800000e8:	00000013          	nop
800000ec:	00000013          	nop
800000f0:	00000013          	nop
800000f4:	00000013          	nop
800000f8:	00000013          	nop
800000fc:	00000013          	nop
80000100:	00002297          	auipc	t0,0x2
80000104:	f0a29223          	sh	a0,-252(t0) # 80002004 <begin_signature+0x4>
80000108:	00002297          	auipc	t0,0x2
8000010c:	eeb29f23          	sh	a1,-258(t0) # 80002006 <begin_signature+0x6>
80000110:	0000100f          	fence.i
80000114:	00002797          	auipc	a5,0x2
80000118:	ef078793          	addi	a5,a5,-272 # 80002004 <begin_signature+0x4>
8000011c:	00078367          	jalr	t1,a5

80000120 <test_2>:
80000120:	00200193          	li	gp,2
80000124:	00000013          	nop
80000128:	1bc00393          	li	t2,444
8000012c:	06769a63          	bne	a3,t2,800001a0 <fail>
80000130:	06400713          	li	a4,100
80000134:	fff70713          	addi	a4,a4,-1
80000138:	fe071ee3          	bnez	a4,80000134 <test_2+0x14>
8000013c:	00002297          	auipc	t0,0x2
80000140:	eca29823          	sh	a0,-304(t0) # 8000200c <begin_signature+0xc>
80000144:	00002297          	auipc	t0,0x2
80000148:	ecb29523          	sh	a1,-310(t0) # 8000200e <begin_signature+0xe>
8000014c:	0000100f          	fence.i
80000150:	00000013          	nop
80000154:	00000013          	nop
80000158:	00000013          	nop
8000015c:	00000013          	nop
80000160:	00000013          	nop
80000164:	00000013          	nop
80000168:	00000013          	nop
8000016c:	00000013          	nop
80000170:	00000013          	nop
80000174:	00000013          	nop
80000178:	00000013          	nop
8000017c:	00000013          	nop
80000180:	00002797          	auipc	a5,0x2
80000184:	e8c78793          	addi	a5,a5,-372 # 8000200c <begin_signature+0xc>
80000188:	00078367          	jalr	t1,a5

8000018c <test_3>:
8000018c:	00300193          	li	gp,3
80000190:	00000013          	nop
80000194:	30900393          	li	t2,777
80000198:	00769463          	bne	a3,t2,800001a0 <fail>
8000019c:	00301a63          	bne	zero,gp,800001b0 <pass>

800001a0 <fail>:
800001a0:	803002b7          	lui	t0,0x80300
800001a4:	55500313          	li	t1,1365
800001a8:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fdfe0>
800001ac:	e59ff06f          	j	80000004 <loop>

800001b0 <pass>:
800001b0:	803002b7          	lui	t0,0x80300
800001b4:	66600313          	li	t1,1638
800001b8:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fdfe0>
800001bc:	e49ff06f          	j	80000004 <loop>
800001c0:	c0001073          	unimp
800001c4:	0000                	unimp
800001c6:	0000                	unimp
800001c8:	0000                	unimp
800001ca:	0000                	unimp
800001cc:	0000                	unimp
800001ce:	0000                	unimp
800001d0:	0000                	unimp
800001d2:	0000                	unimp
800001d4:	0000                	unimp
800001d6:	0000                	unimp
800001d8:	0000                	unimp
800001da:	0000                	unimp

Disassembly of section .data:

80002000 <begin_signature>:
80002000:	14d68693          	addi	a3,a3,333
80002004:	0de68693          	addi	a3,a3,222
80002008:	000307e7          	jalr	a5,t1
8000200c:	22b68693          	addi	a3,a3,555
80002010:	000307e7          	jalr	a5,t1
80002014:	0000                	unimp
80002016:	0000                	unimp
80002018:	0000                	unimp
8000201a:	0000                	unimp
8000201c:	0000                	unimp
8000201e:	0000                	unimp
