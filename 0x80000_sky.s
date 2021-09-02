    ; 80000

    move.l a0,-(a7)     ; backup a0
    move.l a1,-(a7)     ; backup a0
    move.l a2,-(a7)     ; backup a0

    lea $ffff8a00.w,a0
    move.l d6,(a0)+
    move.l d7,(a0)+
    move.l d6,(a0)+
    move.l d7,(a0)+
    move.l d6,(a0)+
    move.l d7,(a0)+
    move.l d6,(a0)+
    move.l d7,(a0)+
    addq.l #8,a0

    move.w #-1,(a0)+    ; 8a28.w endmask1
    move.w #-1,(a0)+    ; 8a2a.w endmask2
    move.w #-1,(a0)+    ; 8a2c.w endmask3
    move.w #0,(a0)+     ; 8a2e.w destxinc
    move.w #2,(a0)+     ; 8a30.w destyinc
    addq.l #4,a0
    move.w #1,(a0)+     ; 8a36.w xcount
    addq.l #2,a0
    move.w #$103,(a0)+  ; 8a3a.w hop/op, a0 is now 8a3c

    lea -4(a0),a1       ; 8a38.w ycount
    lea -6(a1),a2       ; 8a32.l destaddress

    move.l $518a4,a4    ; set start destination
skyline_loop_start:
    move.l a4,(a2)      ; 8a32.l destaddress
    move.w #64,(a1)     ; 8a38.w ycount
    move.b #$c0,(a0)    ; 8a3c.b control (what about linenum?)
    lea 160(a4),a4      ; move destination to next line
skyline_loop_end:
    dbra d4,skyline_loop_start
    move.l (a7)+,a2     ; restore a2
    move.l (a7)+,a1     ; restore a1
    move.l (a7)+,a0     ; restore a0
    jmp $4f2f6

