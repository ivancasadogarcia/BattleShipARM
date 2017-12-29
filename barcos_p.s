@;=========== Fichero fuente principal de la práctica de los barcos  ===========
@;== 	define las variables globales principales del juego (matriz_barcos,	  ==
@;== 	matriz_disparos, ...), la rutina principal() y sus rutinas auxiliares ==
@;== 	programador1: ivan.casado@estudiants.urv.cat							  ==
@;== 	programador2: oriol.balague@estudiants.urv.cat							  ==


@;-- símbolos habituales ---
NUM_PARTIDAS = 150


@;--- .bss. non-initialized data ---

.bss
	nd8: .space 2					@; promedio de disparos para tableros de 8x8
	nd9: .space 2					@; de 9x9
	nd10: .space 2					@; de 10x10
	matriz_barcos:	 .space 100		@; códigos de los barcos a hundir
	matriz_disparos: .space 100		@; códigos de los disparos realizados
	
	.align 2
	quoq: .space 4
	restot: .space 4

@;-- .text. código de las rutinas ---
.text	
		.align 2
		.arm


@; principal():
@;	rutina principal del programa de los barcos; realiza n partidas para cada
@;	uno de los 3 tamaños de tablero establecidos (8x8, 9x9 y 10x10), calculando
@;	el promedio del número de disparos necesario para hundir toda la flota,
@;	que se inicializará en posiciones aleatorias en cada partida; los valores
@;	promedio se deben escribir en las variables globales 'nd8', 'nd9' y 'nd10',
@;	respectivamente 
		.global principal
	principal:
		push {lr}
		ldr r1, =matriz_barcos		@; r1 = matriz_barcos
		ldr r2, =matriz_disparos	@; r2 = matriz_disparos
		
		ldr r3, =nd8				@; r3 es dirección de 'nd8'
		mov r0, #8					@; r0 = dim
		bl realizar_partidas		@; llamada a la función
		
		ldr r3, =nd9				@; r3 es dirección de 'nd9'
		mov r0, #9					@; r0 = dim
		bl realizar_partidas		@; llamada a la función
		
		ldr r3, =nd10				@; r3 es dirección de 'nd10'
		mov r0, #10					@; r0 = dim
		bl realizar_partidas		@; llamada a la función
		
		pop {pc}



@; realizar_partidas(int dim, char tablero_barcos[], 
@;								char tablero_disparos[], char *var_promedio):
@;	rutina para realizar un cierto número de partidas (NUM_PARTIDAS) de la
@;	batalla de barcos, sobre un tablero de barcos y un tablero de disparos
@;	pasados por parámetro, junto con la dimensión de dichos tableros, de
@;	modo que se calcula el promedio de disparos de cada partida necesarios para
@;	hundir todos los barcos; dicho promedio se almacena en la posición de
@;	memoria referenciada por el parámetro 'var_promedio'.
@;	Parámetros:
@;		R0: dim; tamaño de los tableros (dimxdim)
@; 		R1: tablero_barcos[]; dirección base del tablero de barcos
@; 		R2: tablero_disparos[]; dirección base del tablero de disparos
@;		R3: var_promedio (dir); dirección de la variable que albergará el pro-
@;								medio de disparos.
realizar_partidas:
		push {r1, r2, lr}
		
		mov r5, r0					@; r5 = dim, hacer una copia de la dimensión.
		mov r10, #0					@; inicializar 'sumador' con el valor 0.
		mov r9, #0					@; inicializar 'contador_partidas' con el valor 0.
		
		
	.Lhundir:	
		mov r0, r5					@; restablecer la dimensión en r0.
		bl B_inicializa_barcos		@; llamada a la función generadora de barcos.
		mov r0, r5					@; restablecer la dimensión en r0.
		
		bl crear_inter				@; llamada a la función "crear_inter"
		
		bl jugar					@; llamada a la función "jugar"
		
		add r10, r0					@; acumula el valor de r0 en r10.
		add r9, #1					@; contador_partidas++
		cmp r9, #NUM_PARTIDAS		@; comprueba si: 'contador_partidas' < NUM_PARTIDAS
		blo .Lhundir				@; si cumple la condición, va a .Lhundir
		
		
		mov r0, r10					@; r0 = 'sumador'
		mov r1, #NUM_PARTIDAS		@; r1 = NUM_PARTIDAS
		mov r5, r3					@; r5 copia la dirección.
		
		ldr r2, =quoq				@; r2 adquiere la dirección de memoria de =quoq
		ldr r3, =restot				@; r3 adquiere la dirección de memoria de =restot
		
		bl div_mod					@; llamada a la función "div_mod"
		
		ldrb r9, [r2]				@; captura el valor de la dirección r2 a r9.
		mov r3, r5					@; copia la dirección de r5 a r3.
		strb r9, [r3]				@; introduce el valor de r9 a la dirección r3.
		
		pop {r1, r2, pc}

crear_inter:
		push {lr}
		
		mov r6, #0					@; inicializar 'n' con el valor 0.
		mul r7, r0, r0				@; r7 = dim x dim, para saber el número máximo donde 'n' tiene que llegar.
		mov r8, #63					@; r8 = ?, para llenar cada posición de la tabla con '?'.	
	.Lbucle:	
		strb r8, [r2, r6]			@; pone el valor de r8 (?) dentro de la tabla que hay en r2 en la posición que da r6 ('n').
		add r6, #1					@; n++
		cmp r6, r7					@; comprueba si: 'n' < (dim x dim)
		blo .Lbucle					@; si cumple la condición, va a .Lbucle
		
		pop {pc}

.end
