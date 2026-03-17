;TEKST ZADATKA: Napisati program (potprogram, rutinu) na asemblerskom jeziku A51 za nalaženje proizvoda dveju BCD cifara smeštenih u akumulator (pakovani BCD). Prenos parametara se vrši putem akumulatora. 
;Rezultat prikazati kao BCD broj takođe u pakovanom formatu i putem akumulatora ga preneti programu koji poziva navedenu rutinu. Prenos (vraćanje) rezultata realizovati putem akumulatora.​

;Objasnjenje za pakovani BCD format:
;mov a,#00110101B, posmatramo po 4 bita i te vrednosti kao posebne, u ovom slucaju ce biti 3(0011) i 5(0101)
;(00110101)=53, trebamo podeliti sa 16 kako bi dobili odgovarajuce pakovane cifre
;visa cifra=acc/16
;niza cifra=acc mod 16

;primer za 56 u pakovanom fomatu je 0101 0110
;dok je (01010110)=86 to kada podelimo sa 16 dobijamo 5 i ostatak 6
;5*16=80+6=86

PUBLIC START ;globalno vidljiv program
PROGRAM SEGMENT CODE
	RSEG PROGRAM ;relokatibilni tip memorije
START:
	mov A,#00110101B ;upisujemo vrednost u A (binarnom notacijom), u ovom slucaju je 53
	mov B,#10H ;upisujemo 10H ili 16 u registar B
	div AB ;delimo A i B kako bi dobili cifre (A=3 B=5)
	mul AB ;mnozenje izdvojenih cifara, ono sto se i trazi u zadatku
	
	mov B,#10 ;u B upisujemo 10 kako bi uspesno izdvojili cifru desetice i jedinice
	div AB ;izdvajamo cifre desetice i jedinice (A=1/0000 0001) (B=5/0000 0101)
	swap A ;sredjujemo cifru desetice kako bi bila u visem niblu A(0001 0000)
	add A,B ;sabiramo cifre desetice i jedinice kako bi ih dobili kao jednu celinu (A+B=0001 0101)
	ret ;povratak u glavni program
end ;kraj programa

;Uz pomoc prvog DIV dobijamo cifre iz pakovanog BCD formata
;mul AB - mnozimo te cifre, ono sto se trazi u zadatku, ali nakon toga ide sredjivanje kako bi mogli da ih spakujemo u nibl
;kod obavljanja operacije swap trebamo posmatrati binarnu notaciju tih brojeva