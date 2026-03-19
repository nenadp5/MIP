;TEKST ZADATKA: Napisati program (potprogram, rutinu) na asemblerskom jeziku A51 za konverziju hex vrednosti koja se nalazi na adresi PARAM u ASCII kod. 
;Promenljiva PARAM se nalazi u memoriji za podatke (direktno adresibilna), a u proceduru za konverziju se prenosi preko STACK-a.​

;Kada imamo rad sa stekom, na vrhu steka uvek imamo dodate dve vrednosti za PC
;Takodje kada radimo sa stekom najcesce ne koristimo direktno SP (Stack Pointer) registar, vec ga smestimo u neki od pokazivackih registara R0 i R1

PUBLIC HEX_ASCII ;globalni parametri koji su javno dostupni
PUBLIC PARAM
PROGRAM SEGMENT CODE
PODACI SEGMENT IDATA
	PARAM: DS 1 ;rezervisemo jedan bajt podataka za parametar PARAM
	RSEG PROGRAM ;radimo sa relokatibilnim delom memorije
	RSEG PODACI

HEX_ASCII:
	mov R0,SP ;Stack Pointer smestamo u R0 i sve buduce manipulacije radimo sa registrom R0
	dec R0 ;dekrementiramo R0 dva puta kako bi dosli do stvarne vrednosti PARAM
	dec R0 
	XCH A,@R0 ;vrsimo zamenu uz pomoc komande EXCHANGE (XCH), sada nam je u A smestena vrednost koja je bila u R0 odnosno PARAM, dok je u R0 smestena vrednost koja je bila u A
	ANL A,#0Fh ;maskiranje uz pomoc logicke operacije AND (#0F=00001111, tamo gde su jedinice vrednost se zadrzava, dok tamo gde su 0 onda se brise)
	mov DPTR,#TABLE ;klasican pristup lookup tabeli
	movc A,@A+DPTR
	XCH A,@R0 ;nakon promene koja se desila ponovo preko XCH vrsimo vracanje vrednosti
	ret ;povratak u glavni program

TABLE: ;prikaz lookup tabele na jos jedan nacin
	DB '0'
	DB '1'
	DB '2'
	DB '3'
	DB '4'
	DB '5'
	DB '6'
	DB '7'
	DB '8'
	DB '9'
	DB 'A'
	DB 'B'
	DB 'C'
	DB 'D'
	DB 'E'
	DB 'F'