;Klasican prvi zadatak sa racunskih vezbi, samo sto se trazi lookup tabela za anodu
;Spomenutu vrednost 8 upisujemo kao heksadecimalnu u registar A i potom sabiramo sa DPTR

$NOMOD51
$INCLUDE(REG52.INC)
PUBLIC KONVERZIJA
PROGRAM SEGMENT CODE
	RSEG PROGRAM
KONVERZIJA:
	mov A,#08H
	mov DPRT,#TABLE
	movc A,@A+DPTR
	ret
TABLE:
	DB 81H,CFH,92H,86H,CCH,A4H,A0H,8FH,80H,84H
end