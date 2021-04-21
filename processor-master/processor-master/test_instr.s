#Save the current progress count in one register, and total number of notes in another,
#, use these two for ending branch condition.
#jump1:
#bne $r4,$r5,jump2
#j jump1
#jump2:
#addi $r3,$r3,10
#addi $r4,$r4,1
#j jump1
nop
nop
nop
nop
nop
jump1:
nop
nop
nop
nop
nop
bne $r4, $r5, jump2
nop
nop
nop
nop
nop
j jump1
jump2:
nop
nop
nop
nop
nop
addi $r3, $r3, 10
nop
nop
nop
nop
nop
addi $r4, $r4, 1
nop
nop
nop
nop
nop
j jump1


