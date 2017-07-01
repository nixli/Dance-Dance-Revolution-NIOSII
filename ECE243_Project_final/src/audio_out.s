.global audioInit
.global AudioExpt
.global Song_Ptr
.equ ADDR_AUDIODACFIFO, 0xFF203040
.equ COUNTER,640020
.section .text

	
AudioExpt:
	  #prologue
	addi sp, sp, -32
	stw ra, 4(sp)
	stw ea, 8(sp)
	stw r13, 12(sp)
	stw r14, 16(sp)
	stw r16, 20(sp)

			
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
	stw r16, (r3)
	ldw ra ,4 (sp)
	ldw ea, 8(sp)
	ldw r13, 12(sp)
	ldw r14, 16(sp)
	ldw r16, 20(sp)

  	addi sp, sp, 32
   ret
	  
