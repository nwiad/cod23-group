
rv32ui-p-or：     文件格式 elf32-littleriscv


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
800000dc:	0020e733          	or	a4,ra,sp
800000e0:	ff1003b7          	lui	t2,0xff100
800000e4:	f0f38393          	addi	t2,t2,-241 # ff0fff0f <_end+0x7f0fdf0f>
800000e8:	4a771263          	bne	a4,t2,8000058c <fail>

800000ec <test_3>:
800000ec:	00300193          	li	gp,3
800000f0:	0ff010b7          	lui	ra,0xff01
800000f4:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
800000f8:	f0f0f137          	lui	sp,0xf0f0f
800000fc:	0f010113          	addi	sp,sp,240 # f0f0f0f0 <_end+0x70f0d0f0>
80000100:	0020e733          	or	a4,ra,sp
80000104:	fff103b7          	lui	t2,0xfff10
80000108:	ff038393          	addi	t2,t2,-16 # fff0fff0 <_end+0x7ff0dff0>
8000010c:	48771063          	bne	a4,t2,8000058c <fail>

80000110 <test_4>:
80000110:	00400193          	li	gp,4
80000114:	00ff00b7          	lui	ra,0xff0
80000118:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
8000011c:	0f0f1137          	lui	sp,0xf0f1
80000120:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
80000124:	0020e733          	or	a4,ra,sp
80000128:	0fff13b7          	lui	t2,0xfff1
8000012c:	fff38393          	addi	t2,t2,-1 # fff0fff <_start-0x7000f001>
80000130:	44771e63          	bne	a4,t2,8000058c <fail>

80000134 <test_5>:
80000134:	00500193          	li	gp,5
80000138:	f00ff0b7          	lui	ra,0xf00ff
8000013c:	00f08093          	addi	ra,ra,15 # f00ff00f <_end+0x700fd00f>
80000140:	f0f0f137          	lui	sp,0xf0f0f
80000144:	0f010113          	addi	sp,sp,240 # f0f0f0f0 <_end+0x70f0d0f0>
80000148:	0020e733          	or	a4,ra,sp
8000014c:	f0fff3b7          	lui	t2,0xf0fff
80000150:	0ff38393          	addi	t2,t2,255 # f0fff0ff <_end+0x70ffd0ff>
80000154:	42771c63          	bne	a4,t2,8000058c <fail>

80000158 <test_6>:
80000158:	00600193          	li	gp,6
8000015c:	ff0100b7          	lui	ra,0xff010
80000160:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
80000164:	0f0f1137          	lui	sp,0xf0f1
80000168:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
8000016c:	0020e0b3          	or	ra,ra,sp
80000170:	ff1003b7          	lui	t2,0xff100
80000174:	f0f38393          	addi	t2,t2,-241 # ff0fff0f <_end+0x7f0fdf0f>
80000178:	40709a63          	bne	ra,t2,8000058c <fail>

8000017c <test_7>:
8000017c:	00700193          	li	gp,7
80000180:	ff0100b7          	lui	ra,0xff010
80000184:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
80000188:	0f0f1137          	lui	sp,0xf0f1
8000018c:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
80000190:	0020e133          	or	sp,ra,sp
80000194:	ff1003b7          	lui	t2,0xff100
80000198:	f0f38393          	addi	t2,t2,-241 # ff0fff0f <_end+0x7f0fdf0f>
8000019c:	3e711863          	bne	sp,t2,8000058c <fail>

800001a0 <test_8>:
800001a0:	00800193          	li	gp,8
800001a4:	ff0100b7          	lui	ra,0xff010
800001a8:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
800001ac:	0010e0b3          	or	ra,ra,ra
800001b0:	ff0103b7          	lui	t2,0xff010
800001b4:	f0038393          	addi	t2,t2,-256 # ff00ff00 <_end+0x7f00df00>
800001b8:	3c709a63          	bne	ra,t2,8000058c <fail>

800001bc <test_9>:
800001bc:	00900193          	li	gp,9
800001c0:	00000213          	li	tp,0
800001c4:	ff0100b7          	lui	ra,0xff010
800001c8:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
800001cc:	0f0f1137          	lui	sp,0xf0f1
800001d0:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
800001d4:	0020e733          	or	a4,ra,sp
800001d8:	00070313          	mv	t1,a4
800001dc:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800001e0:	00200293          	li	t0,2
800001e4:	fe5210e3          	bne	tp,t0,800001c4 <test_9+0x8>
800001e8:	ff1003b7          	lui	t2,0xff100
800001ec:	f0f38393          	addi	t2,t2,-241 # ff0fff0f <_end+0x7f0fdf0f>
800001f0:	38731e63          	bne	t1,t2,8000058c <fail>

800001f4 <test_10>:
800001f4:	00a00193          	li	gp,10
800001f8:	00000213          	li	tp,0
800001fc:	0ff010b7          	lui	ra,0xff01
80000200:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
80000204:	f0f0f137          	lui	sp,0xf0f0f
80000208:	0f010113          	addi	sp,sp,240 # f0f0f0f0 <_end+0x70f0d0f0>
8000020c:	0020e733          	or	a4,ra,sp
80000210:	00000013          	nop
80000214:	00070313          	mv	t1,a4
80000218:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000021c:	00200293          	li	t0,2
80000220:	fc521ee3          	bne	tp,t0,800001fc <test_10+0x8>
80000224:	fff103b7          	lui	t2,0xfff10
80000228:	ff038393          	addi	t2,t2,-16 # fff0fff0 <_end+0x7ff0dff0>
8000022c:	36731063          	bne	t1,t2,8000058c <fail>

80000230 <test_11>:
80000230:	00b00193          	li	gp,11
80000234:	00000213          	li	tp,0
80000238:	00ff00b7          	lui	ra,0xff0
8000023c:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
80000240:	0f0f1137          	lui	sp,0xf0f1
80000244:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
80000248:	0020e733          	or	a4,ra,sp
8000024c:	00000013          	nop
80000250:	00000013          	nop
80000254:	00070313          	mv	t1,a4
80000258:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000025c:	00200293          	li	t0,2
80000260:	fc521ce3          	bne	tp,t0,80000238 <test_11+0x8>
80000264:	0fff13b7          	lui	t2,0xfff1
80000268:	fff38393          	addi	t2,t2,-1 # fff0fff <_start-0x7000f001>
8000026c:	32731063          	bne	t1,t2,8000058c <fail>

80000270 <test_12>:
80000270:	00c00193          	li	gp,12
80000274:	00000213          	li	tp,0
80000278:	ff0100b7          	lui	ra,0xff010
8000027c:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
80000280:	0f0f1137          	lui	sp,0xf0f1
80000284:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
80000288:	0020e733          	or	a4,ra,sp
8000028c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000290:	00200293          	li	t0,2
80000294:	fe5212e3          	bne	tp,t0,80000278 <test_12+0x8>
80000298:	ff1003b7          	lui	t2,0xff100
8000029c:	f0f38393          	addi	t2,t2,-241 # ff0fff0f <_end+0x7f0fdf0f>
800002a0:	2e771663          	bne	a4,t2,8000058c <fail>

800002a4 <test_13>:
800002a4:	00d00193          	li	gp,13
800002a8:	00000213          	li	tp,0
800002ac:	0ff010b7          	lui	ra,0xff01
800002b0:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
800002b4:	f0f0f137          	lui	sp,0xf0f0f
800002b8:	0f010113          	addi	sp,sp,240 # f0f0f0f0 <_end+0x70f0d0f0>
800002bc:	00000013          	nop
800002c0:	0020e733          	or	a4,ra,sp
800002c4:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002c8:	00200293          	li	t0,2
800002cc:	fe5210e3          	bne	tp,t0,800002ac <test_13+0x8>
800002d0:	fff103b7          	lui	t2,0xfff10
800002d4:	ff038393          	addi	t2,t2,-16 # fff0fff0 <_end+0x7ff0dff0>
800002d8:	2a771a63          	bne	a4,t2,8000058c <fail>

800002dc <test_14>:
800002dc:	00e00193          	li	gp,14
800002e0:	00000213          	li	tp,0
800002e4:	00ff00b7          	lui	ra,0xff0
800002e8:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
800002ec:	0f0f1137          	lui	sp,0xf0f1
800002f0:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
800002f4:	00000013          	nop
800002f8:	00000013          	nop
800002fc:	0020e733          	or	a4,ra,sp
80000300:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000304:	00200293          	li	t0,2
80000308:	fc521ee3          	bne	tp,t0,800002e4 <test_14+0x8>
8000030c:	0fff13b7          	lui	t2,0xfff1
80000310:	fff38393          	addi	t2,t2,-1 # fff0fff <_start-0x7000f001>
80000314:	26771c63          	bne	a4,t2,8000058c <fail>

80000318 <test_15>:
80000318:	00f00193          	li	gp,15
8000031c:	00000213          	li	tp,0
80000320:	ff0100b7          	lui	ra,0xff010
80000324:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
80000328:	00000013          	nop
8000032c:	0f0f1137          	lui	sp,0xf0f1
80000330:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
80000334:	0020e733          	or	a4,ra,sp
80000338:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000033c:	00200293          	li	t0,2
80000340:	fe5210e3          	bne	tp,t0,80000320 <test_15+0x8>
80000344:	ff1003b7          	lui	t2,0xff100
80000348:	f0f38393          	addi	t2,t2,-241 # ff0fff0f <_end+0x7f0fdf0f>
8000034c:	24771063          	bne	a4,t2,8000058c <fail>

80000350 <test_16>:
80000350:	01000193          	li	gp,16
80000354:	00000213          	li	tp,0
80000358:	0ff010b7          	lui	ra,0xff01
8000035c:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
80000360:	00000013          	nop
80000364:	f0f0f137          	lui	sp,0xf0f0f
80000368:	0f010113          	addi	sp,sp,240 # f0f0f0f0 <_end+0x70f0d0f0>
8000036c:	00000013          	nop
80000370:	0020e733          	or	a4,ra,sp
80000374:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000378:	00200293          	li	t0,2
8000037c:	fc521ee3          	bne	tp,t0,80000358 <test_16+0x8>
80000380:	fff103b7          	lui	t2,0xfff10
80000384:	ff038393          	addi	t2,t2,-16 # fff0fff0 <_end+0x7ff0dff0>
80000388:	20771263          	bne	a4,t2,8000058c <fail>

8000038c <test_17>:
8000038c:	01100193          	li	gp,17
80000390:	00000213          	li	tp,0
80000394:	00ff00b7          	lui	ra,0xff0
80000398:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
8000039c:	00000013          	nop
800003a0:	00000013          	nop
800003a4:	0f0f1137          	lui	sp,0xf0f1
800003a8:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
800003ac:	0020e733          	or	a4,ra,sp
800003b0:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800003b4:	00200293          	li	t0,2
800003b8:	fc521ee3          	bne	tp,t0,80000394 <test_17+0x8>
800003bc:	0fff13b7          	lui	t2,0xfff1
800003c0:	fff38393          	addi	t2,t2,-1 # fff0fff <_start-0x7000f001>
800003c4:	1c771463          	bne	a4,t2,8000058c <fail>

800003c8 <test_18>:
800003c8:	01200193          	li	gp,18
800003cc:	00000213          	li	tp,0
800003d0:	0f0f1137          	lui	sp,0xf0f1
800003d4:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
800003d8:	ff0100b7          	lui	ra,0xff010
800003dc:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
800003e0:	0020e733          	or	a4,ra,sp
800003e4:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800003e8:	00200293          	li	t0,2
800003ec:	fe5212e3          	bne	tp,t0,800003d0 <test_18+0x8>
800003f0:	ff1003b7          	lui	t2,0xff100
800003f4:	f0f38393          	addi	t2,t2,-241 # ff0fff0f <_end+0x7f0fdf0f>
800003f8:	18771a63          	bne	a4,t2,8000058c <fail>

800003fc <test_19>:
800003fc:	01300193          	li	gp,19
80000400:	00000213          	li	tp,0
80000404:	f0f0f137          	lui	sp,0xf0f0f
80000408:	0f010113          	addi	sp,sp,240 # f0f0f0f0 <_end+0x70f0d0f0>
8000040c:	0ff010b7          	lui	ra,0xff01
80000410:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
80000414:	00000013          	nop
80000418:	0020e733          	or	a4,ra,sp
8000041c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000420:	00200293          	li	t0,2
80000424:	fe5210e3          	bne	tp,t0,80000404 <test_19+0x8>
80000428:	fff103b7          	lui	t2,0xfff10
8000042c:	ff038393          	addi	t2,t2,-16 # fff0fff0 <_end+0x7ff0dff0>
80000430:	14771e63          	bne	a4,t2,8000058c <fail>

80000434 <test_20>:
80000434:	01400193          	li	gp,20
80000438:	00000213          	li	tp,0
8000043c:	0f0f1137          	lui	sp,0xf0f1
80000440:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
80000444:	00ff00b7          	lui	ra,0xff0
80000448:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
8000044c:	00000013          	nop
80000450:	00000013          	nop
80000454:	0020e733          	or	a4,ra,sp
80000458:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000045c:	00200293          	li	t0,2
80000460:	fc521ee3          	bne	tp,t0,8000043c <test_20+0x8>
80000464:	0fff13b7          	lui	t2,0xfff1
80000468:	fff38393          	addi	t2,t2,-1 # fff0fff <_start-0x7000f001>
8000046c:	12771063          	bne	a4,t2,8000058c <fail>

80000470 <test_21>:
80000470:	01500193          	li	gp,21
80000474:	00000213          	li	tp,0
80000478:	0f0f1137          	lui	sp,0xf0f1
8000047c:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
80000480:	00000013          	nop
80000484:	ff0100b7          	lui	ra,0xff010
80000488:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
8000048c:	0020e733          	or	a4,ra,sp
80000490:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000494:	00200293          	li	t0,2
80000498:	fe5210e3          	bne	tp,t0,80000478 <test_21+0x8>
8000049c:	ff1003b7          	lui	t2,0xff100
800004a0:	f0f38393          	addi	t2,t2,-241 # ff0fff0f <_end+0x7f0fdf0f>
800004a4:	0e771463          	bne	a4,t2,8000058c <fail>

800004a8 <test_22>:
800004a8:	01600193          	li	gp,22
800004ac:	00000213          	li	tp,0
800004b0:	f0f0f137          	lui	sp,0xf0f0f
800004b4:	0f010113          	addi	sp,sp,240 # f0f0f0f0 <_end+0x70f0d0f0>
800004b8:	00000013          	nop
800004bc:	0ff010b7          	lui	ra,0xff01
800004c0:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
800004c4:	00000013          	nop
800004c8:	0020e733          	or	a4,ra,sp
800004cc:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800004d0:	00200293          	li	t0,2
800004d4:	fc521ee3          	bne	tp,t0,800004b0 <test_22+0x8>
800004d8:	fff103b7          	lui	t2,0xfff10
800004dc:	ff038393          	addi	t2,t2,-16 # fff0fff0 <_end+0x7ff0dff0>
800004e0:	0a771663          	bne	a4,t2,8000058c <fail>

800004e4 <test_23>:
800004e4:	01700193          	li	gp,23
800004e8:	00000213          	li	tp,0
800004ec:	0f0f1137          	lui	sp,0xf0f1
800004f0:	f0f10113          	addi	sp,sp,-241 # f0f0f0f <_start-0x70f0f0f1>
800004f4:	00000013          	nop
800004f8:	00000013          	nop
800004fc:	00ff00b7          	lui	ra,0xff0
80000500:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
80000504:	0020e733          	or	a4,ra,sp
80000508:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000050c:	00200293          	li	t0,2
80000510:	fc521ee3          	bne	tp,t0,800004ec <test_23+0x8>
80000514:	0fff13b7          	lui	t2,0xfff1
80000518:	fff38393          	addi	t2,t2,-1 # fff0fff <_start-0x7000f001>
8000051c:	06771863          	bne	a4,t2,8000058c <fail>

80000520 <test_24>:
80000520:	01800193          	li	gp,24
80000524:	ff0100b7          	lui	ra,0xff010
80000528:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
8000052c:	00106133          	or	sp,zero,ra
80000530:	ff0103b7          	lui	t2,0xff010
80000534:	f0038393          	addi	t2,t2,-256 # ff00ff00 <_end+0x7f00df00>
80000538:	04711a63          	bne	sp,t2,8000058c <fail>

8000053c <test_25>:
8000053c:	01900193          	li	gp,25
80000540:	00ff00b7          	lui	ra,0xff0
80000544:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
80000548:	0000e133          	or	sp,ra,zero
8000054c:	00ff03b7          	lui	t2,0xff0
80000550:	0ff38393          	addi	t2,t2,255 # ff00ff <_start-0x7f00ff01>
80000554:	02711c63          	bne	sp,t2,8000058c <fail>

80000558 <test_26>:
80000558:	01a00193          	li	gp,26
8000055c:	000060b3          	or	ra,zero,zero
80000560:	00000393          	li	t2,0
80000564:	02709463          	bne	ra,t2,8000058c <fail>

80000568 <test_27>:
80000568:	01b00193          	li	gp,27
8000056c:	111110b7          	lui	ra,0x11111
80000570:	11108093          	addi	ra,ra,273 # 11111111 <_start-0x6eeeeeef>
80000574:	22222137          	lui	sp,0x22222
80000578:	22210113          	addi	sp,sp,546 # 22222222 <_start-0x5dddddde>
8000057c:	0020e033          	or	zero,ra,sp
80000580:	00000393          	li	t2,0
80000584:	00701463          	bne	zero,t2,8000058c <fail>
80000588:	00301a63          	bne	zero,gp,8000059c <pass>

8000058c <fail>:
8000058c:	803002b7          	lui	t0,0x80300
80000590:	55500313          	li	t1,1365
80000594:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
80000598:	a6dff06f          	j	80000004 <loop>

8000059c <pass>:
8000059c:	803002b7          	lui	t0,0x80300
800005a0:	66600313          	li	t1,1638
800005a4:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
800005a8:	a5dff06f          	j	80000004 <loop>
800005ac:	c0001073          	unimp
800005b0:	0000                	unimp
800005b2:	0000                	unimp
800005b4:	0000                	unimp
800005b6:	0000                	unimp
800005b8:	0000                	unimp
800005ba:	0000                	unimp
800005bc:	0000                	unimp
800005be:	0000                	unimp
