.global Draw_score
.global Draw_score2
.global SCORE
.global clear_hit
Draw_score:
	addi sp, sp, -56
	stw ra, 4(sp)
	stw r4, 16(sp)
	stw r5, 20(sp)
	stw r6, 24(sp)
	stw r7, 28(sp)
	stw r8, 32(sp)
	stw r9, 36(sp)
	stw r10, 40(sp)
	stw r11, 44(sp)
	stw r12, 48(sp)
	stw r13, 52(sp)
	stw r14, 56(sp)
	mov r9,r0
	movia r8, 0x09000000
	movia r13, SCORE
	ldwio r12,0(r13)

	movia r14,10

blt r12,r14,decimal_zero
subi r12,r12,10
blt r12,r14,decimal_one
subi r12,r12,10
blt r12,r14,decimal_two
subi r12,r12,10
blt r12,r14,decimal_three
subi r12,r12,10
blt r12,r14,decimal_four
subi r12,r12,10
blt r12,r14,decimal_five
subi r12,r12,10
blt r12,r14,decimal_six
subi r12,r12,10
blt r12,r14,decimal_seven
subi r12,r12,10
blt r12,r14,decimal_eight
subi r12,r12,10
blt r12,r14,decimal_nine
br Done

decimal_zero:
	movia r4,0
	call number_to_ascii
	mov r7,r5
	br second
decimal_one:
	movia r4,1
	call number_to_ascii
	mov r7,r5
	br second
decimal_two:
	movia r4,2
	call number_to_ascii
	mov r7,r5
	br second
decimal_three:
	movia r4,3
	call number_to_ascii
	mov r7,r5
	br second
decimal_four:
	movia r4,4
	call number_to_ascii
	mov r7,r5
	br second
decimal_five:
	movia r4,5
	call number_to_ascii
	mov r7,r5
	br second
decimal_six:
	movia r4,6
	call number_to_ascii
	mov r7,r5
	br second
decimal_seven:
	movia r4,7
	call number_to_ascii
	mov r7,r5
	br second
decimal_eight:
	movia r4,8
	call number_to_ascii
	mov r7,r5
	br second
decimal_nine:
	movia r4,9
	call number_to_ascii
	mov r7,r5
	br second

second:
	mov r4,r12
	call number_to_ascii
	mov r6,r5
	beq r9,r0,print_score
	br print_score2
	
print_score:
	
	stbio r6,841(r8) 
	stbio r7,839(r8) 
	br Done
	
Done:
	
	#epilogue
	ldw ra, 4(sp)
	ldw r4, 16(sp)
	ldw r5, 20(sp)
	ldw r6, 24(sp)
	ldw r7, 28(sp)
	ldw r8, 32(sp)
	ldw r9, 36(sp)
	ldw r10, 40(sp)
	ldw r11, 44(sp)
	ldw r12, 48(sp)
	ldw r13, 52(sp)
	ldw r14, 56(sp)
	
  	addi sp, sp, 56
	
ret
	
number_to_ascii:

	movi r5,0
	beq r4,r5,Print0
	addi r5,r5,1
	beq r4,r5,Print1
	addi r5,r5,1
	beq r4,r5,Print2
	addi r5,r5,1
	beq r4,r5,Print3
	addi r5,r5,1
	beq r4,r5,Print4
	addi r5,r5,1
	beq r4,r5,Print5
	addi r5,r5,1
	beq r4,r5,Print6
	addi r5,r5,1
	beq r4,r5,Print7
	addi r5,r5,1
	beq r4,r5,Print8
	addi r5,r5,1
	beq r4,r5,Print9
	br Print0
	
Print0: 
  movi  r5, 0x30
  ret
Print1: 
  movi  r5, 0x31
  ret
 Print2: 
  movi  r5, 0x32
  ret
Print3: 
  movi  r5, 0x33
  ret
Print4: 
  movi  r5, 0x34
  ret
Print5: 
  movi  r5, 0x35
  ret
Print6: 
  movi  r5, 0x36
  ret
Print7: 
  movi  r5, 0x37
  ret
Print8: 
  movi  r5, 0x38
  ret
Print9: 
  movi  r5, 0x39
  ret
  
  
  
 
Draw_score2:
	addi sp, sp, -56
	stw ra, 4(sp)
	stw r4, 16(sp)
	stw r5, 20(sp)
	stw r6, 24(sp)
	stw r7, 28(sp)
	stw r8, 32(sp)
	stw r9, 36(sp)
	stw r10, 40(sp)
	stw r11, 44(sp)
	stw r12, 48(sp)
	stw r13, 52(sp)
	stw r14, 56(sp)
	movia r9,1
	movia r8, 0x09000000
	movia r13, SCORE

	ldwio r12,0(r13)

	movia r14,10

blt r12,r14,decimal_zero
subi r12,r12,10
blt r12,r14,decimal_one
subi r12,r12,10
blt r12,r14,decimal_two
subi r12,r12,10
blt r12,r14,decimal_three
subi r12,r12,10
blt r12,r14,decimal_four
subi r12,r12,10
blt r12,r14,decimal_five
subi r12,r12,10
blt r12,r14,decimal_six
subi r12,r12,10
blt r12,r14,decimal_seven
subi r12,r12,10
blt r12,r14,decimal_eight
subi r12,r12,10
blt r12,r14,decimal_nine
br Done

print_score2:
	stbio r6,3881(r8) 
	stbio r7,3879(r8) 
	br Done


clear_hit:
addi sp,sp,-8
stw ra,0(sp)
stw r6,4(sp)
stw r8,8(sp)
	movia r8, 0x09000000
	movi r6,0x20 # space
	stbio r6,132(r8) 
	stbio r6,133(r8) 
	stbio r6,134(r8) 
	stbio r6,135(r8) 
	stbio r6,136(r8) 

ldw ra,0(sp)
ldw r6,4(sp)
ldw r8,8(sp)
addi sp,sp,8
	ret


