    addi t0, zero, 0     # loop variable 8000_0000
    addi t1, zero, 100   # loop upper bound 8000_0004
    addi t2, zero, 0     # sum 8000_0008 
loop:
    addi t0, t0, 1 # 8000_000C 1+1=2
    add t2, t0, t2 # 8000_0010 2+1=3
    beq t0, t1, next # i == 100? 8000_0014
    beq zero, zero, loop # 8000_0018

next:   
    # store result
    lui t0, 0x80000  # base ram address 8000_001C
    sw t2, 0x100(t0) # 8000_0020

    lui t0, 0x10000  # serial address 8000_0024
.TESTW1:
    lb t1, 5(t0)   # 8000_0028
    andi t1, t1, 0x20 # 8000_002C
    beq t1, zero, .TESTW1 # 8000_0030
    # do not write when serial is in used

    addi a0, zero, 'd' # 8000_0034
    sb a0, 0(t0) # 8000_0038

.TESTW2:
    lb t1, 5(t0) # 8000_003C
    andi t1, t1, 0x20 # 8000_0040
    beq t1, zero, .TESTW2 # 8000_0044

    addi a0, zero, 'o' # 8000_0048
    sb a0, 0(t0) # 8000_004C

.TESTW3:
    lb t1, 5(t0) # 8000_0050
    andi t1, t1, 0x20 # 8000_0054
    beq t1, zero, .TESTW3 # 8000_0058

    addi a0, zero, 'n' # 8000_005C
    sb a0, 0(t0) # 8000_0060

.TESTW4:
    lb t1, 5(t0) # 8000_0064
    andi t1, t1, 0x20 # 8000_0068
    beq t1, zero, .TESTW4 # 8000_006C

    addi a0, zero, 'e' # 8000_0070
    sb a0, 0(t0) # 8000_0074

.TESTW5:
    lb t1, 5(t0) # 8000_0078
    andi t1, t1, 0x20 # 8000_007C
    beq t1, zero, .TESTW5 # 8000_0080

    addi a0, zero, '!' # 8000_0084
    sb a0, 0(t0) # 8000_0088

end:
    beq zero, zero, end # 8000_008C
    # loop forever, let pc under control