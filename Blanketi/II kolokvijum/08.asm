;Program je u potupunosti isti kao 8 zadatak sa racunskih vezbi
;RLC - Rotate Left With Carry | DJNZ - Decrement And Jump if Not Zero

PROGRAM SENZOR
PUBLIC _OCITAVANJE_ ;program se moze koristiti i u okviru drugih programskih jezika jer je pocinje sa "_"
clk EQU P1.2 ;pinove vezujemo za imena radi lakse orjentacije
out EQU P1.3
cs EQU P1.4
PROGRAM SEGMENT CODE
	RSEG PROGRAM ;relokatibilni deo memorije
_OCITAVANJE_:
	clr cs ;podesavamo da pocnemo od niskog nivoa
	clr clk
	
	setb clk
	clr clk ;preko setb i clr CLOCK signala simuliramo prvi takt
	setb clk
	clr clk ;preko setb i clr CLOCK signala simuliramo drugi takt
	setb clk
	clr clk ;preko setb i clr CLOCK signala simuliramo NULL takt
	
	mov R3,#08H ;broj elemenata smestamo u R3, smestamo 8 jer je toliko maksimalna vrednost registra
	call petlja ;pozivamo petlju za ucitavanje
	mov R0,A ;smestamo ucitani rezultat u odgovarajuci registar
	mov R3,#04H ;upisujemo 4 u brojacki registar R3, mora 4 jer nam je potreban 12-bitni podataka a mi smo vec ucitali 8
	clr A ;brisemo prethodni sadrzaj radi ispravnog unosa
	call petlja ;pozivamo petlju za ucitavanje
	swap A ;postavljamo na visi nibl kako bi zadovoljili uslov levog poravnanja
	mov R1,A ;rezultat smestamo u odgovarajuci registar
	setb cs ;podesavamo sve na visok nivo
	ret
petlja:
	setb clk
	clr clk ;preko setb i clr CLOCK signala simuliramo ucitavanje podatka
	mov C,out ;upisujemo prvo podatak u CARRY FLAG
	rlc A ;rotiramo levo zajedno sa CARRY FLAG-om
	djnz R3,petlja ;smanjujemo brojacki registar i sve dok ne bude 0 petlja se vrti
	ret ;povratak u glavni program
end ;kraj programa