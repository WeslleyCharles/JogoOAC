jmp init

Msn0: string "  Voce derrotou um porco!   "
Msn1: string "  Aceitar a revanche? <s/n> "
Msn2: string "       O porco vence.       "
Msn3: string " Os porcos foram dizimados. "

Letra: var #1
tempo: var #1

;#####################################
;    ATRIBUTOS DA NAVE E DO PORCO
;#####################################

posNave: var #1
posAntNave: var #1
dirTiroNave: var #1
nVidasNave: var #1
posPorco: var #1
posAntPorco: var #1
dirTiroPorco: var #1
nVidasPorco: var #1
; #####TIRO#####
posTiroNave: var #1
posAntTiroNave: var #1
FlagTiroNave: var #1
tempoTiroPorco: var #1 
posTiroPorco: var #1
posAntTiroPorco: var #1
FlagTiroPorco: var #1

FlagJogando: var #1      ;Verifica se ainda esta jogando
nFase: var #1 ;no. da fase

IncRand: var #1
Rand : var #30   ;tabela de no. Randomicos entre 0 e 7
    static Rand + #0, #3
    static Rand + #1, #1
    static Rand + #2, #0
    static Rand + #3, #7
    static Rand + #4, #2
    static Rand + #5, #7
    static Rand + #6, #6
    static Rand + #7, #0
    static Rand + #8, #5
    static Rand + #9, #2
    static Rand + #10, #2
    static Rand + #11, #7
    static Rand + #12, #0
    static Rand + #13, #7
    static Rand + #14, #2
    static Rand + #15, #6
    static Rand + #16, #5
    static Rand + #17, #0
    static Rand + #18, #1
    static Rand + #19, #2
    static Rand + #20, #7
    static Rand + #21, #7
    static Rand + #22, #5
    static Rand + #23, #3
    static Rand + #24, #6
    static Rand + #25, #7
    static Rand + #26, #0
    static Rand + #27, #3
    static Rand + #28, #1
    static Rand + #29, #1

init:
    Loadn R1, #3
    store nVidasNave, R1

    Loadn R0, #1
    store nFase, R0


;#######Codigo principal#######
main:
    call ApagaTela
    loadn R1, #tela1Linha0
    loadn R2, #1536
    call ImprimeTela2
    
    loadn R1, #tela2Linha0
    loadn R2, #512
    call ImprimeTela2
    
    loadn R1, #tela3Linha0
    loadn R2, #2816
    call ImprimeTela2

;#########Zerar variaveis#########
    Loadn R0, #980          
    store posNave, R0
    store posAntNave, R0
    store FlagTiroNave, R0
    store posTiroNave, R0
    store posAntTiroNave, R0
    
    Loadn R0, #620
    store posPorco, R0
    store posAntPorco, R0
    store FlagTiroPorco, R0
    store posTiroPorco, R0
    store posAntTiroPorco, R0
    
    Loadn R1, #0
    store dirTiroPorco, R1
    
    call ImprimeUI
    
    loadn r1, #3
    load r2, nFase
    mod r2, r2, r1
    loadn r1, #0
    cmp r2, r1
    jne Salva_VidasPorco
    loadn r2, #3
    Salva_VidasPorco:
    store nVidasPorco, r2
    
    call SorteiaTempoTiroPorco
        
    Loadn R0, #0
    loadn R2, #0
    store FlagJogando, R0
    store dirTiroNave, R0
    
    ;#####Rotinas de movimento#####
    Loop:
    
        loadn R1, #10
        mod R1, R0, R1
        cmp R1, R2
        ceq MoveNave
    
        loadn R1, #30
        mod R1, R0, R1
        cmp R1, R2
        ceq MovePorco
    
        loadn R1, #2
        mod R1, R0, R1
        cmp R1, R2
        ceq MoveTiro 
        ceq MoveTiroPorco
    
        call Delay
        inc R0
        
        jmp Loop
    
;funcoes
MoveNave:
    push r0
    push r1
    
    call MoveNave_RecalculaPos

    load r0, posNave
    load r1, posAntNave
    cmp r0, r1
    jeq MoveNave_Skip ;so redesenha se mudou de posicao
        call MoveNave_Apaga
        call MoveNave_Desenha
  MoveNave_Skip:
    
    pop r1
    pop r0
    rts

;--------------------------------
MoveNave_Apaga:
    push R0
    push R1
    push R2
    push R3
    push R4
    push R5

    load R0, posAntNave
    loadn R1, #tela0Linha0
    add R2, R1, r0
    loadn R4, #40
    div R3, R0, R4
    add R2, R2, R3
    
    loadi R5, R2
    
    outchar R5, R0
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    pop R0
    rts
    
;####Movimentacao da nave com base nos inputs####

MoveNave_RecalculaPos:
    push R0
    push R1
    push R2
    push R3
    load R0, posNave
    inchar R1
    loadn R2, #'a'
    cmp R1, R2
    jeq MoveNave_RecalculaPos_A
    
    loadn R2, #'d'
    cmp R1, R2
    jeq MoveNave_RecalculaPos_D
        
    loadn R2, #'w'
    cmp R1, R2
    jeq MoveNave_RecalculaPos_W
        
    loadn R2, #'s'
    cmp R1, R2
    jeq MoveNave_RecalculaPos_S
    
    loadn R2, #' '
    cmp R1, R2
    jeq MoveNave_RecalculaPos_Tiro
    
    loadn R2, #'['
    cmp R1, R2
    jeq MoveNave_RecalculaDirEsq_Tiro
    
    loadn R2, #']'
    cmp R1, R2
    jeq MoveNave_RecalculaDirDir_Tiro
    
  MoveNave_RecalculaPos_Fim:
    store posNave, R0
    pop R3
    pop R2
    pop R1
    pop R0
    rts

  MoveNave_RecalculaPos_A:
    loadn R1, #40
    loadn R2, #0
    mod R1, R0, R1
    cmp R1, R2
    jeq MoveNave_RecalculaPos_Fim
    dec R0
    jmp MoveNave_RecalculaPos_Fim
        
  MoveNave_RecalculaPos_D:
    loadn R1, #40
    loadn R2, #39
    mod R1, R0, R1
    cmp R1, R2
    jeq MoveNave_RecalculaPos_Fim
    inc R0
    jmp MoveNave_RecalculaPos_Fim
    
  MoveNave_RecalculaPos_W:
    loadn R1, #160
    loadn R2, #40
    cmp R0, R1
    jle MoveNave_RecalculaPos_Fim
    sub R0, R0, R2
    jmp MoveNave_RecalculaPos_Fim

  MoveNave_RecalculaPos_S:
    loadn R1, #1159
    cmp R0, R1
    jgr MoveNave_RecalculaPos_Fim
    loadn R1, #40
    add R0, R0, R1
    jmp MoveNave_RecalculaPos_Fim   
    
  MoveNave_RecalculaPos_Tiro:   
    loadn R1, #1
    store FlagTiroNave, R1
    store posTiroNave, R0
    jmp MoveNave_RecalculaPos_Fim   

  MoveNave_RecalculaDirEsq_Tiro:    
    load R1, dirTiroNave
    loadn R2, #0
    dec R1
    cmp R1, R2
    store dirTiroNave, R1       
    jeg MoveNave_RecalculaPos_Fim
    loadn R2, #3
    store dirTiroNave, R2
    jmp MoveNave_RecalculaPos_Fim   
    
  MoveNave_RecalculaDirDir_Tiro:    
    load R1, dirTiroNave
    loadn R2, #4
    inc R1
    mod R1, R1, R2
    store dirTiroNave, R1       
    jmp MoveNave_RecalculaPos_Fim   
    
;----------------------------------
MoveNave_Desenha:
    push R0
    push R1
    
    Loadn R1, #'o'  ; Nave
    load R0, posNave
    outchar R1, R0
    store posAntNave, R0
    
    pop R1
    pop R0
    rts

    
;----------------------------------

MovePorco:
    push r0
    push r1
    
    call MovePorco_RecalculaPos
    load r0, posPorco
    load r1, posAntPorco
    cmp r0, r1
    jeq MovePorco_Skip ;so redesenha se mudou de posicao
        call MovePorco_Apaga
        call MovePorco_Desenha
  MovePorco_Skip:
    
    pop r1
    pop r0
    rts
        
; ----------------------------
        
MovePorco_Apaga:
    push R0
    push R1
    push R2
    push R3
    push R4
    push R5

    load R0, posAntPorco
    load R1, posAntNave
    cmp r0, r1
    jne MovePorco_Apaga_Skip
        loadn r5, #'o'    ;Se o tiro passa sobre a nave, apaga com um o, senao apaga com o cenario 
        jmp MovePorco_Apaga_Fim

  MovePorco_Apaga_Skip: 
  
    loadn R1, #tela0Linha0
    add R2, R1, r0
    loadn R4, #40
    div R3, R0, R4
    add R2, R2, R3
    loadi R5, R2
  
  MovePorco_Apaga_Fim:  
    outchar R5, R0
    
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    pop R0
    rts
    
MovePorco_RecalculaPos:
    push R0
    push R1
    push R2
    push R3

    load R0, posPorco

; sorteia no. randomico entre 0 e 7
    loadn R2, #Rand
    load R1, IncRand
    add r2, r2, r1
    loadi R3, R2
                        
    inc r1
    loadn r2, #30
    cmp r1, r2
    jne MovePorco_RecalculaPos_Skip
        loadn r1, #0
  MovePorco_RecalculaPos_Skip:
    store IncRand, r1

;switch para cada numero sorteado
    loadn r2, #0
    cmp r3, r2
    jne MovePorco_RecalculaPos_Case1
    loadn r1, #41
    sub r0, r0, r1
    jmp MovePorco_RecalculaPos_FimSwitch
    
   MovePorco_RecalculaPos_Case1:
    loadn r2, #1
    cmp r3, r2
    jne MovePorco_RecalculaPos_Case2
    loadn r1, #40
    sub r0, r0, r1
    jmp MovePorco_RecalculaPos_FimSwitch
    
   MovePorco_RecalculaPos_Case2:
    loadn r2, #2
    cmp r3, r2
    jne MovePorco_RecalculaPos_Case3
    loadn r1, #39
    sub r0, r0, r1
    jmp MovePorco_RecalculaPos_FimSwitch

   MovePorco_RecalculaPos_Case3:
    loadn r2, #3
    cmp r3, r2
    jne MovePorco_RecalculaPos_Case4
    loadn r1, #1
    sub r0, r0, r1
    jmp MovePorco_RecalculaPos_FimSwitch

   MovePorco_RecalculaPos_Case4:
    loadn r2, #4
    cmp r3, r2
    jne MovePorco_RecalculaPos_Case5
    loadn r1, #1
    add r0, r0, r1
    jmp MovePorco_RecalculaPos_FimSwitch

   MovePorco_RecalculaPos_Case5:
    loadn r2, #5
    cmp r3, r2
    jne MovePorco_RecalculaPos_Case6
    loadn r1, #39
    add r0, r0, r1
    jmp MovePorco_RecalculaPos_FimSwitch

   MovePorco_RecalculaPos_Case6:
    loadn r2, #6
    cmp r3, r2
    jne MovePorco_RecalculaPos_Case7
    loadn r1, #40
    add r0, r0, r1
    jmp MovePorco_RecalculaPos_FimSwitch

   MovePorco_RecalculaPos_Case7:
    loadn r2, #7
    cmp r3, r2
    jne MovePorco_RecalculaPos_FimSwitch
    loadn r1, #41
    add r0, r0, r1
    jmp MovePorco_RecalculaPos_FimSwitch

  MovePorco_RecalculaPos_FimSwitch: 
    store posPorco, R0
    pop R3
    pop R2
    pop R1
    pop R0
    rts


MovePorco_Desenha:
    push R0
    push R1
    
    Loadn R1, #'A'
    load R0, posPorco
    outchar R1, R0
    store posAntPorco, R0
    
    pop R1
    pop R0
    rts

MoveTiro:
    push r0
    push r1
    
    call MoveTiro_RecalculaPos
    load r0, posTiroNave
    load r1, posAntTiroNave
    cmp r0, r1
    jeq MoveTiro_Skip
        call MoveTiro_Apaga
        call MoveTiro_Desenha
  MoveTiro_Skip:
    
    pop r1
    pop r0
    rts

;-----------------------------
    
MoveTiro_Apaga:
    push R0
    push R1
    push R2
    push R3
    push R4
    push R5

    load R0, posAntTiroNave
    load R1, posAntNave
    cmp r0, r1
    jne MoveTiro_Apaga_Skip1
        loadn r5, #'o'
        jmp MoveTiro_Apaga_Fim
        
  MoveTiro_Apaga_Skip1:
    loadn R1, #tela0Linha0
    add R2, R1, r0
    loadn R4, #40
    div R3, R0, R4
    add R2, R2, R3
    
    loadi R5, R2

  MoveTiro_Apaga_Fim:   
    outchar R5, R0
    
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    pop R0
    rts
    
;###movimentacao do tiro###
MoveTiro_RecalculaPos:
    push R0
    push R1
    push R2
    push R3
    
    load R1, FlagTiroNave
    loadn R2, #1
    cmp R1, R2
    jne MoveTiro_RecalculaPos_Fim2
    
    load R0, posTiroNave
    load R1, posPorco
    cmp R0, R1
    jeq MoveTiro_RecalculaPos_Boom
    
    
    
    loadn R1, #40
    loadn R2, #39
    mod R1, R0, R1      
    cmp R1, R2      ;Se tiro chegou no limite direito
    jeq MoveTiro_SaiDaTela
    
    loadn R2, #160  
    cmp R0, R2      ; Se tiro chegou na primeira linha
    jle MoveTiro_SaiDaTela
    
    loadn R1, #40
    loadn R2, #0
    mod R1, R0, R1      
    cmp R1, R2      ;Se tiro chegou no limite esquerdo
    jeq MoveTiro_SaiDaTela
    
    loadn R2, #1159 
    cmp R0, R2      ; Se tiro chegou na ultima linha
    jgr MoveTiro_SaiDaTela
    
    jmp MoveTiro_RecalculaPos_Fim
    
  MoveTiro_SaiDaTela: ;apaga se sair da tela
    call MoveTiro_Apaga
    loadn R0, #0
    store FlagTiroNave, R0
    store posTiroNave, R0
    store posAntTiroNave, R0
    jmp MoveTiro_RecalculaPos_Fim2  
    
  MoveTiro_RecalculaPos_Fim:
    load R3, dirTiroNave
    
    loadn R1, #0
    cmp R1, R3
    jne MoveTiro_DirDir
    loadn R2, #40
    sub R0, R0, R2
    store posTiroNave, R0   
    jmp MoveTiro_RecalculaPos_Fim2
    
      MoveTiro_DirDir:
        loadn R1, #1
        cmp R1, R3
        jne MoveTiro_DirBaixo
        inc R0
        store posTiroNave, R0   
        jmp MoveTiro_RecalculaPos_Fim2
        
      MoveTiro_DirBaixo:
        loadn R1, #2
        cmp R1, R3
        jne MoveTiro_DirEsq
        loadn R2, #40
        add R0, R0, R2      
        store posTiroNave, R0   
        jmp MoveTiro_RecalculaPos_Fim2
        
      MoveTiro_DirEsq:
        loadn R1, #3
        cmp R1, R3
        dec R0  
        store posTiroNave, R0   
    
  MoveTiro_RecalculaPos_Fim2:
    pop R3
    pop R2
    pop R1
    pop R0
    rts

  MoveTiro_RecalculaPos_Boom:   
    loadn R2, #0
    load R3, nVidasPorco
    dec R3
    store nVidasPorco, R3
    cmp R3, R2
    jne MoveTiro_SaiDaTela
    
    load R2, nFase
    loadn r0, #9
    cmp r0, r2
    jeq Venceu
    
    ;Limpa a tela
    loadn R1, #tela0Linha0
    loadn R2, #0
    call ImprimeTela
    call ImprimeUI
    ;imprime you win
    loadn r0, #526
    loadn r1, #Msn0
    loadn r2, #0
    call ImprimeStr
    
    ;imprime play again
    loadn r0, #605
    loadn r1, #Msn1
    loadn r2, #0
    call ImprimeStr
    
    MoveTiro_RecalculaPos_SouN:
    call DigLetra
    loadn r0, #'n'
    load r1, Letra
    cmp r0, r1
    jeq MoveTiro_RecalculaPos_FimJogo
    loadn r0, #'s'
    cmp r0, r1
    jne MoveTiro_RecalculaPos_SouN 
    load R2, nFase
    inc r2 ;incrementa a fase
    store nFase, r2
    
    call ApagaTela
    
    pop r2
    pop r1
    pop r0

    pop r0
    jmp main
    
  Venceu:
    ;limpa a tela
    loadn R1, #tela0Linha0
    loadn R2, #0
    call ImprimeTela
    call ImprimeUI
    ;imprime you win
    loadn r0, #523
    loadn r1, #Msn3
    loadn r2, #0
    call ImprimeStr
    halt

  MoveTiro_RecalculaPos_FimJogo:
    call ApagaTela
    halt

;----------------------------------
MoveTiro_Desenha:
    push R0
    push R1
    push R2
    
    load R2, dirTiroNave
    loadn R1, #2
    mod R1, R2, R1
    loadn R2, #0
    cmp R1, R2
    jne MoveTiro_DesenhaH
    Loadn R1, #'|'
    jmp MoveTiro_DesenhaFim
    MoveTiro_DesenhaH:
    Loadn R1, #'-'
    
    MoveTiro_DesenhaFim:
    load R0, posTiroNave
    outchar R1, R0
    store posAntTiroNave, R0
    
    pop R2
    pop R1
    pop R0
    rts

SorteiaTempoTiroPorco:
; sorteia nr. randomico entre 0 e 7
    push R1 
    push R2
    push R3
    
    loadn R2, #Rand
    load R1, IncRand
    add r2, r2, r1 
    loadi R3, R2 
    inc r1
    loadn r2, #30
    cmp r1, r2
    jne SalvaTempo
        loadn r1, #0
    SalvaTempo:
    store IncRand, r1
    inc r3
    loadn r1, #50
    mul r3, r3, r1
    store tempoTiroPorco, r3
    pop R3
    pop R2
    pop R1
    rts

MoveTiroPorco:
    push r0
    push r1
    push r2
            
    load R1, tempoTiroPorco
    mod r0, r0, r1
    loadn r1, #0
    cmp R0, R1
    jne MoveTiroPorco_Continua
    
    loadn r1, #1
    store FlagTiroPorco, r1
    load r1, posPorco
    store posTiroPorco, r1
    store posAntTiroPorco, r1
    
    loadn r0, #3
    load r1, nFase
    dec r1
    div r1, r1, r0
    loadn r0, #2
    cmp r0, r1
    jeq Tiro_Dificil
    loadn r0, #1
    cmp r0, r1
    jeq Tiro_Medio
    
    loadn r0, #4
    load r1, dirTiroPorco
    inc r1
    mod r0, r1, r0 
    store dirTiroPorco, r0
    jmp Tiro_Selecionado
    
    Tiro_Medio:
    loadn r0, #4
    load r1, posPorco
    mod r0, r1, r0 
    store dirTiroPorco, r0
    jmp Tiro_Selecionado
    
    Tiro_Dificil:
    load r0, posNave
    load r1, posPorco
    loadn r2, #40
    div r0, r0, r2
    div r1, r1, r2
    cmp r0, r1
    jeq Tiro_Dificil_DirEsq
    jeg Tiro_Dificil_Baixo
    
    loadn r0, #0
    store dirTiroPorco, r0
    jmp Tiro_Selecionado
    
    Tiro_Dificil_Baixo:
    loadn r0, #2
    store dirTiroPorco, r0
    jmp Tiro_Selecionado
    
    Tiro_Dificil_DirEsq:
    load r0, posNave
    load r1, posPorco
    cmp r0, r1
    jeg Tiro_Dificil_Dir
    loadn r0, #3
    store dirTiroPorco, r0
    jmp Tiro_Selecionado
    
    Tiro_Dificil_Dir:
    loadn r0, #1
    store dirTiroPorco, r0
    jmp Tiro_Selecionado
    
    Tiro_Selecionado:   
    call SorteiaTempoTiroPorco
    MoveTiroPorco_Continua:
    call MoveTiroPorco_RecalculaPos
    
    load r0, posTiroPorco
    load r1, posAntTiroPorco
    cmp r0, r1
    jeq MoveTiroPorco_Skip
        call MoveTiroPorco_Apaga
        call MoveTiroPorco_Desenha
  MoveTiroPorco_Skip:
    pop r2
    pop r1
    pop r0
    rts

MoveTiroPorco_Apaga:
    push R0
    push R1
    push R2
    push R3
    push R4
    push R5

    load R0, posAntTiroPorco
    load R1, posAntPorco
    cmp r0, r1
    jne MoveTiroPorco_Apaga_Skip1
        loadn r5, #'A'      ;se o tiro passa sobre o porco, apaga com um A, senao apaga com o cenario 
        jmp MoveTiroPorco_Apaga_Fim
        
  MoveTiroPorco_Apaga_Skip1:
    loadn R1, #tela0Linha0
    add R2, R1, r0
    loadn R4, #40
    div R3, R0, R4
    add R2, R2, R3
    
    loadi R5, R2

  MoveTiroPorco_Apaga_Fim:  
    outchar R5, R0
    
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    pop R0
    rts
    
MoveTiroPorco_RecalculaPos:
    push R0
    push R1
    push R2
    push R3
    
    load R1, FlagTiroPorco
    
    loadn R2, #1
    cmp R1, R2
    jne MoveTiroPorco_RecalculaPos_Fim2
    
    load R0, posTiroPorco
    load R1, posNave
    cmp R0, R1
    jeq MoveTiroPorco_RecalculaPos_Boom
    
    
    
    loadn R1, #40
    loadn R2, #39
    mod R1, R0, R1      
    cmp R1, R2
    jeq MoveTiroPorco_SaiDaTela
    
    loadn R2, #160  
    cmp R0, R2
    jle MoveTiroPorco_SaiDaTela
    
    loadn R1, #40
    loadn R2, #0
    mod R1, R0, R1      
    cmp R1, R2
    jeq MoveTiroPorco_SaiDaTela
    
    loadn R2, #1159 
    cmp R0, R2
    jgr MoveTiroPorco_SaiDaTela
    
    jmp MoveTiroPorco_RecalculaPos_Fim
    
  MoveTiroPorco_SaiDaTela:
    call MoveTiroPorco_Apaga
    loadn R0, #0
    store FlagTiroPorco, R0
    store posTiroPorco, R0
    store posAntTiroPorco, R0
    jmp MoveTiroPorco_RecalculaPos_Fim2 
    
  MoveTiroPorco_RecalculaPos_Fim:
    load R3, dirTiroPorco
    
    loadn R1, #0
    cmp R1, R3
    jne MoveTiroPorco_DirDir
    loadn R2, #40
    sub R0, R0, R2
    store posTiroPorco, R0  
    jmp MoveTiroPorco_RecalculaPos_Fim2
    
      MoveTiroPorco_DirDir:
        loadn R1, #1
        cmp R1, R3
        jne MoveTiroPorco_DirBaixo
        inc R0
        store posTiroPorco, R0  
        jmp MoveTiroPorco_RecalculaPos_Fim2
        
      MoveTiroPorco_DirBaixo:
        loadn R1, #2
        cmp R1, R3
        jne MoveTiroPorco_DirEsq
        loadn R2, #40
        add R0, R0, R2      
        store posTiroPorco, R0  
        jmp MoveTiroPorco_RecalculaPos_Fim2
        
      MoveTiroPorco_DirEsq:
        loadn R1, #3
        cmp R1, R3
        dec R0  
        store posTiroPorco, R0  
    
  MoveTiroPorco_RecalculaPos_Fim2:
    pop R3
    pop R2
    pop R1
    pop R0
    rts

  MoveTiroPorco_RecalculaPos_Boom:  
    loadn R2, #0
    load R3, nVidasNave
    dec R3
    store nVidasNave, R3
    call ImprimeUI
    cmp R3, R2
    jne MoveTiroPorco_SaiDaTela
    
    loadn R1, #tela0Linha0
    loadn R2, #0
    call ImprimeTela
    call ImprimeUI
    ;imprime you lose
    loadn r0, #526
    loadn r1, #Msn2
    loadn r2, #0
    call ImprimeStr
    
    halt

MoveTiroPorco_Desenha:
    push R0
    push R1
    push R2
    
    load R2, dirTiroPorco
    loadn R1, #2
    mod R1, R2, R1
    loadn R2, #0
    cmp R1, R2
    Loadn R1, #'^'
    load R0, posTiroPorco
    outchar R1, R0
    store posAntTiroPorco, R0
    
    pop R2
    pop R1
    pop R0
    rts



;########################################################
;                       DELAY
;########################################################      


Delay:
    Push R0
    Push R1
    
    Loadn R1, #10  ; a
   Delay_volta2:
    Loadn R0, #5000 ; b
   Delay_volta: 
    Dec R0
    JNZ Delay_volta 
    Dec R1
    JNZ Delay_volta2
    
    Pop R1
    Pop R0
    
    RTS


;########################################################
;                       IMPRIME TELA
;########################################################   

ImprimeTela: 
    push r0 
    push r1
    push r2
    push r3
    push r4
    push r5

    loadn R0, #0
    loadn R3, #40
    loadn R4, #41
    loadn R5, #1200
    
   ImprimeTela_Loop:
        call ImprimeStr
        add r0, r0, r3
        add r1, r1, r4
        cmp r0, r5
        jne ImprimeTela_Loop

    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
ImprimeUI:
    push r0
    push r1
    push r2
    
    load R0, nVidasNave
    load R2, nFase
    loadn R1, #48
    add R0, R0, R1
    add R2, R2, R1
    loadn R1, #47
    outchar R0, R1
    loadn R1, #78
    outchar R2, R1 
    
    pop r2
    pop r1
    pop r0
    rts    
;********************************************************
;                   IMPRIME MENSAGEM
;********************************************************
    
ImprimeStr:
    push r0
    push r1
    push r2
    push r3
    push r4
    
    loadn r3, #'\0'

   ImprimeStr_Loop: 
        loadi r4, r1
        cmp r4, r3
        jeq ImprimeStr_Sai
        add r4, r2, r4
        outchar r4, r0
        inc r0
        inc r1
        jmp ImprimeStr_Loop
    
   ImprimeStr_Sai:  
    pop r4 
    pop r3
    pop r2
    pop r1
    pop r0
    rts
;********************************************************
;                       IMPRIME TELA2
;********************************************************   

ImprimeTela2:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    
    loadn R0, #0
    loadn R3, #40
    loadn R4, #41
    loadn R5, #1200
    loadn R6, #tela0Linha0
    
   ImprimeTela2_Loop:
        call ImprimeStr2
        add r0, r0, r3
        add r1, r1, r4
        add r6, r6, r4
        cmp r0, r5
        jne ImprimeTela2_Loop

    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
;********************************************************
;                   IMPRIME STRING2
;********************************************************
    
ImprimeStr2:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    
    loadn r3, #'\0'
    loadn r5, #' '

   ImprimeStr2_Loop:    
        loadi r4, r1
        cmp r4, r3
        jeq ImprimeStr2_Sai
        cmp r4, r5
        jeq ImprimeStr2_Skip
        add r4, r2, r4
        outchar r4, r0
        storei r6, r4
   ImprimeStr2_Skip:
        inc r0
        inc r1
        inc r6
        jmp ImprimeStr2_Loop
    
   ImprimeStr2_Sai: 
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
;********************************************************
;                   DIGITE UMA LETRA
;********************************************************

DigLetra:
    push r0
    push r1
    loadn r1, #255  ;Se nao digitar nada vem 255

   DigLetra_Loop:
        inchar r0
        cmp r0, r1
        jeq DigLetra_Loop

    store Letra, r0

    pop r1
    pop r0
    rts


;********************************************************
;                       APAGA TELA
;********************************************************
ApagaTela:
    push r0
    push r1
    
    loadn r0, #1200
    loadn r1, #' '
    
       ApagaTela_Loop:
        dec r0
        outchar r1, r0
        jnz ApagaTela_Loop
 
    pop r1
    pop r0
    rts 
    

tela0Linha0  : string "                                        "
tela0Linha1  : string "                                        "
tela0Linha2  : string "                                        "
tela0Linha3  : string "                                        "
tela0Linha4  : string "                                        "
tela0Linha5  : string "                                        "
tela0Linha6  : string "                                        "
tela0Linha7  : string "                                        "
tela0Linha8  : string "                                        "
tela0Linha9  : string "                                        "
tela0Linha10 : string "                                        "
tela0Linha11 : string "                                        "
tela0Linha12 : string "                                        "
tela0Linha13 : string "                                        "
tela0Linha14 : string "                                        "
tela0Linha15 : string "                                        "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "                                        "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "    

tela1Linha0  : string "                                        "
tela1Linha1  : string "                                        "
tela1Linha2  : string "                                        "
tela1Linha3  : string "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
tela1Linha4  : string "X                                      X"
tela1Linha5  : string "X                                      X"
tela1Linha6  : string "X       m                              X"
tela1Linha7  : string "X                                      X"
tela1Linha8  : string "X                          m           X"
tela1Linha9  : string "X                                      X"
tela1Linha10 : string "X       +                              X"
tela1Linha11 : string "X                                      X"
tela1Linha12 : string "X              m                       X"
tela1Linha13 : string "X                               +      X"
tela1Linha14 : string "X                                      X"
tela1Linha15 : string "X                                      X"
tela1Linha16 : string "X                                      X"
tela1Linha17 : string "X                                      X"
tela1Linha18 : string "X                      *               X"
tela1Linha19 : string "X                                      X"
tela1Linha20 : string "X                 m                    X"
tela1Linha21 : string "X                                      X"
tela1Linha22 : string "X                                      X"
tela1Linha23 : string "X                              +       X"
tela1Linha24 : string "X     m                                X"
tela1Linha25 : string "X                                      X"
tela1Linha26 : string "X                                      X"
tela1Linha27 : string "X           m                          X"
tela1Linha28 : string "X                                      X"
tela1Linha29 : string "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

tela2Linha0  : string "                                        "
tela2Linha1  : string "                PORCADA                 "
tela2Linha2  : string "                                        "
tela2Linha3  : string "                                        "
tela2Linha4  : string "                                        "
tela2Linha5  : string "                                        "
tela2Linha6  : string "                                        "
tela2Linha7  : string "                                        "
tela2Linha8  : string "                                        "
tela2Linha9  : string "                                        "
tela2Linha10 : string "                                        "
tela2Linha11 : string "                                        "
tela2Linha12 : string "                                        "
tela2Linha13 : string "                                        "
tela2Linha14 : string "                                        "
tela2Linha15 : string "                                        "
tela2Linha16 : string "                                        "
tela2Linha17 : string "                                        "
tela2Linha18 : string "                                        "
tela2Linha19 : string "                                        "
tela2Linha20 : string "                                        "
tela2Linha21 : string "                                        "
tela2Linha22 : string "                                        "
tela2Linha23 : string "                                        "
tela2Linha24 : string "                                        "
tela2Linha25 : string "                                        "
tela2Linha26 : string "                                        "
tela2Linha27 : string "                                        "
tela2Linha28 : string "                                        "
tela2Linha29 : string "                                        "

tela3Linha0  : string "========================================"
tela3Linha1  : string "|VIDAS:  |                    | FASE:  |"
tela3Linha2  : string "========================================"
tela3Linha3  : string "                                        "
tela3Linha4  : string "                                        "
tela3Linha5  : string "                                        "
tela3Linha6  : string "                                        "
tela3Linha7  : string "                                        "
tela3Linha8  : string "                                        "
tela3Linha9  : string "                                        "
tela3Linha10 : string "                                        "
tela3Linha11 : string "                                        "
tela3Linha12 : string "                                        "
tela3Linha13 : string "                                        "
tela3Linha14 : string "                                        "
tela3Linha15 : string "                                        "
tela3Linha16 : string "                                        "
tela3Linha17 : string "                                        "
tela3Linha18 : string "                                        "
tela3Linha19 : string "                                        "
tela3Linha20 : string "                                        "
tela3Linha21 : string "                                        "
tela3Linha22 : string "                                        "
tela3Linha23 : string "                                        "
tela3Linha24 : string "                                        "
tela3Linha25 : string "                                        "
tela3Linha26 : string "                                        "
tela3Linha27 : string "                                        "
tela3Linha28 : string "                                        "
tela3Linha29 : string "                                        "