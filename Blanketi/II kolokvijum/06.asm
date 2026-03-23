;Realizujemo tajmer T0 u 8-bitnom auto-reload rezimu u okviru TMOD registra, vrednost je 00000010=#02H
;Odobravamo prekide za tajmer T0 u okviru IE registra, vrednost je 10000010=#82H
;Odobravamo rad tajmera T0 preko TCON registra, jednostavim setovanjem bita TR0

;Perioda je 200*10^-6s, a u zadatku se trazi 25%, tako da ce podesavanja za TH0 i TL0 biti
;200*0.25=50*10^-6=THIGH | 200-50=150*10^-6=TLOW - ove vrednosti direktno upisujemo u registra TH0 i TL0, sa tim sto pocinjemo od niskog nivoa

$NOMODE51
$INCLUDE(REG52.INC) ;ukljucujemo biblioteke za rad mikrokontrolera
NAME ALARM ;naziv programa
PROGRAM SEGMENT CODE
	RSEG PROGRAM ;relokatibilni deo memorije
main:
	mov IE,#82H ;inicijalizacija IE registra za prekide
	mov TMOD,#02H ;podesavanje tajmera0 u 8-bitnom rezimu
	clr P2.5 ;krecemo od niskog nivoa
	setb TR0 ;aktiviramo tajmer
	mov TH0,#-150 ;podesavamo pocetne parametre za nizak nivo
	mov TL0,#-150
petlja:
	mov C,P1.7  ;beskonacna petlja koja omogucava preslikavanje sa ulaznog pina na izlazni uz pomoc carry flaga
	mov P1.0,C
	sjmp petlja ;petlja ce se vrtiti sve dok se ne desi prekid na koji mikrokontroler reaguje
CSEG AT 000BH ;adresa za prekid tajmera 0
greska:
	cpl P2.5 ;generisemo pravougaoni signal, odnosno menja se prethodno stanje 
	jnb P2.5,nizak_nivo ;ako je P2.5=0 onda je nizak nivo i podesavaju se parametri za nizak nivo. Kako bi u sledecoj iteraciji imalo ispravnu promenu na visok nivo
visok_nivo:
	mov TH0,#-50 ;podesavanje parametara za visok nivo
	reti
nizak_nivo:
	mov TH0,#-150 ;podesavanje parametara za nizak nivo, promene se vrse samo nad TH0
	reti
end