.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_svc
.global asm_sum

.global asm_max
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
@  void int32_t max (int32_t * vectorIn, uint32_t longitud);
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
    asm_max:
         push { r5,r6,r7,r8}
         sub r5,r1,1
         mov r6,r0
         add r0,4
      .asm_max_for:
         ldr r7,[r0]
         ldr r8,[r6]
         cmp r7,r8
         ble .asm_max_menor
         mov r6,r0

    .asm_max_menor:
         add r0,4
         subs r5,1
         bne .asm_max_for
         mov r0,r6
         pop { r5,r6,r7}
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
