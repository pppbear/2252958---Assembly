PUBLIC PrintWord
INCLUDE buffer.inc ; 引入缓冲段

CODESEG SEGMENT
    ASSUME CS:CODESEG
PrintWord PROC FAR 
  INC DI
  ; 打印转换后的数字
  PUSH SI
  ; 计算 DI 到 buffer 起始位置的差值
  MOV SI, OFFSET BUF + 8 
  SUB SI, DI              
  MOV CX, SI
  POP SI
  MOV BP, DI
  MOV BL, 4  ; 字体属性
  MOV BH, 0  ; 页号
  MOV DH, TEMP ; 行号
  MOV AH, 13H
  INT 10H
  ADD SI, 16
  INC DH
  MOV TEMP, DH
  RET
PrintWord ENDP

CODESEG ENDS
END