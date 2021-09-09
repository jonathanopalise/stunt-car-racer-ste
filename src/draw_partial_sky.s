dps_span_from_4e02c:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)

dps_start_span:
    move.b dps_span_lookup(pc,d1.w),dps_modifiable_bra+1
dps_modifiable_bra:
    bra.s dps_do_nothing

dps_span_lookup:
    dc.b (dps_do_nothing-dps_modifiable_bra)-2
    dc.b (dps_one_span-dps_modifiable_bra)-2
    dc.b (dps_two_spans-dps_modifiable_bra)-2
    dc.b (dps_three_spans-dps_modifiable_bra)-2
    dc.b (dps_four_spans-dps_modifiable_bra)-2
    dc.b (dps_five_spans-dps_modifiable_bra)-2
    dc.b (dps_six_spans-dps_modifiable_bra)-2
    dc.b (dps_seven_spans-dps_modifiable_bra)-2
    dc.b (dps_eight_spans-dps_modifiable_bra)-2
    dc.b (dps_nine_spans-dps_modifiable_bra)-2
    dc.b (dps_ten_spans-dps_modifiable_bra)-2
    dc.b (dps_eleven_spans-dps_modifiable_bra)-2
    dc.b (dps_twelve_spans-dps_modifiable_bra)-2
    dc.b (dps_thirteen_spans-dps_modifiable_bra)-2
    dc.b (dps_fourteen_spans-dps_modifiable_bra)-2
    dc.b (dps_fifteen_spans-dps_modifiable_bra)-2

dps_fifteen_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dps_fourteen_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dps_thirteen_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dps_twelve_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dps_eleven_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dps_ten_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dps_nine_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dps_eight_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dps_seven_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dps_six_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dps_five_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dps_four_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dps_three_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dps_two_spans:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dps_one_span:
    move.l d6,(a4)+          ; (12)
    move.l d7,(a4)+          ; (12)
dps_do_nothing:
    jmp $4e05c 
