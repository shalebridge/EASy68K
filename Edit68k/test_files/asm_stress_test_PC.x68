        ORG     $1000
START
; ---- Test vanilla PC and * as both current location and as multiply ----
        MOVE.L (PC),D0                  ; 203A 0000
        MOVE.L 4(PC),D0                 ; 203A 0004 ; These should
        MOVE.L (4,PC),D0                ; 203A 0004 ;  be the same
        MOVE.L (*+4*2,PC,D3.W),D1       ; 223B 3006
        MOVE.L (4+*,PC,D4.W),D1         ; 223B 4002
        MOVE.L (2+*+2,PC,D5.W),D1       ; 223B 5002
        MOVE.L (.$test+$2, PC,D6.W),D1
.$test        
; ---- D2.W as index (ext word top nibble = 0x2, size=W so +0x0000) ----
        ADD.B   (next+2,PC,D2.W),D3     ; D63B 2008   ; disp = +2
        ADD.B   (2+next,PC,D2.W),D3     ; D63B 2004   ; disp = +2
next:   NOP
        ADD.B   (next2,PC,D2.W),D3      ; D63B 2008
        ADD.B   (1,PC,D2.W),D3          ; D63B 2001
        NOP
next2:
; ---- D2.L as index (ext word top nibble = 0x2, size=L -> ext word adds 0x0800) ----
        MOVE.L  (0,PC,D2.L),D0          ; 203B 2800
        MOVE.L  (2,PC,D2.L),D0          ; 203B 2802
        MOVE.L  (-12,PC,D2.L),D0        ; 203B 28F4

; ---- D0.W as index (ext top nibble = 0x0) & various signed disps ----
        MOVE.L  (0,PC,D1.W),D0          ; 203B 1000
        MOVE.L  (1,PC,D1.W),D0          ; 203B 1001
        MOVE.L  (2,PC,D1.W),D0          ; 203B 1002
        MOVE.L  (44,PC,D0.W),D0         ; 203B 002C
        MOVE.L  (-12,PC,D0.W),D0        ; 203B 00F4
        MOVE.L  (13,PC,D0.W),D0         ; 203B 000D
        MOVE.L  (-42,PC,D0.W),D0        ; 203B 00D6

; ---- Forward/backward label sensitivity ----
        ADD.B   (next3,PC,D2.W),D3      ; D63B 2002
next3:  NOP
        MOVE.L  (next3,PC,D2.W),D3      ; 263B 20FC
        
; ---- Forward/backward local label sensitivity ----
        ADD.B   (.next4,PC,D2.W),D3      ; D63B 2002
.next4:  NOP
        MOVE.L  (.next4,PC,D2.W),D3      ; 263B 20FC
        
; ---- Forward/backward local label sensitivity with offset ----
        ADD.B   (2+.next5,PC,D2.W),D3      ; D63B 2004
.next5:  NOP
        MOVE.L  (.next5+2,PC,D2.W),D3      ; 263B 20FE
        
; ---- Range checking ----
        MOVE.L  (127,PC,D0.W),D0        ; 203B 007F
        MOVE.L  (-128,PC,D0.W),D0       ; 203B 0080

        ; Out-of-range should error (expect assembler errors):
        MOVE.L  (128,PC,D0.W),D0        ; ERROR: displacement out of range
        MOVE.L  (-129,PC,D0.W),D0       ; ERROR: displacement out of range

; ---- DISPLACEMENT ONLY (d16,PC) - 16-bit signed displacement ----
        ; (d16,PC) encodes as one extension word with a full signed 16-bit disp
        MOVE.W  (0,PC),D1               ; 323A 0000
        MOVE.W  (2,PC),D1               ; 323A 0002
        MOVE.W  (-2,PC),D1              ; 323A FFFE

        LEA     (0,PC),A0               ; 41FA 0000
        LEA     (6,PC),A0               ; 41FA 0006
        LEA     (-6,PC),A0              ; 41FA FFFA
        
        ; Forward symbol (forces the assembler to compute using the correct PC baseline)
        MOVE.L  (SYMBA,PC,D2.W),D3       ; 263B 20??   ; depends on where SYMA lands (should be signed 8-bit)
        BRA.S   afterSYMBA               ; 6002
SYMBA:   NOP
afterSYMBA:
        MOVE.L  (SYMBA,PC,D2.W),D3       ; 263B 20FC   ; back-ref: disp=-2 - sizeof(NOP)

        
        END START












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
