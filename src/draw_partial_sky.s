dp2_span_from_4e02c:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)

dp2_start_span:
    move.b dp2_span_lookup(pc,d1.w),dps_modifiable_bra+1
dp2_modifiable_bra:
    bra.s dp2_do_nothing

dp2_span_lookup:
    dc.b (dp2_do_nothing-dps_modifiable_bra)-2
    dc.b (dp2_one_span-dps_modifiable_bra)-2
    dc.b (dp2_two_spans-dps_modifiable_bra)-2
    dc.b (dp2_three_spans-dps_modifiable_bra)-2
    dc.b (dp2_four_spans-dps_modifiable_bra)-2
    dc.b (dp2_five_spans-dps_modifiable_bra)-2
    dc.b (dp2_six_spans-dps_modifiable_bra)-2
    dc.b (dp2_seven_spans-dps_modifiable_bra)-2
    dc.b (dp2_eight_spans-dps_modifiable_bra)-2
    dc.b (dp2_nine_spans-dps_modifiable_bra)-2
    dc.b (dp2_ten_spans-dps_modifiable_bra)-2
    dc.b (dp2_eleven_spans-dps_modifiable_bra)-2
    dc.b (dp2_twelve_spans-dps_modifiable_bra)-2
    dc.b (dp2_thirteen_spans-dps_modifiable_bra)-2
    dc.b (dp2_fourteen_spans-dps_modifiable_bra)-2
    dc.b (dp2_fifteen_spans-dps_modifiable_bra)-2

dp2_fifteen_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dp2_fourteen_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dp2_thirteen_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dp2_twelve_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dp2_eleven_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dp2_ten_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dp2_nine_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dp2_eight_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dp2_seven_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dp2_six_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dp2_five_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dp2_four_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dp2_three_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dp2_two_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dp2_one_span:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dp2_do_nothing:
    jmp $4e05c 
