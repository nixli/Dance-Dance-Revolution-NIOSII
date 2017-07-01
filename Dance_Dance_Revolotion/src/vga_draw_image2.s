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

.section .data
num_delay: .word  0
.section .text
.global y_top_start
.global vga_draw_image2
.global arrow_up
.global arrow_info

vga_draw_image2:
	addi sp, sp, -96
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
	stw r15, 60(sp)
	stw r16, 64(sp)
	stw r17, 68(sp)
	stw r18, 72(sp)
	stw r19, 76(sp)
	stw r20, 80(sp)
	stw r21, 84(sp)
	stw r22, 88(sp)
	stw r23, 92(sp)

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


	#set delay ptr
	movia r22, y_top_start
	movia r23, num_delay
	ldw r21, (r23)
	addi r21,r21,1

	#if drew enough times, reset
	movi r16, 1
	beq r21, r16, Reset
	#else increment counter and draw again
	stw r21, (r23)
	br Draw_finish

	
	Reset:
	#store r0 to counter
	stw r0, (r23)
	#incorement y bound counter
	ldw r21, (r22)
	addi r21, r21, 1
	#if y counter reaches 48, reset that too
	movi r16, 48
	bge r21, r16, Reset_y
	#otherwise just store that
	stw r21, (r22)
	br Draw_finish
	
	Reset_y:
	stw r0, (r22)




	Draw_finish:
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