draw_engine_top:  ; start of a line
    move.l d5,-(sp)
    move.w d1,-(sp)
    move.l a4,-(a7)

    moveq.l #16,d2           ; ycount
    moveq.l #-64,d6          ; mask control word $c0

    andi.w    #$ff,d0
    asl.w     #2,d0
    movea.l   #$6dec4,a1
    movea.l   (a1,d0.w),a1
    asl.w     #2,d0
    movea.l   #$51558,a2
    lea       4(a2,d0.w),a2
    move.w    4(a2),d0
    move.w    6(a2),d3
    movea.l   $518a0,a0
    andi.l    #$ff,d0
    andi.l    #$ff,d3
    asl.l     #3,d0
    adda.l    d0,a0
    move.l    d3,d0
    asl.l     #2,d0
    add.l     d0,d3
    asl.l     #5,d3
    adda.l    d3,a0
    move.w    (a2),d1
    move.w    2(a2),d4
label_513dc:
    ; transfer mask to halftone
    lea $ffff8a20.w,a4
    move.w #10,(a4)          ; srcxinc 8a20.w
    move.l a1,4(a4)          ; source address 8a24.l
    move.w #2,14(a4)         ; destxinc 8a2e.w
    move.l #$ffff8a00,18(a4) ; dest address 8a32.l
    move.w #16,22(a4)        ; xcount 8a36.w
    move.w #1,24(a4)         ; ycount 8a38.w
    move.w #$203,26(a4)      ; hop/op 8a3a.w
    move.b d6,28(a4)         ; blitter control 8a3c.b

    ; mask init
    lea $ffff8a2e.w,a4
    clr.w (a4)               ; destxinc 8a2e.w
    move.w #8,2(a4)          ; destyinc 8a30.w
    move.w #1,8(a4)          ; xcount 8a36.w
    move.w #$101,12(a4)      ; hop/op 8a3a.w

    ; mask pass 1
    lea $ffff8a32.w,a4
    move.l a0,(a4)           ; dest address 8a32.l
    move.w d2,6(a4)          ; ycount 8a38.w
    move.b d6,10(a4)         ; blitter control 8a3c.b
    addq.l #2,a0

    ; mask pass 2
    move.l a0,(a4)           ; dest address 8a32.l
    move.w d2,6(a4)          ; ycount 8a38.w
    move.b d6,10(a4)         ; blitter control 8a3c.b
    addq.l #2,a0

    ; mask pass 3
    move.l a0,(a4)           ; dest address 8a32.l
    move.w d2,6(a4)          ; ycount 8a38.w
    move.b d6,10(a4)         ; blitter control 8a3c.b
    addq.l #2,a0

    ; mask pass 4
    move.l a0,(a4)           ; dest address 8a32.l
    move.w d2,6(a4)          ; ycount 8a38.w
    move.b d6,10(a4)         ; blitter control 8a3c.b

    ; colour pass
    subq.l #6,a0
    addq.l #2,a1
    lea $ffff8a20.w,a4
    move.w #2,(a4)           ; srcxinc 8a20.w
    move.w #4,2(a4)          ; srcyinc 8a22.w
    move.l a1,4(a4)          ; source address 8a24.l
    move.w #2,14(a4)         ; destxinc 8a2e.w
    move.w #2,16(a4)         ; destyinc 8a30.w
    move.l a0,18(a4)         ; dest address 8a32.l
    move.w #4,22(a4)         ; xcount 8a36.w
    move.w #16,24(a4)        ; ycount 8a38.w
    move.w #$207,26(a4)      ; hop/op 8a3a.w (was 020f)
    move.b d6,28(a4)         ; blitter control 8a3c.b
    subq.l #2,a1

    ; 256 pixels of 4 bitplane graphics data = 128 bytes
    ; 256 pixels of mask data = 32 bytes
    lea 160(a1),a1
    lea 160(a0),a0

    ; blitter code END
    dbra      d4,label_513dc
    move.l (a7)+,a4
    move.w    (sp)+,d1
    move.l    (sp)+,d5
    rts       


