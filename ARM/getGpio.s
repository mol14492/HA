.global GetGpio

GetGpio:
	push {lr}
	mov r9, r0
	ldr r6, =myloc
 	ldr r0, [r6] @ obtener direccion 
	ldr r5,[r0,#0x34]
	mov r7,#1
	lsl r7,r9
	and r5,r7 

	teq r5, #0
	movne r5, #1
	mov r0, r5
	pop {pc}


