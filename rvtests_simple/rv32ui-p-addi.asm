
rv32ui-p-addi：     文件格式 elf32-littleriscv


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
800000d0:	00008713          	mv	a4,ra
800000d4:	00000393          	li	t2,0
800000d8:	26771c63          	bne	a4,t2,80000350 <fail>

800000dc <test_3>:
800000dc:	00300193          	li	gp,3
800000e0:	00100093          	li	ra,1
800000e4:	00108713          	addi	a4,ra,1
800000e8:	00200393          	li	t2,2
800000ec:	26771263          	bne	a4,t2,80000350 <fail>

800000f0 <test_4>:
800000f0:	00400193          	li	gp,4
800000f4:	00300093          	li	ra,3
800000f8:	00708713          	addi	a4,ra,7
800000fc:	00a00393          	li	t2,10
80000100:	24771863          	bne	a4,t2,80000350 <fail>

80000104 <test_5>:
80000104:	00500193          	li	gp,5
80000108:	00000093          	li	ra,0
8000010c:	80008713          	addi	a4,ra,-2048
80000110:	80000393          	li	t2,-2048
80000114:	22771e63          	bne	a4,t2,80000350 <fail>

80000118 <test_6>:
80000118:	00600193          	li	gp,6
8000011c:	800000b7          	lui	ra,0x80000
80000120:	00008713          	mv	a4,ra
80000124:	800003b7          	lui	t2,0x80000
80000128:	22771463          	bne	a4,t2,80000350 <fail>

8000012c <test_7>:
8000012c:	00700193          	li	gp,7
80000130:	800000b7          	lui	ra,0x80000
80000134:	80008713          	addi	a4,ra,-2048 # 7ffff800 <_end+0xffffd800>
80000138:	800003b7          	lui	t2,0x80000
8000013c:	80038393          	addi	t2,t2,-2048 # 7ffff800 <_end+0xffffd800>
80000140:	20771863          	bne	a4,t2,80000350 <fail>

80000144 <test_8>:
80000144:	00800193          	li	gp,8
80000148:	00000093          	li	ra,0
8000014c:	7ff08713          	addi	a4,ra,2047
80000150:	7ff00393          	li	t2,2047
80000154:	1e771e63          	bne	a4,t2,80000350 <fail>

80000158 <test_9>:
80000158:	00900193          	li	gp,9
8000015c:	800000b7          	lui	ra,0x80000
80000160:	fff08093          	addi	ra,ra,-1 # 7fffffff <_end+0xffffdfff>
80000164:	00008713          	mv	a4,ra
80000168:	800003b7          	lui	t2,0x80000
8000016c:	fff38393          	addi	t2,t2,-1 # 7fffffff <_end+0xffffdfff>
80000170:	1e771063          	bne	a4,t2,80000350 <fail>

80000174 <test_10>:
80000174:	00a00193          	li	gp,10
80000178:	800000b7          	lui	ra,0x80000
8000017c:	fff08093          	addi	ra,ra,-1 # 7fffffff <_end+0xffffdfff>
80000180:	7ff08713          	addi	a4,ra,2047
80000184:	800003b7          	lui	t2,0x80000
80000188:	7fe38393          	addi	t2,t2,2046 # 800007fe <_end+0xffffe7fe>
8000018c:	1c771263          	bne	a4,t2,80000350 <fail>

80000190 <test_11>:
80000190:	00b00193          	li	gp,11
80000194:	800000b7          	lui	ra,0x80000
80000198:	7ff08713          	addi	a4,ra,2047 # 800007ff <_end+0xffffe7ff>
8000019c:	800003b7          	lui	t2,0x80000
800001a0:	7ff38393          	addi	t2,t2,2047 # 800007ff <_end+0xffffe7ff>
800001a4:	1a771663          	bne	a4,t2,80000350 <fail>

800001a8 <test_12>:
800001a8:	00c00193          	li	gp,12
800001ac:	800000b7          	lui	ra,0x80000
800001b0:	fff08093          	addi	ra,ra,-1 # 7fffffff <_end+0xffffdfff>
800001b4:	80008713          	addi	a4,ra,-2048
800001b8:	7ffff3b7          	lui	t2,0x7ffff
800001bc:	7ff38393          	addi	t2,t2,2047 # 7ffff7ff <_start-0x801>
800001c0:	18771863          	bne	a4,t2,80000350 <fail>

800001c4 <test_13>:
800001c4:	00d00193          	li	gp,13
800001c8:	00000093          	li	ra,0
800001cc:	fff08713          	addi	a4,ra,-1
800001d0:	fff00393          	li	t2,-1
800001d4:	16771e63          	bne	a4,t2,80000350 <fail>

800001d8 <test_14>:
800001d8:	00e00193          	li	gp,14
800001dc:	fff00093          	li	ra,-1
800001e0:	00108713          	addi	a4,ra,1
800001e4:	00000393          	li	t2,0
800001e8:	16771463          	bne	a4,t2,80000350 <fail>

800001ec <test_15>:
800001ec:	00f00193          	li	gp,15
800001f0:	fff00093          	li	ra,-1
800001f4:	fff08713          	addi	a4,ra,-1
800001f8:	ffe00393          	li	t2,-2
800001fc:	14771a63          	bne	a4,t2,80000350 <fail>

80000200 <test_16>:
80000200:	01000193          	li	gp,16
80000204:	800000b7          	lui	ra,0x80000
80000208:	fff08093          	addi	ra,ra,-1 # 7fffffff <_end+0xffffdfff>
8000020c:	00108713          	addi	a4,ra,1
80000210:	800003b7          	lui	t2,0x80000
80000214:	12771e63          	bne	a4,t2,80000350 <fail>

80000218 <test_17>:
80000218:	01100193          	li	gp,17
8000021c:	00d00093          	li	ra,13
80000220:	00b08093          	addi	ra,ra,11
80000224:	01800393          	li	t2,24
80000228:	12709463          	bne	ra,t2,80000350 <fail>

8000022c <test_18>:
8000022c:	01200193          	li	gp,18
80000230:	00000213          	li	tp,0
80000234:	00d00093          	li	ra,13
80000238:	00b08713          	addi	a4,ra,11
8000023c:	00070313          	mv	t1,a4
80000240:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000244:	00200293          	li	t0,2
80000248:	fe5216e3          	bne	tp,t0,80000234 <test_18+0x8>
8000024c:	01800393          	li	t2,24
80000250:	10731063          	bne	t1,t2,80000350 <fail>

80000254 <test_19>:
80000254:	01300193          	li	gp,19
80000258:	00000213          	li	tp,0
8000025c:	00d00093          	li	ra,13
80000260:	00a08713          	addi	a4,ra,10
80000264:	00000013          	nop
80000268:	00070313          	mv	t1,a4
8000026c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000270:	00200293          	li	t0,2
80000274:	fe5214e3          	bne	tp,t0,8000025c <test_19+0x8>
80000278:	01700393          	li	t2,23
8000027c:	0c731a63          	bne	t1,t2,80000350 <fail>

80000280 <test_20>:
80000280:	01400193          	li	gp,20
80000284:	00000213          	li	tp,0
80000288:	00d00093          	li	ra,13
8000028c:	00908713          	addi	a4,ra,9
80000290:	00000013          	nop
80000294:	00000013          	nop
80000298:	00070313          	mv	t1,a4
8000029c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002a0:	00200293          	li	t0,2
800002a4:	fe5212e3          	bne	tp,t0,80000288 <test_20+0x8>
800002a8:	01600393          	li	t2,22
800002ac:	0a731263          	bne	t1,t2,80000350 <fail>

800002b0 <test_21>:
800002b0:	01500193          	li	gp,21
800002b4:	00000213          	li	tp,0
800002b8:	00d00093          	li	ra,13
800002bc:	00b08713          	addi	a4,ra,11
800002c0:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002c4:	00200293          	li	t0,2
800002c8:	fe5218e3          	bne	tp,t0,800002b8 <test_21+0x8>
800002cc:	01800393          	li	t2,24
800002d0:	08771063          	bne	a4,t2,80000350 <fail>

800002d4 <test_22>:
800002d4:	01600193          	li	gp,22
800002d8:	00000213          	li	tp,0
800002dc:	00d00093          	li	ra,13
800002e0:	00000013          	nop
800002e4:	00a08713          	addi	a4,ra,10
800002e8:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002ec:	00200293          	li	t0,2
800002f0:	fe5216e3          	bne	tp,t0,800002dc <test_22+0x8>
800002f4:	01700393          	li	t2,23
800002f8:	04771c63          	bne	a4,t2,80000350 <fail>

800002fc <test_23>:
800002fc:	01700193          	li	gp,23
80000300:	00000213          	li	tp,0
80000304:	00d00093          	li	ra,13
80000308:	00000013          	nop
8000030c:	00000013          	nop
80000310:	00908713          	addi	a4,ra,9
80000314:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000318:	00200293          	li	t0,2
8000031c:	fe5214e3          	bne	tp,t0,80000304 <test_23+0x8>
80000320:	01600393          	li	t2,22
80000324:	02771663          	bne	a4,t2,80000350 <fail>

80000328 <test_24>:
80000328:	01800193          	li	gp,24
8000032c:	02000093          	li	ra,32
80000330:	02000393          	li	t2,32
80000334:	00709e63          	bne	ra,t2,80000350 <fail>

80000338 <test_25>:
80000338:	01900193          	li	gp,25
8000033c:	02100093          	li	ra,33
80000340:	03208013          	addi	zero,ra,50
80000344:	00000393          	li	t2,0
80000348:	00701463          	bne	zero,t2,80000350 <fail>
8000034c:	00301a63          	bne	zero,gp,80000360 <pass>

80000350 <fail>:
80000350:	803002b7          	lui	t0,0x80300
80000354:	55500313          	li	t1,1365
80000358:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
8000035c:	ca9ff06f          	j	80000004 <loop>

80000360 <pass>:
80000360:	803002b7          	lui	t0,0x80300
80000364:	66600313          	li	t1,1638
80000368:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
8000036c:	c99ff06f          	j	80000004 <loop>
80000370:	c0001073          	unimp
80000374:	0000                	unimp
80000376:	0000                	unimp
80000378:	0000                	unimp
8000037a:	0000                	unimp
8000037c:	0000                	unimp
8000037e:	0000                	unimp