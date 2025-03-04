.globl main 
.equ STDOUT, 1
.equ STDIN, 0
.equ __NR_READ, 63
.equ __NR_WRITE, 64
.equ __NR_EXIT, 93

.text

# Final version, outputs a message 1 char at a time
# takes in an input 1 char at a time
# prints the taken in message 1 char at a time

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
		# move the address of the input to a0 and save the actual value to t0 for comparison (t0 != 0)
        mv a0, s1
        lb t0, 0(a0)
		beqz t0, PDONE

		# shift up the address by a byte
        addi s1, s1, 1

		# put the characters
		jal putchar

		# load the return value from putchar back into t0 for comparison
		lb t0, 0(a0)
		blt t0, zero, PERROR

		j PWHILE

	# in case the program errors, load -1 into a0 and return
	PERROR:
		li a0, -1
		j PEPI

	#end of loop
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

	# setup to ecall, a0 = STDOUT, a1 = buffer (input), a2 = # of bytes to prints (always 1)
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

	# do while loop
	WHILE:
		# get the char out of input
		jal getchar

		# load value for comparison
		lb t1, 0(a0)
		blt t1, zero, ERROR

		# save the value into the return and shift the return by a byte
		sb t1, 0(t0)
		addi t0, t0, 1

		# load the value of '\n' for camparison with t1 if not equal, keep looping
		li t2, 10
		beq t1, t2, DONE
		mv a0, t0
		j WHILE

	# in case the program errors, load -1 into a0 and return
	ERROR:
		mv a0, t1
		j EPI

	# end of loop
	DONE: 
		# shift the return back one to replace the \n with a \0
		addi t0, t0, -1
		li t1, 0
		sb t1, 0(t0)

		# a0 = beginning of return string
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

	# setup to ecall, a0 = STDIN, a1 = buffer (input), a2 = # of bytes to prints (always 1)
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

