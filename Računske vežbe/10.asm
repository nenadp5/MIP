;TEKST ZADATKA: Napisati program na asemblerskom jeziku A51 koji kreira pravougaoni talasni oblik na pinu P1.0. Frekvenciju pravougaonog talasnog oblika od 10 KHz realizovati korišćenjem tajmera T0. 
;(Napomena: faktor ispune je 50% - duty cycling). Frekvencija kristala je 12 000 000 HZ = 12 MHz.​

;Ako je F=12MHz, onda je Fmc=F/12=1000000Hz, dok je Tmc=1/Fmc=1*10^-6
;Frekvencija pravougaonog talasnog oblika je 10kHz, odnosno Tto=1/10000=100*10^-6 i onda jedan blok iznosi 50*10^-6
;Konacnu vrednost takta dobijamo kada vrednost bloka podelimo sa Tmc odnosno 50*10^-6/1*10^-6=50

;Tajmer inicijalizujemo kao 8-bitni u autoreload rezimu za tajmer 0, sto znaci da u TMOD upisujemmo 00000010B ili #02h
;Realizovacemo putem prekida tako da je u okviru IE registra neophodno da dozvolimo opsti prekid EA i T0 prekid za tajmer, pa onda upisujemo 10000010 ili #82h

PROGRAM SEGMENT CODE
	CSEG AT 0000h ;lokacija pocetka programa
	ljmp main ;skacemo na labelu za glavni deo programa
	RSEG PROGRAM ;relokatibilni deo memorije
main:
	mov TMOD,#02h ;inicijalizujemo tajmer da radi u 8-bitnom rezimu rada
	mov TH0,#-50 ;kasnjenje koje smo izracunali
	setb TR0 ;aktiviramo rad tajmera
	mov IE,#82h ;odobravamo globalni prekid i prekid za tajmer0 u okviru IE registra
	sjmp $ ;vrti se beskonacna petlja, medjutim mikrokontroler nadgleda rad sistema i reaguje ako se desi prekid

CSEG at 000Bh ;prekid se desio na memorijskoj lokaciji predvidjenoj za tajmer0
T0_ISR:
	CPL P1.0 ;komplementiramo vrednost na pinu P1.0, odnosno generise se pravougaoni signal
	CLR TF0 ;brisemo statusni fleg kako ne bi bespotrebno generisalo prekid za tajmer 0
	ret
