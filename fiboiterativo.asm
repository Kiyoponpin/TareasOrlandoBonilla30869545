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
    
    jal fibo
    
    move $t0, $v0
    li $v0, 4
    la $a0, result
    syscall
    li $v0, 1
    move $a0, $t0
    syscall
    li $v0, 10
    syscall

fibo:
    li $v0, 1
    ble $a0, 1, f_fibo
    
    li $t0, 0
    li $t1, 1
    li $t2, 2
    
ciclo:
    add $t3, $t0, $t1
    move $t0, $t1
    move $t1, $t3
    addi $t2, $t2, 1
    ble $t2, $a0, ciclo
    
    move $v0, $t1
    
f_fibo:
    jr $ra