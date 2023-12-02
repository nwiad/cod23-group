
rv32ui-p-and：     文件格式 elf32-littleriscv


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
800000d4:	0f0f1137          	lui	sp,0xf0f1
800000d8:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
800000dc:	0020f733          	and	a4,ra,sp
800000e0:	0f0013b7          	lui	t2,0xf001
800000e4:	f0038393          	addi	t2,t2,-256 # f000f00 <_start-0x70fff100>
800000e8:	48771c63          	bne	a4,t2,80000580 <fail>

800000ec <test_3>:
800000ec:	00300193          	li	gp,3
800000f0:	0ff010b7          	lui	ra,0xff01
800000f4:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
800000f8:	f0f0f137          	lui	sp,0xf0f0f
800000fc:	0f010113          	addi	sp,sp,240 # f0f0f0f0 <_end+0x70f0d0f0>
80000100:	0020f733          	and	a4,ra,sp
80000104:	00f003b7          	lui	t2,0xf00
80000108:	0f038393          	addi	t2,t2,240 # f000f0 <_start-0x7f0fff10>
8000010c:	46771a63          	bne	a4,t2,80000580 <fail>

80000110 <test_4>:
80000110:	00400193          	li	gp,4
80000114:	00ff00b7          	lui	ra,0xff0
80000118:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
8000011c:	0f0f1137          	lui	sp,0xf0f1
80000120:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
80000124:	0020f733          	and	a4,ra,sp
80000128:	000f03b7          	lui	t2,0xf0
8000012c:	00f38393          	addi	t2,t2,15 # f000f <_start-0x7ff0fff1>
80000130:	44771863          	bne	a4,t2,80000580 <fail>

80000134 <test_5>:
80000134:	00500193          	li	gp,5
80000138:	f00ff0b7          	lui	ra,0xf00ff
8000013c:	00f08093          	addi	ra,ra,15 # f00ff00f <_end+0x700fd00f>
80000140:	f0f0f137          	lui	sp,0xf0f0f
80000144:	0f010113          	addi	sp,sp,240 # f0f0f0f0 <_end+0x70f0d0f0>
80000148:	0020f733          	and	a4,ra,sp
8000014c:	f000f3b7          	lui	t2,0xf000f
80000150:	42771863          	bne	a4,t2,80000580 <fail>

80000154 <test_6>:
80000154:	00600193          	li	gp,6
80000158:	ff0100b7          	lui	ra,0xff010
8000015c:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
80000160:	0f0f1137          	lui	sp,0xf0f1
80000164:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
80000168:	0020f0b3          	and	ra,ra,sp
8000016c:	0f0013b7          	lui	t2,0xf001
80000170:	f0038393          	addi	t2,t2,-256 # f000f00 <_start-0x70fff100>
80000174:	40709663          	bne	ra,t2,80000580 <fail>

80000178 <test_7>:
80000178:	00700193          	li	gp,7
8000017c:	0ff010b7          	lui	ra,0xff01
80000180:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
80000184:	f0f0f137          	lui	sp,0xf0f0f
80000188:	0f010113          	addi	sp,sp,240 # f0f0f0f0 <_end+0x70f0d0f0>
8000018c:	0020f133          	and	sp,ra,sp
80000190:	00f003b7          	lui	t2,0xf00
80000194:	0f038393          	addi	t2,t2,240 # f000f0 <_start-0x7f0fff10>
80000198:	3e711463          	bne	sp,t2,80000580 <fail>

8000019c <test_8>:
8000019c:	00800193          	li	gp,8
800001a0:	ff0100b7          	lui	ra,0xff010
800001a4:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
800001a8:	0010f0b3          	and	ra,ra,ra
800001ac:	ff0103b7          	lui	t2,0xff010
800001b0:	f0038393          	addi	t2,t2,-256 # ff00ff00 <_end+0x7f00df00>
800001b4:	3c709663          	bne	ra,t2,80000580 <fail>

800001b8 <test_9>:
800001b8:	00900193          	li	gp,9
800001bc:	00000213          	li	tp,0
800001c0:	ff0100b7          	lui	ra,0xff010
800001c4:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
800001c8:	0f0f1137          	lui	sp,0xf0f1
800001cc:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
800001d0:	0020f733          	and	a4,ra,sp
800001d4:	00070313          	mv	t1,a4
800001d8:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800001dc:	00200293          	li	t0,2
800001e0:	fe5210e3          	bne	tp,t0,800001c0 <test_9+0x8>
800001e4:	0f0013b7          	lui	t2,0xf001
800001e8:	f0038393          	addi	t2,t2,-256 # f000f00 <_start-0x70fff100>
800001ec:	38731a63          	bne	t1,t2,80000580 <fail>

800001f0 <test_10>:
800001f0:	00a00193          	li	gp,10
800001f4:	00000213          	li	tp,0
800001f8:	0ff010b7          	lui	ra,0xff01
800001fc:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
80000200:	f0f0f137          	lui	sp,0xf0f0f
80000204:	0f010113          	addi	sp,sp,240 # f0f0f0f0 <_end+0x70f0d0f0>
80000208:	0020f733          	and	a4,ra,sp
8000020c:	00000013          	nop
80000210:	00070313          	mv	t1,a4
80000214:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000218:	00200293          	li	t0,2
8000021c:	fc521ee3          	bne	tp,t0,800001f8 <test_10+0x8>
80000220:	00f003b7          	lui	t2,0xf00
80000224:	0f038393          	addi	t2,t2,240 # f000f0 <_start-0x7f0fff10>
80000228:	34731c63          	bne	t1,t2,80000580 <fail>

8000022c <test_11>:
8000022c:	00b00193          	li	gp,11
80000230:	00000213          	li	tp,0
80000234:	00ff00b7          	lui	ra,0xff0
80000238:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
8000023c:	0f0f1137          	lui	sp,0xf0f1
80000240:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
80000244:	0020f733          	and	a4,ra,sp
80000248:	00000013          	nop
8000024c:	00000013          	nop
80000250:	00070313          	mv	t1,a4
80000254:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000258:	00200293          	li	t0,2
8000025c:	fc521ce3          	bne	tp,t0,80000234 <test_11+0x8>
80000260:	000f03b7          	lui	t2,0xf0
80000264:	00f38393          	addi	t2,t2,15 # f000f <_start-0x7ff0fff1>
80000268:	30731c63          	bne	t1,t2,80000580 <fail>

8000026c <test_12>:
8000026c:	00c00193          	li	gp,12
80000270:	00000213          	li	tp,0
80000274:	ff0100b7          	lui	ra,0xff010
80000278:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
8000027c:	0f0f1137          	lui	sp,0xf0f1
80000280:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
80000284:	0020f733          	and	a4,ra,sp
80000288:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000028c:	00200293          	li	t0,2
80000290:	fe5212e3          	bne	tp,t0,80000274 <test_12+0x8>
80000294:	0f0013b7          	lui	t2,0xf001
80000298:	f0038393          	addi	t2,t2,-256 # f000f00 <_start-0x70fff100>
8000029c:	2e771263          	bne	a4,t2,80000580 <fail>

800002a0 <test_13>:
800002a0:	00d00193          	li	gp,13
800002a4:	00000213          	li	tp,0
800002a8:	0ff010b7          	lui	ra,0xff01
800002ac:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
800002b0:	f0f0f137          	lui	sp,0xf0f0f
800002b4:	0f010113          	addi	sp,sp,240 # f0f0f0f0 <_end+0x70f0d0f0>
800002b8:	00000013          	nop
800002bc:	0020f733          	and	a4,ra,sp
800002c0:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002c4:	00200293          	li	t0,2
800002c8:	fe5210e3          	bne	tp,t0,800002a8 <test_13+0x8>
800002cc:	00f003b7          	lui	t2,0xf00
800002d0:	0f038393          	addi	t2,t2,240 # f000f0 <_start-0x7f0fff10>
800002d4:	2a771663          	bne	a4,t2,80000580 <fail>

800002d8 <test_14>:
800002d8:	00e00193          	li	gp,14
800002dc:	00000213          	li	tp,0
800002e0:	00ff00b7          	lui	ra,0xff0
800002e4:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
800002e8:	0f0f1137          	lui	sp,0xf0f1
800002ec:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
800002f0:	00000013          	nop
800002f4:	00000013          	nop
800002f8:	0020f733          	and	a4,ra,sp
800002fc:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000300:	00200293          	li	t0,2
80000304:	fc521ee3          	bne	tp,t0,800002e0 <test_14+0x8>
80000308:	000f03b7          	lui	t2,0xf0
8000030c:	00f38393          	addi	t2,t2,15 # f000f <_start-0x7ff0fff1>
80000310:	26771863          	bne	a4,t2,80000580 <fail>

80000314 <test_15>:
80000314:	00f00193          	li	gp,15
80000318:	00000213          	li	tp,0
8000031c:	ff0100b7          	lui	ra,0xff010
80000320:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
80000324:	00000013          	nop
80000328:	0f0f1137          	lui	sp,0xf0f1
8000032c:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
80000330:	0020f733          	and	a4,ra,sp
80000334:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000338:	00200293          	li	t0,2
8000033c:	fe5210e3          	bne	tp,t0,8000031c <test_15+0x8>
80000340:	0f0013b7          	lui	t2,0xf001
80000344:	f0038393          	addi	t2,t2,-256 # f000f00 <_start-0x70fff100>
80000348:	22771c63          	bne	a4,t2,80000580 <fail>

8000034c <test_16>:
8000034c:	01000193          	li	gp,16
80000350:	00000213          	li	tp,0
80000354:	0ff010b7          	lui	ra,0xff01
80000358:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
8000035c:	00000013          	nop
80000360:	f0f0f137          	lui	sp,0xf0f0f
80000364:	0f010113          	addi	sp,sp,240 # f0f0f0f0 <_end+0x70f0d0f0>
80000368:	00000013          	nop
8000036c:	0020f733          	and	a4,ra,sp
80000370:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000374:	00200293          	li	t0,2
80000378:	fc521ee3          	bne	tp,t0,80000354 <test_16+0x8>
8000037c:	00f003b7          	lui	t2,0xf00
80000380:	0f038393          	addi	t2,t2,240 # f000f0 <_start-0x7f0fff10>
80000384:	1e771e63          	bne	a4,t2,80000580 <fail>

80000388 <test_17>:
80000388:	01100193          	li	gp,17
8000038c:	00000213          	li	tp,0
80000390:	00ff00b7          	lui	ra,0xff0
80000394:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
80000398:	00000013          	nop
8000039c:	00000013          	nop
800003a0:	0f0f1137          	lui	sp,0xf0f1
800003a4:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
800003a8:	0020f733          	and	a4,ra,sp
800003ac:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800003b0:	00200293          	li	t0,2
800003b4:	fc521ee3          	bne	tp,t0,80000390 <test_17+0x8>
800003b8:	000f03b7          	lui	t2,0xf0
800003bc:	00f38393          	addi	t2,t2,15 # f000f <_start-0x7ff0fff1>
800003c0:	1c771063          	bne	a4,t2,80000580 <fail>

800003c4 <test_18>:
800003c4:	01200193          	li	gp,18
800003c8:	00000213          	li	tp,0
800003cc:	0f0f1137          	lui	sp,0xf0f1
800003d0:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
800003d4:	ff0100b7          	lui	ra,0xff010
800003d8:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
800003dc:	0020f733          	and	a4,ra,sp
800003e0:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800003e4:	00200293          	li	t0,2
800003e8:	fe5212e3          	bne	tp,t0,800003cc <test_18+0x8>
800003ec:	0f0013b7          	lui	t2,0xf001
800003f0:	f0038393          	addi	t2,t2,-256 # f000f00 <_start-0x70fff100>
800003f4:	18771663          	bne	a4,t2,80000580 <fail>

800003f8 <test_19>:
800003f8:	01300193          	li	gp,19
800003fc:	00000213          	li	tp,0
80000400:	f0f0f137          	lui	sp,0xf0f0f
80000404:	0f010113          	addi	sp,sp,240 # f0f0f0f0 <_end+0x70f0d0f0>
80000408:	0ff010b7          	lui	ra,0xff01
8000040c:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
80000410:	00000013          	nop
80000414:	0020f733          	and	a4,ra,sp
80000418:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000041c:	00200293          	li	t0,2
80000420:	fe5210e3          	bne	tp,t0,80000400 <test_19+0x8>
80000424:	00f003b7          	lui	t2,0xf00
80000428:	0f038393          	addi	t2,t2,240 # f000f0 <_start-0x7f0fff10>
8000042c:	14771a63          	bne	a4,t2,80000580 <fail>

80000430 <test_20>:
80000430:	01400193          	li	gp,20
80000434:	00000213          	li	tp,0
80000438:	0f0f1137          	lui	sp,0xf0f1
8000043c:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
80000440:	00ff00b7          	lui	ra,0xff0
80000444:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
80000448:	00000013          	nop
8000044c:	00000013          	nop
80000450:	0020f733          	and	a4,ra,sp
80000454:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000458:	00200293          	li	t0,2
8000045c:	fc521ee3          	bne	tp,t0,80000438 <test_20+0x8>
80000460:	000f03b7          	lui	t2,0xf0
80000464:	00f38393          	addi	t2,t2,15 # f000f <_start-0x7ff0fff1>
80000468:	10771c63          	bne	a4,t2,80000580 <fail>

8000046c <test_21>:
8000046c:	01500193          	li	gp,21
80000470:	00000213          	li	tp,0
80000474:	0f0f1137          	lui	sp,0xf0f1
80000478:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
8000047c:	00000013          	nop
80000480:	ff0100b7          	lui	ra,0xff010
80000484:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
80000488:	0020f733          	and	a4,ra,sp
8000048c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000490:	00200293          	li	t0,2
80000494:	fe5210e3          	bne	tp,t0,80000474 <test_21+0x8>
80000498:	0f0013b7          	lui	t2,0xf001
8000049c:	f0038393          	addi	t2,t2,-256 # f000f00 <_start-0x70fff100>
800004a0:	0e771063          	bne	a4,t2,80000580 <fail>

800004a4 <test_22>:
800004a4:	01600193          	li	gp,22
800004a8:	00000213          	li	tp,0
800004ac:	f0f0f137          	lui	sp,0xf0f0f
800004b0:	0f010113          	addi	sp,sp,240 # f0f0f0f0 <_end+0x70f0d0f0>
800004b4:	00000013          	nop
800004b8:	0ff010b7          	lui	ra,0xff01
800004bc:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
800004c0:	00000013          	nop
800004c4:	0020f733          	and	a4,ra,sp
800004c8:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800004cc:	00200293          	li	t0,2
800004d0:	fc521ee3          	bne	tp,t0,800004ac <test_22+0x8>
800004d4:	00f003b7          	lui	t2,0xf00
800004d8:	0f038393          	addi	t2,t2,240 # f000f0 <_start-0x7f0fff10>
800004dc:	0a771263          	bne	a4,t2,80000580 <fail>

800004e0 <test_23>:
800004e0:	01700193          	li	gp,23
800004e4:	00000213          	li	tp,0
800004e8:	0f0f1137          	lui	sp,0xf0f1
800004ec:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
800004f0:	00000013          	nop
800004f4:	00000013          	nop
800004f8:	00ff00b7          	lui	ra,0xff0
800004fc:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
80000500:	0020f733          	and	a4,ra,sp
80000504:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000508:	00200293          	li	t0,2
8000050c:	fc521ee3          	bne	tp,t0,800004e8 <test_23+0x8>
80000510:	000f03b7          	lui	t2,0xf0
80000514:	00f38393          	addi	t2,t2,15 # f000f <_start-0x7ff0fff1>
80000518:	06771463          	bne	a4,t2,80000580 <fail>

8000051c <test_24>:
8000051c:	01800193          	li	gp,24
80000520:	ff0100b7          	lui	ra,0xff010
80000524:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
80000528:	00107133          	and	sp,zero,ra
8000052c:	00000393          	li	t2,0
80000530:	04711863          	bne	sp,t2,80000580 <fail>

80000534 <test_25>:
80000534:	01900193          	li	gp,25
80000538:	00ff00b7          	lui	ra,0xff0
8000053c:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
80000540:	0000f133          	and	sp,ra,zero
80000544:	00000393          	li	t2,0
80000548:	02711c63          	bne	sp,t2,80000580 <fail>

8000054c <test_26>:
8000054c:	01a00193          	li	gp,26
80000550:	000070b3          	and	ra,zero,zero
80000554:	00000393          	li	t2,0
80000558:	02709463          	bne	ra,t2,80000580 <fail>

8000055c <test_27>:
8000055c:	01b00193          	li	gp,27
80000560:	111110b7          	lui	ra,0x11111
80000564:	11108093          	addi	ra,ra,273 # 11111111 <_start-0x6eeeeeef>
80000568:	22222137          	lui	sp,0x22222
8000056c:	22210113          	addi	sp,sp,546 # 22222222 <_start-0x5dddddde>
80000570:	0020f033          	and	zero,ra,sp
80000574:	00000393          	li	t2,0
80000578:	00701463          	bne	zero,t2,80000580 <fail>
8000057c:	00301a63          	bne	zero,gp,80000590 <pass>

80000580 <fail>:
80000580:	803002b7          	lui	t0,0x80300
80000584:	55500313          	li	t1,1365
80000588:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
8000058c:	a79ff06f          	j	80000004 <loop>

80000590 <pass>:
80000590:	803002b7          	lui	t0,0x80300
80000594:	66600313          	li	t1,1638
80000598:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
8000059c:	a69ff06f          	j	80000004 <loop>
800005a0:	c0001073          	unimp
800005a4:	0000                	unimp
800005a6:	0000                	unimp
800005a8:	0000                	unimp
800005aa:	0000                	unimp
800005ac:	0000                	unimp
800005ae:	0000                	unimp
800005b0:	0000                	unimp
800005b2:	0000                	unimp
800005b4:	0000                	unimp
800005b6:	0000                	unimp
800005b8:	0000                	unimp
800005ba:	0000                	unimp
800005bc:	0000                	unimp
800005be:	0000                	unimp
