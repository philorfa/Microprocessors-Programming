include "m16def.inc"
. def reg = r24
. def temp = r26
. org 0x0
rjmp reset
. org 0x2 ; Address of the routine2 - INT0
rjmp routine2
reti
reset:
;----------------. INITIALIZE STACK .------------------------;
ldi temp , high ( RAMEND ) ; Initialize stack
out SPH , temp
ldi temp , low ( RAMEND)
out SPL , temp
;---------. MAKE THE PROGRAM SESNITIVE TO INTERRUPTS INT0 .--------;
ldi reg , ( 1 << ISC00 ) | ( 1 << ISC01 ) ; Set the options
for interrupt INT0
out MCUCR , reg
ldi reg , ( 1 << INT0)
out GICR , reg
sei ; Enable interrupts
;------------------. SET OUTPUT AND INPUT .----------------------;
ser temp
out DDRC , temp ; PORTC is output ( interrupts ' counter)
out DDRB , temp ; PORTB is output ( counter from 1 to 255)
ldi temp , 0 ; PORTD is the input ( Interrupt)
out DDRD , temp
out DDRA , temp
ldi temp , 0xFF ; Set the Counter
;--------------. ROUTINE OF THE MAIN PROGRAMM - COUNTING .------;
loop :
inc temp ; Increase the counter
out PORTB , temp ; Display to PORTA
ldi r24 , low ( 200 ) ; Wait for 0.10 sec ( 100 msec)
ldi r25 , high ( 200)
rcall wait_msec
rjmp loop ; Continuous operation ( when the counter
reaches 255 it resets)
;--------------. PREVENTING SPARKLING - INT0 .---------------;
routine2:
ldi r24 , low ( 5 )
ldi r25 , high ( 5 ) ; Small delay to check and avoid
sparkling
jumpee:
ldi reg , ( 1 << INTF0 ) ; Check for misses when the PD2
button is pressed
out GIFR , reg ; Make sure that only one interrupt
will be processed
rcall wait_msec
in reg , GIFR
sbrc reg ,6
rjmp jumpee ; End loop
;-------------. MAIN ROUTINE OF INT0 .---------------;
push temp
in temp , SREG
push temp
ldi r20 , 0 ; register where we store the ouput
ldi r19 , 8 ; Loop counter - 8 loops one for each
bit of the input
in r18 , PINA ; Take input
again:
lsr r18 ; logic shift right our input
brcc next ; chech if the bit is 1 or 0
lsl r20 ; shift left our counter
inc r20 ; increase by 1
next:
dec r19 ; decrease loop counter
cpi r19 ,0
brne again
out PORTC , r20 ; print
pop temp
out SREG , temp
pop temp
reti
;------------. WAIT ROUTINES .--------------------;
wait_usec:
sbiw r24 , 1
nop
nop
nop
nop
brne wait_usec
ret
wait_msec:
push r24
push r25
ldi r24 , low ( 998 )
ldi r25 , high ( 998 )
rcall wait_usec
pop r25
pop r24
sbiw r24 , 1
brne wait_msec
ret