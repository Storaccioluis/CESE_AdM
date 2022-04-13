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
         push { r5,r6,r7,r8,r10,r11,r12}
         mov r8,r0
         mov r5,r2
         mov r7,3
     .asm_filtroVentana10_for:
         mov r6,r0
         cmp r5,2
         beq .asm_filtroVentana10_Ind_2
         cmp r5,1
         beq .asm_filtroVentana10_Ind_1

         ldrh r10,[r6],2
         ldrh r11,[r6],2
         ldrh r12,[r6]
         ADD r10,r10,r11
         ADD r10,r10,r12
         SDIV r10,r10,r7
         strh r10,[r1],2
         ADD r0,2
         subs r5,1
         bne .asm_filtroVentana10_for


     .asm_filtroVentana10_Ind_2:
      ldrh r10,[r6],2
      ldrh r11,[r6],2
      ldrh r12,[r8]
      ADD r10,r10,r11
      ADD r10,r10,r12
      SDIV r10,r10,r7
      strh r10,[r1],2
      subs r5,1
      bne .asm_filtroVentana10_for

     .asm_filtroVentana10_Ind_1:
      ldrh r10,[r6],2
      ldrh r11,[r8],2
      ldrh r12,[r8]
      ADD r10,r10,r11
      ADD r10,r10,r12
      SDIV r10,r10,r7
      strh r10,[r1],2
      subs r5,1
      bne .asm_filtroVentana10_for

         pop { r5,r6,r7,r10,r11,r12}
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
