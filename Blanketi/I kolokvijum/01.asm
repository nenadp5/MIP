;SETB IT1 | SETB IT0 podesavamo da reaguje na opadajucu ivicu
;MOV A,IT01CF | ANL A,#01110111B | MOV IT01CF,A podesavamo da reaguje kada je HOT=0 i COLD=0

$NOMOD51 ;ukljucujemo biblioteke za ispravan rad mikrokontrolera
$INCLUDE(REG52.INC)
PROGRAM SEGMENT CODE
	RSEG PROGRAM
start:
	mov IE,#85H ;podesavamo IE registar za omogucavanje prekida 
	mov A,IT01CF ;IT01CF registar smestamo u A, jer nije direktno adresabilan
	anl A,#01110111B ;obavljamo maskiranje koje omogucava da reaguje kada je HOT=0 i COLD=0
	mov IT01CF,A 
	setb IT0 ;setujemo bitove IT0 i IT1 tako da reaguju na opadajucu ivicu
	setb IT1
	
	setb P1.0 ;ukljucujemo pec da radi
	jb P3.2,skip ;ako je P3.2=1 onda nije HOT i pec treba da ostane ukljucena, tako da skacemo na petlju "skip" 
	clr P1.0 ;ako je P3.2=0 onda je HOT i gasi se pec

skip:
	sjmp skip ;vrti se beskonacna petlja
	
cseg at 0003H ;desio se prekid na lokaciji za EX0, sto znaci da je HOT
EX0:
	clr P1.0 ;imamo eksterni prekid 0 i onda se iskljucuje pec
	reti ;povratak u glavni program
	
cseg at 0013H ;desio se prekid na lokaciji za EX1, sto znaci da je COLD
EX1:
	setb P1.0 ;imamo eksterni prekid 1 i onda se ukljucuje pec
	reti
	
end

;Dok se izvrsava beskonacna petlja mikrokontroler vrsi proveru pinova i ukoliko detektuje prekid krece od lokacije definisane  kod CSEG