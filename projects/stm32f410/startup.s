.syntax unified
.cpu cortex-m4
.fpu fpv4-sp-d16
.thumb

/* Endereços de memória definidos no linker.ld */
.word _estack      /* Inicialização do ponteiro de pilha */
.word Reset_Handler /* Endereço do tratador de RESET */
.word Default_Handler /* NMI */
.word Default_Handler /* HardFault */
.word Default_Handler /* MemManage */
.word Default_Handler /* BusFault */
.word Default_Handler /* UsageFault */
.word 0             /* Reservado */
.word 0             /* Reservado */
.word 0             /* Reservado */
.word 0             /* Reservado */
.word Default_Handler /* SVC */
.word Default_Handler /* DebugMon */
.word 0             /* Reservado */
.word Default_Handler /* PendSV */
.word Default_Handler /* SysTick */
/* Demais vetores podem ser adicionados conforme necessidade */

.section .text.Reset_Handler
.thumb_func
.global Reset_Handler
Reset_Handler:
    /* Inicialização de dados .data: copiar da FLASH para RAM */
    ldr r0, =_sidata  /* Origem na FLASH */
    ldr r1, =_sdata   /* Destino na RAM */
    ldr r2, =_edata   /* Fim da RAM */
    b data_copy_end
data_copy_loop:
    ldr r3, [r0], #4
    str r3, [r1], #4
data_copy_end:
    cmp r1, r2
    bcc data_copy_loop

    /* Zerar seção .bss na RAM */
    ldr r0, =_sbss
    ldr r1, =_ebss
    movs r2, #0
    b bss_zero_end
bss_zero_loop:
    str r2, [r0], #4
bss_zero_end:
    cmp r0, r1
    bcc bss_zero_loop

    /* Chamar a aplicação principal */
    bl main

    /* Se retornar, travar aqui */
loop_forever:
    b loop_forever

/* Tratador padrão para interrupções não implementadas */
.section .text.Default_Handler
.thumb_func
Default_Handler:
    b .

.align