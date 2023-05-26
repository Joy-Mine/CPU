.data
.text
li $v0 5
syscall

blt		$t0, $zero, end	# if $t0 < $zero then goto end
#重新写一下这个部分

add $t0 $t0 $v0
add $t1 $zero $t0 #t1 as count
add $t2 $zero $t0 #t2 stores the result
loop:
subi $t1 $t1 1
add $t2 $t2 $t1 

bne $t1 $zero loop
li $v0 1
add $a0 $zero $t2
syscall

end:
#blink still cannot solve


addi	$v0, $0, 10		# System call 10 - Exit
syscall					# execute
