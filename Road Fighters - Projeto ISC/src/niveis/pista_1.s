.data
#5 em 5(apos quantas linhas carregadas ele aparece,contador,tipo do obstaculo,ja apareceu(1(apareceu) e 0(nn apareceu))e posicao

INIMIGOS:	.word 400,0,0,0,116,600,0,1,0,148,1500,0,4,0,132,2000,0,3,0,148,2500,0,0,0,116,3000,0,1,0,132,3400,0,2,0,148,3900,0,3,0,116,4500,0,1,0,132
#0 = petroleo, 1 = carro vermelho, 2 = caminhao, 3 = carro azul, 4 = carro amarelo 

TAM:		.word 8


TAMANHO: 58
NOTAS_PISTA: 64,256,65,128,67,256,64,256,67,641,67,128,69,384,71,256,69,128,71,256,69,256,71,384,69,256,67,256,65,256,64,256,65,128,67,256,64,256,67,384,60,513,62,256,64,256,62,128,60,256,57,256,60,513,67,384,65,256,64,256,65,128,67,256,64,256,67,513,65,128,67,256,69,256,71,256,69,128,71,256,69,256,71,384,72,256,75,256,74,256,72,256,69,384,60,256,64,256,62,128,60,513,62,256,67,256,65,128,64,256,65,256,67,641,65,513		
CONTADOR.NOTA:	.word 0

POSICAO_FUTURA:	.word 116,0
TEMPO.POSICAO:	.word 0

POSICAO_CARRINHO: .half 10,200

.include "../../images/pistas/pista1.data"
.include "../../images/pistas/pista_inicio.data"
.include "../../images/pistas/pista_final.data"

.include "../../images/carro/carro.data"
.include "../../images/carro/explosao1.data"
.include "../../images/carro/explosao2.data"
.include "../../images/carro/explosao3.data"
.include "../../images/carro/rodando1.data"
.include "../../images/carro/rodando2.data"
.include "../../images/carro/rodando3.data"
.include "../../images/carro/rodando4.data"
.include "../../images/carro/rodando5.data"
.include "../../images/carro/rodando6.data"
.include "../../images/carro/rodando7.data"
.include "../../images/carro/carrinho_pequeno.data"
.include "../../images/carro/bloco_cinza.data"

.include "../../images/obstaculos/buraco.data"
.include "../../images/obstaculos/caminhao.data"
.include "../../images/obstaculos/carroamarelo.data"
.include "../../images/obstaculos/carroazul.data"

.text
SETUP_PISTA:		

		

		la a0,pista_inicio		# carrega o endereco do sprite 'map' em a0
		li a1,0				# x = 0
		li a2,0				# y = 0
		li a3,0				# frame = 0
		call PRINT_PISTA		# imprime a pista 
		li a3,1				# frame = 1
		call PRINT_PISTA		# imprime a pista
		lw s0,0(a0)			#carrega em s0 o numero de colunas
		lw s1,4(a0)			#carrega em s1 o numero de linhas
		
		la a0,carro
		li a1,116			#x = 120
		li a2,184			#y = 184
		li a3,0	
		mv s3,a1			#s3 = x
		mv s4,a2			#s4 = y
		call PRINT_PISTA		#imprime o carro
	
		
		la a0,carrinho_pequeno
		li a1,10			
		li a2,200			
		li a3,0	
		call PRINT_PISTA
		li a3,1
		call PRINT_PISTA
		
		li a7,32
		li a0,1000
		ecall
		
		li t0,0
		li t1,3
		
TRES.DOIS.UM:
		li a0,60
		li a1,550
		li a2,80
		li a3,100
		li a7,33
		ecall
	
		li a7,32
		li a0,500
		ecall
	
		addi t0,t0,1
		bne t0,t1,TRES.DOIS.UM
		
		
		li a0,75
		li a1,700
		li a3,127
		li a7,33
		ecall		
		
		
		
		li s2,0				#zera s2( s2 sera o contador de linhas) 
		li s6,239			#s6 = numero de penultima linha(a ultima � uma linnha preta)
		
		
		li s5,0				#s5 guarda o frame
		
		li s7,0				#contador de refresh
		
		
		li a7,30
		ecall
		mv s8,a0
		
		li s9,10

TEMPO:
		li a2,3
		li a3,127
		call PLAY_SONG_PISTA
		
		li t0,0xFF200604		# carrega em t0 o endereco de troca de frame
		sw s5,0(t0)

		li a7,30
		ecall
		
		mv t0,a0
		
		sub t1,t0,s8
		
		blt t1,s9,TEMPO
		li a7,30
		ecall
		mv s8,a0
		
		
LOOP:		
		call KEY_PISTA		#verifica se uma tecla foi pressionada
		
		
		li t0,0xFF200604		# carrega em t0 o endereco de troca de frame
		sw s5,0(t0)
		
		beq s2,s1,PRIMEIRA_LINHA #caso ja tenha desenhado todos as linhas menos a primeira
		
		sub a0,s1,s2		#a0 recebe o numero da linha de baixo
		mv a1,s5		#a1 recebe frame s5
		li a2,32		#a2 = coluna
		call ENDERECO		#retorna endere�o da linha de baixo
		mv a3,a0		#a3 recebe o endereco da linha de baixo no frame 0
		
		sub a0,s1,s2		#a0 recebe o numero da linha de baixo
		xori t0,s5,1
		mv a1,t0		#a0 recebe frame 1
		li a2,32		#a2 = coluna
		call ENDERECO		#retorna endere�o da linha de baixo no frame 1
		mv a4,a0		#a4 recebe o endereco da linha de baixo no frame 1
		
		addi s2,s2,1		#incrementa s2
		sub a0,s1,s2		#a0 recebe o numero da linha de cima
		xori t0,s5,1
		mv a1,t0		#a1 recebe frame 1
		li a2,32		#a2 = coluna
		call ENDERECO		#retorna endere�o da linha de cima no frame 1
		mv a5,a0		#a5 recebe o endere�o da linha de cima no frame 1
		
		mv a0,a3		#endereco da linha de baixo frame 0
		mv a1,a4		#endereco da linha de baixo frame 1
		mv a2,a5		#endereco da linha de cima no frame 1
		li a3,160		#a3 = coluna de parada
		
		
		call SET_DESENHA	#desenha os pixeis da linha de cima na de baixo
FIM.LOOP:	j LOOP
		
FIM.JOGO:	
		li a7,32
		li a0,5000
		ecall
		
		call SETUP_PISTA_2
		
ANDA_CARRINHO:
		la a0, POSICAO_CARRINHO
		lh a2, 2(a0)
		
		
		addi a2, a2, -1
		sh a2, 2(a0)
		
		la a0,carrinho_pequeno
		li a1, 10
		li a3, 0
		call PRINT_PISTA
		
		li a3,1
		call PRINT_PISTA
		
		la a0,bloco_cinza
		addi a2, a2, 16
		li a3, 0
		call PRINT_PISTA
		
		li a3,1
		call PRINT_PISTA
		
		
		j RETORNA_CARRINHO
		
		
PRIMEIRA_LINHA:

		li a0,0
		xori t0,s5,1
		mv a1,t0
		li a2,32		#a2 = coluna
		call ENDERECO		#retorna o endere�o da primeira linha do frame 0
		mv a3,a0		#guarda o endere�o em a3
		
		li a0,0
		mv a1,s5
		li a2,32		#a2 = coluna
		call ENDERECO		#retorna o endere�o da primeria linha no frame 1
		mv a1,a3		#a0=frame 0, a1=frame 1
		
		
		li t0,5000
		bge s7,t0,CHEGADA
		
		la a2,pista1
		mv a3,s6
		call SET_STORE
		
CHEGADA:	la a2,pista_final
		mv a3,s6
		call SET_STORE
		
		li t0,5240
		bge s7,t0,FIM.JOGO	  
		
		
		
		
		bgtz s6,MEIO
		li s6,240
		
MEIO:		li s2,0

		addi s6,s6,-1
		
		
		la t0,POSICAO_FUTURA
		lw t0,0(t0)
		#beq s3,t0,PERCORRE
		
		sub t1,t0,s3		#t1 = posicao futura - posicao atual
		bgtz t1,DIR
		bltz t1,ESQ
		
		la t0,POSICAO_FUTURA
		li t1,0
		sw t1,4(t0)
		
		
		
		jal zero,PERCORRE
		
		
DIR:		call MOVE.DIR
		jal zero,PERCORRE		
		
ESQ:		call MOVE.ESQ
		jal zero,PERCORRE
		
		
		
		
		#se prepara para chamar INIMIGO
PERCORRE:	li a5,0			#contador de inimigos
		
LOOP.PERCORRE:	li a0,0
		mv a1,s5
		
		la t0,INIMIGOS
		li t2,20
		mul t3,t2,a5
		add t0,t0,t3
		
		
		lw a2,16(t0)
		
		
		call ENDERECO
		
		mv a3,a0
		
		li a0,0
		xori a1,s5,1
		call ENDERECO
		
		mv a1,a0		#a1 recebe endere�o da linha 1 em um frame
		mv a0,a3		#a0 recebe endere�o do outro frame
		la t0, carro		
		lw a2,0(t0)		#a2 = numero de colunas do carro
		lw a3,4(t0)		#a3 = numero de linhas do carro
		mv a4,s7		#a4 = contador de refresh
		
		call INIMIGO
		addi a5,a5,1
		la t0,TAM
		lw t0,0(t0)
		bne a5,t0,LOOP.PERCORRE
		
		
		
		la t0,INIMIGOS
		li t2,0

LOOP.BATEU:	lw t1,12(t0)
		beqz t1,FIM_PRIMEIRA
		
		lw t1,4(t0)		#t1 recebe o contador de INIMIGOS
		addi t1,t1,1
		sw t1,4(t0)		#soma 1 ao contador do carro inimigo
		
		
		bne s4,t1,NBATEU
		lw t1,16(t0)
		
		addi t2,t1,8
		bgt s3,t2,NBATEU
		
		addi t2,t1,-8
		blt s3,t2,NBATEU
		
		
		
		j REDIRECIONA_REACAO

		
		
NBATEU:		addi t0,t0,20
		addi t2,t2,1
		la t3,TAM
		lw t3,0(t3)
		bne t2,t3,LOOP.BATEU
		j FIM_PRIMEIRA
	
REDIRECIONA_REACAO:
		lw t1, 8(t0)
		beqz t1, CARRO_RODANDO
		
		
		la t0,POSICAO_FUTURA
		li t1,1
		sw t1,4(t0)
		
		la t0,POSICAO_FUTURA
		li t1,170
		sw t1,0(t0)
		
		call MOVE.DIR
		jal zero,NBATEU				
	
		
		
		
FIM_PRIMEIRA:	addi s7,s7,1

		li t0,30
		rem t0, s7, t0
		
		beqz t0, ANDA_CARRINHO
RETORNA_CARRINHO:
		
		li t0,2
		beq t0,s9,TEMPO
		li t0,80
		rem t1,s7,t0
		bnez t1,TEMPO
		addi s9,s9,-1
				
		
		jal zero,TEMPO
				
							
ENDERECO:	
		#aqui eh carregado o endere�o da linha a0 na coluna a2 no frame a1
		li t0,0xff0
		add t0,t0,a1
		slli t0,t0,20			#carrega em t0 o endereco base do frame a1
		li t1,320			#carrega em t1 320
		mul t3,a0,t1			#carrega em t3 a linha*320
		li t4,0				#zera t4
		add t4,t0,t3			#carrega em t4 o endere�o base do frame a1 + linha*320
		add t4,t4,a2			#soma a t4 a coluna inicial
		mv a0,t4			#a0 = endere�o da linha
		ret
						
REDIRECIONA_IMAGEM:
IMAGEM_BURACO:

		lw t4, 8(t3)

		li t1, 0
		bne t4, t1, IMAGEM_VERMELHO

		la t1, buraco
		
		lw a2, 0(t1)
		lw a3,4(t1)
		mul t0,a2,t0			#multiplica o numero de colunas pelo numero da linha
		
		
		add t1,t1,t0			#coloca t1 no pixel de come�o
		li t3,0
		j TESTE.LINHA	
		
IMAGEM_VERMELHO:
		lw t4, 8(t3)
		
		li t1, 1
		bne t4, t1, IMAGEM_CAMINHAO
		
		la t1, carro
		
		lw a2, 0(t1)
		lw a3,4(t1)
		mul t0,a2,t0
		
		
		add t1,t1,t0		
		li t3,0
		j TESTE.LINHA
				
IMAGEM_CAMINHAO:
		lw t4, 8(t3)

		li t1, 2
		bne t4, t1, IMAGEM_AZUL
		
		la t1, caminhao
		
		lw a2, 0(t1)
		lw a3,4(t1)
		mul t0,a2,t0
		
		
		add t1,t1,t0	
		li t3,0
		j TESTE.LINHA
		
IMAGEM_AZUL:			
		lw t4, 8(t3)
		
		li t1, 3
		bne t4, t1, IMAGEM_AMARELO 
		
		la t1, carroazul
		
		lw a2, 0(t1)
		lw a3,4(t1)
		mul t0,a2,t0
		
		
		add t1,t1,t0
		li t3,0
		j TESTE.LINHA
		
IMAGEM_AMARELO:	
		la t1, carroamarelo
		
		lw a2, 0(t1)
		lw a3,4(t1)
		mul t0,a2,t0
		
		
		add t1,t1,t0
		li t3, 0 
		j TESTE.LINHA



INIMIGO:	
TESTE.TEMPO:	
		la t3,INIMIGOS
		li t4,20
		mul t4,t4,a5
		add t3,t3,t4
		
		lw t4,0(t3)
		blt a4,t4,FIM_INIMIGO		#testa se ja se passou o tempo necessario
		
		
		li t0,1
		sw t1,12(t3)			#diz que  carro ja apareceu
		
		lw t4,4(t3)
		lw a4,4(t3)	
		
	
		lw t0,4(t3)

		j REDIRECIONA_IMAGEM
		
		
TESTE.LINHA:	bge a4,a3,FIM_INIMIGO	


LOOP.INIMIGO:	
		
		lw t2,8(t1)			#carrega em t2 4 pixeis da linha do carro
		sw t2,0(a0)
		sw t2,0(a1)
		
		addi t1,t1,4
		addi a0,a0,4
		addi a1,a1,4
		addi t3,t3,4
		beq a2,t3,FIM_INIMIGO
		jal zero, LOOP.INIMIGO

FIM_INIMIGO:	ret







#aqui eh desenhado o que esta no endere�o a2 em a1 e a0	
SET_DESENHA:	li t0,0				#t0 = contador
					
DESENHA:	addi t1,t0,32
		beq s3,t1,SET_CARRO		#caso tenha chegado na coluna do carro
VOLTA:		lh t1,0(a2)			#carrega 4 pixeis da linha de cima em t0
		sh t1,0(a1)			#desenha os 4 pixeis de t0 em a1(linha de baixo)
		sh t1,0(a0)
		addi a0,a0,2			#pula 4 pixeis
		addi a1,a1,2			#pula 4 pixeis
		addi a2,a2,2			#pula 4 pixeis
		addi t0,t0,2			#incrementa o contador de colunas
		bgt t0,a3,FIM_DESENHA		#caso ja tenha desenhado toda a linha ele sai do loop
		jal zero,DESENHA
		
FIM_DESENHA:	ret

SET_CARRO:	
		la t3,carro
		lw t4,4(t3)			#t4 = altura do carro
		lw t3,0(t3)			#t3 = largura do carro
		li t5,56			#t5= ultima linha do carro
		bgt s2,t5,VOLTA			#caso s2 maior q a ultima linha do carro 
		sub t5,t5,t4 			#t5 recebe primeira linha do carro
		blt s2,t5,VOLTA		
		

		li t5,0
		
CAR:		lw t1,0(a2)			#carrega 4 pixeis da linha de cima em t0
		sw t1,0(a1)			#desenha os 4 pixeis de t0 em a1(linha de baixo)
		addi a0,a0,4			#pula 4 pixeis
		addi a1,a1,4			#pula 4 pixeis
		addi a2,a2,4			#pula 4 pixeis
		addi t0,t0,4			#incrementa o contador de colunas
		addi t5,t5,4
		beq t5,t3,DESENHA
		jal zero, CAR
		
		
		
		
		
		
		

#guarda tudo que esta em a2 na linha a3 em a1 e a0 	
SET_STORE:	li t0,0
		li t1,320
		mul t2,t1,a3
		add a2,a2,t2
		addi a2,a2,32

STORE:		lw t1,8(a2)
		sw t1,0(a1)
		sw t1,0(a0)
		addi a2,a2,4
		addi a1,a1,4
		addi a0,a0,4
		addi t0,t0,4
		li t1,160
		bne t0,t1,STORE
		
		
		
FIM_STORE:	ret



#a1 = frame, a3 = background
SET_FUNDO:	li t5,0			#contador de linha
		

CONTA_LINHA:	
		la t0,carro
		lw t6,4(t0)		#t6 = qtd de linhas
		beq t5,t6,FIM_FUNDO	#testa se ja leu todas as linhas
		
		
		mv a0,s4		#a0 recebe primeira linha do carro
		add a0,a0,t5		#soma em a0 quantas linhas ja foram
		xori a1,a1,1
		mv a2,s3		#guarda em a2 a coluna do carro
		addi t6,ra,0		#guarda em t6 o endere�o de retorno
		call ENDERECO
		mv ra,t6		#recebe o ra original
		mv a3,a0
		
		
		
		xori a1,a1,1
		mv a0,s4		#a0 recebe primeira linha do carro
		add a0,a0,t5		#soma em a0 quantas linhas ja foram
		mv a2,s3		#guarda em a2 a coluna do carro
		addi t6,ra,0		#guarda em t6 o endere�o de retorno
		call ENDERECO
		mv ra,t6		#recebe o ra original
		
		addi t5,t5,1		#incrementa contador de linha
		
		
		
		
		li t6,0
		
		
FUNDO:		lw t0,0(a0)
		sw t0,0(a3)
		addi a0,a0,4
		addi a3,a3,4
		addi t6,t6,4
		
		la t0,carro
		lw t1,0(t0)
		beq t6,t1,CONTA_LINHA	#testa se ja leu todas as colunas
		jal zero,FUNDO
		

FIM_FUNDO:	ret



KEY_PISTA:
		li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)			# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
   		beq t0,zero,FIM_KEY_PISTA   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  			# le o valor da tecla tecla
		
		li t0,'a'
		beq t2,t0,CARRO_ESQ		# se tecla pressionada for 'a', chama CHAR_CIMA
		
		li t0,'d'
		beq t2,t0,CARRO_DIR		# se tecla pressionada for 'd', chama CHAR_CIMA
	
FIM_KEY_PISTA:	ret


EXPLOSAO:	
		li a0,40		# define a nota
		li a1,1500		# define a dura��o da nota em ms
		li a2,127		# define o instrumento
		li a3,127		# define o volume
		li a7,31		# define o syscall
		ecall			# toca a nota
	
			
		mv a0,s4
		xori t0,s5,1
		mv a1,t0
		mv a2,s3
		call SET_FUNDO
		

		la a0,explosao1		#o que sera impresso
		mv a1,s3		#eixo x
		mv a2,s4		#eixo y
		mv a3,s5		#frame
		call PRINT_PISTA 
	
		li a0, 150		#time sleep
		li a7, 32
		ecall		

		xori s5, s5, 1

		la a0,explosao2	
		mv a1,s3		
		mv a2,s4		
		mv a3,s5		
		call PRINT_PISTA 
	
		xori s5, s5, 1
	
		li a0, 150
		li a7, 32
		ecall		

		la a0,explosao3		
		mv a1,s3		
		mv a2,s4		
		mv a3,s5		
		call PRINT_PISTA 
		
		li a0,150
		li a7, 32
		ecall
	
		mv a0,s4
		xori t0,s5,1
		mv a1,t0
		mv a2,s3
		call SET_FUNDO	
		
		li a0,150
		li a7, 32
		ecall
		
		li s3, 116
		la t0,POSICAO_FUTURA
		sw s3,0(t0)
		
		
		la a0,carro		#o que sera impresso
		mv a1,s3		#eixo x
		mv a2,s4		#eixo y
		mv a3,s5		#frame
		call PRINT_PISTA 

		jal zero,LOOP

CARRO_ESQ:	
		la t0,POSICAO_FUTURA
		addi t1,s3,-16
		sw t1,0(t0)
		li t1,0
		sw t1,4(t0)
		
			
MOVE.ESQ:	
		la t0,TEMPO.POSICAO
		lw t0,0(t0)
		li a7,30
		ecall
		sub t1,a0,t0
		li t2,30
		bltu t1,t2,FIM.ESQ
		
		li t0,100
		blt s3,t0,EXPLOSAO
		
		la t0,TEMPO.POSICAO
		sw a0,0(t0)

		mv a0,s4
		xori t0,s5,1
		mv a1,t0
		mv a2,s3
		mv a7,ra
		la a4,POSICAO_FUTURA
		lw a4,4(a4)
		
		
		
		
		call SET_FUNDO
		


		addi s3,s3,-2		#movimenta o carro em 4 posi�oes
		
		
		
		xori s5,s5,1		#troca o frame
		
		
		
		
		la a0,carro		#o que sera impresso
		mv a1,s3		#eixo x
		mv a2,s4		#eixo y
		mv a3,s5		#frame
		call PRINT_PISTA 
		
		mv ra,a7

FIM.ESQ:	ret
		
CARRO_DIR:	
		la t0,POSICAO_FUTURA
		addi t1,s3,16
		sw t1,0(t0)
		li t1,0
		sw t1,4(t0)

MOVE.DIR:	
		la t0,TEMPO.POSICAO
		lw t0,0(t0)
		li a7,30
		ecall
		sub t1,a0,t0
		li t2,30
		bltu t1,t2,FIM.DIR
		
		li t0,164
		bgt s3,t0,EXPLOSAO
		
		la t0,TEMPO.POSICAO
		sw a0,0(t0)
		

		mv a0,s4
		xori t0,s5,1
		mv a1,t0
		mv a2,s3
		mv a7,ra
		
		la a4,POSICAO_FUTURA
		lw a4,4(a4)
		
		call SET_FUNDO


		
		#addi s3,s3,4		#movimenta o carro em 4 posi�oes
		
		
		
		xori s5,s5,1		#troca o frame
		
		la a4,POSICAO_FUTURA
		lw a5,4(a4)
		
		bnez a5,RODADO
		
		
NORMAL:		la a0,carro		#o que sera impresso
		jal zero,CARRO
RODADO:		lw a5,0(a4)
		li t0,2
		sub t1,a5,s3
		beq t0,t1,NORMAL
		
		la a0,rodando2
		
CARRO:		
		addi s3,s3,2
		mv a1,s3		#eixo x
		mv a2,s4		#eixo y
		mv a3,s5		#frame
		call PRINT_PISTA 
		
		mv ra,a7

FIM.DIR:	ret
		
CARRO_RODANDO:
		mv a0,s4
		xori t0,s5,1
		mv a1,t0
		mv a2,s3
		call SET_FUNDO
		

		addi s3,s3,16		#movimenta o carro em 4 posi�oes
		la t0,POSICAO_FUTURA
		sw s3,0(t0)
		
		li t0, 164
		bge s3,t0,EXPLOSAO
		
		
		la a0,rodando1		
		mv a1,s3		
		mv a2,s4	
		mv a3,s5	
		call PRINT_PISTA		
	
		li a0, 50
		li a7, 32
		ecall
		
		mv a0,s4
		xori t0,s5,1
		mv a1,t0
		mv a2,s3
		call SET_FUNDO
		
		 
		la a0,rodando2	
		mv a1,s3		
		mv a2,s4	
		mv a3,s5	
		call PRINT_PISTA
	
		li a0, 50
		li a7, 32
		ecall
		
		mv a0,s4
		xori t0,s5,1
		mv a1,t0
		mv a2,s3
		call SET_FUNDO
		
	 
	  	la a0,rodando3		
		mv a1,s3		
		mv a2,s4	
		mv a3,s5	
		call PRINT_PISTA
		
		li a0, 50
		li a7, 32
		ecall
		
		mv a0,s4
		xori t0,s5,1
		mv a1,t0
		mv a2,s3
		call SET_FUNDO	
		
		 
		la a0,rodando4		
		mv a1,s3		
		mv a2,s4	
		mv a3,s5	
		call PRINT_PISTA
	
		li a0, 50
		li a7, 32
		ecall
		
		mv a0,s4
		xori t0,s5,1
		mv a1,t0
		mv a2,s3
		call SET_FUNDO
		

		la a0,rodando5		
		mv a1,s3		
		mv a2,s4	
		mv a3,s5	
		call PRINT_PISTA	
	
		li a0, 150
		li a7, 32
		ecall
		
		mv a0,s4
		xori t0,s5,1
		mv a1,t0
		mv a2,s3
		call SET_FUNDO
		
		
		la a0,rodando6		
		mv a1,s3		
		mv a2,s4	
		mv a3,s5	
		call PRINT_PISTA		
	
		li a0, 50
		li a7, 32
		ecall
		
		mv a0,s4
		xori t0,s5,1
		mv a1,t0
		mv a2,s3
		call SET_FUNDO
		
		
		la a0,rodando7		
		mv a1,s3		
		mv a2,s4	
		mv a3,s5	
		call PRINT_PISTA
		
	
		li a0, 50
		li a7, 32
		ecall	
		
		mv a0,s4
		xori t0,s5,1
		mv a1,t0
		mv a2,s3
		call SET_FUNDO
		
		xori s5, s5, 1
		
		la a0, carro
		mv a1, s3
		mv a2, s4
		mv a3, s5
		call PRINT_PISTA
		

		jal zero,LOOP		
		
		

PRINT_PISTA:
		li t0,0xFF0			# carrega 0xFF0 em t0
		add t0,t0,a3			#seleciona o frame
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
		
PRINT_LINHA_PISTA:
		lw t6,0(t1)			# carrega em t6 uma word (4 pixeis) da imagem
		sw t6,0(t0)			# imprime no bitmap a word (4 pixeis) da imagem
		
		addi t0,t0,4			# incrementa endereco do bitmap
		addi t1,t1,4			# incrementa endereco da imagem
		
		addi t3,t3,4			# incrementa contador de coluna
		blt t3,t4,PRINT_LINHA_PISTA	# se contador da coluna < largura, continue imprimindo

		addi t0,t0,320			# t0 += 320
		sub t0,t0,t4			# t0 -= largura da imagem
		# ^ isso serve pra "pular" de linha no bitmap display
		
		mv t3,zero			# zera t3 (contador de coluna)
		addi t2,t2,1			# incrementa contador de linha
		bgt t5,t2,PRINT_LINHA_PISTA		# se altura > contador de linha, continue imprimindo
		
		ret
		

PLAY_SONG_PISTA:
		li a7,30		#recebe tempo atual em ms
		ecall
		sub t0,a0,s11		#t0 = tempo atual - tempo quando nota foi tocada
		bgeu t0,s10,TOCA_PISTA	#se ja tiver passsado o tempo necessario ele vai para toca
		ret
		
		
TOCA_PISTA:
		la t0,CONTADOR.NOTA
		lw t0,0(t0)
		la t1,TAMANHO
		lw t1,0(t1)
		
		beq t0,t1, ZERA_CONTADOR_PISTA		# contador chegou no final? ent�o  v� para FIM
		li t2,8
		mul t2,t0,t2
		
		la t3,NOTAS_PISTA
		add t3,t3,t2
		
		lw a0,0(t3)		# le o valor da nota
		lw a1,4(t3)		# le a duracao da nota
		li a7,31		# define a chamada de syscall
		ecall			# toca a nota
		#mv a0,a1		# passa a dura��o da nota para a pausa
		#li a7,32		# define a chamada de syscal 
		#ecall			# realiza uma pausa de a0 ms
		
		
		
		mv s10,a1		#s4 recebe duracao da pausa
		li a7,30		#recebe tempo atual em ms
		ecall
		mv s11,a0		#s5 = tempo atual em ms
		
		addi t0,t0,1
		la t4,CONTADOR.NOTA
		sw t0,0(t4)
		
		ret
		
ZERA_CONTADOR_PISTA:	
		la t0,CONTADOR.NOTA
		li t1,0
		sw t1,0(t0)
		
		jal zero,TOCA_PISTA
