$NOMOD51
$INCLUDE(REG52.INC) ;ukljucujemo biblioteke za normalan rad programa 
NAME PROGRAM ;naziv programa
PUBLIC PREVODJENJE
PUBLIC BUFFER ;definisemo globalne elemente
PROGRAM SEGMENT CODE
PODACI SEGMENT IDATA
	RSEG PODACI
	BUFFER: DS 5 ;rezervisemo 5 bajtova za promenljivu buffer
	RSEG PROGRAM
PREVODJENJE:
	mov R5,#5 ;smestamo broj elemenata 
	mov R0,#BUFFER ;povezujemo R0 sa baferom
petlja:
	mov A,@R1 ;uzimamo podatak iz izvorisnog niza
	add A,#30H ;primenjujemo konverziju
	mov @R0,A ;upisujemo podataka u odredisni niz
	inc R0 ;prelazimo na sledece elemente
	inc R1
	djnz R5,petlja ;smanjujemo brojac sve dok se ne smanji na 0
	ret
end