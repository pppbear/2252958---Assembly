INCLUDE stack.inc ; 引入栈段
INCLUDE data.inc  ; 引入数据段
INCLUDE table.inc ; 引入表格段
INCLUDE buffer.inc ; 引入缓冲段

extrn MoveYear:FAR, MoveIncome:FAR, MovePeople:FAR, CalculateAverage:FAR
extrn PrintTable:FAR, PrintWord:FAR


CODESEG SEGMENT
    ASSUME CS:CODESEG, DS:DATASEG, ES:TABLE
MAIN PROC FAR
  ; 初始化数据段
  MOV AX, DATASEG
  MOV ES, AX
  MOV DI, OFFSET DATASEG
  MOV AX, DATASEG
  MOV DS, AX
  MOV SI, 0
  MOV BX, 0 ; 行计数
  CALL MoveYear

  MOV DI, OFFSET DATASEG + 5
  CALL MoveIncome

  MOV DI, OFFSET DATASEG + 10
  CALL MovePeople

  MOV CX, 21
  MOV DI, OFFSET DATASEG + 5
  CALL CalculateAverage

  ; 清屏
  MOV AH, 00H
  MOV AL, 03H
  INT 10H

  ; 打印表格数据
  CALL PrintTable

  ; 退出程序
  MOV AH, 4CH
  INT 21H
MAIN ENDP
CODESEG ENDS
END MAIN
