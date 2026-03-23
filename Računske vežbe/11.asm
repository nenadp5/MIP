;TEKST ZADATKA: Napisati sekvencu instrukcija kojom inicijalizujemo serijski port da radi u 8-bitnom režimu rada UART-a na bitskoj brzini od 2400 bps. 
;Pretpostavimo da se mikrokontroler 8051 taktuje kristalom frekvencije 12 MHz, a da se takt bitske brzine generiše korišćenjem tajmera T1.​

;Prvo moramo da nadjemo TH1 preko formule i da proverimo kako ce njegovo zaokruzivanje uticati na Baud Rate, gde odstupanje ne sme biti vece od 2%
;Formula: Baud Rate=(2^smod / 32) * (Fkristala / (12*(256-TH1)) | Baud Rate=dato u tekstu | smod=0 | Fkristala=dato u tekstu | TH1=trazimo i zaokruzujemo na prvi priblizni broj
;Ukoliko odstupanje Baud Rate-a bude vece od 2% onda se ne pise program za inicijalizaciju.

;UART - 8 bitni rezim rada i podesavamo u SCON registru. Sadrzaj SCON registra je 01010000 odnosno #50h
;Tajmer T1 - sa 8 bitnim autoreload funkcijom i podesavamo u TMOD registru. Sadrzaj TMOD registra je 00100000 odnosno #20h
;Podesavamo TR1 kako bi tajmer uopste radio (direktno podesavamo u TCON) 

PROGRAM SEGMENT CODE
	RSEG PROGRAM ;relokatibilni deo memorije
init:
	mov SCON,#50h ;inicijalizujemo sadrzaj registra SCON za UART
	mov TMOD,#20h ;inicijalizujemo sadrzaj TMOD registra za tajmer
	mov TH1,#243 ;podesavamo TH1 da imamo odgovarajuce kasnjenje
	setb TR1 ;ukljucujemo tajmer
end
