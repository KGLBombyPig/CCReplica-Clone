; ---------------------------------------------------------------------------

ObjSignpost:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_C726(pc,d0.w),d1
		jsr	off_C726(pc,d1.w)
		lea	(AniSignpost).l,a1
		bsr.w	ObjectAnimate
		bsr.w	DisplaySprite
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------
off_C726:	dc.w loc_C72E-off_C726
                dc.w loc_C752-off_C726
                dc.w loc_C77C-off_C726
                dc.w loc_C814-off_C726
; ---------------------------------------------------------------------------

loc_C72E:
		addq.b	#2,$24(a0)
		move.l	#MapSignpost,4(a0)
		move.w	#$680,2(a0)
		move.b	#4,1(a0)
		move.b	#$18,$18(a0)
		move.b	#4,$19(a0)

loc_C752:
		move.w	(v_objspace+8).w,d0
		sub.w	8(a0),d0
		bcs.s	locret_C77A
		cmpi.w	#$20,d0
		bcc.s	locret_C77A
		;move.w	#$A8,d0
		;jsr	(PlayMusic).l
		;clr.b	(f_timecount).w
		move.w	(unk_FFF72A).w,(unk_FFF728).w
		addq.b	#2,$24(a0)

locret_C77A:
		rts
; ---------------------------------------------------------------------------

loc_C77C:
		subq.w	#1,$30(a0)
		bpl.s	loc_C798
		move.w	#$3C,$30(a0)
		addq.b	#1,$1C(a0)
		cmpi.b	#3,$1C(a0)
		bne.s	loc_C798
		addq.b	#2,$24(a0)
		move.w 	#$100,$30(a0)
		;move.w	#$8E,d0
		;jsr	(PlaySFX).l
loc_C798:
		subq.w	#1,$32(a0)
		bpl.s	locret_C802
		move.w	#$B,$32(a0)
		moveq	#0,d0
locret_C802:
		rts
; ---------------------------------------------------------------------------

loc_C814:
		tst.w 	$30(a0)
		bpl.s 	locret_B83A
		;tst.b	(f_victory).w
		;bne.s	locret_C880
		;move.w	(unk_FFF72A).w,(unk_FFF728).w
		;clr.b	(v_invinc).w
		;clr.b	(f_timecount).w
		;move.b 	#1,(f_victory).w
		;move.b	#$3A,(v_objspace+$600).w
		;moveq	#$10,d0
		;jsr	(plcReplace).l
		;moveq	#0,d0
		;move.b	(v_zone).w,d0
		;andi.w	#7,d0
		;lsl.w	#3,d0
		;move.b	(v_act).w,d1
		;andi.w	#3,d1
		;add.w	d1,d1
		;add.w	d1,d0
		;move.w	word_A826(pc,d0.w),d0
		;move.w	d0,(v_zone).w
		;tst.w	d0
		;bne.s	loc_A81C
		;move.b	#0,(v_gamemode).w
		;bra.s	locret_C880
		addi.b 	#1,(v_act).w
		cmpi.b 	#4,(v_act).w
		bne.s 	loc_A81C
		move.b 	#0,(v_act).w
		addi.b 	#1,(v_zone).w
; ---------------------------------------------------------------------------

loc_A81C:
		move.w	#1,(LevelRestart).w
locret_B83A:
		subi.w 	#1,$30(a0)
locret_C880:
		rts
