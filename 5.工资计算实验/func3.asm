PUBLIC MovePeople
INCLUDE data.inc  ; 引入数据段
INCLUDE table.inc ; 引入表格段
CODESEG SEGMENT
    ASSUME CS:CODESEG
MovePeople PROC FAR
  ; 代码实现，移动人数
  ; 移动人数
  MOV DI, OFFSET DATASEG + 10
  MOV BX, 0
PEOPLE:
  MOV AX, [SI]         ; 将 DATASEG 中的低 16 位加载到 AX
  MOV WORD PTR [DI], AX      ; 将 AX 存入 TABLE 中的低 16 位
  ADD SI, 2
  ADD DI, 16
  INC BX
  CMP BX, 21
  JL PEOPLE
  RET
MovePeople ENDP
CODESEG ENDS
end