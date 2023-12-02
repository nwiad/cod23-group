
rv32ui-p-bne：     文件格式 elf32-littleriscv


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
800000cc:	00000093          	li	ra,0
800000d0:	00100113          	li	sp,1
800000d4:	00209663          	bne	ra,sp,800000e0 <test_2+0x18>
800000d8:	2a301a63          	bne	zero,gp,8000038c <fail>
800000dc:	00301663          	bne	zero,gp,800000e8 <test_3>
800000e0:	fe209ee3          	bne	ra,sp,800000dc <test_2+0x14>
800000e4:	2a301463          	bne	zero,gp,8000038c <fail>

800000e8 <test_3>:
800000e8:	00300193          	li	gp,3
800000ec:	00100093          	li	ra,1
800000f0:	00000113          	li	sp,0
800000f4:	00209663          	bne	ra,sp,80000100 <test_3+0x18>
800000f8:	28301a63          	bne	zero,gp,8000038c <fail>
800000fc:	00301663          	bne	zero,gp,80000108 <test_4>
80000100:	fe209ee3          	bne	ra,sp,800000fc <test_3+0x14>
80000104:	28301463          	bne	zero,gp,8000038c <fail>

80000108 <test_4>:
80000108:	00400193          	li	gp,4
8000010c:	fff00093          	li	ra,-1
80000110:	00100113          	li	sp,1
80000114:	00209663          	bne	ra,sp,80000120 <test_4+0x18>
80000118:	26301a63          	bne	zero,gp,8000038c <fail>
8000011c:	00301663          	bne	zero,gp,80000128 <test_5>
80000120:	fe209ee3          	bne	ra,sp,8000011c <test_4+0x14>
80000124:	26301463          	bne	zero,gp,8000038c <fail>

80000128 <test_5>:
80000128:	00500193          	li	gp,5
8000012c:	00100093          	li	ra,1
80000130:	fff00113          	li	sp,-1
80000134:	00209663          	bne	ra,sp,80000140 <test_5+0x18>
80000138:	24301a63          	bne	zero,gp,8000038c <fail>
8000013c:	00301663          	bne	zero,gp,80000148 <test_6>
80000140:	fe209ee3          	bne	ra,sp,8000013c <test_5+0x14>
80000144:	24301463          	bne	zero,gp,8000038c <fail>

80000148 <test_6>:
80000148:	00600193          	li	gp,6
8000014c:	00000093          	li	ra,0
80000150:	00000113          	li	sp,0
80000154:	00209463          	bne	ra,sp,8000015c <test_6+0x14>
80000158:	00301463          	bne	zero,gp,80000160 <test_6+0x18>
8000015c:	22301863          	bne	zero,gp,8000038c <fail>
80000160:	fe209ee3          	bne	ra,sp,8000015c <test_6+0x14>

80000164 <test_7>:
80000164:	00700193          	li	gp,7
80000168:	00100093          	li	ra,1
8000016c:	00100113          	li	sp,1
80000170:	00209463          	bne	ra,sp,80000178 <test_7+0x14>
80000174:	00301463          	bne	zero,gp,8000017c <test_7+0x18>
80000178:	20301a63          	bne	zero,gp,8000038c <fail>
8000017c:	fe209ee3          	bne	ra,sp,80000178 <test_7+0x14>

80000180 <test_8>:
80000180:	00800193          	li	gp,8
80000184:	fff00093          	li	ra,-1
80000188:	fff00113          	li	sp,-1
8000018c:	00209463          	bne	ra,sp,80000194 <test_8+0x14>
80000190:	00301463          	bne	zero,gp,80000198 <test_8+0x18>
80000194:	1e301c63          	bne	zero,gp,8000038c <fail>
80000198:	fe209ee3          	bne	ra,sp,80000194 <test_8+0x14>

8000019c <test_9>:
8000019c:	00900193          	li	gp,9
800001a0:	00000213          	li	tp,0
800001a4:	00000093          	li	ra,0
800001a8:	00000113          	li	sp,0
800001ac:	1e209063          	bne	ra,sp,8000038c <fail>
800001b0:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800001b4:	00200293          	li	t0,2
800001b8:	fe5216e3          	bne	tp,t0,800001a4 <test_9+0x8>

800001bc <test_10>:
800001bc:	00a00193          	li	gp,10
800001c0:	00000213          	li	tp,0
800001c4:	00000093          	li	ra,0
800001c8:	00000113          	li	sp,0
800001cc:	00000013          	nop
800001d0:	1a209e63          	bne	ra,sp,8000038c <fail>
800001d4:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800001d8:	00200293          	li	t0,2
800001dc:	fe5214e3          	bne	tp,t0,800001c4 <test_10+0x8>

800001e0 <test_11>:
800001e0:	00b00193          	li	gp,11
800001e4:	00000213          	li	tp,0
800001e8:	00000093          	li	ra,0
800001ec:	00000113          	li	sp,0
800001f0:	00000013          	nop
800001f4:	00000013          	nop
800001f8:	18209a63          	bne	ra,sp,8000038c <fail>
800001fc:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000200:	00200293          	li	t0,2
80000204:	fe5212e3          	bne	tp,t0,800001e8 <test_11+0x8>

80000208 <test_12>:
80000208:	00c00193          	li	gp,12
8000020c:	00000213          	li	tp,0
80000210:	00000093          	li	ra,0
80000214:	00000013          	nop
80000218:	00000113          	li	sp,0
8000021c:	16209863          	bne	ra,sp,8000038c <fail>
80000220:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000224:	00200293          	li	t0,2
80000228:	fe5214e3          	bne	tp,t0,80000210 <test_12+0x8>

8000022c <test_13>:
8000022c:	00d00193          	li	gp,13
80000230:	00000213          	li	tp,0
80000234:	00000093          	li	ra,0
80000238:	00000013          	nop
8000023c:	00000113          	li	sp,0
80000240:	00000013          	nop
80000244:	14209463          	bne	ra,sp,8000038c <fail>
80000248:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000024c:	00200293          	li	t0,2
80000250:	fe5212e3          	bne	tp,t0,80000234 <test_13+0x8>

80000254 <test_14>:
80000254:	00e00193          	li	gp,14
80000258:	00000213          	li	tp,0
8000025c:	00000093          	li	ra,0
80000260:	00000013          	nop
80000264:	00000013          	nop
80000268:	00000113          	li	sp,0
8000026c:	12209063          	bne	ra,sp,8000038c <fail>
80000270:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000274:	00200293          	li	t0,2
80000278:	fe5212e3          	bne	tp,t0,8000025c <test_14+0x8>

8000027c <test_15>:
8000027c:	00f00193          	li	gp,15
80000280:	00000213          	li	tp,0
80000284:	00000093          	li	ra,0
80000288:	00000113          	li	sp,0
8000028c:	10209063          	bne	ra,sp,8000038c <fail>
80000290:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000294:	00200293          	li	t0,2
80000298:	fe5216e3          	bne	tp,t0,80000284 <test_15+0x8>

8000029c <test_16>:
8000029c:	01000193          	li	gp,16
800002a0:	00000213          	li	tp,0
800002a4:	00000093          	li	ra,0
800002a8:	00000113          	li	sp,0
800002ac:	00000013          	nop
800002b0:	0c209e63          	bne	ra,sp,8000038c <fail>
800002b4:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002b8:	00200293          	li	t0,2
800002bc:	fe5214e3          	bne	tp,t0,800002a4 <test_16+0x8>

800002c0 <test_17>:
800002c0:	01100193          	li	gp,17
800002c4:	00000213          	li	tp,0
800002c8:	00000093          	li	ra,0
800002cc:	00000113          	li	sp,0
800002d0:	00000013          	nop
800002d4:	00000013          	nop
800002d8:	0a209a63          	bne	ra,sp,8000038c <fail>
800002dc:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002e0:	00200293          	li	t0,2
800002e4:	fe5212e3          	bne	tp,t0,800002c8 <test_17+0x8>

800002e8 <test_18>:
800002e8:	01200193          	li	gp,18
800002ec:	00000213          	li	tp,0
800002f0:	00000093          	li	ra,0
800002f4:	00000013          	nop
800002f8:	00000113          	li	sp,0
800002fc:	08209863          	bne	ra,sp,8000038c <fail>
80000300:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000304:	00200293          	li	t0,2
80000308:	fe5214e3          	bne	tp,t0,800002f0 <test_18+0x8>

8000030c <test_19>:
8000030c:	01300193          	li	gp,19
80000310:	00000213          	li	tp,0
80000314:	00000093          	li	ra,0
80000318:	00000013          	nop
8000031c:	00000113          	li	sp,0
80000320:	00000013          	nop
80000324:	06209463          	bne	ra,sp,8000038c <fail>
80000328:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000032c:	00200293          	li	t0,2
80000330:	fe5212e3          	bne	tp,t0,80000314 <test_19+0x8>

80000334 <test_20>:
80000334:	01400193          	li	gp,20
80000338:	00000213          	li	tp,0
8000033c:	00000093          	li	ra,0
80000340:	00000013          	nop
80000344:	00000013          	nop
80000348:	00000113          	li	sp,0
8000034c:	04209063          	bne	ra,sp,8000038c <fail>
80000350:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000354:	00200293          	li	t0,2
80000358:	fe5212e3          	bne	tp,t0,8000033c <test_20+0x8>

8000035c <test_21>:
8000035c:	01500193          	li	gp,21
80000360:	00100093          	li	ra,1
80000364:	00009a63          	bnez	ra,80000378 <test_21+0x1c>
80000368:	00108093          	addi	ra,ra,1
8000036c:	00108093          	addi	ra,ra,1
80000370:	00108093          	addi	ra,ra,1
80000374:	00108093          	addi	ra,ra,1
80000378:	00108093          	addi	ra,ra,1
8000037c:	00108093          	addi	ra,ra,1
80000380:	00300393          	li	t2,3
80000384:	00709463          	bne	ra,t2,8000038c <fail>
80000388:	00301a63          	bne	zero,gp,8000039c <pass>

8000038c <fail>:
8000038c:	803002b7          	lui	t0,0x80300
80000390:	55500313          	li	t1,1365
80000394:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
80000398:	c6dff06f          	j	80000004 <loop>

8000039c <pass>:
8000039c:	803002b7          	lui	t0,0x80300
800003a0:	66600313          	li	t1,1638
800003a4:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
800003a8:	c5dff06f          	j	80000004 <loop>
800003ac:	c0001073          	unimp
800003b0:	0000                	unimp
800003b2:	0000                	unimp
800003b4:	0000                	unimp
800003b6:	0000                	unimp
800003b8:	0000                	unimp
800003ba:	0000                	unimp
800003bc:	0000                	unimp
800003be:	0000                	unimp
