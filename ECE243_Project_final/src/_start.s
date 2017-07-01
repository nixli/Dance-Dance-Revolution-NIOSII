.equ SP_BASE,0x80000000
.equ PS2_ADDRESS, 0xFF200100
.equ ADDR_AUDIODACFIFO, 0xFF203040
.global game_song
.global Song_Ptr
.global Keyboard_data
.global GAME_STATE
.global SCORE
.global Draw_score
.global game_over
.global sensor0_exp
.global sensor1_exp
.global ADDR_JP2
.global ADDR_JP2_IRQ
.global ADDR_JP2_Edge
.global AudioExpt
.section .data
.global sensor_init
.align 2
Keyboard_data: .skip 4
Song_Ptr: .word 

.section .exceptions, "ax"

Handler:
	addi sp, sp, -12
	stw ra, 0(sp)
    stw et,4(sp)
    stw ea,8(sp)
	stw r2,12(sp)
	# timer highest priority
	rdctl et, ipending
    andi et, et, 0x01
    bne et, r0, TIMER_EX
	
    # ps2 higher priority
    rdctl et, ipending
    andi et, et, 0x080
    bne et, r0, PS2_EX
	
	#audio

	
#check if JP2	
	rdctl et, ctl4                    # check the interrupt pending register (ctl4) 
	movia r2, ADDR_JP2_IRQ    
	and	r2, r2, et                  # check if the pending interrupt is from GPIO JP2 
	beq   r2, r0, goto_audio    
# sensor 1 triggered
	movia r2, ADDR_JP2_Edge         # check edge capture register from GPIO JP2 
	ldwio et, 0(r2)
	andhi r2, et, 0x3000              # mask sensor 1  0001 0000 
	bne   r2, r0, SENSOR1_EX        # exit if sensor 2 did not interrupt 
# sensor 0 triggered	
	movia r2, ADDR_JP2_Edge           # check edge capture register from GPIO JP2 
	ldwio et, 0(r2)
	andhi r2, et, 0x0800              # mask sensor 0  0000 1000 
	bne   r2, r0, SENSOR0_EX        # exit if sensor 2 did not interrupt 
	br exit_irq
    #rdctl et, ipending
    #audio lower priority
    #andi et, et, 0b01000000
    #bne et, r0, audio_out
goto_audio:
	rdctl et, ipending
    andi et, et, 0x040
    bne et, r0, AudioEx
    br exit_irq

TIMER_EX:
call game_over
br exit_irq


PS2_EX:
#movi et,0b0
#wrctl ienable, et
call ps2
br exit_irq

AudioEx:
call AudioExpt
br exit_irq


SENSOR1_EX:
call sensor1_exp
movia r2, ADDR_JP2
movia r3, 0xffffffff
stwio r3, 12(r2)
br exit_irq

SENSOR0_EX:
call sensor0_exp
movia r2, ADDR_JP2
movia r3, 0xffffffff
stwio r3, 12(r2)
br exit_irq

exit_irq:

ldw ra, 0(sp)
ldw et,4(sp)
ldw ea,8(sp)
ldw r2,12(sp)
addi sp, sp, 12
addi ea, ea, -4

eret






#**************************************************TEXT*********************************

.section .text
.global _start

_start:
	movia sp, SP_BASE
	movia r10, PS2_ADDRESS
	
	#initialize audio 
	movia r8,game_song
	addi r8,r8,44
	movia r11, Song_Ptr
	stw r8, (r11)
	movia r8, ADDR_AUDIODACFIFO
	movi r11, 0b010
	stw r11, (r8)
	
	call sensor_init
	#call audioInit
	call PS2INIT

#call AudioExpt
	movia r5,GAME_STATE
	stw r0,0(r5)
	movia r5,SCORE
	stw r0,0(r5)
LOOP2:

call main

br LOOP2

exit:
br exit

Draw_block:
#prologue
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


ret

.global clear_char_buffer
clear_char_buffer:
	addi sp, sp, -8
	stw ra, 0(sp)
	stw r5, 4(sp)
	stw r6, 8(sp)

movia r6, 0x09000000
movi  r5, 0x20 
stbio r5,841(r6) 
stbio r5,839(r6) 
stbio r5,3881(r6) 
stbio r5,3879(r6) 
  
Done:
	
	#epilogue
	ldw ra, 0(sp)
	ldw r5, 4(sp)
	ldw r6, 8(sp)
  	addi sp, sp, 8
	
	ret
	
	.end
