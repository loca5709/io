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
done:
	break

.data
STR_PROMPT: .string "Enter number:"
STR_TOTAL:  .string "Total:"
