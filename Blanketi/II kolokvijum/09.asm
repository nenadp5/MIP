;F=12MHz Fmc=F/12=1MHz
;Kako je frekvencija takta 400Hz, onda je T=1/400=2500s i kada se to podeli na jedan blok onda je 1250
;Buduci da je broj taktova 1250 onda se koristi 16-bitni tajmer0, cije podesavanje vrstimo u TMOD registru, vrednost mu je 00000001=#01H
;Da bi odobrili prekid putem tajmera i INT0 vrsimo podesavanje u IE registru, vrednost je 10000011=#83H
;Posto imamo samo jedan prekid onda za njega podesavamo da bude aktivan na opadajucu ivicu SETB IT0

$NOMOD51
$INCLUDE(REG51.INC) ;ukljucujemo biblioteke za normalan rad
NAME ZADACI
PROGRAM SEGMENT CODE
	RSEG PROGRAM ;relokatibilni deo memorije
main:
	mov IE,#83H ;odobravamo odgovarajuce prekide
	mov TMOD,#01H ;podesavamo tajmer u odgovarajuci rezim rada
	setb IT0 ;aktivno na opadajucu ivicu 
	mov TH0,#-1250 ;odgovarajuci broj taktova za tajmer
	mov TLO,#-1250
	clr P1.7 ;brisemo bilo kakve vrednosti za tajmer i zvucnik pre pocetka rada
	clr TR0
petlja:
	jb P1.0,stop_alarm ;proveravamo da li je taster P1.0(pull-down) jedinica, ako jeste signalizira gasenje alarma
	sjmp petlja ;u suprotnom ako je P1.0=0 petlja se samo vrti
stop_alarm:
	clr TR0 ;gasimo tajmer i zvucnik, odnosno stopira se alarm
	clr P1.7
	sjmp petlja
CSEG AT 0003H ;lokacija za prekid INT0
prekid_int0:
	setb TR0 ;aktivira se alarm u vidu singnala na zvucniku, a taj signal dobijamo pomocu tajmera
	reti
CSEG AT 000BH ;lokacija prekida za tajmer0
prekid_tajmer:
	cpl P1.7 ;generise pravougaoni talasni signal uz pomoc komande cpl
	mov TH0,#-1250 ;upisujemo stare vrednosti za svaki slucaj 
	mov TLO,#-1250
	reti
end

;Kada se desi INT0 (sto predstavlja aktiviranje alarma) u isto vreme se desi alarm koji generise prekid na svakih 1250us
;U prekidnoj rutini za tajmer menjamo stanje pina (CPL), pa tako dobijamo signal frekvencije 400Hz i faktorom ispune 50%