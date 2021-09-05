; if we land on road_span_loop_start, we draw one more block of 16 pixels than if
; we land on road_span_loop_end

road_span_loop_start:
    add.w #1,d1
road_span_loop_end:
    add.w #1,d1
; if we land on road_span_loop_start, we draw one more block of 16 pixels than if
; we land on road_span_loop_end
; do we need to update a4 at the end?

    move.l a0,-(a7)
    add.w d1,d1
    add.w d1,d1

    lea $ffff8a2e.w,a0
    clr.w (a0)+          ; destxinc 8a2e.w
    move.w #2,(a0)+          ; destyinc 8a30.w
    move.l a4,(a0)+          ; dest address 8a32.l
    move.w #1,(a0)+          ; xcount 8a36.w
    move.w d1,(a0)+          ; ycount 8a38.w
    move.w #$103,(a0)+       ; hop/op 8a3a.w
    move.b #$c0,(a0)         ; blitter control 8a3c.b

    move.l (a7)+,a0

    ;move.l d6,(a4)+
    ;move.l d7,(a4)+
    ;dbra d1,road_span_loop_start
    jmp $50048
