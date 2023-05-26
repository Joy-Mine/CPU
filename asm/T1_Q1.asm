.data
.text
li $v0 5
syscall
move 	$t0, $v0		# $t0 = v0
add $a0 $zero $zero #a0 is result and init it to 0
addi $t2 $zero 10

add $a0 $zero $t0
li $v0 1
syscall

loop:
and $t1 $t0 1
beq $t1, $zero, target	# if $t1 ==zero  then goto target
addi $a0 $a0 1
target:
srl	$t0, $t0, 1			# $t0 = $t0<<1
subi	$t2, $t2 1			# $t2 = $t2 - 1 
bne	$t2, $zero, loop	# if $t2 !=zero go to loop




beq $a0 $zero exit1
li $a1 1
beq $a0 $a1 exit1
j exit2
exit1:
li $v0 1
li $a0 1
syscall

exit2:
li $v0 1
li $a0 0
syscall
