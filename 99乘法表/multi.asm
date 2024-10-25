STKSEG SEGMENT STACK
DW 32 DUP(0)
STKSEG ENDS

DATASEG SEGMENT
MULTI DB '*'  
EQUAL DB '='
SPACE DB ' '
BUFFER DB 6 DUP(0)
DATASEG ENDS

CODESEG SEGMENT
	ASSUME CS:CODESEG,DS:DATASEG
MAIN PROC FAR
    MOV AX, DATASEG      ; 初始化数据段
    MOV DS, AX
    MOV BL,9
L2:
    MOV CL,1
    CALL MULTIPLY
    DEC BL
    ; 打印换行符
    MOV AH,02H
    MOV DL, 13 
    INT 21H
    MOV DL, 10 
    INT 21H
    ; 继续打印乘法表
    CMP BL,0
    JNZ L2

    MOV AX,4C00H
	INT 21H
MAIN ENDP
; BX是第一个乘数，CX是第二个乘数
MULTIPLY PROC
    MOV AH,02H
    MOV DX,BX
    ADD DX,'0'
    INT 21H          ; 打印乘数
    MOV DL,MULTI
    INT 21H          ; 打印乘号
    
    MOV DX,CX
    ADD DX,'0'
    INT 21H          ; 打印乘数
    MOV AX,CX
    MUL BX            ; AX*BX,结果在AX中
    PUSH AX
    
    MOV DL,EQUAL
    MOV AH,02H
    INT 21H
    POP AX
    PUSH BX
    CALL TRANS
    POP BX
    MOV DL,SPACE
    MOV AH,02H
    INT 21H
    INC CX
    CMP CX,BX
    JG DONE
    CALL MULTIPLY
DONE:
    RET

MULTIPLY ENDP
TRANS PROC
    MOV BX,10
    LEA DI, BUFFER + 5  
    
L1:        
    MOV DX, 0   
    DIV BX               ; AX除以10，商在AX，余数在DX
    ADD DX, '0'          
    DEC DI               ; 递减DI以保存字符
    MOV [DI], DL         ; 把运算结果放入DI指向的地址              
    CMP AX, 0          ; 检查商是否为0
    JNZ L1    
    ; 添加字符串终止符
    MOV BYTE PTR [BUFFER + 5], '$'    
    ; 打印转换后的结果
    MOV AH, 09H
    LEA DX, [DI]           ; DX 指向转换后的数字
    INT 21H

    RET
TRANS ENDP
CODESEG ENDS
	END MAIN