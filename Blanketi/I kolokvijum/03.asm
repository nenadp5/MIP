;MOV A,IT01CF | ORL A,#10001000B | MOV IT01CF,A nam omogucava da sistem reaguje kada je HOT=1 i COLD=1

$NOMOD51 ;ukljucujemo biblioteke za normalni rad
$INCLUDE(REG52.INC)
PROGRAM SEGMENT CODE
	RSEG PROGRAM ;relokatibilni deo memorije
start: 
	mov IE,#85H ;podesavamo IE registar tako da odobravamo globalne prekide i prekide za EX0 i EX1
	mov A,IT01CF ;IT01CF registar smestamo u A kako bi mogli da vrsimo manipulacije nad njim 
	orl A,#10001000B ;ovom vrstom maskiranja postizemo da reaguje kada je COLD=1 i HOT=1
	mov IT01CF,A
	clr IT0 ;podesavamo da sistem reaguje na visok nivo signala
	clr IT1
	setb PX1 ;prioritet se dodeljuje prekidu INT1
	setb P1.1 ;ukljucujemo pec
	jb P3.2,skip ;ako je P3.2=1 znaci da je COLD i pec treba da ostane ukljucena
	clr P1.1 ;u suprotnom treba da iskljucimo pec
skip:
	sjmp skip ;vrti se beskonacna petlja, ali mikrokontroler svakako nadgleda rad sistema i reaguje na prekide 

CSEG at 0003H ;prekid se desio na lokaciji za EX0
EX0:
	setb P1.1 ;trebamo da ukljucimo pec jer se ovaj prekid generise kada je COLD
	reti
CSEG at 0013H ;prekid se desio na lokaciji za EX1
EX1:
	clr P1.1 ;trebamo da iskljucimo pec jer se ovaj prekid generise kada je HOT
	reti
end

;kada se u zadatku trazi dodela prioriteta onda se podesavanja vrse u okviru sledeceg registra
; | - | PSPIO | PT2 | PS0 | PT1 | PX1 | PT0 | PX0 |
;PT0,PT1,PT2 su za tajmere \ PX0,PX1 su za normalne prekide \ PS0 je za serijsku komunikaciju odnosno UART \ PSPIO je za SPIO 