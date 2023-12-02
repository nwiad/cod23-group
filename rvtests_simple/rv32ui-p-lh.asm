
rv32ui-p-lh：     文件格式 elf32-littleriscv


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
800000cc:	0ff00793          	li	a5,255
800000d0:	00002097          	auipc	ra,0x2
800000d4:	f3008093          	addi	ra,ra,-208 # 80002000 <begin_signature>
800000d8:	00009703          	lh	a4,0(ra)
800000dc:	0ff00393          	li	t2,255
800000e0:	28771263          	bne	a4,t2,80000364 <fail>

800000e4 <test_3>:
800000e4:	00300193          	li	gp,3
800000e8:	f0000793          	li	a5,-256
800000ec:	00002097          	auipc	ra,0x2
800000f0:	f1408093          	addi	ra,ra,-236 # 80002000 <begin_signature>
800000f4:	00209703          	lh	a4,2(ra)
800000f8:	f0000393          	li	t2,-256
800000fc:	26771463          	bne	a4,t2,80000364 <fail>

80000100 <test_4>:
80000100:	00400193          	li	gp,4
80000104:	000017b7          	lui	a5,0x1
80000108:	ff078793          	addi	a5,a5,-16 # ff0 <_start-0x7ffff010>
8000010c:	00002097          	auipc	ra,0x2
80000110:	ef408093          	addi	ra,ra,-268 # 80002000 <begin_signature>
80000114:	00409703          	lh	a4,4(ra)
80000118:	000013b7          	lui	t2,0x1
8000011c:	ff038393          	addi	t2,t2,-16 # ff0 <_start-0x7ffff010>
80000120:	24771263          	bne	a4,t2,80000364 <fail>

80000124 <test_5>:
80000124:	00500193          	li	gp,5
80000128:	fffff7b7          	lui	a5,0xfffff
8000012c:	00f78793          	addi	a5,a5,15 # fffff00f <_end+0x7fffcfff>
80000130:	00002097          	auipc	ra,0x2
80000134:	ed008093          	addi	ra,ra,-304 # 80002000 <begin_signature>
80000138:	00609703          	lh	a4,6(ra)
8000013c:	fffff3b7          	lui	t2,0xfffff
80000140:	00f38393          	addi	t2,t2,15 # fffff00f <_end+0x7fffcfff>
80000144:	22771063          	bne	a4,t2,80000364 <fail>

80000148 <test_6>:
80000148:	00600193          	li	gp,6
8000014c:	0ff00793          	li	a5,255
80000150:	00002097          	auipc	ra,0x2
80000154:	eb608093          	addi	ra,ra,-330 # 80002006 <tdat4>
80000158:	ffa09703          	lh	a4,-6(ra)
8000015c:	0ff00393          	li	t2,255
80000160:	20771263          	bne	a4,t2,80000364 <fail>

80000164 <test_7>:
80000164:	00700193          	li	gp,7
80000168:	f0000793          	li	a5,-256
8000016c:	00002097          	auipc	ra,0x2
80000170:	e9a08093          	addi	ra,ra,-358 # 80002006 <tdat4>
80000174:	ffc09703          	lh	a4,-4(ra)
80000178:	f0000393          	li	t2,-256
8000017c:	1e771463          	bne	a4,t2,80000364 <fail>

80000180 <test_8>:
80000180:	00800193          	li	gp,8
80000184:	000017b7          	lui	a5,0x1
80000188:	ff078793          	addi	a5,a5,-16 # ff0 <_start-0x7ffff010>
8000018c:	00002097          	auipc	ra,0x2
80000190:	e7a08093          	addi	ra,ra,-390 # 80002006 <tdat4>
80000194:	ffe09703          	lh	a4,-2(ra)
80000198:	000013b7          	lui	t2,0x1
8000019c:	ff038393          	addi	t2,t2,-16 # ff0 <_start-0x7ffff010>
800001a0:	1c771263          	bne	a4,t2,80000364 <fail>

800001a4 <test_9>:
800001a4:	00900193          	li	gp,9
800001a8:	fffff7b7          	lui	a5,0xfffff
800001ac:	00f78793          	addi	a5,a5,15 # fffff00f <_end+0x7fffcfff>
800001b0:	00002097          	auipc	ra,0x2
800001b4:	e5608093          	addi	ra,ra,-426 # 80002006 <tdat4>
800001b8:	00009703          	lh	a4,0(ra)
800001bc:	fffff3b7          	lui	t2,0xfffff
800001c0:	00f38393          	addi	t2,t2,15 # fffff00f <_end+0x7fffcfff>
800001c4:	1a771063          	bne	a4,t2,80000364 <fail>

800001c8 <test_10>:
800001c8:	00a00193          	li	gp,10
800001cc:	00002097          	auipc	ra,0x2
800001d0:	e3408093          	addi	ra,ra,-460 # 80002000 <begin_signature>
800001d4:	fe008093          	addi	ra,ra,-32
800001d8:	02009283          	lh	t0,32(ra)
800001dc:	0ff00393          	li	t2,255
800001e0:	18729263          	bne	t0,t2,80000364 <fail>

800001e4 <test_11>:
800001e4:	00b00193          	li	gp,11
800001e8:	00002097          	auipc	ra,0x2
800001ec:	e1808093          	addi	ra,ra,-488 # 80002000 <begin_signature>
800001f0:	ffb08093          	addi	ra,ra,-5
800001f4:	00709283          	lh	t0,7(ra)
800001f8:	f0000393          	li	t2,-256
800001fc:	16729463          	bne	t0,t2,80000364 <fail>

80000200 <test_12>:
80000200:	00c00193          	li	gp,12
80000204:	00000213          	li	tp,0
80000208:	00002097          	auipc	ra,0x2
8000020c:	dfa08093          	addi	ra,ra,-518 # 80002002 <tdat2>
80000210:	00209703          	lh	a4,2(ra)
80000214:	00070313          	mv	t1,a4
80000218:	000013b7          	lui	t2,0x1
8000021c:	ff038393          	addi	t2,t2,-16 # ff0 <_start-0x7ffff010>
80000220:	14731263          	bne	t1,t2,80000364 <fail>
80000224:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000228:	00200293          	li	t0,2
8000022c:	fc521ee3          	bne	tp,t0,80000208 <test_12+0x8>

80000230 <test_13>:
80000230:	00d00193          	li	gp,13
80000234:	00000213          	li	tp,0
80000238:	00002097          	auipc	ra,0x2
8000023c:	dcc08093          	addi	ra,ra,-564 # 80002004 <tdat3>
80000240:	00209703          	lh	a4,2(ra)
80000244:	00000013          	nop
80000248:	00070313          	mv	t1,a4
8000024c:	fffff3b7          	lui	t2,0xfffff
80000250:	00f38393          	addi	t2,t2,15 # fffff00f <_end+0x7fffcfff>
80000254:	10731863          	bne	t1,t2,80000364 <fail>
80000258:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000025c:	00200293          	li	t0,2
80000260:	fc521ce3          	bne	tp,t0,80000238 <test_13+0x8>

80000264 <test_14>:
80000264:	00e00193          	li	gp,14
80000268:	00000213          	li	tp,0
8000026c:	00002097          	auipc	ra,0x2
80000270:	d9408093          	addi	ra,ra,-620 # 80002000 <begin_signature>
80000274:	00209703          	lh	a4,2(ra)
80000278:	00000013          	nop
8000027c:	00000013          	nop
80000280:	00070313          	mv	t1,a4
80000284:	f0000393          	li	t2,-256
80000288:	0c731e63          	bne	t1,t2,80000364 <fail>
8000028c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000290:	00200293          	li	t0,2
80000294:	fc521ce3          	bne	tp,t0,8000026c <test_14+0x8>

80000298 <test_15>:
80000298:	00f00193          	li	gp,15
8000029c:	00000213          	li	tp,0
800002a0:	00002097          	auipc	ra,0x2
800002a4:	d6208093          	addi	ra,ra,-670 # 80002002 <tdat2>
800002a8:	00209703          	lh	a4,2(ra)
800002ac:	000013b7          	lui	t2,0x1
800002b0:	ff038393          	addi	t2,t2,-16 # ff0 <_start-0x7ffff010>
800002b4:	0a771863          	bne	a4,t2,80000364 <fail>
800002b8:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002bc:	00200293          	li	t0,2
800002c0:	fe5210e3          	bne	tp,t0,800002a0 <test_15+0x8>

800002c4 <test_16>:
800002c4:	01000193          	li	gp,16
800002c8:	00000213          	li	tp,0
800002cc:	00002097          	auipc	ra,0x2
800002d0:	d3808093          	addi	ra,ra,-712 # 80002004 <tdat3>
800002d4:	00000013          	nop
800002d8:	00209703          	lh	a4,2(ra)
800002dc:	fffff3b7          	lui	t2,0xfffff
800002e0:	00f38393          	addi	t2,t2,15 # fffff00f <_end+0x7fffcfff>
800002e4:	08771063          	bne	a4,t2,80000364 <fail>
800002e8:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002ec:	00200293          	li	t0,2
800002f0:	fc521ee3          	bne	tp,t0,800002cc <test_16+0x8>

800002f4 <test_17>:
800002f4:	01100193          	li	gp,17
800002f8:	00000213          	li	tp,0
800002fc:	00002097          	auipc	ra,0x2
80000300:	d0408093          	addi	ra,ra,-764 # 80002000 <begin_signature>
80000304:	00000013          	nop
80000308:	00000013          	nop
8000030c:	00209703          	lh	a4,2(ra)
80000310:	f0000393          	li	t2,-256
80000314:	04771863          	bne	a4,t2,80000364 <fail>
80000318:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000031c:	00200293          	li	t0,2
80000320:	fc521ee3          	bne	tp,t0,800002fc <test_17+0x8>

80000324 <test_18>:
80000324:	01200193          	li	gp,18
80000328:	00002297          	auipc	t0,0x2
8000032c:	cd828293          	addi	t0,t0,-808 # 80002000 <begin_signature>
80000330:	00029103          	lh	sp,0(t0)
80000334:	00200113          	li	sp,2
80000338:	00200393          	li	t2,2
8000033c:	02711463          	bne	sp,t2,80000364 <fail>

80000340 <test_19>:
80000340:	01300193          	li	gp,19
80000344:	00002297          	auipc	t0,0x2
80000348:	cbc28293          	addi	t0,t0,-836 # 80002000 <begin_signature>
8000034c:	00029103          	lh	sp,0(t0)
80000350:	00000013          	nop
80000354:	00200113          	li	sp,2
80000358:	00200393          	li	t2,2
8000035c:	00711463          	bne	sp,t2,80000364 <fail>
80000360:	00301a63          	bne	zero,gp,80000374 <pass>

80000364 <fail>:
80000364:	803002b7          	lui	t0,0x80300
80000368:	55500313          	li	t1,1365
8000036c:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fdff0>
80000370:	c95ff06f          	j	80000004 <loop>

80000374 <pass>:
80000374:	803002b7          	lui	t0,0x80300
80000378:	66600313          	li	t1,1638
8000037c:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fdff0>
80000380:	c85ff06f          	j	80000004 <loop>
80000384:	c0001073          	unimp
80000388:	0000                	unimp
8000038a:	0000                	unimp
8000038c:	0000                	unimp
8000038e:	0000                	unimp
80000390:	0000                	unimp
80000392:	0000                	unimp
80000394:	0000                	unimp
80000396:	0000                	unimp
80000398:	0000                	unimp
8000039a:	0000                	unimp
8000039c:	0000                	unimp
8000039e:	0000                	unimp
800003a0:	0000                	unimp
800003a2:	0000                	unimp
800003a4:	0000                	unimp
800003a6:	0000                	unimp
800003a8:	0000                	unimp
800003aa:	0000                	unimp
800003ac:	0000                	unimp
800003ae:	0000                	unimp
800003b0:	0000                	unimp
800003b2:	0000                	unimp
800003b4:	0000                	unimp
800003b6:	0000                	unimp
800003b8:	0000                	unimp
800003ba:	0000                	unimp
800003bc:	0000                	unimp
800003be:	0000                	unimp

Disassembly of section .data:

80002000 <begin_signature>:
80002000:	00ff                	0xff

80002002 <tdat2>:
80002002:	ff00                	fsw	fs0,56(a4)

80002004 <tdat3>:
80002004:	0ff0                	addi	a2,sp,988

80002006 <tdat4>:
80002006:	0000f00f          	0xf00f
8000200a:	0000                	unimp
8000200c:	0000                	unimp
8000200e:	0000                	unimp
