PUBLIC MoveYear
CODESEG SEGMENT
    ASSUME CS:CODESEG
MoveYear PROC FAR
  ; 代码实现，移动年份
   MOV BX, 0 ; 移动的行的数量
NEXT:
  MOV CX, 4 ; 一个year移动四次
  ; 移动year
L1:
  MOV AL, [SI]           ; 将 [SI] 指向的数据加载到 AL 寄存器
  MOV BYTE PTR ES:[DI], AL  ; 将 AL 中的数据存储到 [DI] 指向的地址
  INC SI
  INC DI
  LOOP L1
  
  ADD DI, 12
  INC BX
  CMP BX, 21
  JL NEXT
  RET
MoveYear ENDP
CODESEG ENDS
end