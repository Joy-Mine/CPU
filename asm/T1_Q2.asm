.data 
.text
li $v0 5
syscall
move 	$t0, $v0		# $t0 = v0

add $a0 $zero $t0
li $v0 1
syscall

and $t1 $t0 1 # 如果是奇数 输出1 偶数输出0
move $a0 $t1
li $v0 1
syscall
addi	$v0, $0, 10		# System call 10 - Exit
syscall					# execute
