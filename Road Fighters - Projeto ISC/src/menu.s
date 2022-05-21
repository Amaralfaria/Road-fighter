.data
CHAR_POS:	.half 104,186			# x, y
OLD_CHAR_POS:	.half 0,0			# x, y
# Numero de Notas a tocar
NUM: .word 93
# lista de nota,duração,nota,duração,nota,duração,...
NOTAS:  57,187,60,187,62,187,62,187,62,187,64,187,60,375,57,375,55,375,52,375,50,187,48,187,48,187,48,187,62,187,62,187,62,187,64,187,60,375,57,375,55,375,52,375,50,187,48,187,48,187,48,187,62,187,62,187,62,187,64,187,60,375,57,375,55,375,52,375,50,187,48,375,60,187,62,187,64,187,60,562,60,187,62,187,64,187,60,375,67,187,69,375,72,187,60,375,62,187,62,187,62,187,64,187,60,375,57,375,55,375,52,375,50,187,48,187,48,187,48,187,62,187,62,187,62,187,64,187,60,375,57,375,55,375,52,375,50,187,48,187,48,187,48,187,62,187,62,187,62,187,64,187,60,375,57,375,55,375,52,375,50,187,48,374,60,187,62,187,64,187,60,562,60,187,62,187,64,187,60,375,67,187,69,375,72,562



.text
SETUP:		
		la a0,menu			# carrega o endereco do sprite 'map' em a0
		li a1,0				# x = 0
		li a2,0				# y = 0
		li a3,0				# frame = 0
		call PRINT			# imprime o sprite
		li a3,1				# frame = 1
		call PRINT			# imprime o sprite
		# esse setup serve pra desenhar o "mapa" nos dois frames antes do "jogo" comecar
		la s1,NUM			# define o endereço do número de notas
		lw s2,0(s1)			# le o numero de notas
		la s1,NOTAS			# define o endereço das notas
		li s3,0				# zera o contador de notas
		
		li s8, 1			# já começa em 1

GAME_LOOP:	li a2,3				# define o instrumento
		li a3,127			# define o volume
		call PLAY_SONG		
		
		
		call KEY2			# chama o procedimento de entrada do teclado
		
		xori s0,s0,1			# inverte o valor frame atual (somente o registrador)
		
		la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		
		la a0,maozinha			# carrega o endereco do sprite 'char' em a0
		lh a1,0(t0)			# carrega a posicao x do personagem em a1
		lh a2,2(t0)			# carrega a posicao y do personagem em a2
		mv a3,s0			# carrega o valor do frame em a3
		call PRINT_SPRITE			# imprime o sprite
		
		li t0,0xFF200604		# carrega em t0 o endereco de troca de frame
		sw s0,0(t0)			# mostra o sprite pronto para o usuario
		
		#####################################
		# Limpeza do "rastro" do personagem #
		#####################################
		la t0,OLD_CHAR_POS		# carrega em t0 o endereco de OLD_CHAR_POS
		
		la a0,bloco_preto			# carrega o endereco do sprite 'tile' em a0
		lh a1,0(t0)			# carrega a posicao x antiga do personagem em a1
		lh a2,2(t0)			# carrega a posicao y antiga do personagem em a2
		
		mv a3,s0			# carrega o frame atual (que esta na tela em a3)
		xori a3,a3,1			# inverte a3 (0 vira 1, 1 vira 0)
		call PRINT_SPRITE			# imprime

		j GAME_LOOP			# continua o loop

KEY2:		li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)			# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
   		beq t0,zero,FIM   	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  			# le o valor da tecla tecla
		
		li t0,'1'
		beq t2,t0,CHAR_CIMA		# se tecla pressionada for 'w', chama CHAR_CIMA
		
		li t0,'2'
		beq t2,t0,CHAR_BAIXO		# se tecla pressionada for 's', chama CHAR_CIMA
		
		li t0, ' '
		beq t2, t0, REDIRECIONA_NIVEL
		
FIM:		ret				# retorna


REDIRECIONA_NIVEL:
		li t0, 1
		beq t0, s8, SETUP_PISTA
		
		li t0, 2
		beq t0, s8, SETUP_PISTA_2
		
		j GAME_LOOP



CHAR_CIMA:	la t0,CHAR_POS			#carrega em t0 o endereço de CHAR_POS
		lh t1,2(t0)			#carrega em t1 o valor da posiçao y em t1
		li t2,186			
		beq t1,t2,FIM			#se o dedo ja estiver em fase 1 ele vai para o fim
				
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS
		
		la t0,CHAR_POS
		lh t1,2(t0)			# carrega o y atual do personagem
		addi t1,t1,-16			# decrementa 16 pixeis
		sh t1,2(t0)			# salva
		
		li s8, 1			# nível selecionado
		
		ret

CHAR_BAIXO:	la t0,CHAR_POS			#carrega em t0 o endereço de CHAR_POS
		lh t1,2(t0)			#carrega em t1 o valor da posicao y em t1
		li t2,202
		beq t1,t2,FIM			#se o dedo ja estiver em fase 2 ele vai para o fim
	
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS
		
		la t0,CHAR_POS
		lh t1,2(t0)			# carrega o y atual do personagem
		addi t1,t1,16			# incrementa 16 pixeis
		sh t1,2(t0)			# salva
		
		li s8, 2			# nível selecionado
		
		ret
		

#################################################
#	a0 = endereço imagem			#
#	a1 = x					#
#	a2 = y					#
#	a3 = frame (0 ou 1)			#
#################################################
#	t0 = endereco do bitmap display		#
#	t1 = endereco da imagem			#
#	t2 = contador de linha			#
# 	t3 = contador de coluna			#
#	t4 = largura				#
#	t5 = altura				#
#################################################

PRINT:		li t0,0xFF0			# carrega 0xFF0 em t0
		add t0,t0,a3			# adiciona o frame ao FF0 (se o frame for 1 vira FF1, se for 0 fica FF0)
		slli t0,t0,20			# shift de 20 bits pra esquerda (0xFF0 vira 0xFF000000, 0xFF1 vira 0xFF100000)
		
		add t0,t0,a1			# adiciona x ao t0
		
		li t1,320			# t1 = 320
		mul t1,t1,a2			# t1 = 320 * y
		add t0,t0,t1			# adiciona t1 ao t0
		
		addi t1,a0,8			# t1 = a0 + 8
		
		mv t2,zero			# zera t2
		mv t3,zero			# zera t3
		
		lw t4,0(a0)			# carrega a largura em t4
		lw t5,4(a0)			# carrega a altura em t5
		
PRINT_LINHA:	lw t6,0(t1)			# carrega em t6 uma word (4 pixeis) da imagem
		sw t6,0(t0)			# imprime no bitmap a word (4 pixeis) da imagem
		
		addi t0,t0,4			# incrementa endereco do bitmap
		addi t1,t1,4			# incrementa endereco da imagem
		
		addi t3,t3,4			# incrementa contador de coluna
		blt t3,t4,PRINT_LINHA		# se contador da coluna < largura, continue imprimindo

		addi t0,t0,320			# t0 += 320
		sub t0,t0,t4			# t0 -= largura da imagem
		# ^ isso serve pra "pular" de linha no bitmap display
		
		mv t3,zero			# zera t3 (contador de coluna)
		addi t2,t2,1			# incrementa contador de linha
		bgt t5,t2,PRINT_LINHA		# se altura > contador de linha, continue imprimindo
		
		ret
		
PRINT_SPRITE:	li t0,0xFF0			# carrega 0xFF0 em t0
		add t0,t0,a3			# adiciona o frame ao FF0 (se o frame for 1 vira FF1, se for 0 fica FF0)
		slli t0,t0,20			# shift de 20 bits pra esquerda (0xFF0 vira 0xFF000000, 0xFF1 vira 0xFF100000)
		
		add t0,t0,a1			# adiciona x ao t0
		
		li t1,320			# t1 = 320
		mul t1,t1,a2			# t1 = 320 * y
		add t0,t0,t1			# adiciona t1 ao t0
		
		addi t1,a0,8			# t1 = a0 + 8
		
		mv t2,zero			# zera t2
		mv t3,zero			# zera t3
		
		lw t4,0(a0)			# carrega a largura em t4
		lw t5,4(a0)			# carrega a altura em t5
		
PRINT_LINHA_SPRITE:	
		lh t6,0(t1)			# carrega em t6 uma word (4 pixeis) da imagem
		sh t6,0(t0)			# imprime no bitmap a word (4 pixeis) da imagem
		
		addi t0,t0,2			# incrementa endereco do bitmap
		addi t1,t1,2			# incrementa endereco da imagem
		
		addi t3,t3,2			# incrementa contador de coluna
		blt t3,t4,PRINT_LINHA_SPRITE		# se contador da coluna < largura, continue imprimindo

		addi t0,t0,320			# t0 += 320
		sub t0,t0,t4			# t0 -= largura da imagem
						# ^ isso serve pra "pular" de linha no bitmap display
		
		mv t3,zero			# zera t3 (contador de coluna)
		addi t2,t2,1			# incrementa contador de linha
		bgt t5,t2,PRINT_LINHA_SPRITE		# se altura > contador de linha, continue imprimindo
		
		ret				# retorna
		

PLAY_SONG:	li a7,30		#recebe tempo atual em ms
		ecall
		sub t0,a0,s5		#t0 = tempo atual - tempo quando nota foi tocada
		bgeu t0,s4,TOCA		#se ja tiver passsado o tempo necessario ele vai para toca
		ret
		
		
TOCA:		beq s3,s2, ZERA_CONTADOR		# contador chegou no final? então  vá para FIM
		lw a0,0(s1)		# le o valor da nota
		lw a1,4(s1)		# le a duracao da nota
		li a7,31		# define a chamada de syscall
		ecall			# toca a nota
		#mv a0,a1		# passa a duração da nota para a pausa
		#li a7,32		# define a chamada de syscal 
		#ecall			# realiza uma pausa de a0 ms
		mv s4,a1		#s4 recebe duracao da pausa
		li a7,30		#recebe tempo atual em ms
		ecall
		mv s5,a0		#s5 = tempo atual em ms
		
		addi s1,s1,8		# incrementa para o endereço da próxima nota
		addi s3,s3,1		# incrementa o contador de notas
		ret
		
ZERA_CONTADOR:	li s3,0
		la s1,NOTAS
		jal zero,TOCA
		
.data
.include "../images/menu/maozinha.data"
.include "../images/menu/menu.data"
.include "../images/menu/bloco_preto.data"

.include "./niveis/pista_1.s"
.include "./niveis/pista_2.s"
