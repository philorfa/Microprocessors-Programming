. include "m16def.inc"
. def temp = r16
. def inp = r17
. def inp0 = r18
. def inp1 = r19
. def inp2 = r20
. def inp3 = r21
. def inp4 = r22
. def inp5 = r23
. def inp6 = r26
. def inp7 = r27
. def inpC = r29
. def outp = r30
. cseg
. org 0x0
;-------. INITIALIZE STACK .------;
ldi temp , HIGH ( RAMEND ) ;;αρχικοποίηση στοίβας
out SPH , temp
ldi temp , LOW ( RAMEND)
out SPL , temp
;------. DEFINE INPUT AND OUTPUT .------;
ser temp
out DDRB , temp ;;αρχικοποιούμε τη θύρα Β
ως έξοδο
ldi temp ,0
out DDRA , temp ;;αρχικοποιούμε τη θύρα A
ως είσοδο
out DDRC , temp ;;αρχικοποιούμε τη θύρα C
ως είσοδο
;-----. TAKE INPUT AND SAVE EACH BIT .----;
start:
clr inp ; inputA
clr inpC ; inputC
clr outp ; output
clr inp0 ; BIT0
clr inp1 ; BIT1
clr inp2 ; BIT2
clr inp3 ; BIT3
clr inp4 ; BIT4
clr inp5 ; BIT5
clr inp6 ; BIT6
clr inp7 ; BIT7
in inp , PINA ;ανάγνωση της θύρας Α
in inpC , PINC ;ανάγνωση της θύρας C
mov inp0 , inp ;αποθήκευση
mov inp1 , inp ;αποθήκευση
mov inp2 , inp ;αποθήκευση
mov inp3 , inp ;αποθήκευση
mov inp4 , inp ;αποθήκευση
mov inp5 , inp ;αποθήκευση
mov inp6 , inp ;αποθήκευση
mov inp7 , inp ;αποθήκευση
;Βάζουμε τα μπιτ της εισόδου στους αντίστοιχους
καταχωρητές κάνοντας λογικά ΚΑΙ και τις
κατάλληλες μετατοπίσεις
ldi r28 ,1
and inp0 , r28
ldi r28 ,2
and inp1 , r28
lsr inp1
ldi r28 ,4
and inp2 , r28
lsr inp2
lsr inp2
ldi r28 ,8
and inp3 , r28
lsr inp3
lsr inp3
lsr inp3
ldi r28 , 16
and inp4 , r28
lsr inp4
lsr inp4
lsr inp4
lsr inp4
ldi r28 , 32
and inp5 , r28
lsl inp5
lsl inp5
lsl inp5
ldi r28 , 64
and inp6 , r28
lsl inp6
lsl inp6
ldi r28 , 128
and inp7 , r28
lsl inp7
;-----.ΠΥΛΗ 1 - XOR PA0 - PA1 .---------;
eor inp0 , inp1 ;αποθήκευση στο inp0
;-----.ΠΥΛΗ 2 - OR PA2 - PA3 .-----------;
or inp2 , inp3 ;αποθήκευση στο inp2
;-----.ΠΥΛΗ 3 - NOR PA4 - PA5 .---------;
or inp4 , inp5
com inp4
ldi r28 ,1
and inp4 , r28 ;αποθήκευση στο inp4
;----. PYLH 4 - NXOR PA6 - PA7 .----------;
eor inp6 , inp7
com inp6
ldi r28 ,1
and inp6 , r28 ;αποθήκευση στο inp6
;----. PYLH 5 - AND RESULT1 - RESULT2 .-------;
and inp0 , inp2 ;αποθήκευση στο inp0
;------. FORMULATE OUTPUT .---------; κατάλληλες λογικές
πράξεις και μετατοπίσεις μπιτ για να
δημιουργήσουμε το αποτέλεσμα στο outp
or outp , inp0
lsl inp2
or outp , inp2
lsl inp4
lsl inp4
or outp , inp4
lsl inp6
lsl inp6
lsl inp6
or outp , inp6
;------. IMPACT OF PORTC .---------;
eor outp , inpC ;; xor για να γίνει η
ανιστροφή
;-------. PRINT .--------;
out PORTB , outp
rjmp start