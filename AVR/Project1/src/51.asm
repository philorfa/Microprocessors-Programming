.include "m16def.inc"
.def temp = r17
.org 0x0
rjmp main
.org 0x4 ;;Διεύθυνση της ρουτίνας INT1
rjmp ISR1
main:
ldi temp,high(RAMEND) ;; Αρχικοποίηση της στοίβας
out SPH, temp
ldi temp,low(RAMEND)
out SPL, temp
ldi r24 ,( 1 << ISC11) | ( 1 << ISC10) ;; συνθήκες για την int1
out MCUCR, r24
ldi r24 ,( 1 << INT1)
out GICR, r24
sei
ser r26
out DDRA, r26 ;; αρχικοποίηση της εξόδου Α
;;που απεικονίζει τις διακοπές
out DDRB, r26 ;;αρχικοποίηση της εξόδου Β
;;που απεικονίζει το μετρητή
clr r26
clr r23
out DDRD, r26 ;;αρχικοποίηση εισόδου D
loop:
out PORTB, r26 ;; εκτύπωση στη θύρα Β
ldi r24, low(200) ;;φόρτωση καθυστέρησης 0.2sec
ldi r25, high(200) ;;στους r24,25 για τη wait
rcall wait_msec ;;κάλεσμα καθυστέρησης
inc r26 ;;αύξηση r26 που χρησιμοποιούμε
;;για το μέτρημα των διακοπών
rjmp loop
wait_usec:
sbiw r24 ,1
nop
nop
nop
nop
brne wait_usec
ret
wait_msec:
push r24
push r25
ldi r24 , low(998)
ldi r25 , high(998)
rcall wait_usec
pop r25
pop r24
sbiw r24 , 1
brne wait_msec
ret ;
ISR1: ;;ρουτίνα εξυπηρέτησης διακοπής
rcall protect
push r26 ;;σώσε το περιεχόμενο των r26
in r26, SREG ;;και SREG
push r26
in temp,PIND ;;θέσε τη θύρα εξόδου των LED
sbrs temp,7 ;;έλεγχος αν είναι πατημένο το PD7
rjmp ISR1_exit ;;αν όχι φύγε
inc r23
out PORTA, r23
ldi r24, low(998) ;;φόρτωσε τους r24,25 με καθυστέρηση 1sec
ldi r25, high(998)
ISR1_exit:
pop r26
out SREG, r26
pop r26
sei
reti
protect: ;;
ldi temp,0x80
out GIFR,temp
ldi r24,0x05 ;;εισαγωγή μικρής καθυστέρησης για
ldi r25,0x00 ;;αποφυγή σπινθηρισμού
rcall wait_msec
in temp,GIFR ;;έλεγχος και επιβεβαίωση ότι υπάρχει
sbrc temp,7 ;;μία μόνο διακοπή
rjmp protect
ret