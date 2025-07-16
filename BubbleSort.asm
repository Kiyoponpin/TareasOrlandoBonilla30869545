.data
vector:     .word 5, 3, 8, 1, 9   #Insertamos un vector cualquiera desordenado
tam:       .word 5               #Le asignamos un tamaño
mensaje_ordenado: .asciiz "Vector ordenado: "
espacio:      .asciiz " "
nueva_linea:    .asciiz "\n"

.text
.globl main

main:
    # Ordenamos el vector
    jal bubble_sort
    
    # Imprimir vector ordenado
    la $a0, mensaje_ordenado
    li $v0, 4
    syscall
    
    jal mostrar_vector
    
    # Salir del programa
    li $v0, 10
    syscall

# Subrutina para imprimir el vector
mostrar_vector:
    la $t0, vector      # Dirección base del vector
    lw $t1, tam         # Tamaño del vector
    li $t2, 0           # Contador i=0
    
ciclo_imprimir:
    beq $t2, $t1, f_imprimir  # Si i == tam, terminar
    
    # Calcular dirección del elemento i
    sll $t3, $t2, 2      # i*4 (tamaño de palabra)
    add $t3, $t3, $t0    # Dirección de vector[i]
    
    # Imprimir elemento
    lw $a0, 0($t3)
    li $v0, 1
    syscall
    
    # Imprimir espacio
    la $a0, espacio
    li $v0, 4
    syscall
    
    # Incrementar contador
    addi $t2, $t2, 1
    j ciclo_imprimir
    
    f_imprimir:
    # Imprimir nueva línea
    la $a0, nueva_linea
    li $v0, 4
    syscall
    
    jr $ra

# Subrutina BubbleSort
bubble_sort:
    la $t0, vector       # Dirección base del vector
    lw $t1, tam         # Tamaño del vector
    addi $t1, $t1, -1    # tam-1 para el ciclo1
    li $t2, 0            # i = 0 (contador ciclo1)
    
for1:
    bge $t2, $t1, f_sort  # Si i >= tam-1, terminar
    li $t3, 0            # j = 0 (contador ciclo2)
    sub $t4, $t1, $t2    # tam-1-i (límite para j)
    
for2:
    bge $t3, $t4, f_for2  # Si j >= tam-1-i, terminar ciclo2
    
    # Calcular direcciones de vector[j] y vector[j+1]
    sll $t5, $t3, 2      # j*4
    add $t5, $t5, $t0    # Dirección de vector[j]
    addi $t6, $t5, 4     # Dirección de vector[j+1]
    
    # Cargar valores
    lw $t7, 0($t5)       # vector[j]
    lw $t8, 0($t6)       # vector[j+1]
    
    # Comparar
    ble $t7, $t8, sin_intercambio  # Si vector[j] <= vector[j+1], no intercambiar
    
    # Intercambiar valores
    sw $t8, 0($t5)
    sw $t7, 0($t6)
    
sin_intercambio:
    addi $t3, $t3, 1     # j++
    j for2
    
f_for2:
    addi $t2, $t2, 1     # i++
    j for1
    
f_sort:
    jr $ra
