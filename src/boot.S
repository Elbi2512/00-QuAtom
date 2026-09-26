.section .text.boot

.equ BOOT_CORE_AFFINITY, 0

.global _start
.extern __bss_start
.extern __bss_end
.extern __stack_top
.extern kernel_main

_start:
    mrs x0, mpidr_el1
    mov x1, #0xffff
    movk x1, #0x00ff, lsl #16
    movk x1, #0x00ff, lsl #32
    and x0, x0, x1
    mov x1, #BOOT_CORE_AFFINITY
    cmp x0, x1
    b.eq 1f

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
    b.hs 3f
    str xzr, [x0], #8
    b 2b

3:
    bl kernel_main

4:
    wfe
    b 4b
