/* Script de linker para STM32F410RB */
/* Flash: 128KB @ 0x08000000 | RAM: 32KB @ 0x20000000 */

MEMORY
{
  FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 128K
  RAM   (xrw) : ORIGIN = 0x20000000, LENGTH = 32K
}

/* Símbolos para inicialização */
_estack      = ORIGIN(RAM) + LENGTH(RAM);  /* Topo da pilha */
_sidata      = LOADADDR(.data);             /* Origem .data na FLASH */
_sdata       = ORIGIN(.data);               /* Início .data na RAM */
_edata       = ORIGIN(.data) + LENGTH(.data); /* Fim .data na RAM */
_sbss        = ORIGIN(.bss);
_ebss        = ORIGIN(.bss) + LENGTH(.bss);

SECTIONS
{
  .isr_vector :
  {
    . = ALIGN(4);
    KEEP(*(.isr_vector))  /* Tabela de vetores no início da FLASH */
    . = ALIGN(4);
  } > FLASH

  .text :
  {
    . = ALIGN(4);
    *(.text)              /* Código */
    *(.text*)
    *(.rodata)            /* Dados constantes */
    *(.rodata*)
    . = ALIGN(4);
    _etext = .;           /* Fim do código */
  } > FLASH

  .data :
  {
    . = ALIGN(4);
    _sdata = .;
    *(.data)
    *(.data*)
    . = ALIGN(4);
    _edata = .;
  } > RAM AT > FLASH      /* Carregado na FLASH, executado na RAM */

  .bss :
  {
    . = ALIGN(4);
    _sbss = .;
    *(.bss)
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;
  } > RAM

  /* Espaço para pilha e heap (opcional) */
  . = ALIGN(8);
}