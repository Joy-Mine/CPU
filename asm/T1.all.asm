.data
.text
lui $1 0xFFFF
ori $31 $1 0xF000
#30- 23 init to check whether equal
addi $30 $0 1
addi $29 $0 2
addi $28 $0 3
addi $27 $0 4
addi $26 $0 5
addi $25 $0 6
addi $24 $0 7
deadLoop:

testcase:
lw $1 0xC10($31)
beq $1 $30 save_case
j testcase

save_case:
    and $1 $0 $0
	lw $2,0xC70($31) #$2 store case 

input1:
	lw $1,0xC20($31)
	beq $1,$9,save_input1
	j input1

save_input1:
    and $1 $0 $0
	lw $3,0xC70($31) #$3 store input1 

input2:
	lw $1,0xC30($31)
	beq $1,$9,save_input2
	j input2

save_input2:
    and $1 $0 $0
	lw $4,0xC70($31) #$4 store input2
	
	and $5 $0 $0 #make sure $5 is zero
	and $9 $0 $0 #make sure $9 is zero

	and $6 $0 $0  #make sure $6 is zero
	addi $6,$6,2 #prepare for 000
	beq $2,$9,sample000
	addi $9,$9,1
	beq $2,$9,sample001
	j sample111_present










j  deadLoop