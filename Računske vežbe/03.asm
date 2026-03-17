;TEKST ZADATKA: Napisati program (potprogram, rutinu) na asemblerskom jeziku A51 koji konvertuje niz od 5 BCD cifara u ASCII kod koristeći osobinu ASCII prezentacije cifara od 0 do 9. 
;Prenos parametara se vrši preko niza, a nizu se obraćamo registarski indirektnim načinom adresiranja sa početnom adresom smeštenom u registar R1.​


;PRVI NACIN: Jedan niz - dobijena vrednost se prepisuje preko stare
;Indirektno-registarsko adresiranje je oblika ADD A,@R0
;Kada imamo indirektno-registarski nacin adresiranja pokazivaci su nam registri R0 i R1, tako da mozemo imati maksimum dva niza

;Naredba DJNZ (Decrement And Jump if Not Zero) obavlja dekrementiranje registra i skace na datu labelu sve dok registar ne bude jednak nuli
;ASCII vrednost dobijamo tako sto cifru saberemo sa +30H

NAME konvBCDtoASCII ;naziv programa
PUBLIC konverzijaBCDtoASCII ;globalno vidljiva funkcija
konverzija SEGMENT CODE
	RSEG konverzija ;rezervacija dela memorije

konverzijaBCDtoASCII:
	mov R5,#05 ;broj elemenata niza smestamo u registar R5
petlja:
	mov A,@R1 ;ucitavamo prvi broj u nizu u registar A (elementi niza su smesteni u registar R1)
	add A,#30H ;vrsimo njegovo konvertovanje u ASCII karakter
	mov @R1,A ;vracamo na mesto u njegovom nizu
	inc R1 ;prelazimo na sledeci element u nizu
	DJNZ R5, petlja ;smanjujemo vrednost brojackog elementa i ako nije 0 ponovo se izvrsava petlja
	ret ;povratak u glavni program
end ;kraj programa

;--------------------------------------------------------------------------------------------------------------------

;DRUGI NACIN: Dva niza - cuvamo vrednosti koje smo konvertovali, kao i stare
;R0 - odredisni niz (tu smestamo rezultat)
;R1 - izvorisni niz (odatle uzimamo elemente)

NAME konverzijaBCDtoASCII2 ;naziv programa
PUBLIC konvBCDtoASCII2 ;globalno vidljivi elementi
PUBLIC BUFFER
PROGRAM SEGMENT CODE
PODACI SEGMENT IDATA ;deo podataka smesten u IRAM deo memorije
	RSEG PODACI
	BUFFER: DS 5 ;BUFFER zauzima 5 bajta
	RSEG PROGRAM ;relokatibilni deo memorije
	
konvBCDtoASCII2:
	mov R5,#5 ;u registar R5 smestamo broj elemenata u nizu
	mov R0,#BUFFER ;registar R0 vezujemo za odredisni niz odnosno promenljivu BUFFER
petlja:
	mov A,@R1 ;uzimamo prvu vrednost iz izvorisnog niza
	add A,#30H ;sabiramo kako bi dobili odgovarajuci ASCII karakter
	mov @R0,A ;rezultat smestamo u odredisni registar R0
	inc R0 ;prelazimo na sledeci element u nizu 
	inc R1 ;prelazimo na sledeci element u nizu
	DJNZ R5,petlja ;smanjujemo vrednost brojackog elementa, i ako nije 0 ponovo se izvrsava petlja
	ret
end