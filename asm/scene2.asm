.data
.text 
main:
	lui $1, 0xFFFF
	ori $28, $1, 0xF000
    lui $25,0x01FF  #0x00FF 基本上是2s
    ori $25,$25,0xFFFF
    ori $30,$1,0x0FFF
	lui $26,0x007F
    ori $26,$26,0xFFFF
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
	lw $10, 0xC40($28)	#确定输入的单独拨码开�?????
	beq $10, $18, execute	#确定�?????次输�?????
	j loop
	
execute:
	lw $1, 0xC60($28)	#拨码�??关输入样例编�??
    addi $1,$1,0
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
   sw $0,0xC64($28)
   sw $0,0xC80($28)
   lw $10, 0xC40($28)      #010
   addi $24,$0,2
   bne $10,$24,q0 # 等待确定输入
   lw $10, 0xC60($28) #拨码�?????关输入到10 �?????
   srl $11,$10,7 #看看符号位是不是负数
   addi $18,$0,1 
   beq $11 ,$18 ,minus # 如果是负数就跳转
   add $13 ,$0 ,$0 # answer
   add $12 ,$0, $0 # cnt
   q02:
   addi $12 ,$12 ,1 #cnt
   add $13 ,$12 ,$13
   beq $12 ,$10 ,out0
   j q02

   minus:


   addi $1,$0,15
   sw $1,0xC64($28)

    add $10,$26,$0   #显示
    loop_q01:
    addi $10,$10,-1
    bne $10,$0,loop_q01  

    addi $1,$0,0
    sw $1,0xC64($28)

    add $10,$26,$0   #显示
    loop_q011:
    addi $10,$10,-1
    bne $10,$0,loop_q011  

     addi $1,$0,15
     sw $1,0xC64($28)

    add $10,$26,$0   #显示
    loop_q012:
    addi $10,$10,-1
    bne $10,$0,loop_q012  

    addi $1,$0,0
    sw $1,0xC64($28)

    add $10,$26,$0   #显示
    loop_q013:
    addi $10,$10,-1
    bne $10,$0,loop_q013 


    addi $1,$0,15
   sw $1,0xC64($28)

    add $10,$26,$0   #显示
    loop_q014:
    addi $10,$10,-1
    bne $10,$0,loop_q014  

    addi $1,$0,0
    sw $1,0xC64($28)

    add $10,$26,$0   #显示
    loop_q015:
    addi $10,$10,-1
    bne $10,$0,loop_q015  

     addi $1,$0,15
     sw $1,0xC64($28)

    add $10,$26,$0   #显示
    loop_q016:
    addi $10,$10,-1
    bne $10,$0,loop_q016  

    addi $1,$0,0
    sw $1,0xC64($28)

    add $10,$26,$0   #显示
    loop_q017:
    addi $10,$10,-1
    bne $10,$0,loop_q017







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
    sw $0,0xC64($28)
   sw $0,0xC80($28)
    lw $10 ,0xC40($28) #010
    addi $24,$0,2
    bne $10,$24,q1# 等待确定输入


    lw $10,0xC60($28) # 输入
    add $11,$0,$10
    addi $10,$0,1  #存的是答案

    jal fact11


    sw $10,0xC80($28)

    j loop

    fact11:
    addi $10,$10,1
    addi $29,$29,-4
    sw $31,0($29)
    bne $11,$0,L111
    addi $29,$29,4
    jr $31


    L111:
    addi $11,$11,-1
    jal fact11
    lw $31,0($29)
    addi $29,$29,4
    addi $10,$10,1
    jr $31
    
    
   
	
q2:

sw $0,0xC64($28)
   sw $0,0xC80($28)
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

    addi $29,$29,-8
    sw $31,4($29) #sw $ra, 4($sp) #save the return address
    sw $12,0($29) #sw $a0, 0($sp) #save the argument n
    slti $13,$12,1
    beq $13,$0,L12 
    add $14,$0,$0 # 14 存的是答�????? 累加�?????
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
sw $0,0xC64($28)
   sw $0,0xC80($28)

    lw $10,0xC40($28)  #010
    addi $24,$0,2
    bne $10,$24,q3# 等待确定输入
    lw $10,0xC60($28) # 输入
    add $12,$10,$0 #move $a0 $v0 
    jal fact3

    sw $14,0xC80($28)

    and $10,$10,$0
    and $11,$11,$0
    and $12,$12,$0
    and $13,$13,$0
    and $14,$14,$0
    j loop
    fact3:
    addi $29,$29,-8
    sw $31,4($29) #sw $ra, 4($sp) #save the return address
    sw $12,0($29) #sw $a0, 0($sp) #save the argument n
    slti $13,$12,1
    beq $13,$0,L1 
    add $14,$0,$0 # 14 存的是答�????? 累加�?????
    addi $29,$29,8
    jr $31
    L1:addi $12,$12,-1 #12 对应的是a0
    jal fact3
    lw $12,0($29)
    lw $31,4($29)
    addi $29,$29,8

    sw $14,0xC80($28)

    addi $23,$23,9999
    loop_q32:
    addi $23,$23,-1
    bne $23,$0,loop_q32 # 目的是显�??2�??

    add $14,$14,$12
    jr $31

	

q4:
    sw $0,0xC64($28)
   sw $0,0xC80($28)
    lw $10,0xC40($28)  #010
    addi $24,$0,2
    bne $10,$24,q4# 等待确定输入
    lw $10,0xC60($28) # 输入
    add $11,$0,$10 #11 存第�????个输�????
    q42:
    lw $10,0xC40($28)  #001
    addi $24,$0,1
    bne $10,$24,q42# 等待确定输入

    lw $10,0xC60($28) # 输入
    add $12,$0,$10 #12 存第二个输入
    sll $13,$11,24
    sll $14,$12,24
    addu $10,$13,$14 #�????11 �???? 12 加起�???? 存到10 里面
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
    and $10,$10,$0
    and $11,$11,$0
    and $12,$12,$0
    and $13,$13,$0
    and $14,$14,$0
    and $15,$15,$0
    and $16,$16,$0
    and $17,$17,$0
    j loop

    end4:
    addi $10,$0,15 #溢出判断可以用小�??
    sw $10,0xC64($28)
    and $10,$10,$0
    and $11,$11,$0
    and $12,$12,$0
    and $13,$13,$0
    and $14,$14,$0
    and $15,$15,$0
    and $16,$16,$0
    and $17,$17,$0
    j loop 
q5:
    sw $0,0xC64($28)
   sw $0,0xC80($28)
    lw $10,0xC40($28)  #010
    addi $24,$0,2
    bne $10,$24,q5# 等待确定输入
    lw $10,0xC60($28) # 输入
    add $11,$0,$10 #11 存第�????个输�????
    q52:
    lw $10,0xC40($28)  #001
    addi $24,$0,1
    bne $10,$24,q52# 等待确定输入
    lw $10,0xC60($28) # 输入
    add $12,$0,$10 #12 存第二个输入
    sll $13,$11,24
    sll $14,$12,24
    subu $10,$13,$14 #�????11 �???? 12 加起�???? 存到10 里面
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
    and $10,$10,$0
    and $11,$11,$0
    and $12,$12,$0
    and $13,$13,$0
    and $14,$14,$0
    and $15,$15,$0
    and $16,$16,$0
    and $17,$17,$0
    j loop

    end5:
    addi $10,$0,15
    sw $10,0xC64($28)
    and $10,$10,$0
    and $11,$11,$0
    and $12,$12,$0
    and $13,$13,$0
    and $14,$14,$0
    and $15,$15,$0
    and $16,$16,$0
    and $17,$17,$0
    j loop 
	
	
q6:

    sw $0,0xC64($28)
   sw $0,0xC80($28)
    lw $10,0xC40($28)  #010
    addi $24,$0,2
    bne $10,$24,q6# 等待确定输入
    lw $10,0xC60($28) # 输入
    add $11,$0,$10 #11 存第�????个输�????
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
    and $10,$10,$0
    and $11,$11,$0
    and $12,$12,$0
    and $13,$13,$0  
    and $14,$14,$0
    and $15,$15,$0
    and $16,$16,$0
    and $19,$19,$0
    and $20,$20,$0

    j loop

	

q7:

    sw $0,0xC64($28)
   sw $0,0xC80($28)
	lw $10,0xC40($28)  #010
    addi $24,$0,2
    bne $10,$24,q7# 等待确定输入
    lw $10,0xC60($28) # 输入
    add $11,$0,$10 #11 存第�????个输�????
    q72:
    lw $10,0xC40($28)  #001
    addi $24,$0,1
    bne $10,$24,q72# 等待确定输入
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
    bne $15,$0,skip721
    add $16,$0,$12  #全部换成了正�??

    skip721:
    add $17,$0,$0  #存的是商
    addi $19,$0,9 #存的是cnt
    sll $16,$16,8
    loop7:

    addi $19,$19,-1
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
    bne $19,$0,loop7

    srl $11,$11,7
    andi $20,$11,1   #andi $12 $3 1 # 如果12 �??1 说明被除数是�??个负�??
    addi $21,$0,-1
    beq $20,$0,skip7 
    # 到这说明是一个负�??
    xor $22,$21,$14  # 将余数转化为负数
    addi $22,$22,1

    j skip72

    skip7 :  #统一�??终结�??
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

    add $10,$25,$0   #显示
    loop_q71:
    addi $10,$10,-1
    bne $10,$0,loop_q71

    sw $22,0xC80($28)

    add $10,$0,$25
    loop_q72:
    addi $10,$10,-1
    bne $10,$0,loop_q72

    j loop




















