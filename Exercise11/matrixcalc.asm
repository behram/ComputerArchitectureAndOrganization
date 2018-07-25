.text                   # Indicate that everything below is code
        .globl  main            # The entry point is called main

main:   la      $t0, DIMSQ      # Load the address of DIM*DIM
        lbu     $t0, 0($t0)     # Load the value of [DIM*DIM], re-use $t0
        la      $t1, DIM        # Load the address of DIM
        lbu     $t1, 0($t1)     # Load the value of [DIM], re-use $t1

# Capture the first matrix element by element

        la      $a0, msg1       # Load the string address
        la      $a1, MATA       # Load the address of A[0]
        add     $a2, $a1, $t0   # Check dimension + base address
        jal     input           # Call the capture subroutine

# Capture the second matrix element by element

        la      $a0, msg2       # Load the string address
        la      $a1, MATB       # Load the address of B[0]
        add     $a2, $a1, $t0   # Check dimension + base address
        jal     input           # Call the capture subroutine

# Perform the sum of Matrix A + Matrix B

        xor     $t2, $t2, $t2   # i = 0
fori:   xor     $t3, $t3, $t3   # j = 0
forj:   mul     $t4, $t1, $t3   # temp = DIM * j
        add     $t4, $t4, $t2   # temp = j * DIM + i
        la      $t5, MATA        # Load the address of A[0]
        add     $t5, $t5, $t4   # temp += Address of A[0]
        lbu     $t6, 0($t5)   # Load A[temp]
        lbu     $t7, 9($t5)   # Load B[temp]
        add     $t6, $t6, $t7   # C[temp] = A[temp] + B[temp]
        sb      $t6, 18($t5)      # Store C[temp]
        addi    $t3, $t3, 1     # j++
        bne     $t3, $t1, forj  # j < DIM? goto forj
        addi    $t2, $t2, 1     # i++
        bne     $t2, $t1, fori  # i < DIM? goto fori

# Now display the result

        la      $t1, MATC   # Load the address of C[0]
        add     $t2, $t0, $t1   # Add dimension to the base address

out:    li      $v0,4           # mesg1 asking for Matrix B element
        la      $a0, msg3
        syscall

        lbu     $a0, 0($t1)     # load the result
        li      $v0,1           # system call that prints an integer
        syscall 

        li      $v0,4           # prints a '\n'
        la      $a0, cr
        syscall

        addi    $t1, $t1, 1     # increment index pointer
        bne     $t2, $t1, out   # i < DIM?

        li      $v0,10          # system call 10, exit
        syscall

input:  move    $s0, $a0        # Store the address of the original string
        li      $v0,4           # Call the print string system call
        syscall                 # $a0 is already loaded

        li      $v0,5           # system call that reads an integer
        syscall 

        bgtz    $v0, validA     # check if the input is greater than zero

        li      $v0,4           #let user know something was not OK
        la      $a0, error
        syscall

        move    $a0, $s0        # restore the original string
        j       input           # not valid ask for the number again

validA: 
        sb      $v0, 0($a1)     # store value for matrix A
        addi    $a1, $a1, 1     # increment index pointer
        bne     $a2, $a1, input

        jr      $ra             # return to the caller

#
# These are the space allocations for the three matrices (9 elements each)
# and their dimensions (3 x 3)
#
        .data
MATA:   .space 9
MATB:   .space 9
MATC:   .space 9
DIMSQ:  .byte 09
DIM:    .byte 03

msg1:   .asciiz "Enter Matrix A element (positive number):  "
msg2:   .asciiz "Enter Matrix B element (positive number):  "
msg3:   .asciiz "Result element:  "
error:  .asciiz "Error, the number must be positive\n"
cr:     .asciiz "\n"