;TEKST ZADATKA: Napisati program (potprogram, rutinu) na asemblerskom jeziku A51 kojim se realizuje konverzija binarnog broja smeštenog u akumulator u odgovarajući sedmosegmentni cifarski kod korišćenjem look – up tabele.​
;Sedmosegmentni displej je realizovan sa zajedničkom anodom.​ Samostalno odlučite koji način želite da korsitite.

PUBLIC konvBINtoSEG ;definisemo podprogram kao globalni element
PROGRAM SEGMENT CODE ;obavljamo rezervisanje memorije
	using 0 ;oznacava da koristimo prvu registarsku banku 0
	RSEG PROGRAM ;RSEG znaci da je relokatibilni tip memorije

konvBINtoSEG:
	mov DPTR, #TABLE ;u registar DPRT smestamo adresu pocetka tabele
	mov A,#6 ;test vrednost
	movc A,@A+DPTR ;koristimo "movc" jer nam je lookup tabela smestena u ROM memoriji, takodje se obavlja indeksno adresiranje
	ret ;obavezan deo za povratak u glavni program
	
TABLE: ;lookup tabela sa zajednickom anodom koja omogucava normalan rad sedmosegmentnog displeja
	DB 81h
	DB CFh
	DB 92h
	DB 86h
	DB CCh
	DB A4h
	DB A0h
	DB 8Fh
	DB 80h
	DB 84h
	
END ;kraj glavnog programa