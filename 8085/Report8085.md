# Εργαστήριο Μικροϋπολογιστών
## Εργαστηριακή Άσκηση 8085
### Ομάδα Ε11
Ορφανουδάκης Φίλιππος
ΑΜ :03113140
Σινάνι Κλαούντιο
ΑΜ :03113623


#### ==Απο τον αριθμό της ομάδας μας (11) προκύπτει το Ζήτημα 4 προς επιλυση==


## ΖΉΤΗΜΑ 4

Στο ζήτημα αυτό μας ζητείται να φτιάξουμε ένα πρόγραμμα το οποίο θα αξιοποιεί τα 6 7-Segment display για την απεικόνιση ενός αλφαριθμητικού μηνύματος . Το μήνυμα αυτό θα το δίνει σαν είσοδο ο χρήστης από το πληκτρολόγιο του pc του ή από το πληκτρολόγιο του μLab.
Αρχική προϋπόθεση για την σύνταξη ενός μηνύματος είναι να πατηθεί το κουμπί FETCH PC. Με το πάτημα του κουμπιού αυτού το πρόγραμμα μας δίνει για έξοδο στην οθόνη τους εξής χαρακτήρες . . _ _ _ _  σε οποιαδήποτε κατάσταση και αν βρίσκεται .Στη συνέχεια πληκτρολογούμε το μήνυμα μας το οποίο μπορεί να αποτελείται από αριθμούς ή από τους χαρακτήρες A-F . Το μήνυμα θεωρείται ολοκληρωμένο όταν έχουν δωθεί 4 χαρακτήρες και κάθε παραπάνω χαρακτήρας θα αγνοείται , εκτός από το FETCH PC . Αφού ολοκληρωθεί το μήνυμα , το πρόγραμμα μας παρέχει 3 δυνατότητες παρουσίασης του . Πατώντας το 1 το μήνυμα μας αρχίζει να περιστρέφεται δεξιόστροφα ,  πατώντας το 2 αρχίζει η αριστερόστροφη ολίσθηση. Τέλος πατώντας το 3 έχουμε στατική προβολή του μηνύματος μας στη εξής μορφή .ΧΧΧΧ. 


Στο πρόγραμμα μας χρησιμοποιούμε για τις ρουτίνες STDM και DCD για την αποστολή των δεδομένων στα diplays . Για να διαβάσουμε την είσοδο χρησιμοποιούμε αρχικά και για μία φορά την ρουτίνα KIND και στη συνέχεια χρησιμοποιούμε την δικιά μας ρουτίνα CUSTOM_KIND  η οποία αποτελεί μια παραλλαγή της ΚΙΝD . Πριν εξηγήσουμε την λειτουργία της , πρέπει να αναφέρουμε την ανάγκη και το πρόβλημα που μας επιλύει χρησιμοποιώντας την. Αν παρατηρήσουμε στον βοηθό τον κώδικα της KIND παρατηρούμε πως είναι αδύνατο να προβάλουμε σταθερά τις τελείες .Αυτό συμβαίνει καθώς δεν υπάρχει αντίστοιχος κωδικός για τις τελείες έτσι ώστε όταν τον μεταφέρουμε στην κατάλληλη θέση μνήμης να απεικονίζεται συνεχώς με το φρεσκάρισμα της οθόνης που μας προσφέρει η DCD εσωτερικά της KIND  . Ένας τρόπος για να λυθεί αυτό είναι να τις εμφανίζουμε εμείς μέσω των πυλών σάρωσης 2800 και 3800. Ακριβώς αυτή είναι και η τροποποίηση που κάναμε στην KIND . Καθώς περιμένει να εισαχθεί ο επόμενος χαρακτήρας εμφανίζουμε συνέχεια τις τελείες μας . Μια ακόμα τροποποίηση είναι ότι , στην αναμονή για νέο χαρακτήρα , αν είναι σε κατάσταση ολίσθησης , να ολισθαίνει συνεχώς με μια μικρή καθυστέρηση που της έχουμε δώσει μέσω της ρουτίνας DELB.


Πίσω στη κύρια ροή του προγράμματος μας , υπορουτίνες που πιθανώς χρειάζονται επεξήγηση είναι η ALLOCATE , η CENTER και η DOTS .


Η ALLOCATE είναι υπεύθυνη για την σωστή τοποθέτηση του χαρακτήρα μας στο μήνυμα. Οι νέοι χαρακτήρες που εισάγονται μπαίνουν πάντα στην δεξιότερη θέση και οι υπόλοιποι μετακινούνται μια θέση αριστερά. Συνεπώς ξεκινάμε από το δεξιότερο 7-segment display και τοποθετούμε τον νέο χαρακτήρα και αποθηκεύουμε το προηγούμενο περιεχόμενο του. 
Ύστερα εκτελούμε την ίδια διαδικασία μέχρι να πέσουμε πάνω σε τελεία ( την τελεία την αναγνωρίζουμε καθώς έχει τον κωδικό 00Η έσι ώστε να μην εμφανίζεται τίποτα άλλο)


Η CENTER  είναι υπεύθυνη για την στατική κεντρική απεικόνιση του μηνύματος μας .
Η λειτουργία της είναι να βρίσκει την δεύτερη τελεία και να την ρολάρει δεξιά μέχρι να φτάσει στο δεξιότερο 7-segment display. Συνεπώς αυτο που κάνει είναι να τσεκάρει κάθε θέση μνήμης μέχρι να βρεί τον κωδικό 00Η που σημαίνει ότι έχει βρει τελεία . αν αριστερά της είναι χαρακτήρας είναι η ζητούμενη , αν δεν έχει αριστερά χαρακτήρα συνεχίζουμε μέχρι να βρούμε το επόμενο 00Η. Κατα τη διάρκεια της αναζήτησης καταγράφουμε και πόσες θέσεις σκανάραμε ετσι ώστε να ρολάρουμε τόσες θέσει δεξιά.


Η DOTS είναι η ρουτίνα που μας επιτρέπει να βρίσκουμε τις τελείες και να τις απεικονίζουμε. Έχει απλή λειτουργία καθώς το μόνο που κάνει είναι να βρίσκει μια τελεία με ένα σκανάρισμα και από την θέση της τελείας να εντοπίζει που είναι η άλλη τελεία. 




Αρκετά βοηθητικά θα φανούν και  τα σχόλιο  που παραθέτουμε στον κώδικα μας παρακάτω  : 

```perl=
IN 10H
CALL SHUTDOWN ;; SHUTDOWN WILL CLEAR OUR SCREEN 
PUSH PSW
PUSH B
PUSH H
PUSH D
CALL STDM   ;; STDM MAY CHANGE REGISTERS SO WE SAVE THEM
POP H
POP D
POP B
POP PSW
CALL DCD
MVI B,00H ;; COUNTER FOR CHARACTERS GIVEN
MVI E,00H ;; FOR RANDOM USE
BEGIN:
CALL KIND  ;; READ INPUT
CPI 85H     ;; COMPARE WITH FETCH PC CODE
JNZ BEGIN ;; IF NOT EQUAL WAIT UNTIL WE PRESS IT

JMP OP1 ;; WE PRESSED OUR FIRST FETCH PC 

READ_IN:
CALL CUSTOM_KIND   ; INPUT
MOV C,A    ; SAVE INPUT
CPI 85H    ; COMPARE WITH THE CODE OF FETCH_PC
JNZ CHECK  ;WE DIDNT PRESS FETCH_PC
MOV A,B   ; WE PRESSED FETCH_PC
CPI 00H    ;; FETCH_PC WILL EFFECT US ONLY IF WE HAVE REACHED OUR 4TH CHARACKTER
JNZ OP
OP1:
CALL INITIALIZE ; FETCH_PC EFFECT OUTPUT MUST BE . . _ _ _ _
SHINE: ; LET IT SHINE
LXI D,0B00H ;; SET OUR BEGINNING OUTPUT ADDRESS
CALL DISPLAY ;; DIPLAY
JMP READ_IN
OP:
CPI 04H     ;; COMPARE WITH 4
JC READ_IN ;; WE HAVNT REACH OUR 4TH CHARACKET
JMP OP1
CHECK: ;; WE DIDNT PRESS FETCH_PC
MOV A,C ;;MOVE TO A OUR INPUT 
CPI 10H
JNC READ_IN  ;; CHECH IF THE INPUT IS AN ACCEPTABLE CHARACTER( 0-F )
ALLOCATE: ;; ALL OK TIME TO ALLOCATE THE INPUT
MOV A,B
CPI 04H   ;; IF IT THE 5TH CHARACTER GIVEN
JNC ROLLING  ;; WE ACCEPT ONLY 1 - 2 - 3 FOR ROLLING OR CENTRILIZE
LXI H,0B00H ; WE START CHECKING FOR FREE SPACE TO PUT OUR INPUT
PRO:
CPI 00H    ; WE START FROM THE FIRST 7SEGMENT AND INCREASE UNTIL WE REACH OUR
            ;; LOCATION
JZ HIT  ;; WE FOUND OUR FREE SPACE
MOV D,M   ;; WE MOVE OUR CONTENT
MOV M,C    ;; TO THE 
MOV C,D    ;; LEFT
DCR A      ;; A == HOW MANY LEFT ROTATIONS I HAVE TO MAKE
INX H       ;; INCREASE THE POSITION OF THE 7SEGMENT THAT WE CHECK 
JMP PRO
HIT:
INR B      ;; INPUT ++
MOV M,C    ;; FINALLY WE OUR ABLE ALLOCATE
JMP SHINE ;; DISPLAY
ROLLING:
MOV A,C
CPI 01H     ;; 1-RIGHT
JZ RIGHT
CPI 02H  ;;2-LEFT
JZ LEFT
CPI 03H ;; 3-CENTER
JZ CENTER
JMP READ_IN  ;; NO OTHER CHARS ARE ACCEPTABLE
RIGHT:  ;; WE ROTATE ONE POSITION RIGHT ALL OF OUR CONTENT
INR B ;; INCREASE THE NUMBER OF INPUT GIVEN
LXI H,0B00H
MOV E,M
LXI H,0B05H
MOV D,M
MOV M,E
LXI H,0B04H
MOV E,M
MOV M,D
LXI H,0B03H
MOV D,M
MOV M,E
LXI H,0B02H
MOV E,M
MOV M,D
LXI H,0B01H
MOV D,M
MOV M,E
LXI H,0B00H
MOV M,D
JMP SHINE
LEFT:    ;; WE ROTATE ONE POSITION LEFT ALL OF OUR CONTENT
INR B ;; INCREASE THE NUMBER OF INPUT GIVEN
LXI H,0B00H
MOV E,M
LXI H,0B01H
MOV D,M
MOV M,E
LXI H,0B02H
MOV E,M
MOV M,D
LXI H,0B03H
MOV D,M
MOV M,E
LXI H,0B04H
MOV E,M
MOV M,D
LXI H,0B05H
MOV D,M
MOV M,E
LXI H,0B00H
MOV M,D
JMP SHINE
CENTER:           ;; WITH THIS FUNCTION WE FIND THE LOCATION OF THE SECOND BLANK
MVI E,00H   ;; 7-SEGMENT
LXI H,0B00H  ;; START LOOKING FROM H
FIND:
MOV A,M
CPI 10H    ;; WE FOUND ONE BLANK 7-SEGMENT
JZ WE_ARE_CLOSE     ;; CHECK  IT IS THE FIRST OR THE SECOND
INX H  ;; INR MEMORY POINTER
INR E  ;; INR  TIMES THAT WE CHECKED
JMP FIND
WE_ARE_CLOSE:
INX H
MOV A,M
CPI 10H
JNZ GOTCHA  ;; WE HIT A CHARACTER ON THE LEFT SO WE FOUND WHAT WE WANTED
INR E
MOV A,E
CPI 05H ;; IF WE REACH THE 5TH POSITION THEN WE ARE FINE
JZ GOTCHA
JMP WE_ARE_CLOSE
GOTCHA:   ;; WE ROTATE RIGHT UNTIL THE SECOND BLANK 7-SEGMENT REACH FIRST POSITION
MOV A,E  ;; eg (.) . _ _ _ _ -> . _ _ _ _(.)
CPI 00H
JZ SHINE
LXI H,0B00H
MOV E,M
LXI H,0B05H
MOV D,M
MOV M,E
LXI H,0B04H
MOV E,M
MOV M,D
LXI H,0B03H
MOV D,M
MOV M,E
LXI H,0B02H
MOV E,M
MOV M,D
LXI H,0B01H
MOV D,M
MOV M,E
LXI H,0B00H
MOV M,D
MOV E,A
DCR E
JMP GOTCHA
SHUTDOWN:   ;; HAVE A CLEAR START
MVI A,00H
LXI B,0000H
LXI D,0B00H
LXI H,0B00H
MVI M,10H
INX H
MVI M,10H
INX H
MVI M,10H
INX H
MVI M,10H
INX H
MVI M,10H
INX H
MVI M,10H
RET
INITIALIZE:  ;; FETCH-PC EFFECT OUR OUPTU SHOULD BE
LXI D,0B00H
LXI H,0B00H
MVI M,17H
INX H         ;; . . _ _ _ _
MVI M,17H
INX H
MVI M,17H
INX H
MVI M,17H
INX H
MVI M,10H
INX H
MVI M,10H
MVI B,00H
RET
DISPLAY: ;; SHINE ON YOU
PUSH PSW
PUSH B   ;; SAVE REGISTERS IN CASE STDM CHANGES THEM
PUSH H
PUSH D
CALL STDM
POP H
POP D
POP B
POP PSW
CALL DCD
RET
DOTS:        ;; WITH THIS FUNCTION WE FIND WHERE THE DOTS SHOULD BE
LXI H,0B00H    ;; AND DISPLAY THEM
MVI D,80H ;
GO:
MOV A,M
CPI 10H    ;; WE FOUND OUR FIRST DOT
JNZ FIRST  ;; ALL WE NEEDED
MOV A,D    ;; NOW WE CAN DEFINE THE SECOND DOT
RLC
MOV E,A
CPI 01H
JZ FIX
RLC
GO_1:
ORA E     ;; A= THE LOCATION OF THE TWO 7SEGMENTS
STA 2800H
MVI A,7FH
STA 3800H ;; PRINT  DOT
RET
FIX:
INX H
MOV A,M
CPI 10H
JZ FIX_2
MVI A,20H
JMP GO_1
FIX_2:
MVI A,02H
JMP GO_1
FIRST:
MOV A,D
RLC
INX H
MOV D,A
JMP GO

ROLL_ON: ;; WITH THIS FUNCTION WE CHECK IF WE MUST ROLL INSIDE THE CUSTOM KIND
MOV A,B
CPI 05H
JNC FIFTH ;; WE HAVE GIVEN 5 OR MORE CHARACTERS SO WE MUST CKECH IF ITS TIME TO ROTATE
RET
FIFTH:
MOV A,C
CPI 01H
JZ RIGHT1 ;; BINGO WE MUST ROTATE RIGHT UNTIL ANOTHER ACCEPTABLE CHARACTER IS GIVEN
CPI 02H
JZ LEFT1 ;; ^^ WE ROTATE LEFT
RET


RIGHT1: ;; ROTATE ONE POSITION RIGHT
PUSH B ;; SAVE REGISTER
LXI B,0040H ;; OUR DELB DURATION
CALL DELB
POP B 
PUSH D ;; SAVE REGISTERS IN CASE CUSTOM_KIND NEEDS THEM
PUSH H
LXI H,0B00H
MOV E,M
LXI H,0B05H
MOV D,M
MOV M,E
LXI H,0B04H
MOV E,M
MOV M,D
LXI H,0B03H
MOV D,M
MOV M,E
LXI H,0B02H
MOV E,M
MOV M,D
LXI H,0B01H
MOV D,M
MOV M,E
LXI H,0B00H
MOV M,D
POP H
LXI D,0B00H
CALL DISPLAY
POP D
RET
LEFT1: ;; ROTATE ONE POSITION LEFT
PUSH B ;; SAVE RESGISTER
LXI B,0040H ;; OUR DELB DURATION
CALL DELB
POP B
PUSH D ;; SAVE REGISTERS IN CASE CUSTOM KIND NEEDS THEM 
PUSH H
LXI H,0B00H
MOV E,M
LXI H,0B01H
MOV D,M
MOV M,E
LXI H,0B02H
MOV E,M
MOV M,D
LXI H,0B03H
MOV D,M
MOV M,E
LXI H,0B04H
MOV E,M
MOV M,D
LXI H,0B05H
MOV D,M
MOV M,E
LXI H,0B00H
MOV M,D

POP H
LXI D,0B00H
CALL DISPLAY
POP D
RET
CUSTOM_KIND:
PUSH D
PUSH H
CUSTOM_KIND1:
CALL DCD ;UPDATE DISPLAY AND WAIT
CALL ROLL_ON
CALL DOTS ;DISPLAY DOTS
CALL KPU ;CHK FOR PUSHED KEY
JNZ CUSTOM_KIND1 ;IF KEY STILL PUSHED
CUSTOM_KIND2:
CALL DCD ;UPDATE DISP AND WAIT
CALL ROLL_ON
CALL DOTS ; DISPLAY DOTS
CALL KPU ;SHK FOR PUSHED KEY
JZ CUSTOM_KIND2 ;IF KEY NOT PUSHED
TEAM:
LXI H,0BE8H ;ADRS OF FIRST KEY ROW SCAN
MVI D,FFH ;LOAD ROW COUNTER TO 0-1
CUSTOM_KIND3:
MOV A,M ;GET ROW N KEY DATA
CPI F7H ;IS IT THE HDWR STEP KEY?
JZ CUSTOM_KIND5 ;YES JUMPS
CMA ;INVERT KEY DATA
INR L ;NEXT ROW
INR D ;NEXT TABLE BLOCK
ANA A ;TEST ROW N FOR 0
JZ CUSTOM_KIND3 ;JUMP IF KEY NOT PUSHED
CPI 04H ;SEE IF D3=1
JNZ CUSTOM_KIND4 ;IF SO
DCR A ;ELSE SET A=3
CUSTOM_KIND4:
ADD D ;ADD 3X THE ROW N TO
ADD D ;GET THE TABLE OFFSET
ADD D
MOV E,A ;STORE TABLE INDEX
MVI D,00H ;CLEAR MS BYTE OF DE
LXI H,01AFH ;ADRS OF KEY CODE TABLE
DAD D ;ADD INDEX TO TABLE ADRS
MOV A,M ;PUT KEY CODE IN A
CALL REWIND
CUSTOM_KIND5:
POP H
POP D
RET
REWIND:
MOV A,B
CPI 05H      ;; IF WE HAVE GIVEN MORE THAN 5 CHARS
JNC REWIND1   ;; THERE IS A SPECIAL CASE WE MUST
                      ;; CHECK
MOV A,M
RET

REWIND1: ;; WITH THIS SUBROUTINE WE MAINTAIN OUR INPUT SO WE CAN CONSTANTLY ROTATE
MOV A,M 
CPI 85H ;; CHECK IF WE PRESSES FETCH PC SO WE MUST INITIALIZE
JNZ OL
RET
OL:
CPI  04H
JNC REWIND2
RET

REWIND2:
MOV A,C ;; C == THE PREVIOUS ACCEPTABLE INPUT
RET
END

```