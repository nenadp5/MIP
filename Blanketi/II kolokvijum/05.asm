;Zadatak je isti kao 7 zadatak sa racunskih vezbi, samo sto su date adrese gde se nalaze baferi

$NOMOD51
$INCLUDE(REG51.INC)
NAME TASTATURA
PUBLIC OLDBUFF,NEWBUFF ;definisemo bafere kao globalne
PROGRAM SEGMENT CODE
ISEG AT 00E0H ;deo IRAM memorije i zato koristimo IRAM
	OLDBUFF: DS 8 ;zauzimamo 8 bajtova u memoriji za OLDBUFF
ISEG AT 00E8H
	NEWBUFF: DS 8 ;zauzimamo 8 bajtova u memoriji za NEWBUFF
RSEG PROGRAM ;relokatibilni deo memorije
scan:
	mov A,#01111111B ;pocetna vrednost za setajucu nulu
	mov R0,#NEWBUFF ;povezujemo registre sa baferima
	mov R1,#OLDBUFF
scan1:
	mov P0,A ;smestamo setajucu nulu na odgovarajuci pin
	rr A ;pomeramo nulu u desno, posle prvog prolaska ce biti 10111111B
	mov R2,A ;pamtimo stanje jer nam je potrebno na kraju za proveru
	mov A,P2 ;ucitavamo stanje sa pina P2 (tasture) u registar A
	xch A,@R0 ;preko komande XCH vrsimo smestanje ucitane vrednosti u NEWBUFF, a vrednost iz NEWBUFF smestamo u A
	mov @R1,A ;prethodna vrednost iz NEWBUFF je smestena u A, i ona je automatski postala stara vrednost, pa se preko komande MOV premesta u OLDBUFF
	inc R0 ;prelazimo na sledece elemente
	inc R1
	mov A,R2 ;vracamo vrednost setajuce nule kako bi mogli da utvrdimo da li je kraj
	jb ACC.7,scan1 ;ako je bit najvece tezine 1 znaci da jos ima podataka za ucitavanje i vrti se petlja, dok ako je 0 onda je kraj
	ret ;povratak u glavni program
end ;kraj