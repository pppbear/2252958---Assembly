PUBLIC MoveIncome
INCLUDE data.inc  ; 引入数据段
INCLUDE table.inc 
CODESEG SEGMENT
    ASSUME CS:CODESEG
MoveIncome PROC FAR
  ; 移动收入
  MOV DI, OFFSET DATASEG + 5
  MOV BX, 0
SUMM:
  MOV AX, [SI]         ; 将 DATASEG 中的低 16 位加载到 AX
  MOV WORD PTR [DI], AX      ; 将 AX 存入 TABLE 中的低 16 位
  MOV AX, [SI + 2]       ; 将 DATASEG 中的高 16 位加载到 AX
  MOV WORD PTR [DI + 2], AX    ; 将 AX 存入 TABLE 中的高 16 位
  
  ADD SI, 4
  ADD DI, 16
  INC BX
  CMP BX, 21
  JL SUMM
  RET
MoveIncome ENDP
CODESEG ENDS
end