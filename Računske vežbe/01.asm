;TEKST ZADATKA: Napisati potprogram na A51 asemblerskom jeziku koji vrši konverziju binarnog broja (0–9) smeštenog u akumulator u sedmosegmentni kod korišćenjem look-up tabele. Pristup tabeli mora se realizovati korišćenjem PC registra (program counter).​

PUBLIC konvBINtoSEG ;definisemo potprogram
PROGRAM SEGMENT CODE ;obavljamo rezervisanje memorije
	using 0 ;koristimo registarsku banku 0
	RSEG PROGRAM ;nagovestavamo da je u pitanju relokatibilni tip memorije
	
konvBINtoSEG:
	mov A,#6 ;test vrednost
	inc A ;uvecavamo za 1, kako bi se izbegla operacija ret, obavezno je brojanje koraka do tabele jer radimo sa PC registrom
	movc A,@A+PC ;pristupamo tabeli uz pomoc PC registra 
	ret ;naredba za povratak u glavni program
	
TABLE: DB 7Eh,30h,6Dh,79h,33h,5Bh,5Fh,70h,7Fh,73h ;drugaciji nacin zapisa lookup tabele

END ;kraj glavnog programa