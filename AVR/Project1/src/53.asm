.include "m16def.inc"
.def temp=r16
.def mule=r17 ; used for PA7 input
.def clock_h=r18 ;for the timer
.def clock_l=r19 ;for the timer
.def leds=r20 ; used for keeeping PB0 lit after 0.5 secs
.def int_mule=r22; used for PD3 input
.org 0x00
jmp main ; Reset Handler
.org 0x04
jmp ISR1 ; IRQ1 Handler
.org 0x10
jmp timer1_rout
main:
ldi temp,high(RAMEND)
out SPH,temp
ldi temp,low(RAMEND)
out SPL,temp ; stack init
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=-
ldi r24 ,( 1 << ISC11) | ( 1 << ISC10)
out MCUCR, r24
ldi r24 ,( 1 << INT1)
out GICR, r24 ;INT1 and protect from sparkling
;setup
ldi temp,0x05 ; Frequency Divisor = 1024
out TCCR1B,temp
ldi temp,0x04 ; Enable Timer1
out TIMSK,temp
sei
clr temp
out DDRD,temp ; pullup resistance for input
ser temp
out DDRB,temp
ldi clock_h,0x85 ; clock_h:clock_l = 0x85EE
;{=65536-4*7812.5}, where 7812.5Hz = cycles/sec =~ 8MHz/1024
ldi clock_l,0xEE ;
ldi leds,0x01 ; PB0
loop:
in mule,PINA ; porta -> input
sbrs mule,7 ; If PA7==1 exit loop and do stuff
;with leds
rjmp loop
ldi temp,0xFF
out PORTB,temp ; light up PB0-PB7 leds
ldi r24,low(500)
ldi r25,high(500) ; delay 500 ms
rcall wait_msec
out PORTB,leds ; led PB0 on due to PA7
out TCNT1H,clock_h ; 4secs
out TCNT1L,clock_l
in mule,PINA
sbrc mule,7 ; if PA7==0, ignore next command
clr r21
out PORTB,r21 ; turn PB0 led off
rjmp loop
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=-
ISR1:
rcall protect ;prevent sparkling
push r26
in r26, SREG
push r26
ldi temp,0xFF ; on refresh, light em up
out PORTB,temp
ldi r24,low(500)
ldi r25,high(500) ; delay 500 ms
rcall wait_msec
out PORTB,leds ; led on
out TCNT1H,clock_h ; reset clock
out TCNT1L,clock_l
pop r26
out SREG, r26
pop r26
sei
in int_mule, PIND
sbrc int_mule,3 ; if PD3==0, ignore next command
reti
clr r22
out PORTB,r22 ;turn PB0 led off
reti
timer1_rout:
clr leds
out PORTB,leds ; timer overflow -> lights out
ldi leds,0x01 ; led PB0 needs to light up again
sei
reti
wait_usec:
sbiw r24 ,1 ; 2 cycles (0.250 micro sec)
nop ; 1 cycles (0.125 micro sec)
nop ; 1 cycles (0.125 micro sec)
nop ; 1 cycles (0.125 micro sec)
nop ; 1 cycles (0.125 micro sec)
brne wait_usec ; 1 or 2 cycles (0.125 or 0.250 micro sec)
ret ; 4 cycles (0.500 micro sec)
wait_msec:
push r24 ; 2 cycles (0.250 micro sec)
push r25 ; 2 cycles
ldi r24 , 0xe6 ; load register r25:r24 with 998 (1 cycles -
0.125 micro sec)
ldi r25 , 0x03 ; 1 cycles (0.125 micro sec)
rcall wait_usec ; 3 cycles (0.375 micro sec), total delay
998.375 micro sec
pop r25 ; 2 cycles (0.250 micro sec)
pop r24 ; 2 cycles
sbiw r24 , 1 ; 2 cycles
brne wait_msec ; 1 or 2 cycles (0.125 or 0.250 micro sec)
ret ; 4 cycles (0.500 micro sec)
protect:
ldi temp,0x80 ;0b1000 0000
out GIFR,temp ;Setting zero INTF1
ldi r24,0x05
ldi r25,0x00
rcall wait_msec ;wait 5 msec
in temp,GIFR ;Check if INTF1==1
sbrc temp,7
rjmp protect ;If INTF1==1 loop
ret ;If INTF1==0 return