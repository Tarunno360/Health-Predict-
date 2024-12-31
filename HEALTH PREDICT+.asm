.MODEL SMALL
.STACK 100H
.DATA 
    height_conversion_warning db 'Warning: Precise height conversion may be approximate$'
    MENU_MSG DB '*** HEALTH PREDICT+ ***$'
    MENU_1 DB '1. Medical History Monitor$'
    MENU_2 DB '2. BMI Calculator$'
    MENU_3 DB '3. Daily Caloric Needs Calculator$'
    MENU_4 DB '4. Exit$'
    CHOICE_MSG DB 'Enter your choice (1-4): $'

    
    
    MSG1 DB 'Enter Blood Sugar (mg/dL) in 2 digits: $'
    MSG2 DB 'Enter Systolic BP (mmHg) digits choice [2 for 2 digits/3 for 3 digits]: $'
    MSG3 DB 'Enter Systolic BP (mmHg): $'
    MSG4 DB 'Enter Diastolic BP (mmHg) in 2 digits: $'
    MSG5 DB 'Enter Oxygen Saturation (%) in 2 digits: $'
    MSG6 DB 'Enter Uric Acid (mg/dL) in 1 digit: $'
    
    NEWLINE DB 0DH,0AH,'$'
    SPACE DB '  $'
    
    SUGAR DW ?
    SYSTOLIC DW ?
    DIASTOLIC DW ?
    OXYGEN DW ?
    URIC DB ?
    CHOICE DB ?
    
    HEADER DB 'Medical History  |Value| Normal|           Diagnosis                         |$'                       
    LINE DB '--------------------------------------------------------------------------------$'
    
    PARAM1 DB 'Blood Sugar(mg/dL)  $'
    PARAM2 DB 'Systolic BP(mmHg)  $'    
    PARAM3 DB 'Diastolic BP(mmHg)  $'
    PARAM4 DB 'Oxygen Sat(%)       $'
    PARAM5 DB 'Uric Acid(mg/dL)     $'
                                            
    RANGE1 DB '70-90  $'
    RANGE2 DB '90-120 $'
    RANGE3 DB '60-80  $'
    RANGE4 DB '95-100 $'
    RANGE5 DB '3-7    $'
    
    NORMAL_MSG_BS DB 'Your Blood Sugar level is normal$'
    HIGH_MSG_BS DB 'You are likely to be diabetic.  Consult Specialist$'
    LOW_MSG_BS DB 'Your blood sugar level is low. Consult Specialist$'
    
    NORMAL_MSG_BP DB 'Your Blood Pressure is normal$'
    HIGH_MSG_BP DB 'You have High Pressure.  Consult Specialist$'
    LOW_MSG_BP DB 'You have Low Pressure.  Consult Specialist$'
    
    
        
    NORMAL_MSG_OS DB 'Your Oxygen Saturation is normal$'
    HIGH_MSG_OS DB 'Your O2 Saturation is abnormal.  Consult Specialist$'
    LOW_MSG_OS DB 'Your O2 Saturation is low.  Consult Specialist$'
    
        
    NORMAL_MSG_UA DB 'Your Uric Acid Level is normal$'
    HIGH_MSG_UA DB 'You have Hyperuricemia.  Consult Specialist$'
    LOW_MSG_UA DB 'You have Fanconi syndrome.  Consult Specialist$'
    
    
    
    
    
    PROMPT_HEIGHT DB 'Enter height (1 for cm, 2 for inch): $'
    PROMPT_CM DB 'Enter height in cm (3 digits): $'
    PROMPT_INCH DB 'Enter height in inches (2 digits): $'
    PROMPT_WEIGHT DB 'Enter weight (1 for kg, 2 for lb): $'
    PROMPT_KG DB 'Enter weight in kg (2 digits): $'
    PROMPT_LB DB 'Enter weight in lb (3 digits): $'
    BMI_MSG DB 'Your BMI is: $'
    
    
    ; Variables to store measurements with decimal precision
    ; We'll store values multiplied by 100 to handle 2 decimal places
    HEIGHT DW ?    ; Height in meters * 100
    WEIGHT DW ?    ; Weight in kg * 100
    BMI DW ?       ; BMI * 10 (one decimal place)
    statusLow db 'Low Weight$'
    statusNormal db 'Normal Weight$'
    statusHigh db 'Overweight$'
    temporary db ? 
    
    result_msg db 'Daily calories needed: $'
    prompt_age db 'Enter age in years: $'
    age dw 0       ; Store age in years
    calories dw 0  ; Store final result
    temp dw 0
 
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    
    
    MENU:
    LEA DX, MENU_MSG
    MOV AH, 9
    INT 21H
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    

    LEA DX, MENU_1
    MOV AH, 9
    INT 21H
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    

    LEA DX, MENU_2
    MOV AH, 9
    INT 21H
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    LEA DX, MENU_3
    MOV AH, 9
    INT 21H
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    

    LEA DX, MENU_4
    MOV AH, 9
    INT 21H
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    

    LEA DX, CHOICE_MSG
    MOV AH, 9
    INT 21H

    MOV AH, 1
    INT 21H
    SUB AL, '0'

    CMP AL, 1
    JE VITAL_SIGNS
    CMP AL, 2
    JE BMI_CALC
    CMP AL, 3
    JE CALORIC_CALC

    CMP AL, 4
    JE EXIT_PROGRAM
    JMP MENU

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    VITAL_SIGNS:  
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    
    ; Blood Sugar Input
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    CALL READ_TWO_DIGITS
    MOV SUGAR, AX
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    ; Systolic BP - Choice Input
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    SUB AL, '0'
    MOV CHOICE, AL
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    LEA DX, MSG3
    MOV AH, 9
    INT 21H
    
    CMP CHOICE, 2
    JE TWO_DIGITS_INPUT
    JMP THREE_DIGITS_INPUT
    
TWO_DIGITS_INPUT:
    CALL READ_TWO_DIGITS
    MOV SYSTOLIC, AX
    JMP CONTINUE_INPUT
    
THREE_DIGITS_INPUT:
    CALL READ_THREE_DIGITS
    MOV SYSTOLIC, AX
    
CONTINUE_INPUT:
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    ; Diastolic BP
    LEA DX, MSG4
    MOV AH, 9
    INT 21H
    CALL READ_TWO_DIGITS
    MOV DIASTOLIC, AX
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    ; Oxygen Saturation
    LEA DX, MSG5
    MOV AH, 9
    INT 21H
    CALL READ_TWO_DIGITS
    MOV OXYGEN, AX
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    ; Uric Acid
    LEA DX, MSG6
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    SUB AL, '0'
    MOV URIC, AL
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    ; Display Results
    CALL DISPLAY_RESULTS
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    
    JMP MENU 
       
    BMI_CALC: 
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    
     ; Height Unit Selection
    LEA DX, PROMPT_HEIGHT
    MOV AH, 9
    INT 21H
    
    ; Read height unit choice
    MOV AH, 1
    INT 21H
    SUB AL, '0'
 
    

    
    ; Compare choice
    CMP AL, 1
    JE CM_INPUT
    JMP INCH_INPUT
    
CM_INPUT:
    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    
    ; Prompt for cm input
    LEA DX, PROMPT_CM
    MOV AH, 9
    INT 21H
    
    CALL READ_THREE_DIGITS
    
    ; Convert cm to meters (divide by 100)
    ; AX already contains the value in cm
    MOV BX, 100
    MUL BX          ; Multiply by 100 first for 2 decimal precision
    MOV BX, 100
    DIV BX          ; Divide by 100 to convert to meters
    MOV HEIGHT, AX  ; Store height in meters * 100
    JMP WEIGHT_INPUT
    
INCH_INPUT:
    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    
    ; Prompt for inch input
    LEA DX, PROMPT_INCH
    MOV AH, 9
    INT 21H
    
    CALL READ_TWO_DIGITS
    
    ; Convert inches to meters
    ; Formula: meters = inches * 0.0254
    ; We'll multiply by 254 and divide by 10000 for precision
    MOV BX, 254

    MUL BX
    MOV BX, 100    ; To keep 2 decimal places
    DIV BX
    MOV HEIGHT, AX
    
WEIGHT_INPUT:
    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    
    ; Print weight unit choice prompt
    LEA DX, PROMPT_WEIGHT
    MOV AH, 9
    INT 21H
    
    ; Read weight unit choice
    MOV AH, 1
    INT 21H
    SUB AL, '0'
    
    ; Compare choice
    CMP AL, 1
    JE KG_INPUT
    JMP LB_INPUT
    
KG_INPUT:
    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    
    ; Prompt for kg input
    LEA DX, PROMPT_KG
    MOV AH, 9
    INT 21H
    
    CALL READ_TWO_DIGITS
    
    ; Store weight in kg * 100 for precision
    MOV BX, 100
    MUL BX
    MOV WEIGHT, AX
    JMP CALCULATE_BMI
    
LB_INPUT:
    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    
    ; Prompt for lb input
    LEA DX, PROMPT_LB
    MOV AH, 9
    INT 21H
    
    CALL READ_THREE_DIGITS
    
    ; Convert lb to kg
    ; Formula: kg = lb * 0.45359237
    ; We'll multiply by 45359 and divide by 100000 for approximation
    MOV BX, 45
    MUL BX
    MOV BX, 100
    DIV BX
    MOV BX, 100    ; Multiply by 100 for precision
    MUL BX
    MOV WEIGHT, AX
    
CALCULATE_BMI:
    ; Calculate BMI = weight / (height * height)
    ; All values are scaled: weight * 100, height * 100
    
    ; First calculate height squared
    MOV AX, HEIGHT
    MOV BX, HEIGHT
    MUL BX          ; Result in DX:AX
    
    ; Adjust for scaling (divide by 100 to account for extra multiplication)
    MOV BX, 100
    DIV BX
    
    ; Save height squared in BX
    MOV BX, AX
    
    ; Now divide weight by height squared
    MOV AX, WEIGHT
    MOV DX, 0
    DIV BX
    
    ; Multiply by 10 for one decimal place
    MOV BX, 10
    MUL BX
    
    ; Store final BMI (with one decimal place)
    MOV BMI, AX
    
    ; Print result
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    
    LEA DX, BMI_MSG
    MOV AH, 9
    INT 21H
    
    ; Display BMI (implement your own number display routine here)
    MOV AX, BMI
    CALL DISPLAY_NUM 
    CALL CheckBMIStatus
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    
    
    JMP MENU  
    
    
    CALORIC_CALC: 
    
        PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    
     ; Height Unit Selection
    LEA DX, PROMPT_HEIGHT
    MOV AH, 9
    INT 21H
    
    ; Read height unit choice
    MOV AH, 1
    INT 21H
    SUB AL, '0'
 
    

    
    ; Compare choice
    CMP AL, 1
    JE CM_INPUT_Calories
    JMP INCH_INPUT_Calories
    
CM_INPUT_Calories:
    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    
    ; Prompt for cm input
    LEA DX, PROMPT_CM
    MOV AH, 9
    INT 21H
    
    CALL READ_THREE_DIGITS
    

    MOV HEIGHT, AX  ; Store height in meters * 100
    JMP WEIGHT_INPUT_Calories
    
INCH_INPUT_Calories:
    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    
    ; Prompt for inch input
    LEA DX, PROMPT_INCH
    MOV AH, 9
    INT 21H
    
    CALL READ_TWO_DIGITS
    
    ; Convert inches to meters
    ; Formula: meters = inches * 2.54
    ; We'll multiply by 254 and divide by 100 for precision
    MOV BX, 254
    MUL BX
    MOV BX, 100    ; To keep 2 decimal places
    DIV BX
    MOV HEIGHT, AX
    
WEIGHT_INPUT_Calories:
    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    
    ; Print weight unit choice prompt
    LEA DX, PROMPT_WEIGHT
    MOV AH, 9
    INT 21H
    
    ; Read weight unit choice
    MOV AH, 1
    INT 21H
    SUB AL, '0'
    
    ; Compare choice
    CMP AL, 1
    JE KG_INPUT_Calories
    JMP LB_INPUT_Calories
    
KG_INPUT_Calories:
    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    
    ; Prompt for kg input
    LEA DX, PROMPT_KG
    MOV AH, 9
    INT 21H
    
    CALL READ_TWO_DIGITS
    
    ; Store weight in kg * 100 for precision

    MOV WEIGHT, AX
    JMP CALCULATE_Calories
    
LB_INPUT_Calories:
    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    
    ; Prompt for lb input
    LEA DX, PROMPT_LB
    MOV AH, 9
    INT 21H
    
    CALL READ_THREE_DIGITS
    
    ; Convert lb to kg
    ; Formula: kg = lb * 0.45359237
    ; We'll multiply by 45359 and divide by 100000 for approximation
    MOV BX, 45
    MUL BX
    MOV BX, 100
    DIV BX

    MOV WEIGHT, AX
       ; 13.7 x weight
       
    
    CALCULATE_Calories:   
    LEA DX, prompt_age
    MOV AH, 9
    INT 21H
    CALL READ_TWO_DIGITS
    MOV AGE, AX   
       
       
       
       
    
    
    MOV AX, weight
    MOV BX, 137
    MUL BX
    MOV BX, 10
    MOV DX,0
    DIV BX
    MOV temp, AX
    
    ; Add 66
    ADD temp, 66
    
    ; 5 x height
    MOV AX, height
    MOV BX, 5
    MUL BX
    ADD temp, AX
    
    ; 6.8 x age
    MOV AX, age
    MOV BX, 68
    MUL BX
    MOV BX, 10
    DIV BX
    SUB temp, AX
    
    ; Multiply by 1.1 and 1.15
    ; Combined factor: 1.265 (represented as 1265/1000)
    MOV AX, temp
    MOV BX, 1265
    MUL BX
    MOV BX, 1000
    DIV BX
    MOV calories, AX
    
    ; Print result
    LEA DX, newline
    MOV AH, 9
    INT 21H
    
    LEA DX, result_msg
    MOV AH, 9
    INT 21H
    
    MOV AX, calories
    CALL print_num 
    JMP MENU
    
    ; Exit program
    EXIT_PROGRAM:
    MOV AH, 4CH
    INT 21H
MAIN ENDP

READ_TWO_DIGITS PROC

    PUSH BX
    MOV AH, 1
    INT 21H
    SUB AL, '0'
    MOV BL, AL    ; First digit in BL
    
    MOV AH, 1
    INT 21H
    SUB AL, '0'   ; Second digit in AL
    
    MOV BH, 0     ; Clear BH
    MOV AH, 0     ; Clear AH
    
    PUSH AX       ; Save second digit
    
    MOV AL, BL    ; Move first digit to AL
    MOV BL, 10
    MUL BL        ; Multiply first digit by 10
    
    POP BX        ; Get back second digit in BL
    ADD AL, BL    ; Add second digit
    
    MOV AH, 0     ; Clear AH for final result
    POP BX
    RET
READ_TWO_DIGITS ENDP

READ_THREE_DIGITS PROC
    PUSH BX
    PUSH CX
    
    MOV AH, 1
    INT 21H
    SUB AL, '0'
    MOV BL, AL    ; First digit
    
    MOV AH, 1
    INT 21H
    SUB AL, '0'
    MOV CL, AL    ; Second digit
    
    MOV AH, 1
    INT 21H
    SUB AL, '0'   ; Third digit
    
    PUSH AX
    
    MOV AL, BL
    MOV BL, 100
    MUL BL        ; First digit * 100
    MOV BX, AX
    
    MOV AL, CL
    MOV CL, 10
    MUL CL        ; Second digit * 10
    ADD BX, AX
    
    POP AX
    AND AX, 00FFH ; Clear AH
    ADD AX, BX    ; Add third digit
    
    POP CX
    POP BX
    RET
READ_THREE_DIGITS ENDP

PRINT_NUM PROC
    MOV CX, 0
    MOV BX, 10
    
DIVIDE:
    MOV DX, 0
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE DIVIDE
    
PRINT_DIGITS:
    POP DX
    ADD DL, '0'
    MOV AH, 2
    INT 21H
    LOOP PRINT_DIGITS
    RET
PRINT_NUM ENDP

DISPLAY_RESULTS PROC
    ; Print Header
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    LEA DX, HEADER
    MOV AH, 9
    INT 21H
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    LEA DX, LINE
    MOV AH, 9
    INT 21H
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    ; Blood Sugar Row
    LEA DX, PARAM1
    MOV AH, 9
    INT 21H
    
    MOV AX, SUGAR
    CALL PRINT_NUM
    
    LEA DX, SPACE
    MOV AH, 9
    INT 21H
    
    LEA DX, RANGE1
    MOV AH, 9
    INT 21H
    
    MOV AX, SUGAR
    CMP AX, 70
    JL SUGAR_LOW
    CMP AX, 90
    JG SUGAR_HIGH
    
    LEA DX, NORMAL_MSG_BS
    JMP PRINT_SUGAR
    
SUGAR_LOW:
    LEA DX, LOW_MSG_BS
    JMP PRINT_SUGAR
    
SUGAR_HIGH:
    LEA DX, HIGH_MSG_BS
    
PRINT_SUGAR:
    MOV AH, 9
    INT 21H
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    ; Systolic BP Row
    LEA DX, PARAM2
    MOV AH, 9
    INT 21H
    
    MOV AX, SYSTOLIC
    CALL PRINT_NUM
    
    LEA DX, SPACE
    MOV AH, 9
    INT 21H
    
    LEA DX, RANGE2
    MOV AH, 9
    INT 21H
    
    MOV AX, SYSTOLIC
    CMP AX, 90
    JL SYS_LOW
    CMP AX, 120
    JG SYS_HIGH
    
    LEA DX, NORMAL_MSG_BP
    JMP PRINT_SYS
    
SYS_LOW:
    LEA DX, LOW_MSG_BP
    JMP PRINT_SYS
    
SYS_HIGH:
    LEA DX, HIGH_MSG_BP
    
PRINT_SYS:
    MOV AH, 9
    INT 21H
    
     
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    PUSH DX 
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    ; Diastolic BP Row
    LEA DX, PARAM3
    MOV AH, 9
    INT 21H
    
    MOV AX, DIASTOLIC
    CALL PRINT_NUM
    
    LEA DX, SPACE
    MOV AH, 9
    INT 21H
    
    LEA DX, RANGE3
    MOV AH, 9
    INT 21H
    
    MOV AX, DIASTOLIC
    CMP AX, 60
    JL DIA_LOW
    CMP AX, 80
    JG DIA_HIGH
    
    LEA DX, NORMAL_MSG_BP
    JMP PRINT_DIA
    
DIA_LOW:
    LEA DX, LOW_MSG_BP
    JMP PRINT_DIA
    
DIA_HIGH:
    LEA DX, HIGH_MSG_BP
    
PRINT_DIA:
    MOV AH, 9
    INT 21H
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    ; Oxygen Saturation Row
    LEA DX, PARAM4
    MOV AH, 9
    INT 21H
    
    MOV AX, OXYGEN
    CALL PRINT_NUM
    
    LEA DX, SPACE
    MOV AH, 9
    INT 21H
    
    LEA DX, RANGE4
    MOV AH, 9
    INT 21H
    
    MOV AX, OXYGEN
    CMP AX, 95
    JL OXY_LOW
    CMP AX, 100
    JG OXY_HIGH
    
    LEA DX, NORMAL_MSG_OS
    JMP PRINT_OXY
    
OXY_LOW:
    LEA DX, LOW_MSG_OS
    JMP PRINT_OXY
    
OXY_HIGH:
    LEA DX, HIGH_MSG_OS
    
PRINT_OXY:
    MOV AH, 9
    INT 21H
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX    
    ; Uric Acid Row
    LEA DX, PARAM5
    MOV AH, 9
    INT 21H
    
    MOV AL, URIC
    MOV AH, 0
    CALL PRINT_NUM
    
    LEA DX, SPACE
    MOV AH, 9
    INT 21H
    
    LEA DX, RANGE5
    MOV AH, 9
    INT 21H
    
    MOV AL, URIC
    MOV AH, 0
    CMP AL, 3
    JL URIC_LOW
    CMP AL, 7
    JG URIC_HIGH
    
    LEA DX, NORMAL_MSG_UA
    JMP PRINT_URIC
    
URIC_LOW:
    LEA DX, LOW_MSG_UA
    JMP PRINT_URIC
    
URIC_HIGH:
    LEA DX, HIGH_MSG_UA
    
PRINT_URIC:
    MOV AH, 9
    INT 21H
    
    PUSH DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    POP DX
    RET
DISPLAY_RESULTS ENDP
DISPLAY_NUM PROC
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AX,BMI
    MOV DX,0
    ; AX contains the number (multiplied by 10 for one decimal place)
    MOV BX, 10
    DIV BX        ; AX = quotient (integer part), DX = remainder (decimal part)
    
    ; Save decimal part
    PUSH DX
    
    ; Now display the integer part
    MOV CX, 0    ; Counter for digits
    MOV BX, 10
    
DIVIDE_INT:
    MOV DX, 0
    DIV BX       ; Divide by 10
    PUSH DX      ; Save remainder (digit)
    INC CX       ; Increment counter
    CMP AX, 0    ; Check if quotient is 0
    JNE DIVIDE_INT
    
DISPLAY_INT:
    POP DX       ; Get digit
    ADD DL, '0'  ; Convert to ASCII
    MOV AH, 2
    INT 21H
    LOOP DISPLAY_INT
    
    ; Display decimal point
    MOV DL, '.'
    MOV AH, 2
    INT 21H
    
    ; Display decimal part
    POP DX       ; Get back the decimal part
    ADD DL, '0'  ; Convert to ASCII
    MOV AH, 2
    INT 21H
    
    POP DX
    POP CX
    POP BX
    RET
DISPLAY_NUM ENDP
; BMI Status Check Procedure
CheckBMIStatus PROC
    ; Assume BMI is in AX (scaled)

    
    ; Print status message
    mov dl, ' '
    mov ah, 2
    int 21h

    ; BMI Status Check
    MOV AX,BMI
    cmp ax, 185     ; 18.5 * 10
    jl LowBMI
    
    cmp ax, 250     ; 25.0 * 10
    jl NormalBMI
    
    ; If we reach here, it's High BMI
HighBMI:
    lea dx, statusHigh
    jmp PrintBMIStatus

LowBMI:
    lea dx, statusLow
    jmp PrintBMIStatus

NormalBMI:
    lea dx, statusNormal
    jmp PrintBMIStatus

PrintBMIStatus:
    mov ah, 9
    int 21h

    ret
CheckBMIStatus ENDP

END MAIN