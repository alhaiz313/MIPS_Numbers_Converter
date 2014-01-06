

.data
msg1:.asciiz "\nPlease insert text (max 100 characters): "
msg2:.asciiz "\nThe result is: "
str1: .space 100
str2: .space 100

.text
.globl main
main:
############ get the first string ############
li $v0,4
la $a0,msg1
syscall

li $v0,8
la $a0,str1
addi $a1,$zero,100
syscall   #got string 1
########### get the second string ############
li $v0,4
la $a0,msg1
syscall

li $v0,8
la $a0,str2
addi $a1,$zero,100
syscall   #got string 2
##############################################
la $t1,str1  #pass address of str1
la $t2,str2  #pass address of str2

add $t8,$zero,$t1
add $t9,$zero,$t2

jal strcmp   #call strcmp
nop
############# Print the result ###############




li $v0,4
la $a0,msg2
syscall


add $a0,$t5,$zero

finish:

li $v0,1
syscall

li $v0,10
syscall
#############################################

continue:

strcmp:

add $t0,$zero,$zero ###### equality cntr



loop:

lb $t3,($t1)  #load a byte from each string
lb $t4,($t2)

beq $t3,10,endstring_2 #str1 end
nop
beq $t4,10,endstring_2 #str2 end
nop

beq $t3,$t4,equal
nop



addi $t1,$t1,1
addi $t2,$t2,1
j loop
nop


equal:
addi $t1,$t1,1
addi $t2,$t2,1
addi $t0,$t0,1

j loop
nop




endstring_2:

bgt $t5,$t0,do_not_save_it
nop

add $t5,$zero,$t0

do_not_save_it: 


add $t1,$zero,$t8
add $t2,$zero,$t9

addi $s0,$s0,1

add $t1,$t1,$s0

lb $s1,($t1)
beq $s1,10,endString
nop
j strcmp
nop





endString:


bgt $t5,$t0,do_not_save_it2
nop

add $t5,$zero,$t0

do_not_save_it2: 


addi $s4,$s4,1 #### switch_counter


la $t2,str1 #switch the addresses
la $t1,str2

add $t8,$zero,$t1
add $t9,$zero,$t2


add $s0,$zero,$zero

ble $s4,1,continue #####we want to switch only once
nop



jr $ra
 
nop
###################################
