.global _main
.extern _printf

.data
array_base:
    .xword 0x1234567812345678, 0x2345678923456789, 0x3456789034567890, 0x4567890145678901

array_length:
    .word 8

.text
_main:
    stp x29, x30, [sp, #-16]!   ; Save frame pointer and return address
    mov x29, sp                 ; Update frame pointer

    ldr x0, =array_base         ; Load array base address
    ldr w1, =array_length       ; Load array length
    mov x2, #0                  ; Initialize sum for core 0
    mov x3, #0                  ; Initialize sum for core 1

    ; Calculate the sum for the assigned part of the array
    mov x4, 0                   ; Assuming core ID is 0
    cbz x4, core0_loop          ; If core ID is 0
    b core1_loop                ; If core ID is 1

core0_loop:
    ldr x5, [x0], #8            ; Load the array element and increment the pointer
    add x2, x2, x5              ; Add the element to the sum
    sub w1, w1, #1              ; Decrement the array length
    cbnz w1, core0_loop         ; If there are still elements left, continue the loop
    b finish                    ; Otherwise, finish

core1_loop:
    ldr x5, [x0, x1, lsl #3]    ; Load the array element from the second half
    add x3, x3, x5              ; Add the element to the sum
    sub w1, w1, #1              ; Decrement the array length
    cbnz w1, core1_loop         ; If there are still elements left, continue the loop

finish:
    add x2, x2, x3              ; Combine the partial sums
    ; The final sum is in x2

    ; Print the result
    ldr x0, =result_fmt
    bl _printf

    ldp x29, x30, [sp], #16     ; Restore frame pointer and return address
    ret

result_fmt:
    .asciz "Sum: %ld\n"

