draw_ground:

    move.l a0,usp
    move.l a4,a0

    addq.l #1,d4
    lea $ffff8a28.w,a4
    move.w #-1,(a4)+    ; 8a28.w endmask1
    move.w #-1,(a4)+    ; 8a2a.w endmask2
    move.w #-1,(a4)+    ; 8a2c.w endmask3
    move.w #8,(a4)+     ; 8a2e.w destxinc
    move.w #40,(a4)+    ; 8a30.w destyinc
    addq.l #4,a4
    move.w #16,(a4)+    ; 8a36.w xcount
    addq.l #2,a4
    move.w #$f,(a4)+    ; 8a3a.w hop/op

    move.l a0,-10(a4)   ; 8a32.l destaddress
    move.w d4,-4(a4)    ; 8a38.w ycount
    move.b #$c0,(a4)    ; 8a3c.b control
    addq.l #4,a0        ; move to third plane

    move.l a0,-10(a4)   ; 8a32.l destaddress
    move.w d4,-4(a4)    ; 8a38.w ycount
    move.b #$c0,(a4)    ; 8a3c.b control
    addq.l #2,a0        ; move to fourth plane

    move.l a0,-10(a4)   ; 8a32.l destaddress
    move.w d4,-4(a4)    ; 8a38.w ycount
    move.b #$c0,(a4)    ; 8a3c.b control
    subq.l #4,a0        ; move to next plane

    move.l a0,-10(a4)   ; 8a32.l destaddress
    move.w d4,-4(a4)    ; 8a38.w ycount
    clr.w -2(a4)        ; 8a3a.w hop/op
    move.b #$c0,(a4)    ; 8a3c.b control

    move.l usp,a0     ; restore a0

    jmp $4f290

