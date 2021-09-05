road_span_loop_start:
    move.l d6,(a4)+
    move.l d7,(a4)+
road_span_loop_end:
    dbra d1,road_span_loop_start
    jmp $50048
