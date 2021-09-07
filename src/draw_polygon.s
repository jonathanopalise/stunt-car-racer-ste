draw_polygon: ; 4fd2c
    move.b    #0,$51256
    move.l    a1,$51280
    move.l    a2,$5127c
    suba.l    a2,a1
    move.l    a1,$51284
    beq       label_500d0
    move.w    #0,d7
    move.b    $51276,d6
    andi.b    #$40,d6
    eori.b    #$40,d6
    movea.l   #$6ddc4,a4
    movea.l   #$6dd44,a0
    movea.l   (a0)+,a5
    movea.l   a0,a3
    bra       label_4fdea
label_4fd72:
    movea.l   a0,a3
    movea.l   (a0)+,a5
    move.w    (a5),d0
    cmp.w     2(a5),d0
    bne       label_4fd9a
    cmpa.l    #$6dd44,a3
    bne       label_4fdea
    btst      #6,$51276
    bne       label_4fdb0
    bra       label_4fdea
label_4fd9a:
    cmp.w     d4,d0
    beq       label_4fdb0
    cmp.w     2(a5),d3
    bne       label_4fdbe
    move.b    #$40,d6
    bra       label_4fdea
label_4fdb0:
    tst.b     d6
    bne       label_4fdbe
    move.b    #0,d6
    bra       label_4fdea
label_4fdbe:
    eori.b    #$40,d6
    bne       label_4fdea
    move.l    a3,6(a4,d7.w)
    move.l    a0,d2
    subq.l    #8,d2
    cmp.l     $5127c,d2
    bge       label_4fdde
    add.l     $51284,d2
label_4fdde:
    move.l    d2,2(a4,d7.w)
    move.w    d0,(a4,d7.w)
    addi.w    #$a,d7
label_4fdea:
    move.w    (a5),d3
    move.w    2(a5),d4
    cmpa.l    $51280,a0
    bne       label_4fe00
    suba.l    $51284,a0
label_4fe00:
    cmpa.l    #$6dd44,a3
    bne       label_4fd72
    subi.w    #$a,d7
    beq       label_4fe74
    bmi       label_500d6
    move.w    d7,$51258
    move.w    $51258,d2
    move.w    (a4,d2.w),d0
    move.w    d2,d1
    bra       label_4fe3a
label_4fe2c:
    cmp.w     (a4,d2.w),d0
    bge       label_4fe3a
    move.w    (a4,d2.w),d0
    move.w    d2,d1
label_4fe3a:
    subi.w    #$a,d2
    bpl       label_4fe2c
    move.w    #$8000,(a4,d1.w)
    movea.l   6(a4,d1.w),a1
    movea.l   2(a4,d1.w),a2
    jsr       $4fc92
    move.w    d0,$5125a
    bmi       label_4fe70
    move.l    6(a4,d1.w),$5125c
    move.l    2(a4,d1.w),$51260
label_4fe70:
    bra       label_4fe84
label_4fe74:
    move.w    #$8000,$5125a
    movea.l   6(a4),a1
    movea.l   2(a4),a2
label_4fe84:
    movea.l   (a1),a0
    movea.l   (a2),a3
    move.b    $51278,d0
    clr.l     d6
    clr.l     d7
    lsr.b     #1,d0
    bcc       label_4fe9a
    not.w     d6
label_4fe9a:
    swap      d6
    lsr.b     #1,d0
    bcc       label_4fea4
    not.w     d6
label_4fea4:
    lsr.b     #1,d0
    bcc       label_4feac
    not.w     d7
label_4feac:
    swap      d7
    lsr.b     #1,d0
    bcc       label_4feb6
    not.w     d7
label_4feb6:

    ; update halftone START

    move.l a0,usp

    lea $ffff8a00.w,a0
    rept 4
    move.l d7,(a0)+
    move.l d6,(a0)+
    endr

    lea $ffff8a2e.w,a0
    clr.w (a0)+              ; (8) destxinc 8a2e.w
    move.w #2,(a0)+          ; destyinc 8a30.w
    addq.l #4,a0
    move.w #1,(a0)+          ; xcount 8a36.w
    addq.l #2,a0
    move.w #$103,(a0)+       ; hop/op 8a3a.w

    move.l usp,a0

    ; update halftone END

    movea.l   #$4e0a0,a5
    move.w    (a0)+,d1
    move.w    (a3)+,d0
    cmp.w     d1,d0
    bne       label_500d6
    addq.l    #6,a0
    addq.l    #6,a3
    move.w    d1,$b670
    subq.w    #1,d1
    cmpi.w    #$80,d1
    bcc       label_500d6
    movea.l   $518a4,a6
    clr.l     d0
    move.w    d1,d0
    asl.w     #2,d0
    add.w     d1,d0
    asl.w     #5,d0
    adda.l    d0,a6
label_4feec:
    move.w    $b670,d0
    cmp.w     $5125a,d0
    bne       label_4ff46
    move.w    $b670,-(sp)
    move.l    a6,-(sp)
    move.l    a3,-(sp)
    move.l    a2,-(sp)
    move.l    $5125c,-(sp)
    addq.b    #1,$51256
    movea.l   $51260,a2
    movea.l   (a2),a3
    adda.l    #8,a3
    jsr       $4fc92
    move.w    d0,$5125a
    bmi       label_4ff42
    move.l    6(a4,d1.w),$5125c
    move.l    2(a4,d1.w),$51260
label_4ff42:
    bra       label_4feec
label_4ff46:
    move.w    (a0)+,d4
    bpl       label_4ff7a
label_4ff4c:
    addq.l    #4,a1
    cmpa.l    $51280,a1
    blt       label_4ff5e
    suba.l    $51284,a1
label_4ff5e:
    cmpa.l    a2,a1
    beq       label_50086
    movea.l   (a1),a0
    move.w    (a0)+,d4
    cmp.w     $b670,d4
    bne       label_500d6
    addq.l    #6,a0
    move.w    (a0)+,d4
    bmi       label_4ff4c
label_4ff7a:
    move.w    (a3)+,d5
    bpl       label_4ffac
label_4ff80:
    cmpa.l    $5127c,a2
    bne       label_4ff90
    adda.l    $51284,a2
label_4ff90:
    movea.l   -(a2),a3
    cmpa.l    a1,a2
    beq       label_50086
    move.w    (a3)+,d5
    cmp.w     $b670,d5
    bne       label_500d6
    addq.l    #6,a3
    move.w    (a3)+,d5
    bmi       label_4ff80
label_4ffac:
    cmp.w     d4,d5
    bgt       label_4ffc4
    beq       label_50070
    tst.b     $b54e
    bpl       label_50070
    bra       label_50070
label_4ffc4:
    move.w    d4,d1
    andi.w    #$f0,d1
    lsr.w     #1,d1
    lea       (a6,d1.w),a4
    move.w    d4,d3
    move.w    d5,d1
    lsr.w     #4,d3
    lsr.w     #4,d1
    sub.w     d3,d1
    bne       label_50012
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
    bra       label_50070
label_50012:
    subq.b    #1,d1
    andi.w    #$f,d4
    beq       road_span_from_50018
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

; new code here

; inputs:
; - d1 contains number of 16 pixel spans to be drawn (may be 0)
; - a4 is the back buffer address to which this span needs to be written

unrolled_span_iterations equ 10

    dbt d1,label_50048
    bra.s start_span

road_span_from_50018:
    addq.w #1,d1             ; (4) we need one more 16 pixel block if coming from 50018

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
    move.l a4,(a0)           ; (8) dest address 8a32.l
    move.w d1,6(a0)          ; (8) ycount 8a38.w
    move.b #$c0,10(a0)       ; (12) blitter control 8a3c.b
    move.l usp,a0            ; (4) restore a0

    add.w d1,d1              ; (4) bytes to advance = words drawn * 2
    add.l d1,a4              ; (8) advanced dest address to end of span

skip_span:
    bra label_50048               ; (8)

    rept unrolled_span_iterations
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
    endr
do_nothing:
    move.l usp,a0            ; restore a0

label_50048:
    andi.w    #$f,d5
    beq       label_50070
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
label_50070:
    subq.w    #1,$b670
    suba.l    #$a0,a6
    cmpa.l    $518a4,a6
    bge       label_4feec
label_50086:
    tst.b     $51256
    beq       label_500d0
    movea.l   (sp)+,a1
    movea.l   (sp)+,a2
    movea.l   (sp)+,a3
    movea.l   (sp)+,a6
    move.w    (sp)+,$b670
    subq.b    #1,$51256
    movea.l   (a1),a0
    adda.l    #8,a0
    jsr       $4fc92
    move.w    d0,$5125a
    bmi       label_500cc
    move.l    6(a4,d1.w),$5125c
    move.l    2(a4,d1.w),$51260
label_500cc:
    bra       label_4feec
label_500d0:
    clr.l     d1
    clr.l     d2
    rts       
label_500d6:
    tst.b     $51256
    beq       label_500d0
    movea.l   (sp)+,a1
    movea.l   (sp)+,a2
    movea.l   (sp)+,a3
    movea.l   (sp)+,a6
    move.w    (sp)+,$b670
    subq.b    #1,$51256
    movea.l   (a1),a0
    adda.l    #8,a0
    bra       label_500d6

