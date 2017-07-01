.global GAME_STATE
.global UPPER_BOX_Y
.global top_arrow_info
.global SCORE
.global MODE
.global BREAK_CODE_FLAG
.global PS2_ADDRESS
.global Keyboard_data
.global game_over
.equ TIMER,0xFF202000
# ps2 interrupt handler


### direction ###
.equ Q,0x015 # left
.equ E,0x024 # right

.equ w,0x01d
.equ d,0x023
.equ s,0x01b
.equ a,0x01c
.equ esc,0x076
### others ###
.equ BREAK,0x0f0
.equ SPACE,0x29 # space
.equ one,0x016
.equ two,0x01e
.equ three,0x026
.section .text
.global ps2
.global temp_arrow_info
ps2:
	addi sp, sp, -40
	stw ra, 0(sp)
	stw r9, 4(sp)
	stw r10, 8(sp)
	stw r11, 12(sp)
	stw r12, 16(sp)
	stw r13, 20(sp)
	stw r14, 24(sp)
	stw r15, 28(sp)
	stw r16, 32(sp)
	stw ea, 36(sp)
	stw r17, 40(sp)
	
	movia r10, UPPER_BOX_Y
	movia r11, top_arrow_info
	movia r17, temp_arrow_info
	movia et, PS2_ADDRESS #Store address of PS/2 device
	ldwio r15, 0(et) #Load value of the base register
	andi r15, r15, 0x0FF #Mask first 8-bit
	
	#Check if break code was sent (F0)
	movi r14, esc
	beq r15, r14, RESET
	
	#Check if break code was sent (F0)
	movi r14, BREAK
	beq r15, r14, SET_BREAK_CODE_FLAG
	
	#Check if break code flag is 1
	movia et, BREAK_CODE_FLAG
	ldb r14, 0(et)
	movi r12, 0b1
	#If it's 1, ignore the key and reset the flag
	beq r12, r14, RESET_FLAG

	#check if player starts game
	movi r14, SPACE 
	beq r15, r14, TITLE_TO_MENU
	
	#check if player starts game
	movi r14, one 
	beq r15, r14, MENU_TO_START
	
	
	#check if player enters 123(mode)
	#movi r14, one 
	#beq r15, r14,MODE_TO_START
	#movi r14, two 
	#beq r15, r14,MODE_TO_START
	#movi r14, three 
	#beq r15, r14,MODE_TO_START
	
	#check if already started
	movia et, GAME_STATE
	ldw r14, 0(et)
	movi et, GAME_STARTED
	#If not, do nothing and exit
	bne r14, et, EXIT
	
	
	# If enter key Q (left_hand) 
	# check arrow position 
	movi r14,Q
	beq r15,r14,PRESS_LEFT_HAND
	
	# If enter key w (up) 
	# check arrow position 
	movi r14,w
	beq r15,r14,PRESS_UP
	
	# If enter key d (right) 
	# check arrow position 
	movi r14,d
	beq r15,r14,PRESS_RIGHT
	
	# If enter key a (left) 
	# check arrow position 
	movi r14,a
	beq r15,r14,PRESS_LEFT
	
	# If enter key s (down) 
	# check arrow position 
	movi r14,s
	beq r15,r14,PRESS_DOWN
	
	# If enter key E (right_hand) 
	# check arrow position 
	movi r14,E
	beq r15,r14,PRESS_RIGHT_HAND

	#Else 
	br EXIT
	
PRESS_LEFT_HAND:
	ldw r14,0(r17)
	andi r14,r14,0b00100000
	# bit 6 is 0, exit
	beq r14,r0,EXIT
	# check if arrow valid
	ldw r14,0(r11)
	andi r14,r14,0b00100000
	# bit 6 is 0, exit
	beq r14,r0,EXIT
	
	#set flag
	ldw r14,0(r17)
	andi r14,r14,0b00011111
	stw r14,0(r17)
	
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

PRESS_UP:
	ldw r14,0(r17)
	andi r14,r14,0b00010000
	# bit 5 is 0, exit
	beq r14,r0,EXIT
	# check if arrow valid
	ldw r14,0(r11)
	andi r14,r14,0b00010000
	# bit 5 is 0, exit
	beq r14,r0,EXIT
	
	#set flag
	ldw r14,0(r17)
	andi r14,r14,0b00101111
	stw r14,0(r17)
	
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
	
PRESS_RIGHT:
	ldw r14,0(r17)
	andi r14,r14,0b00001000
	# bit 4 is 0, exit
	beq r14,r0,EXIT
	# check if arrow valid
	ldw r14,0(r11)
	andi r14,r14,0b00001000
	# bit 4 is 0, exit
	beq r14,r0,EXIT
	
	#set flag
	ldw r14,0(r17)
	andi r14,r14,0b00110111
	stw r14,0(r17)
	
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
	
PRESS_DOWN:
	ldw r14,0(r17)
	andi r14,r14,0b00000100
	# bit 3 is 0, exit
	beq r14,r0,EXIT
	
	# check if arrow valid
	ldw r14,0(r11)
	andi r14,r14,0b00000100
	# bit 3 is 0, exit
	beq r14,r0,EXIT
	
	#set flag
	ldw r14,0(r17)
	andi r14,r14,0b00111011
	stw r14,0(r17)
	
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
	
PRESS_LEFT:
	ldw r14,0(r17)
	andi r14,r14,0b00000010
	beq r14,r0,EXIT
	
	# check if arrow valid
	ldw r14,0(r11)
	andi r14,r14,0b00000010
	# bit 2 is 0, exit
	beq r14,r0,EXIT
	
	#set flag
	ldw r14,0(r17)
	andi r14,r14,0b00111101
	stw r14,0(r11)
	
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

PRESS_RIGHT_HAND:
	ldw r14,0(r17)
	andi r14,r14,0b00000001
	beq r14,r0,EXIT
	
	# check if arrow valid
	ldw r14,0(r11)
	andi r14,r14,0b00000001
	# bit 1 is 0, exit
	beq r14,r0,EXIT
	
	#set flag
	ldw r14,0(r17)
	andi r14,r14,0b00111110
	stw r14,0(r11)
	
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
###############GAME STATE#####################	
TITLE_TO_MENU:
	movia r14, GAME_STATE
	ldw r9,0(r14) # r9 for current state
	movi r16,TITLE
	bne r9,r16,EXIT # if current state is not title, exit
	movi r16,MENU
	stw r16,0(r14)
	br EXIT

MENU_TO_START:
    movia r14, GAME_STATE
    ldw r9,0(r14) # r9 for current state
    movi r16,MENU
    bne r9,r16,EXIT # if current state is not title, exit
    movi r16,GAME_STARTED
    stw r16,0(r14)
    br EXIT

#MODE_TO_START:
#	movia r14, GAME_STATE
#	ldw r9,0(r14) # r9 for current state
#	movi r16,SELECT_MODE	
#	bne r9,r16,EXIT
#	movi r16,GAME_STARTED
#	stw r16,0(r14)
#	movia r14,MODE
#	stw r15,0(r14) # write mode 
#	br EXIT
	
SET_BREAK_CODE_FLAG:
	#Set break code to 1
	movia r16, BREAK_CODE_FLAG
	ldb r14, 0(r16)
	addi r14, r14, 1
	stb r14, 0(r16)
	br EXIT
	
RESET_FLAG:
	#Set break code flag to 0
	movi r14,0
	stb r14, 0(et)
	br EXIT
RESET:
	movia r14, GAME_STATE
	stw r0,0(r14) 
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
ldw r9, 4(sp)
ldw r10, 8(sp)
ldw r11, 12(sp)
ldw r12, 16(sp)
ldw r13, 20(sp)
ldw r14, 24(sp)
ldw r15, 28(sp)
ldw r16, 32(sp)
ldw ea, 36(sp)
ldw r17, 40(sp)
addi sp, sp, 40
ret

 
 
	

game_over:
	
	addi sp,sp,-8
	stw ra,0(sp)
	stw r9,4(sp)
	stw r11,8(sp)
	
	movia r11,GAME_STATE
	movia r9,GAME_OVER
	stw r9,0(r11) 
	movia r23,TIMER
	stwio r0,4(r23)
	
	ldw ra,0(sp)
	ldw r9,4(sp)
	ldw r11,8(sp)
	addi sp,sp,8
	ret