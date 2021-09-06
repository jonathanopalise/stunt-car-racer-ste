draw_engine_top:  ; start of a line
    ;move.l a0,a2 
    ;move.w d1,d3  ; d3 = number of 16 pixel blocks

    ; NEW CODE START
    ; don't forget to push a4

    move.l a4,-(a7)

    lea $ffff8a20.w,a4
    move.w #10,(a4)+         ; srcxinc 8a20.w
    addq.l #2,a4             ; skip srcyinc 8a22.w
    move.l a1,(a4)+          ; source address 8a24.l
    move.w #-1,(a4)+         ; endmask1 8a28.w
    move.w #-1,(a4)+         ; endmask2 8a2a.w
    move.w #-1,(a4)+         ; endmask3 8a2c.w
    move.w #2,(a4)+          ; destxinc 8a2e.w
    addq.l #2,a4             ; skip destyinc 8a30.w
    move.l #$ffff8a00,(a4)+  ; dest address 8a32.l
    move.w #16,(a4)+         ; xcount 8a36.w
    move.w #1,(a4)+          ; ycount 8a38.w
    move.w #$203,(a4)+       ; hop/op 8a3a.w
    ;move.b #$c0,(a4)         ; blitter control 8a3c.b

    move.l (a7)+,a4

    ; NEW CODE END

    ;lea $a0(a2),a0
    ;dbra d4,draw_engine_top
    ;move.w (a7)+,d1
    ;move.l (a7)+,d5
    ;rts

    move.l d5,-(sp)
    move.w d1,-(sp)

    move.w (sp)+,d1
    move.l (sp)+,d5
    rts
