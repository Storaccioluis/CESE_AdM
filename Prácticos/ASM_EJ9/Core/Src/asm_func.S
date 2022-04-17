.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_svc
.global asm_sum

.global asm_invertir
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
@  void asm_downsampleM (int32_t * vectorIn, int32_t * vectorOut, uint32_t longitud, uint32_t N);
@
@ Parametros recibidos:
@   r0: Vin
@   r1: long
@ Valor de retorno:
@   r0: resultado de la suma de firstOperand y secondOperand
@
.thumb_func
    asm_invertir:
         push {r5,r6,r7,r8,r9,r10,r11}

         mov r5,2
         udiv r5,r1,r5                //r5----> TAM/2
         mov r6,0                     //r6----> acum
         mov r8,0                     //r8----> Index
         mov r10,2                    //r2----> multiplicar por 2
         sub r1,r1,1
         mov r9,r0                    //r9----> direccion Vin
         mov r12,r0
      .asm_invertir_for:

         sub r7,r1,r8
         mul r7,r10
         add r9,r0,r7
         ldrh r7,[r9]
         mov r6,r7
         ldrh r11,[r12]
         strh r11,[r9]
         strh r6,[r12],2
         add r8,1
         mov r6,0
         subs r5,1
         bne .asm_invertir_for


		 pop {r5,r6,r7,r8,r9,r10,r11}
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
