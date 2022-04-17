.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_svc
.global asm_sum

.global asm_filtroVentana10
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_svc (void)
@
.thumb_func
    asm_svc:
        svc 0
        bx lr



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@  void asm_filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitudVectorIn);
@
@ Parametros recibidos:
@   r0: firstOperand
@   r1: secondOperand
@   r2: thirdOperand
@
@ Valor de retorno:
@   r0: resultado de la suma de firstOperand y secondOperand
@
.thumb_func
    asm_filtroVentana10:
         push {r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
         mov r5,r0 			//r5--> dirección primer elemento Vin
         sub r6,r2,8 		//r6-->TAM-10  --2
         mov r7,0           //r7-->i_index
         mov r8,0           //r8-->j_index
         mov r9,0           //r9-->k_index
         mov r12,0          //r12--> acum
         mov r11,10         //r11--> index j --10



     .asm_filtroVentana10_for_i_index:       //for i_index
          mov r9,0           //r9-->k_index =0
          mov r10,r7
         .asm_filtroVentana10_for_j_index:   //for j_index
         add r10,r7,r8                       //r10--> i_index + j_index
         mov r0,r5
         cmp r10,r6					 //cmp (i_index+j_index)<=r6
         blt .asm_filtroVentana10_menor

         mov r3,2
         mul r3,r9,r3
         add r0,r3
         ldrh r4,[r0]
         add r12,r4
         add r8,1
         add r9,1
         subs r11,1
         bne .asm_filtroVentana10_for_j_index
         mov r3,10                  // 10 --- 2
         udiv r3,r12,r3
         strh r3,[r1],2
         mov r12,0
         mov r11,10
         add r7,1
         subs r2,1
         bne .asm_filtroVentana10_for_i_index
         pop {r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
         bx lr

     .asm_filtroVentana10_menor:
         mov r3,2
         mul r3,r10,r3
         add r0,r3
         ldrh r4,[r0]
         add r12,r4                         //acum + V[i+j]
         add r8,1
         subs r11,1
         bne .asm_filtroVentana10_for_j_index
         mov r8,0
         mov r3,10                // 10 --- 2
         udiv r3,r12,r3
         strh r3,[r1],2
         mov r12,0
         add r7,1
         mov r11,10
         subs r2,1
         bne .asm_filtroVentana10_for_i_index
         pop {r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
         bx lr       @ vuelve adonde fue llamada (especificamente, si "pc"
                    @ es la direccion, en el codigo del programa, de la
                    @ instruccion "bl asm_sum" usada para saltar a
                    @ esta funcion, entonces "lr" contiene ese "pc" + 4).
                    @ el valor de retorno debe quedar en el registro r0.
                    @ En este caso, r0 es el resultado de r0 + r1.

        @ Otras alternativas para el retorno
        @ mov pc,lr
        @ bx lr
        @ push {lr} ... pop {pc}
