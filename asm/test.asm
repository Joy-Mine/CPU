.data 
.text 
main:
 lui $2,0xFFFF
 ori $28,$2,0xF000
loop:
 addi $1,$3,1
 sw $1,0xC80($28)
 j loop