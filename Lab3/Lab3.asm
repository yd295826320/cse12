.data
	message: .asciiz "Enter the height of the pattern (must be greater than 0): "
	message2: .asciiz "Invalid entry! "
.text
main:
	li $v0, 4
	la $a0, message
	syscall 
	li $v0, 5
	syscall 
	move $t0, $v0
	
	blez $t0, wmessage2
	
	addi $t7, $t7, 0
	
loop1: 
	addi $t7, $t7, 1
	subi $t1, $t7, 1
	mul $t2, $t1, 1
	
	j loop2
loop2:
	bgtz $t1, print1
	beqz $t1, print
print:
	li $v0, 1
	la $a0, ($t7)
	syscall
	j loop3
loop3:
	
	bgtz $t2, print2
	beqz $t2, loop4
	
loop4:
	
	li $v0 11
	la $a0, 0xA
	syscall
	beq $t7, $t0, exit
	j loop1

print2: 
	li $v0, 11
	la $a0, 0x9
	syscall
	li $v0, 11
	la $a0, 0x2A
	syscall 
	subi $t2, $t2, 1
	j loop3

print1:
	li $v0, 11
	la $a0, 0x2A
	syscall
	li $v0, 11
	la $a0, 0x9
	syscall 
	subi $t1, $t1, 1
	j loop2
wmessage2:
	li $v0 4
	la $a0, message2
	syscall
	li $v0 11
	la $a0, 0xA
	syscall
	j main
	
exit:
	li $v0, 11
	la $a0, 0xA
	syscall 
	li $v0, 10
	syscall 