.data
entrada: .asciiz "Ingrese n: "
result: .asciiz "Fibonacci(n) = "

.text
.globl main

main:
    
    li $v0, 4
    la $a0, entrada
    syscall

    li $v0, 5
    syscall
    move $a0, $v0 

   
    jal fibo_recursivo

    move $t0, $v0

    li $v0, 4
    la $a0, result
    syscall

    li $v0, 1
    move $a0, $t0 
    syscall

    li $v0, 10
    syscall

fibo_recursivo:
   
    beqz $a0, fibo

    li $v0, 1             
    beq $a0, 1, f_fibo  
    
    addi $sp, $sp, -12   
    sw $ra, 0($sp)       
    sw $a0, 4($sp)        

    addi $a0, $a0, -1     
    jal fibo_recursivo   
    sw $v0, 8($sp)        

    lw $a0, 4($sp)       
    addi $a0, $a0, -2     
    jal fibo_recursivo    
    

    lw $t0, 8($sp)        
    add $v0, $t0, $v0     

    lw $ra, 0($sp)             
    addi $sp, $sp, 12     

    j f_fibo          

fibo:
    li $v0, 0             
    j f_fibo            

f_fibo:
    jr $ra  