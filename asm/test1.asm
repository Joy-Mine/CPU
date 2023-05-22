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

	sub $6,$6,$6 #make sure $6 is zero
	addi $6,$6,2 #prepare for 000
	beq $2,$9,sample000
	addi $9,$9,1
	beq $2,$9,sample001
	j sample111_present
	
	
	
sample000:
	#only use $1
	sub $3,$3,$6
	beq $3,$0,istwomi
	add $6,$6,$6
	slt $5,$3,$6
	sub $8,$8,$8
	addi $8,$8,1
	beq $5,$8,isnottwomi #$5==1
	j sample000
isTwomi:
	sw $5,0xC60($31)
	j end
isNotTwomi:
	sw $5,0xC60($31) #slt not achieve $5=0
	j end
	
	
sample001:
	sub $8,$8,$8
	addi $8,$8,1
	beq $3,$8,isOdd
	beq $3,$0,isNotOdd
	sub $3,$3,2
	j sample001
isOdd:
	sub $5,$5,$5
	addi $5,$5,1
	sw $5,0xC60($31)
	j end
isNotOdd:
	sw $0,0xC60($31)
	j end
	
	
sample010:
	or $5,$3,$4
	sw $5,0xC60($31)
	j end
	
sample011:
	nor $5,$3,$4
	sw $5,0xC60($31)
	j end
sample100:
	xor $5,$3,$4
	sw $5,0xC60($31)
	j end
sample101:
	slt $5,$3,$4
	sw $5,0xC60($31)
	j end
sample110:
	sltu $5,$3,$4
	sw $5,0xC60($31)
	j end
	
	
sample111_present:
	sub $8,$8,$8
	addi $8,$8,1
	lw  $1,0xC40($31)
	beq $1,$8,sample111
	j sample111_present
sample111:
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
	j end
	
	
end:
	sub $8,$8,$8
	addi $8,$8,1
	lw  $1,0xC50($31)
	beq $1,$8,testcase
	j end
