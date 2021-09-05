; inputs:
; - d1 contains number of 16 pixel spans to be drawn (may be 0)
; - a4 is the back buffer address to which this span needs to be written

span_jump_table:
    dc.l do_nothing ; should never be used
    dc.l draw_one_chunk    ; 16 wide
    dc.l draw_two_chunks    ; 32 wide
    dc.l draw_three_chunks    ; 48 wide
    dc.l start_blitter_span    ; 16 wide
    dc.l start_blitter_span    ; 32 wide
    dc.l start_blitter_span    ; 48 wide
    dc.l start_blitter_span    ; 16 wide
    dc.l start_blitter_span    ; 32 wide
    dc.l start_blitter_span    ; 48 wide
    dc.l start_blitter_span    ; 16 wide
    dc.l start_blitter_span    ; 32 wide
    dc.l start_blitter_span    ; 48 wide
    dc.l start_blitter_span    ; 16 wide
    dc.l start_blitter_span    ; 32 wide
    dc.l start_blitter_span    ; 48 wide
    dc.l start_blitter_span    ; 16 wide

road_span_from_5003c:
    bra.s start_span

road_span_from_50018:
    addq.l #1,d1              ; we need one more 16 pixel block if coming from 50018

start_span:
    add.w d1,d1              ; number of words for Blitter = number of 16 pixel blocks * 4
    add.w d1,d1
    move.l a0,usp            ; backup a0

    ;cmp.w #12,d1
    ;bgt.s start_blitter_span

    lea span_jump_table(pc),a0
    move.l (a0,d1.w),a0
    jmp (a0)

start_blitter_span:
    lea $ffff8a32.w,a0
    move.l a4,(a0)+          ; dest address 8a32.l
    addq.l #2,a0
    move.w d1,(a0)+          ; ycount 8a38.w
    addq.l #2,a0
    move.b #$c0,(a0)         ; blitter control 8a3c.b
    move.l usp,a0            ; restore a0

    add.w d1,d1              ; bytes to advance = words drawn * 2
    add.l d1,a4              ; advanced dest address to end of span

skip_span:
    jmp $50048

draw_three_chunks:
    move.l d6,(a4)+
    move.l d7,(a4)+
draw_two_chunks:
    move.l d6,(a4)+
    move.l d7,(a4)+
draw_one_chunk:
    move.l d6,(a4)+
    move.l d7,(a4)+
do_nothing:
    move.l usp,a0            ; restore a0
    jmp $50048

