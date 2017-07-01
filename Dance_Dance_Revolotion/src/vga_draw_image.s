# r5 : image width (x)
# r6 : image hight (y)
# r7 : start x
# r8 : start y
# r9 : y loop counter
# r10: x loop counter
# r11 : image buffer
# r12 temp colour
#r15 ptr to arrow
#r20 is the ptr to the moving y coordinate for blocks 
.equ ADDR_AUDIODACFIFO, 0xFF203040
.equ TIMER1 , 0xFF202000
.section .data
game_song: .incbin "game_song2.wav"

y_top_start: .word 0,240,192,144,96,48,0

num_delay: .word  0

#the information of the arrows at each row
arrow_info: .word 0, 0, 0, 0, 0, 0

arrow_info_options: .word 1, 2, 3, 4, 5, 6
top_arrow_info: .word 0
arrow_feedin_sequence: .byte 3,3,5,2,4,1,3,2,3,0,0,0,0,0,7,0,0,0,0,0,6,0,0,0,0,0,1,0,0,0,0,0,0,0,7,0,0,0,0,0,0,7
temp_arrow_info: .word 0
feed_counter: .word 0 

.section .text
.global clear_hit
.global feed_counter
.global y_top_start
.global vga_draw_image
.global arrow_up
.global left_hand
.global arrow_info
.global arrow_right
.global arrow_down
.global arrow_left
.global right_hand
.global game_song
.global Song_Ptr
.global all_arrow
.global comb_up_left
.global comb_2_hands
.global comb_down_left
.global comb_up_right
.global comb_down_right
.global comb_up_left
.global comb_up_down_left
.global arrow_up
.global left_hand

.global arrow_right
.global arrow_down
.global arrow_left
.global right_hand

.global UPPER_BOX_Y
.global top_arrow_info
.global temp_arrow_info
vga_draw_image:
	addi sp, sp, -96
	stw ra, 4(sp)
	stw r2, 8(sp)
	stw r3, 12(sp)
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
	stw r15, 60(sp)
	stw r16, 64(sp)
	stw r17, 68(sp)
	stw r18, 72(sp)
	stw r19, 76(sp)
	stw r20, 80(sp)
	stw r21, 84(sp)
	stw r22, 88(sp)
	stw r23, 92(sp)
	#get a timer snapshot
	movia r16, 0xFF202000           # r7 contains the base address for the timer 
    stwio r0,16(r16)              # Tell Timer to take a snapshot of the timer 
    ldwio r13,16(r16)              # Read snapshot bits 0..15 
    ldwio r14,20(r16)              # Read snapshot bits 16...31 
    slli  r14,r14,16		# Shift left logically
    or    r2,r14,r13               # Combine bits 0..15 and 16...31 into one register
	
	addi r4,r4, 0x46
	mov r9,r0
	mov r10,r0
	# use r11 to store pixel buffer addr
	movia r11,VGA_ADDRESS
	movia r20, y_top_start
	### assume all start from (0,0) ###
	### change start pt afterwards ###
	mov r10,r7 # r10 x start 
	mov r9,r8 # r9 y start
	
	add r6,r9,r6  # now r6 - 1 is y end point
	add r5,r10,r5 # now r5 - 1 is x end point
	
	### go through y coordinate (r9 : r6 - 1)
	Y_LOOP: 
		bge r9,r6,DONE_Y_LOOP
		mov r10,r7 # reset x start point
		
		### go through x coordinate (r10 : r5 - 1)
		X_LOOP:
			bge r10,r5,DONE_X_LOOP
			movia r20, y_top_start
			
			
			# conditionals to decide whcih block of the 36 the x, y values are at
			
			ldw r21, 4(r20)
			cmpge r13, r9, r21
			addi r16, r21, 48
			cmplt r14, r9, r16

			and r13, r13, r14
			#and r13, r13, r15
			
			bne r13, r0,CHECK_row1
			
			ldw r21, 8(r20)
			cmpge r13, r9, r21
			addi r16, r21, 48
			cmplt r14, r9, r16
			

			and r13, r13, r14
			#and r13, r13, r15
			
			bne r13, r0,CHECK_row2
			

			
			ldw r21, 12(r20)
			cmpge r13, r9, r21
			addi r16, r21, 48
			cmplt r14, r9, r16
			

			and r13, r13, r14
			#and r13, r13, r15
			
			
			bne r13, r0,CHECK_row3

			
			
			ldw r21, 16(r20)
			cmpge r13, r9, r21
			addi r16, r21, 48
			cmplt r14, r9, r16
			

			and r13, r13, r14
			#and r13, r13, r15
			
			bne r13, r0,CHECK_row4
			
			
			
			ldw r21, 20(r20)
			cmpge r13, r9, r21
			addi r16, r21, 48
			cmplt r14, r9, r16
			

			and r13, r13, r14
			#and r13, r13, r15
			
			
			bne r13, r0,CHECK_row5
			
			
			
			
			ldw r21, 24(r20)
			cmpge r13, r9, r21
			addi r16, r21, 48
			cmplt r14, r9, r16
			

			and r13, r13, r14
			#and r13, r13, r15
			
			
			bne r13, r0,CHECK_row6
			
			
			br Draw_Back			
			
			
			
			
		
			
			CHECK_row1:
			#decide which arrow to load
			movia r15, feed_counter
			ldw r15, (r15)
			addi r15, r15, 5
			movia r16, arrow_feedin_sequence
			add r15, r15, r16
			ldb r15, (r15)
			movi r16, 1
			beq r15, r16, Option1_1
			movi r16,2
			beq r15, r16, Option1_2
			movi r16,3
			beq r15, r16, Option1_3
			movi r16,4
			beq r15, r16, Option1_4
			movi r16,5
			beq r15, r16, Option1_5
			movi r16,6
			beq r15, r16, Option1_6
			movi r16,7
			beq r15, r16, Option1_7
			
			br Draw_Back
			Option1_1:	
			movia r15, comb_2_hands
			br done_op_select
			
			Option1_2:
			movia r15, comb_up_left
			br done_op_select
			
			Option1_3:	
			movia r15, comb_down_left
			br done_op_select
			
			Option1_4:	
			movia r15, comb_up_right
			br done_op_select
			
			Option1_5:	
			movia r15, comb_down_right
			br done_op_select
			
			Option1_6:	
			movia r15, left_hand
			br done_op_select
			
			Option1_7:	
			movia r15, right_hand
			br done_op_select
			
			done_op_select:
			addi r15, r15, 0x46
			
			Draw_Arrow_option:
			#get the y position taking the block's top left as 0
			sub r13, r9, r21
		#	Mod:

			#subi r13, r13, 48
			#movi r16, 48
			#blt r13, r16, Done_Mod
			#br Mod
		
			#movi r18, 48
			#sub r23, r9, r21
			#divu r13, r23, r18
			#muli r13, r13, 48
			#sub r13, r23, r13
	
	Done_Mod:
			muli r13, r13, 320
			add r13, r10, r13			
			muli r13, r13, 2
			add r17, r15, r13
			
			ldhu r12, 0(r17)
			movia r14,0x0000FFFF # white
			beq r12,r14,Draw_Back 
			br CONTINUE
						


			CHECK_row2:
			
			#decide which arrow to load
			movia r15, feed_counter	
			ldw r15, (r15)
			addi r15, r15, 4
			movia r16, arrow_feedin_sequence
			add r15, r15, r16
			
			ldb r15, (r15)
			
			movi r16, 1
			beq r15, r16, Option2_1
			movi r16,2
			beq r15, r16, Option2_2
			movi r16,3
			beq r15, r16, Option2_3
			movi r16,4
			beq r15, r16, Option2_4
			movi r16,5
			beq r15, r16, Option2_5
			movi r16,6
			beq r15, r16, Option2_6
			movi r16,7
			beq r15, r16, Option2_7
			
			br Draw_Back
		
			Option2_1:	
			movia r15, comb_2_hands
			br done_op_select
			
			Option2_2:
			movia r15, comb_up_left
			br done_op_select
			
			Option2_3:	
			movia r15, comb_down_left
			br done_op_select
			
			Option2_4:	
			movia r15, comb_up_right
			br done_op_select
			
			Option2_5:	
			movia r15, comb_down_right
			br done_op_select
			
			Option2_6:	
			movia r15, left_hand
			br done_op_select
			
			Option2_7:	
			movia r15, right_hand
			br done_op_select

			

			CHECK_row3:
			
			#decide which arrow to load
			movia r15, feed_counter	
			ldw r15, (r15)
			addi r15, r15, 3
			movia r16, arrow_feedin_sequence
			add r15, r15, r16
			
			ldb r15, (r15)
			
			movi r16, 1
			beq r15, r16, Option3_1
			movi r16,2
			beq r15, r16, Option3_2
			movi r16,3
			beq r15, r16, Option3_3
			movi r16,4
			beq r15, r16, Option3_4
			movi r16,5
			beq r15, r16, Option3_5
			movi r16,6
			beq r15, r16, Option3_6
			movi r16,7
			beq r15, r16, Option3_7
			
			br Draw_Back
		
			Option3_1:	
			movia r15, comb_2_hands
			br done_op_select
			
			Option3_2:
			movia r15, comb_up_left
			br done_op_select
			
			Option3_3:	
			movia r15, comb_down_left
			br done_op_select
			
			Option3_4:	
			movia r15, comb_up_right
			br done_op_select
			
			Option3_5:	
			movia r15, comb_down_right
			br done_op_select
			
			Option3_6:	
			movia r15, left_hand
			br done_op_select
			
			Option3_7:	
			movia r15, right_hand
			br done_op_select
			
			CHECK_row4:
			
			#decide which arrow to load
			movia r15, feed_counter	
			ldw r15, (r15)
			addi r15, r15, 2
			movia r16, arrow_feedin_sequence
			add r15, r15, r16
			
			ldb r15, (r15)
			
			movi r16, 1
			beq r15, r16, Option4_1
			movi r16,2
			beq r15, r16, Option4_2
			movi r16,3
			beq r15, r16, Option4_3
			movi r16,4
			beq r15, r16, Option4_4
			movi r16,5
			beq r15, r16, Option4_5
			movi r16,6
			beq r15, r16, Option4_6
			movi r16,7
			beq r15, r16, Option4_7
			
			br Draw_Back
		
			Option4_1:	
			movia r15, comb_2_hands
			br done_op_select
			
			Option4_2:
			movia r15, comb_up_left
			br done_op_select
			
			Option4_3:	
			movia r15, comb_down_left
			br done_op_select
			
			Option4_4:	
			movia r15, comb_up_right
			br done_op_select
			
			Option4_5:	
			movia r15, comb_down_right
			br done_op_select
			
			Option4_6:	
			movia r15, left_hand
			br done_op_select
			
			Option4_7:	
			movia r15, right_hand
			br done_op_select

			CHECK_row5:
			
			#decide which arrow to load
			movia r15, feed_counter	
			ldw r15, (r15)
			addi r15, r15, 1
			movia r16, arrow_feedin_sequence
			add r15, r15, r16
			ldb r15, (r15)
			
			movi r16, 1
			beq r15, r16, Option5_1
			movi r16,2
			beq r15, r16, Option5_2
			movi r16,3
			beq r15, r16, Option5_3
			movi r16,4
			beq r15, r16, Option5_4
			movi r16,5
			beq r15, r16, Option5_5
			movi r16,6
			beq r15, r16, Option5_6
			movi r16,7
			beq r15, r16, Option5_7
			
			br Draw_Back
		
			Option5_1:	
			movia r15, comb_2_hands
			br done_op_select
			
			Option5_2:
			movia r15, comb_up_left
			br done_op_select
			
			Option5_3:	
			movia r15, comb_down_left
			br done_op_select
			
			Option5_4:	
			movia r15, comb_up_right
			br done_op_select
			
			Option5_5:	
			movia r15, comb_down_right
			br done_op_select
			
			Option5_6:	
			movia r15, left_hand
			br done_op_select
			
			Option5_7:	
			movia r15, right_hand
			br done_op_select
			
			
			CHECK_row6:
			
			#decide which arrow to load
			movia r15, feed_counter	
			ldw r15, (r15)
			addi r15, r15, 0
			movia r16, arrow_feedin_sequence
			add r15, r15, r16
			ldb r15, (r15)
			
			movi r16, 1
			beq r15, r16, Option6_1
			movi r16,2
			beq r15, r16, Option6_2
			movi r16,3
			beq r15, r16, Option6_3
			movi r16,4
			beq r15, r16, Option6_4
			movi r16,5
			beq r15, r16, Option6_5
			movi r16,6
			beq r15, r16, Option6_6
			movi r16,7
			beq r15, r16, Option6_7
			
			br Draw_Back
		
			Option6_1:	
			movia r15, comb_2_hands
			br done_op_select
			
			Option6_2:
			movia r15, comb_up_left
			br done_op_select
			
			Option6_3:	
			movia r15, comb_down_left
			br done_op_select
			
			Option6_4:	
			movia r15, comb_up_right
			br done_op_select
			
			Option6_5:	
			movia r15, comb_down_right
			br done_op_select
			
			Option6_6:	
			movia r15, left_hand
			br done_op_select
			
			Option6_7:	
			movia r15, right_hand
			br done_op_select
			
			Draw_Back:
			ldhu r12,0(r4) #load current image pixel value (rgb)			
			# if draw character
			movia r13, DRAW_CHAR
			ldb r13,0(r13)
			movi r14,1
			bne r13,r14,CONTINUE # if not char, continue
			
			# check if color is background
			movia r14,0x00000180 # green
			bne r12,r14,CONTINUE # if not green, continue
			
			# if green, ignore, draw next char
			addi r4,r4,2
			addi r10,r10,1
			#addi r15, r15, 2
			br X_LOOP
		
		CONTINUE:

			
			/*
			movia r3,Song_Ptr
			ldw r16,0(r3)

			movia r2,ADDR_AUDIODACFIFO

			load_one_word:

			ldwio r14,4(r2)
			andhi r13,r14,0xFF00
			beq r13,r0,done_sound
			andhi r13,r14,0x00FF
			beq r13,r0,done_sound
	
			ldw r14,0(r16)
			stwio r14,8(r2)
			stwio r14,12(r2)
			addi r16,r16,4

			bgt r13,r0,load_one_word

		
		done_sound:
	
			stw r16,(r3)
				*/
			muli r13,r9,1024 # y * 1024
			muli r14,r10,2 # x * 2
			add r13,r13,r14
			add r13,r13,r11
			
			sthio r12,0(r13)
			addi r4,r4,2 # go to next pixel
			addi r10,r10,1 # increment x
			#addi r15, r15, 2
			br X_LOOP
		DONE_X_LOOP:
			addi r9,r9,1 #increment y
			
			br Y_LOOP
			
	DONE_Y_LOOP:
	movi r17, 4
Handle_top_loop:


	#set delay ptr
	movia r22, y_top_start
	add r22, r17, r22
	#decrement y bound counter
	ldw r21, (r22)
	/*
	bne r21, r0, No_increase_feed
	
	#movia r3, feed_counter
	#ldw r16, (r3)
	#addi r16, r16, 1
	#stw r16,(r3)
	No_increase_feed:
	*/
	cmpgei r13, r21, -24
	cmplti r14, r21, 24
	and r14, r14, r13
	beq r14, r0, Dont_Save_Top
	movia r13, UPPER_BOX_Y
	stw r21, (r13)
	movi r14, 4
	
	div r16, r17, r14 
	movi r14, 6
	sub r16, r14, r16
	movia r23, arrow_feedin_sequence
	add r23, r16, r23
	ldb r16, (r23)
	
	movi r23, 1
	beq r16, r23, Save1
	movi r23, 2
	beq r16, r23, Save2
	movi r23, 3
	beq r16, r23, Save3
	movi r23, 4
	beq r16, r23, Save4
	movi r23, 5
	beq r16, r23, Save5
	movi r23, 6
	beq r16, r23, Save6
	movi r23, 7
	beq r16, r23, Save7
	
	
	Save1:
	movia r23, top_arrow_info
	movui r16, 0b100001
	stw r16, (r23)
	br Dont_Save_Top
	
	
	Save2:
	movia r23, top_arrow_info
	movui r16, 0b010010
	stw r16, (r23)
	br Dont_Save_Top
	
	
	
	Save3:
	movia r23, top_arrow_info
	movui r16, 0b000110
	stw r16, (r23)
	br Dont_Save_Top
	
	
	Save4:
	movia r23, top_arrow_info
	movui r16, 0b011000
	stw r16, (r23)
	br Dont_Save_Top
	
	
	Save5:
	movia r23, top_arrow_info
	movui r16, 0b001100
	stw r16, (r23)
	br Dont_Save_Top
	
	
	Save6:
	movia r23, top_arrow_info
	movui r16, 0b100000
	stw r16, (r23)
	br Dont_Save_Top
	
	Save7:
	movia r23, top_arrow_info
	movui r16, 0b000001
	stw r16, (r23)
	br Dont_Save_Top
	
	
	Dont_Save_Top:
	subi r21, r21, 6
	movi r16, -36
	beq r21, r16, Update
	br Do_not_update
	Update:
	movia r16,temp_arrow_info
	movia r11,0b00111111
	stw r11,0(r16)
	call clear_hit
	Do_not_update:
	#if y counter reaches -48, reset that too
	movi r16, -48
	
	blt r21, r16, Reset_y
	
	# save global y top

	
	#otherwise just store that
	stw r21, (r22)
	br done_handle
	
	Reset_y:
	movi r16, 240
	stw r16, (r22)
	
	
	
	done_handle:
	
	addi r17, r17, 4
	movi r16, 25
	ble r17, r16, Handle_top_loop 


	movia r16, 0xFF202000  
	Draw_finish:
         # r7 contains the base address for the timer 
    stwio r0,16(r16)              # Tell Timer to take a snapshot of the timer 
    ldwio r13,16(r16)              # Read snapshot bits 0..15 
    ldwio r14,20(r16)              # Read snapshot bits 16...31 
    slli  r14,r14,16		# Shift left logically
    or    r14,r14,r13               # Combine bits 0..15 and 16...31 into one register
	sub r14, r2, r14				#time elipsed since beginning of draw screen
	movia r13, 24472700
	
	movia r7,GAME_STATE
	ldw r8,0(r7)
	movia r7,GAME_STARTED
	
	bne r7,r8,exit_draw
	
	bltu r14, r13, Draw_finish
exit_draw:	
	#epilogue
	ldw ra, 4(sp)
	ldw r2, 8(sp)
	ldw r3, 12(sp)
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
	ldw r15, 60(sp)
	ldw r16, 64(sp)
	ldw r17, 68(sp)
	ldw r18, 72(sp)
	ldw r19, 76(sp)
	ldw r20, 80(sp)
	ldw r21, 84(sp)
	ldw r22, 88(sp)
	ldw r23, 92(sp)
  	addi sp, sp, 96
	ret
		
		
	
	