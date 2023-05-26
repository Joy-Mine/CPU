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
bne $8 $0 skip22
add $9 $0 $4 # 统一使用9 , 全部使用正数进行操作

skip22:
#开始做除法操作,现在全部都是正数
add $10 $0 $0 #存的是商
addi $11 $0 9 #存的是cnt
sll $9 $9 8 # 初始化，将除数左移8位,被除数是7
loop: #循环8次

subi $11 $11 1

subu $7 $7 $9
slti $12, $7, 0			# $12 = ($7< 0) ? 1 : 0
beqz $12 shift #大于
addu $7 $7 $9
srl $9 $9 1
sll $10 $10 1
j end

shift:
sll $10 $10 1
addi $10 $10 1
srl $9 $9 1

end:

bne $11 $0 loop


srl $3 $3 7
andi $12 $3 1 # 如果12 是1 说明被除数是一个负数
addi $13 $0 -1
beqz $12 skip 
 # 到这说明是一个负数
xor $14 $13 $7 # 将余数转化为负数
addi $14 $14 1

j skip2

skip:# 最终结果统一为 14
add $14 $0 $7
skip2:

srl $4 $4 7
beq $4 $3 skip3 # 如果两个同号，商的符号是正数
xor $15 $13 $10 
addi $15 $15 1

j skip4

skip3:
add $15 $0 $10
skip4:

add $a0 $15 $0  #15 存的是商 
li $v0 1
syscall
add $a0 $14 $0  #14 最后是余数
li $v0 1
syscall