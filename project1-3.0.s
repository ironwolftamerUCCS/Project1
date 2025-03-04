.globl main 
.equ STDOUT, 1
.equ STDIN, 0
.equ __NR_READ, 63
.equ __NR_WRITE, 64
.equ __NR_EXIT, 93

.text

# V3.0 replaces the write_string with puts and adds the putchar function

main:
	# main() prolog
	addi sp, sp, -104
	sw ra, 100(sp)

	# main() body

	# Write the prompt to the terminal (stdout)
	# Setup args
	la a0, prompt
	addi  a1, zero, prompt_end - prompt
	# Call write function
	jal puts

	# Read up to 100 characters from the terminal (stdin)
	# Setup args
	mv a0, sp
	addi a1, zero, 100
	# Call read function
	jal read_string

	# Write the just read characters to the terminal (stdout)
	# Setup args
	addi a1, a0, 0 
	mv a0, sp
	# Call write function
	jal puts

	# main() epilog
	lw ra, 100(sp)
	addi sp, sp, 104
	ret
	
puts:
    #a0 = prompt

	# prolog
	addi sp, sp, -4
	sw ra, 0(sp)

	mv s1, a0

	#body
	WHILE:
        mv a0, s1
        lb t0, 0(a0)
		beqz t0, DONE
        addi s1, s1, 1
		jal putchar
		lb t0, 0(a0)
		blt t0, zero, ERROR
		j WHILE

	ERROR:
		li a0, -1
		j EPI

	DONE:
		li a0, 0

	#epilog
	EPI:
		lw ra, 0(sp)
		addi sp, sp, 4
		ret

putchar:
	#prolog
	addi sp, sp, -4
	sw a0, 0(sp)

	mv a1, a0
	li a2, 1
    li a7, __NR_WRITE
    li a0, STDOUT
    ecall 
 
	#epilog
	lw a0, 0(sp)
	addi sp, sp, 4
	ret
	
    
read_string:
    mv a2, a1
    mv a1, a0
    li a7, __NR_READ
    li a0, STDIN
    ecall
    ret

.data
prompt:   .ascii  "Enter a message: "
prompt_end:

