.globl main 
.equ STDOUT, 1
.equ STDIN, 0
.equ __NR_READ, 63
.equ __NR_WRITE, 64
.equ __NR_EXIT, 93

.text

# V3.1 replaces the read_string with gets and adds the getchar function

main:
	# main() prolog
	addi sp, sp, -104
	sw ra, 100(sp)

	# main() body

	# Write the prompt to the terminal (stdout)
	# Setup args
	la a0, prompt
	# Call write function
	jal puts

	# Read up to 100 characters from the terminal (stdin)
	# Setup args
	mv a0, sp
	# Call read function
	jal gets

	# Write the just read characters to the terminal (stdout)
	# Setup args
	mv a0, sp
	# Call write function
	jal puts

	# main() epilog
	lw ra, 100(sp)
	addi sp, sp, 104
	ret
	
puts:
	# prolog
	addi sp, sp, -8
	sw sp, 4(sp)
	sw ra, 0(sp)

	mv s1, a0

	#body
	PWHILE:
        mv a0, s1
        lb t0, 0(a0)
		beqz t0, PDONE
        addi s1, s1, 1
		jal putchar
		lb t0, 0(a0)
		blt t0, zero, PERROR
		j PWHILE

	PERROR:
		li a0, -1
		j PEPI

	PDONE:
		li a0, 0

	#epilog
	PEPI:
		lw ra, 0(sp)
		lw sp, 4(sp)
		addi sp, sp, 8
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
	
    
gets:
	#prolog
	addi sp, sp, -8
	sw sp, 4(sp)
	sw ra, 0(sp)

	#body
    mv t0, a0
	li t1, 0

	WHILE:
		jal getchar
		lb t1, 0(a0)
		blt t1, zero, ERROR
		sb t1, 0(t0)
		addi t0, t0, 1
		li t2, 10
		beq t1, t2, DONE
		mv a0, t0
		j WHILE

	ERROR:
		mv a0, t1
		j EPI

	DONE: 
		addi t0, t0, -1
		li t1, 0
		sb t1, 0(t0)
		sub a0, a0, t0

	#epilog
	EPI:
		lw ra, 0(sp)
		lw sp, 4(sp)
		addi sp, sp, 8
		ret



getchar:
	#prolog
	addi sp, sp, -4
	sw a0, 0(sp)

	mv a1, a0
	li a2, 1
    li a7, __NR_READ
    li a0, STDIN
    ecall 
 
	#epilog
	lw a0, 0(sp)
	addi sp, sp, 4
	ret
	

.data
prompt:   .ascii  "Enter a message: "
prompt_end:

