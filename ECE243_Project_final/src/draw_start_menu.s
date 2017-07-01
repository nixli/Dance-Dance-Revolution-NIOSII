.global draw_start_menu_1
.global draw_start_menu_2
.global draw_start_menu_3
.global draw_title
.global draw_menu
.global draw_game_over1
.global draw_game_over2
.global draw_game_over3
.global draw_game_over4
       
draw_title:
	movia r4,TITLE_img
	
	### save return address ###
	addi sp,sp,-4
	stw ra,0(sp)
	
	movi r5,SCREEN_WIDTH
	movi r6,SCREEN_HEIGHT
	mov r7,r0
	mov r8,r0
	call vga_draw_image2
	
	### restore ###
	ldw ra,0(sp)
	addi sp,sp,4
	
	ret
draw_menu:
	movia r4,MENU_img
	
	### save return address ###
	addi sp,sp,-4
	stw ra,0(sp)
	
	movi r5,SCREEN_WIDTH
	movi r6,SCREEN_HEIGHT
	mov r7,r0
	mov r8,r0
	call vga_draw_image2
	
	### restore ###
	ldw ra,0(sp)
	addi sp,sp,4
	
	ret



draw_start_menu_1:
	movia r4,start_image_1
	
	### save return address ###
	addi sp,sp,-4
	stw ra,0(sp)
	
	movi r5,SCREEN_WIDTH
	movi r6,SCREEN_HEIGHT
	mov r7,r0
	mov r8,r0
	call vga_draw_image
	
	### restore ###
	ldw ra,0(sp)
	addi sp,sp,4
	
	ret
	
	
draw_start_menu_2:
	movia r4,start_image_2
	
	### save return address ###
	addi sp,sp,-4
	stw ra,0(sp)
	
	movi r5,SCREEN_WIDTH
	movi r6,SCREEN_HEIGHT
	mov r7,r0
	mov r8,r0
	call vga_draw_image
	
	### restore ###
	ldw ra,0(sp)
	addi sp,sp,4
	
	ret
draw_start_menu_3:
	movia r4,start_image_3
	
	### save return address ###
	addi sp,sp,-4
	stw ra,0(sp)
	
	movi r5,SCREEN_WIDTH
	movi r6,SCREEN_HEIGHT
	mov r7,r0
	mov r8,r0
	call vga_draw_image
	
	### restore ###
	ldw ra,0(sp)
	addi sp,sp,4
	
	ret
	
draw_game_over1:
	movia r4,gameover_img_1
	
	### save return address ###
	addi sp,sp,-4
	stw ra,0(sp)
	
	movi r5,SCREEN_WIDTH
	movi r6,SCREEN_HEIGHT
	mov r7,r0
	mov r8,r0
	call vga_draw_image2
	
	### restore ###
	ldw ra,0(sp)
	addi sp,sp,4
	
	ret
draw_game_over2:
	movia r4,gameover_img_2
	
	### save return address ###
	addi sp,sp,-4
	stw ra,0(sp)
	
	movi r5,SCREEN_WIDTH
	movi r6,SCREEN_HEIGHT
	mov r7,r0
	mov r8,r0
	call vga_draw_image2
	
	### restore ###
	ldw ra,0(sp)
	addi sp,sp,4
	
	ret

draw_game_over3:
	movia r4,gameover_img_3
	
	### save return address ###
	addi sp,sp,-4
	stw ra,0(sp)
	
	movi r5,SCREEN_WIDTH
	movi r6,SCREEN_HEIGHT
	mov r7,r0
	mov r8,r0
	call vga_draw_image2
	
	### restore ###
	ldw ra,0(sp)
	addi sp,sp,4
	
	ret

draw_game_over4:
	movia r4,gameover_img_4
	
	### save return address ###
	addi sp,sp,-4
	stw ra,0(sp)
	
	movi r5,SCREEN_WIDTH
	movi r6,SCREEN_HEIGHT
	mov r7,r0
	mov r8,r0
	call vga_draw_image2
	
	### restore ###
	ldw ra,0(sp)
	addi sp,sp,4
	
	ret

