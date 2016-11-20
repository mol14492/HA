.text
.global dibujar
	
dibujar:
	push {lr}
	
	ldr r8,=xTemp
	str r2,[r8]
	
	mov r6,r4
	
	ldr r8,=yTemp
	str r3,[r8]
	
	ldr r8,=y
	str r0,[r8]
	
	ldr r8,=x
	str r4,[r8]
	
	push {r1}
	mov r9,r2
	
	pop {r4}
	mov r7,r4
	ldr r7,[r7]
	push {r4}
	
	
recorrer:
	
	ldr r10,=xTemp
	ldr r10,[r10]
	sub r10,#1
	cmp r10,#0
	blt siguiente
	
	ldr r0,=xTemp
	str r10,[r0]
	
	ldr r0,=pixelAddr
	ldr r0,[r0]
	ldr r1,=x
	ldr r1,[r1]
	ldr r2,=y
	ldr r2,[r2]
	pop {r4}
	ldrb r3,[r4],#4
	push {r4}
	
	cmp r3,r7
	beq loop3
	bl pixel
	
loop3:

	ldr r0,=x
	ldr r0,[r0]
	add r0,#1
	ldr r1,=x
	str r0,[r1]
	b recorrer
	
siguiente:

	ldr r11,=yTemp
	ldr r11,[r11]
	sub r11,#1
	cmp r11,#0
	beq fin1
	
	ldr r0,=yTemp
	str r11,[r0]
	

	ldr r0,=x
	mov r1,r6
	str r1,[r0]
	

	ldr r0,=xTemp
	str r9,[r0]
	

	ldr r0,=y
	ldr r0,[r0]
	add r0,#1
	ldr r1,=y
	str r0,[r1]

	b recorrer
	
fin1:
	pop {r9}
	pop {pc}
