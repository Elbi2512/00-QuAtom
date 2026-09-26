.section .text.boot
.global _start
.extern __bss_start
.extern __bss_end
.extern __stack_top
.extern kernel_main

.section .data.boot, "aw"
.align 3
boot_core_claim:
    .quad 0

.section .text.boot
_start:
    mrs x0, mpidr_el1
    and x0, x0, #0xff
    cbnz x0, 0f

    ldr x0, =boot_core_claim

1:
    ldaxr x1, [x0]
    cbnz x1, 0f
    mov x1, #1
    stxr w2, x1, [x0]
    cbnz w2, 1b

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
