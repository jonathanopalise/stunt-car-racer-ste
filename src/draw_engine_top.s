draw_engine_top:  ; start of a line
    ;move.l a0,a2 
    ;move.w d1,d3  ; d3 = number of 16 pixel blocks

    ; NEW CODE START
    ; don't forget to push a4

    ;move.l a4,-(a7)
    ;lea $ffff8a20.w,a4
    ;move.w #10,(a4)+         ; srcxinc 8a20.w
    ;addq.l #2,a4             ; skip srcyinc 8a22.w
    ;move.l a1,(a4)+          ; source address 8a24.l
    ;move.w #-1,(a4)+         ; endmask1 8a28.w
    ;move.w #-1,(a4)+         ; endmask2 8a2a.w
    ;move.w #-1,(a4)+         ; endmask3 8a2c.w
    ;move.w #2,(a4)+          ; destxinc 8a2e.w
    ;addq.l #2,a4             ; skip destyinc 8a30.w
    ;move.l #$ffff8a00,(a4)+  ; dest address 8a32.l
    ;move.w #16,(a4)+         ; xcount 8a36.w
    ;move.w #1,(a4)+          ; ycount 8a38.w
    ;move.w #$203,(a4)+       ; hop/op 8a3a.w
    ;move.b #$c0,(a4)         ; blitter control 8a3c.b
    ;move.l (a7)+,a4

    ; NEW CODE END

    ;lea $a0(a2),a0
    ;dbra d4,draw_engine_top
    ;move.w (a7)+,d1
    ;move.l (a7)+,d5
    ;rts

    ; START OF REPLICA CODE

    move.l d5,-(sp)
    move.w d1,-(sp)
    move.l a4,-(a7)

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
    movea.l   a0,a2
    move.w    d1,d3
label_513e0:
    ; blitter code START


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
    move.b #$c0,(a4)         ; blitter control 8a3c.b

    ;AND MASK DATA ACROSS BITPLANES
    ;    - srcxinc = (not required)
    ;    - srcyinc = (not required)
    ;    - sourceaddress = (not required)
    ;    - endmask1 = $ffff
    ;    - endmask2 = $ffff
    ;    - endmask3 = $ffff
    ;    - destxinc = 0
    ;    - destyinc = 8
    ;    - destinationaddress = a0 (add 2 on each pass)
    ;    - xcount = 1
    ;    - ycount = 16 (need to check this value against 68k code)
    ;    - hop/op = #$0101 (hop = halftone, op = source AND destination, 2 nops)
    ;    - four passes:
    ;        - ycount = 16
    ;        - #$c0 to control
    ;        - add 2 to destinationaddress after each pass

    moveq.l #16,d2
    moveq.l #-64,d6

    ; mask init
    lea $ffff8a2e.w,a4
    clr.w (a4)+              ; destxinc 8a2e.w
    move.w #8,(a4)+          ; destyinc 8a30.w
    addq.l #4,a4             ; skip dest address 8a32.l
    move.w #1,(a4)+          ; xcount 8a36.w
    addq.l #2,a4             ; skip ycount 8a38.w
    move.w #$101,(a4)+       ; hop/op 8a3a.w

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


    ; 256 pixels of 4 bitplane graphics data = 128 bytes
    ; 256 pixels of mask data = 32 bytes
    lea 160(a1),a1

    ;move.l    (a0),d0
    ;move.w    (a1),d5
    ;swap      d5
    ;move.w    (a1)+,d5
    ;and.l     d5,d0
    ;or.l      (a1)+,d0
    ;move.l    d0,(a0)+
    ;move.l    (a0),d0
    ;and.l     d5,d0
    ;or.l      (a1)+,d0
    ;move.l    d0,(a0)+
    ;dbra      d3,label_513e0


    ; blitter code END
    lea       $a0(a2),a0
    dbra      d4,label_513dc
    move.l (a7)+,a4
    move.w    (sp)+,d1
    move.l    (sp)+,d5
    rts       


