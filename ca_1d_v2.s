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
	mov	x23, sp                          ; Save the address of the current sum to x23

LBB0_5:                                 ; Inner loop (cell updates)
	cmp	x1, x2
	b.ge	LBB0_8
	ldr	w9, [x20, x1, lsl #2]            ; Load the current cell value
	cmp	x1, #0
	b.eq	LBB0_6
	sub	x24, x1, #1
	ldr	w11, [x20, x24, lsl #2]       ; Load the left neighbor value
	b	LBB0_7
LBB0_6:
	mov	w11, wzr                         ; Set the left neighbor value to 0
LBB0_7:
	cmp	x1, x2, sub #1
	b.eq	LBB0_8
	add	x24, x1, #1
	ldr	w12, [x20, x24, lsl #2]       ; Load the right neighbor value
	b	LBB0_9
LBB0_8:
	mov	w12, wzr                         ; Set the right neighbor value to 0
LBB0_9:
	eor	w9, w9, w11
	eor	w9, w9, w12
	str	w9, [x23, x1, lsl #2]            ; Save the updated cell value
		add	x1, x1, #1
	b	LBB0_5

LBB0_10:
	mov	x1, #0                          ; Reset x1 (loop counter) to 0
	ldr	x0, [x23, x1, lsl #2]            ; Load updated cell value to x0
	str	x0, [x20, x1, lsl #2]            ; Store updated cell value back to the original location
	add	x1, x1, #1
	cmp	x1, x2
	b.lt	LBB0_10

	sub	x19, x19, #1
	cbnz	x19, LBB0_1                     ; If there are more iterations, jump back to LBB0_1

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


