
rv32ui-p-xori：     文件格式 elf32-littleriscv


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
800000cc:	00ff10b7          	lui	ra,0xff1
800000d0:	f0008093          	addi	ra,ra,-256 # ff0f00 <_start-0x7f00f100>
800000d4:	f0f0c713          	xori	a4,ra,-241
800000d8:	ff00f3b7          	lui	t2,0xff00f
800000dc:	00f38393          	addi	t2,t2,15 # ff00f00f <_end+0x7f00d00f>
800000e0:	1c771663          	bne	a4,t2,800002ac <fail>

800000e4 <test_3>:
800000e4:	00300193          	li	gp,3
800000e8:	0ff010b7          	lui	ra,0xff01
800000ec:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
800000f0:	0f00c713          	xori	a4,ra,240
800000f4:	0ff013b7          	lui	t2,0xff01
800000f8:	f0038393          	addi	t2,t2,-256 # ff00f00 <_start-0x700ff100>
800000fc:	1a771863          	bne	a4,t2,800002ac <fail>

80000100 <test_4>:
80000100:	00400193          	li	gp,4
80000104:	00ff10b7          	lui	ra,0xff1
80000108:	8ff08093          	addi	ra,ra,-1793 # ff08ff <_start-0x7f00f701>
8000010c:	70f0c713          	xori	a4,ra,1807
80000110:	00ff13b7          	lui	t2,0xff1
80000114:	ff038393          	addi	t2,t2,-16 # ff0ff0 <_start-0x7f00f010>
80000118:	18771a63          	bne	a4,t2,800002ac <fail>

8000011c <test_5>:
8000011c:	00500193          	li	gp,5
80000120:	f00ff0b7          	lui	ra,0xf00ff
80000124:	00f08093          	addi	ra,ra,15 # f00ff00f <_end+0x700fd00f>
80000128:	0f00c713          	xori	a4,ra,240
8000012c:	f00ff3b7          	lui	t2,0xf00ff
80000130:	0ff38393          	addi	t2,t2,255 # f00ff0ff <_end+0x700fd0ff>
80000134:	16771c63          	bne	a4,t2,800002ac <fail>

80000138 <test_6>:
80000138:	00600193          	li	gp,6
8000013c:	ff00f0b7          	lui	ra,0xff00f
80000140:	70008093          	addi	ra,ra,1792 # ff00f700 <_end+0x7f00d700>
80000144:	70f0c093          	xori	ra,ra,1807
80000148:	ff00f3b7          	lui	t2,0xff00f
8000014c:	00f38393          	addi	t2,t2,15 # ff00f00f <_end+0x7f00d00f>
80000150:	14709e63          	bne	ra,t2,800002ac <fail>

80000154 <test_7>:
80000154:	00700193          	li	gp,7
80000158:	00000213          	li	tp,0
8000015c:	0ff010b7          	lui	ra,0xff01
80000160:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
80000164:	0f00c713          	xori	a4,ra,240
80000168:	00070313          	mv	t1,a4
8000016c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000170:	00200293          	li	t0,2
80000174:	fe5214e3          	bne	tp,t0,8000015c <test_7+0x8>
80000178:	0ff013b7          	lui	t2,0xff01
8000017c:	f0038393          	addi	t2,t2,-256 # ff00f00 <_start-0x700ff100>
80000180:	12731663          	bne	t1,t2,800002ac <fail>

80000184 <test_8>:
80000184:	00800193          	li	gp,8
80000188:	00000213          	li	tp,0
8000018c:	00ff10b7          	lui	ra,0xff1
80000190:	8ff08093          	addi	ra,ra,-1793 # ff08ff <_start-0x7f00f701>
80000194:	70f0c713          	xori	a4,ra,1807
80000198:	00000013          	nop
8000019c:	00070313          	mv	t1,a4
800001a0:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800001a4:	00200293          	li	t0,2
800001a8:	fe5212e3          	bne	tp,t0,8000018c <test_8+0x8>
800001ac:	00ff13b7          	lui	t2,0xff1
800001b0:	ff038393          	addi	t2,t2,-16 # ff0ff0 <_start-0x7f00f010>
800001b4:	0e731c63          	bne	t1,t2,800002ac <fail>

800001b8 <test_9>:
800001b8:	00900193          	li	gp,9
800001bc:	00000213          	li	tp,0
800001c0:	f00ff0b7          	lui	ra,0xf00ff
800001c4:	00f08093          	addi	ra,ra,15 # f00ff00f <_end+0x700fd00f>
800001c8:	0f00c713          	xori	a4,ra,240
800001cc:	00000013          	nop
800001d0:	00000013          	nop
800001d4:	00070313          	mv	t1,a4
800001d8:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800001dc:	00200293          	li	t0,2
800001e0:	fe5210e3          	bne	tp,t0,800001c0 <test_9+0x8>
800001e4:	f00ff3b7          	lui	t2,0xf00ff
800001e8:	0ff38393          	addi	t2,t2,255 # f00ff0ff <_end+0x700fd0ff>
800001ec:	0c731063          	bne	t1,t2,800002ac <fail>

800001f0 <test_10>:
800001f0:	00a00193          	li	gp,10
800001f4:	00000213          	li	tp,0
800001f8:	0ff010b7          	lui	ra,0xff01
800001fc:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
80000200:	0f00c713          	xori	a4,ra,240
80000204:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000208:	00200293          	li	t0,2
8000020c:	fe5216e3          	bne	tp,t0,800001f8 <test_10+0x8>
80000210:	0ff013b7          	lui	t2,0xff01
80000214:	f0038393          	addi	t2,t2,-256 # ff00f00 <_start-0x700ff100>
80000218:	08771a63          	bne	a4,t2,800002ac <fail>

8000021c <test_11>:
8000021c:	00b00193          	li	gp,11
80000220:	00000213          	li	tp,0
80000224:	00ff10b7          	lui	ra,0xff1
80000228:	fff08093          	addi	ra,ra,-1 # ff0fff <_start-0x7f00f001>
8000022c:	00000013          	nop
80000230:	00f0c713          	xori	a4,ra,15
80000234:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000238:	00200293          	li	t0,2
8000023c:	fe5214e3          	bne	tp,t0,80000224 <test_11+0x8>
80000240:	00ff13b7          	lui	t2,0xff1
80000244:	ff038393          	addi	t2,t2,-16 # ff0ff0 <_start-0x7f00f010>
80000248:	06771263          	bne	a4,t2,800002ac <fail>

8000024c <test_12>:
8000024c:	00c00193          	li	gp,12
80000250:	00000213          	li	tp,0
80000254:	f00ff0b7          	lui	ra,0xf00ff
80000258:	00f08093          	addi	ra,ra,15 # f00ff00f <_end+0x700fd00f>
8000025c:	00000013          	nop
80000260:	00000013          	nop
80000264:	0f00c713          	xori	a4,ra,240
80000268:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000026c:	00200293          	li	t0,2
80000270:	fe5212e3          	bne	tp,t0,80000254 <test_12+0x8>
80000274:	f00ff3b7          	lui	t2,0xf00ff
80000278:	0ff38393          	addi	t2,t2,255 # f00ff0ff <_end+0x700fd0ff>
8000027c:	02771863          	bne	a4,t2,800002ac <fail>

80000280 <test_13>:
80000280:	00d00193          	li	gp,13
80000284:	0f004093          	xori	ra,zero,240
80000288:	0f000393          	li	t2,240
8000028c:	02709063          	bne	ra,t2,800002ac <fail>

80000290 <test_14>:
80000290:	00e00193          	li	gp,14
80000294:	00ff00b7          	lui	ra,0xff0
80000298:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
8000029c:	70f0c013          	xori	zero,ra,1807
800002a0:	00000393          	li	t2,0
800002a4:	00701463          	bne	zero,t2,800002ac <fail>
800002a8:	00301a63          	bne	zero,gp,800002bc <pass>

800002ac <fail>:
800002ac:	803002b7          	lui	t0,0x80300
800002b0:	55500313          	li	t1,1365
800002b4:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
800002b8:	d4dff06f          	j	80000004 <loop>

800002bc <pass>:
800002bc:	803002b7          	lui	t0,0x80300
800002c0:	66600313          	li	t1,1638
800002c4:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
800002c8:	d3dff06f          	j	80000004 <loop>
800002cc:	c0001073          	unimp
800002d0:	0000                	unimp
800002d2:	0000                	unimp
800002d4:	0000                	unimp
800002d6:	0000                	unimp
800002d8:	0000                	unimp
800002da:	0000                	unimp
800002dc:	0000                	unimp
800002de:	0000                	unimp
800002e0:	0000                	unimp
800002e2:	0000                	unimp
800002e4:	0000                	unimp
800002e6:	0000                	unimp
800002e8:	0000                	unimp
800002ea:	0000                	unimp
800002ec:	0000                	unimp
800002ee:	0000                	unimp
800002f0:	0000                	unimp
800002f2:	0000                	unimp
800002f4:	0000                	unimp
800002f6:	0000                	unimp
800002f8:	0000                	unimp
800002fa:	0000                	unimp
800002fc:	0000                	unimp
800002fe:	0000                	unimp
