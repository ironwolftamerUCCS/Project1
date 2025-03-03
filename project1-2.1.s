.globl main 
.equ STDOUT, 1
.equ STDIN, 0
.equ __NR_READ, 63
.equ __NR_WRITE, 64
.equ __NR_EXIT, 93

.text

# V2.1 implements the read_string function

main:
	# main() prolog
	addi sp, sp, -104
	sw ra, 100(sp)

	# main() body

	# Write the prompt to the terminal (stdout)
	# Setup args
	addi  a0, zero, prompt_end - prompt
	la a1, prompt
	# Call write function
	jal write_string

	# Read up to 100 characters from the terminal (stdin)
	# Setup args
	mv a0, sp
	addi a1, zero, 100
	# Call read function
	jal read_string

	# Write the just read characters to the terminal (stdout)
	# Setup args
	# a0 is already properly set. The old line would go from addi a2, a0, 0 to addi a0, a0, 0 but that is redundent 
	mv a1, sp
	# Call write function
	jal write_string

	# main() epilog
	lw ra, 100(sp)
	addi sp, sp, 104
	ret
	
write_string:
    mv a2, a0
    li a7, __NR_WRITE
    li a0, STDOUT
    ecall 
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
