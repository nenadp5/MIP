;Kada se u tekstu kaze da program nema drugih aktivnosti ili da zabode, to se postize uz pomoc beskonacne petlje

$NOMOD51 ;ukljucujemo biblioteke za normalan rad mikrokontrolera
$INCLUDE(REG52.INC)
PROGRAM SEGMENT CODE
	RSEG PROGRAM ;relokatibilni deo memorije

start:
	jb P1.0,start ;ako je T1=1 mozemo posmatrati kao da se nista ne desava i da se vrti u krug. Medjutim kada je 0 onda se prikazuje prva cifra, zato sto je PULL-UP konfiguracija
	mov A,#01011101B ;upisujemo vrednost
	mov B,#10H ;u B upisujemo 16 zbog postupka odvajanja cifara
	div AB ;delimo A i B
	call konverzija ;pozivamo funkciju za konverziju vrednosti
	mov P2,A ;konvertovanu vrednost prosledjujemo na pin P2
	mov A,B ;smestamo sledecu vrednost u A
lab:
	jnb P1.1,lab ;ako je T2=0 onda se ne desava nista i program se vrti. Medjutim ako je 1 onda se inicijalizuje druga cifra, zato sto je PULL-DOWN konfiguracija
	call konverzija ;pozivamo funkciju za konverziju vrednosti
	mov P2,A ;konvertovanu vrednost prosledjujemo na pin za displej
	sjmp $ ;nakon pritiska svih tastera onda se vrti beskonacna petlja
konverzija:
	mov DPTR,#TABLE ;klasican postupak sa pristup lookup tabeli
	movc A,@A+DPTR
	ret
TABLE: ;lookup tabela za sedmosegmentni displej
	DB 7EH
	DB 30H
	DB 6DH
	DB 79H
	DB 33H
	DB 5BH
	DB 5FH
	DB 70H
	DB 7FH
	DB 73H