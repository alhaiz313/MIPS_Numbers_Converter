# zainab_alhaidary & Hanooooooooodaty

.data   


number: .asciiz "plz insert a number  <  10^6 :"

input: .space 20  

deci: .asciiz "your num. in deci is:"

frac: .asciiz "your frac num in deci is:"

old_base: .asciiz "plz insert the old base :"

new_base: .asciiz "plz insert the new base:"

new_num: .asciiz "your new num is:"

new_num_frac: .asciiz "."

result: .asciiz "the result is: "

invalid: .asciiz "your input is invalid"

zero: .asciiz "0"

.text

.globl main
main:



#############print_first_sentense#############
li $v0,4
la $a0,number
syscall

#############read_number#############

#$s4 has the starting address of the input

la $a0,input
add $s4,$zero,$a0
li $a1,20
li $v0,8
syscall


#############print_2nd_sentence#############
# $s2 =old_base


li $v0,4
la $a0,old_base
syscall

la $v0,5
syscall

add $s2,$zero,$v0

#############check_the_old_base#############


bgt $s2,16,end
nop
blt $s2,2,end
nop



#############check_the_validity############
########bring_char#########

#$t0=counter for the size

add $t0,$zero,$zero     #initialising the counter to zero
add $t2,$zero,$zero     #initialising the dot_counter to zero

check_validity:

lb $t1, ($s4)   # t1= the fetched character


beq $t1,10,finish_checking
nop

#add $a0, $zero, $t1  ############print the ascci value 
#li $v0,1
#syscall

addi $s4,$s4,1 #inc_the_address

addi $t0,$t0,1 #inc_the_counter


blt $s2,11,less_than_11  #if the base is less than 11
nop
#greater_than_11:        

#lower_case_checking:

addi $t3,$s2,-10 #old_base-10
addi $t3,$t3,97  #97+old_base-10

    
bgt $t1,$t3, end
nop
blt $t1,97,check_upper_case
nop
j check_validity


check_upper_case:

addi $t4,$s2,-10
addi $t4,$t4,65

bgt $t1,$t4,end
nop
blt $t1,65,check_the_number
nop
j check_validity   
nop

##########################
check_the_number:
bgt $t1,57,end
nop
blt $t1,48,check_the_dot
nop
j check_validity
nop

check_the_dot:
bgt  $t1,46,end
nop
blt  $t1,46, end
nop
addi $t2,$t2,1  #inc_the_counter_of_the_dot
add $t8,$zero,$t0  ############ save the place of the dot

#add $a0, $zero, $t0  ############print the counter
#li $v0,1
#syscall

bgt $t2,1,end 
nop                             
j check_validity
nop



###############less_than_11###########



less_than_11:

addi $t5,$s2,48

bgt $t1,$t5,end
nop
blt $t1,48,check_the_dot
nop
j check_validity
nop





##########################


end:
li $v0,4
la $a0,invalid
syscall

  

li $v0,10   ##EXIT
syscall

##########################


finish_checking:

#add $a0, $zero, $t0  ############print the counter
#li $v0,1
#syscall



li $v0,4              ############asking for the new base
la $a0,new_base
syscall

la $v0,5
syscall

add $s3,$zero,$v0   #$s3=the new base
 
bgt $s3,16,end
nop
blt $s3,2,end
nop



########################convert_int_to_decimal##########################

la $a0,input
add $s4,$zero,$a0

add $t6,$s4,$t8  #the address of the dot (with starting index =1)
addi $t6,$t6,-2  #the address of the number b4 the dot
addi $t0,$t0,-1
add $s0,$s4,$t0 #address of the last input
bgt $t8,$zero,dot
nop
add $s5,$zero,$zero
add $t6,$zero,$s0

dot:
add $s6,$zero,$t6
#s5=the result

jal convert_int_to_deci
nop

####finish:

#li $v0,4
#la $a0,deci
#syscall


#add $a0,$zero,$s5
#li $v0,1
#syscall


###################################convert_frac_to_deci###################################
la $s4,input
add $t6,$s4,$t8  #the address of the dot (with starting index =1)
add $s0,$s4,$t0 #address of the last input
add $s7,$zero,$s0 #fixed place for the last addr.

beq $t8,$zero,continue  #if we have no dot skip fraction conversion
nop

mtc1 $zero,$f1
cvt.s.w $f1,$f1############# initializing the result to zero

mtc1 $s2,$f2  ##old_base
cvt.s.w $f2,$f2 #old_base


jal convert_frac_to_deci
 

nop

##finish2:

#li $v0,4
#la $a0,frac
#syscall


#mov.s $f12,$f1
#li $v0,2
#syscall


###################################convert_int_to_new###################################
continue:
bne $s5,$zero,continue1
nop
li $v0,4
la $a0,zero
syscall
j cnt
nop

continue1:
add $s0,$zero,$zero ####initial_s0
###s5 holds the result
nop

#li $v0,4
#la $a0,new_num
#syscall

jal convert_deci_int_to_new
nop


###################################convert_frac_to_new###################################
cnt:

add $t0,$zero,$zero ###number_fraction_digits

srl $t1,$s3,1  ### for rounding

mtc1 $s3, $f28   ###convert_the_new_base_2_float
cvt.s.w $f28, $f28

add $t4,$zero,$zero


mtc1 $t4, $f14   ###save zero in f14
cvt.s.w $f14, $f14




beq $t8,$zero,exit
nop

li $v0,4
la $a0,new_num_frac
syscall

c.eq.s $f1,$f14 ### when f1=0
bc1t your_value_is_zero


jal convert_frac_to_new

nop
########################################################################################################



########################################################################################################


exit:


li $v0,10   ##EXIT
syscall


########################################################################################################


convert_int_to_deci:


blt $t6,$s4,pop

lb $t1, ($t6)   # t1= the fetched character

bgt $t1,96,lower
bgt $t1,65,upper

sub $t1,$t1,48
j allocate
upper: sub $t1,$t1,55
j allocate
lower:  sub $t1,$t1,87

#add $a0, $zero, $t1  ############print the fetched number
#li $v0,1
#syscall


allocate:
addi $sp,$sp,-32
sw $ra,28($sp)
sw $t1,24($sp)
sw $t6,20($sp)




addi $t6,$t6,-1


jal convert_int_to_deci
nop

pop:


lw $t1,24($sp)
mul $t9,$s5,$s2 ############# (result*old_base)
add $s5,$t9,$t1 #############  result=(result*old_base)+number



#add $a0,$zero,$s5  ############print the fetched number
#li $v0,1
#syscall


lw $t6,20($sp)
lw $ra,28($sp)
addi $sp,$sp,32
jr $ra


li $v0,10   ##EXIT
syscall


 ############# ############# ############# ############# ############# ############# #############


convert_frac_to_deci:

bgt $t6,$s0,pop2  

lb $t1,($t6)   # t1= the fetched character

bgt $t1,96,lower2
bgt $t1,65,upper2

sub $t1,$t1,48
j allocate2
upper2: sub $t1,$t1,55
j allocate2
lower2:  sub $t1,$t1,87


allocate2:
addi $sp,$sp,-32
sw $ra,28($sp)
sw $t1,24($sp)
sw $t6,20($sp)

addi $t6,$t6,1


jal convert_frac_to_deci
nop

pop2:

lw $t1,24($sp)

mtc1 $t1,$f0  ##fetched character
cvt.s.w $f0,$f0 ##fetched character

#li $v0,2  ######## print_num_after_conversion
#mov.s $f12,$f0
#syscall

add.s $f9,$f1,$f0 ############# (result+t1)
div.s $f1,$f9,$f2 #############  result=(result+t1)/old_base

#li $v0,2  ######## print_num_after_conversion
#mov.s $f12,$f1
#syscall

lw $t6,20($sp)
lw $ra,28($sp)
addi $sp,$sp,32
jr $ra


li $v0,10   ##EXIT
syscall


 ############# ############# ############# ############# #############
convert_deci_int_to_new:

beq $s5,$zero,pop3
 
nop

rem $s0,$s5,$s3 #####the remainder value


div $s5,$s5,$s3 #####quotient


bgt $s0,9,lower3
nop
addi $s0,$s0,48
j allocate3
nop
lower3: addi $s0,$s0,87
nop

allocate3:
addi $sp,$sp,-32
sw $ra,28($sp)
sw $s0,24($sp)


jal convert_deci_int_to_new

nop

pop3:
lw $s0,24($sp)



 #add $a0, $zero, $s0  ############print the fetched number
 #li $v0,1
 #syscall

la $a0,24($sp)
li $v0,4
syscall

lw $ra,28($sp)
addi $sp,$sp,32

jr $ra
nop

 ############# ############# ############# ############# ############# ############# #############

convert_frac_to_new:

c.lt.s $f14,$f1
bc1f pop4

#beq $f1,$f14,pop4 #### if f1= zero , bcz f14=zero
nop


beq $t0,10,pop4
nop


mul.s $f18,$f1,$f28  ## (float_result*new_base)

mov.s $f16,$f18 ## to keep the value of mul in f16

cvt.w.s $f18, $f18
mfc1 $t3,$f18   ####int_result

mtc1 $t3, $f4  ### put the int result in f4 register
cvt.s.w $f4, $f4

sub.s $f1,$f16,$f4

beq $t0,9,rounding
nop

only_10_digits:

addi $t0,$t0,1 ##counter_increment


bgt $t3,9,lower4
nop
addi $t3,$t3,48
j allocate4
nop
lower4: addi $t3,$t3,87
nop




allocate4:
addi $sp,$sp,-32
sw $ra,28($sp)
sw $t3,24($sp)

la $a0,24($sp)
li $v0,4
syscall

jal convert_frac_to_new

nop

pop4:

lw $ra,28($sp)
lw $t3,24($sp)
addi $sp,$sp,32

jr $ra
nop










 ############# ############# ############# ############# ############# ############# #############

rounding:

c.lt.s $f14,$f1
bc1f only_10_digits 

#beq $f1,$f14,only_10_digits  ###### when we have only 10 digits
nop

add $t5,$t3,$zero  ###safe place for the 10th digit


mul.s $f18,$f1,$f28  ## (float_result*new_base)

mov.s $f16,$f18 ## to keep the value of mul in f16

cvt.w.s $f18, $f18
mfc1 $t5,$f18   ####int_result




blt $t5,$t1,only_10_digits
nop

addi $a2,$s3,-1 ##if the tenth_digit = new base -1=$a2
beq $t3,$a2,only_10_digits
nop

addi $t3,$t3,1



j only_10_digits

nop

#################################################################

your_value_is_zero:

li $v0,4
la $a0,zero
syscall


li $v0,10   ##EXIT
syscall
#################################################################
