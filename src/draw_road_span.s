; inputs:
; - d1 contains number of 16 pixel spans to be drawn (may be 0)
; - a4 is the back buffer address to which this span needs to be written

unrolled_span_iterations equ 10

road_span_from_50018:
    addq.w #1,d1             ; (4) we need one more 16 pixel block if coming from 50018
    bra.s start_span

road_span_from_5003c:
    dbt d1,skip_span

start_span:
    add.w d1,d1              ; (4) number of words for Blitter = number of 16 pixel blocks * 4
    add.w d1,d1              ; (4)
    move.l a0,usp            ; (4) backup a0

    cmp.w #(unrolled_span_iterations*4),d1
    bgt.s start_blitter_span ; (10 if taken, 8 if not)

    lea do_nothing(pc),a0
    sub.l d1,a0
    jmp (a0)

start_blitter_span:
    lea $ffff8a32.w,a0       ; (8)
    move.l a4,(a0)+          ; (8) dest address 8a32.l
    addq.l #2,a0             ; (8)
    move.w d1,(a0)+          ; (8) ycount 8a38.w
    addq.w #2,a0             ; (8)
    move.b #$c0,(a0)         ; (12) blitter control 8a3c.b
    move.l usp,a0            ; (4) restore a0

    add.w d1,d1              ; (4) bytes to advance = words drawn * 2
    add.l d1,a4              ; (8) advanced dest address to end of span

skip_span:
    jmp $50048               ; (8)

    rept unrolled_span_iterations
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
    endr
do_nothing:
    move.l usp,a0            ; restore a0
    jmp $50048

