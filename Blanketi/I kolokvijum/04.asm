$NOMOD51
$INCLUDE(REG52.INC) ;ukljucujemo biblioteke za rad  
PROGRAM SEGMENT CODE
	RSEG PROGRAM ;relokatibilni deo memorije
START:
	mov IE,#85H ;incijalizujemo IE registar da odobrava globalne prekide i prekide 0 i 1
	mov A,IT01CF ;IT01CF registar smestamo u A
	anl A,#01110111B ;vrsimo maskiranje tako da reaguje na HOT=0 i COLD=0
	mov IT01CF,A
	setb IT0 ;podesavamo IT0 i IT1 da reaguju na padajucu ivicu
	setb IT1
	
	setb P1.0 ;ukljucujemo pec
	jb P3.2,skip ;ako je P3.2=1 znaci da nije HOT i preskace se iskljucivanje peci
	clr P1.0 ;ako je HOT onda se iskljucuje pec
skip:
	sjmp skip ;vrti se beskonacna petlja, gde mikrokontroler svakako prati rad sistema

cseg at 0003H ;prekid se desio na lokaciji za prekid 0
EX0:
	clr P1.0 ;reaguje kada je HOT i onda se iskljucuje pec
	reti ;povratak u glavni program
cseg at 0013H ;prekid se desio na lokaciji za prekid 1
EX1:
	setb P1.0 ;reaguje kada je COLD i onda se ukljucuje pec
	reti
end