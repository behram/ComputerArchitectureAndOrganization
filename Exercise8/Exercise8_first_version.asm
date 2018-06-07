.data	
	number1: .word	1
	printNumber:.word 1
	errorNumber: .word 10
	number:.word 5

.text
main:	
	lw	$t1,number
	addi	$a0,$zero,1
	addi	$t2,$zero,1
ForLoop:	
	bgt 	$t2,$t1,Finish
	mult	$a0,$t2
	mflo	$a0
	addi	$t2,$t2,1
	j	ForLoop
Finish:	
	lw	$v0, printNumber
	syscall
	lw	$v0, errorNumber
	syscall
