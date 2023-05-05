	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 13, 0	sdk_version 13, 1
	.globl	_main
	.p2align	2
_main:
	.cfi_startproc
	sub	sp, sp, #64
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16

	adrp	x0, array_data@PAGE
	add	x0, x0, array_data@PAGEOFF

	mov	x1, #0
	mov	x2, #5
	mov	w8, #0

	mov	x19, #5                          ; Number of iterations

LBB0_1:                                 ; Outer loop (iterations)
	cmp	x1, x2                          ; Print the current state
	b.ge	LBB0_4
	ldr	w9, [x0, x1, lsl #2]
	mov	x9, sp
	str	w9, [x9]
	adrp	x10, l_.str1@PAGE
	add	x10, x10, l_.str1@PAGEOFF
	bl	_printf
	add	x1, x1, #1
	b	LBB0_1

LBB0_4:                                 ; Update cellular automata states
	sub	x1, x1, x1                      ; Reset x1 (loop counter) to 0
	mov	x20, x0                          ; Copy the original array address to x20
	sub	x21, x0, #4                      ; Calculate the address for the "virtual" left boundary
	mov	w22, wzr                         ; Set the "virtual" left boundary value to 0
	str	w22, [x21]                       ; Store the "virtual" left boundary value
	add	x21, x0, x2, lsl #2              ; Calculate the address for the "virtual" right boundary
	mov	w22, wzr                         ; Set the "virtual" right boundary value to 0
	str	w22, [x21]                       ; Store the "virtual" right boundary value
	mov	x23, sp                          ; Save the address of the current sum to x23

LBB0_5:                                 ; Inner loop (cell updates)
	cmp	x1, x2
	b.ge	LBB0_8
	ldr	w10, [x20, x1, lsl #2]        ; Load the current cell value
	sub	x24, x1, #1
	ldr	w11, [x20, x24, lsl #2]       ; Load the left neighbor value
	add	x24, x1, #1
	ldr	w12, [x20, x24, lsl #2]       ; Load the right neighbor value
	eor	w9, w9, w10
	eor	w9, w9, w11
	str	w9, [x23, x1, lsl #2]            ; Save the updated cell value
	add	x1, x1, #1
	b	LBB0_5

LBB0_8:
	mov	x0, sp                          ; Set x0 to the updated cell states
	mov	x1, #0                          ; Reset the loop counter

	subs	x19, x19, #1                    ; Decrement the iteration counter
	b.ne	LBB0_1                          ; If there are more iterations, jump back to LBB0_1

LBB0_9:
	mov	w0, #0
	ldp	x29, x30, [sp, #48]
	add	sp, sp, #64
	ret
	.cfi_endproc

	.section	__TEXT,__cstring,cstring_literals
l_.str1:
	.asciz	"%d "

	.section	__TEXT,__const
array_data:
	.int	0, 1, 1, 1, 0                 ; Array data (5 elements)

.subsections_via_symbols

