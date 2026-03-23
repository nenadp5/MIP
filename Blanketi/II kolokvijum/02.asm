;Za stalno ocitavanje pina i njegovog preslikavanja na drugi pin, koristimo jednostavan CARRY BIT
;Inicijalizujemo T0 u 8-bitnom autoreload rezimu u registru TMOD, sadrzaj ce biti 00000010=#02H
;Tajmer 0 u autoreload rezimu je kada je M1=1 a M0=0
;Inicijalizacija prekida preko tajmera 0 se obavlja u IE registru, sadrzaj ce biti 10000010=#82H 

;F=12MHz Fto=F/12=1MHz Tt0=1/Fto=1*10^-6s
;Buduci da je T=200*10^-6s sto se vidi sa slike, 50% ce biti 100*10^-6 odnosno kada racunamo broj taktova 100*10^-6/1*10^-6=100
;Kako bi tajmer 0 radio moramo da ga aktiviramo preko TCON, odnosno TR0
;Kako bi generisali pravougaoni impuls koristimo komandu CPL koja komplementira trenutnu vrednost na tom pinu
;Adresa prekida nastalog zbog tajmer 0 je 8*x+3=11=B

$NOMOD51
$INCLUDE(REG51.INC) ;ukljucujemo biblioteke za rad
PROGRAM SEGMENT CODE
	RSEG PROGRAM ;relokatibilni deo memorije
main:
	mov IE,#82H ;inicijalizacija prekida
	mov TMOD,#02H ;inicijalizacija tajmera
	mov TL0,#-100 ;podesavanje takta
	mov TH0,#-100
	setb TR0 ;pocetak rada tajmera
petlja:
	mov C,P1.7 ;stanje pina smestamo u CARRY FLAG
	mov P1.0,C ;potom vrednost iz CARRY FLAG premestamo na pin P1.0
	sjmp petlja ;beskonacna petlja koja se izvrsava sve dok se ne desi neki prekid

cseg at 000BH ;lokacija prekida za tajmer 0
greska:
	cpl P2.5 ;generisemo pravougaoni signal na pinu P2.5
	clr TF0 ;brisemo statusni fleg za tajmer 0 kako ne bi bespotrebno opet generisalo
	reti ;povratak u glavni program
end