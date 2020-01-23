.data
	msg: .asciiz	"Two decimal numbers p and q. "
	newline: .asciiz   "\n"
	recur_msg: .asciiz "Output for recursive: "
	ans_msg: .asciiz "Output for answer: "
	#sum_msg: .asciiz	"Summation: "
.text

.globl main

main:		li	$v0, 4
		la	$a0, msg
		syscall 
		
		li	$v0, 4
		la	$a0, newline
		syscall 
	
		li	$v0, 5# s0 for p
		syscall 
		add $s0, $v0, $zero
	
		li	$v0, 5# s1 for q
		syscall 
		add $s1, $v0, $zero
		
		slt	$t1, $s0, $s1
		bne	$t1, $zero, continue_1
		add	$t2, $s1, $zero
		add	$s1, $s0, $zero
		add	$s0, $t2, $zero

continue_1:	li	$v0, 4
		la	$a0, newline
		syscall
	
		add $s2, $zero, $zero	#$s2 for Sum
		add $s3, $zero, $zero	#$s3 for Final Sum
	
mainloop:	bgt 	$s0, $s1, display

		 # Call the function
    		add     $a0, $s0, $zero
    		jal     recur
    		add     $s2, $v0, $zero
		add	$s3, $s3, $s2
	
		addi 	$s0, $s0, 1	#p += 1 
		
		j mainloop

recur:		addi    $sp,$sp,-16
    		sw      $a0,0($sp)
    		sw      $ra,4($sp)
    		sw      $s1,8($sp)
    		sw      $s2,12($sp)
    		
    		# Base Case  if( n == 0 ) return 0;
    		li      $v0,0
    		beq     $a0,$zero,recur_done
    		
    		# Base Case  if(n % 10) > 0 return n % 10;
    		li	$s2, 10
    		div	$a0, $s2
    		mfhi	$v0
    		#add	$v0, $s0, $zero
    		slt	$s1, $v0, $zero
    		beq	$s1, $zero, continue
    		#sub	$v0, $zero, $v0
    		
continue:    	bgt 	$v0, $zero, recur_done
    		
    		# RECURSIVE STEP
    		#li	$s2, 10
    		#div    	$a0, $s2          # n / 10
    		mflo	$a0
    		#add	$a0, $s2, $zero
    		jal     recur
    		#lw      $a0,0($sp)        # we need "n" back
    		    		
    		

recur_done:    	lw      $a0,0($sp)
    		lw      $ra,4($sp)
    		lw      $s1,8($sp)
    		lw      $s2,12($sp)
    		addi    $sp,$sp,16
    		jr      $ra    				

	
display:	li	$v0, 4
		la	$a0, ans_msg
		syscall 
		
		li	$v0, 1
		move	$a0, $s3
		syscall 

		
		li	$v0, 4
		la	$a0, newline
		syscall 	
