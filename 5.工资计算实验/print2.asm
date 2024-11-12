PUBLIC PrintTable
extrn PrintYear:FAR, PrintIncome:FAR, PrintPeople:FAR, PrintAva:FAR

CODESEG SEGMENT
    ASSUME CS:CODESEG

PrintTable PROC FAR
  ; 打印表格数据
  ; 打印table
  MOV AH,00H ; 清屏
  MOV AL,03H
  INT 10H
  CALL PrintYear
  ; 打印收入
  CALL PrintIncome
  ; 打印人数
  CALL PrintPeople
  ; 打印人均
  CALL PrintAva
  ; 设置光标位置
  MOV AH,02H
  MOV DH,24
  MOV DL,0
  INT 10H
  RET
PrintTable ENDP
CODESEG ENDS
END