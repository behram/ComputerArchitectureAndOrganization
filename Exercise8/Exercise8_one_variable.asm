.data	
	number:.word 3

.text
main:	
	lw	$t0,number
	addi	$a0,$zero,1

ForLoop:	
	beq 	$t0,$zero,Finish
	mult	$a0,$t0
	mflo	$a0
	addi	$t0,$t0,-1
	j	ForLoop

Finish:
	li	$v0, 1
	syscall

	li	$v0, 10
	syscall
