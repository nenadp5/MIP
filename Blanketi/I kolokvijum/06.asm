;Koristi se komanda CJNE (Compare and Jump if Not Equal) - Ako nisu jednaki skaci
;Proveravamo da li ucitana vrednost u A odgovara binarnoj notaciji te zone, u suprotnom ako ne odgovara skace se na sledecu zonu i obavlja se ista provera.

$NOMOD51
$INCLUDE(REG52.INC) ;ukljucujemo biblioteke za rad
NAME ALARM ;naziv programa
LETTER_C EQU 1001110B ;binarna notacija za slovo C

PROGRAM SEGMENT CODE
	CSEG AT 0000H ;lokacija pocetka programa
	ljmp start ;skacemo na glavni program
	RSEG PROGRAM
start:
	mov P3,#0FFH ;podrazumeva se da nije doslo do provale po zonama sto znaci da se na sedmosegmentni displej prikazuje nula i da je alarmno zvono iskljuceno
	mov A,#0
	mov DPTR,#TABLE
	movc A,@A+DPTR ;klasicna metoda za konverziju uz pomoc DPTR registra
	mov P1,A
	clr P1.7
test:
	mov A,P3 ;ucitavamo vrednost sa ulaza u A
	cjne A,#00H,alarm ;ako nije jednako sa 0 idemo na alarm
	ljmp test ;u suprotnom se samo vrti
alarm:
zona1:
	cjne A,#00000001B,zona2 ;ako ucitana vrednost u A nije jednaka sa binarnom notacijom za zonu 1, onda se skace na proveru sledece zone
	mov A,#1 ;U suprotnom se vrsi prikaz 1 na displeju i aktivira zvono
	mov DPTR,#TABLE 
	movc A,@A+DPTR
	mov P1,A
	ljmp zvono
zona2:
	cjne A,#00000010B,zona3 ;ako ucitana vrednost u A nije jednaka sa binarnom notacijom za zonu 2, onda se skace na proveru sledece zone
	mov A,#2 ;u suprotnom se vrsi prikaz 2 na displeju i aktivira zvono
	mov DPTR,#TABLE
	movc A,@A+DPTR
	mov P1,A
	ljmp zvono
zona3:
	cjne A,#00000100B,zona4 ;ako ucitana vrednost u A nije jednaka sa binarnom notacijom za zonu 3, onda se skace na proveru sledece zone
	mov A,#3 ;u suprotnom se vrsi prikaz 3 na displeju i aktivira zvono
	mov DPTR,#TABLE
	movc A,@A+DPTR
	mov P1,A
	ljmp zvono
zona4:
	cjne A,#00001000B,kombinacija ;ako ucitana vrednost ne odgovara binarnoj notaciji za zonu 4, onda se skace na labelu kombinacija koja ispisuje slovo C
	mov A,#4 ;u suprotnom se vrsi prikaz 4 na displeju i aktivira zvono
	mov DPTR,#TABLE
	movc A,@A+DPTR
	mov P1,A
	ljmp zvono
kombinacija:
	mov P1,#LETTER_C ;kod kombinacije ne moramo da palimo zvono jer ce se ono svakako upaliti kako se program sukcesivno izvrsava
zvono:
	setb P1.7 ;aktiviramo pin koji je namenjen za zvono
	jmp $ ;vrti se beskonacna petlja
TABLE:
	DB 1111110B
	DB 0110000B
	DB 1101101B
	DB 1111001B
	DB 0110011B