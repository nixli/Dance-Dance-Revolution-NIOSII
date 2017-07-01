.global sensor_init
.global sensor0_exp
.global sensor1_exp
.equ ADDR_JP2, 0xFF200070     # address GPIO JP2
.equ ADDR_JP2_IRQ, 0x1000      # IRQ line for GPIO JP2 (IRQ12) 
.equ ADDR_JP2_Edge, 0xFF20007C      # address Edge Capture register GPIO JP2 

.global UPPER_BOX_Y
.global top_arrow_info
.global SCORE
.global ADDR_JP2
.global ADDR_JP2_IRQ
.global ADDR_JP2_Edge
.global temp_arrow_info
.section .text
sensor_init:
   addi sp,sp,-12
   stw ra,0(sp)
   stw r8,4(sp)
   stw r9,8(sp)
   stw r12,12(sp)
   
   movia  r8, ADDR_JP2         # load address GPIO JP2 into r8
   movia  r9, 0x07f557ff       # set motor,threshold and sensors bits to output, set state and sensor valid bits to inputs 
   stwio  r9, 4(r8)
# 0000 0111 1111 0101 0101 0111 1111 1111
# load sensor1,0 threshold value 8 and enable sensor1,0
   movia  r9,  0xfebf0bff       # set motors off enable threshold load sensor 3
   # 1111 1|110 1|011 1111 0000 1011 1111 1111
   stwio  r9,  0(r8)            # store value into threshold register

# disable threshold register and enable state mode
  
   movia  r9,  0xfedfffff      # keep threshold value same in case update occurs before state mode is enabled
   # 1111 1|110 1|101 1111 1111 1111 1111 1111
   stwio  r9,  0(r8)
 
# enable interrupts

    movia  r12, 0xf8000000       # enable interrupts on sensor 0,1
	# 0001 1000000...
    stwio  r12, 8(r8)



	
	
    ldw ra,0(sp)
    ldw r8,4(sp)
    ldw r9,8(sp)
    ldw r12,12(sp)
	addi sp,sp,12
	ret

########### sensor handler ###################
	
sensor1_exp: # sensor 1 right hand
	addi sp, sp, -20
	stw ra, 0(sp)
	stw r10, 4(sp)
	stw r11, 8(sp)
	stw r12, 12(sp)
	stw r13, 16(sp)
	stw r14, 20(sp)
	
	movia r10, UPPER_BOX_Y
	movia r11, top_arrow_info
	# check if arrow valid
	ldw r14,0(r11)
	andi r14,r14,0b00000001
	# bit 1 is 0, exit
	beq r14,r0,EXIT
	
	#get upper box y pisition
	ldw r14,0(r10)
	
	# great input , 2 scores
	beq r14,r0,GREAT
	
	# ok input, 1 score
	movia r13,6
	beq r14,r13,OK
	movia r13,-6
	beq r14,r13,OK
	
	# bad input, no score
	br BAD
	
	
sensor0_exp: # sensor 0 left hand
    addi sp, sp, -20
	stw ra, 0(sp)
	stw r10, 4(sp)
	stw r11, 8(sp)
	stw r12, 12(sp)
	stw r13, 16(sp)
	stw r14, 20(sp)
	
	movia r10, UPPER_BOX_Y
	movia r11, top_arrow_info
	movia r13, temp_arrow_info
	
	ldw r14,0(r13)
	andi r14,r14,0b00100001
	beq r14,r0,EXIT
	
	# check if arrow valid
	ldw r14,0(r11)
	andi r14,r14,0b00100001
	# bit 6 is 0, exit
	beq r14,r0,EXIT
	
	#set flag
	ldw r14,0(r13)
	andi r14,r14,0b00011110
	stw r14,0(r13)
	
	#get upper box y pisition
	ldw r14,0(r10)
	
	# great input , 2 scores
	beq r14,r0,GREAT
	
	# ok input, 1 score
	movia r13,6
	beq r14,r13,OK
	movia r13,-6
	beq r14,r13,OK
	
	# bad input, no score
	br BAD
	
################SCORE INCREMENT###################	
	
BAD:
	br print_miss
	br EXIT

# increment score by 1
OK:
	movia r11,SCORE
	ldw r10, 0(r11)
	addi r10, r10, 1
	stw r10, 0(r11)
	br print_good
	br EXIT
# increment score by 2
GREAT:
	movia r11,SCORE
	ldw r10, 0(r11)
	addi r10, r10, 2
	stw r10, 0(r11)
	br print_great
	br EXIT


print_miss:
	movia r8, 0x09000000
	movi r6,0x4d # m
	stbio r6,132(r8) 
	movi r6,0x49 # i
	stbio r6,133(r8) 
	movi r6,0x53 # s
	stbio r6,134(r8) 
	movi r6,0x53 # s
	stbio r6,135(r8) 
	movi r6,0x20 # space
	stbio r6,136(r8) 
	br EXIT
	
print_good:	
	movia r8, 0x09000000
	movi r6,0x47 # g
	stbio r6,132(r8) 
	movi r6,0x4f # o
	stbio r6,133(r8) 
	movi r6,0x4f # o
	stbio r6,134(r8) 
	movi r6,0x44 # d
	stbio r6,135(r8) 
	movi r6,0x20 # space
	stbio r6,136(r8) 
	br EXIT
	
print_great:
	movia r8, 0x09000000
	movi r6,0x47 # g
	stbio r6,132(r8) 
	movi r6,0x52 # r
	stbio r6,133(r8) 
	movi r6,0x45 # e
	stbio r6,134(r8) 
	movi r6,0x41 # a
	stbio r6,135(r8) 
	movi r6,0x54 # t
	stbio r6,136(r8) 
	br EXIT

	
EXIT:

     
	ldw ra, 0(sp)
	ldw r10, 4(sp)
	ldw r11, 8(sp)
	ldw r12, 12(sp)
	ldw r13, 16(sp)
	ldw r14, 20(sp)
	
	addi sp, sp, 20

	ret
