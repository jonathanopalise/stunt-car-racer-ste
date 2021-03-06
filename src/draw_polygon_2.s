draw_polygon_2:
    move.w    (a2),d2
    move.w    (a0),d0
    cmp.w     (a3),d0
    bne       label_4dece
    cmp.w     (a1),d2
    bne       label_4def6
    cmp.w     d2,d0
    bge       label_4def6
label_4dec6:
    exg       a2,a0
    exg       a3,a1
    bra       label_4def6
label_4dece:
    blt       label_4dee6
    cmp.w     (a1),d2
    beq       label_4dec6
    exg       d0,a0
    movea.l   a1,a0
    movea.l   a2,a1
    movea.l   a3,a2
    movea.l   d0,a3
    bra       label_4def6
label_4dee6:
    cmp.w     (a1),d2
    beq       label_4dec6
    exg       d0,a3
    movea.l   a2,a3
    movea.l   a1,a2
    movea.l   a0,a1
    movea.l   d0,a0
label_4def6:
    move.b    #2,$4e160
    movea.l   #$4e0a0,a5
    move.w    (a0)+,d1
    move.w    (a3)+,d0
    cmp.w     d1,d0
    bne       label_4e09a
    addq.l    #6,a0
    addq.l    #6,a3
    move.w    d1,$b670
    subq.w    #1,d1
    bmi       label_4e09a
    movea.l   $518a4,a6
    clr.l     d0
    move.w    d1,d0
    asl.w     #2,d0
    add.w     d1,d0
    asl.w     #5,d0
    adda.l    d0,a6
label_4df30:
    move.w    (a0)+,d4
    bpl       label_4df78
    subq.b    #1,$4e160
    bmi       label_4e09a
    movea.l   a1,a0
    movea.l   a2,a1
    move.w    (a0)+,d0
    cmp.w     $b670,d0
    bne       label_4e09a
    addq.l    #6,a0
    move.w    (a0)+,d4
    bpl       label_4df78
    subq.b    #1,$4e160
    bmi       label_4e09a
    movea.l   a1,a0
    move.w    (a0)+,d0
    cmp.w     $b670,d0
    bne       label_4e09a
    addq.l    #6,a0
    move.w    (a0)+,d4
    bmi       label_4e09a
label_4df78:
    move.w    (a3)+,d5
    bpl       label_4dfc0
    subq.b    #1,$4e160
    bmi       label_4e09a
    movea.l   a2,a3
    movea.l   a1,a2
    move.w    (a3)+,d0
    cmp.w     $b670,d0
    bne       label_4e09a
    addq.l    #6,a3
    move.w    (a3)+,d5
    bpl       label_4dfc0
    subq.b    #1,$4e160
    bmi       label_4e09a
    movea.l   a2,a3
    move.w    (a3)+,d0
    cmp.w     $b670,d0
    bne       label_4e09a
    addq.l    #6,a3
    move.w    (a3)+,d5
    bmi       label_4e09a
label_4dfc0:
    cmp.w     d4,d5
    bgt       label_4dfd8
    beq       label_4e084
    tst.b     $b54e
    bpl       label_4e084
    bra       label_4e09a
label_4dfd8:
    move.w    d4,d1
    andi.w    #$f0,d1
    lsr.w     #1,d1
    lea       (a6,d1.w),a4
    move.w    d4,d3
    move.w    d5,d1
    lsr.w     #4,d3
    lsr.w     #4,d1
    sub.w     d3,d1
    bne       label_4e026
    andi.w    #$f,d4
    asl.w     #2,d4
    move.l    (a5,d4.w),d4
    andi.w    #$f,d5
    asl.w     #2,d5
    move.l    $40(a5,d5.w),d5
    and.l     d5,d4
    move.l    d6,d2
    move.l    d7,d3
    and.l     d4,d2
    and.l     d4,d3
    not.l     d4
    move.l    (a4),d0
    and.l     d4,d0
    or.l      d2,d0
    move.l    d0,(a4)+
    move.l    (a4),d0
    and.l     d4,d0
    or.l      d3,d0
    move.l    d0,(a4)+
    bra       label_4e084
label_4e026:
    subq.b    #1,d1
    andi.w    #$f,d4
    beq       dp2_span_from_4e02c
    asl.w     #2,d4
    move.l    (a5,d4.w),d4
    move.l    d6,d2
    move.l    d7,d3
    and.l     d4,d2
    and.l     d4,d3
    not.l     d4
    move.l    (a4),d0
    and.l     d4,d0
    or.l      d2,d0
    move.l    d0,(a4)+
    move.l    (a4),d0
    and.l     d4,d0
    or.l      d3,d0
    move.l    d0,(a4)+

    ; new code

    macro dp2_16_pixel_span
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
    endm

    bra dp2_start_span

dp2_span_from_4e02c:
    dp2_16_pixel_span

dp2_start_span:
    move.b dp2_span_lookup(pc,d1.w),dp2_modifiable_bra+1
dp2_modifiable_bra:
    bra.s dp2_do_nothing

dp2_span_lookup:
    dc.b (dp2_do_nothing-dp2_modifiable_bra)-2
    dc.b (dp2_one_span-dp2_modifiable_bra)-2
    dc.b (dp2_two_spans-dp2_modifiable_bra)-2
    dc.b (dp2_three_spans-dp2_modifiable_bra)-2
    dc.b (dp2_four_spans-dp2_modifiable_bra)-2
    dc.b (dp2_five_spans-dp2_modifiable_bra)-2
    dc.b (dp2_six_spans-dp2_modifiable_bra)-2
    dc.b (dp2_seven_spans-dp2_modifiable_bra)-2
    dc.b (dp2_eight_spans-dp2_modifiable_bra)-2
    dc.b (dp2_nine_spans-dp2_modifiable_bra)-2
    dc.b (dp2_ten_spans-dp2_modifiable_bra)-2
    dc.b (dp2_eleven_spans-dp2_modifiable_bra)-2
    dc.b (dp2_twelve_spans-dp2_modifiable_bra)-2
    dc.b (dp2_thirteen_spans-dp2_modifiable_bra)-2
    dc.b (dp2_fourteen_spans-dp2_modifiable_bra)-2
    dc.b (dp2_fifteen_spans-dp2_modifiable_bra)-2

dp2_fifteen_spans:
    dp2_16_pixel_span
dp2_fourteen_spans:
    dp2_16_pixel_span
dp2_thirteen_spans:
    dp2_16_pixel_span
dp2_twelve_spans:
    dp2_16_pixel_span
dp2_eleven_spans:
    dp2_16_pixel_span
dp2_ten_spans:
    dp2_16_pixel_span
dp2_nine_spans:
    dp2_16_pixel_span
dp2_eight_spans:
    dp2_16_pixel_span
dp2_seven_spans:
    dp2_16_pixel_span
dp2_six_spans:
    dp2_16_pixel_span
dp2_five_spans:
    dp2_16_pixel_span
dp2_four_spans:
    dp2_16_pixel_span
dp2_three_spans:
    dp2_16_pixel_span
dp2_two_spans:
    dp2_16_pixel_span
dp2_one_span:
    dp2_16_pixel_span
dp2_do_nothing:

    andi.w    #$f,d5
    beq       label_4e084
    asl.w     #2,d5
    move.l    $40(a5,d5.w),d4
    move.l    d6,d2
    move.l    d7,d3
    and.l     d4,d2
    and.l     d4,d3
    not.l     d4
    move.l    (a4),d0
    and.l     d4,d0
    or.l      d2,d0
    move.l    d0,(a4)+
    move.l    (a4),d0
    and.l     d4,d0
    or.l      d3,d0
    move.l    d0,(a4)+
label_4e084:
    subq.w    #1,$b670
    suba.l    #$a0,a6
    cmpa.l    $518a4,a6
    bge       label_4df30
label_4e09a:
    clr.l     d1
    clr.l     d2
    rts       

