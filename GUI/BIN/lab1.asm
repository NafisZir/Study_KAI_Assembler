STACKSG SEGMENT PARA STACK 
	DB 64 DUP(?) 
STACKSG ENDS 
DATASG SEGMENT PARA 'DATA' 
STR1 DB '1234' 
STR2 DB 4 DUP(' ') 
DATASG ENDS 
CODESG SEGMENT PARA 'CODE' 
ASSUME CS:CODESG,DS:DATASG,SS:STACKSG 
ENTRY PROC FAR 
; Стандартная часть 
PUSH DS 
SUB AX,AX 
PUSH AX 
MOV AX,DATASG 
MOV DS,AX 
;
MOV  DX,4 ; общее количество перестановок 
; Переслать первый символ из STR1 в STR2
M1: 
LEA DI,STR1    ; загрузить в DI смещение первого байта из STR1 
LEA SI,STR2    ; загрузить в SI смещение первого байта из STR3 
MOV CX,3 
MOV AL,[DI]    ; переслать в AL первый байт из STR1 
MOV [SI]+3,AL  ; переслать в последний байт из STR2 содержимое AL 
INC  DI ; DI=DI+1 - следующий символ из STR1 
; 
; переслать остаток строки STR1 в STR2 
M2: 
MOV AL,[DI] ; в AL следующий символ из STR1 
MOV [SI],AL ; переслать AL в очередной (с первого) байт в STR2 
INC DI ; DI=DI+1 - следующий символ из STR1 
INC SI ; SI=SI+1 - следующий символ из STR2 
LOOP M2 ; идти на M2 
; 
; переслать STR2 в STR1 
LEA  DI,STR1 
LEA  SI,STR2 
MOV CX,4 
M3: 
MOV AL,[SI] 
MOV [DI],AL 
INC DI 
INC SI 
LOOP M3 
; 
DEC  DX 
CMP  DX,00 ; Все перестановки сделаны? 
JNE  M1 ; Нет - идти на M1 
RET
ENTRY    ENDP 
CODESG ENDS                  
END   ENTRY
