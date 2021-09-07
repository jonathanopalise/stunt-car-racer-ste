draw_engine_top:  ; start of a line
    move.l a4,-(a7)

    moveq.l #16,d2           ; ycount
    moveq.l #-64,d6          ; mask control word $c0
    moveq.l #4,d1
    moveq.l #2,d7

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
    move.w    2(a2),d4

    move.l a0,usp            ; back up dest address
    move.l a1,d5             ; back up source address
    moveq.l #1,d3            ; stored constant #1
    move.l #$ffff8a00,d0      ; stored halftone address

    ; significant values here are:
    ; d4 - number of iterations
    ; a0 - destination address
    ; a1 - source address
    lea $ffff8a20.w,a4
    move.w #10,(a4)          ; srcxinc 8a20.w
label_513dc:
    ; transfer mask to halftone
    lea $ffff8a20.w,a4
    move.l a1,4(a4)          ; source address 8a24.l
    move.w d7,14(a4)         ; destxinc 8a2e.w
    move.l d0,18(a4)         ; dest address 8a32.l
    move.w d2,22(a4)         ; xcount 8a36.w
    move.w d3,24(a4)         ; ycount 8a38.w
    move.w #$203,26(a4)      ; hop/op 8a3a.w
    move.b d6,28(a4)         ; blitter control 8a3c.b

    ; mask init
    lea $ffff8a2e.w,a4
    clr.w (a4)               ; destxinc 8a2e.w
    move.w #8,2(a4)          ; destyinc 8a30.w
    move.w d3,8(a4)          ; xcount 8a36.w
    move.w #$101,12(a4)      ; hop/op 8a3a.w

    ; mask pass 1
    addq.l #4,a4
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

    lea 160(a1),a1
    lea 160-6(a0),a0

    ; blitter code END
    dbra d4,label_513dc

    move.w 2(a2),d4          ; number of iterations
    move.l usp,a0            ; restore dest address
    move.l d5,a1             ; restore source address
    addq.l #2,a1             ; advance source address to colour data

    ; significant values here are:
    ; d4 - number of iterations
    ; a0 - destination address
    ; a1 - source address
    lea $ffff8a20.w,a4
    move.w d7,(a4)           ; srcxinc 8a20.w
    move.w d1,2(a4)          ; srcyinc 8a22.w
    move.w d7,14(a4)         ; destxinc 8a2e.w
    move.w d7,16(a4)         ; destyinc 8a30.w
    move.w d1,22(a4)         ; xcount 8a36.w
    move.w #$207,26(a4)      ; hop/op 8a3a.w

label_colour:
    lea $ffff8a20.w,a4
    move.l a1,4(a4)          ; source address 8a24.l
    move.l a0,18(a4)         ; dest address 8a32.l
    move.w d2,24(a4)         ; ycount 8a38.w
    move.b d6,28(a4)         ; blitter control 8a3c.b

    lea 160(a1),a1           ; advance source
    lea 160(a0),a0           ; advance destination

    dbra d4,label_colour

    move.l (a7)+,a4
    rts       


