.data	
	number: .word 6
	msg1:	.asciiz	"Enter n:   "
	msg2:	.asciiz	"n factorial equals to:   "
	msg3:	.asciiz	"\nn power 2 equals to:   "
	newline:   .asciiz	"\n"

.text
main:	
	li	$v0,4
	la	$a0, msg1
	syscall

	li	$v0,5
	syscall	
	move	$t1,$v0

	li	$v0,4
	la	$a0, msg2
	syscall

	addi	$a0,$zero,1
	addi	$a1,$zero,1
	addi	$t2,$zero,1
	addi	$t4,$zero,1
	addi	$t3,$zero,2

Factorial:	
	bgt 	$t2,$t1,Expose
	mult	$a0,$t2
	mflo	$a0
	addi	$t2,$t2,1
	j	Factorial

Expose:
	li	$v0, 1
	syscall

	li	$v0,4
	la	$a0, msg3
	syscall
	
	j Power

Power:
	bgt 	$t4,$t1,Expose2
	mult	$a1,$t3
	mflo	$a1
	addi	$t4,$t4,1
	j	Power

Expose2:
	li $v0, 1
	move $a0, $a1
	syscall
	
	li	$v0,10		# exit
	syscall
