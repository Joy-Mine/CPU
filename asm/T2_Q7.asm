.data
.text
li $v0 5
syscall 
add $3 $v0 $0 #3 store the first
li $v0 5
syscall
add $4 $v0 $0 #4 store the second

srl $5 $3 7
andi $5 $5 1 #if 5 is 1 then the result is minus
addi $6 $0 -1
beq $5 $0 positive1
sll $3 $3 24
sra $3 $3 24
xor $7 $6 $3 
addi $7 $7 1 # 3 是负�?? 取补码操�??

positive1:
srl $8 $4 7
andi $8 $8 1
beq $8 $0 positive2
sll $4 $4 24
sra $4 $4 24 
xor $9 $6 $4
addi $9 $9 1 # 4 是负�?? 取补码操�?? 

positive2:
bne $5 $0 skip1
add $7 $0 $3 # 统一使用7
skip1:
bne $8 $0 skip2
add $9 $0 $4 # 统一使用9 , 全部使用正数进行操作

skip2:
add $10 $0 $0  #cnt
add $11 $0 $0  #result
multply:
add $11 $11 $7
addi $10 $10 1
bne $10 $9 multply

srl $5 $3 7
srl $8 $4 7
beq $5 $8 skip3
xor $11 $11 $6
addi $11 $11 1
skip3:

li $v0 1
move $a0 $11
syscall




