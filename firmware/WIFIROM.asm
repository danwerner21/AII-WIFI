
;__________________________________________________________________________________________________
;
;	WIFI ROM DRIVER
;
;	WRITTEN BY: DAN WERNER -- 8/26/2020
;
;	This is designed to work with the apple II WiFi Card.   This code should be slot independent.
;  assuming that the Wifi card is configured, this program should connect to the server and download/run a program
;  in location $2000-3fff by executing
;   PR#x  
;
;   a small program is required to config wifi on the card, and find the apple's ip address.
;
;__________________________________________________________________________________________________
;
; DATA CONSTANTS
;__________________________________________________________________________________________________
;
;
	.ORG	$C200

                JSR $FF4A
                SEI
                JSR $FF58
                TSX
                LDA $0100,X 
                STA $07F8
				AND #$0F
				ASL A
				ASL A 
				ASL A 
				ASL A 				
				STA $34			; STORE ACIA OFFSET IN $34
				TAX
				LDA #$16
				STA $C08B,X
				LDA #$0B
				STA $C08A,X
RECEIVE_CHAR_1:		
				LDA $C089,X				; ACIA STATUS REGISTER
				AND #$08
				BEQ RECEIVE_CHAR_1
RECEIVE_MESSAGE_2:
				LDA $C088,X				; ACIA DATA REGISTER
				STA $45
                JMP $FF3F



MINI_TERMINAL:
                SEI
                JSR $FF58
                TSX
                LDA $0100,X 
                STA $07F8
				AND #$0F
				ASL A
				ASL A
				ASL A 
				ASL A 				
				STA $34			; STORE ACIA OFFSET IN $34
				TAX
				LDA #$16
				STA $C08B,X
				LDA #$0B
				STA $C08A,X
MINI_TERMINAL_1:
				LDA $C089,X				; ACIA STATUS REGISTER
				AND #$08
				BEQ MINI_TERMINAL_2
                LDA $C088,X				; ACIA DATA REGISTER
                ORA #$80
                JSR $FDED
MINI_TERMINAL_2:           
                LDA $C000
                BPL MINI_TERMINAL_1
                STA $C010
                AND #$7F
                TAY
MINI_TERMINAL_3:                
				LDA $C089,X				; ACIA STATUS REGISTER
                AND #$10
                BEQ MINI_TERMINAL_3
                TYA
                STA $C088,X				; ACIA DATA REGISTER
                CMP #$0D 
                BNE MINI_TERMINAL_1 
                LDY #$0A
                CPY #$00
                BNE MINI_TERMINAL_3


	.END
