STKSEG SEGMENT STACK
DW 1000H DUP(0)
STKSEG ENDS
DATASEG SEGMENT
    NUM DB 20
    BUFFER1 DB 6          ; 最大输入长度为5个字符 + 回车符
            DB 0          ; 实际输入的字符数，初始为0
            DB 6 DUP(?)   ; 用于存放用户输入的字符
    BUFFER2 DB 10 DUP(0) 

DATASEG ENDS

CODESEG SEGMENT
	ASSUME CS:CODESEG,DS:DATASEG

MAIN PROC FAR
    ; 保证运行环境正常
    MOV AX,0
    MOV BX,0
    MOV CX,0    
    MOV DX,0
    ; 自定义栈
    MOV AX, STKSEG     ; 将栈段地址加载到AX
    MOV SS, AX         ; 设置SS寄存器
    MOV SP, 1000h      ; 设置SP寄存器为栈顶，指向段的最后一个字节

    MOV AX,DATASEG
    MOV DS,AX
    ; MOV DL,NUM
    ; 输入一个数字
    MOV AH,0AH
    LEA DX, BUFFER1     ; 缓冲区地址
    INT 21H
    ; 处理输入
    CALL INPUT

    MOV DX,AX

    CALL FIBONACCI
    
    ; 处理计算结果，变为ascii码
    CALL TRANS

    MOV AX,4C00H
	INT 21H


MAIN ENDP
FIBONACCI PROC
    CMP DX,0       ;0的时候，将F(0)的值即1压入栈中
    JE L1

    CMP DX,1       ;F(1)不需要处理
    JE L1

    DEC DX   
    PUSH DX

    CALL FIBONACCI ;计算F(n-1)
    POP DX         ; 恢复 DX 的原始值
    PUSH AX        ;保存F(n-1)

    DEC DX
    CALL FIBONACCI ;计算F(n-2),AX带返回结果
    POP BX
    ADD AX,BX      ;计算F(n)
    RET

L1:
    CALL DONE
    RET

FIBONACCI ENDP
DONE PROC
    CMP DX,0
    JE F0
    CMP DX,1
    JE F1
F0:
    MOV AX,0
    RET
F1:
    MOV AX,1
    RET
DONE ENDP
TRANS PROC
    MOV BX,10
    LEA DI, BUFFER2 + 5  
L2:        
    MOV DX, 0   
    DIV BX               ; AX除以10，商在AX，余数在DX
    ADD DX, '0'          
    DEC DI               ; 递减DI以保存字符
    MOV [DI], DL         ; 把运算结果放入DI指向的地址              
    CMP AX, 0          
    JNZ L2               ; 若商不为0，则继续循环
    ; 添加字符串终止符
    MOV BYTE PTR [BUFFER2 + 5], '$'    
    ; 打印转换后的结果
    MOV AH, 09H
    LEA DX, [DI]           ; DX 指向转换后的数字
    INT 21H
    
    RET
TRANS ENDP
INPUT PROC
    ; 将输入的字符串转换为数字，'1234' = 1*1000 + 2*100 + 3*10 + 4
    LEA DI,BUFFER1 + 2
    MOV CL,[BUFFER1 + 1]  ; 输入总字符数
    MOV AX,0
    MOV BX, 10
    ; 当前字符
L3:
    MOV DL,[DI]
    SUB DL,'0'
    ; 之前结果*10
    MUL BL
    ; 加上这一位
    ADD AX,DX
    INC DI
    LOOP L3

    RET
INPUT ENDP
CODESEG ENDS
	END MAIN