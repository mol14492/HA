/*****************************************
*  @ Autores:
*  Gerardo Molina, 14492
*  Diego Felix, 14105
*	
*  Proyecto de Huerto Hidroponico
*
*  Para compilar:
*   as -o main.o main.s gpio0_2.s getGpio.s -g
*   gcc -o main phys_to_virt.o main.o pixel.o
*
*
* Puertos de GPIO
*  	Puerto      Uso
*
*    	 21       Entrada
*   	 15	  Entrada
*    	 18       Entrada
*	 23	  Entrada
*	 24	  Entrada
*	 25	  Entrada
*	 08	  Entrada
*	 07	  Entrada
*	 22	  Entrada
*	 27	  Entrada
*
*
*
*
*******************************************/

.text
.align 2
.global main

main:

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
inicio:	


	bl getScreenAddr

	ldr r1,=pixelAddr
	str r0,[r1]

	bl GetGpioAddress

@@ PUERTOS DE LECTURA @@
	
	@@ Puerto 4
	mov r0,#4

	mov r1, #0

	bl SetGpioFunction

	
	@@ Puerto 21
	mov r0,#21

	mov r1, #0

	bl SetGpioFunction

	
	@@ Puerto 15

	mov r0,#15

	mov r1, #0

	bl SetGpioFunction

	
	@@ Puerto 18

	mov r0,#18

	mov r1, #0

	bl SetGpioFunction

	@@ Puerto 23
	mov r0,#23

	mov r1, #0

	bl SetGpioFunction

	@@ Puerto 24
	mov r0,#24

	mov r1, #0

	bl SetGpioFunction

	@@ Puerto 25
	mov r0,#25

	mov r1, #0

	bl SetGpioFunction

	@@ Puerto 8
	mov r0,#8

	mov r1, #0

	bl SetGpioFunction

	@@ Puerto 7
	mov r0,#7

	mov r1, #0

	bl SetGpioFunction

	@@ Puerto 22
	mov r0,#2

	mov r1, #0

	bl SetGpioFunction

	@@ Puerto 27
	mov r0,#3

	mov r1, #0

	bl SetGpioFunction


@@ PUERTOS DE ESCRITURA @@
	@@ Puerto 17
	mov r0,#17

	mov r1, #1

	bl SetGpioFunction

	@@ Puerto 26
	mov r0,#26

	mov r1, #1

	bl SetGpioFunction

	@@ Puerto 19
	mov r0,#19

	mov r1, #1

	bl SetGpioFunction

	@@ Puerto 13
	mov r0,#13

	mov r1, #1

	bl SetGpioFunction

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@@ PROGRAMA @@	
terminarPrograma:
	
	@@ Enciende led en señal de encendido @@
	mov r0,#17
	mov r1,#1
	bl SetGpio
	
	ldr r0,=terminar		@@ Comparamos para ver si termina el programa
	ldr r0,[r0]
	cmp r0,#1
	beq fin
	
inicioPrograma:	
	bl delay			@@ Hacemos un delay
	bl delay
	


	bl DibujarVENTANA3

	@@ BOTON SALIR @@
	mov r0, #4			@@ Revisamos los botones (Salir)
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne botSalir
	beq noSalir

botSalir:

	@@ Imprime texto
	ldr r0,=si
	bl puts
	
	ldr r0, =terminar
	mov r1,#1
	str r1,[r0]
	b terminarPrograma

noSalir:

	@@ LEER DATOS @@
	
bit00:

	@@ Si es 01 tenemos humedad     @@
	@@ Si es 10 tenemos temperatura @@
	@@ Si es 11 tenemos luminosidad @@

	@@ bit 00 - gpio 027 @@
	mov r0, #27			@@ Revisamos si es temperatura, humedad o luminosidad.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siBit00
	beq noBit00

siBit00:
	@@ bit 01 - gpio 22 @@
	mov r0, #22			@@ Revisamos si es temperatura, humedad o luminosidad.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne luminosidad
	beq temperatura
	
noBit00:
	@@ bit 00 - gpio 22 @@
	mov r0, #22			@@ Revisamos si es temperatura, humedad o luminosidad.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne humedad
	beq inicioPrograma
	

@@@@@@@@@@@@@@@@@@@@@@ TEMPERATURA @@@@@@@@@@@@@@@@@@@@@@
temperatura:

	@@ IR A temperatura @@
	ldr r0,=temp
	bl puts
	

	ldr r0,=valor_humedad			@@@
	mov r1,#0
	str r1,[r0]

bit01_t:
	@@ bit 01 - gpio 21 @@
	
					@@@

	mov r0, #21			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsUnot
	beq noEsUnot

siEsUnot:
	ldr r0,=valor_temperatura
	mov r1,#1
	str r1,[r0]
	ldr r0,=impsi
	bl puts
	b bit02_t
	
noEsUnot:
	ldr r0,=impno
	bl puts


bit02_t:
	mov r0, #20			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsDost
	beq noEsDost

siEsDost:
	ldr r0,=valor_temperatura
	ldr r1,[r0]
	add r1,#2

	str r1,[r0]
	ldr r0,=impsi2
	bl puts
	b bit03_t
noEsDost:

	ldr r0,=impno2
	bl puts

bit03_t:
	mov r0, #18			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsCuatrot
	beq noEsCuatrot

siEsCuatrot:
	ldr r0,=valor_temperatura
	ldr r1,[r0]
	add r1,#4

	str r1,[r0]
	ldr r0,=impsi4
	bl puts
	b bit04_t
	
noEsCuatrot:
	ldr r0,=impno4
	bl puts

bit04_t:
	mov r0, #23			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsOchot
	beq noEsOchot

siEsOchot:
	ldr r0,=valor_temperatura
	ldr r1,[r0]
	add r1,#8

	str r1,[r0]
	ldr r0,=impsi8
	bl puts
	b bit05_t
noEsOchot:
	ldr r0,=impno8
	bl puts

bit05_t:
	mov r0, #24			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsDseist
	beq noEsDseist
siEsDseist:
	ldr r0,=valor_temperatura
	ldr r1,[r0]
	add r1,#16

	str r1,[r0]
	ldr r0,=impsi16
	bl puts
	b bit06_t
noEsDseist:
	ldr r0,=impno16
	bl puts

bit06_t:
	mov r0, #25			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsTdost
	beq noEsTdost
siEsTdost:
	ldr r0,=valor_temperatura
	ldr r1,[r0]
	add r1,#32

	str r1,[r0]
	ldr r0,=impsi32
	bl puts
	b bit07_t
noEsTdost:
	ldr r0,=impno32
	bl puts
		
bit07_t:
	mov r0, #16			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsScuatrot
	beq noEsScuatrot
siEsScuatrot:
	ldr r0,=valor_temperatura
	ldr r1,[r0]
	add r1,#64

	str r1,[r0]
	ldr r0,=impsi64
	bl puts
	b bit08_t
noEsScuatrot:
	ldr r0,=impno64
	bl puts

bit08_t:
	mov r0, #12			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsCVochot
	beq noEsCVochot
siEsCVochot:
	ldr r0,=valor_temperatura
	ldr r1,[r0]
	add r1,#128

	str r1,[r0]
	ldr r0,=impsi128
	bl puts
	b compTemp
noEsCVochot:
	ldr r0,=impno128
	bl puts
	b compTemp

@@ Comparacion de Temperatura @@
compTemp:
	
	ldr r0,=valor_temperatura
	ldr r0,[r0]
	cmp r0,#25
	blt encenderTemperatura
	bgt noencenderTemperatura
	
encenderTemperatura:	
	@@ Enciende el led @@
	mov r0,#13
	mov r1,#1
	bl SetGpio

	b inicioPrograma


noencenderTemperatura:	
	@@ Apaga el led @@
	mov r0,#13
	mov r1,#0
	bl SetGpio

	b inicioPrograma
	
@@@@@@@@@@@@@@@@@@@@@@ HUMEDAD @@@@@@@@@@@@@@@@@@@@@@

humedad:
	@@ IR A humedad @@
	ldr r0,=hume
	bl puts

	ldr r0,=valor_temperatura		@@@
	mov r1,#0
	str r1,[r0]

bit01_h:
	@@ bit 01 - gpio 21 @@
					@@@

	mov r0, #21			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsUnoh
	beq noEsUnoh

siEsUnoh:
	ldr r0,=valor_humedad
	mov r1,#1
	str r1,[r0]
	ldr r0,=impsi
	bl puts
	b bit02_h
	
noEsUnoh:
	ldr r0,=impno
	bl puts


bit02_h:
	mov r0, #20			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsDosh
	beq noEsDosh

siEsDosh:
	ldr r0,=valor_humedad
	ldr r1,[r0]
	add r1,#2

	str r1,[r0]
	ldr r0,=impsi2
	bl puts
	b bit03_h
noEsDosh:

	ldr r0,=impno2
	bl puts

bit03_h:
	mov r0, #18			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsCuatroh
	beq noEsCuatroh

siEsCuatroh:
	ldr r0,=valor_humedad
	ldr r1,[r0]
	add r1,#4

	str r1,[r0]
	ldr r0,=impsi4
	bl puts
	b bit04_h
	
noEsCuatroh:
	ldr r0,=impno4
	bl puts

bit04_h:
	mov r0, #23			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsOchoh
	beq noEsOchoh

siEsOchoh:
	ldr r0,=valor_humedad
	ldr r1,[r0]
	add r1,#8

	str r1,[r0]
	ldr r0,=impsi8
	bl puts
	b bit05_h
noEsOchoh:
	ldr r0,=impno8
	bl puts

bit05_h:
	mov r0, #24			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsDseish
	beq noEsDseish
siEsDseish:
	ldr r0,=valor_humedad
	ldr r1,[r0]
	add r1,#16

	str r1,[r0]
	ldr r0,=impsi16
	bl puts
	b bit06_h
noEsDseish:
	ldr r0,=impno16
	bl puts

bit06_h:
	mov r0, #25			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsTdosh
	beq noEsTdosh
siEsTdosh:
	ldr r0,=valor_humedad
	ldr r1,[r0]
	add r1,#32

	str r1,[r0]
	ldr r0,=impsi32
	bl puts
	b bit07_h
noEsTdosh:
	ldr r0,=impno32
	bl puts
		
bit07_h:
	mov r0, #16			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsScuatroh
	beq noEsScuatroh
siEsScuatroh:
	ldr r0,=valor_humedad
	ldr r1,[r0]
	add r1,#64

	str r1,[r0]
	ldr r0,=impsi64
	bl puts
	b bit08_h
noEsScuatroh:
	ldr r0,=impno64
	bl puts

bit08_h:
	mov r0, #12			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsCVochoh
	beq noEsCVochoh
siEsCVochoh:
	ldr r0,=valor_humedad
	ldr r1,[r0]
	add r1,#128

	str r1,[r0]
	ldr r0,=impsi128
	bl puts
	b compHum
noEsCVochoh:
	ldr r0,=impno128
	bl puts

@@ Comparacion de Humedad @@
compHum:	
	ldr r0,=valor_humedad
	ldr r0,[r0]
	cmp r0,#30
	blt encenderHumedad
	bgt noencenderHumedad	

encenderHumedad:
	@@ Enciende el led si todo esta bien @@
	mov r0,#19
	mov r1,#1
	bl SetGpio

	bl DibujarBienvePrin	

	b inicioPrograma
noencenderHumedad:
	@@ Apaga el led @@
	mov r0,#19
	mov r1,#0
	bl SetGpio

	bl DibujarVENTANA2

	b inicioPrograma
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@ LUMINOSIDAD @@@@@@@@@@@@@@@@@@@@@@ 
luminosidad:
	@@ IR A luminosidad @@
	ldr r0,=lumi
	bl puts
@@ Contador para luminosidad @@

	ldr r0,=valor_luminosidad		@@@
	mov r1,#0
	str r1,[r0]

bit01_l:
	@@ bit 01 - gpio 21 @@
					@@@

	mov r0, #21			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsUno
	beq noEsUno

siEsUno:
	ldr r0,=valor_luminosidad
	mov r1,#1
	str r1,[r0]
	ldr r0,=impsi
	bl puts
	b bit02_l
	
noEsUno:
	ldr r0,=impno
	bl puts


bit02_l:
	mov r0, #20			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsDos
	beq noEsDos

siEsDos:
	ldr r0,=valor_luminosidad
	ldr r1,[r0]
	add r1,#2

	str r1,[r0]
	ldr r0,=impsi2
	bl puts
	b bit03_l
noEsDos:

	ldr r0,=impno2
	bl puts

bit03_l:
	mov r0, #18			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsCuatro
	beq noEsCuatro

siEsCuatro:
	ldr r0,=valor_luminosidad
	ldr r1,[r0]
	add r1,#4

	str r1,[r0]
	ldr r0,=impsi4
	bl puts
	b bit04_l
	
noEsCuatro:
	ldr r0,=impno4
	bl puts

bit04_l:
	mov r0, #23			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsOcho
	beq noEsOcho

siEsOcho:
	ldr r0,=valor_luminosidad
	ldr r1,[r0]
	add r1,#8

	str r1,[r0]
	ldr r0,=impsi8
	bl puts
	b bit05_l
noEsOcho:
	ldr r0,=impno8
	bl puts

bit05_l:
	mov r0, #24			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsDseis
	beq noEsDseis
siEsDseis:
	ldr r0,=valor_luminosidad
	ldr r1,[r0]
	add r1,#16

	str r1,[r0]
	ldr r0,=impsi16
	bl puts
	b bit06_l
noEsDseis:
	ldr r0,=impno16
	bl puts

bit06_l:
	mov r0, #25			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsTdos
	beq noEsTdos
siEsTdos:
	ldr r0,=valor_luminosidad
	ldr r1,[r0]
	add r1,#32

	str r1,[r0]
	ldr r0,=impsi32
	bl puts
	b bit07_l
noEsTdos:
	ldr r0,=impno32
	bl puts
		
bit07_l:
	mov r0, #16			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsScuatro
	beq noEsScuatro
siEsScuatro:
	ldr r0,=valor_luminosidad
	ldr r1,[r0]
	add r1,#64

	str r1,[r0]
	ldr r0,=impsi64
	bl puts
	b bit08_l
noEsScuatro:
	ldr r0,=impno64
	bl puts

bit08_l:
	mov r0, #12			@@ Revisamos el primer bit del valor.
	bl GetGpio
	mov r4, r0
	cmp r4, #0
	bne siEsCVocho
	beq noEsCVocho
siEsCVocho:
	ldr r0,=valor_luminosidad
	ldr r1,[r0]
	add r1,#128

	str r1,[r0]
	ldr r0,=impsi128
	bl puts
	b compLum
noEsCVocho:
	ldr r0,=impno128
	bl puts
	

@@Comparacion de Luminosidad @@
compLum:	
	ldr r0,=valor_luminosidad
	ldr r0,[r0]

	cmp r0,#200
	bgt noencenderluminosidad
	blt encenderluminosidad

noencenderluminosidad:
	@@ Apaga el led @@
	mov r0,#26
	mov r1,#0
	bl SetGpio
	bl DibujarVENTANA2

	b inicioPrograma

encenderluminosidad:
	@@ Enciende el led @@
	mov r0,#26
	mov r1,#1
	bl SetGpio
	bl DibujarVENTANA1
	b inicioPrograma

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fin:
	@@ Apaga led en señal de encendido @@
	mov r0,#17
	mov r1,#0
	bl SetGpio

	@@ Apaga el led @@
	mov r0,#26
	mov r1,#0
	bl SetGpio

	@@ Apaga el led @@
	mov r0,#13
	mov r1,#0
	bl SetGpio

	@@ Apaga el led @@
	mov r0,#19
	mov r1,#0
	bl SetGpio
	
	mov r7,#1 
	swi 0
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@@ SUBRUTINAS @@

delay:
	push {lr}

	mov r0, #0x9000000 
	sleepinicio:
	subs r0,#1
	bne sleepinicio 

	pop {pc}
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@@@@ SUBRUTINAS @@@@


DibujarBienvePrin: 
push {r0-r12, lr}
x         .req r1
y         .req r2
colour    .req r3
addrPixel .req r5
countByte .req r6
ancho     .req r7
alto      .req r8

mov countByte,#0 //Contador que cuenta la cantidad de bytes dibujados
ldr ancho,=BienvePrinAncho
ldr ancho,[ancho]
ldr alto,=BienvePrinAlto
ldr alto,[alto]
mov y,#0
               
//Ciclo que dibuja filas
FilaBienvePrin:
	mov x,#0
	
	drawBienvePrin:
        	cmp x,ancho     //comparar x con el ancho de la imagen
        	bge endBienvePrin
        	ldr addrPixel,=BienvePrin    //Obtenemos la direccion de la matriz con los c$
        	ldrb colour,[addrPixel,countByte] //Leer el dato de la matriz.
        
		ldr r0,=pixelAddr
        	ldr r0,[r0]

        	push {r0-r12}
        	bl pixel
        	pop {r0-r12}
		add countByte,#1 //Incrementamos los bytes dibujados
        	add x,#1 //Aumenta el contador del ancho de la imagen

		b drawBienvePrin

endBienvePrin:
// aumentamos y
add y,#1

//Revisamos si ya dibujamos toda la imagen.
teq y,alto
bne FilaBienvePrin

pop {r0-r12, lr}
mov pc, lr

DibujarVENTANA1: 
push {r0-r12, lr}
x         .req r1
y         .req r2
colour    .req r3
addrPixel .req r5
countByte .req r6
ancho     .req r7
alto      .req r8

mov countByte,#0 //Contador que cuenta la cantidad de bytes dibujados
ldr ancho,=VENTANA1Ancho
ldr ancho,[ancho]
ldr alto,=VENTANA1Alto
ldr alto,[alto]
mov y,#0
                //Ciclo que dibuja filas
FilaVENTANA1:
mov x,#0
drawVENTANA1:
        cmp x,ancho     //comparar x con el ancho de la imagen
        bge endVENTANA1
        ldr addrPixel,=VENTANA1     //Obtenemos la direccion de la matriz con los c$
        ldrb colour,[addrPixel,countByte]       //Leer el dato de la matriz.
        ldr r0,=pixelAddr
        ldr r0,[r0]

        push {r0-r12}
        bl pixel
        pop {r0-r12}

        add countByte,#1 //Incrementamos los bytes dibujados
        add x,#1 //Aumenta el contador del ancho de la imagen
	b drawVENTANA1

endVENTANA1:
// aumentamos y
add y,#1

//Revisamos si ya dibujamos toda la imagen.
teq y,alto
bne FilaVENTANA1

pop {r0-r12, lr}
mov pc, lr

//----------------------------------------



DibujarVENTANA2: 
push {r0-r12, lr}
x         .req r1
y         .req r2
colour    .req r3
addrPixel .req r5
countByte .req r6
ancho     .req r7
alto      .req r8

mov countByte,#0 //Contador que cuenta la cantidad de bytes dibujados
ldr ancho,=VENTANA2Ancho
ldr ancho,[ancho]
ldr alto,=VENTANA2Alto
ldr alto,[alto]
mov y,#0
                //Ciclo que dibuja filas
FilaVENTANA2:
mov x,#0
drawVENTANA2:
        cmp x,ancho     //comparar x con el ancho de la imagen
        bge endVENTANA2
        ldr addrPixel,=VENTANA2     //Obtenemos la direccion de la matriz con los c$
        ldrb colour,[addrPixel,countByte]       //Leer el dato de la matriz.
        ldr r0,=pixelAddr
        ldr r0,[r0]
        push {r0-r12}
        bl pixel
        pop {r0-r12}
        add countByte,#1 //Incrementamos los bytes dibujados
        add x,#1 //Aumenta el contador del ancho de la imagen
	
	b drawVENTANA2

endVENTANA2:
// aumentamos y
add y,#1

//Revisamos si ya dibujamos toda la imagen.
teq y,alto
bne FilaVENTANA2

pop {r0-r12, lr}
mov pc, lr

//----------------------------------------


DibujarVENTANA3: 
push {r0-r12, lr}
x         .req r1
y         .req r2
colour    .req r3
addrPixel .req r5
countByte .req r6
ancho     .req r7
alto      .req r8

mov countByte,#0 //Contador que cuenta la cantidad de bytes dibujados
ldr ancho,=VENTANA3Ancho
ldr ancho,[ancho]
ldr alto,=VENTANA3Alto
ldr alto,[alto]
mov y,#0
                //Ciclo que dibuja filas
FilaVENTANA3:
mov x,#0
drawVENTANA3:
        cmp x,ancho     //comparar x con el ancho de la imagen
        bge endVENTANA3
        ldr addrPixel,=VENTANA3     //Obtenemos la direccion de la matriz con los c$
        ldrb colour,[addrPixel,countByte]       //Leer el dato de la matriz.
        ldr r0,=pixelAddr
        ldr r0,[r0]
        push {r0-r12}
        bl pixel
        pop {r0-r12}
        add countByte,#1 //Incrementamos los bytes dibujados
        add x,#1 //Aumenta el contador del ancho de la imagen
	
	b drawVENTANA3

endVENTANA3:
// aumentamos y
add y,#1

//Revisamos si ya dibujamos toda la imagen.
teq y,alto
bne FilaVENTANA3

pop {r0-r12, lr}
mov pc, lr







@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@ DATOS @@	

.data 
.align 2

.global myloc
myloc: 
	.word 0

.global pixelAddr
pixelAddr: 
	.word 0
terminar:
	.word 0
valor_luminosidad:
	.word 0
valor_temperatura:
	.word 0
valor_humedad:
	.word 0





si:
	.asciz "Terminar!"
lumi:
	.asciz "Luminosidad!"

temp:
	.asciz "Temperatura!"
hume:
	.asciz "Humedad!"
@@@@@@@@@@ temporales @@@@@@@@@@@
impsi:
	.asciz "Si es 1"
impsi2:
	.asciz "Si es 2"
impno2:
	.asciz "No es 2"
impno:
	.asciz "No es 1"
impsi4:
	.asciz "Si es 4"
impno4:
	.asciz "No es 4"
impsi8:
	.asciz "Si es 8"
impno8:
	.asciz "No es 8"
impsi16:
	.asciz "Si es 16"
impno16:
	.asciz "No es 16"
impsi32:
	.asciz "Si es 32"
impno32:
	.asciz "No es 32"
impsi64:
	.asciz "Si es 64"
impno64:
	.asciz "No es 64"
impsi128:
	.asciz "Si es 128"
impno128:
	.asciz "No es 128"
siesdos:
	.asciz "SI SI SI SI SI ..."
.end
