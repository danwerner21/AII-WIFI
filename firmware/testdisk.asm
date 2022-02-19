
;__________________________________________________________________________________________________
;
;	Disk Test 
;
;	WRITTEN BY: DAN WERNER -- 9/6/2020
;
;	
;  
;  
;  
;
;  
;
;__________________________________________________________________________________________________
;
; DATA CONSTANTS
;__________________________________________________________________________________________________
;
;
;
;
;
;
;
;
	.ORG	$2000

PROGRAM_START:
                LDA #'.'
                ORA #$80
                JSR $FDED
                LDA #$00
                STA $2101
                JSR $03E3
                STY $00
                STA $01
                LDA #$00
                LDY #8
                STA ($00),Y
                LDA #$23
                LDY #9
                STA ($00),Y
                JSR GET_BYTE
                CMP #$FF 
                BEQ EXIT
                LDY #4
                STA ($00),Y
                CLC
                ADC $2101 
                STA $2101
                CLC
                LDA #'T'
                ORA #$80
                JSR $FDED
                JSR GET_BYTE
                LDY #5
                STA ($00),Y
                CLC
                ADC $2101 
                STA $2101
                CLC
                LDA #'S'
                ORA #$80
                JSR $FDED
                LDA #$00
                LDY #3
                STA ($00),Y
                LDY #$0B
                STA ($00),Y
                LDA #$02
                LDY #$0C
                STA ($00),Y
                LDX #$00
SECTOR_LOOP:    
                JSR GET_BYTE
                STA $2300,X
                CLC
                ADC $2101 
                STA $2101
                CLC
                INX
                CPX #$00
                BNE SECTOR_LOOP
                JSR $03E3
                JSR $03D9
                LDA #$00
                STA $48
                LDA $2101
                JSR SEND_BYTE
                JMP PROGRAM_START
EXIT:
                BRK
                

GET_BYTE:
                STX $35 
	            LDX $21FF		        ; STORE ACIA OFFSET IN $34
GET_BYTE_1:		
				LDA $C089,X				; ACIA STATUS REGISTER
				AND #$08
				BEQ GET_BYTE_1
				LDA $C088,X				; ACIA DATA REGISTER
                LDX $35
                RTS

SEND_BYTE:
                STX $35 
	            LDX $21FF		        ; STORE ACIA OFFSET IN $34
                PHA
SEND_BYTE_1:		
				LDA $C089,X				; ACIA STATUS REGISTER
				AND #$10
				BEQ SEND_BYTE_1
                PLA
				STA $C088,X				; ACIA DATA REGISTER
                LDX $35
                RTS


    .ORG	$21FF
    .DB     $20


	.END
