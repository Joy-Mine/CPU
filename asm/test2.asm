testcase:
	lw $1,0xC10($31)
	sub $9,$9,$9
	addi $9,$9,1 #$9=1
	beq $1,$9,save_case
	j testcase

save_case:
	sub $1,$1,$1
	lw $2,0xC70($31) #$2 store case 
	
input1:
	lw $1,0xC20($31)
	beq $1,$9,save_input1
	j input1

save_input1:
	sub $1,$1,$1
	lw $3,0xC70($31) #$3 store input1 
	
input2:
	lw $1,0xC30($31)
	beq $1,$9,save_input2
	j input2
	
	
save_input2:
	sub $1,$1,$1
	lw $4,0xC70($31) #$4 store input2
	
	sub $5,$5,$5 #make sure $5 is zero
	sub $9,$9,$9 #make sure $9 is zero

	sub $6,$6,$6
	addi $6,$6,1 #prepare for testcase000 001 010 011
	beq $2,$9,sample000
	addi $9,$9,1
	beq $2,$9,sample001
	addi $9,$9,1
	beq $2,2,sample010
	addi $9,$9,1
	beq $2,3,sample011
	addi $9,$9,1
	beq $2,4,sample100
	addi $9,$9,1
	beq $2,5,sample101
	addi $9,$9,1
	beq $2,6,sample110
	addi $9,$9,1
	beq $2,$9,sample111
	
	
sample000:
	#only use $3
	add $5,$5,$6
	beq $t6,$3,end
	addi $6,$6,1
	j sample000
	
	
sample001:
	
	
sample010:

	
sample011:
	
	
sample100:


sample101:
	
	
sample110:

	
sample111:

	
	
end:
	lw  $1,0xC50($31)
	beq $1,1,testcase
	j end
