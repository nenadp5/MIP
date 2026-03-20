;TEKST ZADATKA: Napisati program na asemblerskom jeziku A51 za analizu tastature veličine 8 * 8 tastera pomoću mikrokontrolera uz pamćenje prethodno i tekuće očitanog stanja u unutrašnjoj memoriji za podatke.
;To podrazumeva da su nam neophodna dva bloka podataka od po 8 B (dva bafera). Jedan za prethodno očitanu vrednost i jedan za tekuće očitanu vrednost.

;Cilj ovog zadatka je da procitamo stanje sa tastature i smestimo u odgovarajuci bafer
;Kako je tastatura prevelika radi se uz pomoc metode "setajuca nula"

NAME TASTATURE ;naziv programa
PUBLIC OLDBUFF, NEWBUFF ;definisemo globalne promenljive
PROGRAM SEGMENT CODE
	ISEG at 80H ;memorijska lokacija u IRAM delu memorije
	 OLDBUFF: DS 8 ;rezervisemo 8 bajtova
	ISEG at 88H ;sledeca memorijska lokacija u IRAM delu memorije 
	 NEWBUFF: DS 8 ;rezervisemo 8 bajtova
RSEG PROGRAM ;relokatibilni deo memorije

scan:
	mov R0,#NEWBUFF ;registar R0, vezujemo za novi bafer
	mov R1,#OLDBUFF ;registar R1, vezujemo za stari bafer
	mov A,#01111111B ;u registar A upisujemo cifru za koju primenjujemo princip setajuce nule
scan1:
	mov P0,A ;upisujemo masku na prvi port
	rr A ;rotiramo u desno vrednost koja je smestena u A (setajucu nulu), odnosno prvi put ce biti 10111111
	mov R2,A ;u R2 smo zapamtili trenutnu vrednost A, jer ce kasnije u toku programa biti promenjena
	mov A,P2 ;ucitavamo stanje sa porta P2 sto predstavlja tastaturu
	xch A,@R0 ;primenjujemo operaciju zamene EXCHANGE (xch) gde menjamo vrednosti iz A i novog bafera 
	mov @R1,A ;u A nam je smestena vrednost iz novog bafera, i preko komande mov je smestamo u stari bafer
	inc R0 ;prelazimo na sledece elemente i mesta u baferima
	inc R1
	mov A,R2 ;ucitavamo prethodno sacuvanu vrednost u A kako bi mogli da odredimo koje je stanje setajuce nule
	jb ACC.7,scan1 ;proveravamo da li je cifra najvece tezine u registru A jedinica, ako jeste onda se ponovo izvrsava labela, jer jos ima elemenata
	ret ;povrataka u glavni program
end

;kod kombinacije XCH i MOV imamo bas ono sto se trazi u zadatku, preko XCH nova vrednost ocitana sa porta i smestena u A se premesta u novi bafer, dok se vrednost iz novog bafera smesta u A
;vrednost smestena u A je vec postala stara vrednost i preko komande MOV se smesta u stari bafer
