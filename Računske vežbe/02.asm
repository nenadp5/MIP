;TEKST ZADATKA: Napisati program (potprogram, rutinu) na asemblerskom jeziku A51 za konverziju 8 – bitnog binarnog broja smeštenog u akumulator, u trocifreni BCD broj i smestiti ga u memoriju u tzv. pakovanom BCD formatu. 
;Cifru stotine smestiti na adresu STOT, a cifru desetice i cifru jedinice smestiti na adresu DESJED.​

;Imamo pojavu nibla koji predstavlja skup od 4 bita
;Prisutni su standardni relokatibilni segmenti za program i podatke
;U ovom zadatku neophodno je da lokalno rezervisemo potreban memorijski prostor sa adresama STOT i DESJED velicine 1 bajt.
;Kako bi bile globalno vidljive koristimo komandu PUBLIC

NAME BINtoBCD ;naziv programa
PUBLIC BINBCD, STOT, DESJED ;globalno vidljivi elementi
PODACI SEGMENT DATA ;segment za podatke
PROGRAM SEGMENT CODE ;segment za program
	RSEG PODACI ;relokatibilni deo memorije
	STOT: DS 1 ;rezervisemo 1 bajt za promenljivu STOT 
	DESJED: DS 1 ;rezervisemo 1 bajt za promenljivu DESJED
	RSEG PROGRAM
	
BINBCD:
	mov A,#255 ;upisujemo test vrednost u A
	mov B,#100 ;upisujemo 100 u B
	div AB ;delimo A i B, odnosno izdvajamo cifru stotine (A=2 B=55)
	mov STOT, A ;rezultat deljenja je smesten u A, sto kasnije prenosimo u promenljivu STOT, ostatak deljenja je u B
	
	mov A,B ;sada ostatak prethodnog deljenja smestamo u A
	mov B,#10 ; u B upisujemo 10
	div AB ;delimo A i B i dobijamo cifru desetice i jedinice (A=5/0000 0101 B=5/0000 0101)
	
	swap A ;nakon ovoga ce cifra desetice biti upisana u visi nibl, odnosno A=0101 0000
	add A,B ;kada saberemo A i B dobijamo 0101 0101
	
	mov DESJED,A ;prethodno dobijenu vrednost smestamo u promenljivu DESJED
	ret ;povratak u glavni program
	
END