    ORG $80000

    move.l a0,-(a7)
    move.l d0,-(a7)

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

    ; at this point, a4 contains address of control
    ; a0 contains destination

    move.l $518a4,a0
    moveq.l #3,d0

    rept 3
    move.l a0,-10(a4)   ; 8a32.l destaddress
    move.w d4,-4(a4)    ; 8a38.w ycount
    move.b #$c0,(a4)    ; 8a3c.b control
    addq.l #2,a0
    endr
    move.l a0,-10(a4)   ; 8a32.l destaddress
    move.w d4,-4(a4)    ; 8a38.w ycount
    move.w #$0,-2(a4)     ; 8a3a.w hop/op
    move.b #$c0,(a4)    ; 8a3c.b control

    move.l (a7)+,d0     ; restore d0
    move.l (a7)+,a0     ; restore a0

    jmp $4f2f6



