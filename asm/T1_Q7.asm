.data
.text
li $v0 5
syscall
move 	$t0, $v0		# $t0 = v0
add $a0 $zero $t0
li $v0 1
syscall

li $v0 5
syscall
move 	$t2, $v0		# $t0 = v0
add $a0 $zero $t2
li $v0 1
syscall

sltu	$t3, $t0, $t2		# $t0 < $t2 $t3 = 1 ? 0
li $v0 1
move $a0 $t3
syscall

addi	$v0, $0, 10		# System call 10 - Exit
syscall					# execute