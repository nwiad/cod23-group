
rv32ui-p-ori：     文件格式 elf32-littleriscv


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
800000d4:	f0f0e713          	ori	a4,ra,-241
800000d8:	f0f00393          	li	t2,-241
800000dc:	1c771463          	bne	a4,t2,800002a4 <fail>

800000e0 <test_3>:
800000e0:	00300193          	li	gp,3
800000e4:	0ff010b7          	lui	ra,0xff01
800000e8:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
800000ec:	0f00e713          	ori	a4,ra,240
800000f0:	0ff013b7          	lui	t2,0xff01
800000f4:	ff038393          	addi	t2,t2,-16 # ff00ff0 <_start-0x700ff010>
800000f8:	1a771663          	bne	a4,t2,800002a4 <fail>

800000fc <test_4>:
800000fc:	00400193          	li	gp,4
80000100:	00ff00b7          	lui	ra,0xff0
80000104:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
80000108:	70f0e713          	ori	a4,ra,1807
8000010c:	00ff03b7          	lui	t2,0xff0
80000110:	7ff38393          	addi	t2,t2,2047 # ff07ff <_start-0x7f00f801>
80000114:	18771863          	bne	a4,t2,800002a4 <fail>

80000118 <test_5>:
80000118:	00500193          	li	gp,5
8000011c:	f00ff0b7          	lui	ra,0xf00ff
80000120:	00f08093          	addi	ra,ra,15 # f00ff00f <_end+0x700fd00f>
80000124:	0f00e713          	ori	a4,ra,240
80000128:	f00ff3b7          	lui	t2,0xf00ff
8000012c:	0ff38393          	addi	t2,t2,255 # f00ff0ff <_end+0x700fd0ff>
80000130:	16771a63          	bne	a4,t2,800002a4 <fail>

80000134 <test_6>:
80000134:	00600193          	li	gp,6
80000138:	ff0100b7          	lui	ra,0xff010
8000013c:	f0008093          	addi	ra,ra,-256 # ff00ff00 <_end+0x7f00df00>
80000140:	0f00e093          	ori	ra,ra,240
80000144:	ff0103b7          	lui	t2,0xff010
80000148:	ff038393          	addi	t2,t2,-16 # ff00fff0 <_end+0x7f00dff0>
8000014c:	14709c63          	bne	ra,t2,800002a4 <fail>

80000150 <test_7>:
80000150:	00700193          	li	gp,7
80000154:	00000213          	li	tp,0
80000158:	0ff010b7          	lui	ra,0xff01
8000015c:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
80000160:	0f00e713          	ori	a4,ra,240
80000164:	00070313          	mv	t1,a4
80000168:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
8000016c:	00200293          	li	t0,2
80000170:	fe5214e3          	bne	tp,t0,80000158 <test_7+0x8>
80000174:	0ff013b7          	lui	t2,0xff01
80000178:	ff038393          	addi	t2,t2,-16 # ff00ff0 <_start-0x700ff010>
8000017c:	12731463          	bne	t1,t2,800002a4 <fail>

80000180 <test_8>:
80000180:	00800193          	li	gp,8
80000184:	00000213          	li	tp,0
80000188:	00ff00b7          	lui	ra,0xff0
8000018c:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
80000190:	70f0e713          	ori	a4,ra,1807
80000194:	00000013          	nop
80000198:	00070313          	mv	t1,a4
8000019c:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800001a0:	00200293          	li	t0,2
800001a4:	fe5212e3          	bne	tp,t0,80000188 <test_8+0x8>
800001a8:	00ff03b7          	lui	t2,0xff0
800001ac:	7ff38393          	addi	t2,t2,2047 # ff07ff <_start-0x7f00f801>
800001b0:	0e731a63          	bne	t1,t2,800002a4 <fail>

800001b4 <test_9>:
800001b4:	00900193          	li	gp,9
800001b8:	00000213          	li	tp,0
800001bc:	f00ff0b7          	lui	ra,0xf00ff
800001c0:	00f08093          	addi	ra,ra,15 # f00ff00f <_end+0x700fd00f>
800001c4:	0f00e713          	ori	a4,ra,240
800001c8:	00000013          	nop
800001cc:	00000013          	nop
800001d0:	00070313          	mv	t1,a4
800001d4:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
800001d8:	00200293          	li	t0,2
800001dc:	fe5210e3          	bne	tp,t0,800001bc <test_9+0x8>
800001e0:	f00ff3b7          	lui	t2,0xf00ff
800001e4:	0ff38393          	addi	t2,t2,255 # f00ff0ff <_end+0x700fd0ff>
800001e8:	0a731e63          	bne	t1,t2,800002a4 <fail>

800001ec <test_10>:
800001ec:	00a00193          	li	gp,10
800001f0:	00000213          	li	tp,0
800001f4:	0ff010b7          	lui	ra,0xff01
800001f8:	ff008093          	addi	ra,ra,-16 # ff00ff0 <_start-0x700ff010>
800001fc:	0f00e713          	ori	a4,ra,240
80000200:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000204:	00200293          	li	t0,2
80000208:	fe5216e3          	bne	tp,t0,800001f4 <test_10+0x8>
8000020c:	0ff013b7          	lui	t2,0xff01
80000210:	ff038393          	addi	t2,t2,-16 # ff00ff0 <_start-0x700ff010>
80000214:	08771863          	bne	a4,t2,800002a4 <fail>

80000218 <test_11>:
80000218:	00b00193          	li	gp,11
8000021c:	00000213          	li	tp,0
80000220:	00ff00b7          	lui	ra,0xff0
80000224:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
80000228:	00000013          	nop
8000022c:	f0f0e713          	ori	a4,ra,-241
80000230:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000234:	00200293          	li	t0,2
80000238:	fe5214e3          	bne	tp,t0,80000220 <test_11+0x8>
8000023c:	fff00393          	li	t2,-1
80000240:	06771263          	bne	a4,t2,800002a4 <fail>

80000244 <test_12>:
80000244:	00c00193          	li	gp,12
80000248:	00000213          	li	tp,0
8000024c:	f00ff0b7          	lui	ra,0xf00ff
80000250:	00f08093          	addi	ra,ra,15 # f00ff00f <_end+0x700fd00f>
80000254:	00000013          	nop
80000258:	00000013          	nop
8000025c:	0f00e713          	ori	a4,ra,240
80000260:	00120213          	addi	tp,tp,1 # 1 <_start-0x7fffffff>
80000264:	00200293          	li	t0,2
80000268:	fe5212e3          	bne	tp,t0,8000024c <test_12+0x8>
8000026c:	f00ff3b7          	lui	t2,0xf00ff
80000270:	0ff38393          	addi	t2,t2,255 # f00ff0ff <_end+0x700fd0ff>
80000274:	02771863          	bne	a4,t2,800002a4 <fail>

80000278 <test_13>:
80000278:	00d00193          	li	gp,13
8000027c:	0f006093          	ori	ra,zero,240
80000280:	0f000393          	li	t2,240
80000284:	02709063          	bne	ra,t2,800002a4 <fail>

80000288 <test_14>:
80000288:	00e00193          	li	gp,14
8000028c:	00ff00b7          	lui	ra,0xff0
80000290:	0ff08093          	addi	ra,ra,255 # ff00ff <_start-0x7f00ff01>
80000294:	70f0e013          	ori	zero,ra,1807
80000298:	00000393          	li	t2,0
8000029c:	00701463          	bne	zero,t2,800002a4 <fail>
800002a0:	00301a63          	bne	zero,gp,800002b4 <pass>

800002a4 <fail>:
800002a4:	803002b7          	lui	t0,0x80300
800002a8:	55500313          	li	t1,1365
800002ac:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
800002b0:	d55ff06f          	j	80000004 <loop>

800002b4 <pass>:
800002b4:	803002b7          	lui	t0,0x80300
800002b8:	66600313          	li	t1,1638
800002bc:	0062a023          	sw	t1,0(t0) # 80300000 <_end+0x2fe000>
800002c0:	d45ff06f          	j	80000004 <loop>
800002c4:	c0001073          	unimp
800002c8:	0000                	unimp
800002ca:	0000                	unimp
800002cc:	0000                	unimp
800002ce:	0000                	unimp
800002d0:	0000                	unimp
800002d2:	0000                	unimp
800002d4:	0000                	unimp
800002d6:	0000                	unimp
800002d8:	0000                	unimp
800002da:	0000                	unimp
800002dc:	0000                	unimp
800002de:	0000                	unimp
800002e0:	0000                	unimp
800002e2:	0000                	unimp
800002e4:	0000                	unimp
800002e6:	0000                	unimp
800002e8:	0000                	unimp
800002ea:	0000                	unimp
800002ec:	0000                	unimp
800002ee:	0000                	unimp
800002f0:	0000                	unimp
800002f2:	0000                	unimp
800002f4:	0000                	unimp
800002f6:	0000                	unimp
800002f8:	0000                	unimp
800002fa:	0000                	unimp
800002fc:	0000                	unimp
800002fe:	0000                	unimp
