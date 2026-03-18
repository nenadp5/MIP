;TEKST ZADATKA: Napisati potprogram na asemblerskom jeziku A51 za konverziju niza od 7 ASCII kodova velikih slova u ASCII kodove malih slova. 
;Prenos parametara se vrši preko niza, a nizu se obraćamo registarsko indirektnim načinom adresiranja sa početnom adresom niza smeštenom u registar R0. Mala slova treba smestiti u poseban bafer.​

;Zadatak je u potpunosti isti kao 03.asm samo sto je ovde konverzija u mala slova.

NAME DOMACI ;naziv programa
PUBLIC KONVERZIJA  ;globalno vidljivi elementi
PUBLIC BUFFER ;globalni element namenjen za odredisni niz
PROGRAM SEGMENT CODE
PODACI SEGMENT IDATA
	 BUFFER: DS 7 ;rezervisemo 7 bajtova u memoriji za odredisni niz
	 RSEG PODACI
	 RSEG PROGRAM ;relokatibilni deo memorije
KONVERZIJA:
	mov R5,#7 ;broj elemenata smestamo u R5, sto predstavlja brojacki registar
	mov R1,#BUFFER ;odredisni niz vezujemo za registar R1
petlja:
	mov A,@R0 ;uzimamo element iz izvorisnog niza koji je smesten u R0
	add a,#20H ;obavljamo konverziju u mala slova tako sto saberemo sa 20 hexa 
	mov @R1,A ;smestamo u odredisni niz 
	inc R1 ;prelazimo na sledeci element
	inc R0
	DJNZ R5,petlja ;smanjujemo brojacki element za 1 i ako nije nula ponovo se izvrsava petlja
	ret ;povratak u glavni program
end