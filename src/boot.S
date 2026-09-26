.section .text.boot

.global _start
.extern __bss_start
.extern __bss_end
.extern __stack_top
.extern kernel_main

_start:
    mrs x0, mpidr_el1
    ubfx x1, x0, #32, #8
    lsl x1, x1, #24
    ubfx x2, x0, #16, #8
    orr x1, x1, x2, lsl #16
    ubfx x2, x0, #8, #8
    orr x1, x1, x2, lsl #8
    and x2, x0, #0xff
    orr x1, x1, x2
    cbz x1, 1f

0:
    wfe
    b 0b

1:
    ldr x0, =__stack_top
    mov sp, x0

    ldr x0, =__bss_start
    ldr x1, =__bss_end

2:
    cmp x0, x1
    b.eq 3f
    str xzr, [x0], #8
    b 2b

3:
    bl kernel_main

4:
    wfe
    b 4b
