;TEKST ZADATKA: Napisati program (potprogram, rutinu) na asemblerskom jeziku A51 koji će izvršiti konverziju 8-bitnog binarnog broja smeštenog u akumulator u trocifreni BCD broj i smestiti ga u memoriju u tzv. pakovanom BCD formatu. 
;Takođe, potrebno je ispisati cifre na sedmosegmentni displej (zajednička katoda) povezan na port P0.​
;Cifru stotine treba smestiti na memorijsku adresu STOT, dok cifre desetice i jedinice treba smestiti u pakovanom formatu na memorijsku adresu DESJED.​
;Prvo ispisati cifru stotina, zatim cifru desetica, i na kraju cifru jedinica.

;Nakon poziva metode "display" u registru A bice smestena hexa vrednost broja iz lookup tabele, a ne prethodna vrednost.
;Zbog toga moramo pre poziva potprograma u pomocni registar (R1 ili R0) da smestimo prethodnu vrednost akumulatora A,
;kako bi kasnije mogli da je vratimo i normalno koristimo kao da nije doslo do promene.

NAME KONVERZIJA ;naziv programa
PUBLIC KONVERZIJA,STOT,DESJED ;globalne promenljive
PROGRAM SEGMENT CODE
	RSEG PROGRAM ;rezervacija segmenta za program
PODACI SEGMENT DATA
	RSEG PODACI ;rezervacija segmenta za podatke
	STOT: DS 1 ;rezervacija 1 bajta za promenljivu STOT
	DESJED: DS 1 ;rezervacija 1 bajta za promenljivu DESJED
	
KONVERZIJA:
	mov DPTR,#TABLE ;vezujemo DPTR za tabelu, u A je vec smestena neka vrednost sto je receno u tekstu zadatka
	mov B,#100 ;u B upisujemo 100
	div AB ;delimo A i B i dobijamo cifru stotine u A i ostatak u B
	mov STOT,A ;vrednost stotine iz A se smesta u promenljivu STOT
	call display ;poziva se metoda za prikaz cifre na sedmosegmentnom displeju
	
	mov A,B ;ostatak iz prethodnog deljenja se smesta u registar A
	mov B,#10 ;u B se upisuje 10 kako bi kasnije kroz deljenje mogli da izvucemo ostale cifre
	div AB ;delimo A i B
	mov R0,A ;u RO pamtimo cifru desetice kako se kasnije ne bi promenila
	call display
	
	mov A,R0 ;vracamo sacuvanu vrednost desetice
	swap A ;prebacamo u veci nibl vrednost smestenu u registru A
	mov R0,A ;ponovo pamtimo da ne bi doslo do gubljenja podatka
	
	mov A,B ;cifra jedinice se upisuje u registar A
	mov R1,A ;pamtimo u rezervnom registru kako vrednost ne bi izgubili prilikom poziva funkcije za prikaz
	call display
	
	mov A,R1 ;vracamo sacuvane vrednosti
	add A,R0 ;sabiramo kako bi dobili celokupni podatak desetice i jedinice
	mov DESJED,A ;smestamo u odgovarajucu promenljivu
	ret
	
display:
	movc A,@A+DPTR ;pristupamo lookup tabeli preko DPTR registra i vrednosti smestenoj u A
	mov P0,A ;vrednost A koja je HEXA notacija odgovarajuce cifre se ispisuje na pinu za sedmosegmentni displej
	ret ;povratak u glavni program
	
TABLE: DB 7Eh,30h,6Dh,79h,33h,5Bh,5Fh,70h,7Fh,73h ;lookup tabela za zajednicku katodu

END