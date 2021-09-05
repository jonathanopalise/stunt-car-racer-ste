; inputs:
; - d1 contains number of 16 pixel spans to be drawn (may be 0)
; - a4 is the back buffer address to which this span needs to be written

road_span_from_5003c:
    tst.w d1
    beq.s skip_span          ; if number of 16 pixel blocks is 0, do nothing
    bra.s start_span

road_span_from_50018:
    addq.l #1,d1              ; we need one more 16 pixel block if coming from 50018

start_span:
    move.l a0,-(a7)          ; backup a0
    add.w d1,d1              ; number of words for Blitter = number of 16 pixel blocks * 4
    add.w d1,d1

    lea $ffff8a32.w,a0
    move.l a4,(a0)+          ; dest address 8a32.l
    addq.l #2,a0
    move.w d1,(a0)+          ; ycount 8a38.w
    addq.l #2,a0
    move.b #$c0,(a0)         ; blitter control 8a3c.b

    move.l (a7)+,a0          ; restore a0

    add.w d1,d1              ; bytes to advance = words drawn * 2
    add.l d1,a4              ; advanced dest address to end of span

skip_span:

    jmp $50048
