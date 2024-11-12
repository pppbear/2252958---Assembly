PUBLIC PrintIncome
INCLUDE data.inc  ; 引入数据段
INCLUDE table.inc ; 引入表格段
INCLUDE buffer.inc ; 引入缓冲段
extrn CONVERT_ZERO:FAR, CONVERT_NOT_ZERO:FAR, PrintWord:FAR

CODESEG SEGMENT
    ASSUME CS:CODESEG
PrintIncome PROC FAR
  ; 打印收入
  MOV DH, 0  ; 行号
  MOV TEMP, DH
  MOV SI, OFFSET DATASEG + 5
PRINT_INCOME:
  MOV AX, [SI]         ; 将收入的低16位加载到AX中
  MOV DX, [SI + 2]         ; 将收入的高16位加载到DX中
  MOV DI, OFFSET BUF + 7    ; DI指向buffer的最后一个字符
  MOV CX, 100                  ; 基数100，用于两位转换

  ; 第一次除法，将DX:AX / 100，商存入AX，余数存入DX
  DIV CX      
  MOV BX, AX                      ; 保存商（高位部分）
  CMP DX, 0
  JNZ NOT_ZERO   
ZERO:
  CALL CONVERT_ZERO
  JMP END3                
NOT_ZERO:
  CALL CONVERT_NOT_ZERO
END3: 
  MOV DL, 20
  CALL PrintWord
  CMP DH, 21
  JL PRINT_INCOME
  RET
PrintIncome ENDP
CODESEG ENDS
END