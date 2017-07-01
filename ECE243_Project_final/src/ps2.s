.equ PS2BASE, 0xFF200100
.global PS2BASE
.global PS2INIT
.equ TIMER,0xFF202000
PS2INIT:

movia r10, PS2BASE

movi r9, 0b1
stwio r9, 4(r10)




movia r9, 0x1080
wrctl ctl3, r9

movia r9, 1
wrctl ctl0, r9

ret 
