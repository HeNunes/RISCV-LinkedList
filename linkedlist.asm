# Enzo Nunes Sedenho - 13671810
# Gabriel da Costa Merlin - 12544420
# João Pedro Mori Machado - 13671831
# Pedro Augusto Monteiro Delgado - 13672766
	
	.data
	.align 0
str_pede_num: .asciz "Digite o numero de nos da lista (minimo de 5): "
str_pede_str: .asciz "Escreva uma frase (so serao salvos 27 caracteres): "
str_seta: .asciz " -> "
	.align 2
p_lista: .word					# Ponteiro para a lista encadeada, o qual na parte estetica dos dados

	.text
	.align 2
	.globl main
	
main:
	addi a7, zero, 4				# Imprimindo str_pede_num
	la a0, str_pede_num
	ecall

	addi s0, zero, 5				# Minimo de nos na lista sera 5
	
	addi a7, zero, 5				# Lendo numero de nos escolhido pelo usuario
	ecall

	blt a0, s0, main				# Caso o numero de nos seja menor que 5, pedimos novamente

	add s1, zero, a0				# Salvando o numero do usuario
	
	addi t0, zero, 0				# Guardando o numero 0 nos contadores
	addi t1, zero, 0
	
	addi a7, zero, 9				# Alocando 36 bytes (1 no) de memoria na Heap
	addi a0, zero, 36
	ecall
	
	la t2, p_lista				#  Ponteiro para inicio da lista sera o enderero do primeiro no alocado
	sw a0, 0(t2)
	
	la t2, p_lista				# Recuperando ponteiro para o primeiro no
	lw s2, 0(t2)
	
	add a1, zero, s2
	add a2, zero, t0
	jal inicializa_no
			
	addi t0, t0, 1				# Incrementando o contador do loop
		
loop_alocacao:
	beq t0, s1, imprimir			# Contador do loop == Quantidade de nos

	addi a7, zero, 9				# Alocando 36 bytes (1 no) de memoria na Heap
	addi a0, zero, 36
	ecall
	
	sw a0, 32(s2)				# Atualizando o p_prox do no alocado
	add s2, zero, a0				# Atualizando o ponteiro auxiliar (S2) que aponta para o ultimo no
	
	add a1, zero, s2
	add a2, zero, t0
	jal inicializa_no
    	
    	addi t0, t0, 1				# Incrementando o contador do loop
    	
    	j loop_alocacao
    		
imprimir:
	la t2, p_lista				# Recuperando ponteiro para o primeiro no
	lw s2, 0(t2)
	
	add a1, zero, s2
	jal imprime_no
	
	addi t1, t1, 1				# Incrementando o contador do loop

loop_imprimir: 
	beq t1, s1, encerra			# Contador do loop == Quantidade de nos
						
	lw t2, 32(s2)				# Lendo o p_prox do no alocado
	add s2, zero, t2				# Atualizando o ponteiro auxiliar (S2) que aponta para o ultimo no

	add a1, zero, s2
	jal imprime_no
			
	addi t1, t1, 1				# Incrementando o contador do loop
	
	j loop_imprimir
    	
encerra:
    	addi a7, zero, 10				# Finalizando o programa
	ecall
    	
    	
							######## FUNCOES AUXILIARES ########
							
	
inicializa_no:
	# Funcao que inicializa os campos de 1 no
	# Parametro => a1: ponteiro para o no // a2: ID do no
	# Retorno => VAZIO
	# OBS: devemos ter uma String 'str_pede_str' para melhorar interface com usuario 
	
	sw a2, 0(a1) 				# Colocando o contador como o ID do no
	
	addi a7, zero, 4				# Imprime a mensagem para o usuario
    	la a0, str_pede_str
    	ecall
	
    	addi a7, zero, 8 				# Le a entrada do usuario e armazena no no			
    	addi a0, a1, 4
    	addi a1, zero, 28 			# Tamanho maximo da string
    	ecall
    	
    	addi a1, a0, -4 				# Retornando o valor antigo ao registrador a1
    	
    	jr ra

imprime_no:
	# Funcao que imprime o ID e a String de um no
	# Parametro => a1: ponteiro para o no
	# Retorno => VAZIO
	# OBS: devemos ter uma String 'str_seta' para melhorar interface com usuario 
	
	addi sp, sp, -4				# Colocando o valor de s0 na pilha
	sw s0, 0(sp)
	
	lw s0, 0(a1)				# Recuperando ID do no
	
	addi a7, zero, 1				# Imprimindo ID
	add a0, zero, s0
	ecall
	
	addi a7, zero, 4				# Imprimindo '->'
	la a0, str_seta
	ecall
	
	addi a7, zero, 4				# Imprimindo String do no
	addi a0, a1, 4
	ecall
	
	lw s0, 0(sp)				# Tirando o valor antigo de s0 na pilha
	addi sp, sp, 4
	
	jr ra
