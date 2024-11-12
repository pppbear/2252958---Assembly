PUBLIC PrintAva
INCLUDE data.inc  ; 引入数据段
INCLUDE table.inc ; 引入表格段
INCLUDE buffer.inc ; 引入缓冲段
extrn CONVERT_LOOP:FAR, PrintWord:FAR
CODESEG SEGMENT
    ASSUME CS:CODESEG
PrintAva PROC FAR
  ; 打印人均
  MOV DH, 0  ; 行号
  MOV TEMP, DH
  MOV SI, OFFSET DATASEG + 13
PRINT_AVA:
  MOV AX, [SI] 
  MOV DI, OFFSET BUF + 7
  CALL CONVERT_LOOP
  ; 打印转换后的数字
  MOV DL, 50
  CALL PrintWord
  CMP DH, 21
  JL PRINT_AVA
  RET
PrintAva ENDP
CODESEG ENDS
END