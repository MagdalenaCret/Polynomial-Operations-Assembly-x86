.386
.model flat, stdcall

includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern sscanf: proc
extern scanf: proc

public start

.data
;;structura polinomului

ELEMENT_POLINOM struct
	coeficient DD 0
	grad DD 0
ELEMENT_POLINOM ends

;;formatele pentru afisarea polinomului
format_afisare DB "Polinomul este : ", 0
format_numar DB "%d", 0
format_x DB "x", 0
format_putere DB "^", 0
format_plus DB "+", 0
format_minus DB "-", 0
format_rand_nou DB 13,10,0
format_polinom_null DB "null",0
format_constanta_integrala DB "+C", 0
format_afisare_valoare_polinom_in_punct_dat DB "Polinomul intr-un punct dat este: %d", 13, 10, 0
numar_maxim_elemente_polinom DD 200

;;variabile utilizate pentru citire
polinom_string_aux DB 100 dup(0)           ;; se vor extrage elementele polinomului pe rand
caracter_polinom DB 'x'                    ;; constanta 'x' din string
caracter_putere DB '^'                     ;; constanta '^' din string
format_element_x_polinom DB "%dx^%d", 0    ;; pentru a extrage gradul si coeficientul
format_element_grad_1_polinom DB "%dx", 0       ;; pentru a extrage coeficientul polinomului grad=1
format_element_constant_polinom DB "%d", 0 ;; doar pentru constante din string (gradul=0)
plus DB '+'
minus DB '-'
grad_polinom DD 0
coef_polinom DD 0

;;variabilele utilizate in rezolvarea operatiilor cu polinoame
polinom ELEMENT_POLINOM 200 dup({-1,-1})
polinom2 ELEMENT_POLINOM 200 dup({-1,-1})  ;;pentru grad 1 si 2 inca doua formate
polinom3 ELEMENT_POLINOM 200 dup({-1,-1})
polinom4 ELEMENT_POLINOM 200 dup({-1,-1})
polinom5 ELEMENT_POLINOM 200 dup({-1,-1})
polinom6 ELEMENT_POLINOM 200 dup({-1,-1})
polinom7 ELEMENT_POLINOM 200 dup({-1,-1})
cop_polinom1_impartire ELEMENT_POLINOM 200 dup({-1,-1})
cop_polinom2_imparitre ELEMENT_POLINOM 200 dup({-1,-1})
polinom_integrat ELEMENT_POLINOM 200 dup({-1,-1})
polinom_rezultat_impartire ELEMENT_POLINOM 200 dup({-1,-1})

;; variabile meniu
descriere_meniu_1 DB "---------- Operatii pe polinoame ---------",13,10,
"Instructiuni:",13,10,
"a. Utilizatorul va introduce din linia de comanda 2 polinoame, iar mai apoi pe baza acestora se pot efectua anumite operatii",13,10,
"b. Cele 2 polinoame sunt initializate cu polinomul 'null'",13,10,
"c. Pentru a introduce un polinom din linia de comanda trebuie respectat urmatorul format:",13,10,
"	c.1. Polinomul va fii introdus in ordinea crescatoarea a gradelor. Ex: 3+10x+34x^5",13,10,0
descriere_meniu_2 DB "	c.2. Se va folosi doar caracterul 'x' in scrierea polinomului",13,10,
"	c.3. Nu se vor introduce coeficienti care sunt nuli, acestia nu se vor scrie",13,10,
"	c.4. Pentru a introduce polinomul null se va introduce doar 0 de la tastatura",13,10,
"d. Pentru a se efectua o operatie, tastati numarul operatie corespunzatoare pe baza celor descrise mai jos:",13,10,0
descriere_meniu_3 DB "	1. Citire polinom",13,10,
"	2. Afisare polinom",13,10,
"	3. Negarea unui polinom",13,10,
"	4. Inmultirea unui polinom cu un scalar",13,10,
"	5. Adunarea celor 2 polinoame",13,10,
"	6. Scaderea celor 2 polinoame",13,10,
"	7. Inmultirea celor 2 polinoame",13,10,
"	8. Ridicarea unui polinom la o putere data",13,10,
"	9. Calculul polinomului intr-un punct dat",13,10,0
descriere_meniu_4 DB "	10. Derivata unui polinom",13,10,
"	11. Integrala unui polinom",13,10,
"	12. Impartirea celor 2 polinoame", 13,10,
"	13. Cel mai mare divizor comun al celor 2 polinoame", 13, 10,
"	14. Cel mai mic multiplu comun al celor 2 polinoame", 13, 10,
"	15. Iesirea din program",13,10,
"------------------------------------------",13,10,0

afisare_operatie DB 13,10,"Operatia dorita este: ", 0
format_citire_operatie DB "%d", 0
numar_operatie DD 0
numar_polinom_ales DD 0
numar_scalar DD 0
numar_putere DD 0
numar_punct DD 0

afisare_polinom_normal DB "Polinomul normal este: ", 0
afisare_ecran_polinom_1 DB "Polinom 1: ", 0
afisare_ecran_polinom_2 DB "Polinom 2: ", 0

afisare_operatie_citire_alegere_polinom DB "Alegeti polinomul pe care vreti sa-l cititi [1/2]: ", 0
format_citire_numar_ales_polinom DB "%d", 0
afisare_citire_polinom DB "Intoduceti polinomul: ", 0
format_citire_polinom DB "%s", 0
format_citire_polinom_2 DB "%s",13,10, 0
afisare_operatie_citire_success DB "Polinomul a fost citit cu success", 13,10,0
polinom_string DB 200 dup(0)

afisare_operatie_sciere_alegere_polinom DB "Alegeti polinomul pe care vreti sa-l afisati pe ecran [1/2]: ", 0
format_sciriere_numar_ales_polinom DB "%d", 0

afisare_operatie_negare_alegere_polinom DB "Alegeti polinomul pe care vreti sa-l negati [1/2]: ", 0
afisare_negare_rezultat DB "Polinomul negat este: ", 0

afisare_operatie_inmultire_scalar_polinom DB "Alegeti polinomul pe care vreti sa-l inmultiti cu un scalar [1/2]: ", 0
afisare_alegere_scalar DB "Scalarul este : ", 0
afisare_inmultire_scalar_rezultat DB "Polinomul inmultit cu scalar este: ", 0

afisare_operatie_putere_alegere_polinom DB "Alegeti polinomul pe care vreti sa-l ridicati la putere [1/2]: ", 0
afisare_alegere_putere DB "Puterea este : ", 0
afisare_putere_rezultat DB "Polinomul ridicat la putere este: ", 0

afisare_operatie_calcul_punct_alegere_polinom DB "Alegeti polinomul in care vreti sa calculati valoarea intr-un punct dat [1/2]: ", 0
afisare_alegere_calcul_punct DB "x=", 0
afisare_calcul_punct_rezultat DB "Valoarea polinomului in punctul dat este: %d",13,10, 0

afisare_operatie_derivare_polinom DB "Alegeti polinomul pe care vreti sa-l derivati [1/2]: ", 0
afisare_derivare_rezultat DB "Derivata polinomului este: ", 0

afisare_operatie_integrare_polinom DB "Alegeti polinomul pe care vreti sa-l integrati [1/2]: ", 0
afisare_integrare_rezultat DB "Integrala polinomului este: ", 0

afisare_adunare_rezultat DB "Suma celor 2 polinoame este: ", 0
afisare_scadere_rezultat DB "Scaderea celor 2 polinoame este: ", 0
afisare_inmultire_rezultat DB "Inmultirea celor 2 polinoame este: ", 0

parasire_program DB "Ati iesit cu succes din program",0

.code
;; Numar elemete polinom
;; Returneaza pentru un polinom numarul de elementele
;; numar_elemente(polinom)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
numar_elemente proc
	push ebp                ;; salvare ebp
    mov ebp, esp
	
	push ebx
	
	mov eax, 0 
	
bucla_numar_elemente:
	mov ebx, [ebp+8]
	mov ebx, [ebx + eax*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad]
	
	inc eax
	cmp ebx, -1
	jne bucla_numar_elemente
	dec eax
	
	pop ebx
	mov esp, ebp           ;; recuperez esp
    pop ebp                ;; recuperez ebp
	ret 4
numar_elemente endp




;; Initializare polinom cu {-1,-1}
;; initializare_polinom(polionm)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
initializare_polinom proc
	push ebp                ;; salvare ebp
    mov ebp, esp 
	
	pusha
	mov ecx, 0
	
bucla_initializare:
	cmp ecx, numar_maxim_elemente_polinom
	je salt_finalizare_iniitializare
	mov ebx, [ebp+8]
	mov [ebx+ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], -1
	mov [ebx+ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], -1
	inc ecx
	jmp bucla_initializare
	
salt_finalizare_iniitializare:
	popa
	mov esp, ebp            ;; recuperez esp
    pop ebp               	;; recuperez ebp
	ret 4
initializare_polinom endp



;;Afisare polinom pe ecran
;;afisare_polinom(polinom)
;;                (+8)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
afisare_polinom proc
    push ebp                ;; salvare ebp
    mov ebp, esp            ;; salvez varful stivei in ebp
	sub esp, 4              ;; variabila locala - numar elemente polinom
	pusha
	push [ebp+8]
	call numar_elemente
	mov [ebp-4], eax       
	
	mov ecx, [ebp-4]
	cmp ecx, 0
	jne calcul_afisare
	;Afisare text polinom null
	push offset format_polinom_null
	call printf
	add esp, 4
	jmp finalizare_afisare

calcul_afisare:
	mov ecx, 0             ;; ecx - index in parcurgea polinomului
	mov esi, 0             ;; esi - index in parcurgea structurii polinomului
bucla:
	cmp ecx, [ebp-4]      ;; lungime vector
	je finalizare_afisare
	mov ebx, ecx 	       ;; salvam ecx in ebx deoarece printf va modifica eax, edx, ecx
	
	cmp ecx, 0
	je salt_dupa_plus
	
	mov eax, [ebp+8]       ;; [ebp+8]  - se afla primul argument trimis functiei
	                       ;; [ebp+12] - al doilea
	mov eax, [eax+esi+ELEMENT_POLINOM.coeficient]  ;; accesez elemntul de la adresa vectorului
	
	cmp eax, 0
	jl salt_dupa_plus
	push offset format_plus
	call printf  
	add esp, 4
	
salt_dupa_plus:
    mov eax, [ebp+8]
	mov eax ,[eax+esi+ELEMENT_POLINOM.coeficient]
	
	;; Daca afisam coeficientul sau nu (nu-l mai afiam cand e 1 si gradul e diferit de 0)
	cmp eax, 1             ;; cazul coeficient=1
	je coef_egal_1
	
	cmp eax, -1             ;; cazul coeficient=1
	je coef_egal_minus_1
	
	push eax               ;; afisez coeficientul
	push offset format_numar
	call printf
	add esp, 8
	jmp dupa_coef
coef_egal_1:
	mov eax, [ebp+8]
	mov eax ,[eax+esi+ELEMENT_POLINOM.grad]
	
	cmp eax, 0              ;; cazul coef=1 si grad=0
	je coef_1_grad_0
	jmp dupa_coef           ;; nu mai afisam
coef_egal_minus_1:
	mov eax, [ebp+8]
	mov eax ,[eax+esi+ELEMENT_POLINOM.grad]
	
	cmp eax, 0              ;; cazul coef=-1 si grad=0
	je coef_minus_1_grad_0
	
	push offset format_minus
	call printf
	add esp, 4
	jmp dupa_coef           ;; nu mai afisam
coef_1_grad_0:
	push 1
	push offset format_numar
	call printf
	add esp, 8
	jmp dupa_coef
coef_minus_1_grad_0:
	push -1
	push offset format_numar
	call printf
	add esp, 8
	jmp dupa_coef
dupa_coef:

	mov eax, [ebp+8]
	mov eax ,[eax+esi+ELEMENT_POLINOM.grad]
	
	cmp eax, 0           ;; gradul =0 - nu mai afisam x
	je grad_egal_0
	
	push eax              ;; printf stica eax, il salvez inainte
	push offset format_x
	call printf
	add esp, 4
	pop eax
	
	cmp eax, 1          ;; gradul =1 - nu mai afisam puterea
	je grad_egal_1
	
	push eax
	push offset format_putere
	call printf
	add esp, 4
	pop eax
	
	push eax
	push offset format_numar
	call printf
	add esp, 8
grad_egal_1:

grad_egal_0:
	

revenire_bucla:
	
	mov ecx, ebx                  ;; recuperez ecx
	inc ecx
	add esi, size ELEMENT_POLINOM
	jmp bucla
finalizare_afisare:

	push offset format_rand_nou
	call printf
	add esp, 4	
	
	popa
    mov esp, ebp           ;; recuperez esp
    pop ebp                ;; recuperez ebp
    ret 4                 ;; ies din functie si curat stiva cu 4 
afisare_polinom endp

;;Afisare integrala polinom pe ecran
;;afisare_integrala_polinom(polinom)
;;                (+8)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
afisare_integrala_polinom proc
   push ebp                ;; salvare ebp
    mov ebp, esp            ;; salvez varful stivei in ebp
	sub esp, 4              ;; variabila locala - numar elemente polinom
	pusha
	push [ebp+8]
	call numar_elemente
	mov [ebp-4], eax       
	
	mov ecx, [ebp-4]
	cmp ecx, 0
	jne calcul_afisare
	;Afisare text polinom null
	push offset format_polinom_null
	call printf
	add esp, 4
	jmp finalizare_afisare

calcul_afisare:
	mov ecx, 0             ;; ecx - index in parcurgea polinomului
	mov esi, 0             ;; esi - index in parcurgea structurii polinomului
bucla:
	cmp ecx, [ebp-4]      ;; lungime vector
	je finalizare_afisare
	mov ebx, ecx 	       ;; salvam ecx in ebx deoarece printf va modifica eax, edx, ecx
	
	cmp ecx, 0
	je salt_dupa_plus
	
	mov eax, [ebp+8]       ;; [ebp+8]  - se afla primul argument trimis functiei
	                       ;; [ebp+12] - al doilea
	mov eax, [eax+esi+ELEMENT_POLINOM.coeficient]  ;; accesez elemntul de la adresa vectorului
	
	cmp eax, 0
	jl salt_dupa_plus
	push offset format_plus
	call printf  
	add esp, 4
	
salt_dupa_plus:
    mov eax, [ebp+8]
	mov eax ,[eax+esi+ELEMENT_POLINOM.coeficient]
	
	;; Daca afisam coeficientul sau nu (nu-l mai afiam cand e 1 si gradul e diferit de 0)
	cmp eax, 1             ;; cazul coeficient=1
	je coef_egal_1
	
	cmp eax, -1             ;; cazul coeficient=1
	je coef_egal_minus_1
	
	push eax               ;; afisez coeficientul
	push offset format_numar
	call printf
	add esp, 8
	jmp dupa_coef
coef_egal_1:
	mov eax, [ebp+8]
	mov eax ,[eax+esi+ELEMENT_POLINOM.grad]
	
	cmp eax, 0              ;; cazul coef=1 si grad=0
	je coef_1_grad_0
	jmp dupa_coef           ;; nu mai afisam
coef_egal_minus_1:
	mov eax, [ebp+8]
	mov eax ,[eax+esi+ELEMENT_POLINOM.grad]
	
	cmp eax, 0              ;; cazul coef=-1 si grad=0
	je coef_minus_1_grad_0
	
	push offset format_minus
	call printf
	add esp, 4
	jmp dupa_coef           ;; nu mai afisam
coef_1_grad_0:
	push 1
	push offset format_numar
	call printf
	add esp, 8
	jmp dupa_coef
coef_minus_1_grad_0:
	push -1
	push offset format_numar
	call printf
	add esp, 8
	jmp dupa_coef
dupa_coef:

	mov eax, [ebp+8]
	mov eax ,[eax+esi+ELEMENT_POLINOM.grad]
	
	cmp eax, 0           ;; gradul =0 - nu mai afisam x
	je grad_egal_0
	
	push eax              ;; printf stica eax, il salvez inainte
	push offset format_x
	call printf
	add esp, 4
	pop eax
	
	cmp eax, 1          ;; gradul =1 - nu mai afisam puterea
	je grad_egal_1
	
	push eax
	push offset format_putere
	call printf
	add esp, 4
	pop eax
	
	push eax
	push offset format_numar
	call printf
	add esp, 8
grad_egal_1:

grad_egal_0:
	

revenire_bucla:
	
	mov ecx, ebx                  ;; recuperez ecx
	inc ecx
	add esi, size ELEMENT_POLINOM
	jmp bucla
finalizare_afisare:

    push offset format_constanta_integrala
	call printf 
	add esp, 4
	
	push offset format_rand_nou
	call printf
	add esp, 4
	
	popa
    mov esp, ebp           ;; recuperez esp
    pop ebp                ;; recuperez ebp
    ret 4                 ;; ies din functie si curat stiva cu 4 
afisare_integrala_polinom endp

;;; Inmultirea unui polinom cu un scalar
;; inmultirea_cu_scalar(polinom, polinom2, scalar)
;;                     (+8    , +12      ,+16   )
;; polinom2 = scalar*polinom
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
inmultirea_cu_scalar proc
    push ebp
	mov ebp, esp
	pusha
	
	push [ebp+8]
	call numar_elemente
	mov edi, eax           ;; edi - numarul de elemente ale polinomului
	mov ecx, 0 
	
	mov esi, [ebp+16]    ;; in cazul in care scalar=0
	cmp esi, 0
	je salt_dupa_inmultire_cu_scalar
	
bucla_inmultire_cu_scalar:
    cmp ecx, edi; verificam daca am parcurs toate elementele
    je salt_dupa_inmultire_cu_scalar 
	 
	mov esi, [ebp+8]
    mov eax, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient]
	mov edx, 0
	mov ebx, [ebp+16]  
    imul ebx                                ; Inmultim elementul cu scalarul
	 
	mov edx, [ebp+12]
    mov [edx + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], eax
	
	mov eax, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad]
	mov [edx + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], eax
	inc ecx
	jmp bucla_inmultire_cu_scalar
salt_dupa_inmultire_cu_scalar:

	mov edx, [ebp+12]
    mov [edx + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], -1 ;;pentru ca sa stiu unde se termina
	mov [edx + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], -1
	
	popa
    mov esp, ebp
    pop ebp
	ret 12
inmultirea_cu_scalar endp
	 
;; Negarea unui polinom
;; negarea_polinom(polinom, polinom2)
;;                (+8     , +12     )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
negarea_polinom proc
    push ebp
	mov ebp, esp
	pusha
	
	push -1
	push [ebp+12]
	push [ebp+8]
	call inmultirea_cu_scalar
	
	popa
    mov esp, ebp           ;; recuperez esp
    pop ebp                ;; recuperez ebp
	ret 8
negarea_polinom endp

;; Adunarea a 2 polinoame
;; adunarea_polinoame(polinom1, polinom2, polinom3)
;;                   (+8       , +12     , +16    )
;; polinom3 = polinom1+polinom2
;; polinom3 la final vom pune {-1, -1} ca sa stim unde se termina polinomul
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
adunarea_polinoame proc
	push ebp                ;; salvare ebp
    mov ebp, esp            ;; salvez varful stivei in ebp
	
	sub esp, 8
	pusha
	push [ebp+12]
	call numar_elemente
	mov [ebp-4], eax       ;; numar elemente poliom 2
	
	push [ebp+8]
	call numar_elemente
	mov [ebp-8], eax       ;; numar elemente poliom 1
	
	push [ebp+16]
	call initializare_polinom
	
	mov ecx, 0
	mov edx, 0
	mov ebx, 0
	
bucla_adunare:
	cmp ecx, [ebp-8]          ;; ecx cu nr1, numarul de elemente ale polinomului1
	je salt_dupa_adunare
	cmp edx, [ebp-4]          ;; edx cu nr2, numarul de elemente ale polinomului2
	je salt_dupa_adunare
	
	mov esi, [ebp+8]
	mov esi, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad]   ;; gradul elementului din polinom1
	
	mov edi, [ebp+12]
	mov edi, [edi+ edx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad]    ;; gradul elementului din polinom2
	
	cmp esi, edi
	jl eticheta_adunare_mic  
	je eticheta_adunare_egal
	jg eticheta_adunare_mare
eticheta_adunare_mic:

	;; copiem gradul poilnom 1 in polinom 3
	mov esi, [ebp+8]
	mov esi, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad]
	mov eax, [ebp+16]
    mov [eax + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], esi
	
	;; copiem coeficient poilnom 1 in polinom 3
	mov esi, [ebp+8]
	mov esi, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient]
	mov eax, [ebp+16]                            ;; polinom 3
    mov [eax + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], esi
	
	inc ecx
	inc ebx
	jmp bucla_adunare
eticheta_adunare_egal:
	;; adunam cei 2 coeficienti
	mov esi, [ebp+8]
	mov esi, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient]
	
	mov edi, [ebp+12]
	mov edi, [edi+ edx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient]
	
	add esi, edi
	cmp esi, 0           ;;cazul in care adunarea = 0, se elimina din polinom
	je incrementare_egal
	
	mov eax, [ebp+16] 
	mov [eax + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], esi
	
	;; copiem gradul poilnom 1 in polinom 3
	mov esi, [ebp+8]
	mov esi, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad]
	mov eax, [ebp+16] 
    mov [eax + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], esi
	inc ebx ;;se incrementeaza doar daca punem un element
incrementare_egal:	
	
	inc ecx
	inc edx
	jmp bucla_adunare
	
eticheta_adunare_mare: 
    ;; copiem gradul poilnom 2 in polinom 3
	mov edi, [ebp+12]
	mov edi, [edi + edx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad]
	mov eax, [ebp+16] 
    mov [eax + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], edi
	
	;; copiem coeficient poilnom 2 in polinom 3
	mov edi, [ebp+12]
	mov edi, [edi + edx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient]
	mov eax, [ebp+16] 
    mov [eax + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], edi
    inc edx
	inc ebx
	jmp bucla_adunare
salt_dupa_adunare:


bucla_while_polinom_1:
	cmp ecx, [ebp-8]          ;; ecx cu nr1 - al treilea argument
	jge salt_la_2_polinom
	
	mov esi, [ebp+8]
	mov esi, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad]
	mov eax, [ebp+16] 
    mov [eax + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], esi
	
	;; copiem coeficient poilnom 1 in polinom 3
	mov esi, [ebp+8]
	mov esi, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient]
	mov eax, [ebp+16] 
    mov [eax + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], esi
	
	inc ecx
	inc ebx
	jmp bucla_while_polinom_1

salt_la_2_polinom:
bucla_while_polinom_2:
	
	cmp edx, [ebp-4]         ;; edx cu nr2 - al 4-lea argument
	jge salt_adunare_final
	
	mov edi, [ebp+12]
	mov edi, [edi + edx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad]
	mov eax, [ebp+16] 
    mov [eax + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], edi
	
	;; copiem coeficient poilnom 2 in polinom 3
	mov edi, [ebp+12]
	mov edi, [edi + edx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient]
	mov eax, [ebp+16] 
    mov [eax + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], edi
    inc edx
	inc ebx
	jmp bucla_while_polinom_2
	
salt_adunare_final:
	
	mov eax, [ebp+16] 
	mov [eax + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], -1
	mov [eax + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], -1
	
	popa
	mov esp, ebp           ;; recuperez esp
    pop ebp                ;; recuperez ebp
	ret 12
adunarea_polinoame endp

;; Scaderea a 2 polinoame
;; scadere_polinoame(polinom1, polinom2, polinom3)
;;                   (+8       , +12     ,   +16)
;; polinom3 = polinom1-polinom2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scaderea_polinoame proc
    push ebp                ;; salvare ebp
    mov ebp, esp            ;; salvez varful stivei in ebp
	
	pusha 
	
	push offset polinom4
	push [ebp+12]
	call negarea_polinom
	
	push [ebp+16]
	push [ebp+8]
	push offset polinom4
	call adunarea_polinoame
	popa
	
	mov esp, ebp           ;; recuperez esp
    pop ebp                ;; recuperez ebp
	ret 12
scaderea_polinoame endp

;; Copiere polinom
;; inmultirea_cu_scalar(polinom, polinom2)
;;                     (+8    , +12      )
;; polinom2 = polinom
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
copiere_polinom proc  
	push ebp
	mov ebp, esp
	pusha
	
	push 1
	push [ebp+12]
	push [ebp+8]
	call inmultirea_cu_scalar
	
	popa
    mov esp, ebp           ;; recuperez esp
    pop ebp                ;; recuperez ebp
	ret 8
copiere_polinom endp


;;Inmultirea a doua polinoame
;; inmultirea_polinoame(polinom1, polinom2, polinom3)
;;                   (+8       , +12     , +16    )
;; polinom3 = polinom1*polinom2
;; polinom3 la final vom pune {-1, -1} ca sa stim unde se termina polinomul
;; x^2 + x^3 + x^4
;; x^2 + x^3
;;P = polinom null
;;P = P + x^4 + x^6  
;;P = P + x^6 + x^9
;;P = P + x^8 + x^12
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; algoritmul din C utilizat
	;int k = 0;
	;polinom = polinom_null
    ;for (int i = 0; i < m; i++) {
	; polinom = polinom + rezultat
    ;for (int j = 0; j < n; j++) {
    ;    Rezultat[k].coeficient = P[i].coeficient * Q[j].coeficient;
    ;    Rezultat[k].grad = P[i].grad + Q[j].grad;
    ;    k++;
    ;}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
inmultirea_polinoame proc
	push ebp                ;; salvare ebp
    mov ebp, esp            ;; salvez varful stivei in ebp
	
	sub esp, 8
	pusha
	
	push [ebp+12]
	call numar_elemente
	mov [ebp-4], eax       ;; numar elemente poliom 2
	
	push [ebp+8]
	call numar_elemente
	mov [ebp-8], eax       ;; numar elemente poliom 1
	
	push [ebp+16]
	call initializare_polinom
	
	mov ecx, 0
	mov edx, 0
	mov ebx, 0
	
	push offset polinom4
	call initializare_polinom ;;initializarea polinomului4 cu polinomul null

	
bucla_inmultire_1:
	cmp ecx, [ebp-8]
	je salt_dupa_inmultire

bucla_inmultire_2:
	cmp edx, [ebp-4]
	je dupa_bucla_inmultire_2
	
	mov esi, [ebp+8]
	mov esi, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad]   ;; gradul elementului din polinom1
	
	mov edi, [ebp+12]
	mov edi, [edi+ edx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad]    ;; gradul elementului din polinom2
	
	add esi, edi
	
	mov eax, [ebp+16] 
	mov [eax + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], esi
    
	mov esi,[ebp+8]
	mov esi, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient]   ;; coeficientul elementului din polinom1
	
	mov edi, [ebp+12]
	mov edi, [edi+ edx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient]    ;; coeficientul elementului din polinom2
	
	push edx       ;; ca sa nu se modifice ecx
	mov edx, 0
	mov eax, esi
	mul edi
	
	mov edx, [ebp+16] 
	mov [edx + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], eax
	pop edx
	inc ebx
	inc edx
    jmp bucla_inmultire_2
	
dupa_bucla_inmultire_2:
	
	mov edx, [ebp+16]
    mov [edx + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], -1 ;;pentru ca sa stiu unde se termina
	mov [edx + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], -1
	
	push offset polinom5
	push offset polinom4 
	push [ebp+16]
	call adunarea_polinoame
	
	push offset polinom4
	push offset polinom5
	call copiere_polinom
	
	mov edx, 0
	mov ebx, 0
	inc ecx
    jmp bucla_inmultire_1

salt_dupa_inmultire:
   
   push [ebp+16]
   push offset polinom4
   call copiere_polinom
   
	popa
	mov esp, ebp           ;; recuperez esp
    pop ebp                ;; recuperez ebp
	ret 12
inmultirea_polinoame endp

;;Impartirea a doua polinoame
;; polinom3 = polinom1/polinom2
;; polinom3 la final vom pune {-1, -1} ca sa stim unde se termina polinomul
;;impartirea_polinoame(polinom, polinom2,polinom1_cop, polinom2_cop, polinom_rezultat_impartire)
;;                     (+8,       +12,    +16,         +20,                           +24)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;impartirea_polinoame proc
impartirea_polinoame proc
	push ebp                ;; salvare ebp
    mov ebp, esp            ;; salvez varful stivei in ebp
	
    sub esp, 8
	pusha
	push [ebp+12]
	call numar_elemente
	mov [ebp-4], eax       ;; numar elemente poliom 2
	
	push [ebp+8]
	call numar_elemente
	mov [ebp-8], eax       ;; numar elemente poliom 1
	
	push [ebp+16]
	call initializare_polinom
	push [ebp+20]
	call initializare_polinom
	
	push [ebp+24]
	call initializare_polinom ;; initializar5e polinom_rezultat_impartire
	
	mov ecx, [ebp-8]
	mov ebx, 0

bucla_inversare_polinom_1:
	cmp ecx, 0
    je salt_dupa_inversiune_pol_1
   
    mov esi, [ebp+8]
	mov esi, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad]
	mov eax, [ebp+16]
    mov [eax + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], esi
	
	mov esi, [ebp+8]
	mov esi, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient]
	mov eax, [ebp+16]                          
    mov [eax + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], esi
	
	mov edx, 1
	mov edi, ecx
	sub edi, edx
	mov ecx, edi
	jmp bucla_inversare_polinom_1
salt_dupa_inversiune_pol_1:

	mov ecx, [ebp-4]
	mov ebx, 0
	
bucla_inversare_polinom_2:
	cmp ecx, 0
    je salt_dupa_inversiune_pol_2
   
    mov esi, [ebp+12]
	mov esi, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad]
	mov eax, [ebp+12]
    mov [eax + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], esi
	
	mov esi, [ebp+12]
	mov esi, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient]
	mov eax, [ebp+20]                          
    mov [eax + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], esi
	
	mov edx, 1
	mov edi, ecx
	sub edi, edx
	mov ecx, edi
	jmp bucla_inversare_polinom_2
salt_dupa_inversiune_pol_2: 


impartirea_polinoame endp

;;Ridicarea la o putere a unui polinom
;;ridicarea_la_putere(polinom1, putere, polinom2)
;;                   (+8      ,+12    ,      +16)
;;   p=polinom1
;;   for ....
;;     x = polinom1*p
;;     p=x
;;   polinom2=p
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ridicarea_la_putere proc
   push ebp                ;; salvare ebp
   mov ebp, esp            ;; salvez varful stivei in ebp
 
   pusha
   mov  ebx, 0
   mov ecx, 0
   
   inc ecx
   
   mov edx, [ebp+12]
   cmp edx, 0
   je salt_la_egal_cu_1
   
   push offset polinom6
   push [ebp+8]
   call copiere_polinom

   
   mov eax, [ebp+12]
 
bucla_ridicare_la_putere:
   cmp ecx, eax
   je salt_ridicare_la_putere_final

	push offset polinom7
	push offset polinom6  
	push [ebp+8]
	call inmultirea_polinoame
	
	push offset polinom6
	push offset polinom7
	call copiere_polinom
	
	inc ecx
	jmp bucla_ridicare_la_putere
salt_ridicare_la_putere_final:
	
	push [ebp+16]
	push offset polinom6
	call copiere_polinom 
    jmp salt_final
	
salt_la_egal_cu_1:
	
	mov esi, [ebp+16]
	mov[esi + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], 1
	
	mov edi, [ebp+16]
    mov [edi + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], 0
	
	inc ebx  ;;pentru ca sa stie sa se opreasca
	
    mov esi, [ebp+16]
	mov[esi + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], -1
	
	mov edi, [ebp+16]
    mov [edi + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], -1

salt_final:
	popa
    mov esp, ebp
    pop ebp
	ret 12
	
ridicarea_la_putere endp

;;Ridicarea la o putere a unui numar
;;ridicarea_la_putere(numar, putere)
;;                   (+8      ,+12)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ridicarea_la_putere_numar_dat proc
	push ebp                ;; salvare ebp
	mov ebp, esp            ;; salvez varful stivei in ebp
	
	push ecx
	push edx
	push ebx
	
	mov ecx, 0
	mov eax, 1
bucla_ridicare_la_putere_numar:
    cmp ecx, [ebp+12]
	je salt_dupa_ridicare_la_putere_numar
	mov edx, 1
	mov ebx, [ebp+8]
	imul ebx
	inc ecx
    jmp bucla_ridicare_la_putere_numar
salt_dupa_ridicare_la_putere_numar:
    pop ebx
	pop edx
	pop ecx
	
    mov esp, ebp
    pop ebp
	ret 8
ridicarea_la_putere_numar_dat endp

;;Derivata unui polinom
;;derivare_polinom(polinom, polinom2)
;;                (+8     , +12     )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
derivare_polinom proc
    push ebp               
    mov ebp, esp
	
	pusha
	push [ebp+8]
	call numar_elemente
	mov edi, eax           ;; edi - numarul de elemente ale polinomului
	
	mov ecx, 0
	mov ebx, 0
	
bucla_derivare_polinom:
   cmp ecx, edi                 ;; verificam daca contorul a ajuns la 0
   je salt_dupa_derivare  
	
   mov esi, [ebp+8]
   mov esi, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad]
   
   cmp esi, 0
   je eticheta_1_derivare
	
	mov edx, 0
	mov eax, esi                                                                 ;; grad -1
	
	push esi
	mov esi, [ebp+8]
    mov esi, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient]
    imul esi
	pop esi
	
	
    dec esi
	mov edx, [ebp+12]
    mov [edx + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], eax
	mov [edx + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], esi
	
   inc ebx
eticheta_1_derivare:
   inc ecx
   jmp bucla_derivare_polinom
   
salt_dupa_derivare:	 

	mov edx, [ebp+12]
    mov [edx + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], -1 ;;pentru ca sa stiu unde se termina
	mov [edx + ebx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], -1
	
	popa
    mov esp, ebp
	pop ebp
	ret 8
derivare_polinom endp
	

;;Integrarea unui polinom
;;integrare_polinom(polinom, polinom_integrat)
;;                (+8     , +12     )
;integrala(10x^2-60x^3+20x^5-100x^6-23x^8+5x^10)dx
;3x^3-15x^3+3x^6-14x^7-2x^9+0x^11+C
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
integrare_polinom proc
	push ebp               
    mov ebp, esp
	
	sub esp, 8
	pusha
	push [ebp+12]
	call numar_elemente
	mov [ebp-4], eax       ;; numar elemente poliom 2
	
	push [ebp+8]
	call numar_elemente
	mov [ebp-8], eax       ;; numar elemente poliom 1
	
	mov ecx, 0
	mov edx, 0            ;; contor polinom
	
	push [ebp+12]
	push [ebp+8]
	call copiere_polinom
	
bucla_integrare:
    cmp ecx, [ebp-8]
	je salt_dupa_integrare
	
	mov esi, [ebp+8]
	mov edi, [ebp+12]
	
	push edx                        ;; salvez edx
	
	mov edx, 0
	mov ebx, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad]
	add ebx, 1 
	mov eax, [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient]
	cdq
	idiv ebx
	
	pop edx                      ;; iau inapoi edx
	
	cmp eax, 0                   ;; daca in urma impartirii ne va da 0
	je coeficient_zero
	
	mov [edi + edx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], ebx
	mov [edi + edx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], eax
	inc edx
coeficient_zero:
	
	inc ecx
	jmp bucla_integrare
	
salt_dupa_integrare:
	
	mov [edi + edx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], -1
	mov [edi + edx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], -1
	popa
    mov esp, ebp
	pop ebp
	ret 8
integrare_polinom endp
	
	
;;Calculul unui polinom intr-un punct x dat
;;calculul_unui_polinom_in_x_dat(polinom, x_dat)
;;;;;;;;                            (+8     , +12)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

calculul_unui_polinom_in_x_dat proc
    push ebp               
    mov ebp, esp
	
	sub esp, 4
	push [ebp+8]
	call numar_elemente
	mov [ebp-4], eax       ;; numar elemente poliom 1
	
	mov ecx, 0
	mov ebx, 0
bucla_calcul_polinom_in_punct_dat:
    cmp ecx, [ebp-4]
	je salt_dupa_calcul_polinom_in_punct_dat
	
	mov esi, [ebp+8]
	
    push [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad]
	push [ebp+12]
	call ridicarea_la_putere_numar_dat
	 
	mov esi, [ebp+8]
	mov edx, 1
	imul [esi + ecx*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient]
	add ebx, eax
	
    inc ecx
	jmp bucla_calcul_polinom_in_punct_dat
	
salt_dupa_calcul_polinom_in_punct_dat:
    
	mov eax, ebx
	
    mov esp, ebp
	pop ebp
	ret 8

calculul_unui_polinom_in_x_dat endp



;;Adaugare 1 ca si coeficient in string daca nu exista nimic in fata lui x
;; Cazuri -x^6   --> -1x^6 - pentru a putea extrage coeficientul cu sscanf
;;adaugare_coef_1_string(sir_element)
;;;;;;;;         	    (+8         )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
adaugare_coef_1_string proc
	push ebp               
    mov ebp, esp
	pusha
	
	mov eax, [ebp+8]    ;; sirul
	mov ecx, 0          ;; contor
	mov edx, -1         ;; index-ul lui x
	
bucla_index_x:
	mov ebx, 0
	mov bl, [eax+ecx]
	cmp bl, 0
	je dupa_bucla_index_x
	
	cmp bl, caracter_polinom
	jne incrementare_bucla_index_x
	mov edx, ecx
incrementare_bucla_index_x:
	inc ecx
	jmp bucla_index_x
dupa_bucla_index_x:

	cmp edx, -1
	je final_adaugare_coef_1
	sub edx, 1                 ;; elemetul dinaintea lui x in sir
	
	cmp edx, -1                ;; cazul x
	je pune_coef_1
	
	mov ebx, 0
	mov bl, [eax+edx]
	cmp bl, plus
	je pune_coef_1             ;; cazul +x  
	
	cmp bl, minus             ;; cazul -x  
	je pune_coef_1 
	jmp final_adaugare_coef_1
	
pune_coef_1:
	inc edx
	inc ecx
bucla_coef_1:
	cmp ecx, edx              ;; mut totul mai la dreapta
	je final_bucla_coef_1
	
	mov ebx, 0
	mov bl, [eax+ecx-1]
	mov [eax+ecx], bl
	
	dec ecx
	jmp bucla_coef_1
final_bucla_coef_1:
	mov bl, '1'
	mov [eax+edx], bl

final_adaugare_coef_1:
	popa
	mov esp, ebp
	pop ebp
	ret 4
	
adaugare_coef_1_string endp



;;Adaugare element polinom
;;adaugare_element_polinom_din_sir(sir_element, polinom)
;;;;;;;;         				  (+8         , +12    )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
adaugare_element_polinom_din_sir proc
	push ebp               
    mov ebp, esp
	pusha
	
	push [ebp+12]
	call numar_elemente
	mov edi, eax          ;; edi - numar elemente polinom
	
	;; Adaug coeficientul 1 daca e cazul
	push [ebp+8]
	call adaugare_coef_1_string
	
	;; Verific daca avem x in string
	mov eax, [ebp+8]      ;; sirul 
	mov ecx, 0
	mov edx, 0            ;; 0 - nu e x in sir, 1 - e x in sir
	mov esi, 0            ;; 0 - nu e '^' in sir, 1 - e '^' in sir

bucla_x:
	mov ebx, 0
	mov bl, [eax+ecx]
	cmp bl, 0
	je dupa_bucla_x
	
	cmp bl, caracter_polinom
	jne comparatie_putere
	mov edx, 1            ;; am gasit x

comparatie_putere:
	cmp bl, caracter_putere
	jne incrementare_bucla
	mov esi, 1            ;; am gasit ^
incrementare_bucla:
	inc ecx
	jmp bucla_x
dupa_bucla_x:

	mov ecx, 0      ;; gradul extras
	mov ebx, 0      ;; coeficientul extras
	
	cmp edx, 1
	je salt_extragere_x
	
	pusha
	;; Extrag coeficientul folosind sscanf pentru cazul cand grad=0
	push offset coef_polinom
	push offset format_element_constant_polinom
	push eax 
	call sscanf
	add esp, 12
	popa
	
	mov ebx, coef_polinom
	mov ecx, 0
	
	jmp final_extragere
salt_extragere_x:

	cmp esi, 1
	je salt_extragere_putere

	pusha
	;; Extrag coeficientul folosind sscanf pentru cazul cand grad=1
	push offset coef_polinom
	push offset format_element_grad_1_polinom
	push eax 
	call sscanf
	add esp, 12
	popa
	
	mov ebx, coef_polinom
	mov ecx, 1
	
	jmp final_extragere
salt_extragere_putere:
	pusha
	;; Extrag gradul si coeficientul folosind sscanf
	push offset grad_polinom
	push offset coef_polinom
	push offset format_element_x_polinom
	push eax 
	call sscanf
	add esp, 16 
	popa
	
	mov ebx, coef_polinom
	mov ecx, grad_polinom

final_extragere:

	cmp ebx,0                         ;; in cazul polinomului null
	je salt_final_extragere_element
	
	mov esi, [ebp+12]
    mov [esi + edi*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], ecx
    mov [esi + edi*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], ebx
	inc edi
	;; Terminatorul pentru polinom
	mov [esi + edi*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.grad], -1
    mov [esi + edi*(size ELEMENT_POLINOM) + ELEMENT_POLINOM.coeficient], -1
	
salt_final_extragere_element:

	popa
	mov esp, ebp
	pop ebp
	ret 8
adaugare_element_polinom_din_sir endp


;;Citirea unui polinom
;;citire_polionom(sir_poliom, polinom)
;;;;;;;;         (+8        , +12    )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
citire_polionom proc
	push ebp               
    mov ebp, esp
	pusha
	
	mov eax, [ebp+8]        ;; string-ul cu polinomul
	mov ecx, 0              ;; contorul
	
	push [ebp+12]
	call initializare_polinom ;; initalizez polinomul - polinomul null
	
	mov esi, 0                ;; ultimul index la care incepe un element al polinomului
bucla_citire:
	mov ebx, 0
	mov bl, [eax+ecx]      ;; iau elementul din sir
	cmp bl, 0              ;; 0 - terminator de sir
	je salt_dupa_citire
	
	cmp bl, plus
	je extragere_element_polinom
	cmp bl, minus
	je extragere_element_polinom
	jmp continuare_bucla_mare
extragere_element_polinom:
	push ebx              ;; salvez ebx inainte de a se scimba
	mov edx, 0
	mov ebx, esi          ;; plec de ultimul index
	
bulca_extragere_element:
	cmp ebx, ecx          ;; ma duc pana la index
	je iesire_bulcla_extragere_element
	
	push ecx             ;; salvez ecx inainte de a se scimba
	
	mov ecx, 0
	mov cl, [eax+ebx]
	mov polinom_string_aux[edx], cl
	
	pop ecx
	
	inc ebx
	inc edx
	jmp bulca_extragere_element
iesire_bulcla_extragere_element:
	mov polinom_string_aux[edx], 0  ;; terminatorul de sir
	
	push [ebp+12]
	push offset polinom_string_aux
	call adaugare_element_polinom_din_sir
	
	mov esi, ecx                    ;; actualizez ultima pozitie
	pop ebx                         ;; salvez inapoi valoarea lui ebx
	
continuare_bucla_mare:
	inc ecx
	jmp bucla_citire
salt_dupa_citire:

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Luam si ultimul element din sir
	mov edx, 0
	mov ebx, esi          ;; plec de ultimul index
	
bulca_extragere_element_2:
	cmp ebx, ecx          ;; ma duc pana la index
	je iesire_bulcla_extragere_element_2
	
	push ecx             ;; salvez ecx inainte de a se scimba
	
	mov ecx, 0
	mov cl, [eax+ebx]
	mov polinom_string_aux[edx], cl
	
	pop ecx
	
	inc ebx
	inc edx
	jmp bulca_extragere_element_2
iesire_bulcla_extragere_element_2:
	mov polinom_string_aux[edx], 0  ;; terminatorul de sir
	
	push [ebp+12]
	push offset polinom_string_aux
	call adaugare_element_polinom_din_sir
	
	mov esi, ecx                    ;; actualizez ultima pozitie
	
	popa
	mov esp, ebp
	pop ebp
	ret 8
citire_polionom endp

start:
    ;; Afiare meniu
	push offset descriere_meniu_1
	call printf
	add esp, 4
	push offset descriere_meniu_2
	call printf
	add esp, 4
	push offset descriere_meniu_3
	call printf
	add esp, 4
	push offset descriere_meniu_4
	call printf
	add esp, 4
	
bucla_program:
	push offset afisare_operatie
	call printf
	add esp, 4
	
	push offset numar_operatie
	push offset format_citire_operatie
	call scanf
	add esp, 8
	
	;; Alegem operatia
	cmp numar_operatie, 1
	je operatie_1
	cmp numar_operatie, 2
	je operatie_2
	cmp numar_operatie, 3
	je operatie_3
	cmp numar_operatie, 4
	je operatie_4
	cmp numar_operatie, 5
	je operatie_5
	cmp numar_operatie, 6
	je operatie_6
	cmp numar_operatie, 7
	je operatie_7
	cmp numar_operatie, 8
	je operatie_8
	cmp numar_operatie, 9
	je operatie_9
	cmp numar_operatie, 10
	je operatie_10
	cmp numar_operatie, 11
	je operatie_11

	jmp finalizare_program

;;;;;;;
operatie_1:
	push offset afisare_operatie_citire_alegere_polinom
	call printf
	add esp, 4
	push offset numar_polinom_ales
	push offset format_citire_numar_ales_polinom
	call scanf 
	add esp, 8
	
	push offset afisare_citire_polinom
	call printf
	add esp, 4
	push offset polinom_string
	push offset format_citire_polinom
	call scanf
	add esp, 8
	
	cmp numar_polinom_ales, 1      ;; aleg in care polinom pun rezultatul citirii
	je citire_polinom_1
	
	push offset polinom2           ;; polinom 2
	push offset polinom_string
	call citire_polionom
	jmp finalizare_operatie_citire
citire_polinom_1:
	push offset polinom           ;; polinom 1
	push offset polinom_string
	call citire_polionom
finalizare_operatie_citire:
	
	push offset afisare_operatie_citire_success
	call printf 
	add esp, 4
	jmp bucla_program

;;;;;;;
operatie_2:
	push offset afisare_operatie_sciere_alegere_polinom
	call printf
	add esp, 4
	push offset numar_polinom_ales
	push offset format_sciriere_numar_ales_polinom
	call scanf 
	add esp, 8
	
	
	
	cmp numar_polinom_ales, 1      ;; aleg pe care polinom il afisez
	je afisare_polinom_1
	
	push offset polinom2           ;; polinom 2
	call afisare_polinom
	jmp finalizare_operatie_afisare
afisare_polinom_1:
	push offset polinom           ;; polinom 1
	call afisare_polinom
finalizare_operatie_afisare:
	jmp bucla_program
	
	
;;;;;;;
operatie_3:
	push offset afisare_operatie_negare_alegere_polinom
	call printf
	add esp, 4
	push offset numar_polinom_ales
	push offset format_sciriere_numar_ales_polinom
	call scanf 
	add esp, 8
	
	;Afisare text polinom
	push offset afisare_polinom_normal
	call printf
	add esp, 4
	
	cmp numar_polinom_ales, 1      ;; aleg pe care polinom il afisez
	je negare_polinom_1
	
	push offset polinom2
	call afisare_polinom
	
	push offset polinom3           ;; polinom 2
	push offset polinom2
	call negarea_polinom
	
	jmp finalizare_operatie_negare
negare_polinom_1:
	push offset polinom
	call afisare_polinom
	
	push offset polinom3           
	push offset polinom           ;; polinom 1
	call negarea_polinom
finalizare_operatie_negare:

	push offset afisare_negare_rezultat
	call printf
	add esp, 4

	push offset polinom3
	call afisare_polinom
	jmp bucla_program
	
	
;;;;;;;
operatie_4:
	push offset afisare_operatie_inmultire_scalar_polinom
	call printf
	add esp, 4
	push offset numar_polinom_ales
	push offset format_sciriere_numar_ales_polinom
	call scanf 
	add esp, 8
	
	;; Luam scalarul
	push offset afisare_alegere_scalar
	call printf
	add esp, 4
	push offset numar_scalar
	push offset format_sciriere_numar_ales_polinom
	call scanf 
	add esp, 8
	
	;Afisare text polinom
	push offset afisare_polinom_normal
	call printf
	add esp, 4
	
	cmp numar_polinom_ales, 1      ;; aleg pe care polinom il afisez
	je inmultire_scalar_polinom_1
	
	push offset polinom2
	call afisare_polinom
	
	push numar_scalar
	push offset polinom3           ;; polinom 2
	push offset polinom2
	call inmultirea_cu_scalar
	
	jmp finalizare_operatie_inmultire_scalar
inmultire_scalar_polinom_1:
	push offset polinom
	call afisare_polinom
	
	push numar_scalar 
	push offset polinom3                   
	push offset polinom           ;; polinom 1
	call inmultirea_cu_scalar
finalizare_operatie_inmultire_scalar:

	push offset afisare_inmultire_scalar_rezultat
	call printf
	add esp, 4

	push offset polinom3
	call afisare_polinom
	jmp bucla_program
	
	
	
	
;;;;;;;
operatie_5:
	;; Polinom1
	push offset afisare_ecran_polinom_1
	call printf
	add esp, 4
	
	push offset polinom
	call afisare_polinom
	
	;; Polinom2
	push offset afisare_ecran_polinom_2
	call printf
	add esp, 4
	
	push offset polinom2
	call afisare_polinom
	
	;; Suma
	push offset afisare_adunare_rezultat
	call printf
	add esp, 4
	
	push offset polinom3
	push offset polinom2
	push offset polinom
	call adunarea_polinoame
	
	push offset polinom3
	call afisare_polinom
	jmp bucla_program
	
	
	
	
;;;;;;;;;;;;;;
operatie_6:
	;; Polinom1
	push offset afisare_ecran_polinom_1
	call printf
	add esp, 4
	
	push offset polinom
	call afisare_polinom
	
	;; Polinom2
	push offset afisare_ecran_polinom_2
	call printf
	add esp, 4
	
	push offset polinom2
	call afisare_polinom
	
	;; Scaderea
	push offset afisare_scadere_rezultat
	call printf
	add esp, 4
	
	push offset polinom3
	push offset polinom2
	push offset polinom
	call scaderea_polinoame
	
	push offset polinom3
	call afisare_polinom
	jmp bucla_program
	
	
	
;;;;;;;
operatie_7:
	;; Polinom1
	push offset afisare_ecran_polinom_1
	call printf
	add esp, 4
	
	push offset polinom
	call afisare_polinom
	
	;; Polinom2
	push offset afisare_ecran_polinom_2
	call printf
	add esp, 4
	
	push offset polinom2
	call afisare_polinom
	
	;; Scaderea
	push offset afisare_inmultire_rezultat
	call printf
	add esp, 4
	
	push offset polinom3
	push offset polinom2
	push offset polinom
	call inmultirea_polinoame
	
	push offset polinom3
	call afisare_polinom
	jmp bucla_program
	

	
;;;;;;;
operatie_8:
	push offset afisare_operatie_putere_alegere_polinom
	call printf
	add esp, 4
	push offset numar_polinom_ales
	push offset format_sciriere_numar_ales_polinom
	call scanf 
	add esp, 8
	
	;; Luam puterea
	push offset afisare_alegere_putere
	call printf
	add esp, 4
	push offset numar_putere
	push offset format_sciriere_numar_ales_polinom
	call scanf 
	add esp, 8
	
	;Afisare text polinom
	push offset afisare_polinom_normal
	call printf
	add esp, 4
	
	cmp numar_polinom_ales, 1      ;; aleg pe care polinom il afisez
	je ridicare_la_putere_polinom_1
	
	push offset polinom2
	call afisare_polinom
	
	push offset polinom3           ;; polinom 2
	push numar_putere
	push offset polinom2
	call ridicarea_la_putere
	
	jmp finalizare_operatie_ridicare_la_putere
ridicare_la_putere_polinom_1:
	push offset polinom
	call afisare_polinom
	
	push offset polinom3                   
	push numar_putere
	push offset polinom           ;; polinom 1
	call ridicarea_la_putere
finalizare_operatie_ridicare_la_putere:

	push offset afisare_inmultire_scalar_rezultat
	call printf
	add esp, 4

	push offset polinom3
	call afisare_polinom
	jmp bucla_program
	
	
;;;;
operatie_9:
	push offset afisare_operatie_calcul_punct_alegere_polinom
	call printf
	add esp, 4
	push offset numar_polinom_ales
	push offset format_sciriere_numar_ales_polinom
	call scanf 
	add esp, 8
	
	;; Luam punctul dat
	push offset afisare_alegere_calcul_punct
	call printf
	add esp, 4
	push offset numar_punct
	push offset format_sciriere_numar_ales_polinom
	call scanf 
	add esp, 8
	
	;Afisare text polinom
	push offset afisare_polinom_normal
	call printf
	add esp, 4
	
	cmp numar_polinom_ales, 1      ;; aleg pe care polinom il afisez
	je calcul_punct_polinom_1
	
	push offset polinom2
	call afisare_polinom
	  
	push numar_punct 				 ;; polinom 2
	push offset polinom2
	call calculul_unui_polinom_in_x_dat
	
	jmp finalizare_operatie_calcul_punct
calcul_punct_polinom_1:
	push offset polinom
	call afisare_polinom
	                 
	push numar_punct
	push offset polinom           ;; polinom 1
	call calculul_unui_polinom_in_x_dat
finalizare_operatie_calcul_punct:
	
	push eax
	push offset afisare_calcul_punct_rezultat
	call printf
	add esp, 8
	jmp bucla_program

	
	
;;;;;;;;;
operatie_10:
	push offset afisare_operatie_derivare_polinom
	call printf
	add esp, 4
	push offset numar_polinom_ales
	push offset format_sciriere_numar_ales_polinom
	call scanf 
	add esp, 8
	
	;Afisare text polinom
	push offset afisare_polinom_normal
	call printf
	add esp, 4
	
	cmp numar_polinom_ales, 1      ;; aleg pe care polinom il afisez
	je derivare_polinom_1
	
	push offset polinom2
	call afisare_polinom
	
	push offset polinom3           ;; polinom 2
	push offset polinom2
	call derivare_polinom
	
	jmp finalizare_operatie_derivare
derivare_polinom_1:
	push offset polinom
	call afisare_polinom
	
	push offset polinom3           
	push offset polinom           ;; polinom 1
	call derivare_polinom
finalizare_operatie_derivare:

	push offset afisare_derivare_rezultat
	call printf
	add esp, 4

	push offset polinom3
	call afisare_polinom
	jmp bucla_program
	
	

;;;;;;;;;;
operatie_11:
	push offset afisare_operatie_integrare_polinom
	call printf
	add esp, 4
	push offset numar_polinom_ales
	push offset format_sciriere_numar_ales_polinom
	call scanf 
	add esp, 8
	
	;Afisare text polinom
	push offset afisare_polinom_normal
	call printf
	add esp, 4
	
	cmp numar_polinom_ales, 1      ;; aleg pe care polinom il afisez
	je integrare_polinom_1
	
	push offset polinom2
	call afisare_polinom
	
	push offset polinom3           ;; polinom 2
	push offset polinom2
	call integrare_polinom
	
	jmp finalizare_operatie_integrare
integrare_polinom_1:
	push offset polinom
	call afisare_polinom
	
	push offset polinom3           
	push offset polinom           ;; polinom 1
	call integrare_polinom
finalizare_operatie_integrare:

	push offset afisare_integrare_rezultat
	call printf
	add esp, 4

	push offset polinom3
	call afisare_integrala_polinom
	jmp bucla_program
	
;;;;;;;;;
finalizare_program:
	push offset parasire_program
	call printf
	add esp, 4
	
	push 0
	call exit
end start