.data			
order_A: 	.space		1024			# 1024 bytes -- 256 integers/words
value_A: 	.space		1024

order_B: 	.space		1024
value_B: 	.space		1024

vectSize:	.asciiz		"\nEnter the size of vectors : "
introA:		.asciiz		"\nFirst Vector\n"
introB: 	.asciiz		"\nSecond Vector\n"
input: 		.asciiz		"\nEnter a number : "
resultString:	.asciiz		"\nScalar product of Vectors : "
scalarSign:	.asciiz		" X "
comma:		.asciiz		","
resultOfVectors:.asciiz         "\nResult is : "
orderOfVectors: .asciiz         "\nOrdered Vectors : "
one:            .asciiz         "1"
zero:           .asciiz         "0"
parantez1:      .asciiz         "("
parantez2:      .asciiz         ")"
.text

start:		
		# getting the vector size
		li		$v0, 4			
		la		$a0, vectSize
		syscall

		li		$v0, 5
		syscall

		addi		$a1, $v0, 0		# a1 -- length of each vector	
		
		# read & store vector A
		li		$v0, 4
		la		$a0, introA
		syscall

		addi		$a2, $zero, 0		# a2 -- loop counter			
		addi		$t1, $zero, 0		# t1 -- order_A index in the loop
		addi		$t2, $zero, 0		# t2 -- value_A index in the loop 

		jal		loopA

		# read & store vector B
		li		$v0, 4
		la		$a0, introB
		syscall
	
		addi		$a2, $zero, 0		# a2 -- loop counter		
		addi		$t1, $zero, 0		# t1 -- order_A index in the loop
		addi		$t2, $zero, 0		# t2 -- value_A index in the loop 

		jal		loopB

		# reset
		addi		$a2, $0, 0		# a2 -- loop counter
		addi		$s1, $0, 0		# s1 -- order_A index in the loop
		addi		$s2, $0, 0		# s2 -- value_A index in the loop
		addi		$s5, $0, 0		# s1 -- order_B index in the loop
		addi		$s6, $0, 0		# s2 -- value_B index in the loop
		addi		$a3, $0, 0		# result

		jal		scalarProduct
		
		
		#printing result
		li		$v0, 4			
		la		$a0, resultOfVectors
		syscall
		# display final result
		li		$v0, 1
		addi		$a0, $a3, 0
		syscall
		
		# final result
		li		$v0, 4			
		la		$a0, resultString
		syscall
		
		# display vector A
		addi		$a2, $zero, 0		# a2 -- loop counter		
		addi		$t1, $zero, 0		# t1 -- order_A index in the loop
		addi		$t2, $zero, 0		# t2 -- value_A index in the loop
		
		jal		dispA
		
		li		$v0, 4			
		la		$a0, scalarSign
		syscall
		
		
		
		# display vector B
		addi		$a2, $zero, 0		# a2 -- loop counter		
		addi		$t1, $zero, 0		# t1 -- order_B index in the loop
		addi		$t2, $zero, 0		# t2 -- value_B index in the loop 

		jal		dispB
		
		#Printing the orders
		li             $v0,4
		la $a0,        orderOfVectors
		syscall
		
		jal loopA
		
exit:		
		li		$v0, 10			
		syscall			

.end main

goBack:
		jr		$ra			# goes to the main function
			
loopA:						
		bge		$a2, $a1, goBack	# return if (a2) counter >= (a1) length

		# display message
		li		$v0, 4
		la		$a0, input
		syscall

		# read value
		li		$v0, 5
		syscall

		addi		$a3, $v0, 0		# a3 -- user input
		addi		$a2, $a2, 1		# increment loop counter
	
		beqz		$a3, ifA		# go to ifA if user input = 0 
			
		li		$t4, 1			
		sw		$t4, order_A($t1)	# order_A(pos_$t1) -- holds 1
		sw		$a3, value_A($t2)	# value_A(pos_$t2) -- holds user input

		addi		$t1, $t1, 4		# order_A moves one position
		addi		$t2, $t2, 4		# value_A moves one position						

		j		loopA

ifA:			
		sw		$a3, order_A($t1)	# order_A(pos_$t1) -- holds 0 
		addi		$t1, $t1, 4		# order_A moves one position			
		j		loopA

loopB:						
		bge		$a2, $a1, goBack	# return if (a2) counter >= (a1) length

		# display message
		li		$v0, 4
		la		$a0, input
		syscall

		# read value
		li		$v0, 5
		syscall

		addi		$a3, $v0, 0		# a3 -- user input
		addi		$a2, $a2, 1		# increment loop counter

		beqz		$a3, ifB		# go to ifB if user input = 0

		li		$t4, 1			
		sw		$t4, order_B($t1)	# order_B(pos_$t1) -- holds 1
		sw		$a3, value_B($t2)	# value_B(pos_$t2) -- holds user input

		addi		$t1, $t1, 4		# order_B moves one position
		addi		$t2, $t2, 4		# value_B moves one position						

		j		loopB

ifB:			
		sw		$a3, order_B($t1)	# order_B(pos_$t1) -- holds 0 
		addi		$t1, $t1, 4		# order_B moves one position			
		j		loopB		
						
scalarProduct:	
		bge		$a2, $a1, goBack	# return if (a2) counter >= (a1) length

		lw		$s4, order_A($s1)	# s4 -- order_A(pos_$s1) value
		lw		$s3, order_B($s5)	# s3 -- order_B(pos_$s5) value

		addi		$a2, $a2, 1		# increment loop counter

vecA:			
		beqz		$s4, zeroA		# if order_A = 0 go to zeroA
		 
		lw		$t6, value_A($s2)	# t6 -- vector_A(pos_$t3) value
				
		addi		$s2, $s2, 4		# value_A moves one position
		addi		$s1, $s1, 4		# order_A moves one position
	
		j		vecB			# go to vecB to check its values

zeroA:			
		addi		$t6, $0, 0		# t6 -- holds zero
		addi		$s1, $s1, 4		# order_A moves one position
		
vecB:		
		beqz		$s3, zeroB		# if order_B = 0 go to zeroB

		lw		$t7, value_B($s6)	# t7 -- vector_B(pos_$s6) value
		
		addi		$s6, $s6, 4		# value_B moves one position
		addi		$s5, $s5, 4		# order_B moves one position

		j		solution

zeroB:			
		addi		$t7, $0, 0		# t7 -- holds 0
		addi		$s5, $s5, 4		# order_B moves one position

		j		scalarProduct
		
solution:		
		mul		$t6, $t7, $t6		# t6 -- partial result A*B
		add		$a3, $a3, $t6		# ScalarProduct = SP(An-1,Bn-1) + SP(An,Bn)			

		j		scalarProduct

dispA:	
		bge		$a2, $a1, goBack	# return if (a2) counter >= (a1) length

		addi		$a2, $a2, 1		# increment loop counter

		li		$t4, 1			
		lw		$t4, order_A($t1)	# order_A(pos_$t1) -- holds 1
		lw		$a3, value_A($t2)	# value_A(pos_$t2) -- holds user input
		

		li		$v0, 1			# displays result
		addi		$a0, $a3, 0
		syscall
		
		li		$v0, 4			
		la		$a0, comma
		syscall

		addi		$t1, $t1, 4		# order_A moves one position
		addi		$t2, $t2, 4
		
		j		dispA
		
dispB:	
		bge		$a2, $a1, goBack	# return if (a2) counter >= (a1) length

		addi		$a2, $a2, 1		# increment loop counter

		li		$t4, 1			
		lw		$t4, order_B($t1)	# order_A(pos_$t1) -- holds 1
		lw		$a3, value_B($t2)	# value_A(pos_$t2) -- holds user input

		li		$v0, 1			# displays result
		addi		$a0, $a3, 0
		syscall
		
		li		$v0, 4			
		la		$a0, comma
		syscall

		addi		$t1, $t1, 4		# order_A moves one position
		addi		$t2, $t2, 4
		
		j		dispB
