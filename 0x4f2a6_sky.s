    ; 4f2a6

    addq.l #1,d4
    lea $ffff8a28.w,a4
    move.w #-1,(a4)+    ; 8a28.w endmask1
    move.w #-1,(a4)+    ; 8a2a.w endmask2
    move.w #-1,(a4)+    ; 8a2c.w endmask3
    move.w #2,(a4)+     ; 8a2e.w destxinc
    move.w #34,(a4)+    ; 8a30.w destyinc
    move.l $518a4,(a4)+ ; 8a32.l destaddress
    move.w #64,(a4)+    ; 8a36.w xcount
    move.w d4,(a4)+     ; 8a38.w ycount
    move.w #0,(a4)+     ; 8a3a.w hop/op
    move.b #$c0,(a4)    ; 8a3c.b control
    move.l $518a4,a4
    jmp $4f2f6


