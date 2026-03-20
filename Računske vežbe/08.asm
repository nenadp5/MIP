;TEKST ZADATKA: Projektovati hardver (nacrtati šemu) i napisati program na asemblerskom jeziku A51 kojim se vrši serijsko očitavanje 12-to bitnog podatka sa analognog digitalnog konvertora ADS 7816 koristeci mikrokontroler 8051.

;Sema i objasnjenje za podesavanje CLOCK i CS signala se nalaze u posebnom PDF dokumentu! 
;Buduci da se radi ocitavanje 12 bitnog podatka, onda moramo dva puta da koristimo registar R3, jer je maksimalna vrednost registra 8.
;Prvi put u R3 upisujemo maksimalnu vrednost, dok drugi put upisujemo 4 koliko nam je i potrebno za ocitavanje 12 bitnog podatka
;Imamo prisutno poravnanje uz levu ivicu, i zbog toga je aktivna komanda SWAP i RLC
NAME CITANJE_ADC ;naziv programa
PUBLIC _CITANJE_ADC ;funkcija moze da se koristi i u drugim jezicima zbog toga sto pocinje sa "_"
dout EQU P1.2 ;dodeljujemo imena pinovima uz pomoc komande EQU
clk EQU P1.3
cs EQU P1.4
PROGRAM SEGMENT CODE
	USING 0 ;koristimo registarsku banku 0
	RSEG PROGRAM ;relokatibilni deo memorije

_CITANJE_ADC:
	clr cs ;podesavamo cs i clk signal na nizak nivo
	clr clk
	setb clk
	clr clk ;prvi set i clear clock signal 
	setb clk
	clr clk ;drugi set i clear clock signal
	setb clk
	clr clk ;null set i clear clock signal
	
	mov R3,#08h ;brojacki registar R3 u koji smestamo 8 sto naznacava broj elemenata
	call petlja ;pozivamo funkciju za ucitavanje
	mov R0,A ;ucitanu vrednost smestamo u registar R0
	mov R3,#04h ;brojacki registar R3 u koji smestamo 4 sto naznacava broj elemenata
	clr A ;brisemo prethodni sadrzaj registra A kako bi lepo upisalo nove podatke
	call petlja ;pozivamo funkciju za ucitavanje
	swap A ;premestamo ucitane podatke u visi nibl
	mov R1,A ;i potom smestamo ucitani podatak u odgovarajuci registar
	setb cs ;podizemo visok nivo
	ret
	
petlja:
	setb clk ;simulira clock signal uz pomoc kojeg ucitavamo podatak
	clr clk
	mov c,dout ;smestamo u carry flag ucitani podatak
	rlc A ;preko komande ROTATE LEFT WITH CARRY podatak se smesta u registar A bit po bit
	DJNZ R3,petlja ;smanjujemo vrednost brojackog registra i ako nije 0 onda se ponovo izvrsava petlja za ucitavanje bita podatka
	ret
end