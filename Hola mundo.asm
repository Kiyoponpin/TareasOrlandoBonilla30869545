.data 

hola: .asciiz "Hola mundo"

.text

main:

  li $v0, 4

  la $a0, hola

  syscall 

  li $v0, 10

  syscall
