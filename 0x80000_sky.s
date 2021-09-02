    ; 80000

    lea $ffff8a00.w,a4
    move.l d6,(a4)+
    move.l d7,(a4)+
    move.l d6,(a4)+
    move.l d7,(a4)+
    move.l d6,(a4)+
    move.l d7,(a4)+
    move.l d6,(a4)+
    move.l d7,(a4)+
    addq.l #8,a4

    move.w #-1,(a4)+    ; 8a28.w endmask1
    move.w #-1,(a4)+    ; 8a2a.w endmask2
    move.w #-1,(a4)+    ; 8a2c.w endmask3
    move.w #0,(a4)+     ; 8a2e.w destxinc
    move.w #2,(a4)+     ; 8a30.w destyinc
    addq.l #4,a4
    move.w #1,(a4)+     ; 8a36.w xcount
    addq.l #2,a4
    move.w #$103,(a4)+  ; 8a3a.w hop/op

    move.l a0,-(a7)     ; backup a0
    lea $ffff8a00.w,a0    ; set a0 to blitter base address
    move.l $518a4,a4    ; set start destination
skyline_loop_start:
    move.l a4,$32(a0)   ; 8a32.l destaddress
    move.w #64,$38(a0)  ; 8a38.w ycount
    move.b #$c0,$3c(a0)  ; 8a3c.b control (what about linenum?)
    lea 160(a4),a4      ; move destination to next line
skyline_loop_end:
    dbra d4,skyline_loop_start
    move.l (a7)+,a0     ; restore a0
    jmp $4f2f6

