STACK_SIZE = 0x1000;

ENTRY(_start)

SECTIONS
{
    . = 0x80000;

    .text : ALIGN(16)
    {
        KEEP(*(.text.boot))
        *(.text*)
    }

    .rodata : ALIGN(16)
    {
        *(.rodata*)
    }

    .data : ALIGN(16)
    {
        *(.data*)
    }

    .bss (NOLOAD) : ALIGN(16)
    {
        . = ALIGN(16);
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(16);
        __bss_end = .;
    }

    .stack (NOLOAD) : ALIGN(16)
    {
        __stack_bottom = .;
        . += STACK_SIZE;
        __stack_top = .;
    }
}
