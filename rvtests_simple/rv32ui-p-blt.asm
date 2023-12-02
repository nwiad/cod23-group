
rv32ui-p-blt：     文件格式 elf32-littleriscv


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
800000d0:	00100113          	li	sp,1
800000d4:	0020c663          	blt	ra,sp,800000e0 <test_2+0x18>
800000d8:	2a301863          	bne	zero,gp,80000388 <fail>
800000dc:	00301663          	bne	zero,gp,800000e8 <test_3>
800000e0:	fe20cee3          	blt	ra,sp,800000dc <test_2+0x14>
800000e4:	2a301263          	bne	zero,gp,80000388 <fail>

800000e8 <test_3>:
800000e8:	00300193          	li	gp,3
800000ec:	fff00093          	li	ra,-1
800000f0:	00100113          	li	sp,1
800000f4:	0020c663          	blt	ra,sp,80000100 <test_3+0x18>
800000f8:	28301863          	bne	zero,gp,80000388 <fail>
800000fc:	00301663          	bne	zero,gp,80000108 <test_4>
80000100:	fe20cee3          	blt	ra,sp,800000fc <test_3+0x14>
80000104:	28301263          	bne	zero,gp,80000388 <fail>

80000108 <test_4>:
80000108:	00400193          	li	gp,4
8000010c:	ffe00093          	li	ra,-2
80000110:	fff00113          	li	sp,-1
80000114:	0020c663          	blt	ra,sp,80000120 <test_4+0x18>
80000118:	26301863          	bne	zero,gp,80000388 <fail>
8000011c:	00301663          	bne	zero,gp,80000128 <test_5>
80000120:	fe20cee3          	blt	ra,sp,8000011c <test_4+0x14>
80000124:	26301263          	bne	zero,gp,80000388 <fail>

80000128 <test_5>:
80000128:	00500193          	li	gp,5
8000012c:	00100093          	li	ra,1
80000130:	00000113          	li	sp,0
80000134:	0020c463          	blt	ra,sp,8000013c <test_5+0x14>
80000138:	00301463          	bne	zero,gp,80000140 <test_5+0x18>
8000013c:	24301663          	bne	zero,gp,80000388 <fail>
80000140:	fe20cee3          	blt	ra,sp,8000013c <test_5+0x14>

80000144 <test_6>:
80000144:	00600193          	li	gp,6
80000148:	00100093          	li	ra,1
8000014c:	fff00113          	li	sp,-1
80000150:	0020c463          	blt	ra,sp,80000158 <test_6+0x14>
80000154:	00301463          	bne	zero,gp,8000015c <test_6+0x18>
80000158:	22301863          	bne	zero,gp,80000388 <fail>
8000015c:	fe20cee3          	blt	ra,sp,80000158 <test_6+0x14>

80000160 <test_7>:
80000160:	00700193          	li	gp,7
80000164:	fff00093          	li	ra,-1
80000168:	ffe00113          	li	sp,-2
8000016c:	0020c463          	blt	ra,sp,80000174 <test_7+0x14>
80000170:	00301463          	bne	zero,gp,80000178 <test_7+0x18>
80000174:	20301a63          	bne	zero,gp,80000388 <fail>
80000178:	fe20cee3          	blt	ra,sp,80000174 <test_7+0x14>

8000017c <test_8>:
8000017c:	00800193          	li	gp,8
80000180:	00100093          	li	ra,1
80000184:	ffe00113          	li	sp,-2
80000188:	0020c463          	blt	ra,sp,80000190 <test_8+0x14>
8000018c:	00301463          	bne	zero,gp,80000194 <test_8+0x18>
80000190:	1e301c63          	bne	zero,gp,80000388 <fail>
80000194:	fe20cee3          	blt	ra,sp,80000190 <test_8+0x14>

80000198 <test_9>:
80000198:	00900193          	li	gp,9
8000019c:	00000213          	li	tp,0
800001a0:	00000093          	li	ra,0
800001a4:	fff00113          	li	sp,-1
800001a8:	1e20c063          	blt	ra,sp,80000388 <fail>
800001ac:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800001b0:	00200293          	li	t0,2
800001b4:	fe5216e3          	bne	tp,t0,800001a0 <test_9+0x8>

800001b8 <test_10>:
800001b8:	00a00193          	li	gp,10
800001bc:	00000213          	li	tp,0
800001c0:	00000093          	li	ra,0
800001c4:	fff00113          	li	sp,-1
800001c8:	00000013          	nop
800001cc:	1a20ce63          	blt	ra,sp,80000388 <fail>
800001d0:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800001d4:	00200293          	li	t0,2
800001d8:	fe5214e3          	bne	tp,t0,800001c0 <test_10+0x8>

800001dc <test_11>:
800001dc:	00b00193          	li	gp,11
800001e0:	00000213          	li	tp,0
800001e4:	00000093          	li	ra,0
800001e8:	fff00113          	li	sp,-1
800001ec:	00000013          	nop
800001f0:	00000013          	nop
800001f4:	1820ca63          	blt	ra,sp,80000388 <fail>
800001f8:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800001fc:	00200293          	li	t0,2
80000200:	fe5212e3          	bne	tp,t0,800001e4 <test_11+0x8>

80000204 <test_12>:
80000204:	00c00193          	li	gp,12
80000208:	00000213          	li	tp,0
8000020c:	00000093          	li	ra,0
80000210:	00000013          	nop
80000214:	fff00113          	li	sp,-1
80000218:	1620c863          	blt	ra,sp,80000388 <fail>
8000021c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000220:	00200293          	li	t0,2
80000224:	fe5214e3          	bne	tp,t0,8000020c <test_12+0x8>

80000228 <test_13>:
80000228:	00d00193          	li	gp,13
8000022c:	00000213          	li	tp,0
80000230:	00000093          	li	ra,0
80000234:	00000013          	nop
80000238:	fff00113          	li	sp,-1
8000023c:	00000013          	nop
80000240:	1420c463          	blt	ra,sp,80000388 <fail>
80000244:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000248:	00200293          	li	t0,2
8000024c:	fe5212e3          	bne	tp,t0,80000230 <test_13+0x8>

80000250 <test_14>:
80000250:	00e00193          	li	gp,14
80000254:	00000213          	li	tp,0
80000258:	00000093          	li	ra,0
8000025c:	00000013          	nop
80000260:	00000013          	nop
80000264:	fff00113          	li	sp,-1
80000268:	1220c063          	blt	ra,sp,80000388 <fail>
8000026c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000270:	00200293          	li	t0,2
80000274:	fe5212e3          	bne	tp,t0,80000258 <test_14+0x8>

80000278 <test_15>:
80000278:	00f00193          	li	gp,15
8000027c:	00000213          	li	tp,0
80000280:	00000093          	li	ra,0
80000284:	fff00113          	li	sp,-1
80000288:	1020c063          	blt	ra,sp,80000388 <fail>
8000028c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000290:	00200293          	li	t0,2
80000294:	fe5216e3          	bne	tp,t0,80000280 <test_15+0x8>

80000298 <test_16>:
80000298:	01000193          	li	gp,16
8000029c:	00000213          	li	tp,0
800002a0:	00000093          	li	ra,0
800002a4:	fff00113          	li	sp,-1
800002a8:	00000013          	nop
800002ac:	0c20ce63          	blt	ra,sp,80000388 <fail>
800002b0:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002b4:	00200293          	li	t0,2
800002b8:	fe5214e3          	bne	tp,t0,800002a0 <test_16+0x8>

800002bc <test_17>:
800002bc:	01100193          	li	gp,17
800002c0:	00000213          	li	tp,0
800002c4:	00000093          	li	ra,0
800002c8:	fff00113          	li	sp,-1
800002cc:	00000013          	nop
800002d0:	00000013          	nop
800002d4:	0a20ca63          	blt	ra,sp,80000388 <fail>
800002d8:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002dc:	00200293          	li	t0,2
800002e0:	fe5212e3          	bne	tp,t0,800002c4 <test_17+0x8>

800002e4 <test_18>:
800002e4:	01200193          	li	gp,18
800002e8:	00000213          	li	tp,0
800002ec:	00000093          	li	ra,0
800002f0:	00000013          	nop
800002f4:	fff00113          	li	sp,-1
800002f8:	0820c863          	blt	ra,sp,80000388 <fail>
800002fc:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000300:	00200293          	li	t0,2
80000304:	fe5214e3          	bne	tp,t0,800002ec <test_18+0x8>

80000308 <test_19>:
80000308:	01300193          	li	gp,19
8000030c:	00000213          	li	tp,0
80000310:	00000093          	li	ra,0
80000314:	00000013          	nop
80000318:	fff00113          	li	sp,-1
8000031c:	00000013          	nop
80000320:	0620c463          	blt	ra,sp,80000388 <fail>
80000324:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000328:	00200293          	li	t0,2
8000032c:	fe5212e3          	bne	tp,t0,80000310 <test_19+0x8>

80000330 <test_20>:
80000330:	01400193          	li	gp,20
80000334:	00000213          	li	tp,0
80000338:	00000093          	li	ra,0
8000033c:	00000013          	nop
80000340:	00000013          	nop
80000344:	fff00113          	li	sp,-1
80000348:	0420c063          	blt	ra,sp,80000388 <fail>
8000034c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000350:	00200293          	li	t0,2
80000354:	fe5212e3          	bne	tp,t0,80000338 <test_20+0x8>

80000358 <test_21>:
80000358:	01500193          	li	gp,21
8000035c:	00100093          	li	ra,1
80000360:	00104a63          	bgtz	ra,80000374 <test_21+0x1c>
80000364:	00108093          	addi	ra,ra,1
80000368:	00108093          	addi	ra,ra,1
8000036c:	00108093          	addi	ra,ra,1
80000370:	00108093          	addi	ra,ra,1
80000374:	00108093          	addi	ra,ra,1
80000378:	00108093          	addi	ra,ra,1
8000037c:	00300393          	li	t2,3
80000380:	00709463          	bne	ra,t2,80000388 <fail>
80000384:	00301a63          	bne	zero,gp,80000398 <pass>

80000388 <fail>:
80000388:	803002b7          	lui	t0,0x80300
8000038c:	55500313          	li	t1,1365
80000390:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
80000394:	c71ff06f          	j	80000004 <loop>

80000398 <pass>:
80000398:	803002b7          	lui	t0,0x80300
8000039c:	66600313          	li	t1,1638
800003a0:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
800003a4:	c61ff06f          	j	80000004 <loop>
800003a8:	c0001073          	unimp
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