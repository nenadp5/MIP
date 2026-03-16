;TEKST ZADATKA: Napisati program (potprogram, rutinu) na asemblerskom jeziku A51 kojim se realizuje konverzija binarnog broja smeštenog u akumulator u odgovarajući sedmosegmentni cifarski kod korišćenjem look – up tabele.

PUBLIC konvBINtoSEG ;definisemo podprogram kao globalnu
PROGRAM SEGMENT CODE ;obavljamo rezervisanje memorije
	using 0 ;oznacava da koristimo prvu registarsku banku 0
	RSEG PROGRAM ;RSEG znaci da je relokatibilni tip memorije

konvBINtoSEG:
	mov DPTR, #TABLE ;u registar DPRT smestamo adresu pocetka tabele
	mov A,#6 ;test vrednost
	movc A,@A+DPTR ;koristimo "movc" jer nam je lookup tabela smestena u ROM memoriji, takodje se obavlja indeksno adresiranje
	ret ;obavezan deo za povratak u glavni program
	
TABLE: ;lookup tabela koja omogucava normalan rad sedmosegmentnog displeja
	DB 7Eh
	DB 30h
	DB 6Dh
	DB 79h
	DB 33h
	DB 5Bh
	DB 5Fh
	DB 70h
	DB 7fh
	DB 73h
	
END ;kraj glavnog programa