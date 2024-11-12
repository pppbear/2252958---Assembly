PUBLIC PrintYear

INCLUDE data.inc  ; 引入数据段
INCLUDE table.inc ; 引入表格段
INCLUDE buffer.inc ; 引入缓冲段

CODESEG SEGMENT
    ASSUME CS:CODESEG

PrintYear PROC FAR
  ; 打印year
  MOV BX, 0
  MOV BP, OFFSET DATASEG
  MOV DH, 0  ; 行号
PRINT_YEAR:
  MOV CX, 4  ; 长度为4
  MOV DL, 4  ; 列号
  MOV AL, 1
  MOV BL, 4
  MOV AH, 13H
  INT 10H
  ADD BP, 16
  INC DH
  CMP DH, 21
  JL PRINT_YEAR
  RET
PrintYear ENDP
CODESEG ENDS
END