PUBLIC CalculateAverage
INCLUDE data.inc  ; 引入数据段
INCLUDE table.inc ; 引入表格段
CODESEG SEGMENT
    ASSUME CS:CODESEG
CalculateAverage PROC FAR
  ; 代码实现，计算人均
  MOV CX, 21
  MOV DI, OFFSET DATASEG + 5
  ; 计算人均
CALC:
  MOV AX, [DI]         ; 将收入的低16位加载到AX中
  MOV DX, [DI + 2]         ; 将收入的高16位加载到DX中
  MOV BX, [DI + 5]         ; 将人数加载到BX中
  ; 执行除法
  DIV BX               ; DX:AX / BX，商在AX，余数在DX
  ; 将人均移到table中
  MOV WORD PTR [DI + 8], AX
  ADD DI, 16
  LOOP CALC
  RET
CalculateAverage ENDP
CODESEG ENDS
end