STKSEG SEGMENT STACK
    DW 200 DUP(0)
STKSEG ENDS
DATASEG SEGMENT
    TABLE   db 7,2,3,4,5,6,7,8,9             ;9*9表数据
	        db 2,4,7,8,10,12,14,16,18
            db 3,6,9,12,15,18,21,24,27
            db 4,8,12,16,7,24,28,32,36
            db 5,10,15,20,25,30,35,40,45
            db 6,12,18,24,30,7,42,48,54
            db 7,14,21,28,35,42,49,56,63
            db 8,16,24,32,40,48,56,7,72
            db 9,18,27,36,45,54,63,72,81
    ERR DB "ERROR$"
    SPACE DB ' '
    POS DB "X Y$"
DATASEG ENDS

CODESEG SEGMENT
	ASSUME CS:CODESEG,DS:DATASEG
MAIN PROC
    MOV AX,DATASEG
    MOV DS,AX
    ; 打印xy标识
    LEA DX,POS
    MOV AH,09H
    INT 21H
    ; 打印换行符
    MOV AH,02H
    MOV DL, 13 
    INT 21H
    MOV DL, 10 
    INT 21H

    
    ; AX为第一个乘数，BX为第二个乘数
    MOV AX,1
    PUSH AX
    MOV BX,1
    ; CX为偏移量
    MOV CX,0
    ; 计算结果
L1:
    POP AX
    PUSH AX
    MUL BX
    ; 获取table中对应数据
    ; 将table地址加载到DI上
    LEA DI,[TABLE]
    ADD DI,CX
    MOV DX,[DI] 
    ; 比较
    CMP AL,DL
    JE L2
    CALL WRONG

L2:
    ; 增加BX,CX
    INC CX
    INC BX
    CMP BX,9
    JLE L1
    ; 获取上一轮的AX
    POP AX
    ; 增加AX
    INC AX
    PUSH AX
    ; 重置BX
    MOV BX,1

    CMP AX,9
    JLE L1
    ; 还原栈
    POP AX
    MOV AH,4CH
    INT 21H
MAIN ENDP
WRONG PROC
    ; 处理错误输出
    PUSH CX
    ; 打印错误位置
    INC CX
    MOV AX,CX
    MOV CX,9
    ; 清空DX否则会出错
    MOV DX,0
    DIV CX
    ; x在AX中保存，y在DX中保存
    PUSH DX
    ; 打印x位置
    MOV DX,AX
    INC DX
    ADD DX,'0'
    MOV AH,02H
    INT 21H
    MOV DL,SPACE
    INT 21H
    ; 打印y位置
    POP DX
    ADD DX,'0'
    INT 21H
    MOV DL,SPACE
    INT 21H
    ; 打印ERROR提示
    LEA DX,ERR
    MOV AH,09H
    INT 21H
    ; 打印换行符
    MOV AH,02H
    MOV DL, 13 
    INT 21H
    MOV DL, 10 
    INT 21H
    POP CX
    RET
WRONG ENDP

CODESEG ENDS
    END MAIN