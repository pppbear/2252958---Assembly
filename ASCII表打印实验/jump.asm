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
    MOV AX, DATASEG   ; 将数据段地址加载到 AX 中
    MOV DS, AX        ; 将数据段地址赋值给 DS，确保 DS 指向数据段

    MOV AH, 2         ; DOS 功能调用，显示字符
    
L1: MOV AL, [MSG1]    ; 从 MSG 地址处读取数据到 AL
    MOV DL, AL        ; 将 AL 中的字符放入 DL，准备显示
    INC AL            ; 递增 AL 中的字符，变成下一个字母
    MOV [MSG1], AL    ; 将新的字符存回 MSG
    INT 21H           ; 调用 DOS 中断，显示字符
    CMP AL,109         
    JL L1

    MOV DL, 13        ;打印换行符
    INT 21H
    MOV DL, 10 
    INT 21H

    MOV AH, 2 
L2: MOV AL, [MSG2]    ; 从 MSG 地址处读取数据到 AL
    MOV DL, AL        ; 将 AL 中的字符放入 DL，准备显示
    INC AL            ; 递增 AL 中的字符，变成下一个字母
    MOV [MSG2], AL    ; 将新的字符存回 MSG
    INT 21H           ; 调用 DOS 中断，显示字符
    CMP AL,122         
    JL  L2

    MOV AX, 4C00H     ; 退出程序
    INT 21H
MAIN ENDP
CODESEG ENDS
    END MAIN
