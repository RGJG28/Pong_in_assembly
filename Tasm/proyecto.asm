;Draw ball
;Martinez C.
;Zamora A.
;Vargas B.
;Jimenez R.
title "Proyecto eypc"
	.model small
	.386
	.stack  64
;____________________________________________________________________________
	.data
	;Valor ASCII de caracteres para el marco del programa
	marcoEsqInfIzq 		equ 	200d 	;'╚'
	marcoEsqInfDer 		equ 	188d	;'╝'
	marcoEsqSupDer 		equ 	187d	;'╗'
	marcoEsqSupIzq 		equ 	201d 	;'╔'
	marcoCruceVerSup	equ		203d	;'╦'
	marcoCruceHorDer	equ 	185d 	;'╣'
	marcoCruceVerInf	equ		202d	;'╩'
	marcoCruceHorIzq	equ 	204d 	;'╠'
	marcoCruce 			  equ		206d	;'╬'
	marcoHor 			    equ 	205d 	;'═'
	marcoVer 			    equ 	186d 	;'║'
;____________________________________________________________________________
	;Para temporizador

 	text db "text$"
 	segundos db 99
 	segundos_auxiliar db 0
;____________________________________________________________________________
  ;Atributos de color de BIOS
	;Valores de color para carácter
	cNegro 			  equ		00h
	cAzul 			  equ		01h
	cVerde 			  equ 	02h
	cCyan 			  equ 	03h
	cRojo 			  equ 	04h
	cMagenta 		  equ		05h
	cCafe 			  equ 	06h
	cGrisClaro		equ		07h
	cGrisOscuro		equ		08h
	cAzulClaro		equ		09h
	cVerdeClaro		equ		0Ah
	cCyanClaro		equ		0Bh
	cRojoClaro		equ		0Ch
	cMagentaClaro	equ		0Dh
	cAmarillo 		equ		0Eh
	cBlanco 		  equ		0Fh
;____________________________________________________________________________
  ;Valores de color para fondo de carácter
	bgNegro 	  	equ		00h
	bgAzul 		  	equ		10h
	bgVerde 	   	equ 	20h
	bgCyan 		  	equ 	30h
	bgRojo 		  	equ 	40h
	bgMagenta 		equ		50h
	bgCafe 			  equ 	60h
	bgGrisClaro		equ		70h
	bgGrisOscuro	equ		80h
	bgAzulClaro		equ		90h
	bgVerdeClaro	equ		0A0h
	bgCyanClaro		equ		0B0h
	bgRojoClaro		equ		0C0h
	bgMagentaClaro	equ		0D0h
	bgAmarillo 		  equ		0E0h
	bgBlanco 	    	equ		0F0h
;____________________________________________________________________________
  ;Definicion de variables
	titulo 			db 		"PONJ","$"
	player1 		db 		"Player 1","$"
	player2 		db 		"Player 2","$"	
	tiempo_cadena	db 		"0:00","$"
	tiempo_s 		db 		0
;____________________________________________________________________________
	;Pensar si las necesito
	p1_score 		db 		0
	p2_score		db 		0
;____________________________________________________________________________
	;variables para guardar la posición del player 1
	p1_col			db 		6
	p1_ren			db 		14
;____________________________________________________________________________
	;variables para guardar la posición del player 2
	p2_col 			db 		73
	p2_ren 			db 		14
;____________________________________________________________________________
	;Limites de la ventana 640*480
	VENTANA_ANCHO DW 282h						; (642 pixeles)
	VENTA_ALTURA  DW 1E0h						; (480 pixeles)
	VENTANA_B  	  DW 6 							; variable utilizada para revisar colisiones (Limites)
	VENTANA_B_1 DW 71 ;Variable utilizada para colisiones en el margen horizontal superior
;____________________________________________________________________________
	TIEMPO_AUX 	  DB 0 							  ; Variable utilizada para verificar si el tiempo ha cambiado
	JUEGO_ACT     DB 1  							; Hay actividad en el juego(1->SI, 0 -> NO (Fin del Juego))
	SALIENDO_D_JUEGO DB 0 						;
	IND_GANADOR   DB 0 							  ; Indice del ganador (1-_Jugador 1, 2 ->Jugador 2)
	ESCENA_ACT    DB 0                ; Indice de la escena actual (0--> Menu principal, 1-> En el juego)
;____________________________________________________________________________
	TEXTO_X_SALIDA DB "[x]","$" ;Texto de la x de salida

	TEXTO_PUNTOS_JUGADOR_UNO DB '0','$'		       ;Texto con los puntos del jugador uno
	TEXTO_PUNTOS_JUGADOR_DOS DB '0','$'		       ;Texto con los puntos del jugador dos
	TEXTO_FIN_JUEGO_T			 DB 'FIN DEL JUEGO $'  ;Texto con la palabra fin del juego
	TEXTO_FIN_JUEGO_GANADOR  DB 'GANADOR: JUGADOR 0 $'              ;Señala al ganador ;Indice a moficar '18'
	TEXTO_JUGAR_OTRAVEZ		 DB 'PRESIONE R PARA JUGAR OTRA VEZ $'    ;Mensaje para jugar de nuevo
	TEXTO_MENU_FIN_JUEGO     DB 'PRESIONE E PARA SALIR DEL JUEGO $' ;Salir del jeugo	
;____________________________________________________________________________
	TEXTO_MENU_P 				 DB 'MENU PRINCIPAL $'
	TEXTO_MENU_TECLA			 DB 'PRESIONES UNA TECLA $'
 	TEXTO_MENU_UNJUGADOR 	 DB '1) UN JUGADOR           $' 	; Mensaje para solo un jugador
	TEXTO_MENU_MULTIJUGADOR  DB '2) DOS JUGADORES        $' 			; Mensaje para dos jugadores
	TEXTO_MENU_SALIR         DB '3) SALIR DEL JUEGO      $' 		;Salir del juego
;____________________________________________________________________________
	;Posicion de origen (x,y)
	P_ORIGEN_X   DW 140h;
	P_ORIGEN_Y    DW 0F0h;

	PELOTA_X DW 140h								; Posicion X (columna) de la pelota
	PELOTA_Y DW 0F0h								; Posicion Y (linea) de la pelota
	PELOTA_SIZE DW 07h							; Tamaño de la pelota (Ancho y alto)
	VELOCIDAD_PELOTA_X DW 04H 					; Velocidad de la pelota en x (horizontal)
	VELOCIDAD_PELOTA_Y DW 04H					; Velocidad de la pelota en y (Vertical)
	;Paleta izquierda 							
	PALETA_IZQUIERDA_X DW 0Fh					; Posicion actual de la paleta izquierda en x
	PALETA_IZQUIERDA_Y DW 0C8h					; Posicion actual de la paleta izquierda en y
	PUNTOS_JUGADOR_UNO DB 0 					; Puntos del jugador de la paleta izquerda (Jugador 1)

	;Paleta derecha
	PALETA_DERECHA_X DW 260h					; Posicion actual de la paleta derecha en x
	PALETA_DERECHA_Y DW 0C8h						; Posicion actual de la paleta iderecha en y
	PUNTOS_JUGADOR_DOS DB 0 					;Puntos del jugador de la paleta derecha (jugador 2)

	AI_JUGADOR    		DB 0 						;La paleta derecha sera controlada por IA
;____________________________________________________________________________
	;Tamaño de las paletas
	PALETA_ANCHO	 DW	08h					;	Ancho de la paleta determinado
	PALETA_ALTO 	 DW 	35h					;  Altura de la paleta determinado

	VELOCIDAD_PALETA DW 0Ah						; Velocidad de la paleta (modificable)
;____________________________________________________________________________
;_____________________________MACROS VARIABLES_______________________________
	col_aux 		db 		0
	ren_aux 		db 		0
	;variable que se utiliza como valor 10 auxiliar en divisiones
	diez 			dw 		10
	;Una variable contador para algunos loops
	conta 			db 		0
	;Variables que sirven de parametros para el procedimiento IMPRIME_BOTON
	boton_caracter 	db 		0
	boton_renglon 	db 		0
	boton_columna 	db 		0
	boton_color		db 		0
	boton_bg_color	db 		0
	;Auxiliar para calculo de coordenadas del mouse
	ocho		db 		8
	;Cuando el driver del mouse no esta disponible
	no_mouse		db 	'No se encuentra driver de mouse. Presione [enter] para salir$'
;____________________________________________________________________________
;__________________________________MACROS____________________________________
;clear - Limpia pantalla
clear macro
	mov ax,0003h 	;ah = 00h, selecciona modo video
					;al = 03h. Modo texto, 16 colores
	int 10h		;llama interrupcion 10h con opcion 00h. 
				;Establece modo de video limpiando pantalla
endm

;posiciona_cursor - Cambia la posición del cursor a la especificada con 'renglon' y 'columna' 
posiciona_cursor macro renglon,columna
	mov dh,renglon	;dh = renglon
	mov dl,columna	;dl = columna
	mov bx,0
	mov ax,0200h 	;preparar ax para interrupcion, opcion 02h
	int 10h 		;interrupcion 10h y opcion 02h. Cambia posicion del cursor
endm 

;inicializa_ds_es - Inicializa el valor del registro DS y ES
inicializa_ds_es 	macro
	mov ax,@data
	mov ds,ax
	mov es,ax 		;Este registro se va a usar, junto con BP, para imprimir cadenas utilizando interrupción 10h
endm

;muestra_cursor_mouse - Establece la visibilidad del cursor del mouser
muestra_cursor_mouse	macro
	mov ax,1		;opcion 0001h
	int 33h			;int 33h para manejo del mouse. Opcion AX=0001h
					;Habilita la visibilidad del cursor del mouse en el programa
endm

;oculta_cursor_teclado - Oculta la visibilidad del cursor del teclado
oculta_cursor_teclado	macro
	mov ah,01h 		;Opcion 01h
	mov cx,2607h 	;Parametro necesario para ocultar cursor
	int 10h 		;int 10, opcion 01h. Cambia la visibilidad del cursor del teclado
endm

;apaga_cursor_parpadeo - Deshabilita el parpadeo del cursor cuando se imprimen caracteres con fondo de color
;Habilita 16 colores de fondo
apaga_cursor_parpadeo	macro
	mov ax,1003h 		;Opcion 1003h
	xor bl,bl 			;BL = 0, parámetro para int 10h opción 1003h
  	int 10h 			;int 10, opcion 01h. Cambia la visibilidad del cursor del teclado
endm
;____________________________________________________________________________
;_________________________________COMENTADA__________________________________
;imprime_caracter_color - Imprime un caracter de cierto color en pantalla, especificado por 'caracter', 'color' y 'bg_color'. 
;Los colores disponibles están en la lista a continuacion;
; Colores:
; 0h: Negro
; 1h: Azul
; 2h: Verde
; 3h: Cyan
; 4h: Rojo
; 5h: Magenta
; 6h: Cafe
; 7h: Gris Claro
; 8h: Gris Oscuro
; 9h: Azul Claro
; Ah: Verde Claro
; Bh: Cyan Claro
; Ch: Rojo Claro
; Dh: Magenta Claro
; Eh: Amarillo
; Fh: Blanco
; utiliza int 10h opcion 09h
; 'caracter' - caracter que se va a imprimir
; 'color' - color que tomará el caracter
; 'bg_color' - color de fondo para el carácter en la celda
; Cuando se define el color del carácter, éste se hace en el registro BL:
; La parte baja de BL (los 4 bits menos significativos) define el color del carácter
; La parte alta de BL (los 4 bits más significativos) define el color de fondo "background" del carácter
;____________________________________________________________________________
;__________________________________MACROS____________________________________
imprime_caracter_color macro caracter,color,bg_color
	mov ah,09h				;preparar AH para interrupcion, opcion 09h
	mov al,caracter 		;AL = caracter a imprimir
	mov bh,0				;BH = numero de pagina
	mov bl,color 			
	or bl,bg_color 			;BL = color del caracter
							;'color' define los 4 bits menos significativos 
							;'bg_color' define los 4 bits más significativos 
	mov cx,1				;CX = numero de veces que se imprime el caracter
							;CX es un argumento necesario para opcion 09h de int 10h
	int 10h 				;int 10h, AH=09h, imprime el caracter en AL con el color BL
endm

;imprime_caracter_color - Imprime un caracter de cierto color en pantalla, especificado por 'caracter', 'color' y 'bg_color'. 
; utiliza int 10h opcion 09h
; 'cadena' - nombre de la cadena en memoria que se va a imprimir
; 'long_cadena' - longitud (en caracteres) de la cadena a imprimir
; 'color' - color que tomarán los caracteres de la cadena
; 'bg_color' - color de fondo para los caracteres en la cadena
imprime_cadena_color macro cadena,long_cadena,color,bg_color
	mov ah,13h				;preparar AH para interrupcion, opcion 13h
	lea bp,cadena 			;BP como apuntador a la cadena a imprimir
	mov bh,0				;BH = numero de pagina
	mov bl,color 			
	or bl,bg_color 			;BL = color del caracter
							;'color' define los 4 bits menos significativos 
							;'bg_color' define los 4 bits más significativos 
	mov cx,long_cadena		;CX = longitud de la cadena, se tomarán este número de localidades a partir del apuntador a la cadena
	int 10h 				;int 10h, AH=09h, imprime el caracter en AL con el color BL
endm

;lee_mouse - Revisa el estado del mouse
;Devuelve:
;;BX - estado de los botones
;;;Si BX = 0000h, ningun boton presionado
;;;Si BX = 0001h, boton izquierdo presionado
;;;Si BX = 0002h, boton derecho presionado
;;;Si BX = 0003h, boton izquierdo y derecho presionados
; (400,120) => 80x25 =>Columna: 400 x 80 / 640 = 50; Renglon: (120 x 25 / 200) = 15 => 50,15
;;CX - columna en la que se encuentra el mouse en resolucion 640x200 (columnas x renglones)
;;DX - renglon en el que se encuentra el mouse en resolucion 640x200 (columnas x renglones)
lee_mouse	macro
	mov ax,0003h
	int 33h
endm

;comprueba_mouse - Revisa si el driver del mouse existe
comprueba_mouse 	macro
	mov ax,0		;opcion 0
	int 33h			;llama interrupcion 33h para manejo del mouse, devuelve un valor en AX
					;Si AX = 0000h, no existe el driver. Si AX = FFFFh, existe driver
endm
;____________________________________________________________________________
;__________________________________CODIGO____________________________________
 .code
 inicio:
    ;--------------------------------
    push DS						 					      ; push a la pila de DS segments
    sub AX,AX               					; Limpia los registros de AX
    push AX                 					;
    mov AX,@data            					; 
    mov DS,AX               					;
    pop AX                  					; Lanzamiento superior de la pila
    pop AX                  					;
    ;---------------------------------------------------------
    
     call LIMPIAR_PANTALLA 						; Modo de video con configuracion incial

     REVISA_TIEMPO: 							;Ciclo para revisar el tiempo

       cmp SALIENDO_D_JUEGO,01h 				;
       je  COMIENZA_PROCESO_SALIDA			 	;

     	 cmp ESCENA_ACT,00h 					;
     	 je  MUESTRA_MENU 						;
     	 cmp JUEGO_ACT,00h 						;
     	 je  MUESTRA_FIN_D_JUEGO				;

		 mov AH,2Ch 							; Obtiene el tiempo del sistema
		 int 21h    							; CH = hour CL = minute DH = second DL = 1/100 seconds

		 cmp DL,TIEMPO_AUX						;¿La hora actual = Hora anterior(Tiempo_Aux)?
		 je REVISA_TIEMPO						;Si es igual, revisar de nuevo
		
		;Si es diferente, entonces, dibujar pelota

		 mov TIEMPO_AUX,DL 						; Actualización del tiempo

        call LIMPIAR_PANTALLA					;Modo de video con configuracion incial
         
        call MOVIMIENTO_PELOTA					; Movimiento de la pelora

    	 	call DIBUJAR_PELOTA  				; Dibuja la pelota

    	 	call MOVIMIENTO_PALETAS  			; Movimiento de las paletas

    	 	call DIBUJAR_PALETAS  				; Dibuja las paletas 

    	 	call DIBUJAR_INTERFAZ_U        	    ;INTERFAZ DEL USUARIO

    	 	;call MOUSE_1

    	 	cmp segundos,dh  ;Aqui estoy personalizando el cronometro
    	 	je imprimir_segundo
    	 	jmp sigue
    	 	imprimir_segundo:



    	 	sigue:
    		jmp REVISA_TIEMPO 					; Repetir la revision del tiempo
    		mov segundos_auxiliar,dh
    		MUESTRA_FIN_D_JUEGO:					;
    			call MENU_FIN_D_JUEGO 			;
  				jmp REVISA_TIEMPO 				;
     			
     		MUESTRA_MENU:
     		call DIBUJAR_MENU						;
     		jmp REVISA_TIEMPO 					;

     		COMIENZA_PROCESO_SALIDA:
     			call SALIDA_CONCLUIDA
     	RET
     ENDP
     ;-----------------------------------------------------------------
     ;Movimiento de la pelota
     MOVIMIENTO_PELOTA PROC NEAR
     	 mov AX,VELOCIDAD_PELOTA_X ; Movimiento de la pelota horizontal
		 add PELOTA_X,AX
		 ;Revisa si la pelota ha pasado a los limites superiores izquierdos, (Pelota_x < 0+ ventana_b)
		 ;si coliciona restablece posicion
		 mov AX,VENTANA_B							;
		 cmp PELOTA_X,AX							;Pelota_X es comparada con el limite izquierdo de la pantalla (0+limites de ventana(Ventana_B))
		 jl PUNTO_A_JUGADOR_DOS					;Si es menor, restablece posicion, y suma un punto al jugador 2

		 ;Revisa si la pelota ha pasado a los limites superiores derecho, (Pelota_x > window_ancho -pelota_size - ventana_b)
		 ;si coliciona restablece posicion

		 mov AX, VENTANA_ANCHO					;
		 sub AX,PELOTA_SIZE						;
		 sub AX,VENTANA_B							;	
		 cmp PELOTA_X,AX   						;Pelota_X es comparada con el limite derecho de la pantalla (Pelota_x > window_ancho -pelota_size - ventana_b)
		 jg PUNTO_A_JUGADOR_UNO 				;Si es mayor restablece posicion, y suma un punto al jugador 1
		 jmp MOVIMIENTO_PELOTA_VERTICAL

		 PUNTO_A_JUGADOR_UNO: 					;Un punto al jugador y restablece el punto original de la pelota
			 inc PUNTOS_JUGADOR_UNO  			;Incrementa un punto a jugador 1
     		 call  POSICION_RESET_PELOTA  	;Restablece la posicion original de la pelota en la pantalla
     		 call ACT_T_PUNTOS_JUGADOR_UNO	;Actualiza el texto de los puntos del jugador uno
     		 cmp PUNTOS_JUGADOR_UNO,05h 		;Si el jugador llega a 5 puntos o mas, acaba el juego
     		 jge FIN_D_JUEGO 					   ;
     		 RET

     	 PUNTO_A_JUGADOR_DOS: 					;Un punto al jugador y restablece el punto original de la pelota
     	 	 inc PUNTOS_JUGADOR_DOS 	 		;Incrementa un punto a jugador 2
     	 	 call POSICION_RESET_PELOTA 		;Restablece la posicion original de la pelota en la pantalla

     	 	 call ACT_T_PUNTOS_JUGADOR_DOS	;Actualiza el texto de los puntos del jugador dos

     	 	 cmp PUNTOS_JUGADOR_DOS,05h 		;Si el jugador llega a 5 puntos o mas, acaba el juego
     		 jge FIN_D_JUEGO 					   ;
     	 	 RET	

     	 FIN_D_JUEGO:								;Fin del juego
     	 	cmp PUNTOS_JUGADOR_UNO,05h			;Verifica si el jugador 1 llego a los 5 puntos
     	 	jnl GANADOR_JUGADOR_UNO 			;Si el jugador uno mas de 5 puntos, es el ganador
     	 	jmp GANADOR_JUGADOR_DOS 			;Si no entonces el jugador 2 es el ganador

     	 	GANADOR_JUGADOR_UNO:
     	 		mov IND_GANADOR,01h 				;Actualiza el indice del ganador si es el jugador 1
     	 		jmp CON_FIN_JUEGO

     	 	GANADOR_JUGADOR_DOS:
     	 		mov IND_GANADOR,02h 				;;Actualiza el indice del ganador si es el jugador 2
     	 		jmp CON_FIN_JUEGO 				;

     	 	CON_FIN_JUEGO:

	     	 	mov PUNTOS_JUGADOR_UNO,00h 		;Restablece los puntos del jugador 1
	     	 	mov PUNTOS_JUGADOR_DOS,00h 		;Restablece los puntos del jugador 2
	     	 	call ACT_T_PUNTOS_JUGADOR_UNO		;
	     	 	call ACT_T_PUNTOS_JUGADOR_DOS		;Marca fin del juego
	     	 	mov JUEGO_ACT,00h 					;
	     	 	RET

     	 MOVIMIENTO_PELOTA_VERTICAL:
			 mov AX,VELOCIDAD_PELOTA_Y          ;Movimiento de la pelota vertical
			 add PELOTA_Y,AX;
	 		
 		;Revisa si la pelota a pasado los limites supriores (Pelota_Y <0  + Ventana_B) (Y->Colisión)
 		;Si ha colisionado, revertir la velocidad en Y
		 mov AX,VENTANA_B_1			 				;
		 cmp PELOTA_Y,AX			 				;Pelota_Y <0  + Ventana_B(Y->Colisión)
		 jl NEG_VELOCIDAD_Y 						;Si es menor revertimos la velocidad en Y
		
		;Revisa si la pelota a pasado los limites supriores (Pelota_Y > window_alto -pelota_size - ventana_b) (Y->Colisión)
 		;Si ha colisionado, revertir la velocidad en Y
		 mov AX,VENTA_ALTURA
		 sub AX,PELOTA_SIZE						;
		 sub AX,VENTANA_B							;
		 cmp PELOTA_Y,AX 							;Pelota_Y es comparada con el limite inferior de la pantalla (Pelota_Y > window_alto -pelota_size - ventana_b)	
		 JG NEG_VELOCIDAD_Y						;Si es menor revertir la velocidad en y
		
		;Revisar si la pelota coliciona con la paleta derecha
		; maxx1 > minx2 && minx1 < maxx2 && maxy1 > miny2 && miny1 < maxy2
		; PELOTA_X + PELOTA_SIZE > PALETA_DERECHA_X && BALL_X < PALETA_DERECHA_X + PALETA_ANCHO 
		; && PELOTA_Y + PELOTA_SIZE > PELOTA_DERECHA_Y && PELOTA_Y < PELOTA_DERECHA_Y + PELOTA_ALTO
		
		mov AX,PELOTA_X 							;
		add AX,PELOTA_SIZE 						;
		cmp AX,PALETA_DERECHA_X  				;
		jng REVISAR_COLISION_CON_PALETA_IZQUIERDA ;Si no hay colision revisa para la peleta izquierda
		
		mov AX,PALETA_DERECHA_X 				;
		add AX,PALETA_ANCHO 						;
		cmp PELOTA_X,AX 							;
		jnl REVISAR_COLISION_CON_PALETA_IZQUIERDA; SI no hay colición revisa para la paleta izquierda

		mov AX,PELOTA_Y 							;
		add AX,PELOTA_SIZE 						;
		cmp AX,PALETA_DERECHA_Y 				;
		jng REVISAR_COLISION_CON_PALETA_IZQUIERDA; Si no hay colicion revisa para la paleta izquierda

		mov AX,PALETA_DERECHA_Y					;
		add AX,PALETA_ALTO						;
		cmp PELOTA_Y,AX 							;
		jnl REVISAR_COLISION_CON_PALETA_IZQUIERDA;
		
		;Si llega a este punto, la pelota a colicionado con la paleta derecha

		jmp NEG_VELOCIDAD_X

		REVISAR_COLISION_CON_PALETA_IZQUIERDA:

		;Revisar si la pelota coliciona con la paleta izquierda 
		; maxx1 > minx2 && minx1 < maxx2 && maxy1 > miny2 && miny1 < maxy2
		; PELOTA_X + PELOTA_SIZE > PALETA_IZQUIERDA_X && BALL_X < PALETA_IZQUIERDA_X + PALETA_ANCHO 
		; && PELOTA_Y + PELOTA_SIZE > PELOTA_IZQUIERDA_Y && PELOTA_Y < PELOTA_IZQUIERDA_Y + PELOTA_ALTO

		mov AX,PELOTA_X 							;
		add AX,PELOTA_SIZE 						;
		cmp AX,PALETA_IZQUIERDA_X 				;
		jng REVISAR_SALIDA_COLISION   		;Si no hay colision revisa para la paleta derecha
		
		mov AX,PALETA_IZQUIERDA_X 				;
		add AX,PALETA_ANCHO 						;
		cmp PELOTA_X,AX 							;
		jnl REVISAR_SALIDA_COLISION   		;Si no hay colision revisa para la paleta derecha

		mov AX,PELOTA_Y 							;
		add AX,PELOTA_SIZE 						;
		cmp AX,PALETA_IZQUIERDA_Y  				;
		jng REVISAR_SALIDA_COLISION   		;Si no hay colision revisa para la paleta derecha

		mov AX,PALETA_IZQUIERDA_Y				;
		add AX,PALETA_ALTO						;
		cmp PELOTA_Y,AX 							;
		jnl REVISAR_SALIDA_COLISION   		;Si no hay colision revisa para la paleta derecha
		
		;Si llega a este punto, la pelota a colicionado con la paleta derecha
		jmp NEG_VELOCIDAD_X

       NEG_VELOCIDAD_Y: 
     		neg VELOCIDAD_PELOTA_Y 					;Velocidad_Pelota_Y = -Velocidad_Pelota_Y
	     	RET
		 NEG_VELOCIDAD_X:
		 	neg  VELOCIDAD_PELOTA_X   			 ;Velocidad contraria
		 	RET
		 REVISAR_SALIDA_COLISION:
			RET

   ENDP
	;-----------------------------------------------------------------------
	;Movimiento de las paletas 
	MOVIMIENTO_PALETAS PROC NEAR

	;Paleta izquierda
		;Revisamos si hay una tecla presionada (Si no salimos del procedimiento)
		mov AH,01h
		int 16h
		jz REVISA_MOVIMIENTO_PALETA_DERECHA   ; ZF=1,  JZ -> SALTA SI ES 0
		; Revisamos mientras este presionado (AL=ASSCII caracter)
		mov AH,00H;
		int 16H
		;Si es 'w' o 'W' movemos arriba
		cmp AL,77h;'w'
		JE MOVIMIENTO_PALETA_IZQUIERDA_ARRIBA
		cmp AL,57h;'W'
		JE MOVIMIENTO_PALETA_IZQUIERDA_ARRIBA
		
		;Si es 's' o 'S' movemos abajo
		cmp AL,73h;'s'
		Je MOVIMIENTO_PALETA_IZQUIERDA_ABAJO
		cmp AL,53h;'S'
		Je MOVIMIENTO_PALETA_IZQUIERDA_ABAJO
		jmp REVISA_MOVIMIENTO_PALETA_DERECHA 

		MOVIMIENTO_PALETA_IZQUIERDA_ARRIBA:
			mov AX,VELOCIDAD_PALETA;
			sub PALETA_IZQUIERDA_Y,AX;

			mov AX,VENTANA_B_1;
			cmp PALETA_IZQUIERDA_Y,AX;
			jl F_TOPE_PALETA_IZQUIERDA;
			jmp REVISA_MOVIMIENTO_PALETA_DERECHA

			F_TOPE_PALETA_IZQUIERDA:
				mov AX,VENTANA_B_1				; 
				mov PALETA_IZQUIERDA_Y,AX 	;
				jmp REVISA_MOVIMIENTO_PALETA_DERECHA; 
	 
		MOVIMIENTO_PALETA_IZQUIERDA_ABAJO:
			mov AX,VELOCIDAD_PALETA;
			add PALETA_IZQUIERDA_Y,AX;
			mov AX, VENTA_ALTURA;
			sub AX,VENTANA_B;
			sub AX,PALETA_ALTO;
			cmp PALETA_IZQUIERDA_Y,AX;
			jg F_PALETA_IZQUIERDA_B_POSICION

			jmp REVISA_MOVIMIENTO_PALETA_DERECHA

			F_PALETA_IZQUIERDA_B_POSICION:
				mov PALETA_IZQUIERDA_Y,AX;
				jmp REVISA_MOVIMIENTO_PALETA_DERECHA;

		;Paleta derecha movimiento
		REVISA_MOVIMIENTO_PALETA_DERECHA:
		cmp AI_JUGADOR,01h;
		je CONTROL_POR_CPU

		;La paleta es controlada por un usuario
		REVISAR_TECLAS:
			;Si es 'o' o 'O' movemos arriba
			cmp AL,6Fh;'o'
			JE MOVIMIENTO_PALETA_DERECHA_ARRIBA
			cmp AL,4Fh;'O'
			JE MOVIMIENTO_PALETA_DERECHA_ARRIBA
			
			;Si es 'l' o 'L' movemos abajo
			cmp AL,6Ch;'l'
			Je MOVIMIENTO_PALETA_DERECHA_ABAJO
			cmp AL,4Ch;'L'
			Je MOVIMIENTO_PALETA_DERECHA_ABAJO
			jmp SALIDA_MOVIMIENTO_PALETA ;Correcto

		;La paleta es controlada por la CPU
		CONTROL_POR_CPU:
			;Revisar si la pelota esta arriba de la paleta (Pelota_Y + Pelota_Size < Paleta_Derecha_y)
			;Si lo es, entonces movemos arriba
			mov AX,PELOTA_Y 				;
			add AX,PELOTA_SIZE 			;
			cmp AX,PALETA_DERECHA_Y
			jl  MOVIMIENTO_PALETA_DERECHA_ARRIBA ;

			;REvisamos si la pelota esta debajo de la pelota (Pelota_Y > Paleta_Derecha_Y +Paleta_altura)
			;Si lo es movemos abajo
			mov AX,PALETA_DERECHA_Y
			add AX,PALETA_ALTO
			cmp AX, PELOTA_Y
			jl MOVIMIENTO_PALETA_DERECHA_ABAJO

			;Si no, no mover paleta
			jmp SALIDA_MOVIMIENTO_PALETA
		
		MOVIMIENTO_PALETA_DERECHA_ARRIBA:
			mov AX,VELOCIDAD_PALETA;
			sub PALETA_DERECHA_Y,AX;

			mov AX,VENTANA_B_1;
			cmp PALETA_DERECHA_Y,AX;
			jl F_TOPE_PALETA_DERECHA;
			jmp SALIDA_MOVIMIENTO_PALETA;

			F_TOPE_PALETA_DERECHA:
				mov AX,VENTANA_B_1				; 
				mov PALETA_DERECHA_Y,AX 	;
				jmp SALIDA_MOVIMIENTO_PALETA; 
	 
		MOVIMIENTO_PALETA_DERECHA_ABAJO:
			mov AX,VELOCIDAD_PALETA;
			add PALETA_DERECHA_Y,AX;
			mov AX, VENTA_ALTURA;
			sub AX,VENTANA_B;
			sub AX,PALETA_ALTO;
			cmp PALETA_DERECHA_Y,AX;
			jg F_PALETA_DERECHA_B_POSICION

			jmp REVISA_MOVIMIENTO_PALETA_DERECHA

			F_PALETA_DERECHA_B_POSICION:
				mov PALETA_DERECHA_Y,AX;
				jmp SALIDA_MOVIMIENTO_PALETA;

		SALIDA_MOVIMIENTO_PALETA:
		
		
		RET
	
	ENDP

;Restablecer el punto original de la pelota cuando toca la pared derecha o izquierda
;----------------------------------------------------------------------------
	 POSICION_RESET_PELOTA PROC NEAR
	 	mov AX,P_ORIGEN_X;
	 	mov PELOTA_X,AX  ;

	 	mov AX, P_ORIGEN_Y;
	 	mov PELOTA_Y,AX;

	 	RET 
	 ENDP

	
    ;Dibujar pelota
    ;----------------------------------------------------------
     DIBUJAR_PELOTA PROC NEAR 

    	 mov CX,PELOTA_X   				; Configuracion de a columna (x)
	    mov DX,PELOTA_Y 					; Configuracion vertical (Y) 

	     PELOTA_HORIZONTAL:
		    mov AH,0Ch      				; Configuracion para dibujar un pixel
		    mov AL,0Fh      				; Color del pixel blanco
		    mov BH,00h      				; numero de pagina
		    int 10h         				;Ejecuta la configuracion 

		    inc CX          				;CX = CX+1
		    mov AX,CX		 				;CX-Pelota_x > Pelota_SIZE (SI-> Saltamos a la siguiente linea, No continuamos en la siguiente columna)
		    sub AX,PELOTA_X 				; 
		    cmp AX,PELOTA_SIZE			;
		    jng PELOTA_HORIZONTAL		;

		    mov CX,PELOTA_X 				; 
		    inc DX            			; Avanzamos 

		    mov AX,DX         			;DX-Pelota_Y >¨Pelota_SIZE (SI-> Salimos del proceso, No-> continuamos)
		    Sub AX,PELOTA_Y   
		    cmp AX,PELOTA_SIZE
		    jng PELOTA_HORIZONTAL
		
    	RET

    ENDP

    ;--------------------------------------------------------
	 ;DIBUJAR PALETAS
	 ;---------------------------------------------------------
	 DIBUJAR_PALETAS PROC NEAR
	 	mov CX, PALETA_IZQUIERDA_X  	; Configuracion de a columna (x)
	 	mov DX, PALETA_IZQUIERDA_Y  	; Configuracion vertical (y)

	 	 DIBUJAR_PALETA_IZQUIERDA_HORIZONTAL:
	 		mov AH,0Ch      				; Configuracion para dibujar un pixel
		    mov AL,0Fh      				; Color del pixel blanco
		    mov BH,00h      				; numero de pagina
		    int 10h         				; 

		    inc CX           			;CX = CX+1
		    mov AX,CX		      		;CX-PALETA_IZQUIERDA_X > PALETA_ANCHO (SI-> Saltamos a la siguiente linea, No continuamos en la siguiente columna)
		    sub AX,PALETA_IZQUIERDA_X;
		    cmp AX,PALETA_ANCHO;
		    jng DIBUJAR_PALETA_IZQUIERDA_HORIZONTAL;

		    mov CX,PALETA_IZQUIERDA_X; 
		    inc DX            				; Avanzamos 

		    mov AX,DX          				;DX-PALETA_IZQUIERDA_Y >PALETA_ALTO (SI-> Salimos del proceso, No-> continuamos)
		    Sub AX,PALETA_IZQUIERDA_Y 	;
		    cmp AX,PALETA_ALTO;
		    jng DIBUJAR_PALETA_IZQUIERDA_HORIZONTAL;
		 ;RET
		 ;ENDP
		 mov CX, PALETA_DERECHA_X  		; Configuracion de a columna (x)
	 	 mov DX, PALETA_DERECHA_Y  		; Configuracion vertical (y)

		  DIBUJAR_PALETA_DERECHA_HORIZONTAL:
	 		 mov AH,0Ch      					; Configuracion para dibujar un pixel
		    mov AL,0Fh      					; Color del pixel blanco
		    mov BH,00h      					; numero de pagina
		    int 10h         					; 

		    inc CX          					;CX = CX+1
		    mov AX,CX		  					;CX-PALETA_DERECHA_X > PALETA_ANCHO (SI-> Saltamos a la siguiente linea, No continuamos en la siguiente columna)
		    sub AX,PALETA_DERECHA_X 		;
		    cmp AX,PALETA_ANCHO 			;
		    jng DIBUJAR_PALETA_DERECHA_HORIZONTAL;

		    mov CX,PALETA_DERECHA_X; 
		    inc DX           			 	; Avanzamos   

		    mov AX,DX         				;DX-PALETA_DERECHA_Y >PALETA_ALTO (SI-> Salimos del proceso, No-> continuamos)
		    Sub AX,PALETA_DERECHA_Y   	;
		    cmp AX,PALETA_ALTO;
		    jng DIBUJAR_PALETA_DERECHA_HORIZONTAL;
		 RET
		 ENDP
		 ;-------------------------------------------------------------------------
	 ;---------------------------------------------------------
	 DIBUJAR_INTERFAZ_U PROC NEAR 
	 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	 




	 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	 ;Dibujar los puntos del jugador 1 (izquierda)
	 	mov AH, 02h								;Posicion del cursor 
	 	mov BH, 00h 							;Numero de pa
	 	mov dh, 02h;02h04h 							;Numero de renglon
	 	mov dl, 04h;06h  							;Numero de columna
	 	int 10h 									;

	 	mov AH,09h								;
	 	lea DX,TEXTO_PUNTOS_JUGADOR_UNO ;Da a DX un puntero a la cadena de TEXTO_PUNTOS_JUGADOR_UNO
	 	int 21h 									;Imprime la cadena
	 	
	 ;Diujar los puntos del jugador dos (dercha)
	 	mov AH, 02h								;Posicion del cursor 
	 	mov BH, 00h 							;Numero de pa
	 	mov dh, 02h;04h 							;Numero de renglon
	 	mov dl, 49h;46h  							;Numero de columna
	 	int 10h 									;

	 	mov AH,09h								;
	 	lea DX,TEXTO_PUNTOS_JUGADOR_DOS  ;Da a DX un puntero a la cadena de TEXTO_PUNTOS_JUGADOR_UNO
	 	int 21h 									;Imprime la cadena
	 										;Imprime la cadena
	 	
	 	mov AH, 02h								;Posicion del cursor 
	 	mov BH, 00h 							;Numero de pa
	 	mov dh, 03h;02h04h 							;Numero de renglon
	 	mov dl, 24h;06h  							;Numero de columna
	 	int 10h 									;

	 	mov AH,09h								;
	 	lea DX,tiempo_cadena ;Da a DX un puntero a la cadena de TEXTO_PUNTOS_JUGADOR_UNO
	 	int 21h 	


	 	posiciona_cursor 0,34
		imprime_caracter_color 'P',cAmarillo,bgNegro
		posiciona_cursor 0,36
		imprime_caracter_color 'O',cAmarillo,bgNegro
		posiciona_cursor 0,38
		imprime_caracter_color 'N',cAmarillo,bgNegro
		posiciona_cursor 0,40
		imprime_caracter_color 'J',cAmarillo,bgNegro

	 ;Dibujar texto player 1
	 	mov AH, 02h								;Posicion del cursor 
	 	mov BH, 00h 							;Numero de pa
	 	mov dh, 02h;04h 							;Numero de renglon
	 	mov dl, 10h;46h  							;Numero de columna
	 	int 10h 									;

	 	mov AH,09h								;
	 	lea DX,player1  ;Da a DX un puntero a la cadena de TEXTO_X_SALIDA
	 	int 21h 									;Imprime la cadena

	 ;Dibujar texto player 2

	 	mov AH, 02h								;Posicion del cursor 
	 	mov BH, 00h 							;Numero de pa
	 	mov dh, 02h;04h 							;Numero de renglon
	 	mov dl, 38h;46h  							;Numero de columna
	 	int 10h 									;

	 	mov AH,09h								;
	 	lea DX,player2  ;Da a DX un puntero a la cadena de TEXTO_X_SALIDA
	 	int 21h 									;Imprime la cadena

;Dibuja la x

posiciona_cursor 0,76
		imprime_caracter_color '[',cAmarillo,bgNegro
		posiciona_cursor 0,77
		imprime_caracter_color 'X',cRojoClaro,bgNegro
		posiciona_cursor 0,78
		imprime_caracter_color ']',cAmarillo,bgNegro
;inicializa la cadena del timer
	mov [tiempo_cadena],"2"
	mov [tiempo_cadena+1],":"
	mov [tiempo_cadena+2],"0"
	mov [tiempo_cadena+3],"0"
		
	mov [tiempo_s],120 			;inicializa el número de segundos del timer
	posiciona_cursor 2,38
	imprime_cadena_color tiempo_cadena,4,cBlanco,bgNegro
	;
	;	call OBTENER_TIEMPO
	 	call DIBUJA_UI
	;	call MOUSE_1

	 	RET
	 ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	OBTENER_TIEMPO PROC NEAR 
		while_tiempo:
		;Obteniendo tiempo del sistema
		mov ah,2ch
		int 21h
		;Revisando si ya pasó 1 segundo
		cmp dh,segundos
		jb sin_Cambios
		mov segundos, dh
		mov ah,9
		mov dx, offset text
		int 21h
		sin_Cambios:
		jmp while_tiempo
endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	 ACT_T_PUNTOS_JUGADOR_UNO PROC NEAR
	 	xor AX,AX
	 	mov AL, PUNTOS_JUGADOR_UNO  		;J1 ->2 PUNTOS -> AL,2

	 	;Antes de imprimir en pantalla, necesitamos convertir de ASCCI a Decimal
	 	;Se puede lograr sumando 30h
	 	add AL,30h
	 	mov [TEXTO_PUNTOS_JUGADOR_UNO],AL ;

	 RET 
	 ENDP

	 ACT_T_PUNTOS_JUGADOR_DOS PROC NEAR
	  	xor AX,AX
	 	mov AL, PUNTOS_JUGADOR_DOS  		;J2 ->2 PUNTOS -> AL,2
	 	;Antes de imprimir en pantalla, necesitamos convertir de ASCCI a Decimal
	 	;Se puede lograr sumando 30h
	 	add AL,30h
	 	mov [TEXTO_PUNTOS_JUGADOR_DOS],AL 
	 
	 RET 	
	 ENDP

	 MENU_FIN_D_JUEGO PROC NEAR 				;Mostara el fin de juego
	 call LIMPIAR_PANTALLA						;Limpia Pantalla

	 	;Muestra el texto de fin de juego
	 	mov AH, 02h								;Posicion del cursor 
	 	mov BH, 00h 							;Numero de pa
	 	mov dh, 09h 							;Numero de renglon
	 	mov dl, 20h  							;Numero de columna
	 	int 10h 									;

	 	mov AH,09h								;
	 	lea DX,TEXTO_FIN_JUEGO_T  			;
	 	int 21h 									;Imprime la cadena
	 
	 	;Muestra al ganador
	 	mov AH, 02h								;Posicion del cursor 
	 	mov BH, 00h 							;Numero de pa
	 	mov dh, 0Dh 							;Numero de renglon
	 	mov dl, 1Eh  							;Numero de columna
	 	int 10h 									;

	 	call TEXTO_DEL_GANADOR_ACT 		;Actualiza al ganador de la partida

	 	mov AH,09h								;
	 	lea DX,TEXTO_FIN_JUEGO_GANADOR  	;
	 	int 21h 									;Imprime la cadena

	 	;Muestra jugar nuevo
	 	mov AH, 02h								;Posicion del cursor 
	 	mov BH, 00h 							;Numero de pa
	 	mov dh, 13h 							;Numero de renglon
	 	mov dl, 17h  							;Numero de columna
	 	int 10h 									;

	 	mov AH,09h								;
	 	lea DX,TEXTO_JUGAR_OTRAVEZ  		;
	 	int 21h 		

	 ;Muestra salir a menu
	 	mov AH, 02h								;Posicion del cursor 
	 	mov BH, 00h 							;Numero de pa
	 	mov dh, 11h 							;Numero de renglon
	 	mov dl, 17h  							;Numero de columna
	 	int 10h 									;

	 	mov AH,09h								;
	 	lea DX,TEXTO_MENU_FIN_JUEGO  		; imprime cadena
	 	int 21h 		

	 	;Espera hasta que presionen una tecla
	 	mov AH,00h 								;
	 	int 16h 									;

	 	;Si la tecla presionada es 'r' o 'R', restablece el juego
	 	cmp AL,'R' 								;
	 	je JUGAR_OTRAVEZ  					;
	 	cmp AL,'r' 								;
	 	je JUGAR_OTRAVEZ 						;

	 	;Si la tecla presionada es 'e' o 'E', restablece el juego
	 	cmp AL,'E' 								;
	 	je SALIR_A_MENU	  					;
	 	cmp AL,'e' 								;
	 	je SALIR_A_MENU 						;
	 	RET 

	 	JUGAR_OTRAVEZ: 
	 		mov JUEGO_ACT,01h 				;
	 		RET

	 	SALIR_A_MENU:
	 		mov JUEGO_ACT,00h 				;
	 		mov ESCENA_ACT,00h				;Escena actual
			RET 	 
	 ENDP

	 DIBUJAR_MENU PROC NEAR
	 	call LIMPIAR_PANTALLA				;Limpiar pantalla
	 	;Muestra el texto del menu
	 	mov AH, 02h								;Posicion del cursor 
	 	mov BH, 00h 							;Numero de pa
	 	mov dh, 08h 							;Numero de renglon
	 	mov dl, 20h  							;Numero de columna
	 	int 10h 									;

	 	;Muesta presione una tecla
	 	mov AH,09h								;
	 	lea DX,TEXTO_MENU_P  				;
	 	int 21h 									;Imprime la cadena

	 	mov AH, 02h								;Posicion del cursor 
	 	mov BH, 00h 							;Numero de pa
	 	mov dh, 09h 							;Numero de renglon
	 	mov dl, 1Dh  							;Numero de columna
	 	int 10h 									;

	 	mov AH,09h								;
	 	lea DX,TEXTO_MENU_TECLA  				;
	 	int 21h 									;Imprime la cadena
	  
	  ;Opcion 1 jugador
	 	mov AH, 02h								;Posicion del cursor 
	 	mov BH, 00h 							;Numero de pa
	 	mov dh, 0Fh 							;Numero de renglon
	 	mov dl, 1Dh  							;Numero de columna
	 	int 10h 									;

	 	mov AH,09h								;
	 	lea DX,TEXTO_MENU_UNJUGADOR  		;
	 	int 21h 									;Imprime la cadena
		
		;Opcion 2 jugadores
	 	mov AH, 02h								;Posicion del cursor 
	 	mov BH, 00h 							;Numero de pa
	 	mov dh, 11h 							;Numero de renglon
	 	mov dl, 1Dh  							;Numero de columna
	 	int 10h 									;

	 	mov AH,09h								;
	 	lea DX,TEXTO_MENU_MULTIJUGADOR  	;
	 	int 21h 									;Imprime la cadena

		;Muestra para salir
	 	mov AH, 02h								;Posicion del cursor 
	 	mov BH, 00h 							;Numero de pa
	 	mov dh, 13h 							;Numero de renglon
	 	mov dl, 1Dh  							;Numero de columna
	 	int 10h 									;

	 	mov AH,09h								;
	 	lea DX,TEXTO_MENU_SALIR  			;
	 	int 21h 									;Imprime la cadena

	 	MENU_ESPERA_POR_UNA_TECLA:
	 	;Espera hasta que presionen una tecla
	 		mov AH,00h 								;
	 		int 16h 	

		 	;Revisa si alguna tecla fue presionada
		 	;Comienza un jugador
		 	cmp AL,'1';
		 	je COMIENZA_UNJUGADOR

		 	;Comienza multijugador (dos personas)
		 	cmp AL,'2';
		 	je COMIENZA_MULTIJUGADOR

		 	;Comienza multijugador (dos personas)
		 	cmp AL,'3';
		 	je SALIR_DE_JUEGO
		 	jmp MENU_ESPERA_POR_UNA_TECLA

		 COMIENZA_UNJUGADOR:
		 	mov ESCENA_ACT,01h 				; 
		 	mov JUEGO_ACT,01h 				;
		 	mov AI_JUGADOR,01h;
		 	RET 

		 COMIENZA_MULTIJUGADOR:
		 	mov ESCENA_ACT,01h 				; 
		 	mov JUEGO_ACT,01h 				;
		 	mov AI_JUGADOR,00h
		 	RET 
		 SALIR_DE_JUEGO:
		 	mov SALIENDO_D_JUEGO,01 		;

	 	RET 
	 ENDP

	 ;---------------------------------------------------------
	 TEXTO_DEL_GANADOR_ACT PROC NEAR
	 	mov AL,IND_GANADOR								;Si el indice del ganador es 1 -> AL,1
	 	add AL,30h 											;AL,31h -> AL,'1'
	 	mov [TEXTO_FIN_JUEGO_GANADOR+17],AL 		;Actualiza el caracter en el indice del texto del ganador

	 RET 
	 ENDP
    ;---------------------------------------------------------
    LIMPIAR_PANTALLA PROC NEAR 							;Limpia la pantalla restableciendo el modo de video
 
     ;Control de video 480p
     mov ah,00h 												; Configuracion de la calidad de video
     mov al,12h 												; o 12h; ;Resolucion 
     int 10h 													; Ejecuta la configuracion

     mov AH,0Bh 												; Configuracion de color
     mov BH,00h 												; Color del fondo
     mov BL,00h 												; Color negro 
     int 10h 													; Ejecurar la configuracion del color (opcional)

    RET
    ENDP
    SALIDA_CONCLUIDA PROC NEAR 							;Vuelve al modo de texto
     mov ah,00h 												; Configuracion de la calidad de video
     mov al,12h 												; o 12h; ;Resolucion 
     int 10h 													; Ejecuta la configuracion
     
     ;Termina el programa
     mov ah,4Ch
     int 21h 													;Calidad de la ventana en la que sale (640*480)
    ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,

MOUSE_1:					;etiqueta inicio
	inicializa_ds_es
	comprueba_mouse		;macro para revisar driver de mouse
	xor ax,0FFFFh		;compara el valor de AX con FFFFh, si el resultado es zero, entonces existe el driver de mouse
	jz imprime_ui		;Si existe el driver del mouse, entonces salta a 'imprime_ui'
	;Si no existe el driver del mouse entonces se muestra un mensaje
	lea dx,[no_mouse]
	mov ax,0900h	;opcion 9 para interrupcion 21h
	int 21h			;interrupcion 21h. Imprime cadena.
	jmp teclado		;salta a 'teclado'
imprime_ui:
	;clear 					;limpia pantalla
	oculta_cursor_teclado	;oculta cursor del mouse
	apaga_cursor_parpadeo 	;Deshabilita parpadeo del cursor
	;call DIBUJA_UI 	;procedimiento que dibuja marco de la interfaz
	muestra_cursor_mouse 	;hace visible el cursor del mouse
;Revisar que el boton izquierdo del mouse no esté presionado
;Si el botón no está suelto, no continúa
mouse_no_clic:
	lee_mouse
	test bx,0001h
	jnz mouse_no_clic
;Lee el mouse y avanza hasta que se haga clic en el boton izquierdo
mouse:
	lee_mouse
	test bx,0001h 		;Para revisar si el boton izquierdo del mouse fue presionado
	jz mouse 			;Si el boton izquierdo no fue presionado, vuelve a leer el estado del mouse

	;Leer la posicion del mouse y hacer la conversion a resolucion
	;80x25 (columnas x renglones) en modo texto
	mov ax,dx 			;Copia DX en AX. DX es un valor entre 0 y 199 (renglon)
	div [ocho] 			;Division de 8 bits
						;divide el valor del renglon en resolucion 640x200 en donde se encuentra el mouse
						;para obtener el valor correspondiente en resolucion 80x25
	xor ah,ah 			;Descartar el residuo de la division anterior
	mov dx,ax 			;Copia AX en DX. AX es un valor entre 0 y 24 (renglon)

	mov ax,cx 			;Copia CX en AX. CX es un valor entre 0 y 639 (columna)
	div [ocho] 			;Division de 8 bits
						;divide el valor de la columna en resolucion 640x200 en donde se encuentra el mouse
						;para obtener el valor correspondiente en resolucion 80x25
	xor ah,ah 			;Descartar el residuo de la division anterior
	mov cx,ax 			;Copia AX en CX. AX es un valor entre 0 y 79 (columna)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Aqui va la lógica de la posicion del mouse;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Si el mouse fue presionado en el renglon 0
	;se va a revisar si fue dentro del boton [X]
	cmp dx,0
	je boton_x

	jmp mouse_no_clic
boton_x:
	jmp boton_x1

;Lógica para revisar si el mouse fue presionado en [X]
;[X] se encuentra en renglon 0 y entre columnas 76 y 78
boton_x1:
	cmp cx,76
	jge boton_x2
	jmp mouse_no_clic
boton_x2:
	cmp cx,78
	jbe boton_x3
	jmp mouse_no_clic
boton_x3:
	;Se cumplieron todas las condiciones
	call LIMPIAR_PANTALLA
	jmp salir

;Si no se encontró el driver del mouse, muestra un mensaje y el usuario debe salir tecleando [enter]
teclado:
	mov ah,08h
	int 21h
	cmp al,0Dh		;compara la entrada de teclado si fue [enter]
	jnz teclado 	;Sale del ciclo hasta que presiona la tecla [enter]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 salir:
    mov ah,4Ch
    mov al,0
    int 21h




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;PROCEDIMIENTOS;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	DIBUJA_UI proc NEAR
		;imprimir esquina superior izquierda del marco
		posiciona_cursor 0,0
		imprime_caracter_color marcoEsqSupIzq,cAmarillo,bgNegro
		
		;imprimir esquina superior derecha del marco
		posiciona_cursor 0,79
		imprime_caracter_color marcoEsqSupDer,cAmarillo,bgNegro
		
		;imprimir esquina inferior izquierda del marco
		posiciona_cursor 29,0
		imprime_caracter_color marcoEsqInfIzq,cAmarillo,bgNegro
		
		;imprimir esquina inferior derecha del marco
		posiciona_cursor 29,79
		imprime_caracter_color marcoEsqInfDer,cAmarillo,bgNegro
		
		;imprimir marcos horizontales, superior e inferior
		mov cx,78 		;CX = 004Eh => CH = 00h, CL = 4Eh 
	marcos_horizontales:
		mov [col_aux],cl
		posiciona_cursor 4,[col_aux]
		imprime_caracter_color marcoHor,cAmarillo,bgNegro
		mov cl,[col_aux]
		loop marcos_horizontales
	
		ret
	endp


	IMPRIME_DATOS_INICIALES proc

		ret
	endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	endp	 			;Indica fin de procedimiento UI para el ensamblador
	
IMPRIME_NUM16 proc
	mov ax,bx   
	mov bp,sp
et1:
	mov dx,0
	div [diez] 	

	push dx
	cmp ax,0d
	jne et1
et2:
	pop dx
	or dl,30h 
	mov ah,02h
	int 21h
	cmp sp,bp
	jne et2

	mov dl,0Ah
	mov ah,02h
	int 21h
	ret
endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;FIN PROCEDIMIENTOS;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
end inicio