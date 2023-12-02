
rv32ui-p-bgeu：     文件格式 elf32-littleriscv


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
800000d4:	0020f663          	bgeu	ra,sp,800000e0 <test_2+0x18>
800000d8:	34301263          	bne	zero,gp,8000041c <fail>
800000dc:	00301663          	bne	zero,gp,800000e8 <test_3>
800000e0:	fe20fee3          	bgeu	ra,sp,800000dc <test_2+0x14>
800000e4:	32301c63          	bne	zero,gp,8000041c <fail>

800000e8 <test_3>:
800000e8:	00300193          	li	gp,3
800000ec:	00100093          	li	ra,1
800000f0:	00100113          	li	sp,1
800000f4:	0020f663          	bgeu	ra,sp,80000100 <test_3+0x18>
800000f8:	32301263          	bne	zero,gp,8000041c <fail>
800000fc:	00301663          	bne	zero,gp,80000108 <test_4>
80000100:	fe20fee3          	bgeu	ra,sp,800000fc <test_3+0x14>
80000104:	30301c63          	bne	zero,gp,8000041c <fail>

80000108 <test_4>:
80000108:	00400193          	li	gp,4
8000010c:	fff00093          	li	ra,-1
80000110:	fff00113          	li	sp,-1
80000114:	0020f663          	bgeu	ra,sp,80000120 <test_4+0x18>
80000118:	30301263          	bne	zero,gp,8000041c <fail>
8000011c:	00301663          	bne	zero,gp,80000128 <test_5>
80000120:	fe20fee3          	bgeu	ra,sp,8000011c <test_4+0x14>
80000124:	2e301c63          	bne	zero,gp,8000041c <fail>

80000128 <test_5>:
80000128:	00500193          	li	gp,5
8000012c:	00100093          	li	ra,1
80000130:	00000113          	li	sp,0
80000134:	0020f663          	bgeu	ra,sp,80000140 <test_5+0x18>
80000138:	2e301263          	bne	zero,gp,8000041c <fail>
8000013c:	00301663          	bne	zero,gp,80000148 <test_6>
80000140:	fe20fee3          	bgeu	ra,sp,8000013c <test_5+0x14>
80000144:	2c301c63          	bne	zero,gp,8000041c <fail>

80000148 <test_6>:
80000148:	00600193          	li	gp,6
8000014c:	fff00093          	li	ra,-1
80000150:	ffe00113          	li	sp,-2
80000154:	0020f663          	bgeu	ra,sp,80000160 <test_6+0x18>
80000158:	2c301263          	bne	zero,gp,8000041c <fail>
8000015c:	00301663          	bne	zero,gp,80000168 <test_7>
80000160:	fe20fee3          	bgeu	ra,sp,8000015c <test_6+0x14>
80000164:	2a301c63          	bne	zero,gp,8000041c <fail>

80000168 <test_7>:
80000168:	00700193          	li	gp,7
8000016c:	fff00093          	li	ra,-1
80000170:	00000113          	li	sp,0
80000174:	0020f663          	bgeu	ra,sp,80000180 <test_7+0x18>
80000178:	2a301263          	bne	zero,gp,8000041c <fail>
8000017c:	00301663          	bne	zero,gp,80000188 <test_8>
80000180:	fe20fee3          	bgeu	ra,sp,8000017c <test_7+0x14>
80000184:	28301c63          	bne	zero,gp,8000041c <fail>

80000188 <test_8>:
80000188:	00800193          	li	gp,8
8000018c:	00000093          	li	ra,0
80000190:	00100113          	li	sp,1
80000194:	0020f463          	bgeu	ra,sp,8000019c <test_8+0x14>
80000198:	00301463          	bne	zero,gp,800001a0 <test_8+0x18>
8000019c:	28301063          	bne	zero,gp,8000041c <fail>
800001a0:	fe20fee3          	bgeu	ra,sp,8000019c <test_8+0x14>

800001a4 <test_9>:
800001a4:	00900193          	li	gp,9
800001a8:	ffe00093          	li	ra,-2
800001ac:	fff00113          	li	sp,-1
800001b0:	0020f463          	bgeu	ra,sp,800001b8 <test_9+0x14>
800001b4:	00301463          	bne	zero,gp,800001bc <test_9+0x18>
800001b8:	26301263          	bne	zero,gp,8000041c <fail>
800001bc:	fe20fee3          	bgeu	ra,sp,800001b8 <test_9+0x14>

800001c0 <test_10>:
800001c0:	00a00193          	li	gp,10
800001c4:	00000093          	li	ra,0
800001c8:	fff00113          	li	sp,-1
800001cc:	0020f463          	bgeu	ra,sp,800001d4 <test_10+0x14>
800001d0:	00301463          	bne	zero,gp,800001d8 <test_10+0x18>
800001d4:	24301463          	bne	zero,gp,8000041c <fail>
800001d8:	fe20fee3          	bgeu	ra,sp,800001d4 <test_10+0x14>

800001dc <test_11>:
800001dc:	00b00193          	li	gp,11
800001e0:	800000b7          	lui	ra,0x80000
800001e4:	fff08093          	addi	ra,ra,-1 # 7fffffff <_end+0xffffdfff>
800001e8:	80000137          	lui	sp,0x80000
800001ec:	0020f463          	bgeu	ra,sp,800001f4 <test_11+0x18>
800001f0:	00301463          	bne	zero,gp,800001f8 <test_11+0x1c>
800001f4:	22301463          	bne	zero,gp,8000041c <fail>
800001f8:	fe20fee3          	bgeu	ra,sp,800001f4 <test_11+0x18>

800001fc <test_12>:
800001fc:	00c00193          	li	gp,12
80000200:	00000213          	li	tp,0
80000204:	f00000b7          	lui	ra,0xf0000
80000208:	fff08093          	addi	ra,ra,-1 # efffffff <_end+0x6fffdfff>
8000020c:	f0000137          	lui	sp,0xf0000
80000210:	2020f663          	bgeu	ra,sp,8000041c <fail>
80000214:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000218:	00200293          	li	t0,2
8000021c:	fe5214e3          	bne	tp,t0,80000204 <test_12+0x8>

80000220 <test_13>:
80000220:	00d00193          	li	gp,13
80000224:	00000213          	li	tp,0
80000228:	f00000b7          	lui	ra,0xf0000
8000022c:	fff08093          	addi	ra,ra,-1 # efffffff <_end+0x6fffdfff>
80000230:	f0000137          	lui	sp,0xf0000
80000234:	00000013          	nop
80000238:	1e20f263          	bgeu	ra,sp,8000041c <fail>
8000023c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000240:	00200293          	li	t0,2
80000244:	fe5212e3          	bne	tp,t0,80000228 <test_13+0x8>

80000248 <test_14>:
80000248:	00e00193          	li	gp,14
8000024c:	00000213          	li	tp,0
80000250:	f00000b7          	lui	ra,0xf0000
80000254:	fff08093          	addi	ra,ra,-1 # efffffff <_end+0x6fffdfff>
80000258:	f0000137          	lui	sp,0xf0000
8000025c:	00000013          	nop
80000260:	00000013          	nop
80000264:	1a20fc63          	bgeu	ra,sp,8000041c <fail>
80000268:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000026c:	00200293          	li	t0,2
80000270:	fe5210e3          	bne	tp,t0,80000250 <test_14+0x8>

80000274 <test_15>:
80000274:	00f00193          	li	gp,15
80000278:	00000213          	li	tp,0
8000027c:	f00000b7          	lui	ra,0xf0000
80000280:	fff08093          	addi	ra,ra,-1 # efffffff <_end+0x6fffdfff>
80000284:	00000013          	nop
80000288:	f0000137          	lui	sp,0xf0000
8000028c:	1820f863          	bgeu	ra,sp,8000041c <fail>
80000290:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000294:	00200293          	li	t0,2
80000298:	fe5212e3          	bne	tp,t0,8000027c <test_15+0x8>

8000029c <test_16>:
8000029c:	01000193          	li	gp,16
800002a0:	00000213          	li	tp,0
800002a4:	f00000b7          	lui	ra,0xf0000
800002a8:	fff08093          	addi	ra,ra,-1 # efffffff <_end+0x6fffdfff>
800002ac:	00000013          	nop
800002b0:	f0000137          	lui	sp,0xf0000
800002b4:	00000013          	nop
800002b8:	1620f263          	bgeu	ra,sp,8000041c <fail>
800002bc:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002c0:	00200293          	li	t0,2
800002c4:	fe5210e3          	bne	tp,t0,800002a4 <test_16+0x8>

800002c8 <test_17>:
800002c8:	01100193          	li	gp,17
800002cc:	00000213          	li	tp,0
800002d0:	f00000b7          	lui	ra,0xf0000
800002d4:	fff08093          	addi	ra,ra,-1 # efffffff <_end+0x6fffdfff>
800002d8:	00000013          	nop
800002dc:	00000013          	nop
800002e0:	f0000137          	lui	sp,0xf0000
800002e4:	1220fc63          	bgeu	ra,sp,8000041c <fail>
800002e8:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002ec:	00200293          	li	t0,2
800002f0:	fe5210e3          	bne	tp,t0,800002d0 <test_17+0x8>

800002f4 <test_18>:
800002f4:	01200193          	li	gp,18
800002f8:	00000213          	li	tp,0
800002fc:	f00000b7          	lui	ra,0xf0000
80000300:	fff08093          	addi	ra,ra,-1 # efffffff <_end+0x6fffdfff>
80000304:	f0000137          	lui	sp,0xf0000
80000308:	1020fa63          	bgeu	ra,sp,8000041c <fail>
8000030c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000310:	00200293          	li	t0,2
80000314:	fe5214e3          	bne	tp,t0,800002fc <test_18+0x8>

80000318 <test_19>:
80000318:	01300193          	li	gp,19
8000031c:	00000213          	li	tp,0
80000320:	f00000b7          	lui	ra,0xf0000
80000324:	fff08093          	addi	ra,ra,-1 # efffffff <_end+0x6fffdfff>
80000328:	f0000137          	lui	sp,0xf0000
8000032c:	00000013          	nop
80000330:	0e20f663          	bgeu	ra,sp,8000041c <fail>
80000334:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000338:	00200293          	li	t0,2
8000033c:	fe5212e3          	bne	tp,t0,80000320 <test_19+0x8>

80000340 <test_20>:
80000340:	01400193          	li	gp,20
80000344:	00000213          	li	tp,0
80000348:	f00000b7          	lui	ra,0xf0000
8000034c:	fff08093          	addi	ra,ra,-1 # efffffff <_end+0x6fffdfff>
80000350:	f0000137          	lui	sp,0xf0000
80000354:	00000013          	nop
80000358:	00000013          	nop
8000035c:	0c20f063          	bgeu	ra,sp,8000041c <fail>
80000360:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000364:	00200293          	li	t0,2
80000368:	fe5210e3          	bne	tp,t0,80000348 <test_20+0x8>

8000036c <test_21>:
8000036c:	01500193          	li	gp,21
80000370:	00000213          	li	tp,0
80000374:	f00000b7          	lui	ra,0xf0000
80000378:	fff08093          	addi	ra,ra,-1 # efffffff <_end+0x6fffdfff>
8000037c:	00000013          	nop
80000380:	f0000137          	lui	sp,0xf0000
80000384:	0820fc63          	bgeu	ra,sp,8000041c <fail>
80000388:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000038c:	00200293          	li	t0,2
80000390:	fe5212e3          	bne	tp,t0,80000374 <test_21+0x8>

80000394 <test_22>:
80000394:	01600193          	li	gp,22
80000398:	00000213          	li	tp,0
8000039c:	f00000b7          	lui	ra,0xf0000
800003a0:	fff08093          	addi	ra,ra,-1 # efffffff <_end+0x6fffdfff>
800003a4:	00000013          	nop
800003a8:	f0000137          	lui	sp,0xf0000
800003ac:	00000013          	nop
800003b0:	0620f663          	bgeu	ra,sp,8000041c <fail>
800003b4:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800003b8:	00200293          	li	t0,2
800003bc:	fe5210e3          	bne	tp,t0,8000039c <test_22+0x8>

800003c0 <test_23>:
800003c0:	01700193          	li	gp,23
800003c4:	00000213          	li	tp,0
800003c8:	f00000b7          	lui	ra,0xf0000
800003cc:	fff08093          	addi	ra,ra,-1 # efffffff <_end+0x6fffdfff>
800003d0:	00000013          	nop
800003d4:	00000013          	nop
800003d8:	f0000137          	lui	sp,0xf0000
800003dc:	0420f063          	bgeu	ra,sp,8000041c <fail>
800003e0:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800003e4:	00200293          	li	t0,2
800003e8:	fe5210e3          	bne	tp,t0,800003c8 <test_23+0x8>

800003ec <test_24>:
800003ec:	01800193          	li	gp,24
800003f0:	00100093          	li	ra,1
800003f4:	0000fa63          	bgeu	ra,zero,80000408 <test_24+0x1c>
800003f8:	00108093          	addi	ra,ra,1
800003fc:	00108093          	addi	ra,ra,1
80000400:	00108093          	addi	ra,ra,1
80000404:	00108093          	addi	ra,ra,1
80000408:	00108093          	addi	ra,ra,1
8000040c:	00108093          	addi	ra,ra,1
80000410:	00300393          	li	t2,3
80000414:	00709463          	bne	ra,t2,8000041c <fail>
80000418:	00301a63          	bne	zero,gp,8000042c <pass>

8000041c <fail>:
8000041c:	803002b7          	lui	t0,0x80300
80000420:	55500313          	li	t1,1365
80000424:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
80000428:	bddff06f          	j	80000004 <loop>

8000042c <pass>:
8000042c:	803002b7          	lui	t0,0x80300
80000430:	66600313          	li	t1,1638
80000434:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
80000438:	bcdff06f          	j	80000004 <loop>
8000043c:	c0001073          	unimp
