;Binarna i hexa notacija za slova P (10011000=98H) i A (10001000=88H) koje su nam potrebne za lookup tabelu

ORG 0000H ;oznacava pocetak programa
main:
	mov DPTR,#TABLE ;u DPTR standardno smestamo TABLE
	jb P2.0,mrak ;proveravamo da li je na foto-senzoru P2.0=1 sto oznacava mrak, ako je 0 onda ce se izvrsiti operacija za dan
dan:
	setb P1.7 ;podizemo roletne kada je dan, roletne su povezane na pin P1.7
	mov A,#00H ;upisujemo 0 kako bi pristupili prvom elementu u tablici, odnosno slovu P
	movc A,@A+DPTR ;klasicna metoda za pristup LOOKUP tabeli
	mov P1,A ;ispisujemo konvertovanu vrednost na pinu za displej
	sjmp $ ;vrti se beskonacna petlja
mrak:
	clr P1.7 ;spustaju se roletne kada je noc, roletne su povezane na pin P1.7
	mov A,#01H ;upisujemo 1 kako bi pristupili drugom elementu u tablici, odnosno slovu A
	movc A,@A+DPTR ;pristup LOOKUP tabeli
	mov P1,A ;prikaz na displeju
	sjmp $
TABLE:
	DB 98H 
	DB 88H
end