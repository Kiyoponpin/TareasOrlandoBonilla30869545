.data
buffer:        .space 1024     # Buffer de 1KB
buffer_tam:    .word 1024      # Tamaño del buffer
cabecera:      .word 0         # Puntero de escritura
cola:          .word 0         # Puntero de lectura
tiempo:        .word 20000     # 20 segundos (20,000 ms)

fin_tiempo:    .asciiz "\nTiempo completado. Contenido del buffer:\n"
otra_linea:    .asciiz "\n"

.text
.globl main

main:
    # Inicialización
    la $s0, buffer          # $s0 = dirección base del buffer
    lw $s1, buffer_tam     # $s1 = tamaño del buffer
    sw $zero, cabecera          # Reiniciar head a 0
    sw $zero, cola          # Reiniciar tail a 0
    lw $s4, tiempo        # $s4 = intervalo de tiempo
    
contar:
    # Obtener tiempo actual
    li $v0, 30
    syscall
    move $t0, $a0           # $t0 = tiempo de inicio
    
entrada:
    # Comprobar tiempo transcurrido
    li $v0, 30
    syscall
    sub $t1, $a0, $t0
    bge $t1, $s4, imprimir_buffer
    
    # Intentar leer carácter directamente (sin check previo)
    li $v0, 12              # Syscall 12: read character
    syscall
    blez $v0, entrada    # Si no hay carácter, continuar
    
    move $t2, $v0           # $t2 = carácter leído
    
    # Filtrar caracteres no deseados (opcional)
    beq $t2, '\n', entrada  # Ignorar newline
    beq $t2, '\r', entrada  # Ignorar carriage return
    
    # Almacenar en buffer circular
    lw $t3, cabecera            # Cargar head actual
    add $t4, $s0, $t3       # $t4 = dirección de escritura
    sb $t2, 0($t4)          # Almacenar carácter
    
    # Actualizar head
    addi $t3, $t3, 1
    blt $t3, $s1, sin_intercambio
    li $t3, 0
sin_intercambio:
    sw $t3, cabecera            # Guardar nuevo head
    
    j entrada
    
imprimir_buffer:
    # Imprimir mensaje
    li $v0, 4
    la $a0, fin_tiempo
    syscall
    
    # Imprimir contenido
imprimir_ciclo:
    lw $t3, cola
    lw $t4, cabecera
    beq $t3, $t4, fin_imprimir
    
    add $t5, $s0, $t3       # Dirección de lectura
    lb $a0, 0($t5)          # Cargar carácter
    
    # Imprimir carácter
    li $v0, 11
    syscall
    
    # Actualizar tail
    addi $t3, $t3, 1
    blt $t3, $s1, int_ultimos_dos
    li $t3, 0
int_ultimos_dos:
    sw $t3, cola
    
    j imprimir_ciclo
    
fin_imprimir:
    # Nueva línea
    li $v0, 4
    la $a0, otra_linea
    syscall
    
    j contar
