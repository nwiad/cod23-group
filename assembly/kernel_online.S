
D:\Codefield\Code_SystemVerilog\cod23-grp53\kernel-rv32-no16550.bin:     file format binary


Disassembly of section .data:

0000000000000000 <.data>:
       0:	00000d17          	auipc	s10,0x0
       4:	00cd0d13          	addi	s10,s10,12 # 0xc
       8:	000d0067          	jr	s10
       c:	007f0d17          	auipc	s10,0x7f0
      10:	ff4d0d13          	addi	s10,s10,-12 # 0x7f0000
      14:	007f0d97          	auipc	s11,0x7f0
      18:	104d8d93          	addi	s11,s11,260 # 0x7f0118
      1c:	01bd0863          	beq	s10,s11,0x2c
      20:	000d2023          	sw	zero,0(s10)
      24:	004d0d13          	addi	s10,s10,4
      28:	ff5ff06f          	j	0x1c
      2c:	00800117          	auipc	sp,0x800
      30:	fd410113          	addi	sp,sp,-44 # 0x800000
      34:	00016433          	or	s0,sp,zero
      38:	807f02b7          	lui	t0,0x807f0
      3c:	007f0317          	auipc	t1,0x7f0
      40:	fc830313          	addi	t1,t1,-56 # 0x7f0004
      44:	00532023          	sw	t0,0(t1)
      48:	007f0317          	auipc	t1,0x7f0
      4c:	fd430313          	addi	t1,t1,-44 # 0x7f001c
      50:	00532023          	sw	t0,0(t1)
      54:	08000293          	li	t0,128
      58:	ffc28293          	addi	t0,t0,-4 # 0xffffffff807efffc
      5c:	ffc10113          	addi	sp,sp,-4
      60:	00012023          	sw	zero,0(sp)
      64:	fe029ae3          	bnez	t0,0x58
      68:	007f0297          	auipc	t0,0x7f0
      6c:	09828293          	addi	t0,t0,152 # 0x7f0100
      70:	0022a023          	sw	sp,0(t0)
      74:	00010f93          	mv	t6,sp
      78:	08000293          	li	t0,128
      7c:	ffc28293          	addi	t0,t0,-4
      80:	ffc10113          	addi	sp,sp,-4
      84:	00012023          	sw	zero,0(sp)
      88:	fe029ae3          	bnez	t0,0x7c
      8c:	007f0297          	auipc	t0,0x7f0
      90:	07428293          	addi	t0,t0,116 # 0x7f0100
      94:	0022a223          	sw	sp,4(t0)
      98:	002fa223          	sw	sp,4(t6)
      9c:	007f0397          	auipc	t2,0x7f0
      a0:	06838393          	addi	t2,t2,104 # 0x7f0104
      a4:	0003a383          	lw	t2,0(t2)
      a8:	007f0317          	auipc	t1,0x7f0
      ac:	06830313          	addi	t1,t1,104 # 0x7f0110
      b0:	00732023          	sw	t2,0(t1)
      b4:	0040006f          	j	0xb8
      b8:	00001497          	auipc	s1,0x1
      bc:	09c48493          	addi	s1,s1,156 # 0x1154
      c0:	00048503          	lb	a0,0(s1)
      c4:	00148493          	addi	s1,s1,1
      c8:	2e0000ef          	jal	ra,0x3a8
      cc:	00048503          	lb	a0,0(s1)
      d0:	fe051ae3          	bnez	a0,0xc4
      d4:	0340006f          	j	0x108
      d8:	00000013          	nop
      dc:	00000013          	nop
      e0:	00000013          	nop
      e4:	00000013          	nop
      e8:	00000013          	nop
      ec:	00000013          	nop
      f0:	00000013          	nop
      f4:	00000013          	nop
      f8:	00000013          	nop
      fc:	00000013          	nop
     100:	fd9ff06f          	j	0xd8
     104:	00000013          	nop
     108:	324000ef          	jal	ra,0x42c
     10c:	05206293          	ori	t0,zero,82 // 'R'
     110:	06550863          	beq	a0,t0,0x180
     114:	04406293          	ori	t0,zero,68 // 'D'
     118:	0a550263          	beq	a0,t0,0x1bc
     11c:	04106293          	ori	t0,zero,65 // 'A'
     120:	0c550e63          	beq	a0,t0,0x1fc
     124:	04706293          	ori	t0,zero,71 // 'G'
     128:	10550c63          	beq	a0,t0,0x240
     12c:	05406293          	ori	t0,zero,84 // 'T'
     130:	00550863          	beq	a0,t0,0x140
     134:	00400513          	li	a0,4
     138:	270000ef          	jal	ra,0x3a8
     13c:	2400006f          	j	0x37c
     140:	ff410113          	addi	sp,sp,-12
     144:	00912023          	sw	s1,0(sp)
     148:	01212223          	sw	s2,4(sp)
     14c:	fff00493          	li	s1,-1
     150:	00912423          	sw	s1,8(sp)
     154:	00810493          	addi	s1,sp,8
     158:	00400913          	li	s2,4
     15c:	00048503          	lb	a0,0(s1)
     160:	fff90913          	addi	s2,s2,-1
     164:	244000ef          	jal	ra,0x3a8
     168:	00148493          	addi	s1,s1,1
     16c:	fe0918e3          	bnez	s2,0x15c
     170:	00012483          	lw	s1,0(sp)
     174:	00412903          	lw	s2,4(sp)
     178:	00c10113          	addi	sp,sp,12
     17c:	2000006f          	j	0x37c
     180:	ff810113          	addi	sp,sp,-8
     184:	00912023          	sw	s1,0(sp)
     188:	01212223          	sw	s2,4(sp)
     18c:	007f0497          	auipc	s1,0x7f0
     190:	e7448493          	addi	s1,s1,-396 # 0x7f0000
     194:	07c06913          	ori	s2,zero,124
     198:	00048503          	lb	a0,0(s1)
     19c:	fff90913          	addi	s2,s2,-1
     1a0:	208000ef          	jal	ra,0x3a8
     1a4:	00148493          	addi	s1,s1,1
     1a8:	fe0918e3          	bnez	s2,0x198
     1ac:	00012483          	lw	s1,0(sp)
     1b0:	00412903          	lw	s2,4(sp)
     1b4:	00810113          	addi	sp,sp,8
     1b8:	1c40006f          	j	0x37c
     1bc:	ff810113          	addi	sp,sp,-8
     1c0:	00912023          	sw	s1,0(sp)
     1c4:	01212223          	sw	s2,4(sp)
     1c8:	300000ef          	jal	ra,0x4c8
     1cc:	000564b3          	or	s1,a0,zero
     1d0:	2f8000ef          	jal	ra,0x4c8
     1d4:	00056933          	or	s2,a0,zero
     1d8:	00048503          	lb	a0,0(s1)
     1dc:	fff90913          	addi	s2,s2,-1
     1e0:	1c8000ef          	jal	ra,0x3a8
     1e4:	00148493          	addi	s1,s1,1
     1e8:	fe0918e3          	bnez	s2,0x1d8
     1ec:	00012483          	lw	s1,0(sp)
     1f0:	00412903          	lw	s2,4(sp)
     1f4:	00810113          	addi	sp,sp,8
     1f8:	1840006f          	j	0x37c
     1fc:	ff810113          	addi	sp,sp,-8
     200:	00912023          	sw	s1,0(sp)
     204:	01212223          	sw	s2,4(sp)
     208:	2c0000ef          	jal	ra,0x4c8
     20c:	000564b3          	or	s1,a0,zero
     210:	2b8000ef          	jal	ra,0x4c8
     214:	00056933          	or	s2,a0,zero
     218:	00295913          	srli	s2,s2,0x2
     21c:	22c000ef          	jal	ra,0x448
     220:	00a4a023          	sw	a0,0(s1)
     224:	fff90913          	addi	s2,s2,-1
     228:	00448493          	addi	s1,s1,4
     22c:	fe0918e3          	bnez	s2,0x21c
     230:	00012483          	lw	s1,0(sp)
     234:	00412903          	lw	s2,4(sp)
     238:	00810113          	addi	sp,sp,8
     23c:	1400006f          	j	0x37c
     240:	288000ef          	jal	ra,0x4c8
     244:	00050d13          	mv	s10,a0
     248:	00606513          	ori	a0,zero,6
     24c:	15c000ef          	jal	ra,0x3a8
     250:	007f0097          	auipc	ra,0x7f0
     254:	db008093          	addi	ra,ra,-592 # 0x7f0000
     258:	0820a023          	sw	sp,128(ra)
     25c:	0040a103          	lw	sp,4(ra)
     260:	0080a183          	lw	gp,8(ra)
     264:	00c0a203          	lw	tp,12(ra)
     268:	0100a283          	lw	t0,16(ra)
     26c:	0140a303          	lw	t1,20(ra)
     270:	0180a383          	lw	t2,24(ra)
     274:	01c0a403          	lw	s0,28(ra)
     278:	0200a483          	lw	s1,32(ra)
     27c:	0240a503          	lw	a0,36(ra)
     280:	0280a583          	lw	a1,40(ra)
     284:	02c0a603          	lw	a2,44(ra)
     288:	0300a683          	lw	a3,48(ra)
     28c:	0340a703          	lw	a4,52(ra)
     290:	0380a783          	lw	a5,56(ra)
     294:	03c0a803          	lw	a6,60(ra)
     298:	0400a883          	lw	a7,64(ra)
     29c:	0440a903          	lw	s2,68(ra)
     2a0:	0480a983          	lw	s3,72(ra)
     2a4:	04c0aa03          	lw	s4,76(ra)
     2a8:	0500aa83          	lw	s5,80(ra)
     2ac:	0540ab03          	lw	s6,84(ra)
     2b0:	0580ab83          	lw	s7,88(ra)
     2b4:	05c0ac03          	lw	s8,92(ra)
     2b8:	0600ac83          	lw	s9,96(ra)
     2bc:	0680ad83          	lw	s11,104(ra)
     2c0:	06c0ae03          	lw	t3,108(ra)
     2c4:	0700ae83          	lw	t4,112(ra)
     2c8:	0740af03          	lw	t5,116(ra)
     2cc:	0780af83          	lw	t6,120(ra)
     2d0:	00000097          	auipc	ra,0x0
     2d4:	00c08093          	addi	ra,ra,12 # 0x2dc
     2d8:	000d0067          	jr	s10
     2dc:	007f0097          	auipc	ra,0x7f0
     2e0:	d2408093          	addi	ra,ra,-732 # 0x7f0000
     2e4:	0020a223          	sw	sp,4(ra)
     2e8:	0030a423          	sw	gp,8(ra)
     2ec:	0040a623          	sw	tp,12(ra)
     2f0:	0050a823          	sw	t0,16(ra)
     2f4:	0060aa23          	sw	t1,20(ra)
     2f8:	0070ac23          	sw	t2,24(ra)
     2fc:	0080ae23          	sw	s0,28(ra)
     300:	0290a023          	sw	s1,32(ra)
     304:	02a0a223          	sw	a0,36(ra)
     308:	02b0a423          	sw	a1,40(ra)
     30c:	02c0a623          	sw	a2,44(ra)
     310:	02d0a823          	sw	a3,48(ra)
     314:	02e0aa23          	sw	a4,52(ra)
     318:	02f0ac23          	sw	a5,56(ra)
     31c:	0300ae23          	sw	a6,60(ra)
     320:	0510a023          	sw	a7,64(ra)
     324:	0520a223          	sw	s2,68(ra)
     328:	0530a423          	sw	s3,72(ra)
     32c:	0540a623          	sw	s4,76(ra)
     330:	0550a823          	sw	s5,80(ra)
     334:	0560aa23          	sw	s6,84(ra)
     338:	0570ac23          	sw	s7,88(ra)
     33c:	0580ae23          	sw	s8,92(ra)
     340:	0790a023          	sw	s9,96(ra)
     344:	07a0a223          	sw	s10,100(ra)
     348:	07b0a423          	sw	s11,104(ra)
     34c:	07c0a623          	sw	t3,108(ra)
     350:	07d0a823          	sw	t4,112(ra)
     354:	07e0aa23          	sw	t5,116(ra)
     358:	07f0ac23          	sw	t6,120(ra)
     35c:	0800a103          	lw	sp,128(ra)
     360:	00008513          	mv	a0,ra
     364:	00000097          	auipc	ra,0x0
     368:	f7808093          	addi	ra,ra,-136 # 0x2dc
     36c:	00152023          	sw	ra,0(a0)
     370:	00706513          	ori	a0,zero,7
     374:	034000ef          	jal	ra,0x3a8
     378:	0040006f          	j	0x37c
     37c:	d8dff06f          	j	0x108
     380:	0000006f          	j	0x380
     384:	08006513          	ori	a0,zero,128
     388:	020000ef          	jal	ra,0x3a8
     38c:	00000513          	li	a0,0
     390:	084000ef          	jal	ra,0x414
     394:	080000ef          	jal	ra,0x414
     398:	07c000ef          	jal	ra,0x414
     39c:	00000517          	auipc	a0,0x0
     3a0:	c7050513          	addi	a0,a0,-912 # 0xc
     3a4:	00050067          	jr	a0
     3a8:	100002b7          	lui	t0,0x10000
     3ac:	00528303          	lb	t1,5(t0) # 0x10000005
     3b0:	02037313          	andi	t1,t1,32
     3b4:	00031463          	bnez	t1,0x3bc
     3b8:	ff5ff06f          	j	0x3ac
     3bc:	00a28023          	sb	a0,0(t0)
     3c0:	00008067          	ret
     3c4:	ff810113          	addi	sp,sp,-8
     3c8:	00112023          	sw	ra,0(sp)
     3cc:	00812223          	sw	s0,4(sp)
     3d0:	00050413          	mv	s0,a0
     3d4:	0ff57513          	andi	a0,a0,255
     3d8:	fd1ff0ef          	jal	ra,0x3a8
     3dc:	00845513          	srli	a0,s0,0x8
     3e0:	0ff57513          	andi	a0,a0,255
     3e4:	fc5ff0ef          	jal	ra,0x3a8
     3e8:	01045513          	srli	a0,s0,0x10
     3ec:	0ff57513          	andi	a0,a0,255
     3f0:	fb9ff0ef          	jal	ra,0x3a8
     3f4:	01845513          	srli	a0,s0,0x18
     3f8:	0ff57513          	andi	a0,a0,255
     3fc:	fadff0ef          	jal	ra,0x3a8
     400:	00040513          	mv	a0,s0
     404:	00012083          	lw	ra,0(sp)
     408:	00412403          	lw	s0,4(sp)
     40c:	00810113          	addi	sp,sp,8
     410:	00008067          	ret
     414:	ffc10113          	addi	sp,sp,-4
     418:	00112023          	sw	ra,0(sp)
     41c:	fa9ff0ef          	jal	ra,0x3c4
     420:	00012083          	lw	ra,0(sp)
     424:	00410113          	addi	sp,sp,4
     428:	00008067          	ret
     42c:	100002b7          	lui	t0,0x10000
     430:	00528303          	lb	t1,5(t0) # 0x10000005
     434:	00137313          	andi	t1,t1,1
     438:	00031463          	bnez	t1,0x440
     43c:	ff5ff06f          	j	0x430
     440:	00028503          	lb	a0,0(t0)
     444:	00008067          	ret
     448:	fec10113          	addi	sp,sp,-20
     44c:	00112023          	sw	ra,0(sp)
     450:	00812223          	sw	s0,4(sp)
     454:	00912423          	sw	s1,8(sp)
     458:	01212623          	sw	s2,12(sp)
     45c:	01312823          	sw	s3,16(sp)
     460:	fcdff0ef          	jal	ra,0x42c
     464:	00a06433          	or	s0,zero,a0
     468:	fc5ff0ef          	jal	ra,0x42c
     46c:	00a064b3          	or	s1,zero,a0
     470:	fbdff0ef          	jal	ra,0x42c
     474:	00a06933          	or	s2,zero,a0
     478:	fb5ff0ef          	jal	ra,0x42c
     47c:	00a069b3          	or	s3,zero,a0
     480:	0ff47413          	andi	s0,s0,255
     484:	0ff4f493          	andi	s1,s1,255
     488:	0ff97913          	andi	s2,s2,255
     48c:	0ff9f993          	andi	s3,s3,255
     490:	01306533          	or	a0,zero,s3
     494:	00851513          	slli	a0,a0,0x8
     498:	01256533          	or	a0,a0,s2
     49c:	00851513          	slli	a0,a0,0x8
     4a0:	00956533          	or	a0,a0,s1
     4a4:	00851513          	slli	a0,a0,0x8
     4a8:	00856533          	or	a0,a0,s0
     4ac:	00012083          	lw	ra,0(sp)
     4b0:	00412403          	lw	s0,4(sp)
     4b4:	00812483          	lw	s1,8(sp)
     4b8:	00c12903          	lw	s2,12(sp)
     4bc:	01012983          	lw	s3,16(sp)
     4c0:	01410113          	addi	sp,sp,20
     4c4:	00008067          	ret
     4c8:	ff810113          	addi	sp,sp,-8
     4cc:	00112023          	sw	ra,0(sp)
     4d0:	00812223          	sw	s0,4(sp)
     4d4:	f75ff0ef          	jal	ra,0x448
     4d8:	00050413          	mv	s0,a0
     4dc:	00040513          	mv	a0,s0
     4e0:	00012083          	lw	ra,0(sp)
     4e4:	00412403          	lw	s0,4(sp)
     4e8:	00810113          	addi	sp,sp,8
     4ec:	00008067          	ret
	...
    1000:	001f0f13          	addi	t5,t5,1
    1004:	00008067          	ret
    1008:	040002b7          	lui	t0,0x4000
    100c:	fff28293          	addi	t0,t0,-1 # 0x3ffffff
    1010:	00006313          	ori	t1,zero,0
    1014:	00106393          	ori	t2,zero,1
    1018:	00206e13          	ori	t3,zero,2
    101c:	fe0298e3          	bnez	t0,0x100c
    1020:	00008067          	ret
    1024:	010002b7          	lui	t0,0x1000
    1028:	00106313          	ori	t1,zero,1
    102c:	00206393          	ori	t2,zero,2
    1030:	00306e13          	ori	t3,zero,3
    1034:	0063c3b3          	xor	t2,t2,t1
    1038:	00734333          	xor	t1,t1,t2
    103c:	0063c3b3          	xor	t2,t2,t1
    1040:	007e4e33          	xor	t3,t3,t2
    1044:	01c3c3b3          	xor	t2,t2,t3
    1048:	007e4e33          	xor	t3,t3,t2
    104c:	01c34333          	xor	t1,t1,t3
    1050:	006e4e33          	xor	t3,t3,t1
    1054:	01c34333          	xor	t1,t1,t3
    1058:	fff28293          	addi	t0,t0,-1 # 0xffffff
    105c:	fc029ce3          	bnez	t0,0x1034
    1060:	00008067          	ret
    1064:	040002b7          	lui	t0,0x4000
    1068:	00029463          	bnez	t0,0x1070
    106c:	00008067          	ret
    1070:	0040006f          	j	0x1074
    1074:	fff28293          	addi	t0,t0,-1 # 0x3ffffff
    1078:	ff1ff06f          	j	0x1068
    107c:	fff28293          	addi	t0,t0,-1
    1080:	020002b7          	lui	t0,0x2000
    1084:	ffc10113          	addi	sp,sp,-4
    1088:	00512023          	sw	t0,0(sp)
    108c:	00012303          	lw	t1,0(sp)
    1090:	fff30313          	addi	t1,t1,-1
    1094:	00612023          	sw	t1,0(sp)
    1098:	00012283          	lw	t0,0(sp)
    109c:	fe0296e3          	bnez	t0,0x1088
    10a0:	00410113          	addi	sp,sp,4
    10a4:	00008067          	ret
    10a8:	80400537          	lui	a0,0x80400
    10ac:	002005b7          	lui	a1,0x200
    10b0:	000806b7          	lui	a3,0x80
    10b4:	00200737          	lui	a4,0x200
    10b8:	ffc70713          	addi	a4,a4,-4 # 0x1ffffc
    10bc:	00a585b3          	add	a1,a1,a0
    10c0:	00100413          	li	s0,1
    10c4:	00050613          	mv	a2,a0
    10c8:	00862023          	sw	s0,0(a2)
    10cc:	00d41493          	slli	s1,s0,0xd
    10d0:	00944433          	xor	s0,s0,s1
    10d4:	01145493          	srli	s1,s0,0x11
    10d8:	00944433          	xor	s0,s0,s1
    10dc:	00541493          	slli	s1,s0,0x5
    10e0:	00944433          	xor	s0,s0,s1
    10e4:	00460613          	addi	a2,a2,4
    10e8:	feb610e3          	bne	a2,a1,0x10c8
    10ec:	00000613          	li	a2,0
    10f0:	00000293          	li	t0,0
    10f4:	00e472b3          	and	t0,s0,a4
    10f8:	005502b3          	add	t0,a0,t0
    10fc:	0002a283          	lw	t0,0(t0) # 0x2000000
    1100:	0062c2b3          	xor	t0,t0,t1
    1104:	00544433          	xor	s0,s0,t0
    1108:	00d41493          	slli	s1,s0,0xd
    110c:	00944433          	xor	s0,s0,s1
    1110:	01145493          	srli	s1,s0,0x11
    1114:	00944433          	xor	s0,s0,s1
    1118:	00541493          	slli	s1,s0,0x5
    111c:	00944433          	xor	s0,s0,s1
    1120:	00e47333          	and	t1,s0,a4
    1124:	00650333          	add	t1,a0,t1
    1128:	00532023          	sw	t0,0(t1)
    112c:	00028313          	mv	t1,t0
    1130:	00d41493          	slli	s1,s0,0xd
    1134:	00944433          	xor	s0,s0,s1
    1138:	01145493          	srli	s1,s0,0x11
    113c:	00944433          	xor	s0,s0,s1
    1140:	00541493          	slli	s1,s0,0x5
    1144:	00944433          	xor	s0,s0,s1
    1148:	00160613          	addi	a2,a2,1
    114c:	fad614e3          	bne	a2,a3,0x10f4
    1150:	00008067          	ret
    1154:	4f4d                	li	t5,19
    1156:	494e                	lw	s2,208(sp)
    1158:	4f54                	lw	a3,28(a4)
    115a:	2052                	fld	ft0,272(sp)
    115c:	6f66                	ld	t5,88(sp)
    115e:	2072                	fld	ft0,280(sp)
    1160:	4952                	lw	s2,20(sp)
    1162:	562d4353          	0x562d4353
    1166:	2d20                	fld	fs0,88(a0)
    1168:	6920                	ld	s0,80(a0)
    116a:	696e                	ld	s2,216(sp)
    116c:	6974                	ld	a3,208(a0)
    116e:	6c61                	lui	s8,0x18
    1170:	7a69                	lui	s4,0xffffa
    1172:	6465                	lui	s0,0x19
    1174:	002e                	c.slli	zero,0xb
