@;=============== Fichero fuente de la pr�ctica de los barcos  =================
@;== 	define las rutinas jugar() y sus rutinas auxiliares					  ==
@;== 	programador1: ivan.casado@estudiants.urv.cat							  ==
@;== 	programador2: oriol.balague@estudiants.urv.cat							  ==

MAX = 6      			@; un valor que utilizaremos en algunos casos como m�ximo

.bss
	.align 2
	quo: .space 4		@; =quo, quoficiente de una divisi�n
	resto: .space 4		@; =resto, resto de una divisi�n



@;-- .text. c�digo de las rutinas ---
.text	
		.align 2
		.arm


@; jugar(int dim, char tablero_disparos[]):
@;	rutina para realizar los lanzamientos contra el tablero de barcos iniciali-
@;	zado con la �ltima llamada a B_incializa_barcos(), anotando los resultados
@;	en el tablero de disparos que se pasa por par�metro (por referencia), donde
@;	los dos tableros tienen el mismo tama�o (dim = dimensi�n del tablero de
@;	barcos). La rutina realizar� los disparos necesarios hasta hundir todos los
@;	barcos, devolviendo el n�mero total de disparos realizado.
@;	Par�metros:
@;		R0: dim; tama�o de los tableros
@; 		R1: char tablero_disparos[]; direcci�n base del tablero de disparos
@;	Resultado:
@;		R0: n�mero total de disparos realizados para completar la partida
		.global jugar
jugar:
		push {r1, r2, r3, r4, r5, r9, r10, lr}
		
		mov r12, r1					@; r12 = tablero_barcos[], lo usaremos para conservar la direcci�n y luego consultarlo en la memoria.
		mov r1, r2					@; r1 = tablero_disparos[], copiamos la direcci�n de r2 a r1.
		mov r0, r5					@; r5 = dim, realizamos una copia de 'dim' en r5.
		
		mov r10, #0					@; inicializar 'barcos_hundidos' a 0.
		
		mov r2, #1					@; inicializar n�mero de fila a 1.
		mov r3, #1					@; inicializar n�mero de columna a 1.
		mov r11, #-1				@; inicializar la copia de la posici�n de tabla anterior con el valor -1.
		
	.Lpartida:	
		bl efectuar_disparo			@; llamada a la funci�n "efectuar_disparo"
		
		cmp r0, #1					@; comprobar que r0 es igual a 1.
		beq .L1						@; si es r0 es igual a 1, ir a .L1
		cmp r0, #2					@; comprobar que r0 es igual a 2.
		beq .L2						@; si es r0 es igual 2, ir a .L2
		cmp r0, #3					@; comprobar que r0 es igual 3.
		beq .L3						@; si es r0 es igual 3, ir a .L3
		b .Lsortida					@; si r0 no cumple ninguna de las condiciones anteriores, ira a .Lsortida
		
	.L1:							@; Procedimiento de lanzamiento en AGUA
		mov r6, #46					@; r6 = '.'
		strb r6, [r1, r9]			@; r1[r9] = '.'
		
		b .Lsortida					@; ir a .Lsortida
		
	.L2:							@; Procedimiento de lanzamiento en TOCADO
		mov r6, #88					@; r6 = 'X'
		strb r6, [r1, r9]			@; r1[r9] = 'X'
		mov r11, r9
		
		b .Lsortida					@; ir a .Lsortida
		
	.L3:							@; Procedimiento de lanzamiento en HUNDIDO
		mov r6, #88					@; r6 = 'X'
		strb r6, [r1, r9]			@; r1[r9] = 'X'		
		
		cmp r5, #10 				@;
		beq .L33					@;
		bl aguas_alrededor 			@; llamada a la funci�n "aguas_alrededor"
		.L33:
		mov r11, #-1				@; r11 = -1, se reinicia su valor a -1.
		mov r9, r11					@; borrar el valor de r9.
		add r10, #1					@; r10++
		b .Lsortida					@; ir a .Lsortida
		
	.Lsortida:
		mov r0, r5					@; r0 = dim, devuelve el valor de dimensi�n guardado en r5 a r0.
		cmp r10, #10				@; determinar si 'barcos_hundidos' < 10
		blo .Lpartida				@; si se cumple la condici�n, va a .Lhundir
		
		bl B_num_disparos			@; llamada a la funci�n contadora de disparos
		pop {r1, r2, r3, r4, r5, r9, r10, pc}


aguas_alrededor:
		push {r3, r4, r5, r6, r7, r8, r9, r10, r11, lr}
		mov r7, #46					@; se le assigna el caracter '.' (agua) a r7.
		mov r8, #0					@; inicializa r8 a 0, se utilizar� para limitar el bucle de poner aguas al rededor.
		
		bl caso_lateral				@; llamada a la funci�n "caso lateral"
		cmp r11, #1					@; comprueba que r11, el indicador de la funci�n "caso lateral" sea igual a 1.
		beq .Lsup					@; si r11 == 1, salta a .Lsup
		cmp r11, #2					@; comprueba que r11, el indicador de la funci�n "caso lateral" sea igual a 2.
		beq .L22					@; si r11 == 2, salta a .L22
		
	.LsupI:	
		cmp r11, #1					@; comprueba que no se del tipo "caso 1".
		beq .Lsup					@; si r11 == 1, salta a .Lfinal
		sub r9, #1					@; r9 = r9 - 1.
		sub r9, r5					@; r9 = r9 - dim.
		strb r7, [r1, r9]			@; inserta el valor de r7 en la direcci�n r1+r9.
		add r9, #1					@; a�ade a 'pos' + 1.
		add r9, r5					@; a�ade a 'pos' + dim.
		
	.Lsup:
		sub r9, r5					@; pos = pos - dim.
		ldrb r6, [r1, r9]			@; r6 pasa a ser el valor que habia en la direcci�n de memoria r1+pos.
		cmp r6, #88					@; comprueba que r6 sea igual a 'X'.
		beq .LsupI					@; si r6 == 'X', salta a .LsupI
		strb r7, [r1, r9]			@; inserta el valor de r7 en la direcci�n r1+pos.
		add r8, #1					@; mov_max++
		cmp r8, #MAX				@; comprobamos que mov_max si es superior o igual al valor de MAX
		bhi .Lfinal					@; si mov_max >= MAX, salta a .Lfinal
		cmp r11, #2					@; comprobamos que r11 no sea 2, ya que si fuera r11 == 2, seria un caso lateral [Mirar la funci�n caso_lateral]
		beq .Lfinal					@; si r11 == 2, salta a .Lfinal
		
	.LsupD:	
		add r9, #1					@; pos++
		strb r7, [r1, r9]			@; inserta el valor de r7 en la direcci�n r1+pos.
		add r9, r5					@; pos = pos + dim
		b .Lder						@; salta a .Lder
		
	.Lder1:	
		bl caso_lateral				@; llamada a la funci�n "caso_lateral"
		cmp r11, #2					@; comprobar que r11 recibido de la funci�n "caso_lateral" si es igual a 2
		beq .L22					@; si r11 == 2, salta a .L22 ya que tenemos un caso lateral de tipo 2, es decir, 'pos' esta pegado a la derecha del tablero
		sub r9, r5					@; pos = pos - dim.
		b .LsupD					@; salta a .LsupD
	.Lder:
		ldrb r6, [r1, r9]			@; r6 pasa a ser el valor que habia en la direcci�n de memoria r1+pos.
		cmp r6, #88					@; comprueba si r6 es igual a 'X'
		beq .Lder1					@; si r6 == 'X', salta a .Lder1
		strb r7, [r1, r9]			@; inserta el valor de r7 en la direcci�n r1+pos.
		add r8, #1					@; mov_max++
		cmp r8, #MAX				@; comprobamos que mov_max si es superior o igual al valor de MAX
		bhi .Lfinal					@; si mov_max >= MAX, salta a .Lfinal
		
	.LinfD:	
		add r9, r5					@; pos = pos + dim
		strb r7, [r1, r9]			@; inserta el valor de r7 en la direcci�n r1+pos.
		sub r9, #1					@; pos--
		b .Linf						@; salta a .Linf
		
	.Linf1:	
		add r9, #1					@; pos++
		b .LinfD					@; salta a .LinfD
	.Linf:
		ldrb r6, [r1, r9]			@; r6 pasa a ser el valor que habia en la direcci�n de memoria r1+pos.
		cmp r6, #88					@; comprueba si r6 es igual a 'X'
		beq .Linf1					@; si r6 == 'X', salta a .Linf1
		strb r7, [r1, r9]			@; inserta el valor de r7 en la direcci�n r1+pos.
		add r8, #1					@; mov_max++
		cmp r8, #MAX				@; comprobamos que mov_max si es superior o igual al valor de MAX
		bhi .Lfinal					@; si mov_max >= MAX, salta a .Lfinal
		cmp r11, #1					@; comprobamos que r11 no sea 1, ya que si fuera r11 = 1, seria un caso lateral [Mirar la funci�n caso_lateral]
		beq .Lfinal					@; si r11 == 1, salta a .Lfinal
		
	.LinfI:	
		sub r9, r5					@; pos = pos - dim
		ldrb r6, [r1, r9]			@; r6 pasa a ser el valor que habia en la direcci�n de memoria r1+pos.
		cmp r6, #88					@; comprueba si r6 es igual a 'X'
		bne .LinfI1					@; si r6 == 'X', salta a .LinfI1
		
		bl caso_lateral				@; llamada a la funci�n "caso_lateral"
		cmp r11, #1					@; comprobamos que r11 no sea 1, ya que si fuera r11 = 1, seria un caso lateral [Mirar la funci�n caso_lateral]
		beq .L22					@; si r11 == 1, salta a .L22
		add r9, r5					@; pos = pos + dim
		
	.LinfI1:	
		sub r9, #1					@; pos--
		strb r7, [r1, r9]			@; inserta el valor de r7 en la direcci�n r1+pos.
		sub r9, r5					@; pos = pos - dim
		b .Lizq						@; salta a .Lizq
		
	.Lizq1:	
		add r9, r5					@; pos = pos + dim
		b .LinfI					@; salta a .LinfI
	.Lizq:
		ldrb r6, [r1, r9]			@; r6 pasa a ser el valor que habia en la direcci�n de memoria r1+pos.
		cmp r6, #88					@; comprueba si r6 es igual a 'X'
		beq .Lizq1					@; si r6 == 'X', salta a .Lizq1
		strb r7, [r1, r9]			@; inserta el valor de r7 en la direcci�n r1+pos.
		add r8, #1					@; mov_max++
		cmp r8, #MAX				@; comprobamos que mov_max si es superior o igual al valor de MAX
		bhi .Lfinal					@; si mov_max >= MAX, salta a .Lfinal
		add r9, #1					@; pos++
		b .LsupI					@; salta a .LsupI
		
	.L22:	
		add r9, r5					@; pos = pos + dim
		ldrb r6, [r1, r9]			@; r6 pasa a ser el valor que habia en la direcci�n de memoria r1+pos.
		cmp r6, #88					@; comprueba que r6 no sea igual a 'X'
		bne .Linf					@; si r6 != 'X', salta a .Linf
		b .L22						@; vuelve al principio del bucle en .L22
		
	.Lfinal:						
		
		
		pop {r3, r4, r5, r6, r7, r8, r9, r10, r11, pc}


@; La utilidad de esta funci�n es comprobar si la posici�n en la que se encuentra r9,
@; no es una posici�n que se encuentra en los laterales del tablero, para asi evitar poner aguas
@; alrededor del barco, traspasando filas y columnas, en posiciones donde puede haber un barco
@; sin encontrar. Al ser un tabla y no una matriz, nos encontramos que las filas no tienen un final,
@; sino que continuan en la siguiente fila, lo cual produce un error en el desarrollo l�gico del juego.
@;
@; Si la posici�n de r9 no est� pegada a ningun lateral, r11 = 0.
@; Si la posici�n de r9 est� pegada lateral izquierdo, r11 = 1.
@; Si la posici�n de r9 est� pegada lateral derecho, r11 = 2.
@; Par�metros:
@;		R5: dim; tama�o de los tableros
@; 		R9: posici�n en la tabla [0, 1, 2 ... dimxdim]
@; Resultado:
@; 		R11: tipo del caso en el que se encuentra la posici�n. [0, 1, 2]
@; 

caso_lateral:
		push {r3, r5, r7, r9, lr}
		
		mov r3, #0					@; inicializa el contador 'n' a 0.
	.Lcomprobar_derecha:			@; APLICA LA FORMULA: �� pos == 'dim' x 'n' ??
	
		mul r7, r5, r3				@; multiplica 'dim'x'n' y guarda el valor en r7.
		cmp r9, r7					@; compara el valor de la posici�n guardada en r9 y r7.
		beq .Lcaso_derecha			@; si son iguales (r9 == r7), salta a .Lcaso_derecha
		add r3, #1					@; en el caso que no fueran iguales, se incrementa r3: r3++
		cmp r3, r5					@; se compara r3 y la 'dim'.
		blo .Lcomprobar_derecha		@; si r3 es menor a r5 (r3 < 'dim'), se continua el bucle en .Lcomprobar_derecha
		
		mov r3, #1					@; inicializa el contador 'n' a 1.
	.Lcomprobar_izquierda:			@; APLICA LA FORMULA: �� pos == ('dim' x 'n') - 1 ??
	
		mul r7, r5, r3				@; multiplica 'dim'x'n' y guarda el valor en r7.
		sub r7, #1					@; se le resta 1 al valor de r7.
		cmp r9, r7					@; compara el valor de la posici�n guardada en r9 y r7.
		beq .Lcaso_izquierda		@; si son iguales (r9 == r7), salta a .Lcaso_izquierda
		add r3, #1					@; en el caso que no fueran iguales, se incrementa r3: r3++
		cmp r3, r5					@; se compara r3 y la 'dim'.
		bls .Lcomprobar_izquierda	@; si r3 es menor a r5 (r3 < 'dim'), se continua el bucle en .Lcomprobar_izquierda
		
		mov r11, #0					@; si no ha dado ningun caso anterior, r11 = 0.
		b .Lfi						@; salta a .Lfi
		
	.Lcaso_derecha:	
		mov r11, #1					@; r11 = 1, en cual es el caso donde la posici�n r9 est� pegada al lateral izquierdo.
		b .Lfi						@; salta a .Lfi
		
	.Lcaso_izquierda:	
		mov r11, #2					@; r11 = 2, en cual es el caso donde la posici�n r9 est� pegada al lateral derecho.
		b .Lfi						@; salta a .Lfi
		
	.Lfi:	
		
		pop {r3, r5, r7, r9, pc}

@; efectuar_disparo(int dim, char tablero_disparos[], int f, int c):
@;	rutina para efectuar un disparo contra el tablero de barcos inicializado
@;	con la �ltima llamada a B_incializa_barcos(), anotando los resultados en
@;	el tablero de disparos que se pasa por par�metro (por referencia), donde los
@;	dos tableros tienen el mismo tama�o (dim = dimensi�n del tablero de barcos).
@;	La rutina realizar� el disparo llamando a la funci�n B_dispara(), y actuali-
@;	zar� el contenido del tablero de disparos consecuentemente, devolviendo
@;	el c�digo de resultado del disparo.
@;	Par�metros:
@;		R0: dim; tama�o de los tableros
@; 		R1: tablero_disparos[]; direcci�n base del tablero de disparos
@;		R2: f; n�mero de fila (0..dim-1)
@;		R3: c; n�mero de columna (0..dim-1)
@;	Resultado:
@;		R0: c�digo del resultado del disparo (-1: ERROR, 0:REPETIT, 1: AGUA,
@;												2: TOCAT, 3: ENFONSAT)
efectuar_disparo:
		push {r4, r5, lr}
		mov r5, r0					@; r5 = dim, realiza una copia de dim en r5.
		
	.Linicio:
		ldrb r6, [r1, r9]			@; r6 captura el valor que hay en la direcci�n de memoria r1 + r9.
		cmp r6, #88					@; compara si el valor captado por r6 es igual a 'X', es decir, un tocado o hundido.
		beq .Ltocado				@; si es igual, va a .Ltocado
		
		ldrb r6, [r1, r11]				@; r6 captura el valor que hay en la direcci�n de memoria r1 + r11.
		cmp r6, #88						@; compara si el valor captado por r6 es igual a 'X', es decir, un tocado o hundido.
		beq .Lagua_con_tocado_anterior	@; si es igual, va a .Lagua_con_tocado_anterior
		
	.Ltiro_aleatorio:	
		mov r0, r5					@; r0 = dim, devuelve el valor de dimensi�n guardado en r5 a r0.
		bl mod_random				@; llamada a la funci�n "mod_random"
		mov r2, r0					@; fila = r0
		add r2, #1					@; fila++
		mov r0, r5					@; r0 = dim, devuelve el valor de dimensi�n guardado en r5 a r0.
		bl mod_random				@; llamada a la funci�n "mod_random"
		mov r3, r0					@; columna = r0
		add r3, #1					@; columna++
		mov r0, r5					@; r0 = dim, devuelve el valor de dimensi�n guardado en r5 a r0.
		
		sub r7, r2, #1				@; r7 = fila - 1
		mov r8, r5					@; r8 = dim
		mla r9, r8, r7, r3			@; r9 = (r8 * r7) + columna
		sub r9, #1					@; r9--
		ldrb r6, [r1, r9]			@; se guarda en r6 el contenido de la direcci�n de memoria r1 + r9
		
		cmp r6, #63					@; comprueba que sea r6 igual a '?'
		beq .Ltiro					@; si es igual se va a efectuar el tiro en .Ltiro
		bne .Ltiro_aleatorio		@; si no es igual, volver� a hacer una posici�n aleatoria, salta a .Ltiro_aleatorio
		
	.Lagua_con_tocado_anterior:	
		mov r9, r11					@; r9 = r11
		
	.Ltocado:	
		sub r9, r5							@; pos = pos + dim
		ldrb r6, [r1, r9]					@; capturamos en r6 el valor de la direcci�n de memoria de r1 + r9
		cmp r6, #63							@; comparamos si r6 es igual a '?'
		beq .Ldeshacer_formula_de_posicion	@; si es igual, salta a .Ldeshacer_formula_de_posici�n
		
		add r9, #1							@; pos++
		add r9, r5							@; pos = pos + dim
		ldrb r6, [r1, r9]					@; capturamos en r6 el valor de la direcci�n de memoria de r1 + r9
		cmp r6, #63							@; comparamos si r6 es igual a '?' 
		beq .Ldeshacer_formula_de_posicion	@; si es igual, salta a .Ldeshacer_formula_de_posici�n
		
		sub r9, #1							@; pos--
		add r9, r5							@; pos = pos + dim
		ldrb r6, [r1, r9]					@; capturamos en r6 el valor de la direcci�n de memoria de r1 + r9
		cmp r6, #63							@; comparamos si r6 es igual a '?'
		beq .Ldeshacer_formula_de_posicion	@; si es igual, salta a .Ldeshacer_formula_de_posici�n
		
		sub r9, #1							@; pos--
		sub r9, r5							@; pos = pos - dim
		ldrb r6, [r1, r9]					@; capturamos en r6 el valor de la direcci�n de memoria de r1 + r9
		cmp r6, #63							@; comparamos si r6 es igual a '?'
		beq .Ldeshacer_formula_de_posicion	@; si es igual, salta a .Ldeshacer_formula_de_posici�n
		
		add r9, #1					@; pos++
		b .Ltiro_aleatorio			@; salta a .Ltiro_aleatorio
		
	.Ldeshacer_formula_de_posicion:	
		mov r7, r1					@; hacemos una copia de la direcci�n r1 a r7
		mov r1, r5					@; copiamos la dim en r1
		mov r0, r9					@; en r0 ponemos el valor de la posici�n
		
		ldr r2, =quo				@; r2 pasa a ser la direcci�n de memoria de quo
		ldr r3, =resto				@; r3 pasa a ser la direcci�n de memoria de resto
		
		bl div_mod					@; llamada a la funci�n "div_mod"
		
		mov r1, r7					@; devolvemos la direcci�n de memoria a r1.
		ldr r7, [r2]				@; capturamos en r7 el valor de la direcci�n de memoria de r2
		ldr r4, [r3]				@; capturamos en r4 el valor de la direcci�n de memoria de r3
		mov r2, r7					@; fila = r7
		mov r3, r4					@; columna = r4
		add r2, #1					@; fila++
		add r3, #1					@; columna++
		
	.Ltiro:	
		add r0, r2, #64				@; r0 = fila + 64, sumamos 64 al valor de fila para saber su letra en la tabla ascii
		mov r7, r1					@; se hace una copia en r7 de la direcci�n de memoria de la tabla_disparos de r1.
		mov r1, r3					@; r1 = columna			
		
		bl B_dispara				@; llamada a la funci�n "B_dispara"
		
		mov r3, r1					@; r3 vuelve a ser el valor de la columna.
		mov r1, r7					@; r1 vuelve a ser la direcci�n de memoria de la tabla_disparos.
		
		pop {r4, r5, pc}
		

.end
