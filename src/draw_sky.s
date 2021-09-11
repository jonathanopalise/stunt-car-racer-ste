draw_sky:
    move.l a0,usp

    addq.l #1,d4
    lea $ffff8a28.w,a4
    move.w #-1,(a4)+         ; 8a28.w endmask1
    move.w #-1,(a4)+         ; 8a2a.w endmask2
    move.w #-1,(a4)+         ; 8a2c.w endmask3
    move.w #8,(a4)+          ; 8a2e.w destxinc
    move.w #40,(a4)+         ; 8a30.w destyinc
    addq.l #4,a4
    move.w #16,(a4)+         ; 8a36.w xcount
    addq.l #2,a4
    move.w #$f,(a4)+         ; 8a3a.w hop/op

    move.l $518a4,a0

    rept 3
    move.l a0,-10(a4)        ; 8a32.l destaddress
    move.w d4,-4(a4)         ; 8a38.w ycount
    move.b #$c0,(a4)         ; 8a3c.b control
    addq.l #2,a0             ; move to next plane
    endr
    move.l a0,-10(a4)        ; 8a32.l destaddress
    move.w d4,-4(a4)         ; 8a38.w ycount
    clr.w -2(a4)             ; 8a3a.w hop/op
    move.b #$c0,(a4)         ; 8a3c.b control

    ; initialise blitter variables once for subseqent phase of polygon drawing

    lea $ffff8a2e.w,a4
    clr.w (a4)               ; (8) destxinc 8a2e.w
    move.w #2,2(a4)          ; destyinc 8a30.w
    move.w #1,8(a4)          ; xcount 8a36.w
    move.w #$103,12(a4)      ; hop/op 8a3a.w

    move.l usp,a0     ; restore a0

    jmp $4f2f6

