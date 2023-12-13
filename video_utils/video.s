li t0, 480000
li t1, 120 # frames

start:
    addi t2, x0, 0 # 记录帧数
    li t5, 0x80400000 # ExtRAM

frames:
    addi t3, x0, 0 # 像素
    li t4, 0x01000000 # BRAM

pixels:
    lb t6, (t5) # load from ExtRAM
    sb t6, (t4) # store to BRAM
    addi t4, t4, 1 # t4 = t4 + 1
    addi t5, t5, 1
    addi t3, t3, 16
    beq t3, t0, next # 开始新的一帧
    j pixels

next:
    addi t2, t2, 1 
    beq t2, t1, start # 重新放一边
    j frames
