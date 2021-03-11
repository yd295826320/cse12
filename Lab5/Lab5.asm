# Winter 2021 CSE12 Lab5 Template
######################################################
# Macros for instructor use (you shouldn't need these)
######################################################

# Macro that stores the value in %reg on the stack 
#	and moves the stack pointer.
.macro push(%reg)
	subi $sp $sp 4
	sw %reg 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#	loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg 0($sp)
	addi $sp $sp 4	
.end_macro

#################################################
# Macros for you to fill in (you will need these)
#################################################

# Macro that takes as input coordinates in the format
#	(0x00XX00YY) and returns x and y separately.
# args: 
#	%input: register containing 0x00XX00YY
#	%x: register to store 0x000000XX in
#	%y: register to store 0x000000YY in
.macro getCoordinates(%input %x %y)
	# YOUR CODE HERE		
	srl %x, %input, 16		# x=input<<16
	and %x, %x, 0x00FF		# clean x
	and %y, %input, 0x00FF		# y=input's last 8 bit
.end_macro

# Macro that takes Coordinates in (%x,%y) where
#	%x = 0x000000XX and %y= 0x000000YY and
#	returns %output = (0x00XX00YY)
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store 0x00XX00YY in
.macro formatCoordinates(%output %x %y)
	# YOUR CODE HERE
	and %x, %x, 0x00FF			# clean x
	and %y, %y, 0x00FF			# clean y
	sll %output, %x, 16			# output = x<<16
	add %output, %output, %y		# output+=y
.end_macro 

# Macro that converts pixel coordinate to address
# 	output = origin + 4 * (x + 128 * y)
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%origin: register containing address of (0, 0)
#	%output: register to store memory address in
.macro getPixelAddress(%output %x %y %origin)
	# YOUR CODE HERE
	mul %y, %y, 128				#y * 128
	add %x, %x, %y				#x + y * 128
	mul %x, %x, 4				#4 * (x + y * 128)
	add %output, %origin, %x		#output = origin + 4 * (x + 128 * y)
.end_macro


.data
originAddress: .word 0xFFFF0000

.text
# prevent this file from being run as main
li $v0 10 
syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
# Clear_bitmap: Given a color, will fill the bitmap 
#	display with that color.
# -----------------------------------------------------
# Inputs:
#	$a0 = Color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
clear_bitmap: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	li $t0,0					# Loop:
	lw $t0, originAddress				# t0=originAddress
	cleanLabel1:
	sw $a0, ($t0)					# [t0]=a0
	beq $t0, 0xfffffffc, cleanLabel2		# if t0==0xfffffffc:
	addi $t0, $t0, 4				# t0+=4
	j cleanLabel1
	cleanLabel2:	
	jr $ra

#*****************************************************
# draw_pixel: Given a coordinate in $a0, sets corresponding 
#	value in memory to the color given by $a1
# -----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#		$a1 = color of pixel in format (0x00RRGGBB)
#	Outputs:
#		No register outputs
#*****************************************************
draw_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	getCoordinates($a0, $t1, $t2)# x, y		# divide a0 into x and y
	mul $t2, $t2, 128				# p=y*128+x
	add $t2, $t1, $t2				# p=y*128+x
	mul $t2, $t2, 4
	addi $t2, $t2, 0xFFFF0000			# p=p+0xFFFF0000
	sw $a1, ($t2)					# [p]=a1
	jr $ra
	
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#	Outputs:
#		Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
get_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	getCoordinates($a0, $t1, $t2)# x, y		# divide a0 into x and y
	mul $t2, $t2, 128				# p=y*128+x
	add $t2, $t1, $t2
	mul $t2, $t2, 4					# p=p*4
	addi $t2, $t2, 0xFFFF0000			# p=p+0xFFFF0000
	lw $v0, ($t2)					# v0=[p]
	jr $ra

#*****************************************************
# draw_horizontal_line: Draws a horizontal line
# ----------------------------------------------------
# Inputs:
#	$a0 = y-coordinate in format (0x000000YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_horizontal_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push $ra					#push ra
	li $t0, 0					#set index
	lw $t3, originAddress				#load address to t3
	move $t5, $a0					#move the y-coordinate
	loop:						#loop
		beq $t0, 128, exit			#if it reach 128 pixel exit
		formatCoordinates($a0 $t0 $t5)		#form the address to 0x00XX00YY
		jal draw_pixel				#draw pixel
		
		addi $t0, $t0, 1			#move to next
		j loop
 	exit:
 	pop $ra						#pop ra
 	jr $ra


#*****************************************************
# draw_vertical_line: Draws a vertical line
# ----------------------------------------------------
# Inputs:
#	$a0 = x-coordinate in format (0x000000XX)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_vertical_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push $ra					#push ra
	li $t0, 0					#set index
	lw $t3, originAddress				#load address to t3
	move $t5, $a0					#move the y-coordinate
	loop1:						#loop
		beq $t0, 128, exit1			#if it reach 128 pixel exit
		formatCoordinates($a0 $t5 $t0)		#form the address to 0x00XX00YY
		jal draw_pixel				#draw pixel
		
		addi $t0, $t0, 1			#move to next
		j loop1
 	exit1:
 	pop $ra						#pop ra
 	jr $ra



#*****************************************************
# draw_crosshair: Draws a horizontal and a vertical 
#	line of given color which intersect at given (x, y).
#	The pixel at (x, y) should be the same color before 
#	and after running this function.
# -----------------------------------------------------
# Inputs:
#	$a0 = (x, y) coords of intersection in format (0x00XX00YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_crosshair: nop
	push($ra)
	push($s0)
	push($s1)
	push($s2)
	push($s3)
	push($s4)
	push($s5)
	move $s5 $sp

	move $s0 $a0  # store 0x00XX00YY in s0
	move $s1 $a1  # store 0x00RRGGBB in s1
	getCoordinates($a0 $s2 $s3)  # store x and y in s2 and s3 respectively
	
	# get current color of pixel at the intersection, store it in s4
	# YOUR CODE HERE, only use the s0-s4 registers (and a, v where appropriate)
	move $a0, $s0									#move the the address
	jal get_pixel									#get pixel color
	move $s4, $v0									#store color in s4
	# draw horizontal line (by calling your `draw_horizontal_line`) function
	# YOUR CODE HERE, only use the s0-s4 registers (and a, v where appropriate)
	
	move $a0, $s3									#set the y-coordinate
	move $a1, $s1									#set the color
	jal draw_horizontal_line							# draw horizontal line
	
	# draw vertical line (by calling your `draw_vertical_line`) function
	# YOUR CODE HERE, only use the s0-s4 registers (and a, v where appropriate)
	
	move $a0, $s2									#set the x-coordinate
	move $a1, $s1									#set the color
	jal draw_vertical_line								#draw vertical line
	
	# restore pixel at the intersection to its previous color
	# YOUR CODE HERE, only use the s0-s4 registers (and a, v where appropriate)
	move $a0, $s0									#move the address
	move $a1, $s4									#move the color
	jal draw_pixel									#draw the pixel
	
	move $sp $s5
	pop($s5)
	pop($s4)
	pop($s3)
	pop($s2)
	pop($s1)
	pop($s0)
	pop($ra)
	jr $ra
