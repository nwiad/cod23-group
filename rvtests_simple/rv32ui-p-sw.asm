
rv32ui-p-sw：     文件格式 elf32-littleriscv


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
800000d4:	00aa0137          	lui	sp,0xaa0
800000d8:	0aa10113          	addi	sp,sp,170 # aa00aa <_start-0x7f55ff56>
800000dc:	00000797          	auipc	a5,0x0
800000e0:	01478793          	addi	a5,a5,20 # 800000f0 <test_2+0x28>
800000e4:	0020a023          	sw	sp,0(ra)
800000e8:	0000a703          	lw	a4,0(ra)
800000ec:	0080006f          	j	800000f4 <test_2+0x2c>
800000f0:	00010713          	mv	a4,sp
800000f4:	00aa03b7          	lui	t2,0xaa0
800000f8:	0aa38393          	addi	t2,t2,170 # aa00aa <_start-0x7f55ff56>
800000fc:	4c771863          	bne	a4,t2,800005cc <fail>

80000100 <test_3>:
80000100:	00300193          	li	gp,3
80000104:	00002097          	auipc	ra,0x2
80000108:	efc08093          	addi	ra,ra,-260 # 80002000 <begin_signature>
8000010c:	aa00b137          	lui	sp,0xaa00b
80000110:	a0010113          	addi	sp,sp,-1536 # aa00aa00 <_end+0x2a0089d0>
80000114:	00000797          	auipc	a5,0x0
80000118:	01478793          	addi	a5,a5,20 # 80000128 <test_3+0x28>
8000011c:	0020a223          	sw	sp,4(ra)
80000120:	0040a703          	lw	a4,4(ra)
80000124:	0080006f          	j	8000012c <test_3+0x2c>
80000128:	00010713          	mv	a4,sp
8000012c:	aa00b3b7          	lui	t2,0xaa00b
80000130:	a0038393          	addi	t2,t2,-1536 # aa00aa00 <_end+0x2a0089d0>
80000134:	48771c63          	bne	a4,t2,800005cc <fail>

80000138 <test_4>:
80000138:	00400193          	li	gp,4
8000013c:	00002097          	auipc	ra,0x2
80000140:	ec408093          	addi	ra,ra,-316 # 80002000 <begin_signature>
80000144:	0aa01137          	lui	sp,0xaa01
80000148:	aa010113          	addi	sp,sp,-1376 # aa00aa0 <_start-0x755ff560>
8000014c:	00000797          	auipc	a5,0x0
80000150:	01478793          	addi	a5,a5,20 # 80000160 <test_4+0x28>
80000154:	0020a423          	sw	sp,8(ra)
80000158:	0080a703          	lw	a4,8(ra)
8000015c:	0080006f          	j	80000164 <test_4+0x2c>
80000160:	00010713          	mv	a4,sp
80000164:	0aa013b7          	lui	t2,0xaa01
80000168:	aa038393          	addi	t2,t2,-1376 # aa00aa0 <_start-0x755ff560>
8000016c:	46771063          	bne	a4,t2,800005cc <fail>

80000170 <test_5>:
80000170:	00500193          	li	gp,5
80000174:	00002097          	auipc	ra,0x2
80000178:	e8c08093          	addi	ra,ra,-372 # 80002000 <begin_signature>
8000017c:	a00aa137          	lui	sp,0xa00aa
80000180:	00a10113          	addi	sp,sp,10 # a00aa00a <_end+0x200a7fda>
80000184:	00000797          	auipc	a5,0x0
80000188:	01478793          	addi	a5,a5,20 # 80000198 <test_5+0x28>
8000018c:	0020a623          	sw	sp,12(ra)
80000190:	00c0a703          	lw	a4,12(ra)
80000194:	0080006f          	j	8000019c <test_5+0x2c>
80000198:	00010713          	mv	a4,sp
8000019c:	a00aa3b7          	lui	t2,0xa00aa
800001a0:	00a38393          	addi	t2,t2,10 # a00aa00a <_end+0x200a7fda>
800001a4:	42771463          	bne	a4,t2,800005cc <fail>

800001a8 <test_6>:
800001a8:	00600193          	li	gp,6
800001ac:	00002097          	auipc	ra,0x2
800001b0:	e7008093          	addi	ra,ra,-400 # 8000201c <tdat8>
800001b4:	00aa0137          	lui	sp,0xaa0
800001b8:	0aa10113          	addi	sp,sp,170 # aa00aa <_start-0x7f55ff56>
800001bc:	00000797          	auipc	a5,0x0
800001c0:	01478793          	addi	a5,a5,20 # 800001d0 <test_6+0x28>
800001c4:	fe20aa23          	sw	sp,-12(ra)
800001c8:	ff40a703          	lw	a4,-12(ra)
800001cc:	0080006f          	j	800001d4 <test_6+0x2c>
800001d0:	00010713          	mv	a4,sp
800001d4:	00aa03b7          	lui	t2,0xaa0
800001d8:	0aa38393          	addi	t2,t2,170 # aa00aa <_start-0x7f55ff56>
800001dc:	3e771863          	bne	a4,t2,800005cc <fail>

800001e0 <test_7>:
800001e0:	00700193          	li	gp,7
800001e4:	00002097          	auipc	ra,0x2
800001e8:	e3808093          	addi	ra,ra,-456 # 8000201c <tdat8>
800001ec:	aa00b137          	lui	sp,0xaa00b
800001f0:	a0010113          	addi	sp,sp,-1536 # aa00aa00 <_end+0x2a0089d0>
800001f4:	00000797          	auipc	a5,0x0
800001f8:	01478793          	addi	a5,a5,20 # 80000208 <test_7+0x28>
800001fc:	fe20ac23          	sw	sp,-8(ra)
80000200:	ff80a703          	lw	a4,-8(ra)
80000204:	0080006f          	j	8000020c <test_7+0x2c>
80000208:	00010713          	mv	a4,sp
8000020c:	aa00b3b7          	lui	t2,0xaa00b
80000210:	a0038393          	addi	t2,t2,-1536 # aa00aa00 <_end+0x2a0089d0>
80000214:	3a771c63          	bne	a4,t2,800005cc <fail>

80000218 <test_8>:
80000218:	00800193          	li	gp,8
8000021c:	00002097          	auipc	ra,0x2
80000220:	e0008093          	addi	ra,ra,-512 # 8000201c <tdat8>
80000224:	0aa01137          	lui	sp,0xaa01
80000228:	aa010113          	addi	sp,sp,-1376 # aa00aa0 <_start-0x755ff560>
8000022c:	00000797          	auipc	a5,0x0
80000230:	01478793          	addi	a5,a5,20 # 80000240 <test_8+0x28>
80000234:	fe20ae23          	sw	sp,-4(ra)
80000238:	ffc0a703          	lw	a4,-4(ra)
8000023c:	0080006f          	j	80000244 <test_8+0x2c>
80000240:	00010713          	mv	a4,sp
80000244:	0aa013b7          	lui	t2,0xaa01
80000248:	aa038393          	addi	t2,t2,-1376 # aa00aa0 <_start-0x755ff560>
8000024c:	38771063          	bne	a4,t2,800005cc <fail>

80000250 <test_9>:
80000250:	00900193          	li	gp,9
80000254:	00002097          	auipc	ra,0x2
80000258:	dc808093          	addi	ra,ra,-568 # 8000201c <tdat8>
8000025c:	a00aa137          	lui	sp,0xa00aa
80000260:	00a10113          	addi	sp,sp,10 # a00aa00a <_end+0x200a7fda>
80000264:	00000797          	auipc	a5,0x0
80000268:	01478793          	addi	a5,a5,20 # 80000278 <test_9+0x28>
8000026c:	0020a023          	sw	sp,0(ra)
80000270:	0000a703          	lw	a4,0(ra)
80000274:	0080006f          	j	8000027c <test_9+0x2c>
80000278:	00010713          	mv	a4,sp
8000027c:	a00aa3b7          	lui	t2,0xa00aa
80000280:	00a38393          	addi	t2,t2,10 # a00aa00a <_end+0x200a7fda>
80000284:	34771463          	bne	a4,t2,800005cc <fail>

80000288 <test_10>:
80000288:	00a00193          	li	gp,10
8000028c:	00002097          	auipc	ra,0x2
80000290:	d9408093          	addi	ra,ra,-620 # 80002020 <tdat9>
80000294:	12345137          	lui	sp,0x12345
80000298:	67810113          	addi	sp,sp,1656 # 12345678 <_start-0x6dcba988>
8000029c:	fe008213          	addi	tp,ra,-32
800002a0:	02222023          	sw	sp,32(tp) # 20 <_start-0x7fffffe0>
800002a4:	0000a283          	lw	t0,0(ra)
800002a8:	123453b7          	lui	t2,0x12345
800002ac:	67838393          	addi	t2,t2,1656 # 12345678 <_start-0x6dcba988>
800002b0:	30729e63          	bne	t0,t2,800005cc <fail>

800002b4 <test_11>:
800002b4:	00b00193          	li	gp,11
800002b8:	00002097          	auipc	ra,0x2
800002bc:	d6808093          	addi	ra,ra,-664 # 80002020 <tdat9>
800002c0:	58213137          	lui	sp,0x58213
800002c4:	09810113          	addi	sp,sp,152 # 58213098 <_start-0x27decf68>
800002c8:	ffd08093          	addi	ra,ra,-3
800002cc:	0020a3a3          	sw	sp,7(ra)
800002d0:	00002217          	auipc	tp,0x2
800002d4:	d5420213          	addi	tp,tp,-684 # 80002024 <tdat10>
800002d8:	00022283          	lw	t0,0(tp) # 0 <_start-0x80000000>
800002dc:	582133b7          	lui	t2,0x58213
800002e0:	09838393          	addi	t2,t2,152 # 58213098 <_start-0x27decf68>
800002e4:	2e729463          	bne	t0,t2,800005cc <fail>

800002e8 <test_12>:
800002e8:	00c00193          	li	gp,12
800002ec:	00000213          	li	tp,0
800002f0:	aabbd0b7          	lui	ra,0xaabbd
800002f4:	cdd08093          	addi	ra,ra,-803 # aabbccdd <_end+0x2abbacad>
800002f8:	00002117          	auipc	sp,0x2
800002fc:	d0810113          	addi	sp,sp,-760 # 80002000 <begin_signature>
80000300:	00112023          	sw	ra,0(sp)
80000304:	00012703          	lw	a4,0(sp)
80000308:	aabbd3b7          	lui	t2,0xaabbd
8000030c:	cdd38393          	addi	t2,t2,-803 # aabbccdd <_end+0x2abbacad>
80000310:	2a771e63          	bne	a4,t2,800005cc <fail>
80000314:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000318:	00200293          	li	t0,2
8000031c:	fc521ae3          	bne	tp,t0,800002f0 <test_12+0x8>

80000320 <test_13>:
80000320:	00d00193          	li	gp,13
80000324:	00000213          	li	tp,0
80000328:	daabc0b7          	lui	ra,0xdaabc
8000032c:	ccd08093          	addi	ra,ra,-819 # daabbccd <_end+0x5aab9c9d>
80000330:	00002117          	auipc	sp,0x2
80000334:	cd010113          	addi	sp,sp,-816 # 80002000 <begin_signature>
80000338:	00000013          	nop
8000033c:	00112223          	sw	ra,4(sp)
80000340:	00412703          	lw	a4,4(sp)
80000344:	daabc3b7          	lui	t2,0xdaabc
80000348:	ccd38393          	addi	t2,t2,-819 # daabbccd <_end+0x5aab9c9d>
8000034c:	28771063          	bne	a4,t2,800005cc <fail>
80000350:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000354:	00200293          	li	t0,2
80000358:	fc5218e3          	bne	tp,t0,80000328 <test_13+0x8>

8000035c <test_14>:
8000035c:	00e00193          	li	gp,14
80000360:	00000213          	li	tp,0
80000364:	ddaac0b7          	lui	ra,0xddaac
80000368:	bcc08093          	addi	ra,ra,-1076 # ddaabbcc <_end+0x5daa9b9c>
8000036c:	00002117          	auipc	sp,0x2
80000370:	c9410113          	addi	sp,sp,-876 # 80002000 <begin_signature>
80000374:	00000013          	nop
80000378:	00000013          	nop
8000037c:	00112423          	sw	ra,8(sp)
80000380:	00812703          	lw	a4,8(sp)
80000384:	ddaac3b7          	lui	t2,0xddaac
80000388:	bcc38393          	addi	t2,t2,-1076 # ddaabbcc <_end+0x5daa9b9c>
8000038c:	24771063          	bne	a4,t2,800005cc <fail>
80000390:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000394:	00200293          	li	t0,2
80000398:	fc5216e3          	bne	tp,t0,80000364 <test_14+0x8>

8000039c <test_15>:
8000039c:	00f00193          	li	gp,15
800003a0:	00000213          	li	tp,0
800003a4:	cddab0b7          	lui	ra,0xcddab
800003a8:	bbc08093          	addi	ra,ra,-1092 # cddaabbc <_end+0x4dda8b8c>
800003ac:	00000013          	nop
800003b0:	00002117          	auipc	sp,0x2
800003b4:	c5010113          	addi	sp,sp,-944 # 80002000 <begin_signature>
800003b8:	00112623          	sw	ra,12(sp)
800003bc:	00c12703          	lw	a4,12(sp)
800003c0:	cddab3b7          	lui	t2,0xcddab
800003c4:	bbc38393          	addi	t2,t2,-1092 # cddaabbc <_end+0x4dda8b8c>
800003c8:	20771263          	bne	a4,t2,800005cc <fail>
800003cc:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800003d0:	00200293          	li	t0,2
800003d4:	fc5218e3          	bne	tp,t0,800003a4 <test_15+0x8>

800003d8 <test_16>:
800003d8:	01000193          	li	gp,16
800003dc:	00000213          	li	tp,0
800003e0:	ccddb0b7          	lui	ra,0xccddb
800003e4:	abb08093          	addi	ra,ra,-1349 # ccddaabb <_end+0x4cdd8a8b>
800003e8:	00000013          	nop
800003ec:	00002117          	auipc	sp,0x2
800003f0:	c1410113          	addi	sp,sp,-1004 # 80002000 <begin_signature>
800003f4:	00000013          	nop
800003f8:	00112823          	sw	ra,16(sp)
800003fc:	01012703          	lw	a4,16(sp)
80000400:	ccddb3b7          	lui	t2,0xccddb
80000404:	abb38393          	addi	t2,t2,-1349 # ccddaabb <_end+0x4cdd8a8b>
80000408:	1c771263          	bne	a4,t2,800005cc <fail>
8000040c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000410:	00200293          	li	t0,2
80000414:	fc5216e3          	bne	tp,t0,800003e0 <test_16+0x8>

80000418 <test_17>:
80000418:	01100193          	li	gp,17
8000041c:	00000213          	li	tp,0
80000420:	bccde0b7          	lui	ra,0xbccde
80000424:	aab08093          	addi	ra,ra,-1365 # bccddaab <_end+0x3ccdba7b>
80000428:	00000013          	nop
8000042c:	00000013          	nop
80000430:	00002117          	auipc	sp,0x2
80000434:	bd010113          	addi	sp,sp,-1072 # 80002000 <begin_signature>
80000438:	00112a23          	sw	ra,20(sp)
8000043c:	01412703          	lw	a4,20(sp)
80000440:	bccde3b7          	lui	t2,0xbccde
80000444:	aab38393          	addi	t2,t2,-1365 # bccddaab <_end+0x3ccdba7b>
80000448:	18771263          	bne	a4,t2,800005cc <fail>
8000044c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000450:	00200293          	li	t0,2
80000454:	fc5216e3          	bne	tp,t0,80000420 <test_17+0x8>

80000458 <test_18>:
80000458:	01200193          	li	gp,18
8000045c:	00000213          	li	tp,0
80000460:	00002117          	auipc	sp,0x2
80000464:	ba010113          	addi	sp,sp,-1120 # 80002000 <begin_signature>
80000468:	001120b7          	lui	ra,0x112
8000046c:	23308093          	addi	ra,ra,563 # 112233 <_start-0x7feeddcd>
80000470:	00112023          	sw	ra,0(sp)
80000474:	00012703          	lw	a4,0(sp)
80000478:	001123b7          	lui	t2,0x112
8000047c:	23338393          	addi	t2,t2,563 # 112233 <_start-0x7feeddcd>
80000480:	14771663          	bne	a4,t2,800005cc <fail>
80000484:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000488:	00200293          	li	t0,2
8000048c:	fc521ae3          	bne	tp,t0,80000460 <test_18+0x8>

80000490 <test_19>:
80000490:	01300193          	li	gp,19
80000494:	00000213          	li	tp,0
80000498:	00002117          	auipc	sp,0x2
8000049c:	b6810113          	addi	sp,sp,-1176 # 80002000 <begin_signature>
800004a0:	300110b7          	lui	ra,0x30011
800004a4:	22308093          	addi	ra,ra,547 # 30011223 <_start-0x4ffeeddd>
800004a8:	00000013          	nop
800004ac:	00112223          	sw	ra,4(sp)
800004b0:	00412703          	lw	a4,4(sp)
800004b4:	300113b7          	lui	t2,0x30011
800004b8:	22338393          	addi	t2,t2,547 # 30011223 <_start-0x4ffeeddd>
800004bc:	10771863          	bne	a4,t2,800005cc <fail>
800004c0:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800004c4:	00200293          	li	t0,2
800004c8:	fc5218e3          	bne	tp,t0,80000498 <test_19+0x8>

800004cc <test_20>:
800004cc:	01400193          	li	gp,20
800004d0:	00000213          	li	tp,0
800004d4:	00002117          	auipc	sp,0x2
800004d8:	b2c10113          	addi	sp,sp,-1236 # 80002000 <begin_signature>
800004dc:	330010b7          	lui	ra,0x33001
800004e0:	12208093          	addi	ra,ra,290 # 33001122 <_start-0x4cffeede>
800004e4:	00000013          	nop
800004e8:	00000013          	nop
800004ec:	00112423          	sw	ra,8(sp)
800004f0:	00812703          	lw	a4,8(sp)
800004f4:	330013b7          	lui	t2,0x33001
800004f8:	12238393          	addi	t2,t2,290 # 33001122 <_start-0x4cffeede>
800004fc:	0c771863          	bne	a4,t2,800005cc <fail>
80000500:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000504:	00200293          	li	t0,2
80000508:	fc5216e3          	bne	tp,t0,800004d4 <test_20+0x8>

8000050c <test_21>:
8000050c:	01500193          	li	gp,21
80000510:	00000213          	li	tp,0
80000514:	00002117          	auipc	sp,0x2
80000518:	aec10113          	addi	sp,sp,-1300 # 80002000 <begin_signature>
8000051c:	00000013          	nop
80000520:	233000b7          	lui	ra,0x23300
80000524:	11208093          	addi	ra,ra,274 # 23300112 <_start-0x5ccffeee>
80000528:	00112623          	sw	ra,12(sp)
8000052c:	00c12703          	lw	a4,12(sp)
80000530:	233003b7          	lui	t2,0x23300
80000534:	11238393          	addi	t2,t2,274 # 23300112 <_start-0x5ccffeee>
80000538:	08771a63          	bne	a4,t2,800005cc <fail>
8000053c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000540:	00200293          	li	t0,2
80000544:	fc5218e3          	bne	tp,t0,80000514 <test_21+0x8>

80000548 <test_22>:
80000548:	01600193          	li	gp,22
8000054c:	00000213          	li	tp,0
80000550:	00002117          	auipc	sp,0x2
80000554:	ab010113          	addi	sp,sp,-1360 # 80002000 <begin_signature>
80000558:	00000013          	nop
8000055c:	223300b7          	lui	ra,0x22330
80000560:	01108093          	addi	ra,ra,17 # 22330011 <_start-0x5dccffef>
80000564:	00000013          	nop
80000568:	00112823          	sw	ra,16(sp)
8000056c:	01012703          	lw	a4,16(sp)
80000570:	223303b7          	lui	t2,0x22330
80000574:	01138393          	addi	t2,t2,17 # 22330011 <_start-0x5dccffef>
80000578:	04771a63          	bne	a4,t2,800005cc <fail>
8000057c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000580:	00200293          	li	t0,2
80000584:	fc5216e3          	bne	tp,t0,80000550 <test_22+0x8>

80000588 <test_23>:
80000588:	01700193          	li	gp,23
8000058c:	00000213          	li	tp,0
80000590:	00002117          	auipc	sp,0x2
80000594:	a7010113          	addi	sp,sp,-1424 # 80002000 <begin_signature>
80000598:	00000013          	nop
8000059c:	00000013          	nop
800005a0:	122330b7          	lui	ra,0x12233
800005a4:	00108093          	addi	ra,ra,1 # 12233001 <_start-0x6ddccfff>
800005a8:	00112a23          	sw	ra,20(sp)
800005ac:	01412703          	lw	a4,20(sp)
800005b0:	122333b7          	lui	t2,0x12233
800005b4:	00138393          	addi	t2,t2,1 # 12233001 <_start-0x6ddccfff>
800005b8:	00771a63          	bne	a4,t2,800005cc <fail>
800005bc:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800005c0:	00200293          	li	t0,2
800005c4:	fc5216e3          	bne	tp,t0,80000590 <test_23+0x8>
800005c8:	00301a63          	bne	zero,gp,800005dc <pass>

800005cc <fail>:
800005cc:	803002b7          	lui	t0,0x80300
800005d0:	55500313          	li	t1,1365
800005d4:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fdfd0>
800005d8:	a2dff06f          	j	80000004 <loop>

800005dc <pass>:
800005dc:	803002b7          	lui	t0,0x80300
800005e0:	66600313          	li	t1,1638
800005e4:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fdfd0>
800005e8:	a1dff06f          	j	80000004 <loop>
800005ec:	c0001073          	unimp
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
80002000:	deadbeef          	jal	t4,7ffdd5ea <_start-0x22a16>

80002004 <tdat2>:
80002004:	deadbeef          	jal	t4,7ffdd5ee <_start-0x22a12>

80002008 <tdat3>:
80002008:	deadbeef          	jal	t4,7ffdd5f2 <_start-0x22a0e>

8000200c <tdat4>:
8000200c:	deadbeef          	jal	t4,7ffdd5f6 <_start-0x22a0a>

80002010 <tdat5>:
80002010:	deadbeef          	jal	t4,7ffdd5fa <_start-0x22a06>

80002014 <tdat6>:
80002014:	deadbeef          	jal	t4,7ffdd5fe <_start-0x22a02>

80002018 <tdat7>:
80002018:	deadbeef          	jal	t4,7ffdd602 <_start-0x229fe>

8000201c <tdat8>:
8000201c:	deadbeef          	jal	t4,7ffdd606 <_start-0x229fa>

80002020 <tdat9>:
80002020:	deadbeef          	jal	t4,7ffdd60a <_start-0x229f6>

80002024 <tdat10>:
80002024:	deadbeef          	jal	t4,7ffdd60e <_start-0x229f2>
80002028:	0000                	unimp
8000202a:	0000                	unimp
8000202c:	0000                	unimp
8000202e:	0000                	unimp
