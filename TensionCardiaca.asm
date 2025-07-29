.data
    msg_inicio:    .asciiz "Iniciando medición de tensión arterial...\n"  # Mensaje inicial
    msg_espera:    .asciiz "Esperando resultados...\n"                   # Mensaje de espera
    msg_resultado: .asciiz "Resultados:\nSistólica: "                    # Encabezado resultado sistólica
    msg_barra:     .asciiz " / "                                         # Separador
    msg_diastolica:.asciiz "\nDiastólica: "                              # Encabezado diastólica
    msg_error:     .asciiz "Error en la medición\n"                      # Mensaje de error
    
    # Direcciones de memoria para control del dispositivo
    TensionControl: .word 0xFFFF0020   # Registro de control
    TensionEstado:  .word 0xFFFF0024   # Registro de estado
    TensionSistol:  .word 0xFFFF0028   # Registro valor sistólico
    TensionDiastol: .word 0xFFFF002C   # Registro valor diastólico

.text
main:
    # Mostrar mensaje de inicio
    la $a0, msg_inicio    # Carga dirección del mensaje
    li $v0, 4             # Código para imprimir string
    syscall               # Ejecuta llamada al sistema
    
    # Llamar al controlador de tensión
    jal controlador_tension
    
    # Verificar si hubo error (v0 < 0)
    bltz $v0, error_medicion
    
    # Mostrar resultados si no hay error
    la $a0, msg_resultado  # Carga encabezado de resultados
    li $v0, 4
    syscall
    
    # Mostrar valor sistólico (v0)
    move $a0, $v0         # Mueve valor a $a0
    li $v0, 1             # Código para imprimir entero
    syscall
    
    # Mostrar barra separadora
    la $a0, msg_barra
    li $v0, 4
    syscall
    
    # Mostrar valor diastólico (v1)
    move $a0, $v1
    li $v0, 1
    syscall
    
    j exit                # Terminar programa

error_medicion:
    # Manejo de error
    la $a0, msg_error     # Carga mensaje de error
    li $v0, 4
    syscall

exit:
    # Salir del programa
    li $v0, 10            # Código para exit
    syscall

controlador_tension:
    # Mostrar mensaje de espera
    la $a0, msg_espera
    li $v0, 4
    syscall
    
    # Iniciar medición (escribir 1 en registro de control)
    lw $t0, TensionControl  # Carga dirección de control
    li $t1, 1              # Valor para iniciar medición
    sw $t1, 0($t0)         # Escribe en registro
    
    # Esperar a que esté listo (polling)
    espera:
        lw $t0, TensionEstado  # Carga dirección de estado
        lw $t1, 0($t0)        # Lee estado
        beq $t1, 0, espera    # Si estado == 0, sigue esperando
    
    # Leer valores sistólico y diastólico
    lw $t0, TensionSistol     # Carga dirección valor sistólico
    lw $v0, 0($t0)            # Lee valor
    
    lw $t0, TensionDiastol    # Carga dirección valor diastólico
    lw $v1, 0($t0)            # Lee valor
    
    jr $ra                    # Retorna al llamador