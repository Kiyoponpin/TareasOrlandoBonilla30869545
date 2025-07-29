.data
    temp_init: .asciiz "Inicializando sensor...\n"       # Mensaje de inicialización
    temp_ready: .asciiz "Sensor listo. Temperatura: "   # Mensaje de éxito
    temp_error: .asciiz "Error en sensor\n"             # Mensaje de error
    SensorControl: .word 0xFFFF0010                     # Dirección de control del sensor
    SensorEstado: .word 0xFFFF0014                      # Dirección de estado del sensor
    SensorDatos: .word 0xFFFF0018                       # Dirección de datos del sensor

.text
main:
    # Imprimir mensaje de inicialización
    la $a0, temp_init       # Carga dirección del mensaje
    li $v0, 4               # Código de syscall para imprimir string
    syscall                 # Ejecuta la llamada al sistema
    
    # Inicializar y leer sensor
    jal InicializarSensor   # Llama a la función de inicialización
    jal LeerTemperatura    # Llama a la función para leer temperatura
    
    # Verificar si hubo error
    beq $v1, -1, error     # Si $v1 = -1, salta a 'error'
    j mostrar_temp         # Si no, salta a 'mostrar_temp'  
    
error:
    # Manejo de error
    la $a0, temp_error     # Carga mensaje de error
    li $v0, 4              # Syscall para imprimir string
    syscall                # Ejecuta
    j end                  # Salta al final del programa

mostrar_temp:
    # Mostrar temperatura leída
    move $t2, $v0          # Guarda el valor de temperatura en $t2
    
    # Imprime mensaje de éxito
    la $a0, temp_ready    # Carga dirección del mensaje
    li $v0, 4             # Syscall para imprimir string
    syscall               # Ejecuta
    
    # Imprime el valor de temperatura
    move $a0, $t2         # Mueve el valor a $a0 para imprimir
    li $v0, 1             # Syscall para imprimir entero
    syscall               # Ejecuta

end:
    # Termina el programa
    li $v0, 10            # Syscall para exit
    syscall               # Ejecuta

InicializarSensor:
    # Configura el sensor para lectura
    lw $t0, SensorControl  # Carga dirección de control
    li $t1, 0x2            # Valor de inicialización (ej: encender sensor)
    sw $t1, 0($t0)         # Escribe en registro de control
    jr $ra                 # Retorna al llamador

LeerTemperatura:
    # Verifica estado del sensor
    lw $t0, SensorEstado   # Carga dirección de estado
    lw $t1, 0($t0)        # Lee estado del sensor
    beq $t1, -1, error_sensor  # Si estado = -1, hay error
    beq $t1, 0, no_listo       # Si estado = 0, sensor no listo
    
    # Si el sensor está listo, lee datos
    lw $t0, SensorDatos   # Carga dirección de datos
    lw $v0, 0($t0)        # Lee temperatura
    li $v1, 0             # Retorna éxito ($v1 = 0)
    jr $ra                # Retorna al llamador
    
no_listo:
    # Sensor no está listo
    li $v0, 0             # Valor de temperatura = 0 (no válido)
    li $v1, -1            # Retorna error ($v1 = -1)
    jr $ra                # Retorna
    
error_sensor:
    # Error en el sensor
    li $v0, 0             # Valor de temperatura = 0 (no válido)
    li $v1, -1            # Retorna error ($v1 = -1)
    jr $ra                # Retorna