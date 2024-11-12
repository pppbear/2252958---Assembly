STKSEG SEGMENT STACK
DW 30000 DUP(0)
STKSEG ENDS

DATASEG SEGMENT 
;以下是表示 21 年的 21 个字符串
DB '1975','1976','1977','1978','1979','1980','1981','1982','1983' 
DB '1984','1985','1986','1987','1988','1989','1990','1991','1992' 
DB '1993','1994','1995' 
 
;以下是表示 21 年公司总收的 21 个 dword 型数据
DD 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514 
DD 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000 
 
;以下是表示 21 年公司雇员人数的 21 个 word 型数据
DW 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226 
DW 11542,14430,15257,17800 
DATASEG ENDS

TABLE SEGMENT
DB 21 DUP('year summ ne ?? ')
TABLE ENDS

BUFFER SEGMENT
BUF DB 8 DUP(0)   ; 占用8字节
TEMP DB 0        ; 定义一个 8 位的内存变量，用于存放 DH
BUFFER ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG, DS:DATASEG, ES:TABLE
MAIN PROC FAR
  MOV AX, DATASEG
  MOV ES, AX
  MOV DI, OFFSET DATASEG ; DI 寄存器指向 TABLE 段的开始位置

  MOV AX, DATASEG
  MOV DS, AX
  MOV SI, 0

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

  MOV DI, OFFSET DATASEG + 5

  MOV BX, 0
  ; 移动收入
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

  ; 打印table
  MOV AH,00H ; 清屏
  MOV AL,03H
  INT 10H

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

  ; 打印收入
  MOV DH, 0  ; 行号
  MOV TEMP, DH
  MOV SI, OFFSET DATASEG + 5
PRINT_INCOME:
  MOV AX, [SI]         ; 将收入的低16位加载到AX中
  MOV DX, [SI + 2]         ; 将收入的高16位加载到DX中
  MOV DI, OFFSET BUF + 7    ; DI指向buffer的最后一个字符
  MOV CX, 100                  ; 基数100，用于两位转换

  ; 第一次除法，将DX:AX / 100，商存入AX，余数存入DX
  DIV CX      
  MOV BX, AX                      ; 保存商（高位部分）
  CMP DX, 0
  JNZ NOT_ZERO   
ZERO:
  CALL CONVERT_ZERO
  JMP END3                
NOT_ZERO:
  CALL CONVERT_NOT_ZERO
END3: 
  MOV DL, 20
  CALL PRINT_WORD
  CMP DH, 21
  JL PRINT_INCOME

  ; 打印人数
  MOV DH, 0  ; 行号
  MOV TEMP, DH
  MOV SI, OFFSET DATASEG + 10
PRINT_PEOPLE:
  MOV AX, [SI] 
  MOV DI, OFFSET BUF + 7
  CALL CONVERT_LOOP
  ; 打印转换后的数字
  MOV DL, 35
  CALL PRINT_WORD
  CMP DH, 21
  JL PRINT_PEOPLE
  
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
  CALL PRINT_WORD
  CMP DH, 21
  JL PRINT_AVA

  ; 设置光标位置
  MOV AH,02H
  MOV DH,24
  MOV DL,0
  INT 10H
ERROR_DIV_ZERO:
  MOV AH, 4CH
  INT 21H
MAIN ENDP
CONVERT_ZERO PROC
  ADD DL, '0'                  ; 将余数转换为ASCII字符
  MOV [DI], DL                 ; 存入buffer中
  DEC DI
  MOV [DI], DL
  DEC DI
  MOV AX, BX
  CMP AX, 0
  JZ END1 
  CALL CONVERT_HIGH
END1: 
  RET
CONVERT_ZERO ENDP

CONVERT_NOT_ZERO PROC
    MOV AX, DX                   ; 将余数加载到AX中，用于接下来的逐位转换
  
    CALL CONVERT_LOOP
    ; 恢复商并继续处理
    MOV AX, BX
    CMP AX, 0
    JZ END2            ; 如果商为0，跳到结束
    CALL CONVERT_HIGH
END2: 
  RET
CONVERT_NOT_ZERO ENDP

CONVERT_LOOP PROC
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

CONVERT_HIGH PROC  
  CALL CONVERT_LOOP
  RET
CONVERT_HIGH ENDP

PRINT_WORD PROC 
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
PRINT_WORD ENDP
CODESEG ENDS
  END MAIN 