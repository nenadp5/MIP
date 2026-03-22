;Adrese (70H i 71H) se prvo smeste u registar R0, a potom se u R0 koje ima tu adresu upise konkretna vrednost

$NOMOD51
$INCLUDE(REG52.INC) ;ukljucujemo biblioteke za rad
PROGRAM SEGMENT CODE
	CSEG AT 0000H ;memorijska lokacija za pocetak programa
	ljmp start ;skacemo na glavni deo programa
	RSEG PROGRAM
start:
	jb p1.0, start ;receno je da su tasteri aktivni na 0, pa zato proveravamo da li su 1, i ako jesu onda se petlja samo vrti
	mov R0,#70H ;R0 uzima adresu 70H
	mov @R0,#5 ;smestamo vrednost u R0
	mov A,@R0 ;prebacamo vrednost u A
	call konverzija ;pozivamo proceduru za konverziju
	mov P2,A ;prosledjujemo konvertovani broj na pin za displej
lab:
	jb P1.1,lab ;proveravamo da li je P1.1=1, ako jeste samo se vrti petlja
	mov R0,#71H ;u R0 smestamo adresu 71
	mov @R0,#7 ;u R0 smestamo vrednost
	mov A,@R0 ;vrednost prebacujemo u A
	call konverzija ;pozivamo proceduru za konverziju
	mov P2,A ;konvertovanu vrednost prosledjujemo na pin za displej
	sjmp $ ;vrti se beskonacna petlja
konverzija:
	mov DPTR,#TABLE
	movc A,@A+DPTR ;klasican postupak za pristup lookup tabeli preko DPTR registra
	ret
TABLE: DB 7EH,30H,6CH,79H,33H,5BH,5FH,70H,7FH,7BH ;lookup tabela za displej sa zajednickom katodom
end