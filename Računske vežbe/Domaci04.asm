;TEKST ZADATKA: Napisati potprogram na asemblerskom jeziku A51 koji konvertuje niz od 8 BCD cifara u ASCII kod, koristeći osobinu ASCII reprezentacije cifara od 0 do 9. Prenos parametara vrši se preko niza, pri čemu se nizu pristupa registarski indirektnim načinom adresiranja, sa početnom adresom smeštenom u registru R1. 
;Pre konverzije, svaku cifru potrebno je prikazati na sedmosegmentnom displeju sa zajedničkom katodom koji je povezan na port P0. Konvertovane vrednosti treba smestiti u poseban bafer.​

NAME DOMACI4 ;dodeljujemo naziv
PUBLIC konverzija_i_prikaz ;elemente cinimo globalno vidljivim i u nastavku obavljamo rezervaciju memorije
PUBLIC BUFFER
PROGRAM SEGMENT CODE
PODACI SEGMENT IDATA
	BUFFER: DS 8 ;rezervisemo 8 bajtova za odredisni niz
	RSEG PODACI
	RSEG PROGRAM
konverzija_i_prikaz: 
	mov R5,#8 ;broj elemenata niza smestamo u R5 sto predstavlja brojacki registar u ovom slucaju
	mov R0,#BUFFER ;R0 vezujemo za odredisni niz
petlja:
	mov A,@R1 ;uzimamo prvi element iz izvorisnog niza
	mov DPTR,#TABLE ;vezujemo lookup tabelu za DPTR registar
	movc A,@A+DPTR ;pristupamo lookup tabeli i uzimamo element koji odgovara vrednosti smestenoj u A
	mov P0,A ;prikazujemo rezultat na displeju koji je povezan na port P0
	
	mov A,@R1 ;ponovo uzimamo element iz izvorisnog niza jer je u A smestena HEXA vrednost elementa, sto nam sada nije potrebno
	add A,#30H ;obavljamo konverziju sto se i trazi u zadatku
	mov @R0,A ;konvertovanu vrednost smestamo u odredisni niz
	
	inc R0 ;prelazimo na sledeci element u nizu
	inc R1
	DJNZ R5, petlja ;smanjujemo vrednost brojackog elementa za 1 i ako nije 0 ponovo se izvrsava petlja
	ret
	
TABLE: DB 7Eh,30h,6Dh,79h,33h,5Bh,5Fh,70h,7Fh,73h ;lookup tabela za displej sa zajednickom katodom

end