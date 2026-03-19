;TEKST ZADATKA: Projektovati sistem (nacrtati šemu i napisati program na asemblerskom jeziku A51) za kontrolu peći koristeći uslužno prekidne rutine (ISR) za obradu prekida tipa spoljašnji (eksterni) prekidi. 
;Kontrola peći se ostvaruje praćenjem temperature u opsegu (20 +- 1) stepeni putem senzora koji generišu odgovarajuće okidačke (trigger) impulse kada dođe do detektovanja definisanih limita vrednosti (minimalna 19 stepeni i maksimalna vrednost 21 stepen)

;Pinovi koji su korisceni ali nisu naznaceni u tekstu zadatka:
;P1.7 kontrola peci (P1.7=0 pec je iskljucena, P1.7=1 pec je ukljucena)
;P3.2-INT0 prekid | P3.3-INT1 prekid
;Koristimo registar IE koji je namenjen za podesavanje prekida, tako da treba pogledati fajl u kome su objasnjeni prekidi
;Kada se trazi opadajuca ivica onda se vrsi setovanje bitova IT0 i IT1 (setb IT0 \ setb IT1)
;Kada se trazi nizak nivo onda se kliruju bitovi IT0 i IT1 (clr IT0 \ clr IT1)

$NOMOD51
$INCLUDE(REG52.INC) ;ukljucujemo biblioteke za normalan rad
PROGRAM SEGMENT CODE
	CSEG AT 0000H ;lokacija pocetka programa
	ljmp START ;skace se na labelu START
	RSEG PROGRAM ;relokatibilni deo memorije
START:
	mov IE,#85h ;u IE registar upisujemo hexa vrednost 85 sto odobrava globalne prekide i prekide EX1 i EX0
	setb IT0 ;podesavamo da reaguje na opadajucu ivicu
	setb IT1 ;podesavamo da reaguje na opadajucu ivicu
	setb P1.7 ;podesavamo da je pec ukljucena
	
	jb P3.2,skip ;ako je pin P3.2=1 sto znaci da nije HOT onda se skace na labelu SKIP
	clr P1.7 ;ako je pin P3.2=0 onda je HOT i pec se iskljucuje

skip: ;kada skoci na labelu skip onda se vrti beskonacna petlja
	sjmp skip ;dok se vrti beskonacna petlja moze se generisati prekid i onda ce mikrokontroler skociti na odgovarajucu lokaciju za obradu prekida
	
	cseg at 0003H ;desio se prekid na lokaciji za EX0
EX0_ISR: 
	clr P1.7 ;detektuje prekid na P3.2 sto predstavlja HOT (preko 21 stepen) i onda se gasi pec povezana na pin P1.7
	reti
	
	cseg at 0013H ;desio se prekid na lokaciji EX1
EX1_ISR:
	setb P1.7 ;detektuje prekid na P3.2 sto predstavlja COLD (ispod 19 stepeni) i pali P1.7 pec
	reti

end

;Lokacije prekida se dobijajo po formuli 8*x+3, gde je X broj prekida, odnosno
;Spoljasnji prekid 0 - EX0 | x=0 | lokacija=8*x+3=0003H
;Tajmer 0 | x=1 | lokacija=8*x+3=000BH
;Spoljasnji prekid 1 - EX1 | x=2 | lokacija=8*x+3=0013H
;Tajmer 1| x=3 | lokacija=8*x+3=001BH
;Serijski prenos (UART)| x=4 | lokacija=8*x+3=0023H
;Tajmer 2 | x=5 | lokacija=8*x+3=002BH
