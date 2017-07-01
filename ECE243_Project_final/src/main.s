.global draw_start_menu_1
.global draw_start_menu_2
.global draw_start_menu_3
.global vga_draw_image
.global vga_draw_image2
.global clear_hit
.global ps2_key
.global SCREEN_WIDTH
.global SCREEN_HEIGHT
.global PS2_ADDRESS
.global Draw_score
.global Draw_score2

.global GAME_STATE
.global UPPER_BOX_Y
.global CURRENT_ARRAY
.global SCORE
.global MODE
.global BREAK_CODE_FLAG

.equ SCREEN_WIDTH,320
.equ SCREEN_HEIGHT,240
.equ VGA_ADDRESS, 0x08000000
.equ TIMER,0xFF202000
############GAME STATES#########
.global GAME_STATE
.global TITLE
.global MENU
#.global SELECT_MODE
.global GAME_STARTED
.global GAME_OVER

.equ TITLE,0
.equ MENU,1
.equ GAME_STARTED,2
.equ GAME_OVER,3

#############PS/2###########
.equ PS2_ADDRESS,0xFF200100

.section .data

.global start_image_1
.global start_image_2
.global start_image_3
.global TITLE_img
.global MENU_img
.global mode_img
.global game_song

# 1 arrow
.global arrow_up
.global left_hand

.global arrow_right
.global arrow_down
.global arrow_left
.global right_hand
.global arrow_info

# 2+ arrows
.global comb_2_hands
.global comb_down_left
.global comb_up_right
.global comb_down_right
.global comb_up_left
.global comb_up_down_left
.global comb_all
.global gameover_img_1
.global gameover_img_2
.global gameover_img_3
.global gameover_img_4
.global all_arrow
.global y_top_start
.global DRAW_CHAR
.global VGA_ADDRESS
.align 0
DRAW_CHAR: .byte 0 #Set to 1 so that VGA ignores the characters white background
.align 1
TITLE_img: .incbin "/img/TITLE.bmp"
MENU_img: .incbin "/img/MENU.bmp"
#mode_img: .incbin "/img/mode.bmp"
start_image_1: .incbin "/img/background1.bmp"
start_image_2: .incbin "/img/background2.bmp"
start_image_3: .incbin "/img/background3.bmp"
gameover_img_1: .incbin "/img/gameover1.bmp"
gameover_img_2: .incbin "/img/gameover2.bmp"
gameover_img_3: .incbin "/img/gameover3.bmp"
gameover_img_4: .incbin "/img/gameover4.bmp"

#arrow_up: .incbin "/img/arrow/1_up.bmp"
left_hand: .incbin "/img/arrow/1_left_hand.bmp"
#arrow_down: .incbin "/img/arrow/1_down.bmp"
#arrow_left: .incbin "/img/arrow/1_left.bmp"
#arrow_right: .incbin "/img/arrow/1_right.bmp"
right_hand: .incbin "/img/arrow/1_right_hand.bmp"

comb_2_hands: .incbin "/img/arrow/2_both_hands.bmp"
comb_down_left: .incbin "/img/arrow/2_down_left.bmp"
comb_up_right: .incbin "/img/arrow/2_up_right.bmp"
comb_down_right: .incbin "/img/arrow/2_down_right.bmp"
comb_up_left: .incbin "/img/arrow/2_up_left.bmp"
comb_up_down_left: .incbin "/img/arrow/3_up_down_left.bmp"
#comb_all: .incbin "/img/arrow/4_all.bmp"

#all_arrow: .incbin "/img/arrow1.bmp"

.align 2
BREAK_CODE_FLAG: .word 0
GAME_STATE: .word 0 # game state default 0, title
UPPER_BOX_Y: .word 1 # unset
CURRENT_ARRAY: .word 0b00001100 # unset
SCORE: .word 0 # unset 
MODE: .word 0 # unset

.section .text

.global main

main:
    call clear_char_buffer
#	addi sp, sp, -4
#	stw ra , 0(sp)
	movia r23,TIMER
	stwio r0,4(r23)
	movi r23, 0x1080
	wrctl ienable, r23
	
	
    movia r5,GAME_STATE
    ldw r6,0(r5)
	movia r7,TITLE
    beq r6,r7,draw_title_poll
	movia r7,MENU
    beq r6,r7,deal_menu
	br skip_menu
	deal_menu:
	movia r8,game_song
	addi r8,r8,44
	movia r11, Song_Ptr
	stw r8, (r11)
	
	couter_set:
	movia r23, feed_counter
	stw r0, (r23)
	br draw_menu_poll
	
	skip_menu:
#	movia r7,SELECT_MODE
#    beq r6,r7,draw_mode_poll
	movia r7,GAME_STARTED
    beq r6,r7,start_game
	
	br skip_this
	start_game:
	Timer_set:
	movia r23,TIMER
	movui r22,%lo(0xFFFFFFFF)
	stwio r22,8(r23)
	movui r22,%hi(0xFFFFFFFF)
	stwio r22,12(r23) # set timer 50 sec
	stwio r0,0(r23)
	movi r22,0b0101 #start the timer, enable interupt
	stwio r22,4(r23)
	movi r23, 0x10c1
	wrctl ienable, r23
	
	Y_top_set:
	movia r23, y_top_start
	movi r22, 240
	stw r22, 4(r23)
	movi r22, 196
	stw r22, 8(r23)
	movi r22, 144
	stw r22, 12(r23)
	movi r22, 96
	stw r22, 16(r23)
	movi r22, 48
	stw r22, 20(r23)
	
	stw r0, 24(r23)
	br draw_game_poll
	
	skip_this:
	movia r7,GAME_OVER
	beq r6,r7,draw_game_over_poll
	br draw_title_poll

draw_title_poll:
	
	movia r5, SCORE
	stwio r0,0(r5)
	call clear_hit
	call clear_char_buffer
    call draw_title
	movia r5,GAME_STATE
    ldw r6,0(r5)
	movia r7,TITLE
    bne r6,r7,main

  br draw_title_poll

draw_menu_poll:

	call clear_char_buffer
    call draw_menu
	movia r5,GAME_STATE
    ldw r6,0(r5)
	movia r7,MENU
    bne r6,r7,main
    br draw_menu_poll

#draw_mode_poll:
#    call draw_mode
#    br main_exit


draw_game_poll:
	
	call draw_start_menu_1
	call draw_start_menu_2
	call draw_start_menu_3
	call Draw_score
	movia r5,GAME_STATE
    ldw r6,0(r5)
	movia r7,GAME_STARTED
    bne r6,r7,main
	
	br draw_game_poll

draw_game_over_poll:
	call draw_game_over1
	call draw_game_over2
	call draw_game_over3
	call draw_game_over4
	call Draw_score2
	movia r5,GAME_STATE
    ldw r6,0(r5)
	movia r7,GAME_OVER
    bne r6,r7,main
	br draw_game_over_poll

#main_exit:
#	ldw ra, 0(sp)
#	addi sp, sp, 4
#ret


Delay:
addi sp, sp, -4
stw r7, 0(sp)
movi r7, 200
subtract:
beq r7, r0, delay_finish
subi r7,r7,1
br subtract

delay_finish:
ldw r7, 0(sp)
addi sp, sp, 4

ret
.end





