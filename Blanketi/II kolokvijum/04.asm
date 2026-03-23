;Zadatak je isti kao 9 zadatak sa racunskih vezbi, samo promenjene brojke

;F=11059200Hz Fmc=F/12=921600Hz Tmc=1/921600=1.085*10^-6
;Receno je da je frekvencija takta 1000Hz, odnosno T=1/1000=1ms gde ce jedan blok biti 500*10^-6
;Broj taktova je 500*10^-6/1.085*10^-6=461 takta
;Tajmer 0 radi u 16-bitnom rezimu rada: TMOD, #01H

mov TMOD,#00000001B ;omogucava odgovarajuci rezim rada tajmera
main:
	setb P1.0 ;podesavamo visok nivo
	acall kasnjenje ;pozivamo metodu koja simulira kasnjenje
	clr P1.0 ;podesavamo nizak nivo
	acall kasnjenje ;pozivamo metodu koja simulira kasnjenje, acall pamti odakle se pozvao program i kad se zavrsi tacno se tu vraca
	sjmp main ;vrti se petlja
kasnjenje:
	mov TH0,#-461 ;upisujemo vrednost koju smo izracunali, sa predznakom minus jer simulira kasnjenje
	mov TL0,#-461
	setb TR0 ;startujemo tajmer
provera:
	jnb TF0,provera ;ako je TF0=0 znaci da tajmer0 nije prelio i moze da se vrti petlja
	clr TF0 ;kada TF0=1 restartuje se vrednost za fleg i sam tajmer
	clr TR0
	setb P1.0 ;podesavamo ponovo visok nivo na pinu
	ret ;povratak u glavni program
end