.global _start
_start:
	####
	# Example code to print the "Enter number:" prompt
	movia	r2, 0xff201000		# JTAG UART MMIO base address
    movia   r15, STR_PROMPT		# address of "Enter number:" string
	movi r18, 0
	
write_str:
    ldb     r16, 0(r15)			# r16 = read next character from STR_PROMPT
    addi    r15, r15, 1			# advance pointer in STR_PROMPT
    beq     r16, r0, read_init		# if we read null character, we're done

wait:
	ldwio	r17, 4(r2)			# read the control register to read WSPACE
	srli	r17, r17, 16		# get WSPACE
	beq		r17, r0, wait		# wait until there is space

    stwio   r16, 0(r2)			# write character (r16)
    br		write_str           # repeat for the next character

read_init:
	movi r19, 0

readchar:
ldwio r20, 0(r2)
andi r21, r20, 0x8000
beq r21, r0, read_char

andi r16,r20 0x00FF

wait_echo:
	ldwio	r17, 4(r2)			# read the control register to read WSPACE
	srli	r17, r17, 16		# get WSPACE
	beq		r17, r0, wait		# wait until there is space

    stwio   r16, 0(r2)	

	movi r22, 0x30
	blt r16, r22, read_char
	movi r23,0x39
	blt r23, r 16, read_char

	addi r16, r16, -48
    movi r24, 10
    mul r19, r19, r24
    add r19, r19, r16
    br read_char
	
	finish_number:
	add r18, r18, r19
	movia r15, STR_TOTAL
	addi r15, r15, 1
	beq r16, r0, print_total_num
	
	write_total:
	divu r29, r25, r26
	mul r30, r29, r26
	sub r16, r25, r30
    addi r16, r16, 48
    stb r16, 0(r27)
    addi r27, r27, 1
    addi r28, r28, 1
    mov r25, r29
    bne r25, r0, make_digits

    addi r27, r27, -1

	print_digits:
	ldb r16, 0(r27)

	wait_digit:
	ldwio r17, 4(r2)
	srli r17, r17, 16
	beq r17, r0, wait_digit

	stwio r16, 0(r2)
	addi r27, r27, -1
	addi r28, r28, -1
	bne r28, r0, print_digits
	br print_endline

	print_zero:
	movi r16, 0x30

	wait_zero:
	ldwio r17, 4(r2)
	srli r17, r17, 16
	beq r17, r0, wait_zero

	stwio r16 0(r2)

	print_endline:
	movi r16, 0x0A

	wait_nl2:
	ldwio r17, 4(r2)
	srli r17, r17, 16
	beq r17, r0, wait_nl2

	stwio r16, 0(r2)

	movia r15, STR_PROMPT
	br write_str

	.data
	STR_PROMPT: .string "Enter number:"
	STR_TOTAL: .string "Total:"
	DIGITS: .skip 16
	
	
done:
	break

.data
STR_PROMPT: .string "Enter number:"
STR_TOTAL:  .string "Total:"
