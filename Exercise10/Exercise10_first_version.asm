			
.data
			
inputArray:	.space		200
	
askLength:	.asciiz		"Enter the length of array: \n"
askElements:	.asciiz		"Enter elements of array (press enter): \n"
originArr:	.asciiz		"Original Array: "
finalArr:	.asciiz		"Sorted Array: "
	
space:		.asciiz		" "
newLine:	.asciiz		"\n"
	
			.text
			
theMaster:		#responsible for communication with the user - input and output of the program
		la	$a0, askLength
		li	$v0, 4
		syscall
		
		li	$v0, 5
		syscall
		
		addu	$t0, $zero, $v0			# t0 -- array length
		
		la	$a0, askElements
		li	$v0, 4
		syscall
		
		li	$t1, 0				# t1 -- counter
		la	$t3, inputArray			# t3 -- inputArray address

userLoop:
		bge	$t1, $t0, userLoopEND 		# if (counter >= array length) -> end
		
		li	$v0, 5 				# gets value from user
		syscall
		
		sll	$t2, $t1, 2			# shift left counter t1^2; t2 -- index of new counter
		addu	$t2, $t2, $t3 			# add t2 to the addres of inputArray 
		sw	$v0, 0($t2)			# t2 -- stores value at that pos
		
		addi	$t1, $t1, 1 			# increment counter
		j	userLoop
		
userLoopEND:						# input the original array on console
		li	$v0, 4
		la	$a0, originArr
		syscall
		
		li	$t1, 0				# resets counter
	
dispOrigin:
		bge 	$t1, $t0, dispOriginEND		# if (counter >= array length) -> end
	
		sll 	$t4, $t1, 2			# shift left counter t1^2; t4 -- index of new counter
		addu 	$t4, $t4, $t3			# add t4 to the address of inputArray
		lw 	$t4, 0($t4)			# load value at pos t4
		
		li 	$v0, 1					
		addu 	$a0, $t4, $zero			# print number at pos t4
		syscall
		
		li 	$v0, 4				
		la 	$a0, space
		syscall
		
		addi 	$t1, $t1, 1			# increment counter
		j	dispOrigin

dispOriginEND:
		jal	bubbleSort	
		
		li	$v0, 4
		la	$a0, newLine
		syscall
		la	$a0, finalArr
		syscall
		
		li	$t1, 0
		
dispFinal:
		bge 	$t1, $t0, dispFinalEND
	
		sll 	$t4, $t1, 2
		addu 	$t4, $t4, $t3
		lw 	$t4, 0($t4)
		
		li 	$v0, 1
		addu	$a0, $t4, $zero
		syscall
		
		li 	$v0, 4
		la 	$a0, space
		syscall
		
		addi 	$t1, $t1, 1
		j	dispFinal
	
dispFinalEND:
		li $v0, 10
		syscall		  		
		 		 			
.end main

bubbleSort:
		# t3 -- array,	t0 -- length
		
		addu	$t1, $t0, $zero 		# t1 -- holds length
		subi	$t1, $t1, 1			# t1 = t1 - 1 
		
loop1:
		li	$t2, 0					
	
loop2:
		addi	$t5, $t2, 1			# t5 -- incremented counter
	
		sll	$t4, $t2, 2			# t4 -- left shift of counter t2^2
		sll	$t5, $t5, 2			# left shift of t5
		
		addu	$t4, $t4, $t3			# add counter & address of inputArray in t4 
		addu	$t5, $t5, $t3			# add counter & address of inputArray in t5
		lw	$t6, 0($t4)			# t6 -- value at pos t4
		lw	$t7, 0($t5)			# t7 -- value at pos t5
		
		blt	$t6, $t7, noSwap 		# if (t6 <= t7) -> don't swap -- branch if less than
		
		sw	$t6, 0($t5)			# t6 -- value at pos t5 (copy)
		sw	$t7, 0($t4)					# sw saves a word from register into ram
		
noSwap:
		addi	$t2, $t2, 1			# increment counter
		blt	$t2, $t1, loop2			# if (counter <= length) -1 -> loop2
	
		subi	$t1, $t1, 1			# save reduced size 
		bge	$t1, $zero, loop1		# if (size >= zero) -> loop1
		
		jr	$ra
		
