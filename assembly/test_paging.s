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
    ret