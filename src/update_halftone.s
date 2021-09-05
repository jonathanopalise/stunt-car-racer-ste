update_halftone:
    move.l #$4e0a0,a5  ; instruction previously located at 4feb6

    move.l a0,-(a7)
    lea $ffff8a00.w,a0

    rept 4
    move.l d6,(a0)+
    move.l d7,(a0)+
    endr

    move.l (a7)+,a0

    rts
