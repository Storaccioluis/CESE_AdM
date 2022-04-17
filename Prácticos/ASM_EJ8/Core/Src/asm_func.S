.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_svc
.global asm_sum

.global asm_downsampleM
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
@   r1: Vout
@   r2: long
@   r3: N
@ Valor de retorno:
@   r0: resultado de la suma de firstOperand y secondOperand
@
.thumb_func
    asm_downsampleM:
         push {r5,r6,r7,r8,r9}
         mov r5,0
         mov r6,0  //r6--> acum
         mov r7,0  //r7--> acum_dec
         mov r8,r3
      .asm_max_for:
         ldr r9,[r0],4
         cmp r6,r8
         beq  .asm_cmp_decimar
         str r9,[r1],4
         add r6,1
         subs r2,1
         bne .asm_max_for
         pop {r5,r6,r7,r8,r9}
         bx lr



 .asm_cmp_decimar:
         mov r6,0
         subs r2,1
         bne .asm_max_for
		 pop {r5,r6,r7,r8,r9}
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
