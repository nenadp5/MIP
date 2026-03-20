;TEKST ZADATKA: Napisati program na asemblerskom jeziku A51 koji kreira pravougaoni talasni oblik na pinu P1.0. Frekvenciju pravougaonog talasnog oblika od 1 KHz realizovati korišćenjem tajmera TO. (Napomena: faktor ispune je 50% - duty cycling). 
;Frekvencija kristala je 11 059 200 HZ = 11,0592 MHz. Napomena: generisati pravougaoni talasni oblik prozivkom (bez ISR).

;Ako je F=11059200Hz, onda je Fmc=F/12=921600Hz, dok je Tmc=1/Fmc=1,085*10^-6
;Frekvencija pravougaonog talasnog oblika je 1000Hz, odnosno Tto=1/1000=1*10^-3 i onda jedan blok iznosi 500*10^-6
;Konacnu vrednost takta dobijamo kada vrednost bloka podelimo sa Tmc odnosno 500*10^-6/1.085*10^-6=460.829=461
;Medjutim kako imamo kasnjenje i faktore na koje ne mozemo da uticemo onda cemo koristiti vrednost -444

;Za podesavanje rada tajmera u odgovarajucem rezimu koristimo registar TMOD, a za njegovu kontrolu i proveru koristimo bitove iz TCON. Registri su opisani u posebnom fajlu.

mov TMOD,#00000001B ;omogucava rad tajmera 0 u 16-bitnom rezimu rada
main:
	setb P1.0 ;postavljamo visok nivo
	acall delay ;pozivamo funkciju koja simulira kasnjenje, acall pamti mesto odakle se skocilo i nakon njegovog izvrasanja se vraca ponovo tu
	clr P1.0 ;postavljamo nizak nivo
	acall delay ;pozivamo funkciju koja simulira kasnjenje
	sjmp main ;vrti se program
delay:
	mov TH0,#HIGH(-444) ;kasnjenje koje odgovara tekstu zadatka
	mov TL0,#LOW(-444) ;uvek stavljamo minus na dobijenu vrednost jer predstavlja kasnjenje
	setb TR0 ;ukljucujemo tajmer0 da radi
here:
	jnb TF0,here ;ako je TF0=0 znaci da tajmer0 jos nije prelio i vrti se petlja sve dok ne bude TF0=1
	clr TR0 ;kada tajmer prelije, onda se iskljucuje i brise se njegov statusni fleg
	clr TF0
	setb P1.0 ;postavljamo stanje na visok nivo
	ret
end
