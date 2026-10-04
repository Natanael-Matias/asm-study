.syntax unified
.cpu cortex-m4
.fpu fpv4-sp-d16
.thumb

/* Definições de registradores — STM32F410 */
.equ RCC_BASE,      0x40023800
.equ RCC_AHB1ENR,   (RCC_BASE + 0x30)
.equ GPIOA_BASE,    0x40020000
.equ GPIOA_MODER,   (GPIOA_BASE + 0x00)
.equ GPIOA_ODR,     (GPIOA_BASE + 0x14)
.equ GPIOA_BSRR,    (GPIOA_BASE + 0x18)
.equ RCC_GPIOAEN,   (1 << 0)       /* Habilita clock GPIOA — bit 0 */
.equ LED_PIN,       5              /* Pino PA5 */

.section .text
.global main
.thumb_func
main:
    /* Passo 1 — Habilitar clock do GPIOA no RCC_AHB1ENR */
    ldr r0, =RCC_AHB1ENR
    ldr r1, [r0]
    orr r1, r1, #RCC_GPIOAEN
    str r1, [r0]

    /* Passo 2 — Definir PA5 como saída (MODER = 01) */
    ldr r0, =GPIOA_MODER
    ldr r1, [r0]
    bic r1, r1, #(0x3 << (LED_PIN * 2))  /* Limpar bits */
    orr r1, r1, #(0x1 << (LED_PIN * 2))  /* Definir como saída */
    str r1, [r0]

    /* Passo 3 — Ligar e desligar LED em loop */
led_loop:
    /* Ligar LED — definir bit em BSRR (set) */
    ldr r0, =GPIOA_BSRR
    movs r1, #(1 << LED_PIN)
    str r1, [r0]

    bl delay /* Esperar um tempo */

    /* Desligar LED — definir bit em BSRR (reset = bit + 16) */
    ldr r0, =GPIOA_BSRR
    movs r1, #(1 << (LED_PIN + 16))
    str r1, [r0]

    bl delay

    b led_loop /* Repetir */

/* Função de atraso aproximado */
.thumb_func
delay:
    ldr r2, =500000  /* Valor ajustável conforme velocidade do clock */
delay_loop:
    subs r2, r2, #1
    bne delay_loop
    bx lr

.align