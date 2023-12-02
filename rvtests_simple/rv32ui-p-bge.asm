
rv32ui-p-bge：     文件格式 elf32-littleriscv


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
800000d0:	00000113          	li	sp,0
800000d4:	0020d663          	bge	ra,sp,800000e0 <test_2+0x18>
800000d8:	30301863          	bne	zero,gp,800003e8 <fail>
800000dc:	00301663          	bne	zero,gp,800000e8 <test_3>
800000e0:	fe20dee3          	bge	ra,sp,800000dc <test_2+0x14>
800000e4:	30301263          	bne	zero,gp,800003e8 <fail>

800000e8 <test_3>:
800000e8:	00300193          	li	gp,3
800000ec:	00100093          	li	ra,1
800000f0:	00100113          	li	sp,1
800000f4:	0020d663          	bge	ra,sp,80000100 <test_3+0x18>
800000f8:	2e301863          	bne	zero,gp,800003e8 <fail>
800000fc:	00301663          	bne	zero,gp,80000108 <test_4>
80000100:	fe20dee3          	bge	ra,sp,800000fc <test_3+0x14>
80000104:	2e301263          	bne	zero,gp,800003e8 <fail>

80000108 <test_4>:
80000108:	00400193          	li	gp,4
8000010c:	fff00093          	li	ra,-1
80000110:	fff00113          	li	sp,-1
80000114:	0020d663          	bge	ra,sp,80000120 <test_4+0x18>
80000118:	2c301863          	bne	zero,gp,800003e8 <fail>
8000011c:	00301663          	bne	zero,gp,80000128 <test_5>
80000120:	fe20dee3          	bge	ra,sp,8000011c <test_4+0x14>
80000124:	2c301263          	bne	zero,gp,800003e8 <fail>

80000128 <test_5>:
80000128:	00500193          	li	gp,5
8000012c:	00100093          	li	ra,1
80000130:	00000113          	li	sp,0
80000134:	0020d663          	bge	ra,sp,80000140 <test_5+0x18>
80000138:	2a301863          	bne	zero,gp,800003e8 <fail>
8000013c:	00301663          	bne	zero,gp,80000148 <test_6>
80000140:	fe20dee3          	bge	ra,sp,8000013c <test_5+0x14>
80000144:	2a301263          	bne	zero,gp,800003e8 <fail>

80000148 <test_6>:
80000148:	00600193          	li	gp,6
8000014c:	00100093          	li	ra,1
80000150:	fff00113          	li	sp,-1
80000154:	0020d663          	bge	ra,sp,80000160 <test_6+0x18>
80000158:	28301863          	bne	zero,gp,800003e8 <fail>
8000015c:	00301663          	bne	zero,gp,80000168 <test_7>
80000160:	fe20dee3          	bge	ra,sp,8000015c <test_6+0x14>
80000164:	28301263          	bne	zero,gp,800003e8 <fail>

80000168 <test_7>:
80000168:	00700193          	li	gp,7
8000016c:	fff00093          	li	ra,-1
80000170:	ffe00113          	li	sp,-2
80000174:	0020d663          	bge	ra,sp,80000180 <test_7+0x18>
80000178:	26301863          	bne	zero,gp,800003e8 <fail>
8000017c:	00301663          	bne	zero,gp,80000188 <test_8>
80000180:	fe20dee3          	bge	ra,sp,8000017c <test_7+0x14>
80000184:	26301263          	bne	zero,gp,800003e8 <fail>

80000188 <test_8>:
80000188:	00800193          	li	gp,8
8000018c:	00000093          	li	ra,0
80000190:	00100113          	li	sp,1
80000194:	0020d463          	bge	ra,sp,8000019c <test_8+0x14>
80000198:	00301463          	bne	zero,gp,800001a0 <test_8+0x18>
8000019c:	24301663          	bne	zero,gp,800003e8 <fail>
800001a0:	fe20dee3          	bge	ra,sp,8000019c <test_8+0x14>

800001a4 <test_9>:
800001a4:	00900193          	li	gp,9
800001a8:	fff00093          	li	ra,-1
800001ac:	00100113          	li	sp,1
800001b0:	0020d463          	bge	ra,sp,800001b8 <test_9+0x14>
800001b4:	00301463          	bne	zero,gp,800001bc <test_9+0x18>
800001b8:	22301863          	bne	zero,gp,800003e8 <fail>
800001bc:	fe20dee3          	bge	ra,sp,800001b8 <test_9+0x14>

800001c0 <test_10>:
800001c0:	00a00193          	li	gp,10
800001c4:	ffe00093          	li	ra,-2
800001c8:	fff00113          	li	sp,-1
800001cc:	0020d463          	bge	ra,sp,800001d4 <test_10+0x14>
800001d0:	00301463          	bne	zero,gp,800001d8 <test_10+0x18>
800001d4:	20301a63          	bne	zero,gp,800003e8 <fail>
800001d8:	fe20dee3          	bge	ra,sp,800001d4 <test_10+0x14>

800001dc <test_11>:
800001dc:	00b00193          	li	gp,11
800001e0:	ffe00093          	li	ra,-2
800001e4:	00100113          	li	sp,1
800001e8:	0020d463          	bge	ra,sp,800001f0 <test_11+0x14>
800001ec:	00301463          	bne	zero,gp,800001f4 <test_11+0x18>
800001f0:	1e301c63          	bne	zero,gp,800003e8 <fail>
800001f4:	fe20dee3          	bge	ra,sp,800001f0 <test_11+0x14>

800001f8 <test_12>:
800001f8:	00c00193          	li	gp,12
800001fc:	00000213          	li	tp,0
80000200:	fff00093          	li	ra,-1
80000204:	00000113          	li	sp,0
80000208:	1e20d063          	bge	ra,sp,800003e8 <fail>
8000020c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000210:	00200293          	li	t0,2
80000214:	fe5216e3          	bne	tp,t0,80000200 <test_12+0x8>

80000218 <test_13>:
80000218:	00d00193          	li	gp,13
8000021c:	00000213          	li	tp,0
80000220:	fff00093          	li	ra,-1
80000224:	00000113          	li	sp,0
80000228:	00000013          	nop
8000022c:	1a20de63          	bge	ra,sp,800003e8 <fail>
80000230:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000234:	00200293          	li	t0,2
80000238:	fe5214e3          	bne	tp,t0,80000220 <test_13+0x8>

8000023c <test_14>:
8000023c:	00e00193          	li	gp,14
80000240:	00000213          	li	tp,0
80000244:	fff00093          	li	ra,-1
80000248:	00000113          	li	sp,0
8000024c:	00000013          	nop
80000250:	00000013          	nop
80000254:	1820da63          	bge	ra,sp,800003e8 <fail>
80000258:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000025c:	00200293          	li	t0,2
80000260:	fe5212e3          	bne	tp,t0,80000244 <test_14+0x8>

80000264 <test_15>:
80000264:	00f00193          	li	gp,15
80000268:	00000213          	li	tp,0
8000026c:	fff00093          	li	ra,-1
80000270:	00000013          	nop
80000274:	00000113          	li	sp,0
80000278:	1620d863          	bge	ra,sp,800003e8 <fail>
8000027c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000280:	00200293          	li	t0,2
80000284:	fe5214e3          	bne	tp,t0,8000026c <test_15+0x8>

80000288 <test_16>:
80000288:	01000193          	li	gp,16
8000028c:	00000213          	li	tp,0
80000290:	fff00093          	li	ra,-1
80000294:	00000013          	nop
80000298:	00000113          	li	sp,0
8000029c:	00000013          	nop
800002a0:	1420d463          	bge	ra,sp,800003e8 <fail>
800002a4:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002a8:	00200293          	li	t0,2
800002ac:	fe5212e3          	bne	tp,t0,80000290 <test_16+0x8>

800002b0 <test_17>:
800002b0:	01100193          	li	gp,17
800002b4:	00000213          	li	tp,0
800002b8:	fff00093          	li	ra,-1
800002bc:	00000013          	nop
800002c0:	00000013          	nop
800002c4:	00000113          	li	sp,0
800002c8:	1220d063          	bge	ra,sp,800003e8 <fail>
800002cc:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002d0:	00200293          	li	t0,2
800002d4:	fe5212e3          	bne	tp,t0,800002b8 <test_17+0x8>

800002d8 <test_18>:
800002d8:	01200193          	li	gp,18
800002dc:	00000213          	li	tp,0
800002e0:	fff00093          	li	ra,-1
800002e4:	00000113          	li	sp,0
800002e8:	1020d063          	bge	ra,sp,800003e8 <fail>
800002ec:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002f0:	00200293          	li	t0,2
800002f4:	fe5216e3          	bne	tp,t0,800002e0 <test_18+0x8>

800002f8 <test_19>:
800002f8:	01300193          	li	gp,19
800002fc:	00000213          	li	tp,0
80000300:	fff00093          	li	ra,-1
80000304:	00000113          	li	sp,0
80000308:	00000013          	nop
8000030c:	0c20de63          	bge	ra,sp,800003e8 <fail>
80000310:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000314:	00200293          	li	t0,2
80000318:	fe5214e3          	bne	tp,t0,80000300 <test_19+0x8>

8000031c <test_20>:
8000031c:	01400193          	li	gp,20
80000320:	00000213          	li	tp,0
80000324:	fff00093          	li	ra,-1
80000328:	00000113          	li	sp,0
8000032c:	00000013          	nop
80000330:	00000013          	nop
80000334:	0a20da63          	bge	ra,sp,800003e8 <fail>
80000338:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000033c:	00200293          	li	t0,2
80000340:	fe5212e3          	bne	tp,t0,80000324 <test_20+0x8>

80000344 <test_21>:
80000344:	01500193          	li	gp,21
80000348:	00000213          	li	tp,0
8000034c:	fff00093          	li	ra,-1
80000350:	00000013          	nop
80000354:	00000113          	li	sp,0
80000358:	0820d863          	bge	ra,sp,800003e8 <fail>
8000035c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000360:	00200293          	li	t0,2
80000364:	fe5214e3          	bne	tp,t0,8000034c <test_21+0x8>

80000368 <test_22>:
80000368:	01600193          	li	gp,22
8000036c:	00000213          	li	tp,0
80000370:	fff00093          	li	ra,-1
80000374:	00000013          	nop
80000378:	00000113          	li	sp,0
8000037c:	00000013          	nop
80000380:	0620d463          	bge	ra,sp,800003e8 <fail>
80000384:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000388:	00200293          	li	t0,2
8000038c:	fe5212e3          	bne	tp,t0,80000370 <test_22+0x8>

80000390 <test_23>:
80000390:	01700193          	li	gp,23
80000394:	00000213          	li	tp,0
80000398:	fff00093          	li	ra,-1
8000039c:	00000013          	nop
800003a0:	00000013          	nop
800003a4:	00000113          	li	sp,0
800003a8:	0420d063          	bge	ra,sp,800003e8 <fail>
800003ac:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800003b0:	00200293          	li	t0,2
800003b4:	fe5212e3          	bne	tp,t0,80000398 <test_23+0x8>

800003b8 <test_24>:
800003b8:	01800193          	li	gp,24
800003bc:	00100093          	li	ra,1
800003c0:	0000da63          	bgez	ra,800003d4 <test_24+0x1c>
800003c4:	00108093          	addi	ra,ra,1
800003c8:	00108093          	addi	ra,ra,1
800003cc:	00108093          	addi	ra,ra,1
800003d0:	00108093          	addi	ra,ra,1
800003d4:	00108093          	addi	ra,ra,1
800003d8:	00108093          	addi	ra,ra,1
800003dc:	00300393          	li	t2,3
800003e0:	00709463          	bne	ra,t2,800003e8 <fail>
800003e4:	00301a63          	bne	zero,gp,800003f8 <pass>

800003e8 <fail>:
800003e8:	803002b7          	lui	t0,0x80300
800003ec:	55500313          	li	t1,1365
800003f0:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
800003f4:	c11ff06f          	j	80000004 <loop>

800003f8 <pass>:
800003f8:	803002b7          	lui	t0,0x80300
800003fc:	66600313          	li	t1,1638
80000400:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
80000404:	c01ff06f          	j	80000004 <loop>
80000408:	c0001073          	unimp
8000040c:	0000                	unimp
8000040e:	0000                	unimp
80000410:	0000                	unimp
80000412:	0000                	unimp
80000414:	0000                	unimp
80000416:	0000                	unimp
80000418:	0000                	unimp
8000041a:	0000                	unimp
8000041c:	0000                	unimp
8000041e:	0000                	unimp
80000420:	0000                	unimp
80000422:	0000                	unimp
80000424:	0000                	unimp
80000426:	0000                	unimp
80000428:	0000                	unimp
8000042a:	0000                	unimp
8000042c:	0000                	unimp
8000042e:	0000                	unimp
80000430:	0000                	unimp
80000432:	0000                	unimp
80000434:	0000                	unimp
80000436:	0000                	unimp
80000438:	0000                	unimp
8000043a:	0000                	unimp
8000043c:	0000                	unimp
8000043e:	0000                	unimp
