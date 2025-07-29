.data
    verde:    .asciiz "Semáforo en verde, esperando pulsador (presiona 's')\n"
    pulsado:  .asciiz "\nPulsador activado: en 20 segundos, cambiará a amarillo\n"
    amarillo: .asciiz "\nSemáforo en amarillo, en 10 segundos cambiará a rojo\n"
    rojo:     .asciiz "\nSemáforo en rojo, en 30 segundos volverá a verde\n"

.text
.globl main

main:
    
    # Estado inicial: VERDE
    li $v0, 4
    la $a0, verde
    syscall

esperar_s:
    # Leer tecla (syscall 12 = read char)
    li $v0, 12
    syscall

    # Verificar si es 's' (minúscula)
    bne $v0, 's', esperar_s

    # Pulsador presionado: Cambiar a AMARILLO en 20 segundos
    li $v0, 4
    la $a0, pulsado
    syscall

    # Espera 20 segundos (simulada con syscall 32 = sleep)
    li $a0, 20000      # 20,000 ms = 20 segundos
    li $v0, 32
    syscall

    # Estado AMARILLO
    li $v0, 4
    la $a0, amarillo
    syscall

    # Espera 10 segundos
    li $a0, 10000      # 10 segundos
    li $v0, 32
    syscall

    # Estado ROJO
    li $v0, 4
    la $a0, rojo
    syscall

    # Espera 30 segundos
    li $a0, 30000      # 30 segundos
    li $v0, 32
    syscall

    # Volver a VERDE (reiniciar ciclo)
    j main
