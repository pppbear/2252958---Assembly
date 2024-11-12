PUBLIC CONVERT_LOOP

CONVERT SEGMENT
    ASSUME CS:CONVERT
CONVERT_LOOP PROC FAR
  XOR DX, DX
  MOV CX, 10                   ; 基数10，用于逐位转换
L2:
  DIV CX                       ; 将AX中的值除以10，商在AX，余数在DX
  ADD DL, '0'                  ; 将余数转换为ASCII字符
  MOV [DI], DL                 ; 存入buffer中
  XOR DX, DX                   ; 清除DX，以便下一次除法
  DEC DI                       ; DI前移一位
  CMP AX, 0                    ; 检查AX是否为0
  JNE L2             ; 若AX不为0，继续循环
  RET
CONVERT_LOOP ENDP
CONVERT ENDS
end

