main:
	
	li	$v0,4
	la	$a0, msg1	
	syscall

	
	li	$v0,5		
	syscall	
	move	$t0,$v0		

	
	li	$v0,4		
	la	$a0, msg2	
	syscall

	
	li	$v0,5		
	syscall	
	#move	$t0,$v0		

	# Math
	sub	$t0, $t0, $v0	# A = A - B


	
	li	$v0,4		
	la	$a0, msg3	
	syscall

	
	li	$v0,5		
	syscall	
	sub	$t0,$t0,$v0		

	
	li	$v0,4		
	la	$a0, msg4	
	syscall

	
	li	$v0,5		
	syscall	
	add	$t0,$v0,$t0	

	
	li	$v0, 4
	la	$a0, msg5
	syscall

	
	li	$v0,1		
	move	$a0, $t0	
	syscall

	
	li	$v0,4		
	la	$a0, newline
	syscall

	li	$v0,10		# exit
	syscall

	# Start .data segment (data!)
	.data
msg1:	.asciiz	"Enter A:   "
msg2:	.asciiz	"Enter B:   "
msg3:	.asciiz	"Enter C:   "
msg4:	.asciiz	"Enter D:   "
msg5:	.asciiz	"(A + B) - (C - D) = "
newline:   .asciiz	"\n"