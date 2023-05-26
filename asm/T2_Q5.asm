.data
.text
li $v0 5
syscall
add $3 $0 $v0 #3 store the first 
li $v0 5
syscall
add $4 $0 $v0 #4 store the second
sll $6 $3 24# 先左�???24�???
sll $7 $4 24
add $5 $6 $7 #直接加起�???
srl $8 $3 7
srl $9 $4 7
xor $8 $9 $8
bne $8 $0 no_flow #符号位不同，不可能溢�???
#可能存在溢出的情�???
srl $10 $5 31
xor $10 $8 $10
beq $10 $0 no_flow
j end


no_flow:

sra $5 $5 24
add $a0 $0 $5
li $v0 1
syscall

addi	$v0, $0, 10		# System call 10 - Exit
syscall	

end:
li $v0 1
li $a0 8778
syscall

addi	$v0, $0, 10		# System call 10 - Exit
syscall					# execute
