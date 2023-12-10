
kernel.elf:     file format elf32-littleriscv


Disassembly of section .text:

80000000 <INITLOCATE>:
    .section .text.init
    // 监控程序的入口点，是最先执行的代码
    // .text.init 段放在内存的 0x80000000 位置
INITLOCATE:
    // 跳转到 init.S:START
    la s10, START
80000000:	00000d17          	auipc	s10,0x0
80000004:	00cd0d13          	addi	s10,s10,12 # 8000000c <START>
    jr s10
80000008:	000d0067          	jr	s10

8000000c <START>:

    .global START
START:
    // 清空 BSS
    // _sbss 和 _ebss 在 ld script 中定义
    la s10, _sbss
8000000c:	007f0d17          	auipc	s10,0x7f0
80000010:	ff4d0d13          	addi	s10,s10,-12 # 807f0000 <_sbss>
    la s11, _ebss
80000014:	007f0d97          	auipc	s11,0x7f0
80000018:	104d8d93          	addi	s11,s11,260 # 807f0118 <_ebss>

8000001c <bss_init>:
bss_init:
    beq s10, s11, bss_init_done
8000001c:	01bd0863          	beq	s10,s11,8000002c <bss_init_done>
    sw  zero, 0(s10)
80000020:	000d2023          	sw	zero,0(s10)
    addi s10, s10, 4
80000024:	004d0d13          	addi	s10,s10,4
    j   bss_init
80000028:	ff5ff06f          	j	8000001c <bss_init>

8000002c <bss_init_done>:
bss_init_done:

#ifdef ENABLE_INT
    // 设置异常处理地址寄存器 mtvec
    la s0, EXCEPTION_HANDLER
8000002c:	00000417          	auipc	s0,0x0
80000030:	5d440413          	addi	s0,s0,1492 # 80000600 <EXCEPTION_HANDLER>
    csrw mtvec, s0
80000034:	30541073          	csrw	mtvec,s0

    // 判断是否设置成功（mtvec 是 WARL）
    csrr t0, mtvec
80000038:	305022f3          	csrr	t0,mtvec
    beq t0, s0, mtvec_done
8000003c:	00828a63          	beq	t0,s0,80000050 <mtvec_done>

    // 不成功，尝试 MODE=VECTORED
    la s0, VECTORED_EXCEPTION_HANDLER
80000040:	00000417          	auipc	s0,0x0
80000044:	7c040413          	addi	s0,s0,1984 # 80000800 <VECTORED_EXCEPTION_HANDLER>
    ori s0, s0, 1
80000048:	00146413          	ori	s0,s0,1
    csrw mtvec, s0
8000004c:	30541073          	csrw	mtvec,s0

80000050 <mtvec_done>:
mtvec_done:

    // 打开时钟中断
    li t0, MIE_MTIE
80000050:	08000293          	li	t0,128
    csrw mie, t0
80000054:	30429073          	csrw	mie,t0
#endif

    // 设置内核栈
    la sp, KERNEL_STACK_INIT
80000058:	00800117          	auipc	sp,0x800
8000005c:	fa810113          	addi	sp,sp,-88 # 80800000 <KERNEL_STACK_INIT>

    // 设置用户栈
    li t0, USER_STACK_INIT
80000060:	800002b7          	lui	t0,0x80000
    // 设置用户态程序的 sp(x2) 和 fp(x8) 寄存器
    // uregs_sp 和 uregs_fp 在 ld script 中定义
    la t1, uregs_sp
80000064:	007f0317          	auipc	t1,0x7f0
80000068:	fa030313          	addi	t1,t1,-96 # 807f0004 <uregs_sp>
    STORE t0, 0(t1)
8000006c:	00532023          	sw	t0,0(t1)
    la t1, uregs_fp
80000070:	007f0317          	auipc	t1,0x7f0
80000074:	fac30313          	addi	t1,t1,-84 # 807f001c <uregs_fp>
    STORE t0, 0(t1)
80000078:	00532023          	sw	t0,0(t1)

#ifdef ENABLE_UART16550
    // 配置串口，见 serial.h 中的叙述进行配置
    li t0, COM1
8000007c:	100002b7          	lui	t0,0x10000
    // 打开 FIFO，并且清空 FIFO
    li t1, COM_FCR_CONFIG 
80000080:	00700313          	li	t1,7
    sb t1, %lo(COM_FCR_OFFSET)(t0)
80000084:	00628123          	sb	t1,2(t0) # 10000002 <INITLOCATE-0x6ffffffe>
    // 打开 DLAB
    li t1, COM_LCR_DLAB
80000088:	08000313          	li	t1,128
    sb t1, %lo(COM_LCR_OFFSET)(t0)
8000008c:	006281a3          	sb	t1,3(t0)
    // 设置 Baudrate
    li t1, COM_DLL_VAL
80000090:	00c00313          	li	t1,12
    sb t1, %lo(COM_DLL_OFFSET)(t0)
80000094:	00628023          	sb	t1,0(t0)
    sb x0, %lo(COM_DLM_OFFSET)(t0)
80000098:	000280a3          	sb	zero,1(t0)
    // 关闭 DLAB，打开 WLEN8
    li t1, COM_LCR_CONFIG
8000009c:	00300313          	li	t1,3
    sb t1, %lo(COM_LCR_OFFSET)(t0)
800000a0:	006281a3          	sb	t1,3(t0)
    sb x0, %lo(COM_MCR_OFFSET)(t0)
800000a4:	00028223          	sb	zero,4(t0)
    // 打开串口中断
    li t1, COM_IER_RDI
800000a8:	00100313          	li	t1,1
    sb t1, %lo(COM_IER_OFFSET)(t0)
800000ac:	006280a3          	sb	t1,1(t0)
#endif

    // 从内核栈顶清空并留出 TF_SIZE 大小的空间用于存储中断帧
    li t0, TF_SIZE
800000b0:	08000293          	li	t0,128
.LC0:
    addi t0, t0, -XLEN
800000b4:	ffc28293          	addi	t0,t0,-4
    addi sp, sp, -XLEN
800000b8:	ffc10113          	addi	sp,sp,-4
    STORE zero, 0(sp)
800000bc:	00012023          	sw	zero,0(sp)
    bne t0, zero, .LC0
800000c0:	fe029ae3          	bnez	t0,800000b4 <mtvec_done+0x64>

    // 保存中断帧地址到 TCBT
    la t0, TCBT
800000c4:	007f0297          	auipc	t0,0x7f0
800000c8:	03c28293          	addi	t0,t0,60 # 807f0100 <TCBT>
    STORE sp, 0(t0)
800000cc:	0022a023          	sw	sp,0(t0)

    // t6 保存 idle 中断帧位置
    mv t6, sp
800000d0:	00010f93          	mv	t6,sp

    // 初始化栈空间
    li t0, TF_SIZE
800000d4:	08000293          	li	t0,128
.LC1:
    addi t0, t0, -XLEN
800000d8:	ffc28293          	addi	t0,t0,-4
    addi sp, sp, -XLEN
800000dc:	ffc10113          	addi	sp,sp,-4
    STORE zero, 0(sp)
800000e0:	00012023          	sw	zero,0(sp)
    bne t0, zero, .LC1
800000e4:	fe029ae3          	bnez	t0,800000d8 <mtvec_done+0x88>

    // 载入TCBT地址
    la t0, TCBT
800000e8:	007f0297          	auipc	t0,0x7f0
800000ec:	01828293          	addi	t0,t0,24 # 807f0100 <TCBT>
    // thread1(shell/user) 的中断帧地址设置
    STORE sp, XLEN(t0)
800000f0:	0022a223          	sw	sp,4(t0)
    // 设置 idle 线程栈指针(调试用?)
    STORE sp, TF_sp(t6)
800000f4:	002fa223          	sw	sp,4(t6)

    // 取得 thread1 的 TCB 地址
    la t2, TCBT + XLEN
800000f8:	007f0397          	auipc	t2,0x7f0
800000fc:	00c38393          	addi	t2,t2,12 # 807f0104 <TCBT+0x4>
    LOAD t2, 0(t2)
80000100:	0003a383          	lw	t2,0(t2)

#ifdef ENABLE_INT
    // 设置当前线程为 thread1
    csrw mscratch, t2
80000104:	34039073          	csrw	mscratch,t2
#endif

    la t1, current
80000108:	007f0317          	auipc	t1,0x7f0
8000010c:	00830313          	addi	t1,t1,8 # 807f0110 <current>
    sw t2, 0(t1)
80000110:	00732023          	sw	t2,0(t1)

#ifdef ENABLE_PAGING
#ifdef RV32
    // Sv32 是两级页表，PAGE_TABLE 为一级页表
    la t0, PAGE_TABLE
80000114:	00002297          	auipc	t0,0x2
80000118:	eec28293          	addi	t0,t0,-276 # 80002000 <PAGE_TABLE>
#endif

    // 填写用户代码的页表
    // 需要映射 0x00000000-0x002FF000 (VA) 共 768
    // Sv32 时都在一个页中
    la t1, PAGE_TABLE_USER_CODE
8000011c:	00003317          	auipc	t1,0x3
80000120:	ee430313          	addi	t1,t1,-284 # 80003000 <PAGE_TABLE_USER_CODE>
#ifdef RV32
    li t3, 768
80000124:	30000e13          	li	t3,768
#else
    li t3, 512
#endif
    li t2, 0
80000128:	00000393          	li	t2,0
.LOOP_USER_CODE:
// t1 代表 PAGE_TABLE_USER_CODE 的地址，也就是 80100000 对应的表项的地址
// t4 代表 80100000 对应的表项
// 通过 t1+=4 和 t2+=1，计算 t4 + (t2 << 10) 把 80100000 ~ 802ff000 对应的表项依次填入到 PAGE_TABLE_USER_CODE 中
    li t4, 0x200400fb  // 0x80100000 DAGUX-RV
// 0x80100000 = 0b1000_0000_0001_0000_0000_0000_0000_0000
// PTE：高两位补0，物理地址保留高 20 位，RSW=0
// PTE = 0b00__1000_0000_0001_0000_0000__00__1111_1011
8000012c:	20040eb7          	lui	t4,0x20040
80000130:	0fbe8e93          	addi	t4,t4,251 # 200400fb <INITLOCATE-0x5ffbff05>
    slli t5, t2, 10
80000134:	00a39f13          	slli	t5,t2,0xa # RSM 2 位，控制位 8 位，左移 10 位
    add t4, t4, t5
80000138:	01ee8eb3          	add	t4,t4,t5
    sw t4, 0(t1)
8000013c:	01d32023          	sw	t4,0(t1)
    addi t1, t1, XLEN
80000140:	00430313          	addi	t1,t1,4
    addi t2, t2, 1
80000144:	00138393          	addi	t2,t2,1
    bne t2, t3, .LOOP_USER_CODE
80000148:	ffc392e3          	bne	t2,t3,8000012c <mtvec_done+0xdc> # 共 768 次

    la t1, PAGE_TABLE_USER_CODE
// t1 = 0b1000_0000_0000_0000_0011_0000_0000_0000
// t1 = 0b0010_0000_0000_0000_0000_1100_0000_0000
// t1 = 0b0010_0000_0000_0000_0000_1100_1111_0001 (PTE of PAGE_TABLE_USER_CODE)
// 这里是因为 PAGE_TABLE_USER_CODE 是二级页表，所以也按照上面的格式填写到一级页表中
8000014c:	00003317          	auipc	t1,0x3
80000150:	eb430313          	addi	t1,t1,-332 # 80003000 <PAGE_TABLE_USER_CODE>
    srli t1, t1, 2
80000154:	00235313          	srli	t1,t1,0x2
    ori t1, t1, 0xf1
80000158:	0f136313          	ori	t1,t1,241
    sw t1, 0(t0)
8000015c:	0062a023          	sw	t1,0(t0)
    sw t1, 8(t0)
#endif

    // 内核代码段映射
    // 需要映射 0x80000000 和 0x80100000
    // 0x80000000 = 0b1000_0000_00__00_0000_0000__0000_0000_0000
    // 0x80100000 = 0b1000_0000_00__01_0000_0000__0000_0000_0000
    // page_table_2_addr = 0x80002800
    // 00_0000_0000_00 ~ 00_0000_0001_00
    la t0, PAGE_TABLE
80000160:	00002297          	auipc	t0,0x2
80000164:	ea028293          	addi	t0,t0,-352 # 80002000 <PAGE_TABLE>
    la t1, PAGE_TABLE_KERNEL_CODE
80000168:	00004317          	auipc	t1,0x4
8000016c:	e9830313          	addi	t1,t1,-360 # 80004000 <PAGE_TABLE_KERNEL_CODE>
// t1 = 0b1000_0000_0000_0000_0100_0000_0000_0000
    srli t1, t1, 2
80000170:	00235313          	srli	t1,t1,0x2
// t1 = 0b0010_0000_0000_0000_0001_0000_0000_0000
    ori t1, t1, 0xf1
80000174:	0f136313          	ori	t1,t1,241
// t1 = 0b0010_0000_0000_0000_0001_0000_1111_0001
// t1 = 0x200010f1
// t1 是 PAGE_TABLE_KERNEL_CODE 的表项
#ifdef RV32
    li t2, 512*4 // t2 = 0x800
80000178:	000013b7          	lui	t2,0x1
8000017c:	80038393          	addi	t2,t2,-2048 # 800 <INITLOCATE-0x7ffff800>
#else
    li t2, 2*8
#endif
    add t2, t0, t2
80000180:	007283b3          	add	t2,t0,t2 # t2 = 0x80002800
    sw t1, 0(t2)
80000184:	0063a023          	sw	t1,0(t2)

    // 填写用户数据的页表
    // 需要映射 0x7FC10000-0x7FFFF000
    // 0x7fc10 ~ 0x7ffff
    // fff - c10 = 3ef = 1007
    // 1007 + 1 + 16 = 1024
    // Sv32 情况下在一个二级页表内
#ifdef RV32
    la t1, PAGE_TABLE_USER_STACK
80000188:	00005317          	auipc	t1,0x5
8000018c:	e7830313          	addi	t1,t1,-392 # 80005000 <PAGE_TABLE_USER_STACK>
    addi t1, t1, 4*16
80000190:	04030313          	addi	t1,t1,64
    li t3, 1024
80000194:	40000e13          	li	t3,1024
    li t2, 16
80000198:	01000393          	li	t2,16
// t2 = 0x10 = 0b10000
// t2 << 10 = 0b1_0000__00_0000_0000 = 0x4000
.LOOP_USER_STACK:
    li t4, 0x200fc0f7  // 0x803F0000 DAGU-WRV
// 0x803F0000 = 0b1000_0000_0011_1111_0000_0000_0000_0000
// 0b00__1000_0000_0011_1111_0000__00__1111_0111
// 0b1000_0000_0100_0000_0000_0000_0000_0000 = 0x80040000
8000019c:	200fceb7          	lui	t4,0x200fc
800001a0:	0f7e8e93          	addi	t4,t4,247 # 200fc0f7 <INITLOCATE-0x5ff03f09>
    slli t5, t2, 10
800001a4:	00a39f13          	slli	t5,t2,0xa
    add t4, t4, t5
800001a8:	01ee8eb3          	add	t4,t4,t5
    sw t4, 0(t1)
800001ac:	01d32023          	sw	t4,0(t1)
    addi t1, t1, 4
800001b0:	00430313          	addi	t1,t1,4
    addi t2, t2, 1
800001b4:	00138393          	addi	t2,t2,1
    bne t2, t3, .LOOP_USER_STACK
800001b8:	ffc392e3          	bne	t2,t3,8000019c <mtvec_done+0x14c>

    la t1, PAGE_TABLE_USER_STACK
800001bc:	00005317          	auipc	t1,0x5
800001c0:	e4430313          	addi	t1,t1,-444 # 80005000 <PAGE_TABLE_USER_STACK>
// t1 = 0b1000_0000_0000_0000_0101_0000_0000_0000
    srli t1, t1, 2
800001c4:	00235313          	srli	t1,t1,0x2
// t1 = 0b0010_0000_0000_0000_0001_0100_0000_0000
    ori t1, t1, 0xf1
800001c8:	0f136313          	ori	t1,t1,241
// t1 = 0b0010_0000_0000_0000_0001_0100_1111_0001
// t1 = 0x200014f1
    li t2, 2044
800001cc:	7fc00393          	li	t2,2044 # t2 = 0x7fc
    add t2, t0, t2
800001d0:	007283b3          	add	t2,t0,t2 # t2 = 0x800027fc
    sw t1, 0(t2)
800001d4:	0063a023          	sw	t1,0(t2)
    add t2, t0, t2
    sw t1, 0(t2)
#endif

    // 让页表生效
    la t0, PAGE_TABLE
800001d8:	00002297          	auipc	t0,0x2
800001dc:	e2828293          	addi	t0,t0,-472 # 80002000 <PAGE_TABLE>
    srli t0, t0, 12
800001e0:	00c2d293          	srli	t0,t0,0xc
#ifdef RV32
    li t1, SATP_SV32
800001e4:	80000337          	lui	t1,0x80000
#else
    li t1, SATP_SV39
#endif
    or t0, t0, t1
800001e8:	0062e2b3          	or	t0,t0,t1
    csrw satp, t0
800001ec:	18029073          	csrw	satp,t0
    sfence.vma
800001f0:	12000073          	sfence.vma

#ifdef ENABLE_INT
    // 设置 PMP Config
#ifdef RV32
    // 0x00000000-0xffffffff RWX
    li t0, 0b00001111
800001f4:	00f00293          	li	t0,15
    csrw pmpcfg0, t0
800001f8:	3a029073          	csrw	pmpcfg0,t0
    li t0, 0xffffffff
800001fc:	fff00293          	li	t0,-1
    csrw pmpaddr0, t0
80000200:	3b029073          	csrw	pmpaddr0,t0
    csrw pmpaddr0, t0
#endif
#endif

    // 进入主线程
    j WELCOME
80000204:	0040006f          	j	80000208 <WELCOME>

80000208 <WELCOME>:

WELCOME:
    // 装入启动信息并打印
    la a0, monitor_version
80000208:	00001517          	auipc	a0,0x1
8000020c:	f6850513          	addi	a0,a0,-152 # 80001170 <monitor_version>
    jal WRITE_SERIAL_STRING
80000210:	7e8000ef          	jal	ra,800009f8 <WRITE_SERIAL_STRING>

    // 开始交互
    j SHELL
80000214:	0040006f          	j	80000218 <SHELL>

80000218 <SHELL>:
     *  用户空间寄存器：x1-x31依次保存在 0x807F0000 连续 124 字节
     *  用户程序入口临时存储：0x807F0000
     */
SHELL:
    // 读操作符
    jal READ_SERIAL
80000218:	001000ef          	jal	ra,80000a18 <READ_SERIAL>

    // 根据操作符进行不同的操作
    li t0, 'R'
8000021c:	05200293          	li	t0,82
    beq a0, t0, .OP_R
80000220:	06550a63          	beq	a0,t0,80000294 <.OP_R>
    li t0, 'D'
80000224:	04400293          	li	t0,68
    beq a0, t0, .OP_D
80000228:	0a550463          	beq	a0,t0,800002d0 <.OP_D>
    li t0, 'A'
8000022c:	04100293          	li	t0,65
    beq a0, t0, .OP_A
80000230:	0e550063          	beq	a0,t0,80000310 <.OP_A>
    li t0, 'G'
80000234:	04700293          	li	t0,71
    beq a0, t0, .OP_G
80000238:	10550e63          	beq	a0,t0,80000354 <.OP_G>
    li t0, 'T'
8000023c:	05400293          	li	t0,84
    beq a0, t0, .OP_T
80000240:	00550863          	beq	a0,t0,80000250 <.OP_T>

    // 错误的操作符，输出 XLEN，用于区分 RV32 和 RV64
    li a0, XLEN
80000244:	00400513          	li	a0,4
    // 把 XLEN 写给 term
    jal WRITE_SERIAL
80000248:	72c000ef          	jal	ra,80000974 <WRITE_SERIAL>
    j .DONE
8000024c:	2d00006f          	j	8000051c <.DONE>

80000250 <.OP_T>:

.OP_T:
    // 操作 - 打印页表
    // 保存寄存器
    addi sp, sp, -3*XLEN
80000250:	ff410113          	addi	sp,sp,-12
    STORE s1, 0(sp)
80000254:	00912023          	sw	s1,0(sp)
    STORE s2, XLEN(sp)
80000258:	01212223          	sw	s2,4(sp)

#ifdef ENABLE_PAGING
    csrr s1, satp
8000025c:	180024f3          	csrr	s1,satp
    slli s1, s1, 12
80000260:	00c49493          	slli	s1,s1,0xc
#else
    li s1, -1
#endif
    STORE s1, 2*XLEN(sp)
80000264:	00912423          	sw	s1,8(sp)
    addi s1, sp, 2*XLEN
80000268:	00810493          	addi	s1,sp,8
    li s2, XLEN
8000026c:	00400913          	li	s2,4
.LC0:
    // 读取内存并写入串口
    lb a0, 0(s1)
80000270:	00048503          	lb	a0,0(s1)
    addi s2, s2, -1
80000274:	fff90913          	addi	s2,s2,-1
    jal WRITE_SERIAL
80000278:	6fc000ef          	jal	ra,80000974 <WRITE_SERIAL>
    addi s1, s1, 0x1
8000027c:	00148493          	addi	s1,s1,1
    bne s2, zero, .LC0
80000280:	fe0918e3          	bnez	s2,80000270 <.OP_T+0x20>

    // 恢复寄存器
    LOAD s1, 0x0(sp)
80000284:	00012483          	lw	s1,0(sp)
    LOAD s2, XLEN(sp)
80000288:	00412903          	lw	s2,4(sp)
    addi sp, sp, 3*XLEN
8000028c:	00c10113          	addi	sp,sp,12

    j .DONE
80000290:	28c0006f          	j	8000051c <.DONE>

80000294 <.OP_R>:

.OP_R:
    // 操作 - 打印用户空间寄存器
    // 保存 s1, s2
    addi sp, sp, -2*XLEN
80000294:	ff810113          	addi	sp,sp,-8
    STORE s1, 0(sp)
80000298:	00912023          	sw	s1,0(sp)
    STORE s2, XLEN(sp)
8000029c:	01212223          	sw	s2,4(sp)

    // 打印 31 个寄存器
    la s1, uregs
800002a0:	007f0497          	auipc	s1,0x7f0
800002a4:	d6048493          	addi	s1,s1,-672 # 807f0000 <_sbss>
    li s2, 31*XLEN
800002a8:	07c00913          	li	s2,124
.LC1:
    // 读取内存并写入串口
    lb a0, 0(s1)
800002ac:	00048503          	lb	a0,0(s1)
    addi s2, s2, -1
800002b0:	fff90913          	addi	s2,s2,-1
    jal WRITE_SERIAL
800002b4:	6c0000ef          	jal	ra,80000974 <WRITE_SERIAL>
    addi s1, s1, 0x1
800002b8:	00148493          	addi	s1,s1,1
    bne s2, zero, .LC1
800002bc:	fe0918e3          	bnez	s2,800002ac <.OP_R+0x18>

    // 恢复s1,s2
    LOAD s1, 0(sp)
800002c0:	00012483          	lw	s1,0(sp)
    LOAD s2, XLEN(sp)
800002c4:	00412903          	lw	s2,4(sp)
    addi sp, sp, 2*XLEN
800002c8:	00810113          	addi	sp,sp,8
    j .DONE
800002cc:	2500006f          	j	8000051c <.DONE>

800002d0 <.OP_D>:

.OP_D:
    // 操作 - 打印内存 num 个字节
    // 保存 s1, s2
    addi sp, sp, -2*XLEN
800002d0:	ff810113          	addi	sp,sp,-8
    STORE s1, 0(sp)
800002d4:	00912023          	sw	s1,0(sp)
    STORE s2, XLEN(sp)
800002d8:	01212223          	sw	s2,4(sp)

    // 获得 addr
    jal READ_SERIAL_XLEN
800002dc:	7d8000ef          	jal	ra,80000ab4 <READ_SERIAL_XLEN>
    or s1, a0, zero
800002e0:	000564b3          	or	s1,a0,zero
    // 获得 num
    jal READ_SERIAL_XLEN
800002e4:	7d0000ef          	jal	ra,80000ab4 <READ_SERIAL_XLEN>
    or s2, a0, zero
800002e8:	00056933          	or	s2,a0,zero

.LC2:
    // 读取内存并写入串口
    lb a0, 0(s1)
800002ec:	00048503          	lb	a0,0(s1)
    addi s2, s2, -1
800002f0:	fff90913          	addi	s2,s2,-1
    jal WRITE_SERIAL
800002f4:	680000ef          	jal	ra,80000974 <WRITE_SERIAL>
    addi s1, s1, 0x1
800002f8:	00148493          	addi	s1,s1,1
    bne s2, zero, .LC2
800002fc:	fe0918e3          	bnez	s2,800002ec <.OP_D+0x1c>

    // 恢复 s1, s2
    LOAD s1, 0(sp)                    
80000300:	00012483          	lw	s1,0(sp)
    LOAD s2, XLEN(sp)
80000304:	00412903          	lw	s2,4(sp)
    addi sp, sp, 2*XLEN
80000308:	00810113          	addi	sp,sp,8
    j .DONE
8000030c:	2100006f          	j	8000051c <.DONE>

80000310 <.OP_A>:

.OP_A:
    // 操作 - 写入内存 num 字节，num 为 4 的倍数
    // 保存 s1, s2
    addi sp, sp, -2*XLEN
80000310:	ff810113          	addi	sp,sp,-8
    STORE s1, 0(sp)
80000314:	00912023          	sw	s1,0(sp)
    STORE s2, 4(sp)
80000318:	01212223          	sw	s2,4(sp)

    // 获得 addr
    jal READ_SERIAL_XLEN
8000031c:	798000ef          	jal	ra,80000ab4 <READ_SERIAL_XLEN>
    or s1, a0, zero
80000320:	000564b3          	or	s1,a0,zero

    // 获得 num
    jal READ_SERIAL_XLEN
80000324:	790000ef          	jal	ra,80000ab4 <READ_SERIAL_XLEN>
    or s2, a0, zero
80000328:	00056933          	or	s2,a0,zero

    // num 除 4，获得字数
    srl s2, s2, 2
8000032c:	00295913          	srli	s2,s2,0x2

.LC3:
    // 每次写入一字
    // 从串口读入一字
    jal READ_SERIAL_WORD
80000330:	704000ef          	jal	ra,80000a34 <READ_SERIAL_WORD>
    // 写内存一字
    sw a0, 0(s1)
80000334:	00a4a023          	sw	a0,0(s1)
    addi s2, s2, -1
80000338:	fff90913          	addi	s2,s2,-1
    addi s1, s1, 4
8000033c:	00448493          	addi	s1,s1,4
    bne s2, zero, .LC3
80000340:	fe0918e3          	bnez	s2,80000330 <.OP_A+0x20>
    // 有 Cache 时让写入的代码生效
    fence.i
#endif

    // 恢复 s1, s2
    LOAD s1, 0(sp)
80000344:	00012483          	lw	s1,0(sp)
    LOAD s2, XLEN(sp)
80000348:	00412903          	lw	s2,4(sp)
    addi sp, sp, 2*XLEN
8000034c:	00810113          	addi	sp,sp,8
    j .DONE
80000350:	1cc0006f          	j	8000051c <.DONE>

80000354 <.OP_G>:

.OP_G:
    // 操作 - 跳转到用户程序执行
    // 获取 addr
    jal READ_SERIAL_XLEN
80000354:	760000ef          	jal	ra,80000ab4 <READ_SERIAL_XLEN>
    // 保存到 s10
    mv s10, a0
80000358:	00050d13          	mv	s10,a0

    // 写开始计时信号
    // 告诉终端用户程序开始运行
    li a0, SIG_TIMERSET
8000035c:	00600513          	li	a0,6
    jal WRITE_SERIAL
80000360:	614000ef          	jal	ra,80000974 <WRITE_SERIAL>

#ifdef ENABLE_INT
    // 用户程序入口写入EPC
    csrw mepc, s10
80000364:	341d1073          	csrw	mepc,s10

    // 设置 MPP=0，对应 U-mode
    li a0, MSTATUS_MPP_MASK
80000368:	00002537          	lui	a0,0x2
8000036c:	80050513          	addi	a0,a0,-2048 # 1800 <INITLOCATE-0x7fffe800>
    csrc mstatus, a0
80000370:	30053073          	csrc	mstatus,a0
    li t3, 10000000
    add t3, t1, t3      // + 10000000
    li t0, CLINT_MTIMECMP
    sd t3, 0(t0)        // 写入 mtimecmp
#else
    li t0, CLINT_MTIME
80000374:	0200c2b7          	lui	t0,0x200c
80000378:	ff828293          	addi	t0,t0,-8 # 200bff8 <INITLOCATE-0x7dff4008>
    lw t1, 0(t0)        // 读取 mtime 低 32 位
8000037c:	0002a303          	lw	t1,0(t0)
    lw t2, 4(t0)        // 读取 mtime 高 32 位
80000380:	0042a383          	lw	t2,4(t0)
    li t3, 10000000
80000384:	00989e37          	lui	t3,0x989
80000388:	680e0e13          	addi	t3,t3,1664 # 989680 <INITLOCATE-0x7f676980>
    add t3, t1, t3      // 低 32 位 + 10000000
8000038c:	01c30e33          	add	t3,t1,t3
    sltu t1, t3, t1     // 生成进位，若进位 t1 = 1
80000390:	006e3333          	sltu	t1,t3,t1
    add t2, t2, t1      // 高 32 位进位
80000394:	006383b3          	add	t2,t2,t1
    li t0, CLINT_MTIMECMP
80000398:	020042b7          	lui	t0,0x2004
    sw t2, 4(t0)        // 写入 mtimecmp 高 32 位
8000039c:	0072a223          	sw	t2,4(t0) # 2004004 <INITLOCATE-0x7dffbffc>
    sw t3, 0(t0)        // 写入 mtimecmp 低 32 位
800003a0:	01c2a023          	sw	t3,0(t0)
#endif

#endif

    // 定位用户空间寄存器备份地址
    la ra, uregs
800003a4:	007f0097          	auipc	ra,0x7f0
800003a8:	c5c08093          	addi	ra,ra,-932 # 807f0000 <_sbss>
    // 保存栈指针
    STORE sp, TF_ksp(ra)
800003ac:	0820a023          	sw	sp,128(ra)

    // x1 就是 ra
    // LOAD x1,  TF_ra(ra)
    LOAD sp, TF_sp(ra)
800003b0:	0040a103          	lw	sp,4(ra)
    LOAD gp, TF_gp(ra)
800003b4:	0080a183          	lw	gp,8(ra)
    LOAD tp, TF_tp(ra)
800003b8:	00c0a203          	lw	tp,12(ra)
    LOAD t0, TF_t0(ra)
800003bc:	0100a283          	lw	t0,16(ra)
    LOAD t1, TF_t1(ra)
800003c0:	0140a303          	lw	t1,20(ra)
    LOAD t2, TF_t2(ra)
800003c4:	0180a383          	lw	t2,24(ra)
    LOAD s0, TF_s0(ra)
800003c8:	01c0a403          	lw	s0,28(ra)
    LOAD s1, TF_s1(ra)
800003cc:	0200a483          	lw	s1,32(ra)
    LOAD a0, TF_a0(ra)
800003d0:	0240a503          	lw	a0,36(ra)
    LOAD a1, TF_a1(ra)
800003d4:	0280a583          	lw	a1,40(ra)
    LOAD a2, TF_a2(ra)
800003d8:	02c0a603          	lw	a2,44(ra)
    LOAD a3, TF_a3(ra)
800003dc:	0300a683          	lw	a3,48(ra)
    LOAD a4, TF_a4(ra)
800003e0:	0340a703          	lw	a4,52(ra)
    LOAD a5, TF_a5(ra)
800003e4:	0380a783          	lw	a5,56(ra)
    LOAD a6, TF_a6(ra)
800003e8:	03c0a803          	lw	a6,60(ra)
    LOAD a7, TF_a7(ra)
800003ec:	0400a883          	lw	a7,64(ra)
    LOAD s2, TF_s2(ra)
800003f0:	0440a903          	lw	s2,68(ra)
    LOAD s3, TF_s3(ra)
800003f4:	0480a983          	lw	s3,72(ra)
    LOAD s4, TF_s4(ra)
800003f8:	04c0aa03          	lw	s4,76(ra)
    LOAD s5, TF_s5(ra)
800003fc:	0500aa83          	lw	s5,80(ra)
    LOAD s6, TF_s6(ra)
80000400:	0540ab03          	lw	s6,84(ra)
    LOAD s7, TF_s7(ra)
80000404:	0580ab83          	lw	s7,88(ra)
    LOAD s8, TF_s8(ra)
80000408:	05c0ac03          	lw	s8,92(ra)
    LOAD s9, TF_s9(ra)
8000040c:	0600ac83          	lw	s9,96(ra)
    // s10 用来保存用户程序地址
    // LOAD s10, TF_s10(ra)
    LOAD s11, TF_s11(ra)
80000410:	0680ad83          	lw	s11,104(ra)
    LOAD t3, TF_t3(ra)
80000414:	06c0ae03          	lw	t3,108(ra)
    LOAD t4, TF_t4(ra)
80000418:	0700ae83          	lw	t4,112(ra)
    LOAD t5, TF_t5(ra)
8000041c:	0740af03          	lw	t5,116(ra)
    LOAD t6, TF_t6(ra)
80000420:	0780af83          	lw	t6,120(ra)

80000424 <.ENTER_UESR>:

.ENTER_UESR:
#ifdef ENABLE_INT
    // ra 写入返回地址
    la ra, .USERRET_USER
80000424:	00000097          	auipc	ra,0x0
80000428:	00c08093          	addi	ra,ra,12 # 80000430 <.USERRET_USER>
    // 进入用户程序
    mret
8000042c:	30200073          	mret

80000430 <.USERRET_USER>:
    jr s10
#endif

#ifdef ENABLE_INT
.USERRET_USER:
    ebreak
80000430:	00100073          	ebreak

80000434 <USERRET_TIMEOUT>:

    .global USERRET_TIMEOUT
USERRET_TIMEOUT:
    // 发送超时信号
    // 告诉终端用户程序结束运行
    li a0, SIG_TIMEOUT
80000434:	08100513          	li	a0,129
    jal WRITE_SERIAL
80000438:	53c000ef          	jal	ra,80000974 <WRITE_SERIAL>
    j 0f
8000043c:	00c0006f          	j	80000448 <USERRET_MACHINE+0x8>

80000440 <USERRET_MACHINE>:

    .global USERRET_MACHINE
USERRET_MACHINE:
    // 发送停止计时信号
    // 告诉终端用户程序结束运行
    li a0, SIG_TIMETOKEN
80000440:	00700513          	li	a0,7
    jal WRITE_SERIAL
80000444:	530000ef          	jal	ra,80000974 <WRITE_SERIAL>

    // 复制寄存器数据
0:
    la s1, uregs
80000448:	007f0497          	auipc	s1,0x7f0
8000044c:	bb848493          	addi	s1,s1,-1096 # 807f0000 <_sbss>
    li s2, TF_SIZE
80000450:	08000913          	li	s2,128
.LC4:
    lw a0, 0(sp)
80000454:	00012503          	lw	a0,0(sp)
    sw a0, 0(s1)
80000458:	00a4a023          	sw	a0,0(s1)
    addi s2, s2, -4
8000045c:	ffc90913          	addi	s2,s2,-4
    addi s1, s1, 0x4
80000460:	00448493          	addi	s1,s1,4
    addi sp, sp, 0x4
80000464:	00410113          	addi	sp,sp,4
    bne s2, zero, .LC4
80000468:	fe0916e3          	bnez	s2,80000454 <USERRET_MACHINE+0x14>

    // 重新获得当前监控程序栈顶指针
    la s1, uregs
8000046c:	007f0497          	auipc	s1,0x7f0
80000470:	b9448493          	addi	s1,s1,-1132 # 807f0000 <_sbss>
    LOAD sp, TF_ksp(s1)
80000474:	0804a103          	lw	sp,128(s1)

    j .DONE
80000478:	0a40006f          	j	8000051c <.DONE>

8000047c <.USERRET2>:
#endif

.USERRET2:
    // 定位用户空间寄存器备份地址
    la ra, uregs
8000047c:	007f0097          	auipc	ra,0x7f0
80000480:	b8408093          	addi	ra,ra,-1148 # 807f0000 <_sbss>

    // 不能先恢复 ra
    //STORE ra, TF_ra(ra)
    STORE sp, TF_sp(ra)
80000484:	0020a223          	sw	sp,4(ra)
    STORE gp, TF_gp(ra)
80000488:	0030a423          	sw	gp,8(ra)
    STORE tp, TF_tp(ra)
8000048c:	0040a623          	sw	tp,12(ra)
    STORE t0, TF_t0(ra)
80000490:	0050a823          	sw	t0,16(ra)
    STORE t1, TF_t1(ra)
80000494:	0060aa23          	sw	t1,20(ra)
    STORE t2, TF_t2(ra)
80000498:	0070ac23          	sw	t2,24(ra)
    STORE s0, TF_s0(ra)
8000049c:	0080ae23          	sw	s0,28(ra)
    STORE s1, TF_s1(ra)
800004a0:	0290a023          	sw	s1,32(ra)
    STORE a0, TF_a0(ra)
800004a4:	02a0a223          	sw	a0,36(ra)
    STORE a1, TF_a1(ra)
800004a8:	02b0a423          	sw	a1,40(ra)
    STORE a2, TF_a2(ra)
800004ac:	02c0a623          	sw	a2,44(ra)
    STORE a3, TF_a3(ra)
800004b0:	02d0a823          	sw	a3,48(ra)
    STORE a4, TF_a4(ra)
800004b4:	02e0aa23          	sw	a4,52(ra)
    STORE a5, TF_a5(ra)
800004b8:	02f0ac23          	sw	a5,56(ra)
    STORE a6, TF_a6(ra)
800004bc:	0300ae23          	sw	a6,60(ra)
    STORE a7, TF_a7(ra)
800004c0:	0510a023          	sw	a7,64(ra)
    STORE s2, TF_s2(ra)
800004c4:	0520a223          	sw	s2,68(ra)
    STORE s3, TF_s3(ra)
800004c8:	0530a423          	sw	s3,72(ra)
    STORE s4, TF_s4(ra)
800004cc:	0540a623          	sw	s4,76(ra)
    STORE s5, TF_s5(ra)
800004d0:	0550a823          	sw	s5,80(ra)
    STORE s6, TF_s6(ra)
800004d4:	0560aa23          	sw	s6,84(ra)
    STORE s7, TF_s7(ra)
800004d8:	0570ac23          	sw	s7,88(ra)
    STORE s8, TF_s8(ra)
800004dc:	0580ae23          	sw	s8,92(ra)
    STORE s9, TF_s9(ra)
800004e0:	0790a023          	sw	s9,96(ra)
    STORE s10, TF_s10(ra)
800004e4:	07a0a223          	sw	s10,100(ra)
    STORE s11, TF_s11(ra)
800004e8:	07b0a423          	sw	s11,104(ra)
    STORE t3, TF_t3(ra)
800004ec:	07c0a623          	sw	t3,108(ra)
    STORE t4, TF_t4(ra)
800004f0:	07d0a823          	sw	t4,112(ra)
    STORE t5, TF_t5(ra)
800004f4:	07e0aa23          	sw	t5,116(ra)
    STORE t6, TF_t6(ra)
800004f8:	07f0ac23          	sw	t6,120(ra)

    // 重新获得当前监控程序栈顶指针
    LOAD sp, TF_ksp(ra)
800004fc:	0800a103          	lw	sp,128(ra)
    mv a0, ra
80000500:	00008513          	mv	a0,ra
    la ra, .USERRET2
80000504:	00000097          	auipc	ra,0x0
80000508:	f7808093          	addi	ra,ra,-136 # 8000047c <.USERRET2>
    STORE ra, TF_ra(a0)
8000050c:	00152023          	sw	ra,0(a0)

    // 发送停止计时信号
    li a0, SIG_TIMETOKEN
80000510:	00700513          	li	a0,7
    // 告诉终端用户程序结束运行
    jal WRITE_SERIAL
80000514:	460000ef          	jal	ra,80000974 <WRITE_SERIAL>

    j .DONE
80000518:	0040006f          	j	8000051c <.DONE>

8000051c <.DONE>:

.DONE:
    // 交互循环
    j SHELL
8000051c:	cfdff06f          	j	80000218 <SHELL>
	...

80000600 <EXCEPTION_HANDLER>:
    .global EXCEPTION_HANDLER

#ifdef ENABLE_INT
EXCEPTION_HANDLER:
    // 交换 mscratch 和 sp ，保存上下文
    csrrw sp, mscratch, sp
80000600:	34011173          	csrrw	sp,mscratch,sp

    STORE ra, TF_ra(sp)
80000604:	00112023          	sw	ra,0(sp)
    // 读出原来的 sp
    csrrw ra, mscratch, sp
80000608:	340110f3          	csrrw	ra,mscratch,sp
    STORE ra, TF_sp(sp)
8000060c:	00112223          	sw	ra,4(sp)
    STORE gp, TF_gp(sp)
80000610:	00312423          	sw	gp,8(sp)
    STORE tp, TF_tp(sp)
80000614:	00412623          	sw	tp,12(sp)
    STORE t0, TF_t0(sp)
80000618:	00512823          	sw	t0,16(sp)
    STORE t1, TF_t1(sp)
8000061c:	00612a23          	sw	t1,20(sp)
    STORE t2, TF_t2(sp)
80000620:	00712c23          	sw	t2,24(sp)
    STORE s0, TF_s0(sp)
80000624:	00812e23          	sw	s0,28(sp)
    STORE s1, TF_s1(sp)
80000628:	02912023          	sw	s1,32(sp)
    STORE a0, TF_a0(sp)
8000062c:	02a12223          	sw	a0,36(sp)
    STORE a1, TF_a1(sp)
80000630:	02b12423          	sw	a1,40(sp)
    STORE a2, TF_a2(sp)
80000634:	02c12623          	sw	a2,44(sp)
    STORE a3, TF_a3(sp)
80000638:	02d12823          	sw	a3,48(sp)
    STORE a4, TF_a4(sp)
8000063c:	02e12a23          	sw	a4,52(sp)
    STORE a5, TF_a5(sp)
80000640:	02f12c23          	sw	a5,56(sp)
    STORE a6, TF_a6(sp)
80000644:	03012e23          	sw	a6,60(sp)
    STORE a7, TF_a7(sp)
80000648:	05112023          	sw	a7,64(sp)
    STORE s2, TF_s2(sp)
8000064c:	05212223          	sw	s2,68(sp)
    STORE s3, TF_s3(sp)
80000650:	05312423          	sw	s3,72(sp)
    STORE s4, TF_s4(sp)
80000654:	05412623          	sw	s4,76(sp)
    STORE s5, TF_s5(sp)
80000658:	05512823          	sw	s5,80(sp)
    STORE s6, TF_s6(sp)
8000065c:	05612a23          	sw	s6,84(sp)
    STORE s7, TF_s7(sp)
80000660:	05712c23          	sw	s7,88(sp)
    STORE s8, TF_s8(sp)
80000664:	05812e23          	sw	s8,92(sp)
    STORE s9, TF_s9(sp)
80000668:	07912023          	sw	s9,96(sp)
    STORE s10, TF_s10(sp)
8000066c:	07a12223          	sw	s10,100(sp)
    STORE s11, TF_s11(sp)
80000670:	07b12423          	sw	s11,104(sp)
    STORE t3, TF_t3(sp)
80000674:	07c12623          	sw	t3,108(sp)
    STORE t4, TF_t4(sp)
80000678:	07d12823          	sw	t4,112(sp)
    STORE t5, TF_t5(sp)
8000067c:	07e12a23          	sw	t5,116(sp)
    STORE t6, TF_t6(sp)
80000680:	07f12c23          	sw	t6,120(sp)
    csrr t0, mepc
80000684:	341022f3          	csrr	t0,mepc
    STORE t0, TF_epc(sp)
80000688:	06512e23          	sw	t0,124(sp)

    // 根据 mcause 调用不同的异常处理例程
    csrr t0, mcause
8000068c:	342022f3          	csrr	t0,mcause
    li t1, EX_INT_FLAG | EX_INT_MODE_MACHINE | EX_INT_TYPE_TIMER
80000690:	80000337          	lui	t1,0x80000
80000694:	00730313          	addi	t1,t1,7 # 80000007 <KERNEL_STACK_INIT+0xff800007>
    beq t1, t0, .HANDLE_TIMER
80000698:	04530a63          	beq	t1,t0,800006ec <.HANDLE_TIMER>
    li t1, EX_INT_FLAG
8000069c:	80000337          	lui	t1,0x80000
    and t1, t0, t1
800006a0:	0062f333          	and	t1,t0,t1
    bne t1, zero, .HANDLE_INT
800006a4:	04031263          	bnez	t1,800006e8 <.HANDLE_INT>
    li t1, EX_ECALL_U
800006a8:	00800313          	li	t1,8
    beq t1, t0, .HANDLE_ECALL
800006ac:	00530863          	beq	t1,t0,800006bc <.HANDLE_ECALL>
    li t1, EX_BREAK
800006b0:	00300313          	li	t1,3
    beq t1, t0, .HANDLE_BREAK
800006b4:	02530863          	beq	t1,t0,800006e4 <.HANDLE_BREAK>

    j FATAL
800006b8:	2480006f          	j	80000900 <FATAL>

800006bc <.HANDLE_ECALL>:

.HANDLE_ECALL:
    LOAD t0, TF_epc(sp)
800006bc:	07c12283          	lw	t0,124(sp)
    addi t0, t0, 0x4
800006c0:	00428293          	addi	t0,t0,4
    STORE t0, TF_epc(sp)
800006c4:	06512e23          	sw	t0,124(sp)

    LOAD t0, TF_s0(sp)
800006c8:	01c12283          	lw	t0,28(sp)
    li t1, SYS_putc
800006cc:	01e00313          	li	t1,30
    beq t0, t1, .HANDLE_ECALL_PUTC
800006d0:	00628463          	beq	t0,t1,800006d8 <.HANDLE_ECALL_PUTC>

    // 忽略其他系统调用
    j CONTEXT_SWITCH
800006d4:	0300006f          	j	80000704 <CONTEXT_SWITCH>

800006d8 <.HANDLE_ECALL_PUTC>:

.HANDLE_ECALL_PUTC:
    LOAD a0, TF_a0(sp)
800006d8:	02412503          	lw	a0,36(sp)
    jal WRITE_SERIAL
800006dc:	298000ef          	jal	ra,80000974 <WRITE_SERIAL>
    j CONTEXT_SWITCH
800006e0:	0240006f          	j	80000704 <CONTEXT_SWITCH>

800006e4 <.HANDLE_BREAK>:

.HANDLE_BREAK:
    j USERRET_MACHINE
800006e4:	d5dff06f          	j	80000440 <USERRET_MACHINE>

800006e8 <.HANDLE_INT>:

.HANDLE_INT:
    // 暂未实现
    j FATAL
800006e8:	2180006f          	j	80000900 <FATAL>

800006ec <.HANDLE_TIMER>:

.HANDLE_TIMER:
    // 读取 mstatus.MPP
    csrr t0, mstatus
800006ec:	300022f3          	csrr	t0,mstatus
    li t1, MSTATUS_MPP_MASK
800006f0:	00002337          	lui	t1,0x2
800006f4:	80030313          	addi	t1,t1,-2048 # 1800 <INITLOCATE-0x7fffe800>
    and t0, t0, t1
800006f8:	0062f2b3          	and	t0,t0,t1
    // 来自 M 态的中断，直接返回
    bne t0, zero, CONTEXT_SWITCH
800006fc:	00029463          	bnez	t0,80000704 <CONTEXT_SWITCH>

    // 处理用户程序超时
    j USERRET_TIMEOUT
80000700:	d35ff06f          	j	80000434 <USERRET_TIMEOUT>

80000704 <CONTEXT_SWITCH>:

CONTEXT_SWITCH:
    LOAD t0, TF_epc(sp)
80000704:	07c12283          	lw	t0,124(sp)
    csrw mepc, t0
80000708:	34129073          	csrw	mepc,t0

    LOAD ra, TF_ra(sp)
8000070c:	00012083          	lw	ra,0(sp)
    LOAD gp, TF_gp(sp)
80000710:	00812183          	lw	gp,8(sp)
    LOAD tp, TF_tp(sp)
80000714:	00c12203          	lw	tp,12(sp)
    LOAD t0, TF_t0(sp)
80000718:	01012283          	lw	t0,16(sp)
    LOAD t1, TF_t1(sp)
8000071c:	01412303          	lw	t1,20(sp)
    LOAD t2, TF_t2(sp)
80000720:	01812383          	lw	t2,24(sp)
    LOAD s0, TF_s0(sp)
80000724:	01c12403          	lw	s0,28(sp)
    LOAD s1, TF_s1(sp)
80000728:	02012483          	lw	s1,32(sp)
    LOAD a0, TF_a0(sp)
8000072c:	02412503          	lw	a0,36(sp)
    LOAD a1, TF_a1(sp)
80000730:	02812583          	lw	a1,40(sp)
    LOAD a2, TF_a2(sp)
80000734:	02c12603          	lw	a2,44(sp)
    LOAD a3, TF_a3(sp)
80000738:	03012683          	lw	a3,48(sp)
    LOAD a4, TF_a4(sp)
8000073c:	03412703          	lw	a4,52(sp)
    LOAD a5, TF_a5(sp)
80000740:	03812783          	lw	a5,56(sp)
    LOAD a6, TF_a6(sp)
80000744:	03c12803          	lw	a6,60(sp)
    LOAD a7, TF_a7(sp)
80000748:	04012883          	lw	a7,64(sp)
    LOAD s2, TF_s2(sp)
8000074c:	04412903          	lw	s2,68(sp)
    LOAD s3, TF_s3(sp)
80000750:	04812983          	lw	s3,72(sp)
    LOAD s4, TF_s4(sp)
80000754:	04c12a03          	lw	s4,76(sp)
    LOAD s5, TF_s5(sp)
80000758:	05012a83          	lw	s5,80(sp)
    LOAD s6, TF_s6(sp)
8000075c:	05412b03          	lw	s6,84(sp)
    LOAD s7, TF_s7(sp)
80000760:	05812b83          	lw	s7,88(sp)
    LOAD s8, TF_s8(sp)
80000764:	05c12c03          	lw	s8,92(sp)
    LOAD s9, TF_s9(sp)
80000768:	06012c83          	lw	s9,96(sp)
    LOAD s10, TF_s10(sp)
8000076c:	06412d03          	lw	s10,100(sp)
    LOAD s11, TF_s11(sp)
80000770:	06812d83          	lw	s11,104(sp)
    LOAD t3, TF_t3(sp)
80000774:	06c12e03          	lw	t3,108(sp)
    LOAD t4, TF_t4(sp)
80000778:	07012e83          	lw	t4,112(sp)
    LOAD t5, TF_t5(sp)
8000077c:	07412f03          	lw	t5,116(sp)
    LOAD t6, TF_t6(sp)
80000780:	07812f83          	lw	t6,120(sp)
    
    csrw mscratch, sp
80000784:	34011073          	csrw	mscratch,sp
    LOAD sp, TF_sp(sp)
80000788:	00412103          	lw	sp,4(sp)

    mret
8000078c:	30200073          	mret
80000790:	00000013          	nop
80000794:	00000013          	nop
80000798:	00000013          	nop
8000079c:	00000013          	nop
800007a0:	00000013          	nop
800007a4:	00000013          	nop
800007a8:	00000013          	nop
800007ac:	00000013          	nop
800007b0:	00000013          	nop
800007b4:	00000013          	nop
800007b8:	00000013          	nop
800007bc:	00000013          	nop
800007c0:	00000013          	nop
800007c4:	00000013          	nop
800007c8:	00000013          	nop
800007cc:	00000013          	nop
800007d0:	00000013          	nop
800007d4:	00000013          	nop
800007d8:	00000013          	nop
800007dc:	00000013          	nop
800007e0:	00000013          	nop
800007e4:	00000013          	nop
800007e8:	00000013          	nop
800007ec:	00000013          	nop
800007f0:	00000013          	nop
800007f4:	00000013          	nop
800007f8:	00000013          	nop
800007fc:	00000013          	nop

80000800 <VECTORED_EXCEPTION_HANDLER>:
    .balign 256
    .global VECTORED_EXCEPTION_HANDLER
VECTORED_EXCEPTION_HANDLER:
    .rept 64
    j EXCEPTION_HANDLER
    .endr
80000800:	e01ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000804:	dfdff06f          	j	80000600 <EXCEPTION_HANDLER>
80000808:	df9ff06f          	j	80000600 <EXCEPTION_HANDLER>
8000080c:	df5ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000810:	df1ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000814:	dedff06f          	j	80000600 <EXCEPTION_HANDLER>
80000818:	de9ff06f          	j	80000600 <EXCEPTION_HANDLER>
8000081c:	de5ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000820:	de1ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000824:	dddff06f          	j	80000600 <EXCEPTION_HANDLER>
80000828:	dd9ff06f          	j	80000600 <EXCEPTION_HANDLER>
8000082c:	dd5ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000830:	dd1ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000834:	dcdff06f          	j	80000600 <EXCEPTION_HANDLER>
80000838:	dc9ff06f          	j	80000600 <EXCEPTION_HANDLER>
8000083c:	dc5ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000840:	dc1ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000844:	dbdff06f          	j	80000600 <EXCEPTION_HANDLER>
80000848:	db9ff06f          	j	80000600 <EXCEPTION_HANDLER>
8000084c:	db5ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000850:	db1ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000854:	dadff06f          	j	80000600 <EXCEPTION_HANDLER>
80000858:	da9ff06f          	j	80000600 <EXCEPTION_HANDLER>
8000085c:	da5ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000860:	da1ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000864:	d9dff06f          	j	80000600 <EXCEPTION_HANDLER>
80000868:	d99ff06f          	j	80000600 <EXCEPTION_HANDLER>
8000086c:	d95ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000870:	d91ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000874:	d8dff06f          	j	80000600 <EXCEPTION_HANDLER>
80000878:	d89ff06f          	j	80000600 <EXCEPTION_HANDLER>
8000087c:	d85ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000880:	d81ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000884:	d7dff06f          	j	80000600 <EXCEPTION_HANDLER>
80000888:	d79ff06f          	j	80000600 <EXCEPTION_HANDLER>
8000088c:	d75ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000890:	d71ff06f          	j	80000600 <EXCEPTION_HANDLER>
80000894:	d6dff06f          	j	80000600 <EXCEPTION_HANDLER>
80000898:	d69ff06f          	j	80000600 <EXCEPTION_HANDLER>
8000089c:	d65ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008a0:	d61ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008a4:	d5dff06f          	j	80000600 <EXCEPTION_HANDLER>
800008a8:	d59ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008ac:	d55ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008b0:	d51ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008b4:	d4dff06f          	j	80000600 <EXCEPTION_HANDLER>
800008b8:	d49ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008bc:	d45ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008c0:	d41ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008c4:	d3dff06f          	j	80000600 <EXCEPTION_HANDLER>
800008c8:	d39ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008cc:	d35ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008d0:	d31ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008d4:	d2dff06f          	j	80000600 <EXCEPTION_HANDLER>
800008d8:	d29ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008dc:	d25ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008e0:	d21ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008e4:	d1dff06f          	j	80000600 <EXCEPTION_HANDLER>
800008e8:	d19ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008ec:	d15ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008f0:	d11ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008f4:	d0dff06f          	j	80000600 <EXCEPTION_HANDLER>
800008f8:	d09ff06f          	j	80000600 <EXCEPTION_HANDLER>
800008fc:	d05ff06f          	j	80000600 <EXCEPTION_HANDLER>

80000900 <FATAL>:
#endif

FATAL:
    // 严重问题，重启
    // 错误信号
    li a0, SIG_FATAL
80000900:	08000513          	li	a0,128
    // 发送
    jal WRITE_SERIAL
80000904:	070000ef          	jal	ra,80000974 <WRITE_SERIAL>

#ifdef ENABLE_INT
    csrrs a0, mepc, zero
80000908:	34102573          	csrr	a0,mepc
    jal WRITE_SERIAL_XLEN
8000090c:	0d4000ef          	jal	ra,800009e0 <WRITE_SERIAL_XLEN>
    csrrs a0, mcause, zero
80000910:	34202573          	csrr	a0,mcause
    jal WRITE_SERIAL_XLEN
80000914:	0cc000ef          	jal	ra,800009e0 <WRITE_SERIAL_XLEN>
    csrrs a0, mtval, zero
80000918:	34302573          	csrr	a0,mtval
    jal WRITE_SERIAL_XLEN
8000091c:	0c4000ef          	jal	ra,800009e0 <WRITE_SERIAL_XLEN>
    jal WRITE_SERIAL_XLEN
    jal WRITE_SERIAL_XLEN
#endif

    // 重启地址
    la a0, START
80000920:	fffff517          	auipc	a0,0xfffff
80000924:	6ec50513          	addi	a0,a0,1772 # 8000000c <START>
    jr a0
80000928:	00050067          	jr	a0
	...

80000974 <WRITE_SERIAL>:
    .global READ_SERIAL
    .global READ_SERIAL_WORD
    .global READ_SERIAL_XLEN

WRITE_SERIAL:                       // 写串口：将a0的低八位写入串口
    li t0, COM1
80000974:	100002b7          	lui	t0,0x10000

80000978 <.TESTW>:
.TESTW:
    lb t1, %lo(COM_LSR_OFFSET)(t0)  // 查看串口状态
80000978:	00528303          	lb	t1,5(t0) # 10000005 <INITLOCATE-0x6ffffffb>
    andi t1, t1, COM_LSR_THRE       // 截取写状态位
8000097c:	02037313          	andi	t1,t1,32
    bne t1, zero, .WSERIAL          // 状态位非零可写进入写
80000980:	00031463          	bnez	t1,80000988 <.WSERIAL>
    j .TESTW                        // 检测验证，忙等待
80000984:	ff5ff06f          	j	80000978 <.TESTW>

80000988 <.WSERIAL>:
.WSERIAL:
    sb a0, %lo(COM_THR_OFFSET)(t0)  // 写入寄存器a0中的值
80000988:	00a28023          	sb	a0,0(t0)
    jr ra
8000098c:	00008067          	ret

80000990 <WRITE_SERIAL_WORD>:

WRITE_SERIAL_WORD:
    addi sp, sp, -2*XLEN
80000990:	ff810113          	addi	sp,sp,-8
    STORE ra, 0x0(sp)
80000994:	00112023          	sw	ra,0(sp)
    STORE s0, XLEN(sp)
80000998:	00812223          	sw	s0,4(sp)

    mv s0, a0
8000099c:	00050413          	mv	s0,a0

    andi a0, a0, 0xFF
800009a0:	0ff57513          	andi	a0,a0,255
    jal WRITE_SERIAL
800009a4:	fd1ff0ef          	jal	ra,80000974 <WRITE_SERIAL>
    srli a0, s0, 8
800009a8:	00845513          	srli	a0,s0,0x8

    andi a0, a0, 0xFF
800009ac:	0ff57513          	andi	a0,a0,255
    jal WRITE_SERIAL
800009b0:	fc5ff0ef          	jal	ra,80000974 <WRITE_SERIAL>
    srli a0, s0, 16
800009b4:	01045513          	srli	a0,s0,0x10

    andi a0, a0, 0xFF
800009b8:	0ff57513          	andi	a0,a0,255
    jal WRITE_SERIAL
800009bc:	fb9ff0ef          	jal	ra,80000974 <WRITE_SERIAL>
    srli a0, s0, 24
800009c0:	01845513          	srli	a0,s0,0x18

    andi a0, a0, 0xFF
800009c4:	0ff57513          	andi	a0,a0,255
    jal WRITE_SERIAL
800009c8:	fadff0ef          	jal	ra,80000974 <WRITE_SERIAL>
    mv a0, s0
800009cc:	00040513          	mv	a0,s0

    LOAD ra, 0x0(sp)
800009d0:	00012083          	lw	ra,0(sp)
    LOAD s0, XLEN(sp)
800009d4:	00412403          	lw	s0,4(sp)
    addi sp, sp, 2*XLEN
800009d8:	00810113          	addi	sp,sp,8

    jr ra
800009dc:	00008067          	ret

800009e0 <WRITE_SERIAL_XLEN>:

WRITE_SERIAL_XLEN:
    addi sp, sp, -XLEN
800009e0:	ffc10113          	addi	sp,sp,-4
    STORE ra, 0x0(sp)
800009e4:	00112023          	sw	ra,0(sp)

    jal WRITE_SERIAL_WORD
800009e8:	fa9ff0ef          	jal	ra,80000990 <WRITE_SERIAL_WORD>
#ifdef RV64
    srli a0, a0, 32
    jal WRITE_SERIAL_WORD
#endif
    LOAD ra, 0x0(sp)
800009ec:	00012083          	lw	ra,0(sp)
    addi sp, sp, XLEN
800009f0:	00410113          	addi	sp,sp,4

    jr ra
800009f4:	00008067          	ret

800009f8 <WRITE_SERIAL_STRING>:

WRITE_SERIAL_STRING:                // 写字符串：将 a0 地址开始处的字符串写入串口
    mv a1, a0
800009f8:	00050593          	mv	a1,a0
    mv a2, ra
800009fc:	00008613          	mv	a2,ra
    lb a0, 0(a1)
80000a00:	00058503          	lb	a0,0(a1)
0:  jal WRITE_SERIAL                // 调用串口写函数
80000a04:	f71ff0ef          	jal	ra,80000974 <WRITE_SERIAL>
    addi a1, a1, 0x1
80000a08:	00158593          	addi	a1,a1,1
    lb a0, 0(a1)
80000a0c:	00058503          	lb	a0,0(a1)
    bne a0, zero, 0b                // 打印循环至 0 结束符
80000a10:	fe051ae3          	bnez	a0,80000a04 <WRITE_SERIAL_STRING+0xc>
    jr a2
80000a14:	00060067          	jr	a2

80000a18 <READ_SERIAL>:

READ_SERIAL:                        // 读串口：将读到的数据写入a0低八位
    li t0, COM1
80000a18:	100002b7          	lui	t0,0x10000

80000a1c <.TESTR>:
.TESTR:
    lb t1, %lo(COM_LSR_OFFSET)(t0)
80000a1c:	00528303          	lb	t1,5(t0) # 10000005 <INITLOCATE-0x6ffffffb>
    andi t1, t1, COM_LSR_DR         // 截取读状态位
80000a20:	00137313          	andi	t1,t1,1
    bne t1, zero, .RSERIAL          // 状态位非零可读进入读
80000a24:	00031463          	bnez	t1,80000a2c <.RSERIAL>
    j .TESTR                        // 检测验证
80000a28:	ff5ff06f          	j	80000a1c <.TESTR>

80000a2c <.RSERIAL>:
.RSERIAL:
    lb a0, %lo(COM_RBR_OFFSET)(t0)
80000a2c:	00028503          	lb	a0,0(t0)
    jr ra
80000a30:	00008067          	ret

80000a34 <READ_SERIAL_WORD>:

READ_SERIAL_WORD:
    addi sp, sp, -5*XLEN             // 保存ra,s0-3
80000a34:	fec10113          	addi	sp,sp,-20
    STORE ra, 0x0(sp)
80000a38:	00112023          	sw	ra,0(sp)
    STORE s0, XLEN(sp)
80000a3c:	00812223          	sw	s0,4(sp)
    STORE s1, 2*XLEN(sp)
80000a40:	00912423          	sw	s1,8(sp)
    STORE s2, 3*XLEN(sp)
80000a44:	01212623          	sw	s2,12(sp)
    STORE s3, 4*XLEN(sp)
80000a48:	01312823          	sw	s3,16(sp)

    jal READ_SERIAL                 // 读串口获得八个比特
80000a4c:	fcdff0ef          	jal	ra,80000a18 <READ_SERIAL>
    or s0, zero, a0                 // 结果存入s0
80000a50:	00a06433          	or	s0,zero,a0
    jal READ_SERIAL                 // 读串口获得八个比特
80000a54:	fc5ff0ef          	jal	ra,80000a18 <READ_SERIAL>
    or s1, zero, a0                 // 结果存入s1
80000a58:	00a064b3          	or	s1,zero,a0
    jal READ_SERIAL                 // 读串口获得八个比特
80000a5c:	fbdff0ef          	jal	ra,80000a18 <READ_SERIAL>
    or s2, zero, a0                 // 结果存入s2
80000a60:	00a06933          	or	s2,zero,a0
    jal READ_SERIAL                 // 读串口获得八个比特
80000a64:	fb5ff0ef          	jal	ra,80000a18 <READ_SERIAL>
    or s3, zero, a0                 // 结果存入s3
80000a68:	00a069b3          	or	s3,zero,a0

    andi s0, s0, 0x00FF             // 截取低八位
80000a6c:	0ff47413          	andi	s0,s0,255
    andi s1, s1, 0x00FF
80000a70:	0ff4f493          	andi	s1,s1,255
    andi s2, s2, 0x00FF
80000a74:	0ff97913          	andi	s2,s2,255
    andi s3, s3, 0x00FF
80000a78:	0ff9f993          	andi	s3,s3,255
    or a0, zero, s3                 // 存高八位
80000a7c:	01306533          	or	a0,zero,s3
    sll a0, a0, 8                   // 左移
80000a80:	00851513          	slli	a0,a0,0x8
    or a0, a0, s2                   // 存八位
80000a84:	01256533          	or	a0,a0,s2
    sll a0, a0, 8                   // 左移
80000a88:	00851513          	slli	a0,a0,0x8
    or a0, a0, s1                   // 存八位
80000a8c:	00956533          	or	a0,a0,s1
    sll a0, a0, 8                   // 左移
80000a90:	00851513          	slli	a0,a0,0x8
    or a0, a0, s0                   // 存低八位
80000a94:	00856533          	or	a0,a0,s0

    LOAD ra, 0x0(sp)                // 恢复ra,s0
80000a98:	00012083          	lw	ra,0(sp)
    LOAD s0, XLEN(sp)
80000a9c:	00412403          	lw	s0,4(sp)
    LOAD s1, 2*XLEN(sp)
80000aa0:	00812483          	lw	s1,8(sp)
    LOAD s2, 3*XLEN(sp)
80000aa4:	00c12903          	lw	s2,12(sp)
    LOAD s3, 4*XLEN(sp)
80000aa8:	01012983          	lw	s3,16(sp)
    addi sp, sp, 5*XLEN
80000aac:	01410113          	addi	sp,sp,20
    jr ra
80000ab0:	00008067          	ret

80000ab4 <READ_SERIAL_XLEN>:

READ_SERIAL_XLEN:
    addi sp, sp, -2*XLEN             // 保存ra,s0-3
80000ab4:	ff810113          	addi	sp,sp,-8
    STORE ra, 0x0(sp)
80000ab8:	00112023          	sw	ra,0(sp)
    STORE s0, XLEN(sp)
80000abc:	00812223          	sw	s0,4(sp)

    jal READ_SERIAL_WORD
80000ac0:	f75ff0ef          	jal	ra,80000a34 <READ_SERIAL_WORD>
    mv s0, a0
80000ac4:	00050413          	mv	s0,a0
#ifdef RV64
    jal READ_SERIAL_WORD
    sll a0, a0, 32
    add s0, s0, a0
#endif
    mv a0, s0
80000ac8:	00040513          	mv	a0,s0
    LOAD ra, 0x0(sp)                // 恢复ra,s0
80000acc:	00012083          	lw	ra,0(sp)
    LOAD s0, XLEN(sp)
80000ad0:	00412403          	lw	s0,4(sp)
    addi sp, sp, 2*XLEN
80000ad4:	00810113          	addi	sp,sp,8
    jr ra
80000ad8:	00008067          	ret
	...

80001000 <UTEST_SIMPLE>:

    .section .text.utest
    .p2align 2

UTEST_SIMPLE:
    addi t5, t5, 0x1
80001000:	001f0f13          	addi	t5,t5,1
    jr ra
80001004:	00008067          	ret

80001008 <UTEST_1PTB>:
    /*  性能标定程序(1)
     *  这段程序一般没有数据冲突和结构冲突，可作为性能标定。
     *  执行这段程序需至少 320M 指令
     */
UTEST_1PTB:
    li t0, TESTLOOP64         // 装入 64M
80001008:	040002b7          	lui	t0,0x4000
.LC0:
    addi t0, t0, -1                // 滚动计数器
8000100c:	fff28293          	addi	t0,t0,-1 # 3ffffff <INITLOCATE-0x7c000001>
    li t1, 0
80001010:	00000313          	li	t1,0
    li t2, 1
80001014:	00100393          	li	t2,1
    li t3, 2
80001018:	00200e13          	li	t3,2
    bne t0, zero, .LC0
8000101c:	fe0298e3          	bnez	t0,8000100c <UTEST_1PTB+0x4>
    jr ra
80001020:	00008067          	ret

80001024 <UTEST_2DCT>:
    /*  运算数据冲突的效率测试(2)
     *  这段程序含有大量数据冲突，可测试数据冲突对效率的影响。
     *  执行这段程序需至少 176M 指令。
     */
UTEST_2DCT:
    lui t0, %hi(TESTLOOP16)         // 装入16M
80001024:	010002b7          	lui	t0,0x1000
    li t1, 1
80001028:	00100313          	li	t1,1
    li t2, 2
8000102c:	00200393          	li	t2,2
    li t3, 3
80001030:	00300e13          	li	t3,3
.LC1:
    xor t2, t2, t1                  // 交换t1,t2
80001034:	0063c3b3          	xor	t2,t2,t1
    xor t1, t1, t2
80001038:	00734333          	xor	t1,t1,t2
    xor t2, t2, t1
8000103c:	0063c3b3          	xor	t2,t2,t1
    xor t3, t3, t2                  // 交换t2,t3
80001040:	007e4e33          	xor	t3,t3,t2
    xor t2, t2, t3
80001044:	01c3c3b3          	xor	t2,t2,t3
    xor t3, t3, t2
80001048:	007e4e33          	xor	t3,t3,t2
    xor t1, t1, t3                  // 交换t3,t1
8000104c:	01c34333          	xor	t1,t1,t3
    xor t3, t3, t1
80001050:	006e4e33          	xor	t3,t3,t1
    xor t1, t1, t3
80001054:	01c34333          	xor	t1,t1,t3
    addi t0, t0, -1
80001058:	fff28293          	addi	t0,t0,-1 # ffffff <INITLOCATE-0x7f000001>
    bne t0, zero, .LC1
8000105c:	fc029ce3          	bnez	t0,80001034 <UTEST_2DCT+0x10>
    jr ra
80001060:	00008067          	ret

80001064 <UTEST_3CCT>:
    /*  控制指令冲突测试(3)
     *  这段程序有大量控制冲突。
     *  执行需要至少 256M 指令。
     */
UTEST_3CCT:
    lui t0, %hi(TESTLOOP64)         // 装入64M
80001064:	040002b7          	lui	t0,0x4000
.LC2_0:
    bne t0, zero, .LC2_1
80001068:	00029463          	bnez	t0,80001070 <UTEST_3CCT+0xc>
    jr ra
8000106c:	00008067          	ret
.LC2_1:
    j .LC2_2
80001070:	0040006f          	j	80001074 <UTEST_3CCT+0x10>
.LC2_2:
    addi t0, t0, -1
80001074:	fff28293          	addi	t0,t0,-1 # 3ffffff <INITLOCATE-0x7c000001>
    j .LC2_0
80001078:	ff1ff06f          	j	80001068 <UTEST_3CCT+0x4>
    addi t0, t0, -1
8000107c:	fff28293          	addi	t0,t0,-1

80001080 <UTEST_4MDCT>:
    /*  访存相关数据冲突测试(4)
     *  这段程序反复对内存进行有数据冲突的读写。
     *  需要至少执行 192M 指令。
     */
UTEST_4MDCT:
    lui t0, %hi(TESTLOOP32)          // 装入32M
80001080:	020002b7          	lui	t0,0x2000
    addi sp, sp, -4
80001084:	ffc10113          	addi	sp,sp,-4
.LC3:
    sw t0, 0(sp)
80001088:	00512023          	sw	t0,0(sp)
    lw t1, 0(sp)
8000108c:	00012303          	lw	t1,0(sp)
    addi t1, t1, -1
80001090:	fff30313          	addi	t1,t1,-1
    sw t1, 0(sp)
80001094:	00612023          	sw	t1,0(sp)
    lw t0, 0(sp)
80001098:	00012283          	lw	t0,0(sp)
    bne t0, zero, .LC3
8000109c:	fe0296e3          	bnez	t0,80001088 <UTEST_4MDCT+0x8>

    addi sp, sp, 4
800010a0:	00410113          	addi	sp,sp,4
    jr ra
800010a4:	00008067          	ret

800010a8 <UTEST_PUTC>:

#ifdef ENABLE_INT
UTEST_PUTC:
    li s0, SYS_putc
800010a8:	01e00413          	li	s0,30
    li a0, 0x4F              // 'O'
800010ac:	04f00513          	li	a0,79
    ecall
800010b0:	00000073          	ecall
    li a0, 0x4B              // 'K'
800010b4:	04b00513          	li	a0,75
    ecall
800010b8:	00000073          	ecall
    jr ra
800010bc:	00008067          	ret

800010c0 <UTEST_SPIN>:

UTEST_SPIN:
    j UTEST_SPIN
800010c0:	0000006f          	j	800010c0 <UTEST_SPIN>

800010c4 <UTEST_CRYPTONIGHT>:
#endif

UTEST_CRYPTONIGHT:
#ifdef ENABLE_PAGING
    li a0, 0x7FC10000
800010c4:	7fc10537          	lui	a0,0x7fc10
#else
    li a0, 0x80400000 // base addr
#endif
    li a1, 0x200000 // 2M bytes
800010c8:	002005b7          	lui	a1,0x200
    li a3, 524288 // number of iterations
800010cc:	000806b7          	lui	a3,0x80
    li a4, 0x1FFFFC // 2M mask
800010d0:	00200737          	lui	a4,0x200
800010d4:	ffc70713          	addi	a4,a4,-4 # 1ffffc <INITLOCATE-0x7fe00004>
    add a1, a1, a0 // end addr
800010d8:	00a585b3          	add	a1,a1,a0
    li s0, 1 // rand number
800010dc:	00100413          	li	s0,1

    mv a2, a0
800010e0:	00050613          	mv	a2,a0

800010e4 <.INIT_LOOP>:
.INIT_LOOP:
    sw s0, 0(a2)
800010e4:	00862023          	sw	s0,0(a2)

    // xorshift lfsr
    slli s1, s0, 13
800010e8:	00d41493          	slli	s1,s0,0xd
    xor s0, s0, s1
800010ec:	00944433          	xor	s0,s0,s1
    srli s1, s0, 17
800010f0:	01145493          	srli	s1,s0,0x11
    xor s0, s0, s1
800010f4:	00944433          	xor	s0,s0,s1
    slli s1, s0, 5
800010f8:	00541493          	slli	s1,s0,0x5
    xor s0, s0, s1
800010fc:	00944433          	xor	s0,s0,s1

    addi a2, a2, 4
80001100:	00460613          	addi	a2,a2,4
    bne a2, a1, .INIT_LOOP
80001104:	feb610e3          	bne	a2,a1,800010e4 <.INIT_LOOP>

    li a2, 0
80001108:	00000613          	li	a2,0
    li t0, 0
8000110c:	00000293          	li	t0,0

80001110 <.MAIN_LOOP>:
.MAIN_LOOP:
    // calculate a valid addr from rand number
    and t0, s0, a4
80001110:	00e472b3          	and	t0,s0,a4
    add t0, a0, t0
80001114:	005502b3          	add	t0,a0,t0
    // read from it
    lw t0, 0(t0)
80001118:	0002a283          	lw	t0,0(t0) # 2000000 <INITLOCATE-0x7e000000>
    // xor with last iteration's t0
    xor t0, t0, t1
8000111c:	0062c2b3          	xor	t0,t0,t1
    // xor rand number with current t0
    xor s0, s0, t0
80001120:	00544433          	xor	s0,s0,t0

    // get new rand number from xorshift lfsr
    slli s1, s0, 13
80001124:	00d41493          	slli	s1,s0,0xd
    xor s0, s0, s1
80001128:	00944433          	xor	s0,s0,s1
    srli s1, s0, 17
8000112c:	01145493          	srli	s1,s0,0x11
    xor s0, s0, s1
80001130:	00944433          	xor	s0,s0,s1
    slli s1, s0, 5
80001134:	00541493          	slli	s1,s0,0x5
    xor s0, s0, s1
80001138:	00944433          	xor	s0,s0,s1

    // calculate a valid addr from new rand number
    and t1, s0, a4
8000113c:	00e47333          	and	t1,s0,a4
    add t1, a0, t1
80001140:	00650333          	add	t1,a0,t1
    // write t0 to this addr
    sw t0, 0(t1)
80001144:	00532023          	sw	t0,0(t1)
    // save t0 for next iteration
    mv t1, t0
80001148:	00028313          	mv	t1,t0

    // get new rand number from xorshift lfsr
    slli s1, s0, 13
8000114c:	00d41493          	slli	s1,s0,0xd
    xor s0, s0, s1
80001150:	00944433          	xor	s0,s0,s1
    srli s1, s0, 17
80001154:	01145493          	srli	s1,s0,0x11
    xor s0, s0, s1
80001158:	00944433          	xor	s0,s0,s1
    slli s1, s0, 5
8000115c:	00541493          	slli	s1,s0,0x5
    xor s0, s0, s1
80001160:	00944433          	xor	s0,s0,s1

    add a2, a2, 1
80001164:	00160613          	addi	a2,a2,1
    bne a2, a3, .MAIN_LOOP
80001168:	fad614e3          	bne	a2,a3,80001110 <.MAIN_LOOP>

    jr ra
8000116c:	00008067          	ret
