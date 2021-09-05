update_halftone:
    move.l #$4e0a0,a5  ; instruction previously located at 4feb6

    move.l a0,usp

    lea $ffff8a00.w,a0
    rept 4
    move.l d6,(a0)+
    move.l d7,(a0)+
    endr

    lea $ffff8a2e.w,a0
    clr.w (a0)+              ; (8) destxinc 8a2e.w
    move.w #2,(a0)+          ; destyinc 8a30.w
    addq.l #4,a0
    move.w #1,(a0)+          ; xcount 8a36.w
    addq.l #2,a0
    move.w #$103,(a0)+       ; hop/op 8a3a.w

    move.l usp,a0

    rts
