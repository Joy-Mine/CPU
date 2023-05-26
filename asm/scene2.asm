.data 0x0000
.text 0x0000
main:
	lui $1, 0xFFFF
	ori $28, $1, 0xF000
	
	# addi $17, $0, 0
	# addi $18, $0, 1
	# addi $19, $0, 2
	# addi $20, $0, 3
	# addi $21, $0, 4
	# addi $22, $0, 5
	# addi $23, $0, 6
	# addi $24, $0, 7
	
loop:
    addi $18,$0,4 #100
	lw $10, 0xC40($28)	#确定输入的单独拨码开�???
	beq $10, $18, execute	#确定�???次输�???
	j loop
	
execute:
	lw $1, 0xC60($28)	#拨码开关输入样例编号
	beq $1, $0, q0		#000
	addi $18, $0, 1
	beq $1, $18, q1		#001
	addi $18, $18, 1
	beq $1, $18, q2		#010
	addi $18, $18, 1
	beq $1, $18, q3		#011
	addi $18, $18, 1
	beq $1, $18, q4 	#100
	addi $18, $18, 1
	beq $1, $18, q5		#101
	addi $18, $18, 1
	beq $1, $18, q6		#110
	addi $18, $18, 1
	beq $1, $18, q7 	#111
	j loop

q0:
   lw $10, 0xC40($28)      #010
   addi $24,$0,2
   bne $10,$24,q0 # 等待确定输入
   lw $10, 0xC80($28) #拨码�???关输入到10 �???
   srl $11,$10,7 #看看符号位是不是负数
   beq $11 ,$18 ,minus # 如果是负数就跳转
   add $13 ,$0 ,$0 # answer
   add $12 ,$0, $0 # cnt
   q02:
   addi $12 ,$12 ,1 #cnt
   add $13 ,$12 ,$13
   beq $12 ,$10 ,out0
   j q02

   minus:
   #闪烁我不会写
   j init0

   out0:
   sw $13 ,0xC80($28)

   init0:
   and $10,$10,$0 
   and $11,$11,$0 
   and $12,$12,$0 
   and $13,$13,$0
   and $24,$24,$0
   j loop

q1:
    lw $10 ,0xC40($28) #010
    addi $24,$0,2
    bne $10,$24,q1# 等待确定输入
    lw $10,0xC60($28) # 输入
    addi $11,$0,1 # 记录出栈和入栈和
    add $12,$10,$0 #move $a0 $v0 
    jal fact1

    sw $11,0xC80($28)

    and $10,$10,$0
    and $11,$11,$0
    and $12,$12,$0
    and $13,$13,$0
    and $14,$14,$0
    j loop
    fact1:
    addi $11,$11,1
    addi $29,$29,-8
    sw $31,4($29) #sw $ra, 4($sp) #save the return address
    sw $12,($29) #sw $a0, 0($sp) #save the argument n
    slti $13,$12,1
    beq $13,$0,L11
    add $14,$0,$0 # 14 存的是答�??? 累加�???
    addi $29,$29,8
    jr $31
    L11:addi $12,$12,-1 #12 对应的是a0
    jal fact1
    lw $12,0($29)
    lw $31,4($29)
    addi $29,$29,8
    addi $11,$11,1
    add $14,$14,$12
    jr $31

	
q2:


    lw $10,0xC40($28)  #010
    addi $24,$0,2
    bne $10,$24,q2# 等待确定输入
    lw $10,0xC60($28) # 输入
    add $12,$10,$0 #move $a0 $v0 
    jal fact2

    and $10,$10,$0
    and $11,$11,$0
    and $12,$12,$0
    and $13,$13,$0
    and $14,$14,$0
    j loop
    fact2:

    sw $12,0xC80($28)

    addi $23,$23,9999
    loop_q3:
    subi $23,$23,1
    bne $23,$0,loop_q3 # 目的是显示2秒


    addi $29,$29,-8
    sw $31,4($29) #sw $ra, 4($sp) #save the return address
    sw $12,($29) #sw $a0, 0($sp) #save the argument n
    slti $13,$12,1
    beq $13,$0,L12 
    add $14,$0,$0 # 14 存的是答�??? 累加�???
    addi $29,$29,8
    jr $31
    L12:addi $12,$12,-1 #12 对应的是a0
    jal fact2
    lw $12,0($29)
    lw $31,4($29)
    addi $29,$29,8

    add $14,$14,$12
    jr $31

	
	
q3:

    lw $10,0xC40($28)  #010
    addi $24,$0,2
    bne $10,$24,q3# 等待确定输入
    lw $10,0xC60($28) # 输入
    add $12,$10,$0 #move $a0 $v0 
    jal fact3

    sw $14,0xC80($28)


    addi $23,$23,9999
    loop_q3:
    subi $23,$23,1
    bne $23,$0,loop_q3 # 目的是显示2秒

    and $10,$10,$0
    and $11,$11,$0
    and $12,$12,$0
    and $13,$13,$0
    and $14,$14,$0
    j loop
    fact3:
    addi $29,$29,-8
    sw $31,4($29) #sw $ra, 4($sp) #save the return address
    sw $12,($29) #sw $a0, 0($sp) #save the argument n
    slti $13,$12,1
    beq $13,$0,L1 
    add $14,$0,$0 # 14 存的是答�??? 累加�???
    addi $29,$29,8
    jr $31
    L1:addi $12,$12,-1 #12 对应的是a0
    jal fact3
    lw $12,0($29)
    lw $31,4($29)
    addi $29,$29,8

    sw $14,0xC80($28)

    addi $23,$23,9999
    loop_q3:
    subi $23,$23,1
    bne $23,$0,loop_q3 # 目的是显示2秒

    add $14,$14,$12
    jr $31

	

q4:
    lw $10,0xC40($28)  #010
    addi $24,$0,2
    bne $10,$24,q4# 等待确定输入
    lw $10,0xC60($28) # 输入
    add $11,$0,$10 #11 存第�??个输�??
    q42:
    lw $10,0xC40($28)  #001
    addi $24,$0,1
    bne $10,$24,q42# 等待确定输入

    lw $10,0xC60($28) # 输入
    add $12,$0,$10 #12 存第二个输入
    sll $13,$11,24
    sll $14,$12,24
    addu $10,$13,$14 #�??11 �?? 12 加起�?? 存到10 里面
    srl $15,$11,7
    srl $16,$12,7
    xor $15,$15,$16
    bne $15,$0,no_flow4
    srl $17,$10,31
    xor $17,$15,$17
    beq $17,$0,no_flow4
    j end4

    no_flow4:
    sra $10,$10,24 
    sw $10,0xC80($28)
    and $10,$10,0
    and $11,$11,0
    and $12,$12,0
    and $13,$13,0
    and $14,$14,0
    and $15,$15,0
    and $16,$16,0
    and $17,$17,0
    j loop

    end4:
    addi $10,$0,8787 #溢出判断可以用小灯
    sw $10,0xC80($28)
    and $10,$10,0
    and $11,$11,0
    and $12,$12,0
    and $13,$13,0
    and $14,$14,0
    and $15,$15,0
    and $16,$16,0
    and $17,$17,0
    j loop 
q5:

    lw $10,0xC40($28)  #010
    addi $24,$0,2
    bne $10,$24,q5# 等待确定输入
    lw $10,0xC60($28) # 输入
    add $11,$0,$10 #11 存第�??个输�??
    q52:
    lw $10,0xC40($28)  #001
    addi $24,$0,1
    bne $10,$24,q52# 等待确定输入
    lw $10,0xC60($28) # 输入
    add $12,$0,$10 #12 存第二个输入
    sll $13,$11,24
    sll $14,$12,24
    subu $10,$13,$14 #�??11 �?? 12 加起�?? 存到10 里面
    srl $15,$11,7
    srl $16,$12,7
    xor $15,$15,$16
    beq $15,$0,no_flow5
    srl $17,$10,31
    srl $11,$11,7
    beq $17,$11,no_flow5
    j end5

    no_flow5:
    sra $10,$10,24
    sw $10,0xC80($28)
    and $10,$10,0
    and $11,$11,0
    and $12,$12,0
    and $13,$13,0
    and $14,$14,0
    and $15,$15,0
    and $16,$16,0
    and $17,$17,0
    j loop

    end5:
    addi $10,$0,8787
    sw $10,0xC80($28)
    and $10,$10,0
    and $11,$11,0
    and $12,$12,0
    and $13,$13,0
    and $14,$14,0
    and $15,$15,0
    and $16,$16,0
    and $17,$17,0
    j loop 
	
	
q6:
    lw $10,0xC40($28)  #010
    addi $24,$0,2
    bne $10,$24,q6# 等待确定输入
    lw $10,0xC60($28) # 输入
    add $11,$0,$10 #11 存第�??个输�??
    q62:
    lw $10,0xC40($28)  #001
    addi $24,$0,1
    bne $10,$24,q62# 等待确定输入
    lw $10,0xC60($28) # 输入
    add $12,$0,$10 #12 存第二个输入

    srl $13,$11,7
    andi $13,$13,1
    addi $10,$0,-1
    beq $13,$0,positive61
    sll $11,$11,24
    sra $11,$11,24
    xor $14,$10,$11
    addi $14,$14,1

    positive61:
    srl $15,$12,7
    andi $15,$15,1
    beq $15,$0,positive62

    sll $12,$12,24
    sra $12,$12,24
    xor $16,$10,$12
    addi $16,$16,1

    positive62:
    bne $13,$0,skip61
    add $14,$0,$11
    skip61:
    bne $15,$0,skip62
    add $16,$0,$12

    skip62:
    add $19,$0,$0   #cnt
    add $20,$0,$0   #result
    multply6:
    add $20,$20,$14
    addi $19,$19,1
    bne $19,$16,multply6

    srl $13,$11,7
    srl $15,$12,7
    beq $13,$15,skip63
    xor $20,$20,$10
    addi $20,$20,1
    skip63:
    sw $20,0xC80($28)
    #没使用了17 18 号寄存器 
    and $10 $10 $0
    and $11 $11 $0
    and $12 $12 $0
    and $13 $13 $0  
    and $14 $14 $0
    and $15 $15 $0
    and $16 $16 $0
    and $19 $19 $0
    and $20 $20 $0

    j loop

	

q7:
	lw $10,0xC40($28)  #010
    addi $24,$0,2
    bne $10,$24,q6# 等待确定输入
    lw $10,0xC60($28) # 输入
    add $11,$0,$10 #11 存第�??个输�??
    q62:
    lw $10,0xC40($28)  #001
    addi $24,$0,1
    bne $10,$24,q62# 等待确定输入
    lw $10,0xC60($28) # 输入
    add $12,$0,$10 #12 存第二个输入

    srl $13,$11,7
    andi $13,$13,1
    addi $10,$0,-1
    beq $13,$0,positive71
    sll $11,$11,24
    sra $11,$11,24
    xor $14,$10,$11
    addi $14,$14,1

    positive71:
    srl $15,$12,7
    andi $15,$15,1
    beq $15,$0,positive72

    sll $12,$12,24
    sra $12,$12,24
    xor $16,$10,$12
    addi $16,$16,1

    positive72:
    bne $13,$0,skip71
    add $14,$0,$11
    skip71:
    bne $15,$0,skip72
    add $16,$0,$12  #全部换成了正数

    skip72:
    #开始做除法操作，现在的操作全部是正数
    add $17,$0,$0  #存的是商
    addi $19,$0,9 #存的是cnt
    sll $16,$16,8
    loop7:
    subi $19,$19,1
    subu $14,$14,$16
    slti $20,$14,0
    beq $20,$0,shift7
    addu $14,$14,$16
    srl $16,$16,1
    sll $17,$17,1

    j end7

    shift7:
    sll $17,$17,1
    addi $17,$17,1
    srl $16,$16,1

    end7:
    bne $19,$19,loop

    srl $11,$11,7
    andi $20,$11,1   #andi $12 $3 1 # 如果12 是1 说明被除数是一个负数
    addi $21,$0,-1
    beq $20,$0,skip7 
    # 到这说明是一个负数
    xor $22,$21,$14  # 将余数转化为负数
    addi $22,$22,1

    j skip72

    skip7 :  #统一最终结果
    add $22,$0,$14
    skip72:
    srl $12,$12,7
    beq $12,$11,skip73
    xor $23,$21,$17
    addi $23,$23,1

    j skip74

    skip73:
    add $23,$0,$17
    skip74:
    

    sw $23,0xC80($28)

    addi $10,$0,9999    #显示
    loop_q7:
    subi $10,$10,1
    bne $10,$0,loop_q7

    sw $22,0xC80($28)

    addi $10,$0,9999
    loop_q7:
    subi $10,$10,1
    bne $10,$0,loop_q7

    j loop




















