.text
main:
	lw $s0, 0($a1)		#load the title
	lw $t0, ($a1)
	li $v0 4		#"you entered:"
	la $a0, filename
	syscall
	li $v0 11		#nextline
	la $a0, 0xA
	syscall

	li $v0, 4
	move $a0, $s0
	syscall

	li $v0 11		#nextline
	la $a0, 0xA
	syscall
	li $v0 11		
	la $a0, 0xA
	syscall
	
	lw $s0, 0($a1)		#load first data to determine whether invalid
	la $s1, letter
	lb $t1, ($s0)
	sb $t1, ($s1)

uppercase:
	blt $t1 ,0x41, fail1  #check if it is a uppercase letter
	
	bgt  $t1, 0x5A, lowercase
lowercase:
	blt $t1 ,0x61, fail1  #check if it is a lowercase letter
	
	bgt   $t1, 0x7A, fail1
	j length
length:				#it could the last number
	lw $s0, ($a1)
	la $s1, letter

nameloop:			#find the length
	lb $t1, ($s0)
	add $s0, $s0, 1
	sub $s1, $s1,1
	sb $t1, ($s1)
	beq $t1, 0, loopdone
	add $t9, $t9, 1
	j nameloop
loopdone:			#if it's longer than 20 fail
	bge  $t9, 20, fail1

	j checkstart
	
checkstart:				#start checking the braces
	li $v0 13			#open file
	la $a0, ($t0)
	li $a1, 0
	li $a2, 0
	syscall
	move $t0, $v0
	addi $t2, $zero, -1		#index
readingfile:	
	li $v0 14			#read file
	la $a0, ($t0)
	la $a1, buffer			#setting the buffer
	li $a2, 128		
	syscall
	
	la $s6, buffer			#load buffer
	
checkloop:
	
	lb $s1, ($s6)			#buffer input
	addi $s6, $s6, 1		
	addi $t2, $t2, 1
	lw $s7, 0($sp)			#set s7 to be the first on the stack	
	beq $s1,0x28, isopen		#checking if it's open or close braces
	beq $s1,0x5B, isopen
	beq $s1,0x7B, isopen
	beq $s1,0x29, isclose1
	beq $s1,0x5D, isclose2
	beq $s1,0x7D, isclose3
	beq $t2,127, readingfile	#if the buffer is 127, it would read the file again
	beq $s1,0x0, finish
	j checkloop	
isopen:					#when it is open brace, it would push to the stack
			
	sw $s1,($sp)
	addi $sp, $sp, -4
	addi $t3, $t3, 1
	j checkloop

isclose1:				#when it's close brace,it will find whatever ther is a open brace for it
	addi $sp, $sp, 4
	lw $s4,($sp)
	addi $t5, $t5, 1
	beq $s4,0x28,popout
	beq $s4,0x0,fail2
	
	
	j isclose1
isclose2:
	addi $sp, $sp, 4
	lw $s4,($sp)
	addi $t5, $t5, 1
	beq $s4,0x5B,popout
	beq $s4,0x0,fail2
	
	
	j isclose2
isclose3:
	addi $sp, $sp, 4
	lw $s4,($sp)
	addi $t5, $t5, 1
	beq $s4,0x7B,popout
	beq $s4,0x0,fail2
	
	
	j isclose3
	
popout:					#popout the open brace for the pair
	subi $t3,$t3, 1
	sw $t2,($sp)
	addi $t6, $t6, 1
	j return
return:					#return to the current sp
	addi $sp, $sp, -4
	subi $t5, $t5, 1
	beqz  $t5, checkloop
	j return
finish:					#check if there is more open braces
	
	bgtz $t3, fail3
	j success
	
fail1:					#invail messsage
	li $v0 4
	la $a0, fmessage1
	syscall
	j exit
fail2:					#fail messsage for mismatch
	li $v0, 4
	la $a0, fmessage2
	syscall
	li $v0 11
	la $a0, ($s1)
	syscall
	li $v0 4
	la $a0, fmessage2_1
	syscall
	li $v0 1
	la $a0, ($t2)
	syscall
	j exit	
		
		
fail3:					#if there is more open braces on the stack, print out all of it.
	li $v0 4
	la $a0, fmessage3
	syscall
	addi $sp, $sp, 4
	check3:
		lw $s3, ($sp)
		beq $s3,0x28, print
		beq $s3,0x5B, print
		beq $s3,0x7B, print
		
		beq $s3,0x0, exit
		addi $sp, $sp, 4
		j check3
	print:
		li $v0 11
		la $a0, ($s3)
		syscall
		addi $sp,$sp,4
		j check3
success:				#sucess with how many pairs of braces
	li $v0, 4
	la $a0, smessage1
	syscall
	li $v0, 1
	la $a0, ($t6)
	syscall
	li $v0, 4
	la $a0, smessage2
	syscall
	j exit	
		
exit:			#close the file
	li $v0, 16         	
    	move $a0,$t0      		
    	syscall
    	li $v0 11		
	la $a0, 0xA
	syscall
	li $v0, 10
	syscall
	
	
	
	

.data
	letter: .space 4
	buffer: .space 128
	fmessage1: .asciiz "ERROR: Invalid program argument."
	filename: .asciiz "You entered the file:"
	smessage1: .asciiz "SUCCESS: There are "
	smessage2: .asciiz " pairs of braces."
	fmessage2: .asciiz "ERROR - There is a brace mismatch: "
	fmessage2_1: .asciiz " at index "
	fmessage3: .asciiz "ERROR - Brace(s) still on stack: "
	array: .space 1024
	
