
rv32ui-p-add：     文件格式 elf32-littleriscv


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
800000d4:	00208733          	add	a4,ra,sp
800000d8:	00000393          	li	t2,0
800000dc:	4c771663          	bne	a4,t2,800005a8 <fail>

800000e0 <test_3>:
800000e0:	00300193          	li	gp,3
800000e4:	00100093          	li	ra,1
800000e8:	00100113          	li	sp,1
800000ec:	00208733          	add	a4,ra,sp
800000f0:	00200393          	li	t2,2
800000f4:	4a771a63          	bne	a4,t2,800005a8 <fail>

800000f8 <test_4>:
800000f8:	00400193          	li	gp,4
800000fc:	00300093          	li	ra,3
80000100:	00700113          	li	sp,7
80000104:	00208733          	add	a4,ra,sp
80000108:	00a00393          	li	t2,10
8000010c:	48771e63          	bne	a4,t2,800005a8 <fail>

80000110 <test_5>:
80000110:	00500193          	li	gp,5
80000114:	00000093          	li	ra,0
80000118:	ffff8137          	lui	sp,0xffff8
8000011c:	00208733          	add	a4,ra,sp
80000120:	ffff83b7          	lui	t2,0xffff8
80000124:	48771263          	bne	a4,t2,800005a8 <fail>

80000128 <test_6>:
80000128:	00600193          	li	gp,6
8000012c:	800000b7          	lui	ra,0x80000
80000130:	00000113          	li	sp,0
80000134:	00208733          	add	a4,ra,sp
80000138:	800003b7          	lui	t2,0x80000
8000013c:	46771663          	bne	a4,t2,800005a8 <fail>

80000140 <test_7>:
80000140:	00700193          	li	gp,7
80000144:	800000b7          	lui	ra,0x80000
80000148:	ffff8137          	lui	sp,0xffff8
8000014c:	00208733          	add	a4,ra,sp
80000150:	7fff83b7          	lui	t2,0x7fff8
80000154:	44771a63          	bne	a4,t2,800005a8 <fail>

80000158 <test_8>:
80000158:	00800193          	li	gp,8
8000015c:	00000093          	li	ra,0
80000160:	00008137          	lui	sp,0x8
80000164:	fff10113          	addi	sp,sp,-1 # 7fff <_start-0x7fff8001>
80000168:	00208733          	add	a4,ra,sp
8000016c:	000083b7          	lui	t2,0x8
80000170:	fff38393          	addi	t2,t2,-1 # 7fff <_start-0x7fff8001>
80000174:	42771a63          	bne	a4,t2,800005a8 <fail>

80000178 <test_9>:
80000178:	00900193          	li	gp,9
8000017c:	800000b7          	lui	ra,0x80000
80000180:	fff08093          	addi	ra,ra,-1 # 7fffffff <_end+0xffffdfff>
80000184:	00000113          	li	sp,0
80000188:	00208733          	add	a4,ra,sp
8000018c:	800003b7          	lui	t2,0x80000
80000190:	fff38393          	addi	t2,t2,-1 # 7fffffff <_end+0xffffdfff>
80000194:	40771a63          	bne	a4,t2,800005a8 <fail>

80000198 <test_10>:
80000198:	00a00193          	li	gp,10
8000019c:	800000b7          	lui	ra,0x80000
800001a0:	fff08093          	addi	ra,ra,-1 # 7fffffff <_end+0xffffdfff>
800001a4:	00008137          	lui	sp,0x8
800001a8:	fff10113          	addi	sp,sp,-1 # 7fff <_start-0x7fff8001>
800001ac:	00208733          	add	a4,ra,sp
800001b0:	800083b7          	lui	t2,0x80008
800001b4:	ffe38393          	addi	t2,t2,-2 # 80007ffe <_end+0x5ffe>
800001b8:	3e771863          	bne	a4,t2,800005a8 <fail>

800001bc <test_11>:
800001bc:	00b00193          	li	gp,11
800001c0:	800000b7          	lui	ra,0x80000
800001c4:	00008137          	lui	sp,0x8
800001c8:	fff10113          	addi	sp,sp,-1 # 7fff <_start-0x7fff8001>
800001cc:	00208733          	add	a4,ra,sp
800001d0:	800083b7          	lui	t2,0x80008
800001d4:	fff38393          	addi	t2,t2,-1 # 80007fff <_end+0x5fff>
800001d8:	3c771863          	bne	a4,t2,800005a8 <fail>

800001dc <test_12>:
800001dc:	00c00193          	li	gp,12
800001e0:	800000b7          	lui	ra,0x80000
800001e4:	fff08093          	addi	ra,ra,-1 # 7fffffff <_end+0xffffdfff>
800001e8:	ffff8137          	lui	sp,0xffff8
800001ec:	00208733          	add	a4,ra,sp
800001f0:	7fff83b7          	lui	t2,0x7fff8
800001f4:	fff38393          	addi	t2,t2,-1 # 7fff7fff <_start-0x8001>
800001f8:	3a771863          	bne	a4,t2,800005a8 <fail>

800001fc <test_13>:
800001fc:	00d00193          	li	gp,13
80000200:	00000093          	li	ra,0
80000204:	fff00113          	li	sp,-1
80000208:	00208733          	add	a4,ra,sp
8000020c:	fff00393          	li	t2,-1
80000210:	38771c63          	bne	a4,t2,800005a8 <fail>

80000214 <test_14>:
80000214:	00e00193          	li	gp,14
80000218:	fff00093          	li	ra,-1
8000021c:	00100113          	li	sp,1
80000220:	00208733          	add	a4,ra,sp
80000224:	00000393          	li	t2,0
80000228:	38771063          	bne	a4,t2,800005a8 <fail>

8000022c <test_15>:
8000022c:	00f00193          	li	gp,15
80000230:	fff00093          	li	ra,-1
80000234:	fff00113          	li	sp,-1
80000238:	00208733          	add	a4,ra,sp
8000023c:	ffe00393          	li	t2,-2
80000240:	36771463          	bne	a4,t2,800005a8 <fail>

80000244 <test_16>:
80000244:	01000193          	li	gp,16
80000248:	00100093          	li	ra,1
8000024c:	80000137          	lui	sp,0x80000
80000250:	fff10113          	addi	sp,sp,-1 # 7fffffff <_end+0xffffdfff>
80000254:	00208733          	add	a4,ra,sp
80000258:	800003b7          	lui	t2,0x80000
8000025c:	34771663          	bne	a4,t2,800005a8 <fail>

80000260 <test_17>:
80000260:	01100193          	li	gp,17
80000264:	00d00093          	li	ra,13
80000268:	00b00113          	li	sp,11
8000026c:	002080b3          	add	ra,ra,sp
80000270:	01800393          	li	t2,24
80000274:	32709a63          	bne	ra,t2,800005a8 <fail>

80000278 <test_18>:
80000278:	01200193          	li	gp,18
8000027c:	00e00093          	li	ra,14
80000280:	00b00113          	li	sp,11
80000284:	00208133          	add	sp,ra,sp
80000288:	01900393          	li	t2,25
8000028c:	30711e63          	bne	sp,t2,800005a8 <fail>

80000290 <test_19>:
80000290:	01300193          	li	gp,19
80000294:	00d00093          	li	ra,13
80000298:	001080b3          	add	ra,ra,ra
8000029c:	01a00393          	li	t2,26
800002a0:	30709463          	bne	ra,t2,800005a8 <fail>

800002a4 <test_20>:
800002a4:	01400193          	li	gp,20
800002a8:	00000213          	li	tp,0
800002ac:	00d00093          	li	ra,13
800002b0:	00b00113          	li	sp,11
800002b4:	00208733          	add	a4,ra,sp
800002b8:	00070313          	mv	t1,a4
800002bc:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002c0:	00200293          	li	t0,2
800002c4:	fe5214e3          	bne	tp,t0,800002ac <test_20+0x8>
800002c8:	01800393          	li	t2,24
800002cc:	2c731e63          	bne	t1,t2,800005a8 <fail>

800002d0 <test_21>:
800002d0:	01500193          	li	gp,21
800002d4:	00000213          	li	tp,0
800002d8:	00e00093          	li	ra,14
800002dc:	00b00113          	li	sp,11
800002e0:	00208733          	add	a4,ra,sp
800002e4:	00000013          	nop
800002e8:	00070313          	mv	t1,a4
800002ec:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002f0:	00200293          	li	t0,2
800002f4:	fe5212e3          	bne	tp,t0,800002d8 <test_21+0x8>
800002f8:	01900393          	li	t2,25
800002fc:	2a731663          	bne	t1,t2,800005a8 <fail>

80000300 <test_22>:
80000300:	01600193          	li	gp,22
80000304:	00000213          	li	tp,0
80000308:	00f00093          	li	ra,15
8000030c:	00b00113          	li	sp,11
80000310:	00208733          	add	a4,ra,sp
80000314:	00000013          	nop
80000318:	00000013          	nop
8000031c:	00070313          	mv	t1,a4
80000320:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000324:	00200293          	li	t0,2
80000328:	fe5210e3          	bne	tp,t0,80000308 <test_22+0x8>
8000032c:	01a00393          	li	t2,26
80000330:	26731c63          	bne	t1,t2,800005a8 <fail>

80000334 <test_23>:
80000334:	01700193          	li	gp,23
80000338:	00000213          	li	tp,0
8000033c:	00d00093          	li	ra,13
80000340:	00b00113          	li	sp,11
80000344:	00208733          	add	a4,ra,sp
80000348:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000034c:	00200293          	li	t0,2
80000350:	fe5216e3          	bne	tp,t0,8000033c <test_23+0x8>
80000354:	01800393          	li	t2,24
80000358:	24771863          	bne	a4,t2,800005a8 <fail>

8000035c <test_24>:
8000035c:	01800193          	li	gp,24
80000360:	00000213          	li	tp,0
80000364:	00e00093          	li	ra,14
80000368:	00b00113          	li	sp,11
8000036c:	00000013          	nop
80000370:	00208733          	add	a4,ra,sp
80000374:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000378:	00200293          	li	t0,2
8000037c:	fe5214e3          	bne	tp,t0,80000364 <test_24+0x8>
80000380:	01900393          	li	t2,25
80000384:	22771263          	bne	a4,t2,800005a8 <fail>

80000388 <test_25>:
80000388:	01900193          	li	gp,25
8000038c:	00000213          	li	tp,0
80000390:	00f00093          	li	ra,15
80000394:	00b00113          	li	sp,11
80000398:	00000013          	nop
8000039c:	00000013          	nop
800003a0:	00208733          	add	a4,ra,sp
800003a4:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800003a8:	00200293          	li	t0,2
800003ac:	fe5212e3          	bne	tp,t0,80000390 <test_25+0x8>
800003b0:	01a00393          	li	t2,26
800003b4:	1e771a63          	bne	a4,t2,800005a8 <fail>

800003b8 <test_26>:
800003b8:	01a00193          	li	gp,26
800003bc:	00000213          	li	tp,0
800003c0:	00d00093          	li	ra,13
800003c4:	00000013          	nop
800003c8:	00b00113          	li	sp,11
800003cc:	00208733          	add	a4,ra,sp
800003d0:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800003d4:	00200293          	li	t0,2
800003d8:	fe5214e3          	bne	tp,t0,800003c0 <test_26+0x8>
800003dc:	01800393          	li	t2,24
800003e0:	1c771463          	bne	a4,t2,800005a8 <fail>

800003e4 <test_27>:
800003e4:	01b00193          	li	gp,27
800003e8:	00000213          	li	tp,0
800003ec:	00e00093          	li	ra,14
800003f0:	00000013          	nop
800003f4:	00b00113          	li	sp,11
800003f8:	00000013          	nop
800003fc:	00208733          	add	a4,ra,sp
80000400:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000404:	00200293          	li	t0,2
80000408:	fe5212e3          	bne	tp,t0,800003ec <test_27+0x8>
8000040c:	01900393          	li	t2,25
80000410:	18771c63          	bne	a4,t2,800005a8 <fail>

80000414 <test_28>:
80000414:	01c00193          	li	gp,28
80000418:	00000213          	li	tp,0
8000041c:	00f00093          	li	ra,15
80000420:	00000013          	nop
80000424:	00000013          	nop
80000428:	00b00113          	li	sp,11
8000042c:	00208733          	add	a4,ra,sp
80000430:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000434:	00200293          	li	t0,2
80000438:	fe5212e3          	bne	tp,t0,8000041c <test_28+0x8>
8000043c:	01a00393          	li	t2,26
80000440:	16771463          	bne	a4,t2,800005a8 <fail>

80000444 <test_29>:
80000444:	01d00193          	li	gp,29
80000448:	00000213          	li	tp,0
8000044c:	00b00113          	li	sp,11
80000450:	00d00093          	li	ra,13
80000454:	00208733          	add	a4,ra,sp
80000458:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000045c:	00200293          	li	t0,2
80000460:	fe5216e3          	bne	tp,t0,8000044c <test_29+0x8>
80000464:	01800393          	li	t2,24
80000468:	14771063          	bne	a4,t2,800005a8 <fail>

8000046c <test_30>:
8000046c:	01e00193          	li	gp,30
80000470:	00000213          	li	tp,0
80000474:	00b00113          	li	sp,11
80000478:	00e00093          	li	ra,14
8000047c:	00000013          	nop
80000480:	00208733          	add	a4,ra,sp
80000484:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000488:	00200293          	li	t0,2
8000048c:	fe5214e3          	bne	tp,t0,80000474 <test_30+0x8>
80000490:	01900393          	li	t2,25
80000494:	10771a63          	bne	a4,t2,800005a8 <fail>

80000498 <test_31>:
80000498:	01f00193          	li	gp,31
8000049c:	00000213          	li	tp,0
800004a0:	00b00113          	li	sp,11
800004a4:	00f00093          	li	ra,15
800004a8:	00000013          	nop
800004ac:	00000013          	nop
800004b0:	00208733          	add	a4,ra,sp
800004b4:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800004b8:	00200293          	li	t0,2
800004bc:	fe5212e3          	bne	tp,t0,800004a0 <test_31+0x8>
800004c0:	01a00393          	li	t2,26
800004c4:	0e771263          	bne	a4,t2,800005a8 <fail>

800004c8 <test_32>:
800004c8:	02000193          	li	gp,32
800004cc:	00000213          	li	tp,0
800004d0:	00b00113          	li	sp,11
800004d4:	00000013          	nop
800004d8:	00d00093          	li	ra,13
800004dc:	00208733          	add	a4,ra,sp
800004e0:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800004e4:	00200293          	li	t0,2
800004e8:	fe5214e3          	bne	tp,t0,800004d0 <test_32+0x8>
800004ec:	01800393          	li	t2,24
800004f0:	0a771c63          	bne	a4,t2,800005a8 <fail>

800004f4 <test_33>:
800004f4:	02100193          	li	gp,33
800004f8:	00000213          	li	tp,0
800004fc:	00b00113          	li	sp,11
80000500:	00000013          	nop
80000504:	00e00093          	li	ra,14
80000508:	00000013          	nop
8000050c:	00208733          	add	a4,ra,sp
80000510:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000514:	00200293          	li	t0,2
80000518:	fe5212e3          	bne	tp,t0,800004fc <test_33+0x8>
8000051c:	01900393          	li	t2,25
80000520:	08771463          	bne	a4,t2,800005a8 <fail>

80000524 <test_34>:
80000524:	02200193          	li	gp,34
80000528:	00000213          	li	tp,0
8000052c:	00b00113          	li	sp,11
80000530:	00000013          	nop
80000534:	00000013          	nop
80000538:	00f00093          	li	ra,15
8000053c:	00208733          	add	a4,ra,sp
80000540:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000544:	00200293          	li	t0,2
80000548:	fe5212e3          	bne	tp,t0,8000052c <test_34+0x8>
8000054c:	01a00393          	li	t2,26
80000550:	04771c63          	bne	a4,t2,800005a8 <fail>

80000554 <test_35>:
80000554:	02300193          	li	gp,35
80000558:	00f00093          	li	ra,15
8000055c:	00100133          	add	sp,zero,ra
80000560:	00f00393          	li	t2,15
80000564:	04711263          	bne	sp,t2,800005a8 <fail>

80000568 <test_36>:
80000568:	02400193          	li	gp,36
8000056c:	02000093          	li	ra,32
80000570:	00008133          	add	sp,ra,zero
80000574:	02000393          	li	t2,32
80000578:	02711863          	bne	sp,t2,800005a8 <fail>

8000057c <test_37>:
8000057c:	02500193          	li	gp,37
80000580:	000000b3          	add	ra,zero,zero
80000584:	00000393          	li	t2,0
80000588:	02709063          	bne	ra,t2,800005a8 <fail>

8000058c <test_38>:
8000058c:	02600193          	li	gp,38
80000590:	01000093          	li	ra,16
80000594:	01e00113          	li	sp,30
80000598:	00208033          	add	zero,ra,sp
8000059c:	00000393          	li	t2,0
800005a0:	00701463          	bne	zero,t2,800005a8 <fail>
800005a4:	00301a63          	bne	zero,gp,800005b8 <pass>

800005a8 <fail>:
800005a8:	803002b7          	lui	t0,0x80300
800005ac:	55500313          	li	t1,1365
800005b0:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
800005b4:	a51ff06f          	j	80000004 <loop>

800005b8 <pass>:
800005b8:	803002b7          	lui	t0,0x80300
800005bc:	66600313          	li	t1,1638
800005c0:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
800005c4:	a41ff06f          	j	80000004 <loop>
800005c8:	c0001073          	unimp
800005cc:	0000                	unimp
800005ce:	0000                	unimp
800005d0:	0000                	unimp
800005d2:	0000                	unimp
800005d4:	0000                	unimp
800005d6:	0000                	unimp
800005d8:	0000                	unimp
800005da:	0000                	unimp
800005dc:	0000                	unimp
800005de:	0000                	unimp
800005e0:	0000                	unimp
800005e2:	0000                	unimp
800005e4:	0000                	unimp
800005e6:	0000                	unimp
800005e8:	0000                	unimp
800005ea:	0000                	unimp
800005ec:	0000                	unimp
800005ee:	0000                	unimp
800005f0:	0000                	unimp
800005f2:	0000                	unimp
800005f4:	0000                	unimp
800005f6:	0000                	unimp
800005f8:	0000                	unimp
800005fa:	0000                	unimp
800005fc:	0000                	unimp
800005fe:	0000                	unimp
