
;__________________________________________________________________________________________________
;
;	MINI TERMINAL PROGRAM
;
;	WRITTEN BY: DAN WERNER -- 8/26/2020
;
;	This is designed to aid in testing the apple II WiFi Card
;__________________________________________________________________________________________________
;
; DATA CONSTANTS
;__________________________________________________________________________________________________
;
;
	.ORG	$C200

	         	CLD				;  VERIFY DECIMAL MODE IS OFF
				LDA #$60
				STA $CD
				PHP
				SEI 
				JSR $00CD
				TSX
				LDA $0100,X 
				AND #$0F
				ASL
				ASL 
				ASL 
				ASL 				
				STA $34			; STORE ACIA OFFSET IN $34
				TAX
				PLP				
				LDA #$18
				STA $C08B,X
				LDA #$0B
				STA $C08A,X
;
;   BOOT PROGRAM
;
BOOT_PROGRAM:
				LDA #$20
				STA $CE
				LDA #$00 
				STA $CD 				
				TAY
BOOT_PROGRAM_1:		
				LDA $C089,X				; ACIA STATUS REGISTER
				AND #$08
				BEQ BOOT_PROGRAM_1		
				LDA $C088,X				; ACIA DATA REGISTER
				STA ($CD),Y
				INC $CD
				BNE BOOT_PROGRAM_1		
				INC $CE
				LDA $CE
				CMP #$40
				BNE BOOT_PROGRAM_1		
				JMP $2000
;
;   TRANSMIT BUFFER
;
;   X - LOW BYTE POINTER TO NULL TERMINATED STRING
;   Y - HIGH BYTE POINTER TO NULL TERMINATED STRING
;   
TRANSMIT_MESSAGE:
				PHA
				STX $CD 
				STY $CE 				
				LDY #$00
				LDX $34
TRANSMIT_MESSAGE_1:
				LDA $C089,X				; ACIA STATUS REGISTER
				AND #$10
				BEQ TRANSMIT_MESSAGE_1
				LDA ($CD),Y 
				BEQ TRANSMIT_MESSAGE_2
				STA $C088,X				; ACIA DATA REGISTER
				INC $CD
				BNE TRANSMIT_MESSAGE_1 
				INC $CE
				BNE TRANSMIT_MESSAGE_1 
TRANSMIT_MESSAGE_2:
				PLA
				RTS
;
;   RECEIVE BUFFER
;
;   X - LOW BYTE POINTER TO BUFFER
;   Y - HIGH BYTE POINTER TO BUFFER
;   RETURNS:
;   A-NUMBER OF BYTES READ
RECEIVE_MESSAGE:
				STX $CD 
				STY $CE 				
				LDA #$00
				STA $CF
				TAY 
				LDX $34
RECEIVE_MESSAGE_1:		
				LDA $C089,X				; ACIA STATUS REGISTER
				AND #$08
				BNE RECEIVE_MESSAGE_2		
				INC $CF
				BNE RECEIVE_MESSAGE_1		
				BEQ RECEIVE_MESSAGE_3		
RECEIVE_MESSAGE_2:
				LDA $C088,X				; ACIA DATA REGISTER
				STA ($CD),Y
				INY
				LDA #$00
				STA $CF
				CPY #$FF
				BEQ RECEIVE_MESSAGE_3		
				CMP #$0D
				BNE RECEIVE_MESSAGE_1		
RECEIVE_MESSAGE_3:
				TYA
				RTS

; SETUP CARD  1200, 8N1
;
SETUP:
	         	CLD				;  VERIFY DECIMAL MODE IS OFF
				LDA #$60
				STA $CD
				PHP
				SEI 
				JSR $00CD
				TSX
				LDA $0100,X 
				AND #$0F
				ASL
				ASL 
				ASL 
				ASL 				
				STA $34			; STORE ACIA OFFSET IN $34
				TAX
				PLP				
				LDA #$18
				STA $C08B,X
				LDA #$0B
				STA $C08A,X
				RTS

	.END
