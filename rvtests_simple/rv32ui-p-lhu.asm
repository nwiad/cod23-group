
rv32ui-p-lhu：     文件格式 elf32-littleriscv


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
800000d8:	0000d703          	lhu	a4,0(ra)
800000dc:	0ff00393          	li	t2,255
800000e0:	2a771063          	bne	a4,t2,80000380 <fail>

800000e4 <test_3>:
800000e4:	00300193          	li	gp,3
800000e8:	000107b7          	lui	a5,0x10
800000ec:	f0078793          	addi	a5,a5,-256 # ff00 <_start-0x7fff0100>
800000f0:	00002097          	auipc	ra,0x2
800000f4:	f1008093          	addi	ra,ra,-240 # 80002000 <begin_signature>
800000f8:	0020d703          	lhu	a4,2(ra)
800000fc:	000103b7          	lui	t2,0x10
80000100:	f0038393          	addi	t2,t2,-256 # ff00 <_start-0x7fff0100>
80000104:	26771e63          	bne	a4,t2,80000380 <fail>

80000108 <test_4>:
80000108:	00400193          	li	gp,4
8000010c:	000017b7          	lui	a5,0x1
80000110:	ff078793          	addi	a5,a5,-16 # ff0 <_start-0x7ffff010>
80000114:	00002097          	auipc	ra,0x2
80000118:	eec08093          	addi	ra,ra,-276 # 80002000 <begin_signature>
8000011c:	0040d703          	lhu	a4,4(ra)
80000120:	000013b7          	lui	t2,0x1
80000124:	ff038393          	addi	t2,t2,-16 # ff0 <_start-0x7ffff010>
80000128:	24771c63          	bne	a4,t2,80000380 <fail>

8000012c <test_5>:
8000012c:	00500193          	li	gp,5
80000130:	0000f7b7          	lui	a5,0xf
80000134:	00f78793          	addi	a5,a5,15 # f00f <_start-0x7fff0ff1>
80000138:	00002097          	auipc	ra,0x2
8000013c:	ec808093          	addi	ra,ra,-312 # 80002000 <begin_signature>
80000140:	0060d703          	lhu	a4,6(ra)
80000144:	0000f3b7          	lui	t2,0xf
80000148:	00f38393          	addi	t2,t2,15 # f00f <_start-0x7fff0ff1>
8000014c:	22771a63          	bne	a4,t2,80000380 <fail>

80000150 <test_6>:
80000150:	00600193          	li	gp,6
80000154:	0ff00793          	li	a5,255
80000158:	00002097          	auipc	ra,0x2
8000015c:	eae08093          	addi	ra,ra,-338 # 80002006 <tdat4>
80000160:	ffa0d703          	lhu	a4,-6(ra)
80000164:	0ff00393          	li	t2,255
80000168:	20771c63          	bne	a4,t2,80000380 <fail>

8000016c <test_7>:
8000016c:	00700193          	li	gp,7
80000170:	000107b7          	lui	a5,0x10
80000174:	f0078793          	addi	a5,a5,-256 # ff00 <_start-0x7fff0100>
80000178:	00002097          	auipc	ra,0x2
8000017c:	e8e08093          	addi	ra,ra,-370 # 80002006 <tdat4>
80000180:	ffc0d703          	lhu	a4,-4(ra)
80000184:	000103b7          	lui	t2,0x10
80000188:	f0038393          	addi	t2,t2,-256 # ff00 <_start-0x7fff0100>
8000018c:	1e771a63          	bne	a4,t2,80000380 <fail>

80000190 <test_8>:
80000190:	00800193          	li	gp,8
80000194:	000017b7          	lui	a5,0x1
80000198:	ff078793          	addi	a5,a5,-16 # ff0 <_start-0x7ffff010>
8000019c:	00002097          	auipc	ra,0x2
800001a0:	e6a08093          	addi	ra,ra,-406 # 80002006 <tdat4>
800001a4:	ffe0d703          	lhu	a4,-2(ra)
800001a8:	000013b7          	lui	t2,0x1
800001ac:	ff038393          	addi	t2,t2,-16 # ff0 <_start-0x7ffff010>
800001b0:	1c771863          	bne	a4,t2,80000380 <fail>

800001b4 <test_9>:
800001b4:	00900193          	li	gp,9
800001b8:	0000f7b7          	lui	a5,0xf
800001bc:	00f78793          	addi	a5,a5,15 # f00f <_start-0x7fff0ff1>
800001c0:	00002097          	auipc	ra,0x2
800001c4:	e4608093          	addi	ra,ra,-442 # 80002006 <tdat4>
800001c8:	0000d703          	lhu	a4,0(ra)
800001cc:	0000f3b7          	lui	t2,0xf
800001d0:	00f38393          	addi	t2,t2,15 # f00f <_start-0x7fff0ff1>
800001d4:	1a771663          	bne	a4,t2,80000380 <fail>

800001d8 <test_10>:
800001d8:	00a00193          	li	gp,10
800001dc:	00002097          	auipc	ra,0x2
800001e0:	e2408093          	addi	ra,ra,-476 # 80002000 <begin_signature>
800001e4:	fe008093          	addi	ra,ra,-32
800001e8:	0200d283          	lhu	t0,32(ra)
800001ec:	0ff00393          	li	t2,255
800001f0:	18729863          	bne	t0,t2,80000380 <fail>

800001f4 <test_11>:
800001f4:	00b00193          	li	gp,11
800001f8:	00002097          	auipc	ra,0x2
800001fc:	e0808093          	addi	ra,ra,-504 # 80002000 <begin_signature>
80000200:	ffb08093          	addi	ra,ra,-5
80000204:	0070d283          	lhu	t0,7(ra)
80000208:	000103b7          	lui	t2,0x10
8000020c:	f0038393          	addi	t2,t2,-256 # ff00 <_start-0x7fff0100>
80000210:	16729863          	bne	t0,t2,80000380 <fail>

80000214 <test_12>:
80000214:	00c00193          	li	gp,12
80000218:	00000213          	li	tp,0
8000021c:	00002097          	auipc	ra,0x2
80000220:	de608093          	addi	ra,ra,-538 # 80002002 <tdat2>
80000224:	0020d703          	lhu	a4,2(ra)
80000228:	00070313          	mv	t1,a4
8000022c:	000013b7          	lui	t2,0x1
80000230:	ff038393          	addi	t2,t2,-16 # ff0 <_start-0x7ffff010>
80000234:	14731663          	bne	t1,t2,80000380 <fail>
80000238:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000023c:	00200293          	li	t0,2
80000240:	fc521ee3          	bne	tp,t0,8000021c <test_12+0x8>

80000244 <test_13>:
80000244:	00d00193          	li	gp,13
80000248:	00000213          	li	tp,0
8000024c:	00002097          	auipc	ra,0x2
80000250:	db808093          	addi	ra,ra,-584 # 80002004 <tdat3>
80000254:	0020d703          	lhu	a4,2(ra)
80000258:	00000013          	nop
8000025c:	00070313          	mv	t1,a4
80000260:	0000f3b7          	lui	t2,0xf
80000264:	00f38393          	addi	t2,t2,15 # f00f <_start-0x7fff0ff1>
80000268:	10731c63          	bne	t1,t2,80000380 <fail>
8000026c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000270:	00200293          	li	t0,2
80000274:	fc521ce3          	bne	tp,t0,8000024c <test_13+0x8>

80000278 <test_14>:
80000278:	00e00193          	li	gp,14
8000027c:	00000213          	li	tp,0
80000280:	00002097          	auipc	ra,0x2
80000284:	d8008093          	addi	ra,ra,-640 # 80002000 <begin_signature>
80000288:	0020d703          	lhu	a4,2(ra)
8000028c:	00000013          	nop
80000290:	00000013          	nop
80000294:	00070313          	mv	t1,a4
80000298:	000103b7          	lui	t2,0x10
8000029c:	f0038393          	addi	t2,t2,-256 # ff00 <_start-0x7fff0100>
800002a0:	0e731063          	bne	t1,t2,80000380 <fail>
800002a4:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002a8:	00200293          	li	t0,2
800002ac:	fc521ae3          	bne	tp,t0,80000280 <test_14+0x8>

800002b0 <test_15>:
800002b0:	00f00193          	li	gp,15
800002b4:	00000213          	li	tp,0
800002b8:	00002097          	auipc	ra,0x2
800002bc:	d4a08093          	addi	ra,ra,-694 # 80002002 <tdat2>
800002c0:	0020d703          	lhu	a4,2(ra)
800002c4:	000013b7          	lui	t2,0x1
800002c8:	ff038393          	addi	t2,t2,-16 # ff0 <_start-0x7ffff010>
800002cc:	0a771a63          	bne	a4,t2,80000380 <fail>
800002d0:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002d4:	00200293          	li	t0,2
800002d8:	fe5210e3          	bne	tp,t0,800002b8 <test_15+0x8>

800002dc <test_16>:
800002dc:	01000193          	li	gp,16
800002e0:	00000213          	li	tp,0
800002e4:	00002097          	auipc	ra,0x2
800002e8:	d2008093          	addi	ra,ra,-736 # 80002004 <tdat3>
800002ec:	00000013          	nop
800002f0:	0020d703          	lhu	a4,2(ra)
800002f4:	0000f3b7          	lui	t2,0xf
800002f8:	00f38393          	addi	t2,t2,15 # f00f <_start-0x7fff0ff1>
800002fc:	08771263          	bne	a4,t2,80000380 <fail>
80000300:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000304:	00200293          	li	t0,2
80000308:	fc521ee3          	bne	tp,t0,800002e4 <test_16+0x8>

8000030c <test_17>:
8000030c:	01100193          	li	gp,17
80000310:	00000213          	li	tp,0
80000314:	00002097          	auipc	ra,0x2
80000318:	cec08093          	addi	ra,ra,-788 # 80002000 <begin_signature>
8000031c:	00000013          	nop
80000320:	00000013          	nop
80000324:	0020d703          	lhu	a4,2(ra)
80000328:	000103b7          	lui	t2,0x10
8000032c:	f0038393          	addi	t2,t2,-256 # ff00 <_start-0x7fff0100>
80000330:	04771863          	bne	a4,t2,80000380 <fail>
80000334:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000338:	00200293          	li	t0,2
8000033c:	fc521ce3          	bne	tp,t0,80000314 <test_17+0x8>

80000340 <test_18>:
80000340:	01200193          	li	gp,18
80000344:	00002297          	auipc	t0,0x2
80000348:	cbc28293          	addi	t0,t0,-836 # 80002000 <begin_signature>
8000034c:	0002d103          	lhu	sp,0(t0)
80000350:	00200113          	li	sp,2
80000354:	00200393          	li	t2,2
80000358:	02711463          	bne	sp,t2,80000380 <fail>

8000035c <test_19>:
8000035c:	01300193          	li	gp,19
80000360:	00002297          	auipc	t0,0x2
80000364:	ca028293          	addi	t0,t0,-864 # 80002000 <begin_signature>
80000368:	0002d103          	lhu	sp,0(t0)
8000036c:	00000013          	nop
80000370:	00200113          	li	sp,2
80000374:	00200393          	li	t2,2
80000378:	00711463          	bne	sp,t2,80000380 <fail>
8000037c:	00301a63          	bne	zero,gp,80000390 <pass>

80000380 <fail>:
80000380:	803002b7          	lui	t0,0x80300
80000384:	55500313          	li	t1,1365
80000388:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fdff0>
8000038c:	c79ff06f          	j	80000004 <loop>

80000390 <pass>:
80000390:	803002b7          	lui	t0,0x80300
80000394:	66600313          	li	t1,1638
80000398:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fdff0>
8000039c:	c69ff06f          	j	80000004 <loop>
800003a0:	c0001073          	unimp
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
