
rv32ui-p-sh：     文件格式 elf32-littleriscv


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
800000cc:	00002097          	auipc	ra,0x2
800000d0:	f3408093          	addi	ra,ra,-204 # 80002000 <begin_signature>
800000d4:	0aa00113          	li	sp,170
800000d8:	00000797          	auipc	a5,0x0
800000dc:	01478793          	addi	a5,a5,20 # 800000ec <test_2+0x24>
800000e0:	00209023          	sh	sp,0(ra)
800000e4:	00009703          	lh	a4,0(ra)
800000e8:	0080006f          	j	800000f0 <test_2+0x28>
800000ec:	00010713          	mv	a4,sp
800000f0:	0aa00393          	li	t2,170
800000f4:	4c771663          	bne	a4,t2,800005c0 <fail>

800000f8 <test_3>:
800000f8:	00300193          	li	gp,3
800000fc:	00002097          	auipc	ra,0x2
80000100:	f0408093          	addi	ra,ra,-252 # 80002000 <begin_signature>
80000104:	ffffb137          	lui	sp,0xffffb
80000108:	a0010113          	addi	sp,sp,-1536 # ffffaa00 <_end+0x7fff89e0>
8000010c:	00000797          	auipc	a5,0x0
80000110:	01478793          	addi	a5,a5,20 # 80000120 <test_3+0x28>
80000114:	00209123          	sh	sp,2(ra)
80000118:	00209703          	lh	a4,2(ra)
8000011c:	0080006f          	j	80000124 <test_3+0x2c>
80000120:	00010713          	mv	a4,sp
80000124:	ffffb3b7          	lui	t2,0xffffb
80000128:	a0038393          	addi	t2,t2,-1536 # ffffaa00 <_end+0x7fff89e0>
8000012c:	48771a63          	bne	a4,t2,800005c0 <fail>

80000130 <test_4>:
80000130:	00400193          	li	gp,4
80000134:	00002097          	auipc	ra,0x2
80000138:	ecc08093          	addi	ra,ra,-308 # 80002000 <begin_signature>
8000013c:	beef1137          	lui	sp,0xbeef1
80000140:	aa010113          	addi	sp,sp,-1376 # beef0aa0 <_end+0x3eeeea80>
80000144:	00000797          	auipc	a5,0x0
80000148:	01478793          	addi	a5,a5,20 # 80000158 <test_4+0x28>
8000014c:	00209223          	sh	sp,4(ra)
80000150:	0040a703          	lw	a4,4(ra)
80000154:	0080006f          	j	8000015c <test_4+0x2c>
80000158:	00010713          	mv	a4,sp
8000015c:	beef13b7          	lui	t2,0xbeef1
80000160:	aa038393          	addi	t2,t2,-1376 # beef0aa0 <_end+0x3eeeea80>
80000164:	44771e63          	bne	a4,t2,800005c0 <fail>

80000168 <test_5>:
80000168:	00500193          	li	gp,5
8000016c:	00002097          	auipc	ra,0x2
80000170:	e9408093          	addi	ra,ra,-364 # 80002000 <begin_signature>
80000174:	ffffa137          	lui	sp,0xffffa
80000178:	00a10113          	addi	sp,sp,10 # ffffa00a <_end+0x7fff7fea>
8000017c:	00000797          	auipc	a5,0x0
80000180:	01478793          	addi	a5,a5,20 # 80000190 <test_5+0x28>
80000184:	00209323          	sh	sp,6(ra)
80000188:	00609703          	lh	a4,6(ra)
8000018c:	0080006f          	j	80000194 <test_5+0x2c>
80000190:	00010713          	mv	a4,sp
80000194:	ffffa3b7          	lui	t2,0xffffa
80000198:	00a38393          	addi	t2,t2,10 # ffffa00a <_end+0x7fff7fea>
8000019c:	42771263          	bne	a4,t2,800005c0 <fail>

800001a0 <test_6>:
800001a0:	00600193          	li	gp,6
800001a4:	00002097          	auipc	ra,0x2
800001a8:	e6a08093          	addi	ra,ra,-406 # 8000200e <tdat8>
800001ac:	0aa00113          	li	sp,170
800001b0:	00000797          	auipc	a5,0x0
800001b4:	01478793          	addi	a5,a5,20 # 800001c4 <test_6+0x24>
800001b8:	fe209d23          	sh	sp,-6(ra)
800001bc:	ffa09703          	lh	a4,-6(ra)
800001c0:	0080006f          	j	800001c8 <test_6+0x28>
800001c4:	00010713          	mv	a4,sp
800001c8:	0aa00393          	li	t2,170
800001cc:	3e771a63          	bne	a4,t2,800005c0 <fail>

800001d0 <test_7>:
800001d0:	00700193          	li	gp,7
800001d4:	00002097          	auipc	ra,0x2
800001d8:	e3a08093          	addi	ra,ra,-454 # 8000200e <tdat8>
800001dc:	ffffb137          	lui	sp,0xffffb
800001e0:	a0010113          	addi	sp,sp,-1536 # ffffaa00 <_end+0x7fff89e0>
800001e4:	00000797          	auipc	a5,0x0
800001e8:	01478793          	addi	a5,a5,20 # 800001f8 <test_7+0x28>
800001ec:	fe209e23          	sh	sp,-4(ra)
800001f0:	ffc09703          	lh	a4,-4(ra)
800001f4:	0080006f          	j	800001fc <test_7+0x2c>
800001f8:	00010713          	mv	a4,sp
800001fc:	ffffb3b7          	lui	t2,0xffffb
80000200:	a0038393          	addi	t2,t2,-1536 # ffffaa00 <_end+0x7fff89e0>
80000204:	3a771e63          	bne	a4,t2,800005c0 <fail>

80000208 <test_8>:
80000208:	00800193          	li	gp,8
8000020c:	00002097          	auipc	ra,0x2
80000210:	e0208093          	addi	ra,ra,-510 # 8000200e <tdat8>
80000214:	00001137          	lui	sp,0x1
80000218:	aa010113          	addi	sp,sp,-1376 # aa0 <_start-0x7ffff560>
8000021c:	00000797          	auipc	a5,0x0
80000220:	01478793          	addi	a5,a5,20 # 80000230 <test_8+0x28>
80000224:	fe209f23          	sh	sp,-2(ra)
80000228:	ffe09703          	lh	a4,-2(ra)
8000022c:	0080006f          	j	80000234 <test_8+0x2c>
80000230:	00010713          	mv	a4,sp
80000234:	000013b7          	lui	t2,0x1
80000238:	aa038393          	addi	t2,t2,-1376 # aa0 <_start-0x7ffff560>
8000023c:	38771263          	bne	a4,t2,800005c0 <fail>

80000240 <test_9>:
80000240:	00900193          	li	gp,9
80000244:	00002097          	auipc	ra,0x2
80000248:	dca08093          	addi	ra,ra,-566 # 8000200e <tdat8>
8000024c:	ffffa137          	lui	sp,0xffffa
80000250:	00a10113          	addi	sp,sp,10 # ffffa00a <_end+0x7fff7fea>
80000254:	00000797          	auipc	a5,0x0
80000258:	01478793          	addi	a5,a5,20 # 80000268 <test_9+0x28>
8000025c:	00209023          	sh	sp,0(ra)
80000260:	00009703          	lh	a4,0(ra)
80000264:	0080006f          	j	8000026c <test_9+0x2c>
80000268:	00010713          	mv	a4,sp
8000026c:	ffffa3b7          	lui	t2,0xffffa
80000270:	00a38393          	addi	t2,t2,10 # ffffa00a <_end+0x7fff7fea>
80000274:	34771663          	bne	a4,t2,800005c0 <fail>

80000278 <test_10>:
80000278:	00a00193          	li	gp,10
8000027c:	00002097          	auipc	ra,0x2
80000280:	d9408093          	addi	ra,ra,-620 # 80002010 <tdat9>
80000284:	12345137          	lui	sp,0x12345
80000288:	67810113          	addi	sp,sp,1656 # 12345678 <_start-0x6dcba988>
8000028c:	fe008213          	addi	tp,ra,-32
80000290:	02221023          	sh	sp,32(tp) # 20 <_start-0x7fffffe0>
80000294:	00009283          	lh	t0,0(ra)
80000298:	000053b7          	lui	t2,0x5
8000029c:	67838393          	addi	t2,t2,1656 # 5678 <_start-0x7fffa988>
800002a0:	32729063          	bne	t0,t2,800005c0 <fail>

800002a4 <test_11>:
800002a4:	00b00193          	li	gp,11
800002a8:	00002097          	auipc	ra,0x2
800002ac:	d6808093          	addi	ra,ra,-664 # 80002010 <tdat9>
800002b0:	00003137          	lui	sp,0x3
800002b4:	09810113          	addi	sp,sp,152 # 3098 <_start-0x7fffcf68>
800002b8:	ffb08093          	addi	ra,ra,-5
800002bc:	002093a3          	sh	sp,7(ra)
800002c0:	00002217          	auipc	tp,0x2
800002c4:	d5220213          	addi	tp,tp,-686 # 80002012 <tdat10>
800002c8:	00021283          	lh	t0,0(tp) # 0 <_start-0x80000000>
800002cc:	000033b7          	lui	t2,0x3
800002d0:	09838393          	addi	t2,t2,152 # 3098 <_start-0x7fffcf68>
800002d4:	2e729663          	bne	t0,t2,800005c0 <fail>

800002d8 <test_12>:
800002d8:	00c00193          	li	gp,12
800002dc:	00000213          	li	tp,0
800002e0:	ffffd0b7          	lui	ra,0xffffd
800002e4:	cdd08093          	addi	ra,ra,-803 # ffffccdd <_end+0x7fffacbd>
800002e8:	00002117          	auipc	sp,0x2
800002ec:	d1810113          	addi	sp,sp,-744 # 80002000 <begin_signature>
800002f0:	00111023          	sh	ra,0(sp)
800002f4:	00011703          	lh	a4,0(sp)
800002f8:	ffffd3b7          	lui	t2,0xffffd
800002fc:	cdd38393          	addi	t2,t2,-803 # ffffccdd <_end+0x7fffacbd>
80000300:	2c771063          	bne	a4,t2,800005c0 <fail>
80000304:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000308:	00200293          	li	t0,2
8000030c:	fc521ae3          	bne	tp,t0,800002e0 <test_12+0x8>

80000310 <test_13>:
80000310:	00d00193          	li	gp,13
80000314:	00000213          	li	tp,0
80000318:	ffffc0b7          	lui	ra,0xffffc
8000031c:	ccd08093          	addi	ra,ra,-819 # ffffbccd <_end+0x7fff9cad>
80000320:	00002117          	auipc	sp,0x2
80000324:	ce010113          	addi	sp,sp,-800 # 80002000 <begin_signature>
80000328:	00000013          	nop
8000032c:	00111123          	sh	ra,2(sp)
80000330:	00211703          	lh	a4,2(sp)
80000334:	ffffc3b7          	lui	t2,0xffffc
80000338:	ccd38393          	addi	t2,t2,-819 # ffffbccd <_end+0x7fff9cad>
8000033c:	28771263          	bne	a4,t2,800005c0 <fail>
80000340:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000344:	00200293          	li	t0,2
80000348:	fc5218e3          	bne	tp,t0,80000318 <test_13+0x8>

8000034c <test_14>:
8000034c:	00e00193          	li	gp,14
80000350:	00000213          	li	tp,0
80000354:	ffffc0b7          	lui	ra,0xffffc
80000358:	bcc08093          	addi	ra,ra,-1076 # ffffbbcc <_end+0x7fff9bac>
8000035c:	00002117          	auipc	sp,0x2
80000360:	ca410113          	addi	sp,sp,-860 # 80002000 <begin_signature>
80000364:	00000013          	nop
80000368:	00000013          	nop
8000036c:	00111223          	sh	ra,4(sp)
80000370:	00411703          	lh	a4,4(sp)
80000374:	ffffc3b7          	lui	t2,0xffffc
80000378:	bcc38393          	addi	t2,t2,-1076 # ffffbbcc <_end+0x7fff9bac>
8000037c:	24771263          	bne	a4,t2,800005c0 <fail>
80000380:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000384:	00200293          	li	t0,2
80000388:	fc5216e3          	bne	tp,t0,80000354 <test_14+0x8>

8000038c <test_15>:
8000038c:	00f00193          	li	gp,15
80000390:	00000213          	li	tp,0
80000394:	ffffb0b7          	lui	ra,0xffffb
80000398:	bbc08093          	addi	ra,ra,-1092 # ffffabbc <_end+0x7fff8b9c>
8000039c:	00000013          	nop
800003a0:	00002117          	auipc	sp,0x2
800003a4:	c6010113          	addi	sp,sp,-928 # 80002000 <begin_signature>
800003a8:	00111323          	sh	ra,6(sp)
800003ac:	00611703          	lh	a4,6(sp)
800003b0:	ffffb3b7          	lui	t2,0xffffb
800003b4:	bbc38393          	addi	t2,t2,-1092 # ffffabbc <_end+0x7fff8b9c>
800003b8:	20771463          	bne	a4,t2,800005c0 <fail>
800003bc:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800003c0:	00200293          	li	t0,2
800003c4:	fc5218e3          	bne	tp,t0,80000394 <test_15+0x8>

800003c8 <test_16>:
800003c8:	01000193          	li	gp,16
800003cc:	00000213          	li	tp,0
800003d0:	ffffb0b7          	lui	ra,0xffffb
800003d4:	abb08093          	addi	ra,ra,-1349 # ffffaabb <_end+0x7fff8a9b>
800003d8:	00000013          	nop
800003dc:	00002117          	auipc	sp,0x2
800003e0:	c2410113          	addi	sp,sp,-988 # 80002000 <begin_signature>
800003e4:	00000013          	nop
800003e8:	00111423          	sh	ra,8(sp)
800003ec:	00811703          	lh	a4,8(sp)
800003f0:	ffffb3b7          	lui	t2,0xffffb
800003f4:	abb38393          	addi	t2,t2,-1349 # ffffaabb <_end+0x7fff8a9b>
800003f8:	1c771463          	bne	a4,t2,800005c0 <fail>
800003fc:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000400:	00200293          	li	t0,2
80000404:	fc5216e3          	bne	tp,t0,800003d0 <test_16+0x8>

80000408 <test_17>:
80000408:	01100193          	li	gp,17
8000040c:	00000213          	li	tp,0
80000410:	ffffe0b7          	lui	ra,0xffffe
80000414:	aab08093          	addi	ra,ra,-1365 # ffffdaab <_end+0x7fffba8b>
80000418:	00000013          	nop
8000041c:	00000013          	nop
80000420:	00002117          	auipc	sp,0x2
80000424:	be010113          	addi	sp,sp,-1056 # 80002000 <begin_signature>
80000428:	00111523          	sh	ra,10(sp)
8000042c:	00a11703          	lh	a4,10(sp)
80000430:	ffffe3b7          	lui	t2,0xffffe
80000434:	aab38393          	addi	t2,t2,-1365 # ffffdaab <_end+0x7fffba8b>
80000438:	18771463          	bne	a4,t2,800005c0 <fail>
8000043c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000440:	00200293          	li	t0,2
80000444:	fc5216e3          	bne	tp,t0,80000410 <test_17+0x8>

80000448 <test_18>:
80000448:	01200193          	li	gp,18
8000044c:	00000213          	li	tp,0
80000450:	00002117          	auipc	sp,0x2
80000454:	bb010113          	addi	sp,sp,-1104 # 80002000 <begin_signature>
80000458:	000020b7          	lui	ra,0x2
8000045c:	23308093          	addi	ra,ra,563 # 2233 <_start-0x7fffddcd>
80000460:	00111023          	sh	ra,0(sp)
80000464:	00011703          	lh	a4,0(sp)
80000468:	000023b7          	lui	t2,0x2
8000046c:	23338393          	addi	t2,t2,563 # 2233 <_start-0x7fffddcd>
80000470:	14771863          	bne	a4,t2,800005c0 <fail>
80000474:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000478:	00200293          	li	t0,2
8000047c:	fc521ae3          	bne	tp,t0,80000450 <test_18+0x8>

80000480 <test_19>:
80000480:	01300193          	li	gp,19
80000484:	00000213          	li	tp,0
80000488:	00002117          	auipc	sp,0x2
8000048c:	b7810113          	addi	sp,sp,-1160 # 80002000 <begin_signature>
80000490:	000010b7          	lui	ra,0x1
80000494:	22308093          	addi	ra,ra,547 # 1223 <_start-0x7fffeddd>
80000498:	00000013          	nop
8000049c:	00111123          	sh	ra,2(sp)
800004a0:	00211703          	lh	a4,2(sp)
800004a4:	000013b7          	lui	t2,0x1
800004a8:	22338393          	addi	t2,t2,547 # 1223 <_start-0x7fffeddd>
800004ac:	10771a63          	bne	a4,t2,800005c0 <fail>
800004b0:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800004b4:	00200293          	li	t0,2
800004b8:	fc5218e3          	bne	tp,t0,80000488 <test_19+0x8>

800004bc <test_20>:
800004bc:	01400193          	li	gp,20
800004c0:	00000213          	li	tp,0
800004c4:	00002117          	auipc	sp,0x2
800004c8:	b3c10113          	addi	sp,sp,-1220 # 80002000 <begin_signature>
800004cc:	000010b7          	lui	ra,0x1
800004d0:	12208093          	addi	ra,ra,290 # 1122 <_start-0x7fffeede>
800004d4:	00000013          	nop
800004d8:	00000013          	nop
800004dc:	00111223          	sh	ra,4(sp)
800004e0:	00411703          	lh	a4,4(sp)
800004e4:	000013b7          	lui	t2,0x1
800004e8:	12238393          	addi	t2,t2,290 # 1122 <_start-0x7fffeede>
800004ec:	0c771a63          	bne	a4,t2,800005c0 <fail>
800004f0:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800004f4:	00200293          	li	t0,2
800004f8:	fc5216e3          	bne	tp,t0,800004c4 <test_20+0x8>

800004fc <test_21>:
800004fc:	01500193          	li	gp,21
80000500:	00000213          	li	tp,0
80000504:	00002117          	auipc	sp,0x2
80000508:	afc10113          	addi	sp,sp,-1284 # 80002000 <begin_signature>
8000050c:	00000013          	nop
80000510:	11200093          	li	ra,274
80000514:	00111323          	sh	ra,6(sp)
80000518:	00611703          	lh	a4,6(sp)
8000051c:	11200393          	li	t2,274
80000520:	0a771063          	bne	a4,t2,800005c0 <fail>
80000524:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000528:	00200293          	li	t0,2
8000052c:	fc521ce3          	bne	tp,t0,80000504 <test_21+0x8>

80000530 <test_22>:
80000530:	01600193          	li	gp,22
80000534:	00000213          	li	tp,0
80000538:	00002117          	auipc	sp,0x2
8000053c:	ac810113          	addi	sp,sp,-1336 # 80002000 <begin_signature>
80000540:	00000013          	nop
80000544:	01100093          	li	ra,17
80000548:	00000013          	nop
8000054c:	00111423          	sh	ra,8(sp)
80000550:	00811703          	lh	a4,8(sp)
80000554:	01100393          	li	t2,17
80000558:	06771463          	bne	a4,t2,800005c0 <fail>
8000055c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000560:	00200293          	li	t0,2
80000564:	fc521ae3          	bne	tp,t0,80000538 <test_22+0x8>

80000568 <test_23>:
80000568:	01700193          	li	gp,23
8000056c:	00000213          	li	tp,0
80000570:	00002117          	auipc	sp,0x2
80000574:	a9010113          	addi	sp,sp,-1392 # 80002000 <begin_signature>
80000578:	00000013          	nop
8000057c:	00000013          	nop
80000580:	000030b7          	lui	ra,0x3
80000584:	00108093          	addi	ra,ra,1 # 3001 <_start-0x7fffcfff>
80000588:	00111523          	sh	ra,10(sp)
8000058c:	00a11703          	lh	a4,10(sp)
80000590:	000033b7          	lui	t2,0x3
80000594:	00138393          	addi	t2,t2,1 # 3001 <_start-0x7fffcfff>
80000598:	02771463          	bne	a4,t2,800005c0 <fail>
8000059c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800005a0:	00200293          	li	t0,2
800005a4:	fc5216e3          	bne	tp,t0,80000570 <test_23+0x8>
800005a8:	0000c537          	lui	a0,0xc
800005ac:	eef50513          	addi	a0,a0,-273 # beef <_start-0x7fff4111>
800005b0:	00002597          	auipc	a1,0x2
800005b4:	a5058593          	addi	a1,a1,-1456 # 80002000 <begin_signature>
800005b8:	00a59323          	sh	a0,6(a1)
800005bc:	00301a63          	bne	zero,gp,800005d0 <pass>

800005c0 <fail>:
800005c0:	803002b7          	lui	t0,0x80300
800005c4:	55500313          	li	t1,1365
800005c8:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fdfe0>
800005cc:	a39ff06f          	j	80000004 <loop>

800005d0 <pass>:
800005d0:	803002b7          	lui	t0,0x80300
800005d4:	66600313          	li	t1,1638
800005d8:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fdfe0>
800005dc:	a29ff06f          	j	80000004 <loop>
800005e0:	c0001073          	unimp
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

Disassembly of section .data:

80002000 <begin_signature>:
80002000:	          	jal	t4,7fffd3ee <_start-0x2c12>

80002002 <tdat2>:
80002002:	          	jal	t4,7fffd3f0 <_start-0x2c10>

80002004 <tdat3>:
80002004:	          	jal	t4,7fffd3f2 <_start-0x2c0e>

80002006 <tdat4>:
80002006:	          	jal	t4,7fffd3f4 <_start-0x2c0c>

80002008 <tdat5>:
80002008:	          	jal	t4,7fffd3f6 <_start-0x2c0a>

8000200a <tdat6>:
8000200a:	          	jal	t4,7fffd3f8 <_start-0x2c08>

8000200c <tdat7>:
8000200c:	          	jal	t4,7fffd3fa <_start-0x2c06>

8000200e <tdat8>:
8000200e:	          	jal	t4,7fffd3fc <_start-0x2c04>

80002010 <tdat9>:
80002010:	          	jal	t4,7fffd3fe <_start-0x2c02>

80002012 <tdat10>:
80002012:	0000beef          	jal	t4,8000d012 <_end+0xaff2>
80002016:	0000                	unimp
80002018:	0000                	unimp
8000201a:	0000                	unimp
8000201c:	0000                	unimp
8000201e:	0000                	unimp
