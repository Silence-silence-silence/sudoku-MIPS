# Haoting Ni
# haotinn
.data
newline: .asciiz "\n"
.text

##########################################
#  Part #1 Functions
##########################################
setWinBoard:
	# insert code here
	addi $sp,$sp,-28
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $s4,20($sp)
	sw $s5,24($sp)
	
	srl $s0,$a0,8 #byte1
	sll $s1,$a0,24
	srl $s1,$s1,24 #byte0
	
	li $s2,0
	li $s3,0
	li $s4,1
	li $s5,1

	hor_loop:
	bge $s2,9,done_hor
	li $a0,4
	move $a1,$s2
	li $a2,-1
	move $a3,$s0
	jal setCell
	addi $s2,$s2,1
	j hor_loop
	
	done_hor:
	bge $s3,9, done_ver
	move $a0,$s3
	li $a1,4
	li $a2,-1
	move $a3,$s0
	jal setCell

	addi $s3,$s3,1
	j done_hor
	
	done_ver:
	bgt $s4,7,done_lr
	beq $s4,4,skip_lr
	move $a0,$s4
	move $a1,$s5
	li $a2,-1
	move $a3,$s1
	jal setCell
	
	skip_lr:
	addi $s4,$s4,1
	addi $s5,$s5,1
	
	j done_ver
	
	done_lr:
	li $s4,1
	li $s5,7
	
	rl_loop:
	bgt $s4,7 done_rl
	beq $s4,4,skip_rl
	
	move $a0,$s4
	move $a1,$s5
	li $a2,-1
	move $a3,$s1
	jal setCell
	
	skip_rl:
	addi $s4,$s4,1
	addi $s5,$s5,-1
	
	j rl_loop
	
	done_rl:
		
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $s4,20($sp)
	lw $s5,24($sp)
	addi $sp,$sp,28
	
	jr $ra

saveBoard:
	# insert code here
	addi $sp,$sp,-36
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $s4,20($sp)
	sw $s5,24($sp)
	sw $s6,28($sp)
	sw $s7,32($sp)
	
	move $s0,$a0
	move $s6,$a1
	
	li $s7,0 #file des
	li $s2,0 #i
	li $s3,0 #j
	li $s4,0 #no pc
	li $s5,0 #no gc
	
	 li $v0,13
   	 li $a1,9
    	li $a2,0
   	 move $a0,$s0
   	 syscall
   	 
   	 blt $v0,0,save_Error
   	 
   	 move $s7,$v0
   	 
   	 i_save_loop:
   	 bge $s2,9,done_i_save
   	 li $s3,0
   	 	j_save_loop:
   	 	bge $s3,9,done_j_save
   	 	move $a0,$s2
   	 	move $a1,$s3
   	 	jal getCell
   	 	
   	 	beq $v1,0,skip_output
   	 	move $t0,$v0 #color
		move $s1,$v1
		
		li $v0, 9
		li $a0, 5   
		syscall
		move $s0, $v0

		addi $s0, $s0, 5   
		

	
		sll $t1,$s6,20
   	 	srl $t1,$t1,28 #pc
   	 	
   	 	sll $t2,$s6,28 #gc
   	 	srl $t2,$t2,28
   	 	
   	 	
		sll $t4,$t0,28
		srl $t4,$t4,28 #fg
		

   	 	beq $t4,$t1,pccc
   	 	beq $t4,$t2,gccc
   	 	
   	 	j save_Error
   	 	pccc:
   	 	addi $s4,$s4,1
   
  		li $t3, 80      # p
		sb $t3, 0($s0)
		addi $s0, $s0, -1
		
			 	
	
    		j skip_gcccc
    		
    			 	
    		
    		gccc:
    		addi $s5,$s5,1
    		
    		li $t3, 71      # g
		sb $t3, 0($s0)
		addi $s0, $s0, -1
		
	
		
		
		skip_gcccc:
		
		move $t3,$s1 
		addi $t3,$t3 ,48      #int
		sb $t3, 0($s0)
		addi $s0, $s0, -1
		
		
		addi $t3,$s3 ,65
		sb $t3, 0($s0)
		addi $s0, $s0, -1   

		addi $t3,$s2 ,48
		sb $t3, 0($s0)
		addi $s0, $s0, -1

		li   $v0, 15       # system call for write to file
		move $a0, $s7      # file descriptor 
		move $a1, $s0      # address of buffer from which to write
		li   $a2, 5        # hardcoded buffer length
		syscall            # write to file
		blt $v0,0,save_Error
		li   $v0, 15       # system call for write to file
		move $a0, $s7      # file descriptor 
		la $a1, newline      # address of buffer from which to write
		li   $a2, 1        # hardcoded buffer length
		syscall            # write to file
   	 	
   	 	blt $v0,0,save_Error
   	 	skip_output:
   	 	addi $s3,$s3,1
   	 	j j_save_loop
   	 	
   	 	done_j_save:
   	 	addi $s2,$s2,1
   	 	j i_save_loop
   	 
   	 
   	 
   	 done_i_save:
   	 
   	 move $a0,$s7
   	 li $v0,16
   	 syscall
   	 blt $v0,0,save_Error
   	 
	move $v0,$s4
	move $v1,$s5

   	
   	 lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $s4,20($sp)
	lw $s5,24($sp)
	lw $s6,28($sp)
	lw $s7,32($sp)
	addi $sp,$sp,36

	jr $ra
	
	save_Error:
	
	li $v0,-1
	li $v1,-1

   	
   	 lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $s4,20($sp)
	lw $s5,24($sp)
	lw $s6,28($sp)
	lw $s7,32($sp)
	addi $sp,$sp,36

	jr $ra
hint:
	# insert code here
    	addi $sp,$sp,-36
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $s4,20($sp)
	sw $s5,24($sp)
	sw $s6,28($sp)
	sw $s7,32($sp)
	
    	move $s0,$a0 #move
    	move $s1,$a1 #ccolor
    	li $s6,8
    	li $s7,0
    	move $a0,$s0
    	li $a1,0
    	jal getBoardInfo
    	move $s2,$v0 #row
    	move $s3,$v1 #column
    	
    	move $a0,$s0
    	li $a1,1
    	jal getBoardInfo
    	move $s4,$v0 #value
    	
    		

   	 beq $v1,80,invalid_preset
   	 move $a0,$s2
   	 move $a0,$s2
	move $a1,$s3
	move $a2,$s4
	li $a3,0xa0
	li $t0,0
	
	lw $s5,($sp)
	sw $t0,($sp)
	jal check
	
	bgt $v0,0,invalid_preset
   	sw $s5,($sp)	
   	
    	
	check_loop_hint:
	blt $s6,0,done_hintloop
	move $a0,$s2
	move $a1,$s3
	move $a2,$s4
	li $a3,0xa0
	li $t0,0
	
	lw $s5,($sp)
	sw $t0,($sp)
	jal check
	
	sw $s5,($sp)
	beq $v0,0,validinput
	sll $s7,$s7,1
	j next_check_in
	validinput:
	sll $s7,$s7,1
	ori $s7,$s7,00000000000000000000000000000001
	
	
	
	next_check_in:
	
	addi $s6,$s6,-1
	j check_loop_hint
	
	done_hintloop:
	  
	  sll $s7,$s7,1
	 move $v0,$s7
   	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $s4,20($sp)
	lw $s5,24($sp)
	lw $s6,28($sp)
	lw $s7,32($sp)
	addi $sp,$sp,36
   	 
   	 
    
	
	jr $ra
invalid_preset:
	sw $s5,($sp)	
   	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $s4,20($sp)
	lw $s5,24($sp)
	lw $s6,28($sp)
	lw $s7,32($sp)
	addi $sp,$sp,36

	jr $ra
