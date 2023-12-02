
rv32ui-p-andi：     文件格式 elf32-littleriscv


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

800000c8 <test_2>:
800000c8:	00200193          	li	gp,2
800000cc:	ff0100b7          	lui	ra,0xff010
800000d0:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
800000d4:	f0f0f713          	andi	a4,ra,-241
800000d8:	ff0103b7          	lui	t2,0xff010
800000dc:	f0038393          	addi	t2,t2,-256 # ff00ff00 <_end+0x7f00df00>
800000e0:	1a771463          	bne	a4,t2,80000288 <fail>

800000e4 <test_3>:
800000e4:	00300193          	li	gp,3
800000e8:	0ff010b7          	lui	ra,0xff01
800000ec:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
800000f0:	0f00f713          	andi	a4,ra,240
800000f4:	0f000393          	li	t2,240
800000f8:	18771863          	bne	a4,t2,80000288 <fail>

800000fc <test_4>:
800000fc:	00400193          	li	gp,4
80000100:	00ff00b7          	lui	ra,0xff0
80000104:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
80000108:	70f0f713          	andi	a4,ra,1807
8000010c:	00f00393          	li	t2,15
80000110:	16771c63          	bne	a4,t2,80000288 <fail>

80000114 <test_5>:
80000114:	00500193          	li	gp,5
80000118:	f00ff0b7          	lui	ra,0xf00ff
8000011c:	00f08093          	addi	ra,ra,15 # f00ff00f <_end+0x700fd00f>
80000120:	0f00f713          	andi	a4,ra,240
80000124:	00000393          	li	t2,0
80000128:	16771063          	bne	a4,t2,80000288 <fail>

8000012c <test_6>:
8000012c:	00600193          	li	gp,6
80000130:	ff0100b7          	lui	ra,0xff010
80000134:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
80000138:	0f00f093          	andi	ra,ra,240
8000013c:	00000393          	li	t2,0
80000140:	14709463          	bne	ra,t2,80000288 <fail>

80000144 <test_7>:
80000144:	00700193          	li	gp,7
80000148:	00000213          	li	tp,0
8000014c:	0ff010b7          	lui	ra,0xff01
80000150:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
80000154:	70f0f713          	andi	a4,ra,1807
80000158:	00070313          	mv	t1,a4
8000015c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000160:	00200293          	li	t0,2
80000164:	fe5214e3          	bne	tp,t0,8000014c <test_7+0x8>
80000168:	70000393          	li	t2,1792
8000016c:	10731e63          	bne	t1,t2,80000288 <fail>

80000170 <test_8>:
80000170:	00800193          	li	gp,8
80000174:	00000213          	li	tp,0
80000178:	00ff00b7          	lui	ra,0xff0
8000017c:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
80000180:	0f00f713          	andi	a4,ra,240
80000184:	00000013          	nop
80000188:	00070313          	mv	t1,a4
8000018c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000190:	00200293          	li	t0,2
80000194:	fe5212e3          	bne	tp,t0,80000178 <test_8+0x8>
80000198:	0f000393          	li	t2,240
8000019c:	0e731663          	bne	t1,t2,80000288 <fail>

800001a0 <test_9>:
800001a0:	00900193          	li	gp,9
800001a4:	00000213          	li	tp,0
800001a8:	f00ff0b7          	lui	ra,0xf00ff
800001ac:	00f08093          	addi	ra,ra,15 # f00ff00f <_end+0x700fd00f>
800001b0:	f0f0f713          	andi	a4,ra,-241
800001b4:	00000013          	nop
800001b8:	00000013          	nop
800001bc:	00070313          	mv	t1,a4
800001c0:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800001c4:	00200293          	li	t0,2
800001c8:	fe5210e3          	bne	tp,t0,800001a8 <test_9+0x8>
800001cc:	f00ff3b7          	lui	t2,0xf00ff
800001d0:	00f38393          	addi	t2,t2,15 # f00ff00f <_end+0x700fd00f>
800001d4:	0a731a63          	bne	t1,t2,80000288 <fail>

800001d8 <test_10>:
800001d8:	00a00193          	li	gp,10
800001dc:	00000213          	li	tp,0
800001e0:	0ff010b7          	lui	ra,0xff01
800001e4:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
800001e8:	70f0f713          	andi	a4,ra,1807
800001ec:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800001f0:	00200293          	li	t0,2
800001f4:	fe5216e3          	bne	tp,t0,800001e0 <test_10+0x8>
800001f8:	70000393          	li	t2,1792
800001fc:	08771663          	bne	a4,t2,80000288 <fail>

80000200 <test_11>:
80000200:	00b00193          	li	gp,11
80000204:	00000213          	li	tp,0
80000208:	00ff00b7          	lui	ra,0xff0
8000020c:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
80000210:	00000013          	nop
80000214:	0f00f713          	andi	a4,ra,240
80000218:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000021c:	00200293          	li	t0,2
80000220:	fe5214e3          	bne	tp,t0,80000208 <test_11+0x8>
80000224:	0f000393          	li	t2,240
80000228:	06771063          	bne	a4,t2,80000288 <fail>

8000022c <test_12>:
8000022c:	00c00193          	li	gp,12
80000230:	00000213          	li	tp,0
80000234:	f00ff0b7          	lui	ra,0xf00ff
80000238:	00f08093          	addi	ra,ra,15 # f00ff00f <_end+0x700fd00f>
8000023c:	00000013          	nop
80000240:	00000013          	nop
80000244:	70f0f713          	andi	a4,ra,1807
80000248:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000024c:	00200293          	li	t0,2
80000250:	fe5212e3          	bne	tp,t0,80000234 <test_12+0x8>
80000254:	00f00393          	li	t2,15
80000258:	02771863          	bne	a4,t2,80000288 <fail>

8000025c <test_13>:
8000025c:	00d00193          	li	gp,13
80000260:	0f007093          	andi	ra,zero,240
80000264:	00000393          	li	t2,0
80000268:	02709063          	bne	ra,t2,80000288 <fail>

8000026c <test_14>:
8000026c:	00e00193          	li	gp,14
80000270:	00ff00b7          	lui	ra,0xff0
80000274:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
80000278:	70f0f013          	andi	zero,ra,1807
8000027c:	00000393          	li	t2,0
80000280:	00701463          	bne	zero,t2,80000288 <fail>
80000284:	00301a63          	bne	zero,gp,80000298 <pass>

80000288 <fail>:
80000288:	803002b7          	lui	t0,0x80300
8000028c:	55500313          	li	t1,1365
80000290:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
80000294:	d71ff06f          	j	80000004 <loop>

80000298 <pass>:
80000298:	803002b7          	lui	t0,0x80300
8000029c:	66600313          	li	t1,1638
800002a0:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
800002a4:	d61ff06f          	j	80000004 <loop>
800002a8:	c0001073          	unimp
800002ac:	0000                	unimp
800002ae:	0000                	unimp
800002b0:	0000                	unimp
800002b2:	0000                	unimp
800002b4:	0000                	unimp
800002b6:	0000                	unimp
800002b8:	0000                	unimp
800002ba:	0000                	unimp
800002bc:	0000                	unimp
800002be:	0000                	unimp
