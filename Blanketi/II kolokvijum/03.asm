;Podesavamo da tajmer T0 radi u 8-bitnom rezimu rada u okviru TMOD registra, sadrzaj registra ce biti 00000010=#02H
;Odobravanje prekida za tajmer T0 u okviru registra IE, cije ce sadrzaj biti 10000010=#82H
;Kada je faktor ispune 25%, onda nema potrebe za racunanjem kao u prethodnom slucaju, vec direktno manipulisemo sa 200*10^-6s u okviru THO i TL0 
;200*0.25=50*10^-6=THIGH | 200-50=150*10^-6=TLOW - ove vrednosti direktno upisujemo u registra TH0 i TL0, sa tim sto pocinjemo od niskog nivoa

$NOMOD51
$INCLUDE(REG51.INC) ;ukljucujemo biblioteku za rad
PROGRAM SEGMENT CODE
	RSEG PROGRAM ;relokatibilni deo memorije
main:
	mov IE,#82H ;inicijalizacija prekida
	mov TMOD,#02H ;inicijalizacija tajmera
	clr P2.5 ;namestamo da pocnemo sa niskim nivoom
	mov TH0,#-150 ;parametri za nizak nivo
	mov TL0,#-150
	setb TR0 ;aktiviramo tajmer
petlja:
	mov c,P1.7 ;beskonacna petlja koja ocitava vrednost sa jednog pina i smesta u drugi uz pomoc CARRY FLAG
	mov P1.0,C 
	sjmp petlja ;vrti se petlja, a ako se desi neki prekid mikrokontroler reaguje

cseg at 0008H ;desi se prekid za tajmer 0
greska1:
	cpl P2.5 ;menjamo stanje na pinu P2.5 i vrsimo proveru kasnije kako bi ispravno generisali signal
	jnb P2.5,nizak_nivo ;ako je 0(nisko) skace se na vrednost koja definise nisko stanje (odnosno 150). Ako je 1(visoko) stanje, onda sledi podesavanje parametara za visok nivo

visok_nivo:
	mov TH0,#-50 ;parametri za visok nivo
	reti
nizak_nivo:
	mov TH0,#-150 ;parametri za nizak nivo
	reti ;povratak u glavni program
end

;Kod MODE2 tajmer se samo puni preko TH0