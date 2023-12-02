
rv32ui-p-lw：     文件格式 elf32-littleriscv


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
800000cc:	00ff07b7          	lui	a5,0xff0
800000d0:	0ff78793          	addi	a5,a5,255 # ff00ff <_start-0x7f00ff01>
800000d4:	00002097          	auipc	ra,0x2
800000d8:	f2c08093          	addi	ra,ra,-212 # 80002000 <begin_signature>
800000dc:	0000a703          	lw	a4,0(ra)
800000e0:	00ff03b7          	lui	t2,0xff0
800000e4:	0ff38393          	addi	t2,t2,255 # ff00ff <_start-0x7f00ff01>
800000e8:	2a771663          	bne	a4,t2,80000394 <fail>

800000ec <test_3>:
800000ec:	00300193          	li	gp,3
800000f0:	ff0107b7          	lui	a5,0xff010
800000f4:	f0078793          	addi	a5,a5,-256 # ff00ff00 <_end+0x7f00def0>
800000f8:	00002097          	auipc	ra,0x2
800000fc:	f0808093          	addi	ra,ra,-248 # 80002000 <begin_signature>
80000100:	0040a703          	lw	a4,4(ra)
80000104:	ff0103b7          	lui	t2,0xff010
80000108:	f0038393          	addi	t2,t2,-256 # ff00ff00 <_end+0x7f00def0>
8000010c:	28771463          	bne	a4,t2,80000394 <fail>

80000110 <test_4>:
80000110:	00400193          	li	gp,4
80000114:	0ff017b7          	lui	a5,0xff01
80000118:	ff078793          	addi	a5,a5,-16 # ff00ff0 <_start-0x700ff010>
8000011c:	00002097          	auipc	ra,0x2
80000120:	ee408093          	addi	ra,ra,-284 # 80002000 <begin_signature>
80000124:	0080a703          	lw	a4,8(ra)
80000128:	0ff013b7          	lui	t2,0xff01
8000012c:	ff038393          	addi	t2,t2,-16 # ff00ff0 <_start-0x700ff010>
80000130:	26771263          	bne	a4,t2,80000394 <fail>

80000134 <test_5>:
80000134:	00500193          	li	gp,5
80000138:	f00ff7b7          	lui	a5,0xf00ff
8000013c:	00f78793          	addi	a5,a5,15 # f00ff00f <_end+0x700fcfff>
80000140:	00002097          	auipc	ra,0x2
80000144:	ec008093          	addi	ra,ra,-320 # 80002000 <begin_signature>
80000148:	00c0a703          	lw	a4,12(ra)
8000014c:	f00ff3b7          	lui	t2,0xf00ff
80000150:	00f38393          	addi	t2,t2,15 # f00ff00f <_end+0x700fcfff>
80000154:	24771063          	bne	a4,t2,80000394 <fail>

80000158 <test_6>:
80000158:	00600193          	li	gp,6
8000015c:	00ff07b7          	lui	a5,0xff0
80000160:	0ff78793          	addi	a5,a5,255 # ff00ff <_start-0x7f00ff01>
80000164:	00002097          	auipc	ra,0x2
80000168:	ea808093          	addi	ra,ra,-344 # 8000200c <tdat4>
8000016c:	ff40a703          	lw	a4,-12(ra)
80000170:	00ff03b7          	lui	t2,0xff0
80000174:	0ff38393          	addi	t2,t2,255 # ff00ff <_start-0x7f00ff01>
80000178:	20771e63          	bne	a4,t2,80000394 <fail>

8000017c <test_7>:
8000017c:	00700193          	li	gp,7
80000180:	ff0107b7          	lui	a5,0xff010
80000184:	f0078793          	addi	a5,a5,-256 # ff00ff00 <_end+0x7f00def0>
80000188:	00002097          	auipc	ra,0x2
8000018c:	e8408093          	addi	ra,ra,-380 # 8000200c <tdat4>
80000190:	ff80a703          	lw	a4,-8(ra)
80000194:	ff0103b7          	lui	t2,0xff010
80000198:	f0038393          	addi	t2,t2,-256 # ff00ff00 <_end+0x7f00def0>
8000019c:	1e771c63          	bne	a4,t2,80000394 <fail>

800001a0 <test_8>:
800001a0:	00800193          	li	gp,8
800001a4:	0ff017b7          	lui	a5,0xff01
800001a8:	ff078793          	addi	a5,a5,-16 # ff00ff0 <_start-0x700ff010>
800001ac:	00002097          	auipc	ra,0x2
800001b0:	e6008093          	addi	ra,ra,-416 # 8000200c <tdat4>
800001b4:	ffc0a703          	lw	a4,-4(ra)
800001b8:	0ff013b7          	lui	t2,0xff01
800001bc:	ff038393          	addi	t2,t2,-16 # ff00ff0 <_start-0x700ff010>
800001c0:	1c771a63          	bne	a4,t2,80000394 <fail>

800001c4 <test_9>:
800001c4:	00900193          	li	gp,9
800001c8:	f00ff7b7          	lui	a5,0xf00ff
800001cc:	00f78793          	addi	a5,a5,15 # f00ff00f <_end+0x700fcfff>
800001d0:	00002097          	auipc	ra,0x2
800001d4:	e3c08093          	addi	ra,ra,-452 # 8000200c <tdat4>
800001d8:	0000a703          	lw	a4,0(ra)
800001dc:	f00ff3b7          	lui	t2,0xf00ff
800001e0:	00f38393          	addi	t2,t2,15 # f00ff00f <_end+0x700fcfff>
800001e4:	1a771863          	bne	a4,t2,80000394 <fail>

800001e8 <test_10>:
800001e8:	00a00193          	li	gp,10
800001ec:	00002097          	auipc	ra,0x2
800001f0:	e1408093          	addi	ra,ra,-492 # 80002000 <begin_signature>
800001f4:	fe008093          	addi	ra,ra,-32
800001f8:	0200a283          	lw	t0,32(ra)
800001fc:	00ff03b7          	lui	t2,0xff0
80000200:	0ff38393          	addi	t2,t2,255 # ff00ff <_start-0x7f00ff01>
80000204:	18729863          	bne	t0,t2,80000394 <fail>

80000208 <test_11>:
80000208:	00b00193          	li	gp,11
8000020c:	00002097          	auipc	ra,0x2
80000210:	df408093          	addi	ra,ra,-524 # 80002000 <begin_signature>
80000214:	ffd08093          	addi	ra,ra,-3
80000218:	0070a283          	lw	t0,7(ra)
8000021c:	ff0103b7          	lui	t2,0xff010
80000220:	f0038393          	addi	t2,t2,-256 # ff00ff00 <_end+0x7f00def0>
80000224:	16729863          	bne	t0,t2,80000394 <fail>

80000228 <test_12>:
80000228:	00c00193          	li	gp,12
8000022c:	00000213          	li	tp,0
80000230:	00002097          	auipc	ra,0x2
80000234:	dd408093          	addi	ra,ra,-556 # 80002004 <tdat2>
80000238:	0040a703          	lw	a4,4(ra)
8000023c:	00070313          	mv	t1,a4
80000240:	0ff013b7          	lui	t2,0xff01
80000244:	ff038393          	addi	t2,t2,-16 # ff00ff0 <_start-0x700ff010>
80000248:	14731663          	bne	t1,t2,80000394 <fail>
8000024c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000250:	00200293          	li	t0,2
80000254:	fc521ee3          	bne	tp,t0,80000230 <test_12+0x8>

80000258 <test_13>:
80000258:	00d00193          	li	gp,13
8000025c:	00000213          	li	tp,0
80000260:	00002097          	auipc	ra,0x2
80000264:	da808093          	addi	ra,ra,-600 # 80002008 <tdat3>
80000268:	0040a703          	lw	a4,4(ra)
8000026c:	00000013          	nop
80000270:	00070313          	mv	t1,a4
80000274:	f00ff3b7          	lui	t2,0xf00ff
80000278:	00f38393          	addi	t2,t2,15 # f00ff00f <_end+0x700fcfff>
8000027c:	10731c63          	bne	t1,t2,80000394 <fail>
80000280:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000284:	00200293          	li	t0,2
80000288:	fc521ce3          	bne	tp,t0,80000260 <test_13+0x8>

8000028c <test_14>:
8000028c:	00e00193          	li	gp,14
80000290:	00000213          	li	tp,0
80000294:	00002097          	auipc	ra,0x2
80000298:	d6c08093          	addi	ra,ra,-660 # 80002000 <begin_signature>
8000029c:	0040a703          	lw	a4,4(ra)
800002a0:	00000013          	nop
800002a4:	00000013          	nop
800002a8:	00070313          	mv	t1,a4
800002ac:	ff0103b7          	lui	t2,0xff010
800002b0:	f0038393          	addi	t2,t2,-256 # ff00ff00 <_end+0x7f00def0>
800002b4:	0e731063          	bne	t1,t2,80000394 <fail>
800002b8:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002bc:	00200293          	li	t0,2
800002c0:	fc521ae3          	bne	tp,t0,80000294 <test_14+0x8>

800002c4 <test_15>:
800002c4:	00f00193          	li	gp,15
800002c8:	00000213          	li	tp,0
800002cc:	00002097          	auipc	ra,0x2
800002d0:	d3808093          	addi	ra,ra,-712 # 80002004 <tdat2>
800002d4:	0040a703          	lw	a4,4(ra)
800002d8:	0ff013b7          	lui	t2,0xff01
800002dc:	ff038393          	addi	t2,t2,-16 # ff00ff0 <_start-0x700ff010>
800002e0:	0a771a63          	bne	a4,t2,80000394 <fail>
800002e4:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002e8:	00200293          	li	t0,2
800002ec:	fe5210e3          	bne	tp,t0,800002cc <test_15+0x8>

800002f0 <test_16>:
800002f0:	01000193          	li	gp,16
800002f4:	00000213          	li	tp,0
800002f8:	00002097          	auipc	ra,0x2
800002fc:	d1008093          	addi	ra,ra,-752 # 80002008 <tdat3>
80000300:	00000013          	nop
80000304:	0040a703          	lw	a4,4(ra)
80000308:	f00ff3b7          	lui	t2,0xf00ff
8000030c:	00f38393          	addi	t2,t2,15 # f00ff00f <_end+0x700fcfff>
80000310:	08771263          	bne	a4,t2,80000394 <fail>
80000314:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000318:	00200293          	li	t0,2
8000031c:	fc521ee3          	bne	tp,t0,800002f8 <test_16+0x8>

80000320 <test_17>:
80000320:	01100193          	li	gp,17
80000324:	00000213          	li	tp,0
80000328:	00002097          	auipc	ra,0x2
8000032c:	cd808093          	addi	ra,ra,-808 # 80002000 <begin_signature>
80000330:	00000013          	nop
80000334:	00000013          	nop
80000338:	0040a703          	lw	a4,4(ra)
8000033c:	ff0103b7          	lui	t2,0xff010
80000340:	f0038393          	addi	t2,t2,-256 # ff00ff00 <_end+0x7f00def0>
80000344:	04771863          	bne	a4,t2,80000394 <fail>
80000348:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000034c:	00200293          	li	t0,2
80000350:	fc521ce3          	bne	tp,t0,80000328 <test_17+0x8>

80000354 <test_18>:
80000354:	01200193          	li	gp,18
80000358:	00002297          	auipc	t0,0x2
8000035c:	ca828293          	addi	t0,t0,-856 # 80002000 <begin_signature>
80000360:	0002a103          	lw	sp,0(t0)
80000364:	00200113          	li	sp,2
80000368:	00200393          	li	t2,2
8000036c:	02711463          	bne	sp,t2,80000394 <fail>

80000370 <test_19>:
80000370:	01300193          	li	gp,19
80000374:	00002297          	auipc	t0,0x2
80000378:	c8c28293          	addi	t0,t0,-884 # 80002000 <begin_signature>
8000037c:	0002a103          	lw	sp,0(t0)
80000380:	00000013          	nop
80000384:	00200113          	li	sp,2
80000388:	00200393          	li	t2,2
8000038c:	00711463          	bne	sp,t2,80000394 <fail>
80000390:	00301a63          	bne	zero,gp,800003a4 <pass>

80000394 <fail>:
80000394:	803002b7          	lui	t0,0x80300
80000398:	55500313          	li	t1,1365
8000039c:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fdff0>
800003a0:	c65ff06f          	j	80000004 <loop>

800003a4 <pass>:
800003a4:	803002b7          	lui	t0,0x80300
800003a8:	66600313          	li	t1,1638
800003ac:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fdff0>
800003b0:	c55ff06f          	j	80000004 <loop>
800003b4:	c0001073          	unimp
800003b8:	0000                	unimp
800003ba:	0000                	unimp
800003bc:	0000                	unimp
800003be:	0000                	unimp

Disassembly of section .data:

80002000 <begin_signature>:
80002000:	00ff                	0xff
80002002:	00ff                	0xff

80002004 <tdat2>:
80002004:	ff00                	fsw	fs0,56(a4)
80002006:	ff00                	fsw	fs0,56(a4)

80002008 <tdat3>:
80002008:	0ff0                	addi	a2,sp,988
8000200a:	0ff0                	addi	a2,sp,988

8000200c <tdat4>:
8000200c:	f00ff00f          	0xf00ff00f
