	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 13, 0	sdk_version 13, 1
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	wzr, [x29, #-4]
	stur	wzr, [x29, #-8]

	adr	x0, array_data                 ; Load the address of the array_data
	mov	x1, #0                          ; Initialize the loop counter
	mov	x2, #5                          ; Set the length of the array
	mov	w8, #0                          ; Initialize the sum variable

LBB0_1:                                 ; =>This Inner Loop Header: Depth=1
	cmp	x1, x2                         ; Compare loop counter with array length
	b.ge	LBB0_4                         ; If loop counter >= array length, jump to LBB0_4
	ldr	w9, [x0, x1, sxtw]             ; Load array element to w9
	add	w8, w8, w9                     ; Add the element to the sum
	add	x1, x1, #1                     ; Increment the loop counter
	b	LBB0_1                         ; Jump back to the loop header

LBB0_4:
	mov	x9, sp
	str	w8, [x9]                       ; Store the sum result on the stack
	adrp	x0, l_.str@PAGE
	add	x0, x0, l_.str@PAGEOFF
	bl	_printf                        ; Call printf with the sum result
	mov	w0, #0
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"Hello, World! Sum: %d\n"

	.section	__TEXT,__const
array_data:
	.int	1, 2, 3, 4, 5                ; Array data (5 elements)

.subsections_via_symbols

