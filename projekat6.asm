
INCLUDE Irvine32.inc

BufSize = 255

.data
buffer1 BYTE BufSize DUP(? )
buffer2 BYTE BufSize DUP(? )
; buffer3 BYTE BufSize DUP(? )
tekst1 BYTE "Unesite tekst koji zelite da kodirate:", 0Ah, 0
tekst2 BYTE "Unesite kljucnu rec:", 0Ah, 0
tekst3 BYTE "Sifovani tekst:", 0Ah, 0
stdInHandle HANDLE ?

bytesRead1   DWORD ?
bytesRead2   DWORD ?

adr1 DWORD ?
adr2 DWORD ?
i DWORD 0
j DWORD 0
a BYTE ?


.code
ucitaj PROC c

INVOKE GetStdHandle, STD_INPUT_HANDLE
mov	stdInHandle, eax

INVOKE ReadConsole, stdInHandle, ADDR buffer1,
BufSize, ADDR bytesRead1, 0

mov	esi, OFFSET buffer1
mov adr1, esi; adresa pocetka teksta koji se kodira

ret
ucitaj ENDP

ucitaj_kljucnu_rec PROC c


INVOKE GetStdHandle, STD_INPUT_HANDLE
mov	stdInHandle, eax

INVOKE ReadConsole, stdInHandle, ADDR buffer2,
BufSize, ADDR bytesRead2, 0

mov	esi, OFFSET buffer2; esi pokazuje na pocetak kljucne reci
mov adr2, esi

ret
ucitaj_kljucnu_rec ENDP

moduo PROC c
xor eax, eax
mov al, dh			; Broj koji delimo( zbir dva slova) 
mov dl, a			; a je moduo, nekad 26, nekad duzina kljuca

div dl				

mov dh, ah			; dovoljno je jednom podeliti jer je najveci broj ciji se moduo moze racunati 180 ('Z' = 90)
					; u dh se nalazi rezultat, ostatak pri deljenju sa a 
ret
moduo ENDP

saberi PROC c			; u bl se nalazi slovo na koje trenutno pokazuje pokazivac na tekst
and ebx, 000000FFh		; radimo AND jer zelimo da izdvojimo samo najnizi bajt jer njega sabiramo (kod slova)
add ebx, [esi]			; dodajemo slovo kljuca na koje pokazuje esi
and ebx, 000000FFh		;opet AND
mov dh, bl				; smestamo rezultat sabiranja u dh, jer cemo dalje menjati ebx

inc esi					;pomeramo pokazivace na sledeci karakter
inc edi
inc i					; i broji do kog smo karaktera u tekstu stigli, ne racunajuci razmak

ret
saberi ENDP

mod_duzina_kljuca PROC c
mov bh, BYTE PTR bytesRead2		; u ovoj proceduri u dh smestamo indeks slova u kljucnoj reci sa kojom sabiramo 
sub bh, 2						; trenutno slovo u tekstu na koje pokazuje edi 
mov a, bh
call moduo; rezultat je u dh
cmp dh, 0
ret
mod_duzina_kljuca ENDP

razmak1 PROC c
inc edi						;ispisuje razmak, ali pokazivac na kljucnu rec ostaje da pokazuje na isto slovo
inc j						; kao i pre razmaka(ne povecavamo esi)jer ce se to slovo kljuca sabrati po mod26
							; sa prvim sledecim slovom u tekstu nakon razmaka
ret
razmak1 ENDP

main PROC

mov edx, offset tekst2
call WriteString
call ucitaj_kljucnu_rec


mov edx, offset tekst1
call WriteString
call ucitaj					; ucitavamo tekst koji se kodira
xor edx, edx
mov edi, adr1				; edi ce pokazivati na pocetak teksta koji kodiramo

mov esi, offset buffer2 


xor ecx, ecx
mov ecx, bytesRead1
sub ecx, 2                ;bytesRead1 predstavlja duzinu teksta uvecanu za 2, zato oduzimamo i tu vrednost smestamo u brojac
						  ;da bi se petlja ponovila onoliko puta kolika je duzina teksta 

JECXZ done2               ; ako je string prazan, ide na kraj
xor eax, eax
mov eax, bytesRead2		
sub al, 2
mov a, al                ; smestili smo duzinu kljucne reci u a, po tom modulu cemo racunati 

labela:
xor ebx, ebx
mov ebx, [edi]			; u bl se nalazi slovo na koje trenutno pokazuje pokazivac na tekst
cmp bl, ' '				;proveravamo da li je razmak, ako jeste, skacemo na labelu "razmak"
jnz lab3

jmp razmak 

lab3:
call saberi

mov dh, BYTE PTR i			; da bismo izracunali i % nesto, a bl gde je smesten rezultat sabiranja za sada ne menjamo

call mod_duzina_kljuca
jnz mod26					; ako je rezultat deljenja po mod_duzina_kljuca 0, znaci da sledece slovo u tekstu 
sub esi, (bytesRead2)		; treba da se sabere sa prvim slovom kljuca, pa zato pokazivac na kljuc umanjujemo za duzinu kljuca
add esi, 2

mod26:
mov dh, bl					;  vracamo u dh rezultat sabiranja 2 slova 

mov bl, 1Ah                 ; u bl smestamo 26=1Ah
mov a, bl                   ; u a ce se nalaziti broj po cijem modulu racunamo, dakle u ovom slucaju 26
call moduo
mov ebx, adr1              ; pri sifrovanju menjamo originalan tekst sifrovanim
add ebx, j				   ; j ce nam sluziti za kretanje po stringu, na pocetku je 0, a svakim prolazom kroz petlju se inkrementira
inc j;
mov al, 41h					; posto bi trebalo da slova A-Z imaju kod u opsegu 0-25, a ASCII kod slova A je 65, taj broj dodajemo 
add dh, al				    ; svakom rezultatu sabiranja kako bismo dobili odgovarajuce slovo u Vignerovom kodu 

mov[ebx[0]], dh				; zamenjujemo svako slovo u tekstu odgovarajucim kodiranim

jmp lab

razmak: call razmak1

lab:
loop labela					; petlja se ponavlja onoliko puta kolika je vrednost broja smestenog u ecx 
done2:

mov edx, offset tekst3
call WriteString
mov edx, adr1         ; MORA EDX! 
call WriteString


	exit
	
main ENDP
END main