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

    movem.l d0-d7/a1,-(sp)
    include "generated/engine_top_sprite.s"
    movem.l (sp)+,d0-d7/a1

    move.l (a7)+,a4
    rts       


