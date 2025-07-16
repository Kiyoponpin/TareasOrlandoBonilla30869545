.data
vector:     .word   5, 1, 7, 4, 9    # Vector a ordenar
tam:       .word   5                 # Tamaño del vector
espacio:      .asciiz " "            # Espacio para separar números
n_linea:    .asciiz "\n"             # Salto de línea

.text
.globl main

main:
    # Ordenar el vector
    la      $a0, vector
    lw      $a1, tam
    jal     selection_sort
    
    # Imprimir vector ordenado
    la      $a0, vector
    lw      $a1, tam
    jal     mostrar_vector
    
    # Terminar programa
    li      $v0, 10
    syscall

# Subrutina selection_sort
# $a0: dirección del vector
# $a1: tamaño del vector
selection_sort:
    addi    $sp, $sp, -16     # Guardar registros en la pila
    sw      $ra, 12($sp)
    sw      $s2, 8($sp)
    sw      $s1, 4($sp)
    sw      $s0, 0($sp)
    
    move    $s0, $a0          # $s0 = dirección del vector
    move    $s1, $a1          # $s1 = tamaño del vector
    li      $t0, 0            # $t0 = i = 0
    
ciclo1:
    addi    $t1, $t0, 1       # $t1 = j = i + 1
    move    $t2, $t0          # $t2 = min = i
    
    # Calcular dirección de vector[i]
    sll     $t3, $t0, 2       # $t3 = i * 4
    add     $t3, $s0, $t3     # $t3 = dirección de vector[i]
    lw      $s2, 0($t3)       # $s2 = vector[i] (valor mínimo actual)
    
ciclo2:
    bge     $t1, $s1, f_ciclo_2  # Si j >= tam, terminar ciclo2
    
    # Calcular dirección de vector[j]
    sll     $t4, $t1, 2        # $t4 = j * 4
    add     $t4, $s0, $t4      # $t4 = dirección de vector[j]
    lw      $t5, 0($t4)        # $t5 = vector[j]
    
    bge     $t5, $s2, omitir   # Si vector[j] >= mínimo actual, saltar
    move    $t2, $t1           # min = j
    move    $s2, $t5           # mínimo actual = vector[j]
    
omitir:
    addi    $t1, $t1, 1        # j++
    j       ciclo2
    
f_ciclo_2:
    beq     $t2, $t0, no_intercambio  # Si min == i, no intercambiar
    
    # Intercambiar vector[i] y vector[min]
    sll     $t3, $t0, 2        # $t3 = i * 4
    add     $t3, $s0, $t3      # $t3 = dirección de vector[i]
    lw      $t6, 0($t3)        # $t6 = vector[i]
   
    sll     $t4, $t2, 2        # $t4 = min * 4
    add     $t4, $s0, $t4      # $t4 = dirección de vector[min]
    lw      $t7, 0($t4)        # $t7 = vector[min]
    
    sw      $t7, 0($t3)        # vector[i] = $t7
    sw      $t6, 0($t4)        # vector[min] = $t6
    
no_intercambio:
    addi    $t0, $t0, 1        # i++
    addi    $t8, $s1, -1       # $t8 = tam - 1
    blt     $t0, $t8, ciclo1 # Si i < tam-1, continuar ciclo1
    
    lw      $s0, 0($sp)        # Restaurar registros de la pila
    lw      $s1, 4($sp)
    lw      $s2, 8($sp)
    lw      $ra, 12($sp)
    addi    $sp, $sp, 16
    jr      $ra

# Subrutina mostrar_vector
# $a0: dirección del vector
# $a1: tamaño del vector
mostrar_vector:
    move    $t0, $a0           # $t0 = dirección del vector
    move    $t1, $a1           # $t1 = tamaño del vector
    li      $t2, 0             # $t2 = índice (i)
    
ciclo_imprimir:
    bge     $t2, $t1, f_imprimir  # Si i >= tam, terminar
    
    # Calcular dirección de vector[i] y cargar valor
    sll     $t3, $t2, 2        # $t3 = i * 4
    add     $t3, $t0, $t3      # $t3 = dirección de vector[i]
    lw      $a0, 0($t3)        # $a0 = vector[i]
    
    # Imprimir número
    li      $v0, 1
    syscall
    
    # Imprimir espacio (excepto después del último elemento)
    addi    $t4, $t2, 1        # i+1
    bge     $t4, $t1, prox  # Si es el último elemento, saltar
    
    li      $v0, 4
    la      $a0, espacio
    syscall
    
prox:
    addi    $t2, $t2, 1        # i++
    j       ciclo_imprimir
    
f_imprimir:
    # Imprimir nueva línea al final
    li      $v0, 4
    la      $a0, n_linea
    syscall
    jr      $ra