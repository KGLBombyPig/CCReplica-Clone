DynamicLevelEvents:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		move.w	off_495E(pc,d0.w),d0
		jsr	off_495E(pc,d0.w)
		tst.w	(DebugRoutine).w
		beq.s	loc_4936
		move.w	#0,(unk_FFF72C).w
		move.w	#$720,(unk_FFF726).w

loc_4936:
		moveq	#2,d1
		move.w	(unk_FFF726).w,d0
		sub.w	(unk_FFF72E).w,d0
		beq.s	locret_495C
		bcc.s	loc_4952
		move.w	(v_screenposy).w,(unk_FFF72E).w
		andi.w	#$FFFE,(unk_FFF72E).w
		neg.w	d1

loc_4952:
		add.w	d1,(unk_FFF72E).w
		move.b	#1,(unk_FFF75C).w

locret_495C:
		rts
; ---------------------------------------------------------------------------

off_495E:	dc.w EventsGHZ-off_495E, EventsNull-off_495E
                dc.w EventsMZ-off_495E, EventsSLZ-off_495E
		dc.w EventsNull-off_495E, EventsNull-off_495E
; ---------------------------------------------------------------------------

EventsNull:
		rts
; ---------------------------------------------------------------------------

EventsGHZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	off_497C(pc,d0.w),d0
		jmp	off_497C(pc,d0.w)
; ---------------------------------------------------------------------------

off_497C:	dc.w EventsGHZ1-off_497C, EventsGHZ2-off_497C, EventsGHZ3-off_497C
; ---------------------------------------------------------------------------

EventsGHZ1:
		;move.w	#$300,(unk_FFF726).w
		;cmpi.w	#$1780,(v_screenposx).w
		;bcs.s	locret_4996
		;move.w	#$400,(unk_FFF726).w

locret_4996:
		rts
; ---------------------------------------------------------------------------

EventsGHZ2:
		;move.w	#$300,(unk_FFF726).w
		;cmpi.w	#$ED0,(v_screenposx).w
		;bcs.s	locret_49C8
		;move.w	#$200,(unk_FFF726).w
		;cmpi.w	#$1600,(v_screenposx).w
		;bcs.s	locret_49C8
		;move.w	#$400,(unk_FFF726).w
		;cmpi.w	#$1D60,(v_screenposx).w
		;bcs.s	locret_49C8
		;move.w	#$300,(unk_FFF726).w

locret_49C8:
		rts
; ---------------------------------------------------------------------------

EventsGHZ3:
		rts
; ---------------------------------------------------------------------------

EventsMZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	off_4A90(pc,d0.w),d0
		jmp	off_4A90(pc,d0.w)
; ---------------------------------------------------------------------------

off_4A90:	dc.w EventsMZ1-off_4A90, EventsMZ2-off_4A90, EventsMZ3-off_4A90
; ---------------------------------------------------------------------------

EventsMZ1:
		moveq	#0,d0
		move.b	(EventsRoutine).w,d0

loc_4A9C:
		move.w	off_4AA4(pc,d0.w),d0
		jmp	off_4AA4(pc,d0.w)
; ---------------------------------------------------------------------------

off_4AA4:	dc.w loc_4AAC-off_4AA4, sub_4ADC-off_4AA4, loc_4B20-off_4AA4, loc_4B42-off_4AA4
; ---------------------------------------------------------------------------

loc_4AAC:
		move.w	#$1D0,(unk_FFF726).w
		cmpi.w	#$700,(v_screenposx).w
		bcs.s	locret_4ADA
		move.w	#$220,(unk_FFF726).w
		cmpi.w	#$D00,(v_screenposx).w
		bcs.s	locret_4ADA
		move.w	#$340,(unk_FFF726).w
		cmpi.w	#$340,(v_screenposy).w
		bcs.s	locret_4ADA
		addq.b	#2,(EventsRoutine).w

locret_4ADA:
		rts
; ---------------------------------------------------------------------------

sub_4ADC:
		cmpi.w	#$340,(v_screenposy).w
		bcc.s	loc_4AEA
		subq.b	#2,(EventsRoutine).w
		rts
; ---------------------------------------------------------------------------

loc_4AEA:
		move.w	#0,(unk_FFF72C).w
		cmpi.w	#$E00,(v_screenposx).w
		bcc.s	locret_4B1E
		move.w	#$340,(unk_FFF72C).w
		move.w	#$340,(unk_FFF726).w
		cmpi.w	#$A90,(v_screenposx).w
		bcc.s	locret_4B1E
		move.w	#$500,(unk_FFF726).w
		cmpi.w	#$370,(v_screenposy).w
		bcs.s	locret_4B1E
		addq.b	#2,(EventsRoutine).w

locret_4B1E:
		rts
; ---------------------------------------------------------------------------

loc_4B20:
		cmpi.w	#$370,(v_screenposy).w
		bcc.s	loc_4B2E
		subq.b	#2,(EventsRoutine).w
		rts
; ---------------------------------------------------------------------------

loc_4B2E:
		cmpi.w	#$500,(v_screenposy).w
		bcs.s	locret_4B40
		;move.w	#$500,(unk_FFF72C).w
		addq.b	#2,(EventsRoutine).w

locret_4B40:
		rts
; ---------------------------------------------------------------------------

loc_4B42:
		cmpi.w	#$E70,(v_screenposx).w
		bcs.s	locret_4B50
		move.w	#0,(unk_FFF72C).w

locret_4B50:
		rts
; ---------------------------------------------------------------------------

EventsMZ2:
		rts
; ---------------------------------------------------------------------------

EventsMZ3:
		rts
; ---------------------------------------------------------------------------

EventsSLZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	off_4B7A(pc,d0.w),d0
		jmp	off_4B7A(pc,d0.w)
; ---------------------------------------------------------------------------

off_4B7A:	dc.w EventsSLZNull-off_4B7A, EventsSLZNull-off_4B7A, EventsSLZNull-off_4B7A
; ---------------------------------------------------------------------------

EventsSLZNull:
		rts