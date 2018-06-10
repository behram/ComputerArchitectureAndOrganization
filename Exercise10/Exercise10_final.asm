.data			
	lengthQuestion:	.asciiz		"Enter the length of array: \n"
	askElements:	.asciiz		"Enter elements of array (press enter): \n"
	originArr:		.asciiz		"Original Array: "
	finalArr:		.asciiz		"Sorted Array: "
	ascOrDesc:		.asciiz		"ASC (1) or DESC (0): "
	space:			.asciiz		" "
	newLine:		.asciiz		"\n"

.text		
main:
	la	$a0, lengthQuestion
	li	$v0, 4
	syscall

	li	$v0, 5
	syscall

	addu	$t0, $zero, $v0			# length

	la	$a0, askElements
	li	$v0, 4
	syscall

	li $t1,4
    li      $v0,9             # allocate memory
    mult	$t0,$t1
    mflo	$a0	
    syscall                   # $v0 <-- address
    move    $t3,$v0     

	li	$t1, 0				# counter

userLoop:
	bge	$t1, $t0, userLoopEND 		# if (counter >= array length) -> end
	
	li	$v0, 5 				# user value
	syscall
	
	sll	$t2, $t1, 2			# shift left counter t1^2; t2 -- index of new counter
	addu	$t2, $t2, $t3 	# add t2 to the addres of inputArray 
	sw	$v0, 0($t2)			# t2 -- store value at position
	
	addi	$t1, $t1, 1 			# counter
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
	addu 	$a0, $t4, $zero			# print number
	syscall
	
	li 	$v0, 4				
	la 	$a0, space
	syscall
	
	addi 	$t1, $t1, 1
	j	dispOrigin

dispOriginEND:
	li	$v0, 4
	la	$a0, newLine
	syscall

	li	$v0, 4
	la	$a0, ascOrDesc
	syscall

	li	$v0, 5
	syscall

	addu	$s0, $zero, $v0			# length

	jal	bubbleSort	

	li	$v0, 4
	la	$a0, finalArr
	syscall
	
	li	$t1, 0
	

displayScreen:
	bge 	$t1, $t0, exit

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
	j	displayScreen

exit:
	li $v0, 10
	syscall		  		
		 		 			
.end main

bubbleSort:
	addu	$t1, $t0, $zero 		#holds length
	subi	$t1, $t1, 1			# t1 = t1 - 1 
		
Check1:
	li	$t2, 0					
	
Check2:
	addi	$t5, $t2, 1			# t5 -- incremented counter

	sll	$t4, $t2, 2			# t4 -- left shift of counter t2^2
	sll	$t5, $t5, 2			# left shift of t5
	
	addu	$t4, $t4, $t3			# add counter & address of inputArray in t4 
	addu	$t5, $t5, $t3			# add counter & address of inputArray in t5
	lw	$t6, 0($t4)			# t6 -- value at pos t4
	lw	$t7, 0($t5)			# t7 -- value at pos t5
	
	beq $s0, $zero, sortDesc
	j sortAsc

sortDesc:
	bgt	$t6, $t7, noSwap 		# if (t6 < t7) -> don't swap -- branch if less than
	
	sw	$t6, 0($t5)			# t6 -- value at pos t5 (copy)
	sw	$t7, 0($t4)					# sw saves a word from register into ram

sortAsc:
	blt	$t6, $t7, noSwap 		# if (t6 < t7) -> don't swap -- branch if less than
	
	sw	$t6, 0($t5)			# t6 -- value at pos t5 (copy)
	sw	$t7, 0($t4)					# sw saves a word from register into ram

		
noSwap:
	addi	$t2, $t2, 1			# increment counter
	blt	$t2, $t1, Check2			# if (counter <= length) -1 -> Check2

	subi	$t1, $t1, 1			# save reduced size 
	bge	$t1, $zero, Check1		# if (size >= zero) -> Check1
	
	jr	$ra
