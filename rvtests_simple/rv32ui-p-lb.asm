
rv32ui-p-lb：     文件格式 elf32-littleriscv


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
800000cc:	fff00793          	li	a5,-1
800000d0:	00002097          	auipc	ra,0x2
800000d4:	f3008093          	addi	ra,ra,-208 # 80002000 <begin_signature>
800000d8:	00008703          	lb	a4,0(ra)
800000dc:	fff00393          	li	t2,-1
800000e0:	24771a63          	bne	a4,t2,80000334 <fail>

800000e4 <test_3>:
800000e4:	00300193          	li	gp,3
800000e8:	00000793          	li	a5,0
800000ec:	00002097          	auipc	ra,0x2
800000f0:	f1408093          	addi	ra,ra,-236 # 80002000 <begin_signature>
800000f4:	00108703          	lb	a4,1(ra)
800000f8:	00000393          	li	t2,0
800000fc:	22771c63          	bne	a4,t2,80000334 <fail>

80000100 <test_4>:
80000100:	00400193          	li	gp,4
80000104:	ff000793          	li	a5,-16
80000108:	00002097          	auipc	ra,0x2
8000010c:	ef808093          	addi	ra,ra,-264 # 80002000 <begin_signature>
80000110:	00208703          	lb	a4,2(ra)
80000114:	ff000393          	li	t2,-16
80000118:	20771e63          	bne	a4,t2,80000334 <fail>

8000011c <test_5>:
8000011c:	00500193          	li	gp,5
80000120:	00f00793          	li	a5,15
80000124:	00002097          	auipc	ra,0x2
80000128:	edc08093          	addi	ra,ra,-292 # 80002000 <begin_signature>
8000012c:	00308703          	lb	a4,3(ra)
80000130:	00f00393          	li	t2,15
80000134:	20771063          	bne	a4,t2,80000334 <fail>

80000138 <test_6>:
80000138:	00600193          	li	gp,6
8000013c:	fff00793          	li	a5,-1
80000140:	00002097          	auipc	ra,0x2
80000144:	ec308093          	addi	ra,ra,-317 # 80002003 <tdat4>
80000148:	ffd08703          	lb	a4,-3(ra)
8000014c:	fff00393          	li	t2,-1
80000150:	1e771263          	bne	a4,t2,80000334 <fail>

80000154 <test_7>:
80000154:	00700193          	li	gp,7
80000158:	00000793          	li	a5,0
8000015c:	00002097          	auipc	ra,0x2
80000160:	ea708093          	addi	ra,ra,-345 # 80002003 <tdat4>
80000164:	ffe08703          	lb	a4,-2(ra)
80000168:	00000393          	li	t2,0
8000016c:	1c771463          	bne	a4,t2,80000334 <fail>

80000170 <test_8>:
80000170:	00800193          	li	gp,8
80000174:	ff000793          	li	a5,-16
80000178:	00002097          	auipc	ra,0x2
8000017c:	e8b08093          	addi	ra,ra,-373 # 80002003 <tdat4>
80000180:	fff08703          	lb	a4,-1(ra)
80000184:	ff000393          	li	t2,-16
80000188:	1a771663          	bne	a4,t2,80000334 <fail>

8000018c <test_9>:
8000018c:	00900193          	li	gp,9
80000190:	00f00793          	li	a5,15
80000194:	00002097          	auipc	ra,0x2
80000198:	e6f08093          	addi	ra,ra,-401 # 80002003 <tdat4>
8000019c:	00008703          	lb	a4,0(ra)
800001a0:	00f00393          	li	t2,15
800001a4:	18771863          	bne	a4,t2,80000334 <fail>

800001a8 <test_10>:
800001a8:	00a00193          	li	gp,10
800001ac:	00002097          	auipc	ra,0x2
800001b0:	e5408093          	addi	ra,ra,-428 # 80002000 <begin_signature>
800001b4:	fe008093          	addi	ra,ra,-32
800001b8:	02008283          	lb	t0,32(ra)
800001bc:	fff00393          	li	t2,-1
800001c0:	16729a63          	bne	t0,t2,80000334 <fail>

800001c4 <test_11>:
800001c4:	00b00193          	li	gp,11
800001c8:	00002097          	auipc	ra,0x2
800001cc:	e3808093          	addi	ra,ra,-456 # 80002000 <begin_signature>
800001d0:	ffa08093          	addi	ra,ra,-6
800001d4:	00708283          	lb	t0,7(ra)
800001d8:	00000393          	li	t2,0
800001dc:	14729c63          	bne	t0,t2,80000334 <fail>

800001e0 <test_12>:
800001e0:	00c00193          	li	gp,12
800001e4:	00000213          	li	tp,0
800001e8:	00002097          	auipc	ra,0x2
800001ec:	e1908093          	addi	ra,ra,-487 # 80002001 <tdat2>
800001f0:	00108703          	lb	a4,1(ra)
800001f4:	00070313          	mv	t1,a4
800001f8:	ff000393          	li	t2,-16
800001fc:	12731c63          	bne	t1,t2,80000334 <fail>
80000200:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000204:	00200293          	li	t0,2
80000208:	fe5210e3          	bne	tp,t0,800001e8 <test_12+0x8>

8000020c <test_13>:
8000020c:	00d00193          	li	gp,13
80000210:	00000213          	li	tp,0
80000214:	00002097          	auipc	ra,0x2
80000218:	dee08093          	addi	ra,ra,-530 # 80002002 <tdat3>
8000021c:	00108703          	lb	a4,1(ra)
80000220:	00000013          	nop
80000224:	00070313          	mv	t1,a4
80000228:	00f00393          	li	t2,15
8000022c:	10731463          	bne	t1,t2,80000334 <fail>
80000230:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000234:	00200293          	li	t0,2
80000238:	fc521ee3          	bne	tp,t0,80000214 <test_13+0x8>

8000023c <test_14>:
8000023c:	00e00193          	li	gp,14
80000240:	00000213          	li	tp,0
80000244:	00002097          	auipc	ra,0x2
80000248:	dbc08093          	addi	ra,ra,-580 # 80002000 <begin_signature>
8000024c:	00108703          	lb	a4,1(ra)
80000250:	00000013          	nop
80000254:	00000013          	nop
80000258:	00070313          	mv	t1,a4
8000025c:	00000393          	li	t2,0
80000260:	0c731a63          	bne	t1,t2,80000334 <fail>
80000264:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000268:	00200293          	li	t0,2
8000026c:	fc521ce3          	bne	tp,t0,80000244 <test_14+0x8>

80000270 <test_15>:
80000270:	00f00193          	li	gp,15
80000274:	00000213          	li	tp,0
80000278:	00002097          	auipc	ra,0x2
8000027c:	d8908093          	addi	ra,ra,-631 # 80002001 <tdat2>
80000280:	00108703          	lb	a4,1(ra)
80000284:	ff000393          	li	t2,-16
80000288:	0a771663          	bne	a4,t2,80000334 <fail>
8000028c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000290:	00200293          	li	t0,2
80000294:	fe5212e3          	bne	tp,t0,80000278 <test_15+0x8>

80000298 <test_16>:
80000298:	01000193          	li	gp,16
8000029c:	00000213          	li	tp,0
800002a0:	00002097          	auipc	ra,0x2
800002a4:	d6208093          	addi	ra,ra,-670 # 80002002 <tdat3>
800002a8:	00000013          	nop
800002ac:	00108703          	lb	a4,1(ra)
800002b0:	00f00393          	li	t2,15
800002b4:	08771063          	bne	a4,t2,80000334 <fail>
800002b8:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002bc:	00200293          	li	t0,2
800002c0:	fe5210e3          	bne	tp,t0,800002a0 <test_16+0x8>

800002c4 <test_17>:
800002c4:	01100193          	li	gp,17
800002c8:	00000213          	li	tp,0
800002cc:	00002097          	auipc	ra,0x2
800002d0:	d3408093          	addi	ra,ra,-716 # 80002000 <begin_signature>
800002d4:	00000013          	nop
800002d8:	00000013          	nop
800002dc:	00108703          	lb	a4,1(ra)
800002e0:	00000393          	li	t2,0
800002e4:	04771863          	bne	a4,t2,80000334 <fail>
800002e8:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002ec:	00200293          	li	t0,2
800002f0:	fc521ee3          	bne	tp,t0,800002cc <test_17+0x8>

800002f4 <test_18>:
800002f4:	01200193          	li	gp,18
800002f8:	00002297          	auipc	t0,0x2
800002fc:	d0828293          	addi	t0,t0,-760 # 80002000 <begin_signature>
80000300:	00028103          	lb	sp,0(t0)
80000304:	00200113          	li	sp,2
80000308:	00200393          	li	t2,2
8000030c:	02711463          	bne	sp,t2,80000334 <fail>

80000310 <test_19>:
80000310:	01300193          	li	gp,19
80000314:	00002297          	auipc	t0,0x2
80000318:	cec28293          	addi	t0,t0,-788 # 80002000 <begin_signature>
8000031c:	00028103          	lb	sp,0(t0)
80000320:	00000013          	nop
80000324:	00200113          	li	sp,2
80000328:	00200393          	li	t2,2
8000032c:	00711463          	bne	sp,t2,80000334 <fail>
80000330:	00301a63          	bne	zero,gp,80000344 <pass>

80000334 <fail>:
80000334:	803002b7          	lui	t0,0x80300
80000338:	55500313          	li	t1,1365
8000033c:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fdff0>
80000340:	cc5ff06f          	j	80000004 <loop>

80000344 <pass>:
80000344:	803002b7          	lui	t0,0x80300
80000348:	66600313          	li	t1,1638
8000034c:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fdff0>
80000350:	cb5ff06f          	j	80000004 <loop>
80000354:	c0001073          	unimp
80000358:	0000                	unimp
8000035a:	0000                	unimp
8000035c:	0000                	unimp
8000035e:	0000                	unimp
80000360:	0000                	unimp
80000362:	0000                	unimp
80000364:	0000                	unimp
80000366:	0000                	unimp
80000368:	0000                	unimp
8000036a:	0000                	unimp
8000036c:	0000                	unimp
8000036e:	0000                	unimp
80000370:	0000                	unimp
80000372:	0000                	unimp
80000374:	0000                	unimp
80000376:	0000                	unimp
80000378:	0000                	unimp
8000037a:	0000                	unimp
8000037c:	0000                	unimp
8000037e:	0000                	unimp

Disassembly of section .data:

80002000 <begin_signature>:
80002000:	                	0xff

80002001 <tdat2>:
80002001:	                	fsw	fs0,32(s0)

80002002 <tdat3>:
80002002:	                	addi	a2,sp,988

80002003 <tdat4>:
80002003:	0000000f          	fence	unknown,unknown
80002007:	0000                	unimp
80002009:	0000                	unimp
8000200b:	0000                	unimp
8000200d:	0000                	unimp
8000200f:	00              	地址 0x000000008000200f 越界。

