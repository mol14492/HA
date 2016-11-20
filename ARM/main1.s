.text
.align 2
.global main
 
@@ COMPILAR @@

@@ gcc -o main main.s BienvePrin.s gpio0.s pixel.c VENTANA1.s VENTANA2.s pyh_to_virt.o
@@ sudo ./main


 main:

	bl getScreenAddr
	ldr r1,=pixelAddr
	str r0,[r1]
	bl GetGpioAddress
    
terminarPrograma:
    
    ldr r0,=terPro
    ldr r0,[r0]
    cmp r0,#0
    bne fin
    beq incioPrograma

incioPrograma:
    


    bl DibujarVENTANA1
    
    
    bl wait
    bl wait
    bl wait
    
    
    bl DibujarVENTANA2
    
    bl wait
    bl wait
    bl wait
    
    bl DibujarBienvePrin
    
    bl wait
    bl wait
    bl wait
    
    
b terminarPrograma

fin:
	mov r7,#1 
	swi 0

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@@@@ SUBRUTINAS @@@@

//-----------------------------------
//   Subrutinas
//-----------------------------------

//Dibujando la planta mas peque
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

//------------------------------------

//Dibujando la planta mas grande
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


//Dibujando la planta normal
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

wait:
mov r0, #0x4000000
sleepLoop1:
subs r0,#1
bne sleepLoop1
mov pc, lr 

	.unreq x
	.unreq	y         
	.unreq	colour 	  
	.unreq	addrPixel 
	.unreq	countByte 
	.unreq	ancho	  
	.unreq	alto	
    
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@ DATOS @@@@@@@@@@@

.data

terPro:
    .word 0
    
forma: .asciz " %d\n"

.global myloc
myloc: .word 0

.global pixelAddr
pixelAddr: .word 0


