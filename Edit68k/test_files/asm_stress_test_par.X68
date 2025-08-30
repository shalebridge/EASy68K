*-----------------------------------------------------------
* EASy68k Assembler Stress Test
*   Tests parenthesized expression bug
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    
    LEA ($0FFF).w,A0
    LEA ($1FFF).w,A0

    LEA ($CFFF).w,A0
    LEA ($DFFF).w,A0
    LEA ($EFFF).w,A0
    
    LEA ($7FFF).w,A0
    LEA ($7FFF).w, A0
    
    LEA ($00007FFF).w,A0
    LEA ($00007FFF).w, A0   


    END    START        ; last line of source
*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
