STKSEG SEGMENT STACK
DW 200 DUP(0)
STKSEG ENDS

DATASEG SEGMENT
    BUFFER DB 6 DUP(0)   ; 占用6字节
DATASEG ENDS


CODESEG SEGMENT
	ASSUME CS:CODESEG,DS:DATASEG
MAIN PROC FAR
    MOV AX, DATASEG      ; 初始化数据段
    MOV DS, AX
   
    MOV AX,0
    MOV CX,100
    MOV DX,1
    ; 从1开始累加
L1: ADD AX,DX            
    INC DX               ; 加数自增
    LOOP L1

    MOV CX, 5            
    MOV BX, 10           
    LEA DI, BUFFER + 5   
    ; 将AX中的数字转换为字符串，并保存到BUFFER
L2:
    MOV DX, 0           
    DIV BX               ; AX除以10，商在AX，余数在DX
    ADD DL, '0'          
    DEC DI               ; 递减DI以保存字符
    MOV [DI], DL         ; 把运算结果放入DI指向的地址
    DEC CX               
    CMP AX, 0          ; 检查商是否为0
    JNZ L2     ; 若商不为0，则继续循环

    ; 添加字符串终止符
    MOV BYTE PTR [BUFFER + 5], '$'      

    MOV AH,9             ; 显示字符串
    LEA DX, BUFFER
    INT 21H

    MOV AX,4C00H
	INT 21H

MAIN ENDP
CODESEG ENDS
	END MAIN
