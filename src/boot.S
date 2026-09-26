.section .text.boot
.global _start
.extern __bss_start
.extern __bss_end
.extern __stack_top
.extern kernel_main

_start:
    mrs x0, mpidr_el1
    and x0, x0, #0xff
    cbnz x0, 0f

2:
    ldr x0, =__stack_top
    mov sp, x0

    ldr x0, =__bss_start
    ldr x1, =__bss_end

3:
    cmp x0, x1
    b.hs 4f
    str xzr, [x0], #8
    b 3b

4:
    bl kernel_main

5:
    b 5b

0:
    wfe
    b 0b
