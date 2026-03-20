;TEKST ZADATKA: Napisati potprogram na asemblerskom jeziku A51 koji pronalazi proizvod dveju BCD cifara koje su smeštene u pakovanom formatu, pri čemu se registri u kojima se nalaze pakovane cifre nalaze u nizu podataka. 
;Niz sadrži 5 registara, a svaka dva pakovana BCD broja (po dve cifre u jednom registru) treba uzeti iz niza i izračunati njihov proizvod. Prenos parametara vrši se preko niza, a nizu se pristupa registarski indirektnim načinom adresiranja, sa početnom adresom smeštenom u registar R1.
;Pre izvođenja operacije množenja, potrebno je svaku BCD cifru ispisati na sedmosegmentnom displeju sa zajedničkom katodom koji je povezan na port P0. Nakon što se izračuna proizvod, rezultat treba vratiti u BCD formatu (pakovanom) putem novog niza, nazad programu koji poziva ovu rutinu.

;Zadatak predstavlja kombinaciju svih prethodnih, i najvise treba voditi racuna kod cuvanja vrednosti u nekim registrima, da se ne bi izgubili prilikom poziva funkcije za prikaz.

PUBLIC PROIZVOD
PUBLIC BUFFER ;kreiramo globalne promenljive i alokaciju i rezervaciju memorijskog prostora
PROGRAM SEGMENT CODE
	RSEG PROGRAM
PODACI SEGMENT IDATA
	RSEG PODACI
	BUFFER: DS 5

PROIZVOD:
	mov R5,#5 ;broj elemenata smestamo u R5
	mov R0,#BUFFER ;odredisni niz vezujemo za registar R0
	mov DPTR,#TABLE ;tabelu vezujemo za registar DPTR
petlja:
	mov A,@R1 ;ucitavamo podatak iz izvorisnog niza
	mov B,#10H ;u registar B smestamo 10h odnosno 16
	div AB ;delimo A i B kako bi dobili cifre
	mov R2,A ;u R2 smestamo prvu cifru kako je ne bi kasnije prilikom prikaza na displeju izgubili
	call display ;pozivamo metodu za prikaz na sedmosegmentni dislej
	mov A,B ;u A ucitavamo drugu cifru
	mov R3,A ;drugu cifru smestamo u R3 kako je ne bi izgubili tokom prikaza
	call display ;pozivamo metodu za prikaz
	
	mov A,R2 ;vracamo verdnosti u A i B
	mov B,R3
	mul AB ;mnozimo izdvojene cifre, ono sto se i trazi u zadatku
	mov B,#10 ;sada u B upisujemo 10 kako bi mogli lepo da izdvojimo cifre
	div AB ;delimo A i B
	swap A ;vrednost iz A rotiramo da bude u visem niblu uz pomoc funkcije swap
	add A,B ;sabiramo A i B i dobijamo vrednost u pakovanom formatu
	mov @R0,A ;dobijeni rezultat smestamo u odredisni niz
	inc R0 ;prelazimo na sledeci element
	inc R1
	DJNZ R5,petlja ;smanjujemo vrednost brojackog registra za 1 i ako nije 0 onda se ponovo izvrsava petlja
	ret
display:
	movc A,@A+DPTR ;klasicni postupak za uzimanje HEXA vrednosti lookup tabele
	mov P0,A ;prikaz konvertovane vrednosti na odgovarajucem portu
	ret

TABLE: 7Eh,30h,6Dh,79h,33h,5Bh,5Fh,70h,7Fh,73h
