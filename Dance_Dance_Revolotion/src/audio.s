.global audioInit
.global AudioExpt
.equ ADDR_AUDIODACFIFO, 0xFF203040
.global game_song
.global Song_Ptr
.section .data

Song_Ptr: .word

.section .text

audioInit:

#prologue
	addi sp, sp, -16
	stw ra, 0(sp)
	stw r8, 4(sp)
	stw r9, 8(sp)
	stw r10, 12(sp)
	stw r11, 16(sp)

	

	
  movia r11,ADDR_AUDIODACFIFO
  
  #write to enable interrupt
  movi r9, 0b010
  stw r9, 0(r11)
  movia r8,game_song
  addi r8,r8,44
  movia r11, Song_Ptr
  stw r8, (r11)
	
  
  
#epilogue
	ldw ra, 0(sp)
	ldw r8, 4(sp)
	ldw r9, 8(sp)
	ldw r10, 12(sp)
	ldw r11, 16(sp)
  	addi sp, sp, 16
	
	ret
