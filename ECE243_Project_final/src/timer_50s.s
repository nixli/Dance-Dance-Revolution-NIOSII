.equ TIMER,0xFF202000

.section .text

.global timer_50s_init
timer_50s_init:

movia r23,TIMER
movui r22,%lo(2500000000)
stwio r22,8(r23)
movui r22,%hi(2500000000)
stwio r22,12(r23) # set timer 50 sec
stwio r0,0(r23)
movi r22,0b0101 #start the timer, enable interupt
stwio r22,4(r23)
subi ea,ea,4
eret

	
	
	

