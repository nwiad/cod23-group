
rv32ui-p-bltu：     文件格式 elf32-littleriscv


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
800000d4:	0020e663          	bltu	ra,sp,800000e0 <test_2+0x18>
800000d8:	2e301263          	bne	zero,gp,800003bc <fail>
800000dc:	00301663          	bne	zero,gp,800000e8 <test_3>
800000e0:	fe20eee3          	bltu	ra,sp,800000dc <test_2+0x14>
800000e4:	2c301c63          	bne	zero,gp,800003bc <fail>

800000e8 <test_3>:
800000e8:	00300193          	li	gp,3
800000ec:	ffe00093          	li	ra,-2
800000f0:	fff00113          	li	sp,-1
800000f4:	0020e663          	bltu	ra,sp,80000100 <test_3+0x18>
800000f8:	2c301263          	bne	zero,gp,800003bc <fail>
800000fc:	00301663          	bne	zero,gp,80000108 <test_4>
80000100:	fe20eee3          	bltu	ra,sp,800000fc <test_3+0x14>
80000104:	2a301c63          	bne	zero,gp,800003bc <fail>

80000108 <test_4>:
80000108:	00400193          	li	gp,4
8000010c:	00000093          	li	ra,0
80000110:	fff00113          	li	sp,-1
80000114:	0020e663          	bltu	ra,sp,80000120 <test_4+0x18>
80000118:	2a301263          	bne	zero,gp,800003bc <fail>
8000011c:	00301663          	bne	zero,gp,80000128 <test_5>
80000120:	fe20eee3          	bltu	ra,sp,8000011c <test_4+0x14>
80000124:	28301c63          	bne	zero,gp,800003bc <fail>

80000128 <test_5>:
80000128:	00500193          	li	gp,5
8000012c:	00100093          	li	ra,1
80000130:	00000113          	li	sp,0
80000134:	0020e463          	bltu	ra,sp,8000013c <test_5+0x14>
80000138:	00301463          	bne	zero,gp,80000140 <test_5+0x18>
8000013c:	28301063          	bne	zero,gp,800003bc <fail>
80000140:	fe20eee3          	bltu	ra,sp,8000013c <test_5+0x14>

80000144 <test_6>:
80000144:	00600193          	li	gp,6
80000148:	fff00093          	li	ra,-1
8000014c:	ffe00113          	li	sp,-2
80000150:	0020e463          	bltu	ra,sp,80000158 <test_6+0x14>
80000154:	00301463          	bne	zero,gp,8000015c <test_6+0x18>
80000158:	26301263          	bne	zero,gp,800003bc <fail>
8000015c:	fe20eee3          	bltu	ra,sp,80000158 <test_6+0x14>

80000160 <test_7>:
80000160:	00700193          	li	gp,7
80000164:	fff00093          	li	ra,-1
80000168:	00000113          	li	sp,0
8000016c:	0020e463          	bltu	ra,sp,80000174 <test_7+0x14>
80000170:	00301463          	bne	zero,gp,80000178 <test_7+0x18>
80000174:	24301463          	bne	zero,gp,800003bc <fail>
80000178:	fe20eee3          	bltu	ra,sp,80000174 <test_7+0x14>

8000017c <test_8>:
8000017c:	00800193          	li	gp,8
80000180:	800000b7          	lui	ra,0x80000
80000184:	80000137          	lui	sp,0x80000
80000188:	fff10113          	addi	sp,sp,-1 # 7fffffff <_end+0xffffdfff>
8000018c:	0020e463          	bltu	ra,sp,80000194 <test_8+0x18>
80000190:	00301463          	bne	zero,gp,80000198 <test_8+0x1c>
80000194:	22301463          	bne	zero,gp,800003bc <fail>
80000198:	fe20eee3          	bltu	ra,sp,80000194 <test_8+0x18>

8000019c <test_9>:
8000019c:	00900193          	li	gp,9
800001a0:	00000213          	li	tp,0
800001a4:	f00000b7          	lui	ra,0xf0000
800001a8:	f0000137          	lui	sp,0xf0000
800001ac:	fff10113          	addi	sp,sp,-1 # efffffff <_end+0x6fffdfff>
800001b0:	2020e663          	bltu	ra,sp,800003bc <fail>
800001b4:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800001b8:	00200293          	li	t0,2
800001bc:	fe5214e3          	bne	tp,t0,800001a4 <test_9+0x8>

800001c0 <test_10>:
800001c0:	00a00193          	li	gp,10
800001c4:	00000213          	li	tp,0
800001c8:	f00000b7          	lui	ra,0xf0000
800001cc:	f0000137          	lui	sp,0xf0000
800001d0:	fff10113          	addi	sp,sp,-1 # efffffff <_end+0x6fffdfff>
800001d4:	00000013          	nop
800001d8:	1e20e263          	bltu	ra,sp,800003bc <fail>
800001dc:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800001e0:	00200293          	li	t0,2
800001e4:	fe5212e3          	bne	tp,t0,800001c8 <test_10+0x8>

800001e8 <test_11>:
800001e8:	00b00193          	li	gp,11
800001ec:	00000213          	li	tp,0
800001f0:	f00000b7          	lui	ra,0xf0000
800001f4:	f0000137          	lui	sp,0xf0000
800001f8:	fff10113          	addi	sp,sp,-1 # efffffff <_end+0x6fffdfff>
800001fc:	00000013          	nop
80000200:	00000013          	nop
80000204:	1a20ec63          	bltu	ra,sp,800003bc <fail>
80000208:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000020c:	00200293          	li	t0,2
80000210:	fe5210e3          	bne	tp,t0,800001f0 <test_11+0x8>

80000214 <test_12>:
80000214:	00c00193          	li	gp,12
80000218:	00000213          	li	tp,0
8000021c:	f00000b7          	lui	ra,0xf0000
80000220:	00000013          	nop
80000224:	f0000137          	lui	sp,0xf0000
80000228:	fff10113          	addi	sp,sp,-1 # efffffff <_end+0x6fffdfff>
8000022c:	1820e863          	bltu	ra,sp,800003bc <fail>
80000230:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000234:	00200293          	li	t0,2
80000238:	fe5212e3          	bne	tp,t0,8000021c <test_12+0x8>

8000023c <test_13>:
8000023c:	00d00193          	li	gp,13
80000240:	00000213          	li	tp,0
80000244:	f00000b7          	lui	ra,0xf0000
80000248:	00000013          	nop
8000024c:	f0000137          	lui	sp,0xf0000
80000250:	fff10113          	addi	sp,sp,-1 # efffffff <_end+0x6fffdfff>
80000254:	00000013          	nop
80000258:	1620e263          	bltu	ra,sp,800003bc <fail>
8000025c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000260:	00200293          	li	t0,2
80000264:	fe5210e3          	bne	tp,t0,80000244 <test_13+0x8>

80000268 <test_14>:
80000268:	00e00193          	li	gp,14
8000026c:	00000213          	li	tp,0
80000270:	f00000b7          	lui	ra,0xf0000
80000274:	00000013          	nop
80000278:	00000013          	nop
8000027c:	f0000137          	lui	sp,0xf0000
80000280:	fff10113          	addi	sp,sp,-1 # efffffff <_end+0x6fffdfff>
80000284:	1220ec63          	bltu	ra,sp,800003bc <fail>
80000288:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000028c:	00200293          	li	t0,2
80000290:	fe5210e3          	bne	tp,t0,80000270 <test_14+0x8>

80000294 <test_15>:
80000294:	00f00193          	li	gp,15
80000298:	00000213          	li	tp,0
8000029c:	f00000b7          	lui	ra,0xf0000
800002a0:	f0000137          	lui	sp,0xf0000
800002a4:	fff10113          	addi	sp,sp,-1 # efffffff <_end+0x6fffdfff>
800002a8:	1020ea63          	bltu	ra,sp,800003bc <fail>
800002ac:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002b0:	00200293          	li	t0,2
800002b4:	fe5214e3          	bne	tp,t0,8000029c <test_15+0x8>

800002b8 <test_16>:
800002b8:	01000193          	li	gp,16
800002bc:	00000213          	li	tp,0
800002c0:	f00000b7          	lui	ra,0xf0000
800002c4:	f0000137          	lui	sp,0xf0000
800002c8:	fff10113          	addi	sp,sp,-1 # efffffff <_end+0x6fffdfff>
800002cc:	00000013          	nop
800002d0:	0e20e663          	bltu	ra,sp,800003bc <fail>
800002d4:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800002d8:	00200293          	li	t0,2
800002dc:	fe5212e3          	bne	tp,t0,800002c0 <test_16+0x8>

800002e0 <test_17>:
800002e0:	01100193          	li	gp,17
800002e4:	00000213          	li	tp,0
800002e8:	f00000b7          	lui	ra,0xf0000
800002ec:	f0000137          	lui	sp,0xf0000
800002f0:	fff10113          	addi	sp,sp,-1 # efffffff <_end+0x6fffdfff>
800002f4:	00000013          	nop
800002f8:	00000013          	nop
800002fc:	0c20e063          	bltu	ra,sp,800003bc <fail>
80000300:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000304:	00200293          	li	t0,2
80000308:	fe5210e3          	bne	tp,t0,800002e8 <test_17+0x8>

8000030c <test_18>:
8000030c:	01200193          	li	gp,18
80000310:	00000213          	li	tp,0
80000314:	f00000b7          	lui	ra,0xf0000
80000318:	00000013          	nop
8000031c:	f0000137          	lui	sp,0xf0000
80000320:	fff10113          	addi	sp,sp,-1 # efffffff <_end+0x6fffdfff>
80000324:	0820ec63          	bltu	ra,sp,800003bc <fail>
80000328:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000032c:	00200293          	li	t0,2
80000330:	fe5212e3          	bne	tp,t0,80000314 <test_18+0x8>

80000334 <test_19>:
80000334:	01300193          	li	gp,19
80000338:	00000213          	li	tp,0
8000033c:	f00000b7          	lui	ra,0xf0000
80000340:	00000013          	nop
80000344:	f0000137          	lui	sp,0xf0000
80000348:	fff10113          	addi	sp,sp,-1 # efffffff <_end+0x6fffdfff>
8000034c:	00000013          	nop
80000350:	0620e663          	bltu	ra,sp,800003bc <fail>
80000354:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000358:	00200293          	li	t0,2
8000035c:	fe5210e3          	bne	tp,t0,8000033c <test_19+0x8>

80000360 <test_20>:
80000360:	01400193          	li	gp,20
80000364:	00000213          	li	tp,0
80000368:	f00000b7          	lui	ra,0xf0000
8000036c:	00000013          	nop
80000370:	00000013          	nop
80000374:	f0000137          	lui	sp,0xf0000
80000378:	fff10113          	addi	sp,sp,-1 # efffffff <_end+0x6fffdfff>
8000037c:	0420e063          	bltu	ra,sp,800003bc <fail>
80000380:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000384:	00200293          	li	t0,2
80000388:	fe5210e3          	bne	tp,t0,80000368 <test_20+0x8>

8000038c <test_21>:
8000038c:	01500193          	li	gp,21
80000390:	00100093          	li	ra,1
80000394:	00106a63          	bltu	zero,ra,800003a8 <test_21+0x1c>
80000398:	00108093          	addi	ra,ra,1 # f0000001 <_end+0x6fffe001>
8000039c:	00108093          	addi	ra,ra,1
800003a0:	00108093          	addi	ra,ra,1
800003a4:	00108093          	addi	ra,ra,1
800003a8:	00108093          	addi	ra,ra,1
800003ac:	00108093          	addi	ra,ra,1
800003b0:	00300393          	li	t2,3
800003b4:	00709463          	bne	ra,t2,800003bc <fail>
800003b8:	00301a63          	bne	zero,gp,800003cc <pass>

800003bc <fail>:
800003bc:	803002b7          	lui	t0,0x80300
800003c0:	55500313          	li	t1,1365
800003c4:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
800003c8:	c3dff06f          	j	80000004 <loop>

800003cc <pass>:
800003cc:	803002b7          	lui	t0,0x80300
800003d0:	66600313          	li	t1,1638
800003d4:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
800003d8:	c2dff06f          	j	80000004 <loop>
800003dc:	c0001073          	unimp
800003e0:	0000                	unimp
800003e2:	0000                	unimp
800003e4:	0000                	unimp
800003e6:	0000                	unimp
800003e8:	0000                	unimp
800003ea:	0000                	unimp
800003ec:	0000                	unimp
800003ee:	0000                	unimp
800003f0:	0000                	unimp
800003f2:	0000                	unimp
800003f4:	0000                	unimp
800003f6:	0000                	unimp
800003f8:	0000                	unimp
800003fa:	0000                	unimp
800003fc:	0000                	unimp
800003fe:	0000                	unimp
