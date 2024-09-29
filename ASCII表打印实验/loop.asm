STKSEG SEGMENT STACK
    DW 32 DUP(0)
STKSEG ENDS

DATASEG SEGMENT
    MSG1 DB 'a'        
    MSG2 DB 'n'
DATASEG ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG, DS:DATASEG  
MAIN PROC FAR
    MOV AX, DATASEG   
    MOV DS, AX       

    MOV CX, 13        ; 循环 13 次
    MOV AH, 2         ; DOS 功能调用，显示字符
    
L1: MOV AL, [MSG1]    ; 从 MSG 地址处读取数据到 AL
    MOV DL, AL        ; 将 AL 中的字符放入 DL，准备显示
    INC AL            ; 递增 AL 中的字符，变成下一个字母
    MOV [MSG1], AL    ; 将新的字符存回 MSG
    INT 21H           ; 调用 DOS 中断，显示字符
    LOOP L1           ; 循环 CX 次（13 次）
    
    MOV DL, 13 
    INT 21H
    MOV DL, 10 
    INT 21H

    MOV CX, 13        ; 循环 13 次
    MOV AH, 2         ; DOS 功能调用，显示字符

L2: MOV AL, [MSG2]    ; 从 MSG 地址处读取数据到 AL
    MOV DL, AL        ; 将 AL 中的字符放入 DL，准备显示
    INC AL            ; 递增 AL 中的字符，变成下一个字母
    MOV [MSG2], AL    ; 将新的字符存回 MSG
    INT 21H           ; 调用 DOS 中断，显示字符
    LOOP L2           ; 循环 CX 次（13 次）

    MOV AX, 4C00H     ; 退出程序
    INT 21H

MAIN ENDP
CODESEG ENDS
    END MAIN
