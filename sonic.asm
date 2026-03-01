; +------------------------------------------------------+
; | Sonic the Hedgehog (Prototype)                       |
; | Split/Text Disassembly.                              |
; | Originally done by Mega Drive Developers Collective. |
; | Revamped by LethalToxins                             |
; +------------------------------------------------------+

; Processor: Motorola 68000 (M68K)
; Sound Processor: Zilog Z80 (Z80)

; ---------------------------------------------------------------------------
		include "Constants.asm"
		include "Variables.asm"
		include "Macros.asm"

; ---------------------------------------------------------------------------

StartOfROM:
Vectors:	dc.l v_systemstack&$FFFFFF	; Initial stack pointer value
		dc.l EntryPoint			; Start of program
		dc.l BusError			; Bus error
		dc.l AddressError		; Address error (4)
		dc.l IllegalInstr		; Illegal instruction
		dc.l ZeroDivide			; Division by zero
		dc.l ChkInstr			; CHK exception
		dc.l TrapvInstr			; TRAPV exception (8)
		dc.l PrivilegeViol		; Privilege violation
		dc.l Trace			; TRACE exception
		dc.l Line1010Emu		; Line-A emulator
		dc.l Line1111Emu		; Line-F emulator (12)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (16)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (20)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (24)
		dc.l ErrorExcept		; Spurious exception
		dc.l ErrorTrap			; IRQ level 1
		dc.l ErrorTrap			; IRQ level 2
		dc.l ErrorTrap			; IRQ level 3 (28)
		dc.l HBlank			; IRQ level 4 (horizontal retrace interrupt)
		dc.l ErrorTrap			; IRQ level 5
		dc.l VBlank			; IRQ level 6 (vertical retrace interrupt)
		dc.l ErrorTrap			; IRQ level 7 (32)
		dc.l ErrorTrap			; TRAP #00 exception
		dc.l ErrorTrap			; TRAP #01 exception
		dc.l ErrorTrap			; TRAP #02 exception
		dc.l ErrorTrap			; TRAP #03 exception (36)
		dc.l ErrorTrap			; TRAP #04 exception
		dc.l ErrorTrap			; TRAP #05 exception
		dc.l ErrorTrap			; TRAP #06 exception
		dc.l ErrorTrap			; TRAP #07 exception (40)
		dc.l ErrorTrap			; TRAP #08 exception
		dc.l ErrorTrap			; TRAP #09 exception
		dc.l ErrorTrap			; TRAP #10 exception
		dc.l ErrorTrap			; TRAP #11 exception (44)
		dc.l ErrorTrap			; TRAP #12 exception
		dc.l ErrorTrap			; TRAP #13 exception
		dc.l ErrorTrap			; TRAP #14 exception
		dc.l ErrorTrap			; TRAP #15 exception (48)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
Console:	dc.b 'SEGA MEGA DRIVE '	; Hardware system ID (Console name)
Date:		dc.b '(C)SEGA 1989.JAN'	; Copyright holder and release date (generally year)
Title_Local:	dc.b '                                                '	; Domestic name (blank)
Title_Int:	dc.b '                                                '	; International name (blank)
Serial:		dc.b 'GM 00000000-00'	; Serial\version number
Checksum:	dc.w 0			; Checksum
		dc.b 'J               '	; I\O support
RomStartLoc:	dc.l StartOfROM		; Start address of ROM
RomEndLoc:      dc.l EndOfROM-1		; End address of ROM
RamStartLoc:	dc.l $FF0000		; Start address of RAM
RamEndLoc:      dc.l $FFFFFF		; End address of RAM
SRAMSupport:	dc.l $20202020		; SRAM (none)
                dc.l $20202020		; SRAM start ($200001)
                dc.l $20202020		; SRAM end ($20xxxx)
Notes:		dc.b '                                                    ' ; Notes (unused, anything can be put in this space, but it has to be 52 bytes.)
		dc.b 'JU              '	; Region (Country code)
EndOfHeader:

; ===========================================================================
; Crash\Freeze the 68000. Unlike Sonic 2, Sonic 1 uses the 68000 for playing music, so it stops too

ErrorTrap:
		nop
		nop
		bra.s	ErrorTrap
; ===========================================================================

EntryPoint:
		tst.l	(z80_port_1_control).l
loc_20C:
		bne.w	loc_306
		tst.w	(z80_expansion_control).l
		bne.s	loc_20C
		lea	SetupValues(pc),a5
		movem.l	(a5)+,d5-a4
		move.w	-$1100(a1),d0
		andi.w	#$F00,d0
		beq.s	loc_232
		move.l	#'SEGA',$2F00(a1)

loc_232:
		move.w	(a4),d0
		moveq	#0,d0
		movea.l	d0,a6
		move.l	a6,usp
		moveq	#$17,d1

loc_23C:
		move.b	(a5)+,d5
		move.w	d5,(a4)
		add.w	d7,d5
		dbf	d1,loc_23C
		move.l	#$40000080,(a4)
		move.w	d0,(a3)
		move.w	d7,(a1)
		move.w	d7,(a2)

loc_252:
		btst	d0,(a1)
		bne.s	loc_252
		moveq	#$27,d2

loc_258:
		move.b	(a5)+,(a0)+
		dbf	d2,loc_258
		move.w	d0,(a2)
		move.w	d0,(a1)
		move.w	d7,(a2)

loc_264:
		move.l	d0,-(a6)
		dbf	d6,loc_264
		move.l	#$81048F02,(a4)
		move.l	#$C0000000,(a4)
		moveq	#$1F,d3

loc_278:
		move.l	d0,(a3)
		dbf	d3,loc_278
		move.l	#$40000010,(a4)
		moveq	#$13,d4

loc_286:
		move.l	d0,(a3)
		dbf	d4,loc_286
		moveq	#3,d5

loc_28E:
		move.b	(a5)+,$10(a3)
		dbf	d5,loc_28E
		move.w	d0,(a2)
		movem.l	(a6),d0-a6
		disable_ints
		bra.s	loc_306
; ---------------------------------------------------------------------------
SetupValues:	dc.l $8000              ; VDP register start number
                dc.l $3FFF              ; size of RAM\4
                dc.l $100	        ; VDP register diff

		dc.l z80_ram	        ; start of Z80 RAM
		dc.l z80_bus_request	        ; Z80 bus request
		dc.l z80_reset	        ; Z80 reset
		dc.l vdp_data_port	; VDP data
		dc.l vdp_control_port	        ; VDP control

		dc.b 4, $14, $30, $3C, 7, $6C, 0, 0, 0, 0, $FF, 0, $81 ; VDP register values, $8000-$9700 (for initialization)
		dc.b $37, 0, 1, 1, 0, 0, $FF, $FF, 0, 0, $80

		dc.b $AF		; xor	a
		dc.b $01,$D7,$1F	; ld	bc,1FD7h
		dc.b $11,$29,$00	; ld	de,29h
		dc.b $21,$28,$00	; ld	hl,28h
		dc.b $F9		; ld	sp,hl
		dc.b $77		; ld	(hl),a
		dc.b $ED,$B0		; ldir
		dc.b $DD,$E1		; pop	ix
		dc.b $FD,$E1		; pop	iy
		dc.b $ED,$47		; ld	i,a
		dc.b $ED,$4F		; ld	r,a
		dc.b $08		; ex	af,af'
		dc.b $D9		; exx
		dc.b $F1		; pop	af
		dc.b $C1		; pop	bc
		dc.b $D1		; pop	de
		dc.b $E1		; pop	hl
		dc.b $08		; ex	af,af'
		dc.b $D9		; exx
		dc.b $F1		; pop	af
		dc.b $D1		; pop	de
		dc.b $E1		; pop	hl
		dc.b $F9		; ld	sp,hl
		dc.b $F3		; di
		dc.b $ED,$56		; im	1
		dc.b $36,$E9		; ld	(hl),0E9h
		dc.b $E9		; jp	(hl)

		dc.b $9F,$BF,$DF,$FF	; values for PSG channel volumes
; ---------------------------------------------------------------------------

loc_306:
		btst	#6,(z80_expansion_control+1).l
		beq.s	DoChecksum
		cmpi.l	#'init',(ChecksumStr).w
		beq.w	loc_36A

DoChecksum:
		movea.l	#EndOfHeader,a0
		movea.l	#RomEndLoc,a1
		move.l	(a1),d0
		moveq	#0,d1

loc_32C:
		add.w	(a0)+,d1
		cmp.l	a0,d0
		bcc.s	loc_32C
		movea.l	#Checksum,a1
		cmp.w	(a1),d1
		nop
		nop
		lea	(v_systemstack).w,a6
		moveq	#0,d7
		move.w	#$7F,d6

loc_348:
		move.l	d7,(a6)+
		dbf	d6,loc_348
		move.b	(z80_version).l,d0
		andi.b	#$C0,d0
		move.b	d0,(v_megadrive).w
		move.w	#1,(word_FFFFE0).w
		move.l	#'init',(ChecksumStr).w

loc_36A:
		lea	($FF0000).l,a6
		moveq	#0,d7
		move.w	#$3F7F,d6

loc_376:
		move.l	d7,(a6)+
		dbf	d6,loc_376
		bsr.w	vdpInit
		bsr.w	SoundDriverLoad
		bsr.w	padInit
		move.b	#0,(v_gamemode).w

ScreensLoop:
		move.b	(v_gamemode).w,d0
		andi.w	#$1C,d0
		jsr	ScreensArray(pc,d0.w)
		bra.s	ScreensLoop
; ---------------------------------------------------------------------------

ScreensArray:
		bra.w	GM_Sega
; ---------------------------------------------------------------------------
		bra.w	GM_Title
; ---------------------------------------------------------------------------
		bra.w	GM_Level
; ---------------------------------------------------------------------------
		bra.w	GM_Level
; ---------------------------------------------------------------------------
		bra.w	GM_Special
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

; Unused, as the checksum check doesn't care if the checksum is wrong.
ChecksumError:
		bsr.w	vdpInit
		move.l	#$C0000000,(vdp_control_port).l
		moveq	#$3F,d7

loc_3C2:
		move.w	#$E,(vdp_data_port).l
		dbf	d7,loc_3C2
		bra.s	*
; ---------------------------------------------------------------------------

BusError:
		move.b	#2,(v_errortype).w
		bra.s	ErrorAddress
; ---------------------------------------------------------------------------

AddressError:
		move.b	#4,(v_errortype).w
		bra.s	ErrorAddress
; ---------------------------------------------------------------------------

IllegalInstr:
		move.b	#6,(v_errortype).w
		addq.l	#2,2(sp)
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

ZeroDivide:
		move.b	#8,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

ChkInstr:
		move.b	#$A,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

TrapvInstr:
		move.b	#$C,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

PrivilegeViol:
		move.b	#$E,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

Trace:
		move.b	#$10,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

Line1010Emu:
		move.b	#$12,(v_errortype).w
		addq.l	#2,2(sp)
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

Line1111Emu:
		move.b	#$14,(v_errortype).w
		addq.l	#2,2(sp)
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

ErrorExcept:
		move.b	#0,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

ErrorAddress:
		disable_ints
		addq.w	#2,sp
		move.l	(sp)+,(v_spbuffer).w
		addq.w	#2,sp
		movem.l	d0-a7,(v_regbuffer).w
		bsr.w	ErrorPrint
		move.l	2(sp),d0
		bsr.w	ErrorPrintAddr
		move.l	(v_spbuffer).w,d0
		bsr.w	ErrorPrintAddr
		bra.s	loc_472
; ---------------------------------------------------------------------------

ErrorNormal:
		disable_ints
		movem.l	d0-a7,(v_regbuffer).w
		bsr.w	ErrorPrint
		move.l	2(sp),d0
		bsr.w	ErrorPrintAddr

loc_472:
		bsr.w	ErrorWaitInput
		movem.l	(v_regbuffer).w,d0-a7
		enable_ints
		rte
; ---------------------------------------------------------------------------

ErrorPrint:
		lea	(vdp_data_port).l,a6
		locVRAM	$F800
		lea	(ArtText).l,a0
		move.w	#$27F,d1

.loadart:
		move.w	(a0)+,(a6)
		dbf	d1,.loadart
		moveq	#0,d0
		move.b	(v_errortype).w,d0
		move.w	ErrorText(pc,d0.w),d0
		lea	ErrorText(pc,d0.w),a0
		locVRAM (vram_fg+$604)
		moveq	#$12,d1

.loadtext:
		moveq	#0,d0
		move.b	(a0)+,d0
		addi.w	#$790,d0
		move.w	d0,(a6)
		dbf	d1,.loadtext
		rts
; ---------------------------------------------------------------------------

ErrorText:	dc.w .exception-ErrorText, .bus-ErrorText
		dc.w .address-ErrorText, .illinstruct-ErrorText
		dc.w .zerodivide-ErrorText, .chkinstruct-ErrorText
		dc.w .trapv-ErrorText, .privilege-ErrorText
		dc.w .trace-ErrorText, .line1010-ErrorText
		dc.w .line1111-ErrorText
.exception:	dc.b "ERROR EXCEPTION    "
.bus:		dc.b "BUS ERROR          "
.address:	dc.b "ADDRESS ERROR      "
.illinstruct:	dc.b "ILLEGAL INSTRUCTION"
.zerodivide:	dc.b ".ERO DIVIDE        "
.chkinstruct:	dc.b "CHK INSTRUCTION    "
.trapv:		dc.b "TRAPV INSTRUCTION  "
.privilege:	dc.b "PRIVILEGE VIOLATION"
.trace:		dc.b "TRACE              "
.line1010:	dc.b "LINE 1010 EMULATOR "
.line1111:	dc.b "LINE 1111 EMULATOR "
		even
; ---------------------------------------------------------------------------

ErrorPrintAddr:
		move.w	#$7CA,(a6)
		moveq	#7,d2

loc_5BA:
		rol.l	#4,d0
		bsr.s	sub_5C4
		dbf	d2,loc_5BA
		rts
; ---------------------------------------------------------------------------

sub_5C4:
		move.w	d0,d1
		andi.w	#$F,d1
		cmpi.w	#$A,d1
		bcs.s	loc_5D2
		addq.w	#7,d1

loc_5D2:
		addi.w	#$7C0,d1
		move.w	d1,(a6)
		rts
; ---------------------------------------------------------------------------

ErrorWaitInput:
		bsr.w	ReadJoypads
		cmpi.b	#$20,(v_jpadpress1).w
		bne.w	ErrorWaitInput
		rts
; ---------------------------------------------------------------------------
ArtText:	incbin "artunc\menutext.bin"
		even
; ---------------------------------------------------------------------------

VBlank:
		movem.l	d0-a6,-(sp)
		tst.b	(VBlankRoutine).w
		beq.s	loc_B58
		move.w	(vdp_control_port).l,d0
		move.l	#$40000010,(vdp_control_port).l
		move.l	(v_scrposy_dup).w,(vdp_data_port).l
		btst	#6,(v_megadrive).w ; is Mega Drive PAL?
		beq.s	loc_B3C ; if not, branch
		move.w	#$700,d0
		dbf	d0,* ; loop here and do nothing

loc_B3C:
		move.b	(VBlankRoutine).w,d0
		move.b	#0,(VBlankRoutine).w
		move.w	#1,(word_FFF648).w
		andi.w	#$3E,d0
		move.w	VBla_Index(pc,d0.w),d0
		jsr	VBla_Index(pc,d0.w)

loc_B58:
		addq.l	#1,(unk_FFFE0C).w
		jsr	(UpdateMusic).l
		movem.l	(sp)+,d0-a6
		rte
; ---------------------------------------------------------------------------

VBla_00:
		rts
; ---------------------------------------------------------------------------

VBla_Index:	dc.w VBla_00-VBla_Index, VBla_02-VBla_Index
                dc.w VBla_04-VBla_Index, VBla_06-VBla_Index
                dc.w VBla_08-VBla_Index, VBla_0A-VBla_Index
                dc.w VBla_0C-VBla_Index, VBla_0E-VBla_Index
                dc.w VBla_10-VBla_Index, VBla_12-VBla_Index
; ---------------------------------------------------------------------------

VBla_02:
		bsr.w	sub_E78
		tst.w	(v_demolength).w
		beq.w	locret_B8E
		subq.w	#1,(v_demolength).w

locret_B8E:
		rts
; ---------------------------------------------------------------------------

VBla_04:
		bsr.w	sub_E78
		bsr.w	sub_43B6
		bsr.w	sub_1438
		tst.w	(v_demolength).w
		beq.w	locret_BA8
		subq.w	#1,(v_demolength).w

locret_BA8:
		rts
; ---------------------------------------------------------------------------

VBla_06:
		bsr.w	sub_E78
		rts
; ---------------------------------------------------------------------------

VBla_10:
		cmpi.b	#$10,(v_gamemode).w
		beq.w	VBla_0A

VBla_08:
		bsr.w	ReadJoypads
		stopZ80
		waitZ80
		writeCRAM       v_pal_dry,$80,0
		writeVRAM	v_hscrolltablebuffer,$380,vram_hscroll
		move.w	#$8407,(a5)
		move.w	(v_hbla_hreg).w,(a5)
		move.w	(word_FFF61E).w,(word_FFF622).w
		writeVRAM	v_spritetablebuffer,$280,vram_sprites
		tst.b	(f_sonframechg).w
		beq.s	loc_C7A
		writeVRAM	v_sgfx_buffer,$2E0,vram_sonic ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w

loc_C7A:
		startZ80
		bsr.w	mapLevelLoad
		jsr	(AnimateLevelGfx).l
		jsr	(UpdateHUD).l
		bsr.w	loc_1454
		moveq	#0,d0
		move.b	(byte_FFF628).w,d0
		move.b	(byte_FFF629).w,d1
		cmp.b	d0,d1
		bcc.s	loc_CA8
		move.b	d0,(byte_FFF629).w

loc_CA8:
		move.b	#0,(byte_FFF628).w
		tst.w	(v_demolength).w
		beq.w	locret_CBA
		subq.w	#1,(v_demolength).w

locret_CBA:
		rts
; ---------------------------------------------------------------------------

VBla_0A:
		bsr.w	ReadJoypads
		stopZ80
		waitZ80
		writeCRAM       v_pal_dry,$80,0
		writeVRAM	v_spritetablebuffer,$280,vram_sprites
		writeVRAM	v_hscrolltablebuffer,$380,vram_hscroll
		startZ80
		bsr.w	GM_SpecialPalCyc
		tst.b	(f_sonframechg).w
		beq.s	loc_D7A
		writeVRAM	v_sgfx_buffer,$2E0,vram_sonic ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w

loc_D7A:
		tst.w	(v_demolength).w
		beq.w	locret_D86
		subq.w	#1,(v_demolength).w

locret_D86:
		rts
; ---------------------------------------------------------------------------

VBla_0C:
		bsr.w	ReadJoypads
		stopZ80
		waitZ80
		writeCRAM       v_pal_dry,$80,0
		writeVRAM	v_spritetablebuffer,$280,vram_sprites
		writeVRAM	v_hscrolltablebuffer,$380,vram_hscroll
		tst.b	(f_sonframechg).w
		beq.s	loc_E3A
		writeVRAM	v_sgfx_buffer,$2E0,vram_sonic ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w

loc_E3A:
		startZ80
		bsr.w	mapLevelLoad
		jsr	(AnimateLevelGfx).l
		jsr	(UpdateHUD).l
		bsr.w	sub_1438
		rts
; ---------------------------------------------------------------------------

VBla_0E:
		bsr.w	sub_E78
		bsr.w	RunObjects
		bsr.w	ProcessMaps
		addq.b	#1,(byte_FFF628).w
		move.b	#$E,(VBlankRoutine).w
		rts
; ---------------------------------------------------------------------------

VBla_12:
		bsr.w	sub_E78
		bra.w	sub_1438
; ---------------------------------------------------------------------------

sub_E78:
		bsr.w	ReadJoypads
		stopZ80
		waitZ80
		writeCRAM       v_pal_dry,$80,0
		writeVRAM	v_spritetablebuffer,$280,vram_sprites
		writeVRAM	v_hscrolltablebuffer,$380,vram_hscroll
		startZ80
		rts
; ---------------------------------------------------------------------------

HBlank:
		tst.w	(word_FFF648).w
		beq.s	locret_F3A
		move.l	a5,-(sp)
		writeCRAM       v_pal_dry_dup,$80,0
		movem.l	(sp)+,a5
		move.w	#0,(word_FFF648).w

locret_F3A:
		rte
; ---------------------------------------------------------------------------

sub_F3C:
		tst.w	(word_FFF648).w
		beq.s	locret_F7E
		movem.l	d0/a0/a5,-(sp)
		move.w	#0,(word_FFF648).w
		move.w	#$8405,(vdp_control_port).l
		move.w	#$857C,(vdp_control_port).l
		locVRAM $F800
		lea	(v_spritetablebuffer).w,a0
		lea	(vdp_data_port).l,a5
		move.w	#$9F,d0

loc_F74:
		move.l	(a0)+,(a5)
		dbf	d0,loc_F74
		movem.l	(sp)+,d0/a0/a5

locret_F7E:
		rte
; ---------------------------------------------------------------------------

padInit:
		stopZ80
		waitZ80
		moveq	#$40,d0
		move.b	d0,($A10009).l
		move.b	d0,($A1000B).l
		move.b	d0,($A1000D).l
		startZ80
		rts
; ---------------------------------------------------------------------------

ReadJoypads:
		stopZ80
		waitZ80
		lea	(v_jpadhold1).w,a0
		lea	(z80_port_1_data+1).l,a1
		bsr.s	sub_FDC
		addq.w	#2,a1
		bsr.s	sub_FDC
		startZ80
		rts
; ---------------------------------------------------------------------------

sub_FDC:
		move.b	#0,(a1)
		nop
		nop
		move.b	(a1),d0
		lsl.b	#2,d0
		andi.b	#$C0,d0
		move.b	#$40,(a1)
		nop
		nop
		move.b	(a1),d1
		andi.b	#$3F,d1
		or.b	d1,d0
		not.b	d0
		move.b	(a0),d1
		eor.b	d0,d1
		move.b	d0,(a0)+
		and.b	d0,d1
		move.b	d1,(a0)+
		rts
; ---------------------------------------------------------------------------

vdpInit:
		lea	(vdp_control_port).l,a0
		lea	(vdp_data_port).l,a1
		lea	(vdpInitRegs).l,a2
		moveq	#$12,d7

loc_101E:
		move.w	(a2)+,(a0)
		dbf	d7,loc_101E
		move.w	(vdpInitRegs+2).l,d0
		move.w	d0,(v_vdp_buffer1).w
		moveq	#0,d0
		move.l	#$C0000000,(vdp_control_port).l
		move.w	#$3F,d7

loc_103E:
		move.w	d0,(a1)
		dbf	d7,loc_103E
		clr.l	(v_scrposy_dup).w
		clr.l	(v_scrposx_dup).w
		move.l	d1,-(sp)
		fillVRAM	0,$FFFF,0

loc_1070:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	loc_1070
		move.w	#$8F02,(a5)
		move.l	(sp)+,d1
		rts 
; ---------------------------------------------------------------------------

vdpInitRegs:	dc.w $8004
		dc.w $8134
		dc.w $8230
		dc.w $8328
		dc.w $8407
		dc.w $857C
		dc.w $8600
		dc.w $8700
		dc.w $8800
		dc.w $8900
		dc.w $8A00
		dc.w $8B00
		dc.w $8C81
		dc.w $8D3F
		dc.w $8E00
		dc.w $8F02
		dc.w $9001
		dc.w $9100
		dc.w $9200
; ---------------------------------------------------------------------------

sub_10A6:
		fillVRAM	0,$FFF,vram_fg ; clear foreground namespace

loc_10C8:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	loc_10C8
		move.w	#$8F02,(a5)
		fillVRAM	0,$FFF,vram_bg ; clear background namespace

loc_10F6:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	loc_10F6
		move.w	#$8F02,(a5)
		move.l	#0,(v_scrposy_dup).w
		move.l	#0,(v_scrposx_dup).w
		lea	(v_spritetablebuffer).w,a1
		moveq	#0,d0
		move.w	#($280/4),d1	; This should be ($280/4)-1

loc_111C:
		move.l	d0,(a1)+
		dbf	d1,loc_111C
		lea	(v_hscrolltablebuffer).w,a1
		moveq	#0,d0
		move.w	#($400/4),d1	; This should be ($400/4)-1, leading to a slight bug (first bit of the Sonic object's RAM is cleared)

loc_112C:
		move.l	d0,(a1)+
		dbf	d1,loc_112C
		rts
; ---------------------------------------------------------------------------

SoundDriverLoad:
		nop
		stopZ80
		resetZ80
		lea	(Unc_Z80).l,a0
		lea	(z80_ram).l,a1
		move.w	#(Unc_Z80_End-Unc_Z80)-1,d0

loc_1156:
		move.b	(a0)+,(a1)+
		dbf	d0,loc_1156
		moveq	#0,d0
		lea	(z80_ram+$1FF8).l,a1
		move.b	d0,(a1)+
		move.b	#$80,(a1)+
		move.b	#7,(a1)+
		move.b	#$80,(a1)+
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		resetZ80a
		nop
		nop
		nop
		nop
		resetZ80
		startZ80
		rts
; ---------------------------------------------------------------------------
unk_119C:
		dc.b 3,0,0,$14,0,0,0,0
; ---------------------------------------------------------------------------

PlayMusic:
		move.b	d0,(v_snddriver_ram+$A).w
		rts
; ---------------------------------------------------------------------------

PlaySFX:
		move.b	d0,(v_snddriver_ram+$B).w
		rts
; ---------------------------------------------------------------------------
PlaySound_Unused:
		move.b	d0,(v_snddriver_ram+$C).w
		rts

                include "_inc\PauseGame.asm"
; ---------------------------------------------------------------------------

TilemapToVRAM:
		lea	(vdp_data_port).l,a6
		move.l	#$800000,d4

loc_1222:
		move.l	d0,4(a6)
		move.w	d1,d3

loc_1228:
		move.w	(a1)+,(a6)
		dbf	d3,loc_1228
		add.l	d4,d0
		dbf	d2,loc_1222
		rts
; ---------------------------------------------------------------------------

		include "_inc\Nemesis Decompression.asm"

; ---------------------------------------------------------------------------

plcAdd:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		lea	(plcList).w,a2

loc_138E:
		tst.l	(a2)
		beq.s	loc_1396
		addq.w	#6,a2
		bra.s	loc_138E
; ---------------------------------------------------------------------------

loc_1396:
		move.w	(a1)+,d0
		bmi.s	loc_13A2

loc_139A:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		dbf	d0,loc_139A

loc_13A2:
		movem.l	(sp)+,a1-a2
		rts
; ---------------------------------------------------------------------------

plcReplace:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		bsr.s	ClearPLC
		lea	(plcList).w,a2
		move.w	(a1)+,d0
		bmi.s	loc_13CE

loc_13C6:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		dbf	d0,loc_13C6

loc_13CE:
		movem.l	(sp)+,a1-a2
		rts
; ---------------------------------------------------------------------------

ClearPLC:
		lea	(plcList).w,a2
		moveq	#$1F,d0

loc_13DA:
		clr.l	(a2)+
		dbf	d0,loc_13DA
		rts
; ---------------------------------------------------------------------------

RunPLC:
		tst.l	(plcList).w
		beq.s	locret_1436
		tst.w	(unk_FFF6F8).w
		bne.s	locret_1436
		movea.l	(plcList).w,a0
		lea	(NemPCD_WriteRowToVDP).l,a3
		lea	(v_ngfx_buffer).w,a1
		move.w	(a0)+,d2
		bpl.s	loc_1404
		adda.w	#$A,a3

loc_1404:
		andi.w	#$7FFF,d2
		move.w	d2,(unk_FFF6F8).w
		bsr.w	NemDec_BuildCodeTable
		move.b	(a0)+,d5
		asl.w	#8,d5
		move.b	(a0)+,d5
		moveq	#$10,d6
		moveq	#0,d0
		move.l	a0,(plcList).w
		move.l	a3,(unk_FFF6E0).w
		move.l	d0,(unk_FFF6E4).w
		move.l	d0,(unk_FFF6E8).w
		move.l	d0,(unk_FFF6EC).w
		move.l	d5,(unk_FFF6F0).w
		move.l	d6,(unk_FFF6F4).w

locret_1436:
		rts
; ---------------------------------------------------------------------------

sub_1438:
		tst.w	(unk_FFF6F8).w
		beq.w	locret_14D0
		move.w	#9,(unk_FFF6FA).w
		moveq	#0,d0
		move.w	(plcList+4).w,d0
		addi.w	#$120,(plcList+4).w
		bra.s	loc_146C
; ---------------------------------------------------------------------------

loc_1454:
		tst.w	(unk_FFF6F8).w
		beq.s	locret_14D0
		move.w	#3,(unk_FFF6FA).w
		moveq	#0,d0
		move.w	(plcList+4).w,d0
		addi.w	#$60,(plcList+4).w

loc_146C:
		lea	(vdp_control_port).l,a4
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(a4)
		subq.w	#4,a4
		movea.l	(plcList).w,a0
		movea.l	(unk_FFF6E0).w,a3
		move.l	(unk_FFF6E4).w,d0
		move.l	(unk_FFF6E8).w,d1
		move.l	(unk_FFF6EC).w,d2
		move.l	(unk_FFF6F0).w,d5
		move.l	(unk_FFF6F4).w,d6
		lea	(v_ngfx_buffer).w,a1

loc_14A0:
		movea.w	#8,a5
		bsr.w	NemPCD_NewRow
		subq.w	#1,(unk_FFF6F8).w
		beq.s	ShiftPLC
		subq.w	#1,(unk_FFF6FA).w
		bne.s	loc_14A0
		move.l	a0,(plcList).w

loc_14B8:
		move.l	a3,(unk_FFF6E0).w
		move.l	d0,(unk_FFF6E4).w
		move.l	d1,(unk_FFF6E8).w
		move.l	d2,(unk_FFF6EC).w
		move.l	d5,(unk_FFF6F0).w
		move.l	d6,(unk_FFF6F4).w

locret_14D0:
		rts
; ---------------------------------------------------------------------------

ShiftPLC:
		lea	(plcList).w,a0
		moveq	#$15,d0

loc_14D8:
		move.l	6(a0),(a0)+
		dbf	d0,loc_14D8
		rts
; ---------------------------------------------------------------------------

sub_14E2:
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		move.w	(a1)+,d1

loc_14F4:
		movea.l	(a1)+,a0
		moveq	#0,d0
		move.w	(a1)+,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(vdp_control_port).l
		bsr.w	NemDec
		dbf	d1,loc_14F4
		rts
; ---------------------------------------------------------------------------

		include "_inc\Enigma Decompression.asm"
		include "_inc\Kosinski Decompression.asm"
                include "_inc\PaletteCycle.asm"

Cyc_Title:	incbin "palette\Cycle - Title.bin"
		even
Cyc_GHZ:	incbin "palette\Cycle - GHZ.bin"
		even
Cyc_LZ:	        incbin "palette\Cycle - LZ Unused.bin"
		even
Cyc_MZ:	        incbin "palette\Cycle - MZ Unused.bin"
		even
Cyc_SZ1:	incbin "palette\Cycle - SZ1.bin"
		even
Cyc_SZ2:	incbin "palette\Cycle - SZ2.bin"
		even
; ---------------------------------------------------------------------------

PaletteWhiteIn:
		move.w	#$3F,(v_pfade_start).w
		moveq	#0,d0
		lea	(v_pal_dry).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		moveq	#0,d1
		move.b	(v_pfade_size).w,d0

loc_1968:
		move.w	d1,(a0)+
		dbf	d0,loc_1968
		move.w	#$14,d4

loc_1972:
		move.b	#$12,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.s	sub_1988
		bsr.w	RunPLC
		dbf	d4,loc_1972
		rts
; ---------------------------------------------------------------------------

sub_1988:
		moveq	#0,d0
		lea	(v_pal_dry).w,a0
		lea	(v_pal_dry_dup).w,a1
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(v_pfade_size).w,d0

loc_199E:
		bsr.s	sub_19A6
		dbf	d0,loc_199E
		rts
; ---------------------------------------------------------------------------

sub_19A6:
		move.w	(a1)+,d2
		move.w	(a0),d3
		cmp.w	d2,d3
		beq.s	loc_19CE
		move.w	d3,d1
		addi.w	#$200,d1
		cmp.w	d2,d1
		bhi.s	loc_19BC
		move.w	d1,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_19BC:
		move.w	d3,d1
		addi.w	#$20,d1
		cmp.w	d2,d1
		bhi.s	loc_19CA
		move.w	d1,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_19CA:
		addq.w	#2,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_19CE:
		addq.w	#2,a0
		rts
; ---------------------------------------------------------------------------

PaletteFadeOut:
		move.w	#$3F,(v_pfade_start).w
		move.w	#$14,d4

loc_19DC:
		move.b	#$12,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.s	FadeOut_ToBlack
		bsr.w	RunPLC
		dbf	d4,loc_19DC
		rts
; ---------------------------------------------------------------------------

FadeOut_ToBlack:
		moveq	#0,d0
		lea	(v_pal_dry).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		move.b	(v_pfade_size).w,d0

loc_1A02:
		bsr.s	sub_1A0A
		dbf	d0,loc_1A02
		rts
; ---------------------------------------------------------------------------

sub_1A0A:
		move.w	(a0),d2
		beq.s	loc_1A36
		move.w	d2,d1
		andi.w	#$E,d1
		beq.s	loc_1A1A
		subq.w	#2,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_1A1A:
		move.w	d2,d1
		andi.w	#$E0,d1
		beq.s	loc_1A28
		subi.w	#$20,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_1A28:
		move.w	d2,d1
		andi.w	#$E00,d1
		beq.s	loc_1A36
		subi.w	#$200,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_1A36:
		addq.w	#2,a0
		rts
; ---------------------------------------------------------------------------

PalCycSega:
		subq.w	#1,(word_FFF634).w
		bpl.s	locret_1A68
		move.w	#3,(word_FFF634).w
		move.w	(word_FFF632).w,d0
		bmi.s	locret_1A68
		subq.w	#2,(word_FFF632).w
		lea	(Cyc_Sega).l,a0
		lea	(v_pal_dry+4).w,a1
		adda.w	d0,a0
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.w	(a0)+,(a1)+

locret_1A68:
		rts
; ---------------------------------------------------------------------------
Cyc_Sega:	incbin "palette\Cycle - Sega.bin"
		even
; ---------------------------------------------------------------------------

PalLoad1:
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2
		movea.w	(a1)+,a3
		adda.w	#$80,a3
		move.w	(a1)+,d7

        .loop:
		move.l	(a2)+,(a3)+
		dbf	d7,.loop
		rts
; ---------------------------------------------------------------------------

PalLoad2:
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2
		movea.w	(a1)+,a3
		move.w	(a1)+,d7

        .loop:
		move.l	(a2)+,(a3)+
		dbf	d7,.loop
		rts

                include "_inc\Palette Pointers.asm"

Pal_SegaBG:	incbin "palette\Sega Screen.bin"
		even
Pal_Title:	incbin "palette\Title Screen.bin"
		even
Pal_LevelSel:	incbin "palette\Level Select.bin"
		even
Pal_Sonic:	incbin "palette\Sonic.bin"
		even
Pal_GHZ:	incbin "palette\Green Hill Zone.bin"
		even
Pal_LZ:		incbin "palette\Labyrinth Zone.bin"
		even
Pal_Ending:	incbin "palette\Ending.bin"
		even
Pal_MZ:		incbin "palette\Marble Zone.bin"
		even
Pal_SLZ:	incbin "palette\Star Light Zone.bin"
		even
Pal_SZ:		incbin "palette\Sparkling Zone.bin"
		even
Pal_CWZ:	incbin "palette\Clock Work Zone.bin"
		even
Pal_Special:	incbin "palette\Special Stage.bin"
		even

; ---------------------------------------------------------------------------

WaitForVBla:
		enable_ints

.wait:
		tst.b	(VBlankRoutine).w
		bne.s	.wait
		rts
; ---------------------------------------------------------------------------

RandomNumber:
		move.l	(RandomSeed).w,d1
		bne.s	.noreset
		move.l	#$2A6D365A,d1

.noreset:
		move.l	d1,d0
		asl.l	#2,d1
		add.l	d0,d1
		asl.l	#3,d1
		add.l	d0,d1
		move.w	d1,d0
		swap	d1
		add.w	d1,d0
		move.w	d0,d1
		swap	d1
		move.l	d1,(RandomSeed).w
		rts
; ---------------------------------------------------------------------------

GetSine:
		andi.w	#$FF,d0
		add.w	d0,d0
		addi.w	#$80,d0
		move.w	SineTable(pc,d0.w),d1
		subi.w	#$80,d0
		move.w	SineTable(pc,d0.w),d0
		rts
; ---------------------------------------------------------------------------
SineTable:	incbin "misc\sinetable.dat"
		even
; ---------------------------------------------------------------------------
GetSqrt:					; Leftover in the final game (REV00 only though)
		movem.l	d1-d2,-(sp)
		move.w	d0,d1
		swap	d1
		moveq	#0,d0
		move.w	d0,d1
		moveq	#7,d2

loc_22F4:
		rol.l	#2,d1
		add.w	d0,d0
		addq.w	#1,d0
		sub.w	d0,d1
		bcc.s	loc_230E
		add.w	d0,d1
		subq.w	#1,d0
		dbf	d2,loc_22F4
		lsr.w	#1,d0
		movem.l	(sp)+,d1-d2
		rts
; ---------------------------------------------------------------------------

loc_230E:
		addq.w	#1,d0
		dbf	d2,loc_22F4
		lsr.w	#1,d0
		movem.l	(sp)+,d1-d2
		rts
; ---------------------------------------------------------------------------

CalcAngle:
		movem.l	d3-d4,-(sp)
		moveq	#0,d3
		moveq	#0,d4
		move.w	d1,d3
		move.w	d2,d4
		or.w	d3,d4
		beq.s	loc_2378
		move.w	d2,d4
		tst.w	d3
		bpl.w	loc_2336
		neg.w	d3

loc_2336:
		tst.w	d4
		bpl.w	loc_233E
		neg.w	d4

loc_233E:
		cmp.w	d3,d4
		bcc.w	loc_2350
		lsl.l	#8,d4
		divu.w	d3,d4
		moveq	#0,d0
		move.b	AngleTable(pc,d4.w),d0
		bra.s	loc_235A
; ---------------------------------------------------------------------------

loc_2350:
		lsl.l	#8,d3
		divu.w	d4,d3
		moveq	#$40,d0
		sub.b	AngleTable(pc,d3.w),d0

loc_235A:
		tst.w	d1
		bpl.w	loc_2366
		neg.w	d0
		addi.w	#$80,d0

loc_2366:
		tst.w	d2
		bpl.w	loc_2372
		neg.w	d0
		addi.w	#$100,d0

loc_2372:
		movem.l	(sp)+,d3-d4
		rts
; ---------------------------------------------------------------------------

loc_2378:
		move.w	#$40,d0
		movem.l	(sp)+,d3-d4
		rts
; ---------------------------------------------------------------------------
AngleTable:	incbin "misc\angles.bin"
		even
; ---------------------------------------------------------------------------

GM_Sega:
		move.b	#$E0,d0
		bsr.w	PlaySFX
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)
		move.w	#$8230,(a6)
		move.w	#$8407,(a6)
		move.w	#$8700,(a6)
		move.w	#$8B00,(a6)
		move.w	(v_vdp_buffer1).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l

loc_24BC:
		bsr.w	sub_10A6
		locVRAM 0
		lea	(Nem_SegaLogo).l,a0
		bsr.w	NemDec
		lea	($FF0000).l,a1
		lea	(Eni_SegaLogo).l,a0
		move.w	#0,d0
		bsr.w	EniDec
		copyTilemap	$FF0000,$C61C,$B,3
		moveq	#0,d0
		bsr.w	PalLoad2
		move.w	#$28,(word_FFF632).w
		move.w	#0,(word_FFF662).w
		move.w	#0,(word_FFF660).w
		move.w	#$B4,(v_demolength).w
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l

loc_2528:
		move.b	#2,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.w	PalCycSega
		tst.w	(v_demolength).w
		beq.s	loc_2544
		andi.b	#$80,(v_jpadpress1).w
		beq.s	loc_2528

loc_2544:
		move.b	#4,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

GM_Title:
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)
		move.w	#$8230,(a6)
		move.w	#$8407,(a6)
		move.w	#$9001,(a6)
		move.w	#$9200,(a6)
		move.w	#$8B03,(a6)
		move.w	#$8720,(a6)
		move.w	(v_vdp_buffer1).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	sub_10A6
		lea	(v_objspace).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1

loc_2592:
		move.l	d0,(a1)+
		dbf	d1,loc_2592
		locVRAM $4000
		lea	(Nem_TitleFg).l,a0
		bsr.w	NemDec
		locVRAM $6060
		lea	(Nem_TitleSonic).l,a0
		bsr.w	NemDec
		lea	(vdp_data_port).l,a6
		locVRAM $D000,4(a6)
		lea	(ArtText).l,a5
		move.w	#$28F,d1

loc_25D8:
		move.w	(a5)+,(a6)
		dbf	d1,loc_25D8
		lea	(Unc_Title).l,a1
		move.l  #$41860003,d0
		moveq   #$21,d1
		moveq   #$17,d2
		bsr.w	TilemapToVRAM
        ;        copyTilemapUnc	$C206,$21,$17
		move.w	#0,(DebugRoutine).w
		move.w	#0,(DemoMode).w
		move.w	#0,(v_zone).w
		bsr.w	LoadLevelBounds
		bsr.w	DeformLayers
		locVRAM 0
		lea	(Nem_GHZ_1st).l,a0
		bsr.w	NemDec
		lea	(Blk16_GHZ).l,a0
		lea	(v_16x16).w,a4
		move.w	#$5FF,d0

.loadblocks:
		move.l	(a0)+,(a4)+
		dbf	d0,.loadblocks
		lea	(Blk256_GHZ).l,a0
		lea	(v_256x256&$FFFFFF).l,a1
		bsr.w	KosDec
		bsr.w	LoadLayout
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_bgscreenposx).w,a3
		lea	(v_lvllayout+$40).w,a4
		move.w	#$6000,d2
		bsr.w	sub_47B0
		moveq	#1,d0
		bsr.w	PalLoad1
		move.b	#$8A,d0
		bsr.w	PlaySFX
		move.b	#0,(f_debugmode).w
		;move.w	#$178,(v_demolength).w   ; run title screen for $178 frames
		move.b	#$E,(v_objspace+$40).w  ; load big sonic object
		move.b	#$F,(v_objspace+$80).w  ; load press start button text
		move.b	#$F,(v_objspace+$C0).w  ; load object which hides sonic
		move.b	#2,(v_objspace+$DA).w
		moveq	#0,d0
		bsr.w	plcReplace
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	PaletteWhiteIn

loc_26AE:
		move.b	#4,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.w	RunObjects
		bsr.w	DeformLayers
		bsr.w	ProcessMaps
		;bsr.w	PalCycTitle
		bsr.w	RunPLC
		move.w	(v_objspace+8).w,d0
		addq.w	#3,d0              ; set object scroll right speed
		move.w	d0,(v_objspace+8).w ; move sonic to the right
		cmpi.w	#$1C00,d0          ; has object passed $1C00?
		bcs.s	loc_26E4           ; if not, branch
		move.b	#0,(v_gamemode).w    ; go to Sega Screen
		rts
; ---------------------------------------------------------------------------

loc_26E4:
		;tst.w	(v_demolength).w
		;beq.w	loc_27F8
		andi.b	#$80,(v_jpadpress1).w
		beq.w	loc_26AE
		btst	#6,(v_jpadhold1).w
		beq.w	loc_27AA
		moveq	#2,d0
		bsr.w	PalLoad2
		lea	(v_hscrolltablebuffer).w,a1
		moveq	#0,d0
		move.w	#$DF,d1

loc_2710:
		move.l	d0,(a1)+
		dbf	d1,loc_2710
		move.l	d0,(v_scrposy_dup).w
		disable_ints
		lea	(vdp_data_port).l,a6
		move.l	#$60000003,(vdp_control_port).l
		move.w	#$3FF,d1

loc_2732:
		move.l	d0,(a6)
		dbf	d1,loc_2732
		bsr.w	LevSelTextLoad

;loc_273C:
LevelSelect:
		move.b	#4,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.w	sub_28A6
		bsr.w	RunPLC
		tst.l	(plcList).w
		bne.s	LevelSelect
		andi.b	#$F0,(v_jpadpress1).w
		beq.s	LevelSelect
		move.w	(LevSelOption).w,d0
		cmpi.w	#$13,d0
		bne.s	loc_2780
		move.w	(LevSelSound).w,d0
		addi.w	#$80,d0
		cmpi.w	#$93,d0		; There's no pointer for music $92 or $93
		bcs.s	loc_277A	; So the game crashes when played
		cmpi.w	#$A0,d0
		bcs.s	LevelSelect

loc_277A:
		bsr.w	PlaySFX
		bra.s	LevelSelect
; ---------------------------------------------------------------------------

loc_2780:
		add.w	d0,d0
		move.w	LevSelOrder(pc,d0.w),d0
		bmi.s	LevelSelect
		cmpi.w	#$700,d0
		bne.s	loc_27A6
		move.b	#$10,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

;loc_2796:
;		andi.w	#$3FFF,d0
;		btst	#4,(v_jpadhold1).w	; Is B pressed?
;		beq.s	loc_27A6	; If not, ignore below
;		move.w	#3,d0		; Set the zone to Green Hill Act 4

loc_27A6:
		move.w	d0,(v_zone).w

loc_27AA:
		move.b	#$C,(v_gamemode).w
		move.b	#3,(v_lives).w
		moveq	#0,d0
		move.w	d0,(v_rings).w
		move.l	d0,(v_time).w
		move.l	d0,(v_score).w
		;move.b	#$E0,d0
		;bsr.w	PlaySFX
		rts
; ---------------------------------------------------------------------------

LevSelOrder:	dc.w 0,    1,    2
		dc.w $8500, $8500, $8500
		dc.w $200, $201, $202
		dc.w $8500, $8500, $8500
		dc.w $400, $401, $402
		dc.w $8500, $8500,$8500
		dc.w $700, $700,$8000
; ---------------------------------------------------------------------------

; loc_27F8:
		; move.w	#$1E,(v_demolength).w

; loc_27FE:
		; move.b	#4,(VBlankRoutine).w
		; bsr.w	WaitForVBla
		; bsr.w	DeformLayers
		; bsr.w	PaletteCycle
		; bsr.w	RunPLC
		; move.w	(v_objspace+8).w,d0
		; addq.w	#2,d0
		; move.w	d0,(v_objspace+8).w
		; cmpi.w	#$1C00,d0
		; bcs.s	loc_282C
		; move.b	#0,(v_gamemode).w
		; rts
; ---------------------------------------------------------------------------

; loc_282C:
		; tst.w	(v_demolength).w
		; bne.w	loc_27FE
		; move.b	#$E0,d0
		; bsr.w	PlaySFX
		; move.w	(DemoNum).w,d0
		; andi.w	#7,d0
		; add.w	d0,d0
		; move.w	DemoLevels(pc,d0.w),d0
		; move.w	#0,(v_zone).w
		; addq.w	#1,(DemoNum).w
		; cmpi.w	#4,(DemoNum).w
		; bcs.s	loc_2860
		; move.w	#0,(DemoNum).w

loc_2860:
		move.w	#1,(DemoMode).w
		move.b	#8,(v_gamemode).w
		cmpi.w	#$600,d0
		bne.s	loc_2878
		move.b	#$10,(v_gamemode).w

loc_2878:
		move.b	#3,(v_lives).w
		moveq	#0,d0
		move.w	d0,(v_rings).w
		move.l	d0,(v_time).w
		move.l	d0,(v_score).w
		rts
; ---------------------------------------------------------------------------

;DemoLevels:	dc.w $200, 0, $600, $400
; ---------------------------------------------------------------------------

sub_28A6:
		move.b	(v_jpadpress1).w,d1
		andi.b	#3,d1
		bne.s	loc_28B6
		subq.w	#1,(word_FFF666).w
		bpl.s	loc_28F0

loc_28B6:
		move.w	#$B,(word_FFF666).w
		move.b	(v_jpadhold1).w,d1
		andi.b	#3,d1
		beq.s	loc_28F0
		move.w	(LevSelOption).w,d0
		btst	#0,d1
		beq.s	loc_28D6
		subq.w	#1,d0
		bcc.s	loc_28D6
		moveq	#$13,d0

loc_28D6:
		btst	#1,d1
		beq.s	loc_28E6
		addq.w	#1,d0
		cmpi.w	#$14,d0
		bcs.s	loc_28E6
		moveq	#0,d0

loc_28E6:
		move.w	d0,(LevSelOption).w
		bsr.w	LevSelTextLoad
		rts
; ---------------------------------------------------------------------------

loc_28F0:
		cmpi.w	#$13,(LevSelOption).w
		bne.s	locret_292A
		move.b	(v_jpadpress1).w,d1
		andi.b	#$C,d1
		beq.s	locret_292A
		move.w	(LevSelSound).w,d0
		btst	#2,d1
		beq.s	loc_2912
		subq.w	#1,d0
		bcc.s	loc_2912
		moveq	#79,d0

loc_2912:
		btst	#3,d1
		beq.s	loc_2922
		addq.w	#1,d0
		cmpi.w	#80,d0
		bcs.s	loc_2922
		moveq	#0,d0

loc_2922:
		move.w	d0,(LevSelSound).w
		bsr.w	LevSelTextLoad

locret_292A:
		rts
; ---------------------------------------------------------------------------

;sub_292C:
LevSelTextLoad:
		lea	(LevelSelectText).l,a1
		lea	(vdp_data_port).l,a6
		move.l	#$62100003,d4
		move.w	#$E680,d3
		moveq	#$13,d1

loc_2944:
		move.l	d4,4(a6)
		bsr.w	sub_29CC
		addi.l	#$800000,d4
		dbf	d1,loc_2944
		moveq	#0,d0
		move.w	(LevSelOption).w,d0
		move.w	d0,d1
		move.l	#$62100003,d4
		lsl.w	#7,d0
		swap	d0
		add.l	d0,d4
		lea	(LevelSelectText).l,a1
		lsl.w	#3,d1
		move.w	d1,d0
		add.w	d1,d1
		add.w	d0,d1
		adda.w	d1,a1
		move.w	#$C680,d3
		move.l	d4,4(a6)
		bsr.w	sub_29CC
		move.w	#$E680,d3
		cmpi.w	#$13,(LevSelOption).w
		bne.s	loc_2996
		move.w	#$C680,d3

loc_2996:
		move.l	#$6BB00003,(vdp_control_port).l
		move.w	(LevSelSound).w,d0
		addi.w	#$80,d0
		move.b	d0,d2
		lsr.b	#4,d0
		bsr.w	sub_29B8
		move.b	d2,d0
		bsr.w	sub_29B8
		rts
; ---------------------------------------------------------------------------

sub_29B8:
		andi.w	#$F,d0
		cmpi.b	#$A,d0
		bcs.s	loc_29C6
		addi.b	#7,d0

loc_29C6:
		add.w	d3,d0
		move.w	d0,(a6)
		rts
; ---------------------------------------------------------------------------

sub_29CC:
		moveq	#$17,d2

loc_29CE:
		moveq	#0,d0
		move.b	(a1)+,d0
		bpl.s	loc_29DE
		move.w	#0,(a6)
		dbf	d2,loc_29CE
		rts
; ---------------------------------------------------------------------------

loc_29DE:
		add.w	d3,d0
		move.w	d0,(a6)
		dbf	d2,loc_29CE
		rts
; ---------------------------------------------------------------------------

LevelSelectText:incbin "misc\Level Select Text.bin"
                even

MusicList:	dc.b $81, $82, $83, $84, $85, $86
		even
; ---------------------------------------------------------------------------

GM_Level:
		move.b	#$E0,d0
		bsr.w	PlaySFX
                ;locVRAM $B000
		;lea	(Nem_TitleCard).l,a0
		;bsr.w	NemDec
		bsr.w	ClearPLC
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#4,d0
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	loc_2C0A
		bsr.w	plcAdd

loc_2C0A:
		moveq	#1,d0
		bsr.w	plcAdd
		bsr.w	PaletteFadeOut
		bsr.w	sub_10A6
		lea	(vdp_control_port).l,a6
		move.w	#$8B03,(a6)
		move.w	#$8230,(a6)
		move.w	#$8407,(a6)
		move.w	#$857C,(a6)
		move.w	#0,(word_FFFFE8).w
		move.w	#$8AAF,(v_hbla_hreg).w
		move.w	#$8004,(a6)
		move.w	#$8720,(a6)
		lea	(v_objspace).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1

loc_2C4C:
		move.l	d0,(a1)+
		dbf	d1,loc_2C4C
		lea	(v_screenposx).w,a1
		moveq	#0,d0
		move.w	#$3F,d1

loc_2C5C:
		move.l	d0,(a1)+
		dbf	d1,loc_2C5C
		lea	((oscValues+2)).w,a1
		moveq	#0,d0
		move.w	#$27,d1

loc_2C6C:
		move.l	d0,(a1)+
		dbf	d1,loc_2C6C
		moveq	#3,d0
		bsr.w	PalLoad2
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lea	(MusicList).l,a1
		move.b	(a1,d0.w),d0
		bsr.w	PlayMusic
		
		moveq	#2,d0
		jsr	(plcAdd).l
		moveq	#0,d0
		move.b	(v_zone).w,d0
		addi.w	#$15,d0
		jsr	(plcAdd).l
		;cmpi.b 	#2,(v_act).w ; DISCO MOODEEEEE
		;bne.s 	@titlecards
		;move.w	#$E2,d0
		;bsr.w	PlayMusic
	;@titlecards:
		;move.b	#$34,(v_objspace+$80).w

loc_2C92:
		move.b	#$C,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.w	RunObjects
		bsr.w	ProcessMaps
		bsr.w	RunPLC
		;move.w	(v_objspace+$108).w,d0
		;cmp.w	(v_objspace+$130).w,d0
		;bne.s	loc_2C92
		tst.l	(plcList).w
		bne.s	loc_2C92
		bsr.w	EarlyDebugLoadArt
		jsr	(sub_117C6).l
		moveq	#3,d0
		bsr.w	PalLoad1
		bsr.w	LoadLevelBounds
		bsr.w	DeformLayers
		bsr.w	LoadLevelData
		bsr.w	LoadAnimatedBlocks
		bsr.w	mapLevelLoadFull
		jsr	(LogCollision).l
		move.l	#colGHZ,(Collision).w		; Load Green Hill's collision - what follows are some C style conditional statements, really unnecessary and replaced with a table in the final game
		cmpi.b	#1,(v_zone).w			; Is the current zone Labyrinth?
		bne.s	loc_2CFA			; If not, go to the next condition
		move.l	#colLZ,(Collision).w		; Load Labyrinth's collision

loc_2CFA:
		cmpi.b	#2,(v_zone).w			; Is the current zone Marble?
		bne.s	loc_2D0A			; If not, go to the next condition
		move.l	#colMZ,(Collision).w		; Load Marble's collision

loc_2D0A:
		cmpi.b	#3,(v_zone).w			; Is the current zone Star Light?
		bne.s	loc_2D1A			; If not, go to the next condition
		move.l	#colSLZ,(Collision).w		; Load Star Light's collision

loc_2D1A:
		cmpi.b	#4,(v_zone).w			; Is the current zone Sparkling?
		bne.s	loc_2D2A			; If not, go to the last condition
		move.l	#colSZ,(Collision).w		; Load Sparkling's collision

loc_2D2A:
		cmpi.b	#5,(v_zone).w			; Is the current zone Clock Work?
		bne.s	loc_2D3A			; If not, then just skip loading collision
		move.l	#colCWZ,(Collision).w		; Load Clock Work's collision

loc_2D3A:
		move.b	#1,(v_objspace).w ; sonic
		move.b	#$21,(v_objspace+$40).w ; hud
		btst	#6,(v_jpadhold1).w
		beq.s	loc_2D54
		move.b	#1,(f_debugmode).w

loc_2D54:
		move.w	#0,(v_jpadhold2).w
		move.w	#0,(v_jpadhold1).w
		bsr.w	ObjPosLoad
		bsr.w	RunObjects
		bsr.w	ProcessMaps
		moveq	#0,d0
		move.w	d0,(v_rings).w
		move.b	d0,(byte_FFFE1B).w
		move.l	d0,(v_time).w
		move.b	d0,(v_shield).w
		move.b	d0,(v_invinc).w
		move.b	d0,(v_shoes).w
		move.b	d0,($FFFFFE2F).w
		move.w	d0,(DebugRoutine).w
		move.w	d0,(LevelRestart).w
		move.w	d0,(LevelFrames).w
		bsr.w	oscInit
		move.b	#1,(byte_FFFE1F).w
		move.b	#1,(f_extralife).w
		move.b	#1,(f_timecount).w
		move.w	#0,(unk_FFF790).w
		lea	(Demo_GHZ).l,a1
		;moveq	#0,d0
		;move.b	(v_zone).w,d0
		;lsl.w	#2,d0
		;movea.l	(a1,d0.w),a1
		move.b	1(a1),(unk_FFF792).w
		subq.b	#1,(unk_FFF792).w
		move.w	#$708,(v_demolength).w
		move.b	#8,(VBlankRoutine).w
		bsr.w	WaitForVBla
		move.w	#$202F,(v_pfade_start).w
		bsr.w	PaletteWhiteIn+6
		;addq.b	#2,(v_objspace+$A4).w
		;addq.b	#4,(v_objspace+$E4).w
		;addq.b	#4,(v_objspace+$124).w
		;addq.b	#4,(v_objspace+$164).w

GM_LevelLoop:
		bsr.w	PauseGame
		move.b	#8,(VBlankRoutine).w
		bsr.w	WaitForVBla
		addq.w	#1,(LevelFrames).w
		;bsr.w	LZWaterFeatures
		bsr.w	DemoPlayback
		move.w	(v_jpadhold1).w,(v_jpadhold2).w
		bsr.w	RunObjects
		bsr.w 	EarlyDebugMappings
		;tst.w	(DebugRoutine).w
		;bne.s	loc_2E2A
		;cmpi.b	#6,(v_objspace+$24).w ; if sonic is dead, dont update cam scrolling
		;bcc.s	loc_2E2E

;loc_2E2A:
		bsr.w	DeformLayers

loc_2E2E:
		bsr.w	ProcessMaps
		bsr.w	ObjPosLoad
		bsr.w	PaletteCycle
		bsr.w	RunPLC
		bsr.w	oscUpdate
		bsr.w	UpdateTimers
		bsr.w	LoadSignpostPLC
		cmpi.b	#8,(v_gamemode).w
		beq.s	loc_2E66
		tst.w	(LevelRestart).w
		bne.w	GM_Level
		cmpi.b	#$C,(v_gamemode).w
		beq.w	GM_LevelLoop
		rts
; ---------------------------------------------------------------------------

loc_2E66:
		tst.w	(LevelRestart).w
		bne.s	loc_2E84
		tst.w	(v_demolength).w
		beq.s	loc_2E84
		cmpi.b	#8,(v_gamemode).w
		beq.w	GM_LevelLoop
		move.b	#0,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

loc_2E84:
		cmpi.b	#8,(v_gamemode).w
		bne.s	loc_2E92
		move.b	#0,(v_gamemode).w

loc_2E92:
		move.w	#$3C,(v_demolength).w
		move.w	#$3F,(v_pfade_start).w

loc_2E9E:
		move.b	#8,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.w	DemoPlayback
		bsr.w	RunObjects
		bsr.w	ProcessMaps
		bsr.w	ObjPosLoad
		subq.w	#1,(unk_FFF794).w
		bpl.s	loc_2EC8
		move.w	#2,(unk_FFF794).w
		bsr.w	FadeOut_ToBlack

loc_2EC8:
		tst.w	(v_demolength).w
		bne.s	loc_2E9E
		rts
; ---------------------------------------------------------------------------
                include "leftovers\Early Debug Mappings.asm"
                include "leftovers\Ultra Debug Mappings.asm"
; ---------------------------------------------------------------------------
; Unused, Speculated to have been for a window plane wavy masking effect 
; involving writes during HBlank. It writes its tables in the Nemesis GFX
; buffer, only seemingly needing to be called once.
; Discovered by Beta Filter, reconstructed by KatKuriN, Rivet, and ProjectFM
; ---------------------------------------------------------------------------
sub_3018:
		lea	(v_ngfx_buffer).w,a0
		move.w	(f_water).w,d2
		move.w	#$9100,d3
		move.w	#$FF,d7

loc_3028:
		move.w	d2,d0
		bsr.w	GetSine
		asr.w	#4,d0
		bpl.s	loc_3034
		moveq	#0,d0

loc_3034:
		andi.w	#$1F,d0
		move.b	d0,d3
		move.w	d3,(a0)+
		addq.w	#2,d2
		dbf	d7,loc_3028
		addq.w	#2,(f_water).w
		rts


; ---------------------------------------------------------------------------

DemoPlayback:
		tst.w	(DemoMode).w
		bne.s	loc_30B8
		rts
; ---------------------------------------------------------------------------

DemoRecord:
		lea	($80000).l,a1
		move.w	(unk_FFF790).w,d0
		adda.w	d0,a1
		move.b	(v_jpadhold1).w,d0
		cmp.b	(a1),d0
		bne.s	loc_30A2
		addq.b	#1,1(a1)
		cmpi.b	#$FF,1(a1)
		beq.s	loc_30A2
		rts
; ---------------------------------------------------------------------------

loc_30A2:
		move.b	d0,2(a1)
		move.b	#0,3(a1)
		addq.w	#2,(unk_FFF790).w
		andi.w	#$3FF,(unk_FFF790).w
		rts
; ---------------------------------------------------------------------------

loc_30B8:
		tst.b	(v_jpadhold1).w
		bpl.s	loc_30C4
		move.b	#4,(v_gamemode).w

loc_30C4:
		lea	(Demo_GHZ).l,a1
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0
		;movea.l	(a1,d0.w),a1
		move.w	(unk_FFF790).w,d0
		adda.w	d0,a1
		move.b	(a1),d0
		lea	(v_jpadhold1).w,a0
		move.b	d0,d1
		move.b	(a0),d2
		eor.b	d2,d0
		move.b	d1,(a0)+
		and.b	d1,d0
		move.b	d0,(a0)+
		subq.b	#1,(unk_FFF792).w
		bcc.s	locret_30FE
		move.b	3(a1),(unk_FFF792).w
		addq.w	#2,(unk_FFF790).w

locret_30FE:
		rts
; ---------------------------------------------------------------------------
TestLevelChk:
		cmpi.b	#6,(v_zone).w
		bne.s	locret_3176
		bsr.w	sub_3178
		lea	($FF0900).l,a1
		bsr.s	sub_3166
		lea	($FF3380).l,a1
; ---------------------------------------------------------------------------

sub_3166:
		lea	(word_3196).l,a0
		move.w	#$1F,d1

loc_3170:
		move.w	(a0)+,(a1)+
		dbf	d1,loc_3170

locret_3176:
		rts
; ---------------------------------------------------------------------------

sub_3178:
		lea	($FF0000).l,a1
		lea	(word_31D6).l,a0
		move.w	#$B,d1

loc_3188:
		move.w	(a0)+,d0
		ori.w	#$2000,(a1,d0.w)
		dbf	d1,loc_3188
		rts
; ---------------------------------------------------------------------------

word_3196:	dc.w $2024, $2808, $2808, $2808, $207B, 0, 0, 0, $2024
		dc.w $2808, $207B, 0, 0, 0, 0, 0, $30C7, $30C7, $30C7
		dc.w $30C7, $30C7, 0, 0, 0, $3024, $3808, $307B, 0, 0
		dc.w 0, 0, 0

word_31D6:	dc.w $517E, $519E, $51BE, $5360, $5362, $5364, $5380, $5382
		dc.w $5384, $53A0, $53A2, $53A4
; ---------------------------------------------------------------------------

LoadAnimatedBlocks:
		cmpi.b	#2,(v_zone).w
		beq.s	.ismz
		tst.b	(v_zone).w
		bne.s	.notghz
		lea	((v_16x16+$1790)).w,a1
		lea	(AnimBlocksGHZ).l,a0
		move.w	#$37,d1

.loadghz:
		move.w	(a0)+,(a1)+
		dbf	d1,.loadghz

.notghz:
		rts
; ---------------------------------------------------------------------------

.ismz:
		lea	((v_16x16+$17A0)).w,a1
		lea	(AnimBlocksMZ).l,a0
		move.w	#$2F,d1

.loadmz:
		move.w	(a0)+,(a1)+
		dbf	d1,.loadmz
		rts
; ---------------------------------------------------------------------------
AnimBlocksGHZ:	incbin "map16\Anim GHZ.bin"
		even
AnimBlocksMZ:	incbin "map16\Anim MZ.bin"
		even
; ---------------------------------------------------------------------------

EarlyDebugLoadArt:
		;rts                     ; this was rts'd out to stop it from overwriting the vram at $9E00
; ---------------------------------------------------------------------------
		move.l	#$5E000002,(vdp_control_port).l
		lea	(ArtText).l,a0
		move.w	#$9F,d1
		bsr.s	sub_3326
		lea	(ArtText).l,a0
		adda.w	#$220,a0
		move.w	#$5F,d1
; ---------------------------------------------------------------------------

sub_3326:
		move.w	(a0)+,(vdp_data_port).l
		dbf	d1,sub_3326
		rts
; ---------------------------------------------------------------------------
		moveq	#0,d0		; this code converts palette indices from 1 to 6
		move.b	(a0)+,d0	; for example, $11 will be turned into $66
		ror.w	#1,d0
		lsr.b	#3,d0
		rol.w	#1,d0
		move.b	.1bpp(pc,d0.w),d2
		lsl.w	#8,d2
		moveq	#0,d0
		move.b	(a0)+,d0
		ror.w	#1,d0
		lsr.b	#3,d0
		rol.w	#1,d0
		move.b	.1bpp(pc,d0.w),d2
		move.w	d2,(vdp_data_port).l
		dbf	d1,sub_3326
		rts
; ---------------------------------------------------------------------------

.1bpp:		dc.b 0, 6, $60, $66
; ---------------------------------------------------------------------------

oscInit:
		lea	(oscValues).w,a1
		lea	(oscInitTable).l,a2
		moveq	#$20,d1

loc_336C:
		move.w	(a2)+,(a1)+
		dbf	d1,loc_336C
		rts
; ---------------------------------------------------------------------------

oscInitTable:	dc.w $7C, $80, 0, $80, 0, $80, 0, $80, 0, $80, 0, $80
		dc.w 0, $80, 0, $80, 0, $80, 0, $50F0, $11E, $2080, $B4
		dc.w $3080, $10E, $5080, $1C2, $7080, $276, $80, 0, $80
		dc.w 0
; ---------------------------------------------------------------------------

oscUpdate:
		;cmpi.b	#6,(v_objspace+$24).w
		;bcc.s	locret_340C
		lea	(oscValues).w,a1
		lea	(oscUpdateTable).l,a2
		move.w	(a1)+,d3
		moveq	#$F,d1

loc_33CC:
		move.w	(a2)+,d2
		move.w	(a2)+,d4
		btst	d1,d3
		bne.s	loc_33EC
		move.w	2(a1),d0
		add.w	d2,d0
		move.w	d0,2(a1)
		add.w	d0,0(a1)
		cmp.b	0(a1),d4
		bhi.s	loc_3402
		bset	d1,d3
		bra.s	loc_3402
; ---------------------------------------------------------------------------

loc_33EC:
		move.w	2(a1),d0
		sub.w	d2,d0
		move.w	d0,2(a1)
		add.w	d0,0(a1)
		cmp.b	0(a1),d4
		bls.s	loc_3402
		bclr	d1,d3

loc_3402:
		addq.w	#4,a1
		dbf	d1,loc_33CC
		move.w	d3,(oscValues).w

locret_340C:
		rts
; ---------------------------------------------------------------------------

oscUpdateTable:	dc.w 2, $10
		dc.w 2, $18
		dc.w 2, $20
		dc.w 2, $30
		dc.w 4, $20
		dc.w 8, 8
		dc.w 8, $40
		dc.w 4, $40
		dc.w 2, $50
		dc.w 2, $50
		dc.w 2, $20
		dc.w 3, $30
		dc.w 5, $50
		dc.w 7, $70
		dc.w 2, $10
		dc.w 2, $10
; ---------------------------------------------------------------------------

UpdateTimers:
		subq.b	#1,(unk_FFFEC0).w
		bpl.s	loc_3464
		move.b	#$B,(unk_FFFEC0).w
		subq.b	#1,(unk_FFFEC1).w
		andi.b	#7,(unk_FFFEC1).w

loc_3464:
		subq.b	#1,(RingTimer).w
		bpl.s	loc_347A
		move.b	#7,(RingTimer).w
		addq.b	#1,(RingFrame).w
		andi.b	#3,(RingFrame).w

loc_347A:
		subq.b	#1,(unk_FFFEC4).w
		bpl.s	loc_3498
		move.b	#7,(unk_FFFEC4).w
		addq.b	#1,(unk_FFFEC5).w
		cmpi.b	#6,(unk_FFFEC5).w
		bcs.s	loc_3498
		move.b	#0,(unk_FFFEC5).w

loc_3498:
		tst.b	(RingLossTimer).w
		beq.s	locret_34BA
		moveq	#0,d0
		move.b	(RingLossTimer).w,d0
		add.w	(RingLossAccumulator).w,d0
		move.w	d0,(RingLossAccumulator).w
		rol.w	#7,d0
		andi.w	#3,d0
		move.b	d0,(RingLossFrame).w
		subq.b	#1,(RingLossTimer).w

locret_34BA:
		rts
; ---------------------------------------------------------------------------

LoadSignpostPLC:
		;tst.w	(DebugRoutine).w
		;bne.w	locret_34FA
		;cmpi.w	#$202,(v_zone).w
		;beq.s	loc_34D4
		;cmpi.b	#2,(v_act).w
		;beq.s	locret_34FA

;loc_34D4:
		move.w	(v_screenposx).w,d0
		move.w	(unk_FFF72A).w,d1
		subi.w	#$100,d1
		cmp.w	d1,d0
		blt.s	locret_34FA
		;tst.b	(f_timecount).w
		;beq.s	locret_34FA
		cmp.w	(unk_FFF728).w,d1
		beq.s	locret_34FA
		move.w	d1,(unk_FFF728).w
		moveq	#$12,d0
		bra.w	plcReplace
; ---------------------------------------------------------------------------

locret_34FA:
		rts
; ---------------------------------------------------------------------------

GM_Special:
		bsr.w	PaletteFadeOut
		move.w	(v_vdp_buffer1).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	sub_10A6
		lea	(vdp_control_port).l,a5
		move.w	#$8F01,(a5)
		move.l	#$946F93FF,(a5)
		move.w	#$9780,(a5)
		move.l	#$50000081,(a5)
		move.w	#0,(vdp_data_port).l

loc_3534:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	loc_3534
		move.w	#$8F02,(a5)
		moveq	#$14,d0
		bsr.w	sub_14E2
		bsr.w	ssLoadBG
		lea	(v_objspace).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1

loc_3554:
		move.l	d0,(a1)+
		dbf	d1,loc_3554
		lea	(v_screenposx).w,a1
		moveq	#0,d0
		move.w	#$3F,d1

loc_3564:
		move.l	d0,(a1)+
		dbf	d1,loc_3564
		lea	((oscValues+2)).w,a1
		moveq	#0,d0
		move.w	#$27,d1

loc_3574:
		move.l	d0,(a1)+
		dbf	d1,loc_3574
		lea	(v_ngfx_buffer).w,a1
		moveq	#0,d0
		move.w	#$7F,d1

loc_3584:
		move.l	d0,(a1)+
		dbf	d1,loc_3584
		moveq	#$A,d0
		bsr.w	PalLoad1
		jsr	(SS_Load).l
		move.l	#0,(v_screenposx).w
		move.l	#0,(v_screenposy).w
		move.b	#9,(v_objspace).w
		move.w	#$458,(v_objspace+8).w
		move.w	#$4A0,(v_objspace+$C).w
		lea	(vdp_control_port).l,a6
		move.w	#$8B03,(a6)
		move.w	#$8004,(a6)
		move.w	#$8AAF,(v_hbla_hreg).w
		move.w	#$9011,(a6)
		bsr.w	GM_SpecialPalCyc
		clr.w	(unk_FFF780).w
		move.w	#$40,(unk_FFF782).w
		move.w	#$89,d0
		bsr.w	PlaySFX
		move.w	#0,(unk_FFF790).w
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	PaletteWhiteIn

loc_3620:
		bsr.w	PauseGame
		move.b	#$A,(VBlankRoutine).w
		bsr.w	WaitForVBla
		bsr.w	DemoPlayback
		move.w	(v_jpadhold1).w,(v_jpadhold2).w
		bsr.w	RunObjects
		bsr.w	ProcessMaps
		jsr	(GM_Special_ShowLayout).l
		bsr.w	GM_SpecialAnimateBG
		tst.w	(DemoMode).w
		beq.s	loc_3656
		tst.w	(v_demolength).w
		beq.s	loc_3662

loc_3656:
		cmpi.b	#$10,(v_gamemode).w
		beq.w	loc_3620
		rts
; ---------------------------------------------------------------------------

loc_3662:
		move.b	#0,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

ssLoadBG:
		lea	($FF0000).l,a1
		lea	(byte_639B8).l,a0
		move.w	#$4051,d0
		bsr.w	EniDec
		move.l	#$50000001,d3
		lea	($FF0080).l,a2
		moveq	#6,d7

loc_368C:
		move.l	d3,d0
		moveq	#3,d6
		moveq	#0,d4
		cmpi.w	#3,d7
		bcc.s	loc_369A
		moveq	#1,d4

loc_369A:
		moveq	#7,d5

loc_369C:
		movea.l	a2,a1
		eori.b	#1,d4
		bne.s	loc_36B0
		cmpi.w	#6,d7
		bne.s	loc_36C0
		lea	($FF0000).l,a1

loc_36B0:
		movem.l	d0-d4,-(sp)
		moveq	#7,d1
		moveq	#7,d2
		bsr.w	TilemapToVRAM
		movem.l	(sp)+,d0-d4

loc_36C0:
		addi.l	#$100000,d0
		dbf	d5,loc_369C
		addi.l	#$3800000,d0
		eori.b	#1,d4
		dbf	d6,loc_369A
		addi.l	#$10000000,d3
		bpl.s	loc_36EA
		swap	d3
		addi.l	#$C000,d3
		swap	d3

loc_36EA:
		adda.w	#$80,a2
		dbf	d7,loc_368C
		lea	($FF0000).l,a1
		lea	(byte_6477C).l,a0
		move.w	#$4000,d0
		bsr.w	EniDec
		copyTilemap	$FF0000,$C000,$3F,$1F
		copyTilemap	$FF0000,$D000,$3F,$3F
		rts
; ---------------------------------------------------------------------------

GM_SpecialPalCyc:
		tst.w	(f_pause).w
		bmi.s	locret_37B4
		subq.w	#1,(unk_FFF79C).w
		bpl.s	locret_37B4
		lea	(vdp_control_port).l,a6
		move.w	(unk_FFF79A).w,d0
		addq.w	#1,(unk_FFF79A).w
		andi.w	#$1F,d0
		lsl.w	#2,d0
		lea	(byte_380A).l,a0
		adda.w	d0,a0
		move.b	(a0)+,d0
		bpl.s	loc_3760
		move.w	#$1FF,d0

loc_3760:
		move.w	d0,(unk_FFF79C).w
		moveq	#0,d0
		move.b	(a0)+,d0
		move.w	d0,(unk_FFF7A0).w
		lea	(byte_388A).l,a1
		lea	(a1,d0.w),a1
		move.w	#$8200,d0
		move.b	(a1)+,d0
		move.w	d0,(a6)
		move.b	(a1),(v_scrposy_dup).w
		move.w	#$8400,d0
		move.b	(a0)+,d0
		move.w	d0,(a6)
		move.l	#$40000010,(vdp_control_port).l
		move.l	(v_scrposy_dup).w,(vdp_data_port).l
		moveq	#0,d0
		move.b	(a0)+,d0
		bmi.s	loc_37B6
		lea	(dword_3898).l,a1
		adda.w	d0,a1
		lea	(v_pal_dry+$4E).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+

locret_37B4:
		rts
; ---------------------------------------------------------------------------

loc_37B6:
		move.w	(unk_FFF79E).w,d1
		cmpi.w	#$8A,d0
		bcs.s	loc_37C2
		addq.w	#1,d1

loc_37C2:
		mulu.w	#$2A,d1
		lea	(word_38E0).l,a1
		adda.w	d1,a1
		andi.w	#$7F,d0
		bclr	#0,d0
		beq.s	loc_37E6
		lea	(v_pal_dry+$6E).w,a2
		move.l	(a1),(a2)+
		move.l	4(a1),(a2)+
		move.l	8(a1),(a2)+

loc_37E6:
		adda.w	#$C,a1
		lea	(v_pal_dry+$5A).w,a2
		cmpi.w	#$A,d0
		bcs.s	loc_37FC
		subi.w	#$A,d0
		lea	(v_pal_dry+$7A).w,a2

loc_37FC:
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		adda.w	d0,a1
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		rts
; ---------------------------------------------------------------------------

byte_380A:	dc.b 3, 0, 7, $92, 3, 0, 7, $90, 3, 0, 7, $8E, 3, 0, 7
		dc.b $8C, 3, 0, 7, $8B, 3, 0, 7, $80, 3, 0, 7, $82, 3
		dc.b 0, 7, $84, 3, 0, 7, $86, 3, 0, 7, $88, 7, 8, 7, 0
		dc.b 7, $A, 7, $C, $FF, $C, 7, $18, $FF, $C, 7, $18, 7
		dc.b $A, 7, $C, 7, 8, 7, 0, 3, 0, 6, $88, 3, 0, 6, $86
		dc.b 3, 0, 6, $84, 3, 0, 6, $82, 3, 0, 6, $81, 3, 0, 6
		dc.b $8A, 3, 0, 6, $8C, 3, 0, 6, $8E, 3, 0, 6, $90, 3
		dc.b 0, 6, $92, 7, 2, 6, $24, 7, 4, 6, $30, $FF, 6, 6
		dc.b $3C, $FF, 6, 6, $3C, 7, 4, 6, $30, 7, 2, 6, $24

byte_388A:	dc.b $10, 1, $18, 0, $18, 1, $20, 0, $20, 1, $28, 0, $28
		dc.b 1

dword_3898:	dc.l $4000600, $6200624, $6640666, $6000820, $A640A68
		dc.l $AA60AAA, $8000C42, $E860ECA, $EEC0EEE, $4000420
		dc.l $6200620, $8640666, $4200620, $8420842, $A860AAA
		dc.l $6200842, $A640C86, $EA80EEE

word_38E0:	incbin "palette\Cycle - SS.bin"
		even
; ---------------------------------------------------------------------------

GM_SpecialAnimateBG:
		move.w	(unk_FFF7A0).w,d0
		bne.s	loc_39C4
		move.w	#0,(v_bgscreenposy).w
		move.w	(v_bgscreenposy).w,(v_scrposy_dup+2).w

loc_39C4:
		cmpi.w	#8,d0
		bcc.s	loc_3A1C
		cmpi.w	#6,d0
		bne.s	loc_39DE
		addq.w	#1,(v_bg3screenposx).w
		addq.w	#1,(v_bgscreenposy).w
		move.w	(v_bgscreenposy).w,(v_scrposy_dup+2).w

loc_39DE:
		moveq	#0,d0
		move.w	(v_bgscreenposx).w,d0
		neg.w	d0
		swap	d0
		lea	(byte_3A9A).l,a1
		lea	(v_ngfx_buffer).w,a3
		moveq	#9,d3

loc_39F4:
		move.w	2(a3),d0
		bsr.w	GetSine
		moveq	#0,d2
		move.b	(a1)+,d2
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,(a3)+
		move.b	(a1)+,d2
		ext.w	d2
		add.w	d2,(a3)+
		dbf	d3,loc_39F4
		lea	(v_ngfx_buffer).w,a3
		lea	(byte_3A86).l,a2
		bra.s	loc_3A4C
; ---------------------------------------------------------------------------

loc_3A1C:
		cmpi.w	#$C,d0
		bne.s	loc_3A42
		subq.w	#1,(v_bg3screenposx).w
		lea	($FFFFAB00).w,a3
		move.l	#$18000,d2
		moveq	#6,d1

loc_3A32:
		move.l	(a3),d0
		sub.l	d2,d0
		move.l	d0,(a3)+
		subi.l	#$2000,d2
		dbf	d1,loc_3A32

loc_3A42:
		lea	($FFFFAB00).w,a3
		lea	(byte_3A92).l,a2

loc_3A4C:
		lea	(v_hscrolltablebuffer).w,a1
		move.w	(v_bg3screenposx).w,d0
		neg.w	d0
		swap	d0
		moveq	#0,d3
		move.b	(a2)+,d3
		move.w	(v_bgscreenposy).w,d2
		neg.w	d2
		andi.w	#$FF,d2
		lsl.w	#2,d2

loc_3A68:
		move.w	(a3)+,d0
		addq.w	#2,a3
		moveq	#0,d1
		move.b	(a2)+,d1
		subq.w	#1,d1

loc_3A72:
		move.l	d0,(a1,d2.w)
		addq.w	#4,d2
		andi.w	#$3FC,d2
		dbf	d1,loc_3A72
		dbf	d3,loc_3A68
		rts
; ---------------------------------------------------------------------------

byte_3A86:	dc.b 9, $28, $18, $10, $28, $18, $10, $30, $18, 8, $10
		dc.b 0

byte_3A92:	dc.b 6, $30, $30, $30, $28, $18, $18, $18

byte_3A9A:	dc.b 8, 2, 4, $FF, 2, 3, 8, $FF, 4, 2, 2, 3, 8, $FD, 4
		dc.b 2, 2, 3, 2, $FF
; ---------------------------------------------------------------------------

		include "_inc\LevelSizeLoad & BgScrollSpeed.asm"
		include "_inc\DeformLayers.asm"

; ---------------------------------------------------------------------------

sub_43B6:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(unk_FFF756).w,a2
		lea	(v_bgscreenposx).w,a3
		lea	(v_lvllayout+$40).w,a4
		move.w	#$6000,d2
		bsr.w	sub_4484
		lea	(unk_FFF758).w,a2
		lea	(v_bg2screenposx).w,a3
		bra.w	sub_4524
; ---------------------------------------------------------------------------

mapLevelLoad:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(unk_FFF756).w,a2
		lea	(v_bgscreenposx).w,a3
		lea	(v_lvllayout+$40).w,a4
		move.w	#$6000,d2
		bsr.w	sub_4484
		lea	(unk_FFF758).w,a2
		lea	(v_bg2screenposx).w,a3
		bsr.w	sub_4524
		lea	(unk_FFF754).w,a2
		lea	(v_screenposx).w,a3
		lea	(v_lvllayout).w,a4
		move.w	#$4000,d2
		tst.b	(a2)
		beq.s	locret_4482
		bclr	#0,(a2)
		beq.s	loc_4438
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4752
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4608

loc_4438:
		bclr	#1,(a2)
		beq.s	loc_4452
		move.w	#$E0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4752
		move.w	#$E0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4608

loc_4452:
		bclr	#2,(a2)
		beq.s	loc_4468
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4752
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4634

loc_4468:
		bclr	#3,(a2)
		beq.s	locret_4482
		moveq	#$FFFFFFF0,d4
		move.w	#$140,d5
		bsr.w	sub_4752
		moveq	#$FFFFFFF0,d4
		move.w	#$140,d5
		bsr.w	sub_4634

locret_4482:
		rts
; ---------------------------------------------------------------------------

sub_4484:
		tst.b	(a2)
		beq.w	locret_4522
		bclr	#0,(a2)
		beq.s	loc_44A2
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4752
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		moveq	#$1F,d6
		bsr.w	sub_460A

loc_44A2:
		bclr	#1,(a2)
		beq.s	loc_44BE
		move.w	#$E0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4752
		move.w	#$E0,d4
		moveq	#$FFFFFFF0,d5
		moveq	#$1F,d6
		bsr.w	sub_460A

loc_44BE:
		bclr	#2,(a2)
		beq.s	loc_44EE
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4752
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		move.w	(unk_FFF7F0).w,d6
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d6
		blt.s	loc_44EE
		lsr.w	#4,d6
		cmpi.w	#$F,d6
		bcs.s	loc_44EA
		moveq	#$F,d6

loc_44EA:
		bsr.w	sub_4636

loc_44EE:
		bclr	#3,(a2)
		beq.s	locret_4522
		moveq	#$FFFFFFF0,d4
		move.w	#$140,d5
		bsr.w	sub_4752
		moveq	#$FFFFFFF0,d4
		move.w	#$140,d5
		move.w	(unk_FFF7F0).w,d6
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d6
		blt.s	locret_4522
		lsr.w	#4,d6
		cmpi.w	#$F,d6
		bcs.s	loc_451E
		moveq	#$F,d6

loc_451E:
		bsr.w	sub_4636

locret_4522:
		rts
; ---------------------------------------------------------------------------

sub_4524:
		tst.b	(a2)
		beq.w	locret_45B0
		bclr	#2,(a2)
		beq.s	loc_456E
		cmpi.w	#$10,(a3)
		bcs.s	loc_456E
		move.w	(unk_FFF7F0).w,d4
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4752
		move.w	(sp)+,d4
		moveq	#$FFFFFFF0,d5
		move.w	(unk_FFF7F0).w,d6
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d6
		blt.s	loc_456E
		lsr.w	#4,d6
		subi.w	#$E,d6
		bcc.s	loc_456E
		neg.w	d6
		bsr.w	sub_4636

loc_456E:
		bclr	#3,(a2)
		beq.s	locret_45B0
		move.w	(unk_FFF7F0).w,d4
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		move.w	#$140,d5
		bsr.w	sub_4752
		move.w	(sp)+,d4
		move.w	#$140,d5
		move.w	(unk_FFF7F0).w,d6
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d6
		blt.s	locret_45B0
		lsr.w	#4,d6
		subi.w	#$E,d6
		bcc.s	locret_45B0
		neg.w	d6
		bsr.w	sub_4636

locret_45B0:
		rts
; ---------------------------------------------------------------------------
		tst.b	(a2)
		beq.s	locret_4606
		bclr	#2,(a2)
		beq.s	loc_45DC
		move.w	#$D0,d4
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_476E
		move.w	(sp)+,d4
		moveq	#$FFFFFFF0,d5
		moveq	#2,d6
		bsr.w	sub_4636

loc_45DC:
		bclr	#3,(a2)
		beq.s	locret_4606
		move.w	#$D0,d4
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		move.w	#$140,d5
		bsr.w	sub_476E
		move.w	(sp)+,d4
		move.w	#$140,d5
		moveq	#2,d6
		bsr.w	sub_4636

locret_4606:
		rts
; ---------------------------------------------------------------------------

sub_4608:
		moveq	#$15,d6
; ---------------------------------------------------------------------------

sub_460A:
		move.l	#$800000,d7
		move.l	d0,d1

loc_4612:
		movem.l	d4-d5,-(sp)
		bsr.w	sub_4706
		move.l	d1,d0
		bsr.w	sub_4662
		addq.b	#4,d1
		andi.b	#$7F,d1
		movem.l	(sp)+,d4-d5
		addi.w	#$10,d5
		dbf	d6,loc_4612
		rts
; ---------------------------------------------------------------------------

sub_4634:
		moveq	#$F,d6
; ---------------------------------------------------------------------------

sub_4636:
		move.l	#$800000,d7
		move.l	d0,d1

loc_463E:
		movem.l	d4-d5,-(sp)
		bsr.w	sub_4706
		move.l	d1,d0
		bsr.w	sub_4662
		addi.w	#$100,d1
		andi.w	#$FFF,d1
		movem.l	(sp)+,d4-d5
		addi.w	#$10,d4
		dbf	d6,loc_463E
		rts
; ---------------------------------------------------------------------------

sub_4662:
		or.w	d2,d0
		swap	d0
		btst	#4,(a0)
		bne.s	loc_469E
		btst	#3,(a0)
		bne.s	loc_467E
		move.l	d0,(a5)
		move.l	(a1)+,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		move.l	(a1)+,(a6)
		rts
; ---------------------------------------------------------------------------

loc_467E:
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4
		swap	d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4
		swap	d4
		move.l	d4,(a6)
		rts
; ---------------------------------------------------------------------------

loc_469E:
		btst	#3,(a0)
		bne.s	loc_46C0
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d4
		eori.l	#$10001000,d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$10001000,d5
		move.l	d5,(a6)
		rts
; ---------------------------------------------------------------------------

loc_46C0:
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d4
		eori.l	#$18001800,d4
		swap	d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$18001800,d5
		swap	d5
		move.l	d5,(a6)
		rts
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------
		move.l	d0,(a5)
		move.w	#$2000,d5
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		rts
; ---------------------------------------------------------------------------

sub_4706:
		lea	(v_16x16).w,a1
		add.w	4(a3),d4
		add.w	(a3),d5
		move.w	d4,d3
		lsr.w	#1,d3
		andi.w	#$380,d3
		lsr.w	#3,d5
		move.w	d5,d0
		lsr.w	#5,d0
		andi.w	#$7F,d0
		add.w	d3,d0
		moveq	#$FFFFFFFF,d3
		move.b	(a4,d0.w),d3
		andi.b	#$7F,d3
		beq.s	locret_4750
		subq.b	#1,d3
		ext.w	d3
		ror.w	#7,d3
		add.w	d4,d4
		andi.w	#$1E0,d4
		andi.w	#$1E,d5
		add.w	d4,d3
		add.w	d5,d3
		movea.l	d3,a0
		move.w	(a0),d3
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		adda.w	d3,a1

locret_4750:
		rts
; ---------------------------------------------------------------------------

sub_4752:
		add.w	4(a3),d4
		add.w	(a3),d5
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#3,d0
		swap	d0
		move.w	d4,d0
		rts
; ---------------------------------------------------------------------------

sub_476E:
		add.w	4(a3),d4
		add.w	(a3),d5
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#2,d0
		swap	d0
		move.w	d4,d0
		rts
; ---------------------------------------------------------------------------

mapLevelLoadFull:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_screenposx).w,a3
		lea	(v_lvllayout).w,a4
		move.w	#$4000,d2
		bsr.s	sub_47B0
		lea	(v_bgscreenposx).w,a3
		lea	(v_lvllayout+$40).w,a4
		move.w	#$6000,d2
; ---------------------------------------------------------------------------

sub_47B0:
		moveq	#$FFFFFFF0,d4
		moveq	#$F,d6

loc_47B4:
		movem.l	d4-d6,-(sp)
		moveq	#0,d5
		move.w	d4,d1
		bsr.w	sub_4752
		move.w	d1,d4
		moveq	#0,d5
		moveq	#$1F,d6
		bsr.w	sub_460A
		movem.l	(sp)+,d4-d6
		addi.w	#$10,d4
		dbf	d6,loc_47B4
		rts
; ---------------------------------------------------------------------------
		lea	(v_bg3screenposx).w,a3
		move.w	#$6000,d2
		move.w	#$B0,d4
		moveq	#2,d6

loc_47E6:
		movem.l	d4-d6,-(sp)
		moveq	#0,d5
		move.w	d4,d1
		bsr.w	sub_476E
		move.w	d1,d4
		moveq	#0,d5
		moveq	#$1F,d6
		bsr.w	sub_460A
		movem.l	(sp)+,d4-d6
		addi.w	#$10,d4
		dbf	d6,loc_47E6
		rts
; ---------------------------------------------------------------------------

LoadLevelData:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#4,d0
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2
		move.l	a2,-(sp)
		addq.l	#4,a2
		movea.l	(a2)+,a0
		lea	(v_16x16).w,a4
		move.w	#$5FF,d0

.loadblocks:
		move.l	(a0)+,(a4)+
		dbf	d0,.loadblocks
		movea.l	(a2)+,a0
		lea	(v_256x256&$FFFFFF).l,a1
		bsr.w	KosDec
		bsr.w	LoadLayout
		move.w	(a2)+,d0
		move.w	(a2),d0
		andi.w	#$FF,d0
		bsr.w	PalLoad1
		movea.l	(sp)+,a2
		addq.w	#4,a2
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	locret_485A
		bsr.w	plcAdd

locret_485A:
		rts
; ---------------------------------------------------------------------------
sub_485C:
		moveq	#0,d0
		move.b	(v_lives).w,d1
		cmpi.b	#2,d1
		bcs.s	loc_4876
		move.b	d1,d0
		subq.b	#1,d0
		cmpi.b	#5,d0
		bcs.s	loc_4876
		move.b	#4,d0

loc_4876:
		lea	(vdp_data_port).l,a6
		move.l	#$6CBE0002,(vdp_control_port).l
		move.l	#$8579857A,d2
		bsr.s	sub_489E
		move.l	#$6D3E0002,(vdp_control_port).l
		move.l	#$857B857C,d2
; ---------------------------------------------------------------------------

sub_489E:
		moveq	#0,d3
		moveq	#3,d1
		sub.w	d0,d1
		bcs.s	loc_48AC

loc_48A6:
		move.l	d3,(a6)
		dbf	d1,loc_48A6

loc_48AC:
		move.w	d0,d1
		subq.w	#1,d1
		bcs.s	locret_48B8

loc_48B2:
		move.l	d2,(a6)
		dbf	d1,loc_48B2

locret_48B8:
		rts
; ---------------------------------------------------------------------------

LoadLayout:
		lea	(v_lvllayout).w,a3
		move.w	#$1FF,d1
		moveq	#0,d0

loc_48C4:
		move.l	d0,(a3)+
		dbf	d1,loc_48C4
		lea	(v_lvllayout).w,a3
		moveq	#0,d1
		bsr.w	sub_48DA
		lea	(v_lvllayout+$40).w,a3
		moveq	#2,d1
; ---------------------------------------------------------------------------

sub_48DA:
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#5,d0
		move.w	d0,d2
		add.w	d0,d0
		add.w	d2,d0
		add.w	d1,d0
		lea	(LayoutArray).l,a1
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		moveq	#0,d1
		move.w	d1,d2
		move.b	(a1)+,d1
		move.b	(a1)+,d2

loc_4900:
		move.w	d1,d0
		movea.l	a3,a0

loc_4904:
		move.b	(a1)+,(a0)+
		dbf	d0,loc_4904
		lea	$80(a3),a3
		dbf	d2,loc_4900
		rts
; ---------------------------------------------------------------------------

		include "_inc\DynamicLevelEvents.asm"

                include "_incObj\02.asm"
		include "_maps\02.asm"

                include "_incObj\03.asm"
                include "_incObj\04.asm"
                include "_incObj\05.asm"
		include "_maps\05.asm"

                include "_incObj\06.asm"
                include "_incObj\07.asm"
                include "_incObj\11 Bridge (part 1).asm"
; ---------------------------------------------------------------------------

PtfmBridge:
		moveq	#0,d1
		move.b	arg(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		add.w	d2,d2
		lea	(v_objspace).w,a1
		tst.w	yvel(a1)
		bmi.w	locret_5048
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.w	locret_5048
		cmp.w	d2,d0
		bcc.w	locret_5048
		bra.s	PtfmNormal2
; ---------------------------------------------------------------------------

PtfmNormal:
		lea	(v_objspace).w,a1
		tst.w	yvel(a1)
		bmi.w	locret_5048
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.w	locret_5048
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.w	locret_5048

PtfmNormal2:
		move.w	ypos(a0),d0
		subq.w	#8,d0

PtfmNormal3:
		move.w	ypos(a1),d2
		move.b	yrad(a1),d1
		ext.w	d1
		add.w	d2,d1
		addq.w	#4,d1
		sub.w	d1,d0
		bhi.w	locret_5048
		cmpi.w	#$FFF0,d0
		bcs.w	locret_5048
		cmpi.b	#6,act(a1)
		bcc.w	locret_5048
		add.w	d0,d2
		addq.w	#3,d2
		move.w	d2,ypos(a1)
		addq.b	#2,act(a0)

; Solid_ResetFloor
loc_4FD4:
		btst	#3,status(a1)
		beq.s	loc_4FFC
		moveq	#0,d0
		move.b	platform(a1),d0
		lsl.w	#6,d0
		addi.l	#(v_objspace)&$FFFFFF,d0
		movea.l	d0,a2
		cmpi.b	#4,act(a2)
		bne.s	loc_4FFC
		subq.b	#2,act(a2)
		clr.b	subact(a2)

loc_4FFC:
		move.w	a0,d0
		subi.w	#v_objspace,d0
		lsr.w	#6,d0
		andi.w	#$7F,d0
		move.b	d0,platform(a1)
		move.b	#0,angle(a1)
		move.w	#0,yvel(a1)
		move.w	xvel(a1),d0
		;asr.w	#2,d0 ; fuck you
		;sub.w	d0,xvel(a1) ; fuck you
		;move.w	xvel(a1),inertia(a1) ; fuck you
		btst	#1,status(a1)
		beq.s	loc_503C
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	(Sonic_ResetOnFloor).l
		movea.l	(sp)+,a0

loc_503C:
		bset	#3,status(a1)
		bset	#3,status(a0)

locret_5048:
		rts
; ---------------------------------------------------------------------------

PtfmSloped:
		lea	(v_objspace).w,a1
		tst.w	yvel(a1)
		bmi.w	locret_5048
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.s	locret_5048
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.s	locret_5048
		btst	#0,render(a0)
		beq.s	loc_5074
		not.w	d0
		add.w	d1,d0

loc_5074:
		lsr.w	#1,d0
		moveq	#0,d3
		move.b	(a2,d0.w),d3
		move.w	ypos(a0),d0
		sub.w	d3,d0
		bra.w	PtfmNormal3
; ---------------------------------------------------------------------------

PtfmNormalHeight:
		lea	(v_objspace).w,a1
		tst.w	yvel(a1)
		bmi.w	locret_5048
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.w	locret_5048
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.w	locret_5048
		move.w	ypos(a0),d0
		sub.w	d3,d0
		bra.w	PtfmNormal3
		
		include "_incObj\11 Bridge (part 2).asm"
; ---------------------------------------------------------------------------

PtfmCheckExit:
		move.w	d1,d2
; ---------------------------------------------------------------------------

PtfmCheckExit2:
		add.w	d2,d2
		lea	(v_objspace).w,a1
		btst	#1,status(a1)
		bne.s	loc_510A
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.s	loc_510A
		cmp.w	d2,d0
		bcs.s	locret_511C

loc_510A:
		bclr	#3,status(a1)
		move.b	#2,act(a0)
		bclr	#3,status(a0)

locret_511C:
		rts

                include "_incObj\11 Bridge (part 3).asm"
MapBridge:      include "_maps\Bridge.asm"

		include "_incObj\15 Swinging Platform.asm"
MapSwingPtfm:	include "_maps\Swinging Platforms (GHZ).asm"
MapSwingPtfmSZ: include "_maps\Swinging Platforms (SZ).asm"
; ---------------------------------------------------------------------------

ObjSpikeLogs:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_5788(pc,d0.w),d1
		jmp	off_5788(pc,d1.w)
; ---------------------------------------------------------------------------

off_5788:	dc.w loc_5792-off_5788, loc_5854-off_5788, loc_5854-off_5788, loc_58C2-off_5788, loc_58C8-off_5788
; ---------------------------------------------------------------------------

loc_5792:
		addq.b	#2,$24(a0)
		move.l	#MapSpikeLogs,4(a0)
		move.w	#$4398,2(a0)
		move.b	#7,$22(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#8,$18(a0)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		move.b	0(a0),d4
		lea	$28(a0),a2
		moveq	#0,d1
		move.b	(a2),d1
		move.b	#0,(a2)+
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3
		subq.b	#2,d1
		bcs.s	loc_5854
		moveq	#0,d6

loc_57E2:
		bsr.w	ObjectLoad
		bne.s	loc_5854
		addq.b	#1,$28(a0)
		move.w	a1,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+

loc_57FA:
		move.b	#8,$24(a1)
		move.b	d4,0(a1)
		move.w	d2,$C(a1)
		move.w	d3,8(a1)
		move.l	4(a0),4(a1)
		move.w	#$4398,2(a1)
		move.b	#4,1(a1)
		move.b	#3,$19(a1)
		move.b	#8,$18(a1)
		move.b	d6,$3E(a1)
		addq.b	#1,d6
		andi.b	#7,d6
		addi.w	#$10,d3
		cmp.w	8(a0),d3
		bne.s	loc_5850
		move.b	d6,$3E(a0)
		addq.b	#1,d6
		andi.b	#7,d6
		addi.w	#$10,d3
		addq.b	#1,$28(a0)

loc_5850:
		dbf	d1,loc_57E2

loc_5854:
		bsr.w	sub_5860
		bsr.w	DisplaySprite
		bra.w	loc_5880
; ---------------------------------------------------------------------------

sub_5860:
		move.b	(unk_FFFEC1).w,d0
		move.b	#0,$20(a0)
		add.b	$3E(a0),d0
		andi.b	#7,d0
		move.b	d0,$1A(a0)
		bne.s	locret_587E
		move.b	#$84,$20(a0)

locret_587E:
		rts
; ---------------------------------------------------------------------------

loc_5880:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	loc_58A0
		rts
; ---------------------------------------------------------------------------

loc_58A0:
		moveq	#0,d2
		lea	$28(a0),a2
		move.b	(a2)+,d2
		subq.b	#2,d2
		bcs.s	loc_58C2

loc_58AC:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#(v_objspace)&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	ObjectDeleteA1
		dbf	d2,loc_58AC

loc_58C2:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_58C8:
		bsr.w	sub_5860
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
		include "levels\GHZ\SpikeLogs\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjPlatform:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_5918(pc,d0.w),d1
		jmp	off_5918(pc,d1.w)
; ---------------------------------------------------------------------------

off_5918:	dc.w loc_5922-off_5918, loc_59AE-off_5918, loc_59D2-off_5918, loc_5BCE-off_5918, loc_59C2-off_5918
; ---------------------------------------------------------------------------

loc_5922:
		addq.b	#2,$24(a0)
		move.w	#$4000,2(a0)
		move.l	#MapPlatform1,4(a0)
		move.b	#$20,$18(a0)
		cmpi.b	#4,(v_zone).w
		bne.s	loc_5972
		move.l	#MapPlatform2,4(a0)
		move.b	#$20,$18(a0)

loc_5972:
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.w	$C(a0),$2C(a0)
		move.w	$C(a0),$34(a0)
		move.w	8(a0),$32(a0)
		move.w	#$80,$26(a0)
		moveq	#0,d1
		move.b	$28(a0),d0
		cmpi.b	#$A,d0
		bne.s	loc_59AA
		addq.b	#1,d1
		move.b	#$20,$18(a0)

loc_59AA:
		move.b	d1,$1A(a0)

loc_59AE:
		tst.b	$38(a0)
		beq.s	loc_59B8
		subq.b	#4,$38(a0)

loc_59B8:
		moveq	#0,d1
		move.b	$18(a0),d1
		bsr.w	PtfmNormal

loc_59C2:
		bsr.w	sub_5A1E
		bsr.w	sub_5A04
		bsr.w	DisplaySprite
		bra.w	loc_5BB0
; ---------------------------------------------------------------------------

loc_59D2:
		cmpi.b	#$40,$38(a0)
		beq.s	loc_59DE
		addq.b	#4,$38(a0)

loc_59DE:
		moveq	#0,d1
		move.b	$18(a0),d1
		bsr.w	PtfmCheckExit
		move.w	8(a0),-(sp)
		bsr.w	sub_5A1E
		bsr.w	sub_5A04
		move.w	(sp)+,d2
		bsr.w	ptfmSurfaceNormal
		bsr.w	DisplaySprite
		bra.w	loc_5BB0
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

sub_5A04:
		move.b	$38(a0),d0
		bsr.w	GetSine
		move.w	#$400,d1
		muls.w	d1,d0
		swap	d0
		add.w	$2C(a0),d0
		move.w	d0,$C(a0)
		rts
; ---------------------------------------------------------------------------

sub_5A1E:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_5A32(pc,d0.w),d1
		jmp	off_5A32(pc,d1.w)
; ---------------------------------------------------------------------------

off_5A32:	dc.w locret_5A4C-off_5A32, loc_5A5E-off_5A32, loc_5AA4-off_5A32, loc_5ABC-off_5A32, loc_5AE4-off_5A32
		dc.w loc_5A4E-off_5A32, loc_5A94-off_5A32, loc_5B4E-off_5A32, loc_5B7A-off_5A32, locret_5A4C-off_5A32
		dc.w loc_5B92-off_5A32, loc_5A86-off_5A32, loc_5A76-off_5A32
; ---------------------------------------------------------------------------

locret_5A4C:
		rts
; ---------------------------------------------------------------------------

loc_5A4E:
		move.w	$32(a0),d0
		move.b	$26(a0),d1
		neg.b	d1
		addi.b	#$40,d1
		bra.s	loc_5A6A
; ---------------------------------------------------------------------------

loc_5A5E:
		move.w	$32(a0),d0
		move.b	$26(a0),d1
		subi.b	#$40,d1

loc_5A6A:
		ext.w	d1
		add.w	d1,d0
		move.w	d0,8(a0)
		bra.w	loc_5BA8
; ---------------------------------------------------------------------------

loc_5A76:
		move.w	$34(a0),d0
		move.b	(oscValues+$E).w,d1
		neg.b	d1
		addi.b	#$30,d1
		bra.s	loc_5AB0
; ---------------------------------------------------------------------------

loc_5A86:
		move.w	$34(a0),d0
		move.b	(oscValues+$E).w,d1
		subi.b	#$30,d1
		bra.s	loc_5AB0
; ---------------------------------------------------------------------------

loc_5A94:
		move.w	$34(a0),d0
		move.b	$26(a0),d1
		neg.b	d1
		addi.b	#$40,d1
		bra.s	loc_5AB0
; ---------------------------------------------------------------------------

loc_5AA4:
		move.w	$34(a0),d0
		move.b	$26(a0),d1
		subi.b	#$40,d1

loc_5AB0:
		ext.w	d1
		add.w	d1,d0
		move.w	d0,$2C(a0)
		bra.w	loc_5BA8
; ---------------------------------------------------------------------------

loc_5ABC:
		tst.w	$3A(a0)
		bne.s	loc_5AD2
		btst	#3,$22(a0)
		beq.s	locret_5AD0
		move.w	#$1E,$3A(a0)

locret_5AD0:
		rts
; ---------------------------------------------------------------------------

loc_5AD2:
		subq.w	#1,$3A(a0)
		bne.s	locret_5AD0
		move.w	#$20,$3A(a0)
		addq.b	#1,$28(a0)
		rts
; ---------------------------------------------------------------------------

loc_5AE4:
		tst.w	$3A(a0)
		beq.s	loc_5B20
		subq.w	#1,$3A(a0)
		bne.s	loc_5B20
		btst	#3,$22(a0)
		beq.s	loc_5B1A
		bset	#1,$22(a1)
		bclr	#3,$22(a1)
		move.b	#2,$24(a1)
		bclr	#3,$22(a0)
		clr.b	$25(a0)
		move.w	$12(a0),$12(a1)

loc_5B1A:
		move.b	#8,$24(a0)

loc_5B20:
		move.l	$2C(a0),d3
		move.w	$12(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d3,$2C(a0)
		addi.w	#$38,$12(a0)
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$2C(a0),d0
		bcc.s	locret_5B4C
		move.b	#6,$24(a0)

locret_5B4C:
		rts
; ---------------------------------------------------------------------------

loc_5B4E:
		tst.w	$3A(a0)
		bne.s	loc_5B6E
		lea	(unk_FFF7E0).w,a2
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#4,d0
		tst.b	(a2,d0.w)
		beq.s	locret_5B6C
		move.w	#$3C,$3A(a0)

locret_5B6C:
		rts
; ---------------------------------------------------------------------------

loc_5B6E:
		subq.w	#1,$3A(a0)
		bne.s	locret_5B6C
		addq.b	#1,$28(a0)
		rts
; ---------------------------------------------------------------------------

loc_5B7A:
		subq.w	#2,$2C(a0)
		move.w	$34(a0),d0
		subi.w	#$200,d0
		cmp.w	$2C(a0),d0
		bne.s	locret_5B90
		clr.b	$28(a0)

locret_5B90:
		rts
; ---------------------------------------------------------------------------

loc_5B92:
		move.w	$34(a0),d0
		move.b	$26(a0),d1
		subi.b	#$40,d1
		ext.w	d1
		asr.w	#1,d1
		add.w	d1,d0
		move.w	d0,$2C(a0)

loc_5BA8:
		move.b	(oscValues+$1A).w,$26(a0)
		rts
; ---------------------------------------------------------------------------

loc_5BB0:
		move.w	$32(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.s	loc_5BCE
		rts
; ---------------------------------------------------------------------------

loc_5BCE:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------
		include "_maps\05BD2.asm"
		include "levels\shared\Platform\1.map"
		include "levels\shared\Platform\2.map"
		include "levels\shared\Platform\3.map"
		even
; ---------------------------------------------------------------------------

ObjRollingBall:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_5C8E(pc,d0.w),d1
		jmp	off_5C8E(pc,d1.w)
; ---------------------------------------------------------------------------

off_5C8E:	dc.w loc_5C98-off_5C8E, loc_5D2C-off_5C8E, loc_5D86-off_5C8E, loc_5E4A-off_5C8E, loc_5CEE-off_5C8E
; ---------------------------------------------------------------------------

loc_5C98:
		move.b	#$18,$16(a0)
		move.b	#$C,$17(a0)
		bsr.w	ObjectFall
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	locret_5CEC
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		move.b	#8,$24(a0)
		move.l	#MapRollingBall,4(a0)
		move.w	#$43AA,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#$18,$18(a0)
		move.b	#1,$1F(a0)
		bsr.w	sub_5DC8

locret_5CEC:
		rts
; ---------------------------------------------------------------------------

loc_5CEE:
		move.w	#$23,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		btst	#5,$22(a0)
		bne.s	loc_5D14
		move.w	(v_objspace+8).w,d0
		sub.w	8(a0),d0
		bcs.s	loc_5D20

loc_5D14:
		move.b	#2,$24(a0)
		move.w	#$80,$14(a0)

loc_5D20:
		bsr.w	sub_5DC8
		bsr.w	DisplaySprite
		bra.w	loc_5E2A
; ---------------------------------------------------------------------------

loc_5D2C:
		btst	#1,$22(a0)
		bne.w	loc_5D86
		bsr.w	sub_5DC8
		bsr.w	sub_5E50
		bsr.w	SpeedToPos
		move.w	#$23,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		jsr	(Sonic_AnglePosition).l
		cmpi.w	#$20,8(a0)
		bcc.s	loc_5D70
		move.w	#$20,8(a0)
		move.w	#$400,$14(a0)

loc_5D70:
		btst	#1,$22(a0)
		beq.s	loc_5D7E
		move.w	#$FC00,$12(a0)

loc_5D7E:
		bsr.w	DisplaySprite
		bra.w	loc_5E2A
; ---------------------------------------------------------------------------

loc_5D86:
		bsr.w	sub_5DC8
		bsr.w	SpeedToPos
		move.w	#$23,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	8(a0),d4
		bsr.w	SolidObject
		jsr	(Sonic_Floor).l
		btst	#1,$22(a0)
		beq.s	loc_5DBE
		move.w	$12(a0),d0
		addi.w	#$28,d0
		move.w	d0,$12(a0)
		bra.s	loc_5DC0
; ---------------------------------------------------------------------------

loc_5DBE:
		nop

loc_5DC0:
		bsr.w	DisplaySprite
		bra.w	loc_5E2A
; ---------------------------------------------------------------------------

sub_5DC8:
		tst.b	$1A(a0)
		beq.s	loc_5DD6
		move.b	#0,$1A(a0)
		rts
; ---------------------------------------------------------------------------

loc_5DD6:
		move.b	$14(a0),d0
		beq.s	loc_5E02
		bmi.s	loc_5E0A
		subq.b	#1,$1E(a0)
		bpl.s	loc_5E02
		neg.b	d0
		addq.b	#8,d0
		bcs.s	loc_5DEC
		moveq	#0,d0

loc_5DEC:
		move.b	d0,$1E(a0)
		move.b	$1F(a0),d0
		addq.b	#1,d0
		cmpi.b	#4,d0
		bne.s	loc_5DFE
		moveq	#1,d0

loc_5DFE:
		move.b	d0,$1F(a0)

loc_5E02:
		move.b	$1F(a0),$1A(a0)
		rts
; ---------------------------------------------------------------------------

loc_5E0A:
		subq.b	#1,$1E(a0)
		bpl.s	loc_5E02
		addq.b	#8,d0
		bcs.s	loc_5E16
		moveq	#0,d0

loc_5E16:
		move.b	d0,$1E(a0)
		move.b	$1F(a0),d0
		subq.b	#1,d0
		bne.s	loc_5E24
		moveq	#3,d0

loc_5E24:
		move.b	d0,$1F(a0)
		bra.s	loc_5E02
; ---------------------------------------------------------------------------

loc_5E2A:
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

loc_5E4A:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_5E50:
		move.b	$26(a0),d0
		bsr.w	GetSine
		move.w	d0,d2
		muls.w	#$38,d2
		asr.l	#8,d2
		add.w	d2,$14(a0)
		muls.w	$14(a0),d1
		asr.l	#8,d1
		move.w	d1,$10(a0)
		muls.w	$14(a0),d0
		asr.l	#8,d0
		move.w	d0,$12(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels\GHZ\RollingBall\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjCollapsePtfm:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_5EEE(pc,d0.w),d1
		jmp	off_5EEE(pc,d1.w)
; ---------------------------------------------------------------------------

off_5EEE:	dc.w loc_5EFA-off_5EEE, loc_5F2A-off_5EEE, loc_5F4E-off_5EEE, loc_5F7E-off_5EEE, loc_5FDE-off_5EEE
		dc.w sub_5F60-off_5EEE
; ---------------------------------------------------------------------------

loc_5EFA:
		addq.b	#2,$24(a0)
		move.l	#MapCollapsePtfm,4(a0)
		move.w	#$4000,2(a0)
		ori.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#7,$38(a0)
		move.b	#$64,$18(a0)
		move.b	$28(a0),$1A(a0)

loc_5F2A:
		tst.b	$3A(a0)
		beq.s	loc_5F3C
		tst.b	$38(a0)
		beq.w	loc_612A
		subq.b	#1,$38(a0)

loc_5F3C:
		move.w	#$30,d1
		lea	(ObjCollapsePtfm_Slope).l,a2
		bsr.w	PtfmSloped
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

loc_5F4E:
		tst.b	$38(a0)
		beq.w	loc_6130
		move.b	#1,$3A(a0)
		subq.b	#1,$38(a0)
; ---------------------------------------------------------------------------

sub_5F60:
		move.w	#$30,d1
		bsr.w	PtfmCheckExit
		move.w	#$30,d1
		lea	(ObjCollapsePtfm_Slope).l,a2
		move.w	8(a0),d2
		bsr.w	sub_61E0
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

loc_5F7E:
		tst.b	$38(a0)
		beq.s	loc_5FCE
		tst.b	$3A(a0)
		bne.w	loc_5F94
		subq.b	#1,$38(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_5F94:
		subq.b	#1,$38(a0)
		bsr.w	sub_5F60
		lea	(v_objspace).w,a1
		btst	#3,$22(a1)
		beq.s	loc_5FC0
		tst.b	$38(a0)
		bne.s	locret_5FCC
		bclr	#3,$22(a1)
		bclr	#5,$22(a1)
		move.b	#1,$1D(a1)

loc_5FC0:
		move.b	#0,$3A(a0)
		move.b	#6,$24(a0)

locret_5FCC:
		rts
; ---------------------------------------------------------------------------

loc_5FCE:
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		tst.b	1(a0)
		bpl.s	loc_5FDE
		rts
; ---------------------------------------------------------------------------

loc_5FDE:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------
loc_6160:
		bsr.w	ObjectLoad
		bne.s	loc_61A8
		addq.w	#5,a3

loc_6168:
		move.b	#6,$24(a1)
		move.b	d4,0(a1)
		move.l	a3,4(a1)
		move.b	d5,1(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.w	2(a0),2(a1)
		move.b	$19(a0),$19(a1)
		move.b	$18(a0),$18(a1)
		move.b	(a4)+,$38(a1)
		cmpa.l	a0,a1
		bcc.s	loc_61A4
		bsr.w	DisplaySprite1

loc_61A4:
		dbf	d1,loc_6160

loc_61A8:
		bsr.w	DisplaySprite
		move.w	#$B9,d0
		jmp	(PlaySFX).l
		
loc_612A:
		move.b	#0,$3A(a0)
loc_6130:
		lea	(ObjCollapseFloor_Delay1).l,a4
		moveq	#$18,d1
		addq.b	#2,$1A(a0)

loc_613C:
		moveq	#0,d0
		move.b	$1A(a0),d0
		add.w	d0,d0
		movea.l	4(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#1,a3
		bset	#5,1(a0)
		move.b	0(a0),d4
		move.b	1(a0),d5
		movea.l	a0,a1
		bra.w	loc_6168

ObjCollapseFloor_Delay1:dc.b $1C, $18, $14, $10, $1A, $16, $12, $E, $A, 6, $18
		dc.b $14, $10, $C, 8, 4, $16, $12, $E, $A, 6, 2, $14, $10
		dc.b $C, 0

sub_61E0:
		lea	(v_objspace).w,a1
		btst	#3,$22(a1)
		beq.s	locret_6224
		move.w	8(a1),d0
		sub.w	8(a0),d0
		add.w	d1,d0
		lsr.w	#1,d0
		btst	#0,1(a0)
		beq.s	loc_6204
		not.w	d0
		add.w	d1,d0

loc_6204:
		moveq	#0,d1
		move.b	(a2,d0.w),d1
		move.w	$C(a0),d0
		sub.w	d1,d0
		moveq	#0,d1
		move.b	$16(a1),d1
		sub.w	d1,d0
		move.w	d0,$C(a1)
		sub.w	8(a0),d2
		sub.w	d2,8(a1)

locret_6224:
		rts

ObjCollapsePtfm_Slope:dc.b $20, $20, $20, $20, $20, $20, $20, $20, $21, $21
		dc.b $22, $22, $23, $23, $24, $24, $25, $25, $26, $26
		dc.b $27, $27, $28, $28, $29, $29, $2A, $2A, $2B, $2B
		dc.b $2C, $2C, $2D, $2D, $2E, $2E, $2F, $2F, $30, $30
		dc.b $30, $30, $30, $30, $30, $30, $30, $30
		include "_maps\06526.asm"
		include "levels\GHZ\CollapsePtfm\Sprite.map"
		even
; ---------------------------------------------------------------------------

Obj1B:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_6634(pc,d0.w),d1
		jmp	off_6634(pc,d1.w)
; ---------------------------------------------------------------------------

off_6634:	dc.w loc_663E-off_6634, loc_6676-off_6634, loc_668A-off_6634, loc_66CE-off_6634, loc_66D6-off_6634
; ---------------------------------------------------------------------------

loc_663E:
		addq.b	#2,act(a0)
		move.l	#Map1B,map(a0)
		move.w	#$4000,tile(a0)
		move.b	#4,render(a0)
		move.b	#$20,xdisp(a0)
		move.b	#5,$19(a0)
		tst.b	arg(a0)
		bne.s	loc_6676
		move.b	#1,prio(a0)
		move.b	#6,act(a0)
		rts
; ---------------------------------------------------------------------------

loc_6676:
		move.w	#$20,d1
		move.w	#-$14,d3
		bsr.w	PtfmNormalHeight
		bsr.w	DisplaySprite
		bra.w	loc_66A8
; ---------------------------------------------------------------------------

loc_668A:
		move.w	#$20,d1
		bsr.w	PtfmCheckExit
		move.w	8(a0),d2
		move.w	#-$14,d3
		bsr.w	PtfmSurfaceHeight
		bsr.w	DisplaySprite
		bra.w	loc_66A8
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

loc_66A8:
		move.w	xpos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	loc_66C8
		rts
; ---------------------------------------------------------------------------

loc_66C8:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_66CE:
		bsr.w	DisplaySprite
		bra.w	loc_66A8
; ---------------------------------------------------------------------------

loc_66D6:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

Map1B:		dc.w byte_66E0-Map1B, byte_66F5-Map1B

byte_66E0:	dc.b 4
		dc.b $F0, $A, 0, $89, $E0
		dc.b $F0, $A, 8, $89, 8
		dc.b $F8, 5, 0, $92, $F8
		dc.b 8, $C, 0, $96, $F0

byte_66F5:	dc.b 4
		dc.b $E8, $F, 0, $9A, $E0
		dc.b $E8, $F, 8, $9A, 0
		dc.b 8, $D, 0, $AA, $E0
		dc.b 8, $D, 8, $AA, 0
; ---------------------------------------------------------------------------

ObjScenery:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_6718(pc,d0.w),d1
		jmp	off_6718(pc,d1.w)
; ---------------------------------------------------------------------------

off_6718:	dc.w ObjScenery_Init-off_6718, ObjScenery_Normal-off_6718, ObjScenery_Delete-off_6718, ObjScenery_Delete-off_6718
; ---------------------------------------------------------------------------

ObjScenery_Init:
		addq.b	#2,act(a0)
		moveq	#0,d0
		move.b	arg(a0),d0
		mulu.w	#10,d0
		lea	ObjScenery_Types(pc,d0.w),a1
		move.l	(a1)+,map(a0)
		move.w	(a1)+,tile(a0)
		ori.b	#4,render(a0)
		move.b	(a1)+,frame(a0)
		move.b	(a1)+,xdisp(a0)
		move.b	(a1)+,prio(a0)
		move.b	(a1)+,col(a0)

ObjScenery_Normal:
		bsr.w	DisplaySprite
		move.w	xpos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	ObjScenery_Delete
		rts
; ---------------------------------------------------------------------------

ObjScenery_Delete:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

ObjScenery_Types:dc.l MapScenery
		dc.w $398
		dc.b 0, $10, 4, $82
		dc.l MapScenery
		dc.w $398
		dc.b 1, $14, 4, $83
		dc.l MapScenery
		dc.w $4000
		dc.b 0, $20, 1, 0
		dc.l MapBridge
		dc.w $438E
		dc.b 1, $10, 1, 0
		include "levels\shared\Scenery\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjUnkSwitch:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_67C8(pc,d0.w),d1
		jmp	off_67C8(pc,d1.w)
; ---------------------------------------------------------------------------

off_67C8:	dc.w loc_67CE-off_67C8, loc_67F8-off_67C8, loc_6836-off_67C8
; ---------------------------------------------------------------------------

loc_67CE:
		addq.b	#2,act(a0)
		move.l	#MapUnkSwitch,map(a0)
		move.w	#$4000,tile(a0)
		move.b	#4,render(a0)
		move.w	ypos(a0),$30(a0)
		move.b	#$10,xdisp(a0)
		move.b	#5,prio(a0)

loc_67F8:
		move.w	$30(a0),ypos(a0)
		move.w	#$10,d1
		bsr.w	sub_683C
		beq.s	loc_6812
		addq.w	#2,ypos(a0)
		moveq	#1,d0
		move.w	d0,(unk_FFF7E0).w

loc_6812:
		bsr.w	DisplaySprite
		move.w	xpos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	loc_6836
		rts
; ---------------------------------------------------------------------------

loc_6836:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_683C:
		lea	(v_objspace).w,a1
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.s	loc_6874
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.s	loc_6874
		move.w	ypos(a1),d2
		move.b	yrad(a1),d1
		ext.w	d1
		add.w	d2,d1
		move.w	ypos(a0),d0
		subi.w	#$10,d0
		sub.w	d1,d0
		bhi.s	loc_6874
		cmpi.w	#$FFF0,d0
		bcs.s	loc_6874
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_6874:
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------
		include "_maps\Unknown Switch.asm"
		even
; ---------------------------------------------------------------------------

Obj2A:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_689E(pc,d0.w),d1
		jmp	off_689E(pc,d1.w)
; ---------------------------------------------------------------------------

off_689E:	dc.w loc_68A4-off_689E, loc_68F0-off_689E, loc_6912-off_689E
; ---------------------------------------------------------------------------

loc_68A4:
		addq.b	#2,act(a0)
		move.l	#Map2A,map(a0)
		move.w	#0,tile(a0)
		move.b	#4,render(a0)
		move.w	ypos(a0),d0
		subi.w	#$20,d0
		move.w	d0,$30(a0)
		move.b	#$B,xdisp(a0)
		move.b	#5,prio(a0)
		tst.b	arg(a0)
		beq.s	loc_68F0
		move.b	#1,frame(a0)
		move.w	#$4000,tile(a0)
		move.b	#4,prio(a0)
		addq.b	#2,act(a0)

loc_68F0:
		tst.w	(unk_FFF7E0).w
		beq.s	loc_6906
		subq.w	#1,ypos(a0)
		move.w	$30(a0),d0
		cmp.w	ypos(a0),d0
		beq.w	DeleteObject

loc_6906:
		move.w	#$16,d1
		move.w	#$10,d2
		bsr.w	sub_6936

loc_6912:
		bsr.w	DisplaySprite
		move.w	xpos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_6936:
		tst.w	(DebugRoutine).w
		bne.w	locret_69A6
		;cmpi.b	#6,(v_objspace+$24).w
		;bcc.s	locret_69A6
		bsr.w	sub_69CE
		beq.s	loc_698C
		bmi.w	loc_69A8
		tst.w	d0
		beq.w	loc_6976
		bmi.s	loc_6960
		tst.w	xvel(a1)
		bmi.s	loc_6976
		bra.s	loc_6966
; ---------------------------------------------------------------------------

loc_6960:
		tst.w	xvel(a1)
		bpl.s	loc_6976

loc_6966:
		sub.w	d0,xpos(a1)
		move.w	#0,inertia(a1)
		move.w	#0,xvel(a1)

loc_6976:
		btst	#1,status(a1)
		bne.s	loc_699A
		bset	#5,status(a1)
		bset	#5,status(a0)
		rts
; ---------------------------------------------------------------------------

loc_698C:
		btst	#5,status(a0)
		beq.s	locret_69A6
		move.w	#1,ani(a1)

loc_699A:
		bclr	#5,status(a0)
		bclr	#5,status(a1)

locret_69A6:
		rts
; ---------------------------------------------------------------------------

loc_69A8:
		tst.w	yvel(a1)
		beq.s	loc_69C0
		bpl.s	locret_69BE
		tst.w	d3
		bpl.s	locret_69BE
		sub.w	d3,ypos(a1)
		move.w	#0,yvel(a1)

locret_69BE:
		rts
; ---------------------------------------------------------------------------

loc_69C0:
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	(loc_FD78).l
		movea.l	(sp)+,a0
		rts
; ---------------------------------------------------------------------------

sub_69CE:
		lea	(v_objspace).w,a1
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.s	loc_6A28
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	loc_6A28
		move.b	yrad(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	ypos(a1),d3
		sub.w	ypos(a0),d3
		add.w	d2,d3
		bmi.s	loc_6A28
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bcc.s	loc_6A28
		move.w	d0,d5
		cmp.w	d0,d1
		bcc.s	loc_6A10
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5
		neg.w	d5

loc_6A10:
		move.w	d3,d1
		cmp.w	d3,d2
		bcc.s	loc_6A1C
		sub.w	d4,d3
		move.w	d3,d1
		neg.w	d1

loc_6A1C:
		cmp.w	d1,d5
		bhi.s	loc_6A24
		moveq	#1,d4
		rts
; ---------------------------------------------------------------------------

loc_6A24:
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

loc_6A28:
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------
		include "_maps\2A.asm"
		even
; ---------------------------------------------------------------------------

ObjTitleSonic:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_6A64(pc,d0.w),d1
		jmp	off_6A64(pc,d1.w)
; ---------------------------------------------------------------------------

off_6A64:	dc.w loc_6A6C-off_6A64, loc_6AA0-off_6A64, loc_6AB0-off_6A64, loc_6AC6-off_6A64
; ---------------------------------------------------------------------------

loc_6A6C:
		addq.b	#2,act(a0)
		move.w	#$F0,xpos(a0)
		move.w	#$DE+$4,xpix(a0)
		move.l	#MapTitleSonic,map(a0)
		move.w	#$2303,tile(a0)
		move.b	#1,prio(a0)
		move.b	#$1D,$1F(a0)
		lea	(AniTitleSonic).l,a1
		bsr.w	ObjectAnimate

loc_6AA0:
		subq.b	#1,$1F(a0)
		bpl.s	locret_6AAE
		addq.b	#2,act(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

locret_6AAE:
		rts
; ---------------------------------------------------------------------------

loc_6AB0:
		subq.w	#8,xpix(a0)
		cmpi.w	#$96+$4,xpix(a0)
		bne.s	loc_6AC0
		addq.b	#2,act(a0)

loc_6AC0:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

loc_6AC6:
		lea	(AniTitleSonic).l,a1
		bsr.w	ObjectAnimate
		bsr.w	DisplaySprite
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

ObjTitleText:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_6AE8(pc,d0.w),d1
		jsr	off_6AE8(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_6AE8:	dc.w loc_6AEE-off_6AE8, loc_6B1A-off_6AE8, locret_6B18-off_6AE8
; ---------------------------------------------------------------------------

loc_6AEE:
		addq.b	#2,act(a0)
		move.w	#$D0+$2,xpos(a0)
		move.w	#$130+$4,xpix(a0)
		move.l	#MapTitleText,map(a0)
		move.w	#$205,tile(a0)
		cmpi.b	#2,frame(a0)
		bne.s	loc_6B1A
		addq.b	#2,act(a0)

locret_6B18:
		rts
; ---------------------------------------------------------------------------

loc_6B1A:
		lea	(AniTitleText).l,a1
		bra.w	ObjectAnimate
; ---------------------------------------------------------------------------
		include "screens\title\TitleSonic\Sprite.ani"
		include "screens\title\TitleText\Sprite.ani"
; ---------------------------------------------------------------------------

ObjectAnimate:
		moveq	#0,d0
		move.b	ani(a0),d0
		cmp.b	anilast(a0),d0
		beq.s	loc_6B54
		move.b	d0,anilast(a0)
		move.b	#0,anipos(a0)
		move.b	#0,anidelay(a0)

loc_6B54:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		subq.b	#1,anidelay(a0)
		bpl.s	locret_6B94
		move.b	(a1),anidelay(a0)
		moveq	#0,d1
		move.b	anipos(a0),d1
		move.b	1(a1,d1.w),d0
		bmi.s	loc_6B96

loc_6B70:
		move.b	d0,d1
		andi.b	#$1F,d0
		move.b	d0,frame(a0)
		move.b	status(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,render(a0)
		lsr.b	#5,d1
		eor.b	d0,d1
		or.b	d1,render(a0)
		addq.b	#1,anipos(a0)

locret_6B94:
		rts
; ---------------------------------------------------------------------------

loc_6B96:
		addq.b	#1,d0
		bne.s	loc_6BA6
		move.b	#0,anipos(a0)
		move.b	render(a1),d0
		bra.s	loc_6B70
; ---------------------------------------------------------------------------

loc_6BA6:
		addq.b	#1,d0
		bne.s	loc_6BBA
		move.b	2(a1,d1.w),d0
		sub.b	d0,anipos(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.s	loc_6B70
; ---------------------------------------------------------------------------

loc_6BBA:
		addq.b	#1,d0
		bne.s	loc_6BC4
		move.b	2(a1,d1.w),ani(a0)

loc_6BC4:
		addq.b	#1,d0
		bne.s	loc_6BCC
		addq.b	#2,act(a0)

loc_6BCC:
		addq.b	#1,d0
		bne.s	locret_6BDA
		move.b	#0,anipos(a0)
		clr.b	subact(a0)

locret_6BDA:
		rts
; ---------------------------------------------------------------------------
		include "screens\title\TitleText\Sprite.map"
		include "screens\title\TitleSonic\Sprite.map"

                include "_incObj\1E Ballhog.asm"
                include "_incObj\20 Ballhog's Bomb.asm"
                include "_incObj\24 Ballhog's Bomb Explosion.asm"
; ---------------------------------------------------------------------------

ObjExplode:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_7172(pc,d0.w),d1
		jmp	off_7172(pc,d1.w)
; ---------------------------------------------------------------------------

off_7172:	dc.w ObjExplode_Load-off_7172, ObjExplode_Init-off_7172, ObjExplode_Act-off_7172
; ---------------------------------------------------------------------------

ObjExplode_Load:
		addq.b	#2,act(a0)
		bsr.w	ObjectLoad
		bne.s	ObjExplode_Init
		move.b	#$28,id(a1)
		move.w	xpos(a0),xpos(a1)
		move.w	ypos(a0),ypos(a1)

ObjExplode_Init:
		addq.b	#2,act(a0)
		move.l	#MapExplode,map(a0)
		move.w	#$5A0,tile(a0)
		move.b	#4,render(a0)
		move.b	#2,prio(a0)
		move.b	#0,col(a0)
		move.b	#12,xdisp(a0)
		move.b	#7,anidelay(a0)
		move.b	#0,frame(a0)
		move.w	#$AD,d0
		jsr	(PlaySFX).l

ObjExplode_Act:
		subq.b	#1,anidelay(a0)
		bpl.s	.display
		move.b	#7,anidelay(a0)
		addq.b	#1,frame(a0)
		cmpi.b	#5,frame(a0)
		beq.w	DeleteObject

.display:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
		include "_anim\BallHog.asm"
		include "_maps\BallHog.asm"
		include "_maps\BallHog's Bomb.asm"
		include "_maps\BallHog's Bomb Explosion.asm"
		include "levels\shared\Explosion\Sprite.map"
		include "levels\shared\Explosion\Bomb.map"
; ---------------------------------------------------------------------------

ObjAnimals:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_732C(pc,d0.w),d1
		jmp	off_732C(pc,d1.w)
; ---------------------------------------------------------------------------

off_732C:	dc.w loc_7382-off_732C, loc_7418-off_732C, loc_7472-off_732C, loc_74A8-off_732C, loc_7472-off_732C
		dc.w loc_7472-off_732C, loc_7472-off_732C, loc_74A8-off_732C, loc_7472-off_732C

byte_733E:	dc.b 0, 1, 2, 3, 4, 5, 6, 3, 4, 1, 0, 5

word_734A:	dc.w $FE00, $FC00
		dc.l MapAnimals1
		dc.w $FE00, $FD00
		dc.l MapAnimals2
		dc.w $FEC0, $FE00
		dc.l MapAnimals1
		dc.w $FF00, $FE80
		dc.l MapAnimals2
		dc.w $FE80, $FD00
		dc.l MapAnimals3
		dc.w $FD00, $FC00
		dc.l MapAnimals2
		dc.w $FD80, $FC80
		dc.l MapAnimals3
; ---------------------------------------------------------------------------

loc_7382:
		addq.b	#2,act(a0)
		bsr.w	RandomNumber
		andi.w	#1,d0
		moveq	#0,d1
		move.b	(v_zone).w,d1
		add.w	d1,d1
		add.w	d0,d1
		move.b	byte_733E(pc,d1.w),d0
		move.b	d0,$30(a0)
		lsl.w	#3,d0
		lea	word_734A(pc,d0.w),a1
		move.w	(a1)+,$32(a0)
		move.w	(a1)+,$34(a0)
		move.l	(a1)+,map(a0)
		move.w	#$580,tile(a0)
		btst	#0,$30(a0)
		beq.s	loc_73C6
		move.w	#$592,tile(a0)

loc_73C6:
		move.b	#$C,yrad(a0)
		move.b	#4,render(a0)
		bset	#0,render(a0)
		move.b	#6,prio(a0)
		move.b	#8,xdisp(a0)
		move.b	#7,anidelay(a0)
		move.b	#2,frame(a0)
		move.w	#-$400,yvel(a0)
		tst.b	(unk_FFF7A7).w
		bne.s	loc_7438
		bsr.w	ObjectLoad
		bne.s	loc_7414
		move.b	#$29,id(a1)
		move.w	xpos(a0),xpos(a1)
		move.w	ypos(a0),ypos(a1)

loc_7414:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_7418:
		tst.b	render(a0)
		bpl.w	DeleteObject
		bsr.w	ObjectFall
		tst.w	yvel(a0)
		bmi.s	loc_746E
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	loc_746E
		add.w	d1,ypos(a0)

loc_7438:
		move.w	$32(a0),xvel(a0)
		move.w	$34(a0),yvel(a0)
		move.b	#1,frame(a0)
		move.b	$30(a0),d0
		add.b	d0,d0
		addq.b	#4,d0
		move.b	d0,act(a0)
		tst.b	(unk_FFF7A7).w
		beq.s	loc_746E
		btst	#4,(byte_FFFE0F).w
		beq.s	loc_746E
		neg.w	xvel(a0)
		bchg	#0,render(a0)

loc_746E:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_7472:
		bsr.w	ObjectFall
		move.b	#1,frame(a0)
		tst.w	yvel(a0)
		bmi.s	loc_749C
		move.b	#0,frame(a0)
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	loc_749C
		add.w	d1,ypos(a0)
		move.w	$34(a0),yvel(a0)

loc_749C:
		tst.b	render(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_74A8:
		bsr.w	SpeedToPos
		addi.w	#$18,yvel(a0)
		tst.w	yvel(a0)
		bmi.s	loc_74CC
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	loc_74CC
		add.w	d1,ypos(a0)
		move.w	$34(a0),yvel(a0)

loc_74CC:
		subq.b	#1,anidelay(a0)
		bpl.s	loc_74E2
		move.b	#1,anidelay(a0)
		addq.b	#1,frame(a0)
		andi.b	#1,frame(a0)

loc_74E2:
		tst.b	render(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjPoints:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_7500(pc,d0.w),d1
		jsr	off_7500(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_7500:	dc.w ObjPoints_Init-off_7500, ObjPoints_Act-off_7500
; ---------------------------------------------------------------------------

ObjPoints_Init:
		addq.b	#2,act(a0)
		move.l	#MapPoints,map(a0)
		move.w	#$2797,tile(a0)
		move.b	#4,render(a0)
		move.b	#1,prio(a0)
		move.b	#8,xdisp(a0)
		move.w	#-$300,yvel(a0)

ObjPoints_Act:
		tst.w	yvel(a0)
		bpl.w	DeleteObject
		bsr.w	SpeedToPos
		addi.w	#$18,yvel(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels\shared\Animals\1.map"
		include "levels\shared\Animals\2.map"
		include "levels\shared\Animals\3.map"
		include "levels\shared\Points\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjCrabmeat:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_75B8(pc,d0.w),d1
		jmp	off_75B8(pc,d1.w)
; ---------------------------------------------------------------------------

off_75B8:	dc.w loc_75C2-off_75B8, loc_7616-off_75B8, loc_7772-off_75B8, loc_7778-off_75B8, loc_77AE-off_75B8
; ---------------------------------------------------------------------------

loc_75C2:
		move.b	#$10,$16(a0)
		move.b	#8,$17(a0)
		move.l	#MapCrabmeat,4(a0)
		move.w	#$400,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#6,$20(a0)
		move.b	#$15,$18(a0)
		bsr.w	ObjectFall
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.s	locret_7614
		add.w	d1,$C(a0)
		move.b	d3,$26(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$24(a0)

locret_7614:
		rts
; ---------------------------------------------------------------------------

loc_7616:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_7632(pc,d0.w),d1
		jsr	off_7632(pc,d1.w)
		lea	(AniCrabmeat).l,a1
		bsr.w	ObjectAnimate
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_7632:	dc.w loc_7636-off_7632, loc_76D4-off_7632
; ---------------------------------------------------------------------------

loc_7636:
		subq.w	#1,$30(a0)
		bpl.s	locret_7670
		tst.b	1(a0)
		bpl.s	loc_764A
		bchg	#1,$32(a0)
		bne.s	loc_7672

loc_764A:
		addq.b	#2,$25(a0)
		move.w	#$7F,$30(a0)
		move.w	#$80,$10(a0)
		bsr.w	sub_7742
		addq.b	#3,d0
		move.b	d0,$1C(a0)
		bchg	#0,$22(a0)
		bne.s	locret_7670
		neg.w	$10(a0)

locret_7670:
		rts
; ---------------------------------------------------------------------------

loc_7672:
		move.w	#$3B,$30(a0)
		move.b	#6,$1C(a0)
		bsr.w	ObjectLoad
		bne.s	loc_76A8
		move.b	#$1F,0(a1)
		move.b	#6,$24(a1)
		move.w	8(a0),8(a1)
		subi.w	#$10,8(a1)
		move.w	$C(a0),$C(a1)
		move.w	#$FF00,$10(a1)

loc_76A8:
		bsr.w	ObjectLoad
		bne.s	locret_76D2
		move.b	#$1F,0(a1)
		move.b	#6,$24(a1)
		move.w	8(a0),8(a1)
		addi.w	#$10,8(a1)
		move.w	$C(a0),$C(a1)
		move.w	#$100,$10(a1)

locret_76D2:
		rts
; ---------------------------------------------------------------------------

loc_76D4:
		subq.w	#1,$30(a0)
		bmi.s	loc_7728
		bsr.w	SpeedToPos
		bchg	#0,$32(a0)
		bne.s	loc_770E
		move.w	8(a0),d3
		addi.w	#$10,d3
		btst	#0,$22(a0)
		beq.s	loc_76FA
		subi.w	#$20,d3

loc_76FA:
		jsr	(ObjectHitFloor2).l
		cmpi.w	#$FFF8,d1
		blt.s	loc_7728
		cmpi.w	#$C,d1
		bge.s	loc_7728
		rts
; ---------------------------------------------------------------------------

loc_770E:
		jsr	(ObjectHitFloor).l
		add.w	d1,$C(a0)
		move.b	d3,$26(a0)
		bsr.w	sub_7742
		addq.b	#3,d0
		move.b	d0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_7728:
		subq.b	#2,$25(a0)
		move.w	#$3B,$30(a0)

loc_7732:
		move.w	#0,$10(a0)
		bsr.w	sub_7742
		move.b	d0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

sub_7742:
		moveq	#0,d0
		move.b	$26(a0),d3
		bmi.s	loc_775E
		cmpi.b	#6,d3
		bcs.s	locret_775C
		moveq	#1,d0
		btst	#0,$22(a0)
		bne.s	locret_775C
		moveq	#2,d0

locret_775C:
		rts
; ---------------------------------------------------------------------------

loc_775E:
		cmpi.b	#$FA,d3
		bhi.s	locret_7770
		moveq	#2,d0
		btst	#0,$22(a0)
		bne.s	locret_7770
		moveq	#1,d0

locret_7770:
		rts
; ---------------------------------------------------------------------------

loc_7772:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_7778:
		addq.b	#2,$24(a0)
		move.l	#MapCrabmeat,4(a0)
		move.w	#$400,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#$87,$20(a0)
		move.b	#8,$18(a0)
		move.w	#$FC00,$12(a0)
		move.b	#7,$1C(a0)

loc_77AE:
		lea	(AniCrabmeat).l,a1
		bsr.w	ObjectAnimate
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$C(a0),d0
		bcs.s	loc_77D0
		rts
; ---------------------------------------------------------------------------

loc_77D0:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------
		include "levels\GHZ\Crabmeat\Sprite.ani"
		include "levels\GHZ\Crabmeat\Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjBuzzbomber:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_78A6(pc,d0.w),d1
		jmp	off_78A6(pc,d1.w)
; ---------------------------------------------------------------------------

off_78A6:	dc.w loc_78AC-off_78A6, loc_78D6-off_78A6, loc_79E6-off_78A6
; ---------------------------------------------------------------------------

loc_78AC:
		addq.b	#2,$24(a0)
		move.l	#MapBuzzbomber,4(a0)
		move.w	#$444,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#8,$20(a0)
		move.b	#$18,$18(a0)

loc_78D6:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	loc_78F2(pc,d0.w),d1
		jsr	loc_78F2(pc,d1.w)
		lea	(AniBuzzbomber).l,a1
		bsr.w	ObjectAnimate
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

loc_78F2:
		ori.b	#$9A,d4
		subq.w	#1,$32(a0)
		bpl.s	locret_7926
		btst	#1,$34(a0)
		bne.s	loc_7928
		addq.b	#2,$25(a0)
		move.w	#$7F,$32(a0)
		move.w	#$400,$10(a0)
		move.b	#1,$1C(a0)
		btst	#0,$22(a0)
		bne.s	locret_7926
		neg.w	$10(a0)

locret_7926:
		rts
; ---------------------------------------------------------------------------

loc_7928:
		bsr.w	ObjectLoad
		bne.s	locret_798A
		move.b	#$23,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		addi.w	#$1C,$C(a1)
		move.w	#$200,$12(a1)
		move.w	#$200,$10(a1)
		move.w	#$18,d0
		btst	#0,$22(a0)
		bne.s	loc_7964
		neg.w	d0
		neg.w	$10(a1)

loc_7964:
		add.w	d0,8(a1)
		move.b	$22(a0),$22(a1)
		move.w	#$E,$32(a1)
		move.l	a0,$3C(a1)
		move.b	#1,$34(a0)
		move.w	#$3B,$32(a0)
		move.b	#2,$1C(a0)

locret_798A:
		rts
; ---------------------------------------------------------------------------
		subq.w	#1,$32(a0)
		bmi.s	loc_79C2
		bsr.w	SpeedToPos
		tst.b	$34(a0)
		bne.s	locret_79E4
		move.w	(v_objspace+8).w,d0
		sub.w	8(a0),d0
		bpl.s	loc_79A8
		neg.w	d0

loc_79A8:
		cmpi.w	#$60,d0
		bcc.s	locret_79E4
		tst.b	1(a0)
		bpl.s	locret_79E4
		move.b	#2,$34(a0)
		move.w	#$1D,$32(a0)
		bra.s	loc_79D4
; ---------------------------------------------------------------------------

loc_79C2:
		move.b	#0,$34(a0)
		bchg	#0,$22(a0)
		move.w	#$3B,$32(a0)

loc_79D4:
		subq.b	#2,$25(a0)
		move.w	#0,$10(a0)
		move.b	#0,$1C(a0)

locret_79E4:
		rts
; ---------------------------------------------------------------------------

loc_79E6:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

ObjBuzzMissile:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_79FA(pc,d0.w),d1
		jmp	off_79FA(pc,d1.w)
; ---------------------------------------------------------------------------

off_79FA:	dc.w loc_7A04-off_79FA, loc_7A4E-off_79FA, loc_7A6C-off_79FA, loc_7AB2-off_79FA, loc_7AB8-off_79FA
; ---------------------------------------------------------------------------

loc_7A04:
		subq.w	#1,$32(a0)
		bpl.s	sub_7A5E
		addq.b	#2,$24(a0)
		move.l	#MapBuzzMissile,4(a0)
		move.w	#$2444,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#8,$18(a0)
		andi.b	#3,$22(a0)
		tst.b	$28(a0)
		beq.s	loc_7A4E
		move.b	#8,$24(a0)
		move.b	#$87,$20(a0)
		move.b	#1,$1C(a0)
		bra.s	loc_7AC2
; ---------------------------------------------------------------------------

loc_7A4E:
		bsr.s	sub_7A5E
		lea	(AniBuzzMissile).l,a1
		bsr.w	ObjectAnimate
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

sub_7A5E:
		movea.l	$3C(a0),a1
		cmpi.b	#$27,0(a1)
		beq.s	loc_7AB2
		rts
; ---------------------------------------------------------------------------

loc_7A6C:
		btst	#7,$22(a0)
		bne.s	loc_7AA2
		move.b	#$87,$20(a0)
		move.b	#1,$1C(a0)
		bsr.w	SpeedToPos
		lea	(AniBuzzMissile).l,a1
		bsr.w	ObjectAnimate
		bsr.w	DisplaySprite
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$C(a0),d0
		bcs.s	loc_7AB2
		rts
; ---------------------------------------------------------------------------

loc_7AA2:
		move.b	#$24,0(a0)
		move.b	#0,$24(a0)
		bra.w	ObjCannonballExplode
; ---------------------------------------------------------------------------

loc_7AB2:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_7AB8:
		tst.b	1(a0)
		bpl.s	loc_7AB2
		bsr.w	SpeedToPos

loc_7AC2:
		lea	(AniBuzzMissile).l,a1
		bsr.w	ObjectAnimate
		bsr.w	DisplaySprite
		rts
; ---------------------------------------------------------------------------
		include "levels\GHZ\Buzzbomber\Sprite.ani"
		include "levels\GHZ\Buzzbomber\Missile.ani"
		include "levels\GHZ\Buzzbomber\Sprite.map"
		include "levels\GHZ\Buzzbomber\Missile.map"
		even
; ---------------------------------------------------------------------------

ObjRings:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_7BEE(pc,d0.w),d1
		jmp	off_7BEE(pc,d1.w)
; ---------------------------------------------------------------------------

off_7BEE:	dc.w loc_7C18-off_7BEE, loc_7CD0-off_7BEE, loc_7CF8-off_7BEE, loc_7D1E-off_7BEE, loc_7D2C-off_7BEE

byte_7BF8:	dc.b $10, 0
		dc.b $18, 0
		dc.b $20, 0
		dc.b 0, $10
		dc.b 0, $18
		dc.b 0, $20
		dc.b $10, $10
		dc.b $18, $18
		dc.b $20, $20
		dc.b $F0, $10
		dc.b $E8, $18
		dc.b $E0, $20
		dc.b $10, 8
		dc.b $18, $10
		dc.b $F0, 8
		dc.b $E8, $10
; ---------------------------------------------------------------------------

loc_7C18:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	respawn(a0),d0
		lea	2(a2,d0.w),a2
		move.b	(a2),d4
		move.b	arg(a0),d1
		move.b	d1,d0
		andi.w	#7,d1
		cmpi.w	#7,d1
		bne.s	loc_7C3A
		moveq	#6,d1

loc_7C3A:
		swap	d1
		move.w	#0,d1
		lsr.b	#4,d0
		add.w	d0,d0
		move.b	byte_7BF8(pc,d0.w),d5
		ext.w	d5
		move.b	byte_7BF8+1(pc,d0.w),d6
		ext.w	d6
		movea.l	a0,a1
		move.w	xpos(a0),d2
		move.w	ypos(a0),d3
		lsr.b	#1,d4
		bcs.s	loc_7CBC
		bclr	#7,(a2)
		bra.s	loc_7C74
; ---------------------------------------------------------------------------

loc_7C64:
		swap	d1
		lsr.b	#1,d4
		bcs.s	loc_7CBC
		bclr	#7,(a2)
		bsr.w	ObjectLoad
		bne.s	loc_7CC8

loc_7C74:
		move.b	#$25,id(a1)
		addq.b	#2,act(a1)
		move.w	d2,xpos(a1)
		move.w	xpos(a0),$32(a1)
		move.w	d3,ypos(a1)
		move.l	#MapRing,map(a1)
		move.w	#$27B2,tile(a1)
		move.b	#4,render(a1)
		move.b	#2,prio(a1)
		move.b	#$47,col(a1)
		move.b	#8,xdisp(a1)
		move.b	respawn(a0),respawn(a1)
		move.b	d1,$34(a1)

loc_7CBC:
		addq.w	#1,d1
		add.w	d5,d2
		add.w	d6,d3
		swap	d1
		dbf	d1,loc_7C64

loc_7CC8:
		btst	#0,(a2)
		bne.w	DeleteObject

loc_7CD0:
		move.b	(RingFrame).w,frame(a0)
		bsr.w	DisplaySprite
		move.w	$32(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.s	loc_7D2C
		rts
; ---------------------------------------------------------------------------

loc_7CF8:
		addq.b	#2,act(a0)
		move.b	#0,col(a0)
		move.b	#1,prio(a0)
		bsr.w	CollectRing
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	respawn(a0),d0
		move.b	$34(a0),d1
		bset	d1,2(a2,d0.w)

loc_7D1E:
		lea	(AniRing).l,a1
		bsr.w	ObjectAnimate
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_7D2C:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

CollectRing:
		addq.w	#1,(v_rings).w
		ori.b	#1,(f_extralife).w
		move.w	#$B5,d0
		;cmpi.w	#50,(v_rings).w
		;bcs.s	loc_7D6A
		;bset	#0,(byte_FFFE1B).w
		;beq.s	loc_7D5E
		;cmpi.w	#100,(v_rings).w
		;bcs.s	loc_7D6A
		;bset	#1,(byte_FFFE1B).w
		;bne.s	loc_7D6A

;loc_7D5E:
		;addq.b	#1,(v_lives).w
		;addq.b	#1,(byte_FFFE1C).w
		;move.w	#$88,d0

;loc_7D6A:
		jmp	(PlaySFX).l
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
		include "_anim\Rings.asm"
		include "_maps\Rings.asm"
		even
; ---------------------------------------------------------------------------

ObjMonitor:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_8054(pc,d0.w),d1
		jmp	off_8054(pc,d1.w)
; ---------------------------------------------------------------------------

off_8054:	dc.w loc_805E-off_8054, loc_80C0-off_8054
		dc.w sub_81D2-off_8054, loc_81A4-off_8054
		dc.w loc_81AE-off_8054
; ---------------------------------------------------------------------------

loc_805E:
		addq.b	#2,act(a0)
		move.b	#$E,yrad(a0)
		move.b	#$E,xrad(a0)
		move.l	#MapMonitor,map(a0)
		move.w	#$680,tile(a0)
		move.b	#4,render(a0)
		move.b	#3,prio(a0)
		move.b	#$F,xdisp(a0)
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	respawn(a0),d0
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		beq.s	loc_80B4
		move.b	#8,act(a0)
		move.b	#$B,frame(a0)
		rts
; ---------------------------------------------------------------------------

loc_80B4:
		move.b	#$46,col(a0)
		;move.b	arg(a0),ani(a0)

loc_80C0:
		move.b	subact(a0),d0
		beq.s	loc_811A
		subq.b	#2,d0
		bne.s	loc_80FA
		moveq	#0,d1
		move.b	xdisp(a0),d1
		addi.w	#$B,d1
		bsr.w	PtfmCheckExit
		btst	#3,status(a1)
		bne.w	loc_80EA
		clr.b	subact(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_80EA:
		move.w	#$10,d3
		move.w	xpos(a0),d2
		bsr.w	PtfmSurfaceHeight
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_80FA:
		bsr.w	ObjectFall
		jsr	(ObjectHitFloor).l
		tst.w	d1
		bpl.w	loc_81A4
		add.w	d1,ypos(a0)
		clr.w	yvel(a0)
		clr.b	subact(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_811A:
		move.w	#$1A,d1
		move.w	#$F,d2
		bsr.w	sub_83B4
		beq.w	loc_818A
		tst.w	yvel(a1)
		bmi.s	loc_8138
		cmpi.b	#2,ani(a1)
		beq.s	loc_818A

loc_8138:
		tst.w	d1
		bpl.s	loc_814E
		sub.w	d3,ypos(a1)
		bsr.w	loc_4FD4
		move.b	#2,subact(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_814E:
		tst.w	d0
		beq.w	loc_8174
		bmi.s	loc_815E
		tst.w	xvel(a1)
		bmi.s	loc_8174
		bra.s	loc_8164
; ---------------------------------------------------------------------------

loc_815E:
		tst.w	xvel(a1)
		bpl.s	loc_8174

loc_8164:
		sub.w	d0,xpos(a1)
		move.w	#0,inertia(a1)
		move.w	#0,xvel(a1)

loc_8174:
		btst	#1,status(a1)
		bne.s	loc_8198
		bset	#5,status(a1)
		bset	#5,status(a0)
		bra.s	loc_81A4
; ---------------------------------------------------------------------------

loc_818A:
		btst	#5,status(a0)
		beq.s	loc_81A4
		move.w	#1,ani(a1)

loc_8198:
		bclr	#5,status(a0)
		bclr	#5,status(a1)

loc_81A4:
		lea	(AniMonitor).l,a1
		bsr.w	ObjectAnimate

loc_81AE:
		bsr.w	DisplaySprite
		move.w	xpos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_81D2:
		; destroy monitor
		addq.b	#2,act(a0)
		move.b	#0,col(a0)
		bsr.w	ObjectLoad
		bne.s	loc_8216
		move.b	#$27,id(a1)
		addq.b	#2,act(a1)
		move.w	xpos(a0),xpos(a1)
		move.w	ypos(a0),ypos(a1)

loc_8216:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

sub_83B4:
		tst.w	(DebugRoutine).w
		bne.w	loc_8400
		lea	(v_objspace).w,a1
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.s	loc_8400
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	loc_8400
		move.b	yrad(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	ypos(a1),d3
		sub.w	ypos(a0),d3
		add.w	d2,d3
		bmi.s	loc_8400
		add.w	d2,d2
		cmp.w	d2,d3
		bcc.s	loc_8400
		cmp.w	d0,d1
		bcc.s	loc_83F6
		add.w	d1,d1
		sub.w	d1,d0

loc_83F6:
		cmpi.w	#$10,d3
		bcs.s	loc_8404

loc_83FC:
		moveq	#1,d1
		rts
; ---------------------------------------------------------------------------

loc_8400:
		moveq	#0,d1
		rts
; ---------------------------------------------------------------------------

loc_8404:
		moveq	#0,d1
		move.b	xdisp(a0),d1
		addq.w	#4,d1
		move.w	d1,d2
		add.w	d2,d2
		add.w	xpos(a1),d1
		sub.w	xpos(a0),d1
		bmi.s	loc_83FC
		cmp.w	d2,d1
		bcc.s	loc_83FC
		moveq	#-1,d1
		rts
; ---------------------------------------------------------------------------
		include "_anim\Monitor.asm"
		include "_maps\Monitor.asm"
; ---------------------------------------------------------------------------

RunObjects:
		lea	(v_objspace).w,a0
		moveq	#$7F,d7
		moveq	#0,d0
		;cmpi.b	#6,(v_objspace+$24).w
		;bcc.s	loc_8560
; ---------------------------------------------------------------------------

sub_8546:
		move.b	(a0),d0
		beq.s	loc_8556
		add.w	d0,d0
		add.w	d0,d0
		movea.l	loc_857A+2(pc,d0.w),a1
		jsr	(a1)
		moveq	#0,d0

loc_8556:
		lea	size(a0),a0
		dbf	d7,sub_8546
		rts
; ---------------------------------------------------------------------------

loc_8560:
		moveq	#$1F,d7
		bsr.s	sub_8546
		moveq	#$5F,d7

loc_8566:
		moveq	#0,d0
		move.b	(a0),d0
		beq.s	loc_8576
		tst.b	1(a0)
		bpl.s	loc_8576
		bsr.w	DisplaySprite

loc_8576:
		lea	size(a0),a0

loc_857A:
		dbf	d7,loc_8566
		rts
; ---------------------------------------------------------------------------
AllObjects:
                include "_inc\Object Pointers.asm"
                include "_incObj\sub ObjectFall.asm"
                include "_incObj\sub SpeedToPos.asm"
                include "_incObj\sub DisplaySprite.asm"
                include "_incObj\sub DeleteObject.asm"
; ---------------------------------------------------------------------------

off_8796:	dc.l 0
                dc.l (v_screenposx)&$FFFFFF
                dc.l (v_bgscreenposx)&$FFFFFF
                dc.l (v_bg3screenposx)&$FFFFFF
; ---------------------------------------------------------------------------

ProcessMaps:
		lea	(v_spritetablebuffer).w,a2
		moveq	#0,d5
		lea	(v_spritequeue).w,a4
		moveq	#7,d7

loc_87B2:
		tst.w	(a4)
		beq.w	loc_8876
		moveq	#2,d6

loc_87BA:
		movea.w	(a4,d6.w),a0
		tst.b	(a0)
		beq.w	loc_886E
		bclr	#7,render(a0)
		move.b	1(a0),d0
		move.b	d0,d4
		andi.w	#$C,d0
		beq.s	loc_8826
		movea.l	off_8796(pc,d0.w),a1
		moveq	#0,d0
		move.b	xdisp(a0),d0
		move.w	xpos(a0),d3
		sub.w	(a1),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	loc_886E
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#320,d1
		bge.s	loc_886E
		addi.w	#$80,d3
		btst	#4,d4
		beq.s	loc_8830
		moveq	#0,d0
		move.b	yrad(a0),d0
		move.w	ypos(a0),d2
		sub.w	4(a1),d2
		move.w	d2,d1
		add.w	d0,d1
		bmi.s	loc_886E
		move.w	d2,d1
		sub.w	d0,d1
		cmpi.w	#224,d1
		bge.s	loc_886E
		addi.w	#$80,d2
		bra.s	loc_8848
; ---------------------------------------------------------------------------

loc_8826:
		move.w	xpix(a0),d2
		move.w	xpos(a0),d3
		bra.s	loc_8848
; ---------------------------------------------------------------------------

loc_8830:
		move.w	ypos(a0),d2
		sub.w	4(a1),d2
		addi.w	#$80,d2
		cmpi.w	#96,d2
		bcs.s	loc_886E
		cmpi.w	#384,d2
		bcc.s	loc_886E

loc_8848:
		movea.l	map(a0),a1
		moveq	#0,d1
		btst	#5,d4
		bne.s	loc_8864
		move.b	frame(a0),d1
		add.b	d1,d1
		adda.w	(a1,d1.w),a1
		move.b	(a1)+,d1
		subq.b	#1,d1
		bmi.s	loc_8868

loc_8864:
		bsr.w	sub_8898

loc_8868:
		bset	#7,render(a0)

loc_886E:
		addq.w	#2,d6
		subq.w	#2,(a4)
		bne.w	loc_87BA

loc_8876:
		lea	$80(a4),a4
		dbf	d7,loc_87B2
		move.b	d5,(byte_FFF62C).w
		cmpi.b	#80,d5
		beq.s	loc_8890
		move.l	#0,(a2)
		rts
; ---------------------------------------------------------------------------

loc_8890:
		move.b	#0,-5(a2)
		rts
; ---------------------------------------------------------------------------

sub_8898:
		movea.w	tile(a0),a3
		btst	#0,d4
		bne.s	loc_88DE
		btst	#1,d4
		bne.w	loc_892C
; ---------------------------------------------------------------------------

sub_88AA:
		cmpi.b	#80,d5
		beq.s	locret_88DC
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_88D6
		addq.w	#1,d0

loc_88D6:
		move.w	d0,(a2)+
		dbf	d1,sub_88AA

locret_88DC:
		rts
; ---------------------------------------------------------------------------

loc_88DE:
		btst	#1,d4
		bne.w	loc_8972

loc_88E6:
		cmpi.b	#80,d5
		beq.s	locret_892A
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	d4,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$800,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		neg.w	d0
		add.b	d4,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_8924
		addq.w	#1,d0

loc_8924:
		move.w	d0,(a2)+
		dbf	d1,loc_88E6

locret_892A:
		rts
; ---------------------------------------------------------------------------

loc_892C:
		cmpi.b	#80,d5
		beq.s	locret_8970
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		lsl.b	#3,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1000,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_896A
		addq.w	#1,d0

loc_896A:
		move.w	d0,(a2)+
		dbf	d1,loc_892C

locret_8970:
		rts
; ---------------------------------------------------------------------------

loc_8972:
		cmpi.b	#80,d5
		beq.s	locret_89C4
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		lsl.b	#3,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	d4,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1800,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		neg.w	d0
		add.b	d4,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_89BE
		addq.w	#1,d0

loc_89BE:
		move.w	d0,(a2)+
		dbf	d1,loc_8972

locret_89C4:
		rts
; ---------------------------------------------------------------------------

ObjectChkOffscreen:
		move.w	xpos(a0),d0
		sub.w	(v_screenposx).w,d0
		bmi.s	.offscreen
		cmpi.w	#320,d0
		bge.s	.offscreen
		move.w	ypos(a0),d1
		sub.w	(v_screenposy).w,d1
		bmi.s	.offscreen
		cmpi.w	#224,d1
		bge.s	.offscreen
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

.offscreen:
		moveq	#1,d0
		rts
; ---------------------------------------------------------------------------

ObjPosLoad:
		moveq	#0,d0
		move.b	(unk_FFF76C).w,d0
		move.w	off_89FC(pc,d0.w),d0
		jmp	off_89FC(pc,d0.w)
; ---------------------------------------------------------------------------

off_89FC:	dc.w loc_8A00-off_89FC, loc_8A44-off_89FC
; ---------------------------------------------------------------------------

loc_8A00:
		addq.b	#2,(unk_FFF76C).w
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	(ObjPos_Index).l,a0
		movea.l	a0,a1
		adda.w	(a0,d0.w),a0
		move.l	a0,(unk_FFF770).w
		move.l	a0,(unk_FFF774).w
		adda.w	2(a1,d0.w),a1
		move.l	a1,(unk_FFF778).w
		move.l	a1,(unk_FFF77C).w
		lea	(v_regbuffer).w,a2
		move.w	#$101,(a2)+
		move.w	#$5E,d0

loc_8A38:
		clr.l	(a2)+
		dbf	d0,loc_8A38
		move.w	#$FFFF,(unk_FFF76E).w

loc_8A44:
		lea	(v_regbuffer).w,a2
		moveq	#0,d2
		move.w	(v_screenposx).w,d6
		andi.w	#$FF80,d6
		cmp.w	(unk_FFF76E).w,d6
		beq.w	locret_8B20
		bge.s	loc_8ABA
		move.w	d6,(unk_FFF76E).w
		movea.l	(unk_FFF774).w,a0
		subi.w	#$80,d6
		bcs.s	loc_8A96

loc_8A6A:
		cmp.w	-6(a0),d6
		bge.s	loc_8A96
		subq.w	#6,a0
		tst.b	4(a0)
		bpl.s	loc_8A80
		subq.b	#1,1(a2)
		move.b	1(a2),d2

loc_8A80:
		bsr.w	sub_8B22
		bne.s	loc_8A8A
		subq.w	#6,a0
		bra.s	loc_8A6A
; ---------------------------------------------------------------------------

loc_8A8A:
		tst.b	4(a0)
		bpl.s	loc_8A94
		addq.b	#1,1(a2)

loc_8A94:
		addq.w	#6,a0

loc_8A96:
		move.l	a0,(unk_FFF774).w
		movea.l	(unk_FFF770).w,a0
		addi.w	#$300,d6

loc_8AA2:
		cmp.w	-6(a0),d6
		bgt.s	loc_8AB4
		tst.b	-2(a0)
		bpl.s	loc_8AB0
		subq.b	#1,(a2)

loc_8AB0:
		subq.w	#6,a0
		bra.s	loc_8AA2
; ---------------------------------------------------------------------------

loc_8AB4:
		move.l	a0,(unk_FFF770).w
		rts
; ---------------------------------------------------------------------------

loc_8ABA:
		move.w	d6,(unk_FFF76E).w
		movea.l	(unk_FFF770).w,a0
		addi.w	#$280,d6

loc_8AC6:
		cmp.w	(a0),d6
		bls.s	loc_8ADA
		tst.b	4(a0)
		bpl.s	loc_8AD4
		move.b	(a2),d2
		addq.b	#1,(a2)

loc_8AD4:
		bsr.w	sub_8B22
		beq.s	loc_8AC6

loc_8ADA:
		move.l	a0,(unk_FFF770).w
		movea.l	(unk_FFF774).w,a0
		subi.w	#$300,d6
		bcs.s	loc_8AFA

loc_8AE8:
		cmp.w	(a0),d6
		bls.s	loc_8AFA
		tst.b	4(a0)
		bpl.s	loc_8AF6
		addq.b	#1,1(a2)

loc_8AF6:
		addq.w	#6,a0
		bra.s	loc_8AE8
; ---------------------------------------------------------------------------

loc_8AFA:
		move.l	a0,(unk_FFF774).w
		rts
; ---------------------------------------------------------------------------

loc_8B00:
		movea.l	(unk_FFF778).w,a0
		move.w	(v_bg3screenposx).w,d0
		addi.w	#$200,d0
		andi.w	#$FF80,d0
		cmp.w	(a0),d0
		bcs.s	locret_8B20
		bsr.w	sub_8B22
		move.l	a0,(unk_FFF778).w
		bra.w	loc_8B00
; ---------------------------------------------------------------------------

locret_8B20:
		rts
; ---------------------------------------------------------------------------

sub_8B22:
		tst.b	4(a0)
		bpl.s	loc_8B36
		bset	#7,2(a2,d2.w)
		beq.s	loc_8B36
		addq.w	#6,a0
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

loc_8B36:
		bsr.w	ObjectLoad
		bne.s	locret_8B70
		move.w	(a0)+,8(a1)
		move.w	(a0)+,d0
		move.w	d0,d1
		andi.w	#$FFF,d0
		move.w	d0,$C(a1)
		rol.w	#2,d1
		andi.b	#3,d1
		move.b	d1,1(a1)
		move.b	d1,$22(a1)
		move.b	(a0)+,d0
		bpl.s	loc_8B66
		andi.b	#$7F,d0
		move.b	d2,$23(a1)

loc_8B66:
		move.b	d0,0(a1)
		move.b	(a0)+,$28(a1)
		moveq	#0,d0

locret_8B70:
		rts
; ---------------------------------------------------------------------------

ObjectLoad:
		lea	(LevelObjectsList).w,a1
		move.w	#$5F,d0

loc_8B7A:
		tst.b	(a1)
		beq.s	locret_8B86
		lea	size(a1),a1
		dbf	d0,loc_8B7A

locret_8B86:
		rts
; ---------------------------------------------------------------------------

LoadNextObject:
		movea.l	a0,a1
		move.w	#$F000,d0
		sub.w	a0,d0
		lsr.w	#6,d0
		subq.w	#1,d0
		bcs.s	locret_8BA2

loc_8B96:
		tst.b	(a1)
		beq.s	locret_8BA2
		lea	size(a1),a1
		dbf	d0,loc_8B96

locret_8BA2:
		rts
; ---------------------------------------------------------------------------

ObjChopper:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_8BB6(pc,d0.w),d1
		jsr	off_8BB6(pc,d1.w)
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_8BB6:	dc.w loc_8BBA-off_8BB6, loc_8BF0-off_8BB6
; ---------------------------------------------------------------------------

loc_8BBA:
		addq.b	#2,$24(a0)
		move.l	#MapChopper,4(a0)
		move.w	#$47B,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#9,$20(a0)
		move.b	#$10,$18(a0)
		move.w	#$F900,$12(a0)
		move.w	$C(a0),$30(a0)

loc_8BF0:
		lea	(AniChopper).l,a1
		bsr.w	ObjectAnimate
		bsr.w	SpeedToPos
		addi.w	#$18,$12(a0)
		move.w	$30(a0),d0
		cmp.w	$C(a0),d0
		bcc.s	loc_8C18
		move.w	d0,$C(a0)
		move.w	#$F900,$12(a0)

loc_8C18:
		move.b	#1,$1C(a0)
		subi.w	#$C0,d0
		cmp.w	$C(a0),d0
		bcc.s	locret_8C3A
		move.b	#0,$1C(a0)
		tst.w	$12(a0)
		bmi.s	locret_8C3A
		move.b	#2,$1C(a0)

locret_8C3A:
		rts
; ---------------------------------------------------------------------------
		include "levels\GHZ\Chopper\Sprite.ani"
		even
		include "levels\GHZ\Chopper\Sprite.map"
		even

                include "_incObj\2C Jaws.asm"
		include "_anim\Jaws.asm"
		include "_maps\Jaws.asm"
		even

                include "_incObj\2D Burrobot.asm"
		include "levels\LZ\Burrobot\Sprite.ani"
		even
		include "levels\LZ\Burrobot\Sprite.map"
		even
; ---------------------------------------------------------------------------

SolidObject:
		;cmpi.b	#6,(v_objspace+$24).w
		;bcc.w	loc_A2FE
		tst.b	subact(a0)	; is Sonic standing on the object?
		beq.w	loc_A37C	; if not, branch
		move.w	d1,d2
		add.w	d2,d2
		lea	(v_objspace).w,a1
		btst	#1,status(a1)
		bne.s	loc_A2EE
		move.w	8(a1),d0
		sub.w	8(a0),d0
		add.w	d1,d0
		bmi.s	loc_A2EE
		cmp.w	d2,d0
		bcs.s	loc_A302

loc_A2EE:
		bclr	#3,status(a1)
		bclr	#3,status(a0)
		clr.b	subact(a0)

loc_A2FE:
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_A302:
		move.w	d4,d2
		bsr.w	PtfmSurfaceHeight
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_A30C:
		tst.w	(DebugRoutine).w
		bne.w	loc_A448
		tst.b	render(a0)
		bpl.w	loc_A42E
		lea	(v_objspace).w,a1
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.w	loc_A42E
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.w	loc_A42E
		move.w	d0,d5
		btst	#0,render(a0)
		beq.s	loc_A346
		not.w	d5
		add.w	d3,d5

loc_A346:
		lsr.w	#1,d5
		moveq	#0,d3
		move.b	(a2,d5.w),d3
		sub.b	(a2),d3
		move.w	ypos(a0),d5
		sub.w	d3,d5
		move.b	yrad(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	ypos(a1),d3
		sub.w	d5,d3
		addq.w	#4,d3
		add.w	d2,d3
		bmi.w	loc_A42E
		subq.w	#4,d3
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bcc.w	loc_A42E
		bra.w	loc_A3CC
; ---------------------------------------------------------------------------

loc_A37C:
		tst.w	(DebugRoutine).w
		bne.w	loc_A448
		tst.b	render(a0)
		bpl.w	loc_A42E
		lea	(v_objspace).w,a1
		move.w	xpos(a1),d0
		sub.w	xpos(a0),d0
		add.w	d1,d0
		bmi.w	loc_A42E
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.w	loc_A42E
		move.b	yrad(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	ypos(a1),d3
		sub.w	ypos(a0),d3
		addq.w	#4,d3
		add.w	d2,d3
		bmi.w	loc_A42E
		subq.w	#4,d3
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bcc.w	loc_A42E

loc_A3CC:
		move.w	d0,d5
		cmp.w	d0,d1
		bcc.s	loc_A3DA
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5
		neg.w	d5

loc_A3DA:
		move.w	d3,d1
		cmp.w	d3,d2
		bcc.s	loc_A3E6
		sub.w	d4,d3
		move.w	d3,d1
		neg.w	d1

loc_A3E6:
		cmp.w	d1,d5
		bhi.w	loc_A44C
		tst.w	d0
		beq.s	loc_A40C
		bmi.s	loc_A3FA
		tst.w	xvel(a1)
		bmi.s	loc_A40C
		bra.s	loc_A400
; ---------------------------------------------------------------------------

loc_A3FA:
		tst.w	xvel(a1)
		bpl.s	loc_A40C

loc_A400:
		move.w	#0,inertia(a1)
		move.w	#0,xvel(a1)

loc_A40C:
		sub.w	d0,8(a1)
		btst	#1,status(a1)
		bne.s	loc_A428
		bset	#5,status(a1)
		bset	#5,status(a0)
		moveq	#1,d4
		rts
; ---------------------------------------------------------------------------

loc_A428:
		bsr.s	sub_A43C
		moveq	#1,d4
		rts
; ---------------------------------------------------------------------------

loc_A42E:
		btst	#5,status(a0)
		beq.s	loc_A448
		move.w	#1,ani(a1)
; ---------------------------------------------------------------------------

sub_A43C:
		bclr	#5,status(a0)
		bclr	#5,status(a1)

loc_A448:
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_A44C:
		tst.w	d3
		bmi.s	loc_A458

loc_A450:
		cmpi.w	#$10,d3
		bcs.s	loc_A488
		bra.s	loc_A42E
; ---------------------------------------------------------------------------

loc_A458:
		tst.w	yvel(a1)
		beq.s	loc_A472
		bpl.s	loc_A46E
		tst.w	d3
		bpl.s	loc_A46E
		sub.w	d3,ypos(a1)
		move.w	#0,yvel(a1)

loc_A46E:
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

loc_A472:
		btst	#1,status(a1)
		bne.s	loc_A46E
		move.l	a0,-(sp)
		movea.l	a1,a0
		bsr.w	loc_FD78
		movea.l	(sp)+,a0
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

loc_A488:
		moveq	#0,d1
		move.b	xdisp(a0),d1
		addq.w	#4,d1
		move.w	d1,d2
		add.w	d2,d2
		add.w	xpos(a1),d1
		sub.w	xpos(a0),d1
		bmi.s	loc_A4C4
		cmp.w	d2,d1
		bcc.s	loc_A4C4
		tst.w	yvel(a1)
		bmi.s	loc_A4C4
		sub.w	d3,ypos(a1)
		subq.w	#1,ypos(a1)
		bsr.w	loc_4FD4
		move.b	#2,subact(a0)
		bset	#3,status(a0)
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

loc_A4C4:
		moveq	#0,d4
		rts
; ===========================================================================
; Level Order
; ===========================================================================
		; remove this whenever possible
		include "_incObj\sub RememberState.asm"
		;include "_incObj\40 Motobug.asm"
		even
; ---------------------------------------------------------------------------

ObjLavaMaker:
		moveq	#0,d0
		move.b	act(a0),d0
		move.w	off_C1D0(pc,d0.w),d1
		jsr	off_C1D0(pc,d1.w)
		bra.w	loc_C2E6
; ---------------------------------------------------------------------------

off_C1D0:	dc.w loc_C1DA-off_C1D0, loc_C1FA-off_C1D0

byte_C1D4:	dc.b $1E, $3C, $5A, $78, $96, $B4
; ---------------------------------------------------------------------------

loc_C1DA:
		addq.b	#2,act(a0)
		move.b	arg(a0),d0
		lsr.w	#4,d0
		andi.w	#$F,d0
		move.b	byte_C1D4(pc,d0.w),$1F(a0)
		move.b	$1F(a0),$1E(a0)
		andi.b	#$F,arg(a0)

loc_C1FA:
		subq.b	#1,$1E(a0)
		bne.s	locret_C22A
		move.b	$1F(a0),$1E(a0)
		bsr.w	ObjectChkOffscreen
		bne.s	locret_C22A
		bsr.w	ObjectLoad
		bne.s	locret_C22A
		move.b	#$14,id(a1)
		move.w	xpos(a0),xpos(a1)
		move.w	ypos(a0),ypos(a1)
		move.b	arg(a0),arg(a1)

locret_C22A:
		rts
; ---------------------------------------------------------------------------

ObjLavaball:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_C23E(pc,d0.w),d1
		jsr	off_C23E(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_C23E:	dc.w loc_C254-off_C23E, loc_C2C8-off_C23E, j_DeleteObject-off_C23E

word_C244:	dc.w $FC00, $FB00, $FA00, $F900, $FE00, $200, $FE00, $200
; ---------------------------------------------------------------------------

loc_C254:
		addq.b	#2,act(a0)
		move.b	#8,yrad(a0)
		move.b	#8,xrad(a0)
		move.l	#MapLavaball,map(a0)
		move.w	#$345,tile(a0)
		move.b	#4,render(a0)
		move.b	#3,prio(a0)
		move.b	#$8B,col(a0)
		move.w	ypos(a0),$30(a0)
		moveq	#0,d0
		move.b	arg(a0),d0
		add.w	d0,d0
		move.w	word_C244(pc,d0.w),yvel(a0)
		move.b	#8,xdisp(a0)
		cmpi.b	#6,arg(a0)
		bcs.s	loc_C2BE
		move.b	#$10,xdisp(a0)
		move.b	#2,ani(a0)
		move.w	yvel(a0),xvel(a0)
		move.w	#0,yvel(a0)

loc_C2BE:
		move.w	#$AE,d0
		jsr	(PlaySFX).l

loc_C2C8:
		moveq	#0,d0
		move.b	arg(a0),d0
		add.w	d0,d0
		move.w	off_C306(pc,d0.w),d1
		jsr	off_C306(pc,d1.w)
		bsr.w	SpeedToPos
		lea	(AniLavaball).l,a1
		bsr.w	ObjectAnimate

loc_C2E6:
		move.w	xpos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

off_C306:	dc.w loc_C318-off_C306, loc_C318-off_C306, loc_C318-off_C306, loc_C318-off_C306, loc_C340-off_C306
		dc.w loc_C362-off_C306, loc_C384-off_C306, loc_C3A8-off_C306, locret_C3CC-off_C306
; ---------------------------------------------------------------------------

loc_C318:
		addi.w	#$18,yvel(a0)
		move.w	$30(a0),d0
		cmp.w	ypos(a0),d0
		bcc.s	loc_C32C
		addq.b	#2,act(a0)

loc_C32C:
		bclr	#1,status(a0)
		tst.w	yvel(a0)
		bpl.s	locret_C33E
		bset	#1,status(a0)

locret_C33E:
		rts
; ---------------------------------------------------------------------------

loc_C340:
		bset	#1,status(a0)
		bsr.w	ObjectHitCeiling
		tst.w	d1
		bpl.s	locret_C360
		move.b	#8,arg(a0)
		move.b	#1,ani(a0)
		move.w	#0,yvel(a0)

locret_C360:
		rts
; ---------------------------------------------------------------------------

loc_C362:
		bclr	#1,status(a0)
		bsr.w	ObjectHitFloor
		tst.w	d1
		bpl.s	locret_C382
		move.b	#8,arg(a0)
		move.b	#1,ani(a0)
		move.w	#0,yvel(a0)

locret_C382:
		rts
; ---------------------------------------------------------------------------

loc_C384:
		bset	#0,status(a0)
		moveq	#-8,d3
		bsr.w	ObjectHitWallLeft
		tst.w	d1
		bpl.s	locret_C3A6
		move.b	#8,arg(a0)
		move.b	#3,ani(a0)
		move.w	#0,xvel(a0)

locret_C3A6:
		rts
; ---------------------------------------------------------------------------

loc_C3A8:
		bclr	#0,status(a0)
		moveq	#8,d3
		bsr.w	ObjectHitWallRight
		tst.w	d1
		bpl.s	locret_C3CA
		move.b	#8,arg(a0)
		move.b	#3,ani(a0)
		move.w	#0,xvel(a0)

locret_C3CA:
		rts
; ---------------------------------------------------------------------------

locret_C3CC:
		rts
; ---------------------------------------------------------------------------
; Attributes: thunk

j_DeleteObject:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------
		include "levels\MZ\LavaBall\Sprite.ani"
		include "levels\MZ\FloorLavaball\Sprite.ani"
		include "levels\MZ\Platform\Sprite.map"
		include "levels\MZ\FloorLavaball\Sprite.map"
		even
; ---------------------------------------------------------------------------
ObjSceneryLamp:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_C538(pc,d0.w),d1
		jmp	off_C538(pc,d1.w)
; ---------------------------------------------------------------------------

off_C538:	dc.w loc_C53C-off_C538, loc_C560-off_C538
; ---------------------------------------------------------------------------

loc_C53C:
		addq.b	#2,$24(a0)
		move.l	#MapSceneryLamp,4(a0)
		move.w	#0,2(a0)
		move.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#6,$19(a0)

loc_C560:
		subq.b	#1,$1E(a0)
		bpl.s	loc_C57E
		move.b	#7,$1E(a0)
		addq.b	#1,$1A(a0)
		cmpi.b	#6,$1A(a0)
		bcs.s	loc_C57E
		move.b	#0,$1A(a0)

loc_C57E:
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
		include "levels\SZ\SceneryLamp\Sprite.map"
		even
; ---------------------------------------------------------------------------
        include "_incObj\0D Signpost.asm"

		include "_anim\Signpost.asm"
		include "_maps\Signpost.asm"
		even
; ---------------------------------------------------------------------------

ObjSonic:
		tst.w	(DebugRoutine).w
		bne.w	Edit
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_E826(pc,d0.w),d1
		jmp	off_E826(pc,d1.w)
; ---------------------------------------------------------------------------

off_E826:	dc.w loc_E830-off_E826, loc_E872-off_E826, Sonic_Hurt-off_E826, Sonic_Death-off_E826
		dc.w Sonic_ResetLevel-off_E826
; ---------------------------------------------------------------------------

loc_E830:
		addq.b	#2,$24(a0)
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		move.l	#MapSonic,4(a0)
		move.w	#$780,2(a0)
		move.b	#2,$19(a0)
		move.b	#$18,$18(a0)
		move.b	#4,1(a0)
		move.w	#$600,(unk_FFF760).w
		move.w	#$C,(unk_FFF762).w
		move.w	#$40,(unk_FFF764).w

loc_E872:
		andi.w	#$7FF,$C(a0)
		andi.w	#$7FF,(v_screenposy).w
		tst.w	(f_debugmode).w
		beq.s	loc_E892
		btst	#4,(v_jpadpress2).w
		beq.s	loc_E892
		move.w	#1,(DebugRoutine).w

loc_E892:
		moveq	#0,d0
		move.b	$22(a0),d0
		andi.w	#6,d0
		move.w	off_E8C8(pc,d0.w),d1
		jsr	off_E8C8(pc,d1.w)
		bsr.s	sub_E8D6
		bsr.w	sub_E952
		bsr.w 	loc_F26A
		move.b	(unk_FFF768).w,$36(a0)
		move.b	(unk_FFF76A).w,$37(a0)
		bsr.w	Sonic_Animate
		bsr.w	TouchObjects
		bsr.w	Sonic_SpecialChunk
		bsr.w	Sonic_DynTiles
		rts
; ---------------------------------------------------------------------------

off_E8C8:	dc.w sub_E96C-off_E8C8, sub_E98E-off_E8C8, loc_E9A8-off_E8C8, loc_E9C6-off_E8C8

MusicList2:	dc.b $81, $82, $83, $84, $85, $86
; ---------------------------------------------------------------------------

sub_E8D6:
		move.w	$30(a0),d0
		beq.s	loc_E8E4
		subq.w	#1,$30(a0)
		lsr.w	#3,d0
		bcc.s	loc_E8E8

loc_E8E4:
		bsr.w	DisplaySprite

loc_E8E8:
		rts
; ---------------------------------------------------------------------------

sub_E952:
		move.w	(unk_FFF7A8).w,d0
		lea	(v_tracksonic).w,a1
		lea	(a1,d0.w),a1
		move.w	8(a0),(a1)+
		move.w	$C(a0),(a1)+
		addq.b	#4,(unk_FFF7A9).w
		rts
; ---------------------------------------------------------------------------

sub_E96C:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_SlopeResist
		bsr.w	Sonic_Move
		bsr.w	Sonic_Roll
		bsr.w	Sonic_LevelBound
		bsr.w	SpeedToPos
		bsr.w	Sonic_AnglePosition
		bsr.w	Sonic_SlopeRepel
		rts
; ---------------------------------------------------------------------------

sub_E98E:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_ChgJumpDirection
		bsr.w	Sonic_LevelBound
		bsr.w	ObjectFall
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_Floor
		rts
; ---------------------------------------------------------------------------

loc_E9A8:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_RollRepel
		bsr.w	Sonic_RollSpeed
		bsr.w	Sonic_LevelBound
		bsr.w	SpeedToPos
		bsr.w	Sonic_AnglePosition
		bsr.w	Sonic_SlopeRepel
		rts
; ---------------------------------------------------------------------------

loc_E9C6:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_ChgJumpDirection
		bsr.w	Sonic_LevelBound
		bsr.w	ObjectFall
		move.b 	#2,$1C(a0) ; roll/jump

		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_Floor
		rts
; ---------------------------------------------------------------------------

Sonic_Move:
		move.w	(unk_FFF760).w,d6
		move.w	(unk_FFF762).w,d5
		move.w	(unk_FFF764).w,d4
		tst.w	$3E(a0)
		bne.w	Sonic_ResetScroll
		btst	#2,(v_jpadhold2).w
		beq.s	Sonic_NoLeft
		bsr.w	Sonic_MoveLeft

Sonic_NoLeft:
		btst	#3,(v_jpadhold2).w
		beq.s	Sonic_NoRight
		bsr.w	Sonic_MoveRight

Sonic_NoRight:
		move.b	$26(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.w	Sonic_ResetScroll
		tst.w	$14(a0)
		bne.w	Sonic_ResetScroll
		bclr	#5,$22(a0)
		move.b	#5,$1C(a0)
		btst	#3,$22(a0)
		beq.s	Sonic_Balance
		moveq	#0,d0
		move.b	$3D(a0),d0
		lsl.w	#6,d0
		lea	(v_objspace).w,a1
		lea	(a1,d0.w),a1
		tst.b	$22(a1)
		bmi.s	Sonic_ResetScroll
		moveq	#0,d1
		move.b	$18(a1),d1
		move.w	d1,d2
		add.w	d2,d2
		subq.w	#4,d2
		add.w	8(a0),d1
		sub.w	8(a1),d1
		cmpi.w	#4,d1
		blt.s	loc_EA92
		cmp.w	d2,d1
		bge.s	loc_EA82
		bra.s	Sonic_ResetScroll
; ---------------------------------------------------------------------------

Sonic_Balance:
		jsr	(ObjectHitFloor).l
		cmpi.w	#$C,d1
		blt.s	Sonic_ResetScroll
		cmpi.b	#3,$36(a0)
		bne.s	loc_EA8A

loc_EA82:
		bclr	#0,$22(a0)
		bra.s	loc_EA98
; ---------------------------------------------------------------------------

loc_EA8A:
		cmpi.b	#3,$37(a0)
		bne.s	Sonic_ResetScroll

loc_EA92:
		bset	#0,$22(a0)

loc_EA98:
		move.b	#6,$1C(a0)
		;bra.s	Sonic_ResetScroll
; ---------------------------------------------------------------------------

Sonic_ResetScroll:
		cmpi.w	#$60,(unk_FFF73E).w
		beq.s	loc_EAEA
		bcc.s	loc_EAE6
		addq.w	#4,(unk_FFF73E).w

loc_EAE6:
		subq.w	#2,(unk_FFF73E).w

loc_EAEA:
		move.b	(v_jpadhold2).w,d0
		andi.b	#$C,d0
		bne.s	loc_EB16
		move.w	$14(a0),d0
		beq.s	loc_EB16
		bmi.s	loc_EB0A
		sub.w	d5,d0
		bcc.s	loc_EB04
		move.w	#0,d0

loc_EB04:
		move.w	d0,$14(a0)
		bra.s	loc_EB16
; ---------------------------------------------------------------------------

loc_EB0A:
		add.w	d5,d0
		bcc.s	loc_EB12
		move.w	#0,d0

loc_EB12:
		move.w	d0,$14(a0)

loc_EB16:
		move.b	$26(a0),d0
		jsr	(GetSine).l
		muls.w	$14(a0),d1
		asr.l	#8,d1
		move.w	d1,$10(a0)
		muls.w	$14(a0),d0
		asr.l	#8,d0
		move.w	d0,$12(a0)

loc_EB34:
		move.b	#$40,d1
		tst.w	$14(a0)
		beq.s	locret_EB8E
		bmi.s	loc_EB42
		neg.w	d1

loc_EB42:
		move.b	$26(a0),d0
		add.b	d1,d0
		move.w	d0,-(sp)
		bsr.w	Sonic_WalkSpeed
		move.w	(sp)+,d0
		tst.w	d1
		bpl.s	locret_EB8E
		move.w	#0,$14(a0)
		bset	#5,$22(a0)
		asl.w	#8,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	loc_EB8A
		cmpi.b	#$40,d0
		beq.s	loc_EB84
		cmpi.b	#$80,d0
		beq.s	loc_EB7E
		add.w	d1,$10(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB7E:
		sub.w	d1,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB84:
		sub.w	d1,$10(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB8A:
		add.w	d1,$12(a0)

locret_EB8E:
		rts
; ---------------------------------------------------------------------------

Sonic_MoveLeft:
		move.w	$14(a0),d0
		beq.s	loc_EB98
		bpl.s	loc_EBC4

loc_EB98:
		bset	#0,$22(a0)
		bne.s	loc_EBAC
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)

loc_EBAC:
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_EBB8
		move.w	d1,d0

loc_EBB8:
		move.w	d0,$14(a0)
		move.b	#0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_EBC4:
		sub.w	d4,d0
		bcc.s	loc_EBCC
		move.w	#$FF80,d0

loc_EBCC:
		move.w	d0,$14(a0)
		move.b	$26(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_EBFA
		cmpi.w	#$400,d0
		blt.s	locret_EBFA
		move.b	#$D,$1C(a0)
		bclr	#0,$22(a0)
		move.w	#$A4,d0
		jsr	(PlaySFX).l

locret_EBFA:
		rts
; ---------------------------------------------------------------------------

Sonic_MoveRight:
		move.w	$14(a0),d0
		bmi.s	loc_EC2A
		bclr	#0,$22(a0)
		beq.s	loc_EC16
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)

loc_EC16:
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_EC1E
		move.w	d6,d0

loc_EC1E:
		move.w	d0,$14(a0)
		move.b	#0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_EC2A:
		add.w	d4,d0
		bcc.s	loc_EC32
		move.w	#$80,d0

loc_EC32:
		move.w	d0,$14(a0)
		move.b	$26(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_EC60
		cmpi.w	#$FC00,d0
		bgt.s	locret_EC60
		move.b	#$D,$1C(a0)
		bset	#0,$22(a0)
		move.w	#$A4,d0
		jsr	(PlaySFX).l

locret_EC60:
		rts
; ---------------------------------------------------------------------------

Sonic_RollSpeed:
		move.w	(unk_FFF760).w,d6
		asl.w	#1,d6
		move.w	(unk_FFF762).w,d5
		asr.w	#1,d5
		move.w	(unk_FFF764).w,d4
		asr.w	#2,d4
		tst.w	$3E(a0)
		bne.s	loc_EC92
		btst	#2,(v_jpadhold2).w
		beq.s	loc_EC86
		bsr.w	Sonic_RollLeft

loc_EC86:
		btst	#3,(v_jpadhold2).w
		beq.s	loc_EC92
		bsr.w	Sonic_RollRight

loc_EC92:
		move.w	$14(a0),d0
		beq.s	loc_ECB4
		bmi.s	loc_ECA8
		sub.w	d5,d0
		bcc.s	loc_ECA2
		move.w	#0,d0

loc_ECA2:
		move.w	d0,$14(a0)
		bra.s	loc_ECB4
; ---------------------------------------------------------------------------

loc_ECA8:
		add.w	d5,d0
		bcc.s	loc_ECB0
		move.w	#0,d0

loc_ECB0:
		move.w	d0,$14(a0)

loc_ECB4:
		tst.w	$14(a0)
		bne.s	loc_ECD6
		bclr	#2,$22(a0)
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		move.b	#5,$1C(a0)
		subq.w	#5,$C(a0)

loc_ECD6:
		move.b	$26(a0),d0
		jsr	(GetSine).l
		muls.w	$14(a0),d1
		asr.l	#8,d1
		move.w	d1,$10(a0)
		muls.w	$14(a0),d0
		asr.l	#8,d0
		move.w	d0,$12(a0)
		bra.w	loc_EB34
; ---------------------------------------------------------------------------

Sonic_RollLeft:
		move.w	$14(a0),d0
		beq.s	loc_ED00
		bpl.s	loc_ED0E

loc_ED00:
		bset	#0,$22(a0)
		move.b	#2,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_ED0E:
		sub.w	d4,d0
		bcc.s	loc_ED16
		move.w	#$FF80,d0

loc_ED16:
		move.w	d0,$14(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_RollRight:
		move.w	$14(a0),d0
		bmi.s	loc_ED30
		bclr	#0,$22(a0)
		move.b	#2,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_ED30:
		add.w	d4,d0
		bcc.s	loc_ED38
		move.w	#$80,d0

loc_ED38:
		move.w	d0,$14(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_ChgJumpDirection:
		move.w	(unk_FFF760).w,d6
		move.w	(unk_FFF762).w,d5
		asl.w	#1,d5
		btst	#4,$22(a0)
		bne.s	Sonic_ResetScroll2
		move.w	$10(a0),d0
		btst	#2,(v_jpadhold1).w
		beq.s	loc_ED6E
		;bset	#0,$22(a0)
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_ED6E
		move.w	d1,d0

loc_ED6E:
		btst	#3,(v_jpadhold1).w
		beq.s	Sonic_JumpMove
		;bclr	#0,$22(a0)
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	Sonic_JumpMove
		move.w	d6,d0

Sonic_JumpMove:
		move.w	d0,$10(a0)

Sonic_ResetScroll2:
		cmpi.w	#$60,(unk_FFF73E).w
		beq.s	loc_ED9A
		bcc.s	loc_ED96
		addq.w	#4,(unk_FFF73E).w

loc_ED96:
		subq.w	#2,(unk_FFF73E).w

loc_ED9A:
		cmpi.w	#$FC00,$12(a0)
		bcs.s	locret_EDC8
		move.w	$10(a0),d0
		move.w	d0,d1
		asr.w	#5,d1
		beq.s	locret_EDC8
		bmi.s	loc_EDBC
		sub.w	d1,d0
		bcc.s	loc_EDB6
		move.w	#0,d0

loc_EDB6:
		move.w	d0,$10(a0)
		rts
; ---------------------------------------------------------------------------

loc_EDBC:
		sub.w	d1,d0
		bcs.s	loc_EDC4
		move.w	#0,d0

loc_EDC4:
		move.w	d0,$10(a0)

locret_EDC8:
		rts
; ---------------------------------------------------------------------------

Sonic_Squish:
		move.b	$26(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_EDF8
		bsr.w	Sonic_NoRunningOnWalls
		tst.w	d1
		bpl.s	locret_EDF8
		move.w	#0,$14(a0)
		move.w	#0,$10(a0)
		move.w	#0,$12(a0)
		move.b	#$B,$1C(a0)

locret_EDF8:
		rts
; ---------------------------------------------------------------------------

Sonic_LevelBound:
		move.l	8(a0),d1
		move.w	$10(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	(unk_FFF728).w,d0
		addi.w	#$10,d0
		cmp.w	d1,d0
		bhi.s	Sonic_BoundSides
		move.w	(unk_FFF72A).w,d0
		addi.w	#$128,d0
		cmp.w	d1,d0
		bls.s	Sonic_BoundSides
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$C(a0),d0
		bcs.w	loc_FD78
		rts
; ---------------------------------------------------------------------------

Sonic_BoundSides:
		move.w	d0,8(a0)
		move.w	#0,$A(a0)
		move.w	#0,$10(a0)
		move.w	#0,$14(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_Roll:
		move.w	$14(a0),d0
		bpl.s	loc_EE54
		neg.w	d0

loc_EE54:
		cmpi.w	#$80,d0
		bcs.s	locret_EE6C
		move.b	(v_jpadhold2).w,d0
		andi.b	#$C,d0
		bne.s	locret_EE6C
		btst	#1,(v_jpadhold2).w
		bne.s	Sonic_CheckRoll

locret_EE6C:
		rts
; ---------------------------------------------------------------------------

Sonic_CheckRoll:
		btst	#2,$22(a0)
		beq.s	Sonic_DoRoll
		rts
; ---------------------------------------------------------------------------

Sonic_DoRoll:
		bset	#2,$22(a0)
		move.b	#$E,$16(a0)
		move.b	#7,$17(a0)
		move.b	#2,$1C(a0)
		addq.w	#5,$C(a0)
		move.w	#$A9,d0
		jsr	(PlaySFX).l
		tst.w	$14(a0)
		bne.s	locret_EEAA
		move.w	#$200,$14(a0)

locret_EEAA:
		rts
; ---------------------------------------------------------------------------

Sonic_Jump:
		move.b	(v_jpadpress2).w,d0
		andi.b	#$70,d0
		beq.w	locret_EF46
		moveq	#0,d0
		move.b	$26(a0),d0
		addi.b	#-$80,d0
		bsr.w	sub_10520
		cmpi.w	#6,d1
		blt.w	locret_EF46
		moveq	#0,d0
		move.b	$26(a0),d0
		subi.b	#$40,d0
		jsr	(GetSine).l
		muls.w	#$680,d1
		asr.l	#8,d1
		add.w	d1,$10(a0)
		muls.w	#$680,d0
		asr.l	#8,d0
		add.w	d0,$12(a0)
		bset	#1,$22(a0)
		bclr	#5,$22(a0)
		addq.l	#4,sp
		move.b	#1,$3C(a0)
		move.w	#$A0,d0
		jsr	(PlaySFX).l
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		;tst.b	(f_victory).w ; has the victory animation flag been set?
		;bne.s	loc_EF48 ; if not, branch
		btst	#2,$22(a0) ; use "victory leaping" animation
		bne.s	loc_EF50
		move.b	#$E,$16(a0)
		move.b	#7,$17(a0)
		;move.b	#2,$1C(a0) ; use "jumping" animation
		bset	#2,$22(a0)
		addq.w	#5,$C(a0)

locret_EF46:
		rts
; ---------------------------------------------------------------------------

loc_EF48:
		move.b	#$13,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_EF50:
		bset	#4,$22(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_JumpHeight:
		tst.b	$3C(a0)
		beq.s	loc_EF78
		cmpi.w	#$FC00,$12(a0)
		bge.s	locret_EF76
		move.b	(v_jpadhold2).w,d0
		andi.b	#$70,d0
		bne.s	locret_EF76
		move.w	#$FC00,$12(a0)

locret_EF76:
		rts
; ---------------------------------------------------------------------------

loc_EF78:
		cmpi.w	#$F040,$12(a0)
		bge.s	locret_EF86
		move.w	#$F040,$12(a0)

locret_EF86:
		rts
; ---------------------------------------------------------------------------

Sonic_SlopeResist:
		move.b	$26(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_EFBC
		move.b	$26(a0),d0
		jsr	(GetSine).l
		muls.w	#$20,d0
		asr.l	#8,d0
		tst.w	$14(a0)
		beq.s	locret_EFBC
		bmi.s	loc_EFB8
		tst.w	d0
		beq.s	locret_EFB6
		add.w	d0,$14(a0)

locret_EFB6:
		rts
; ---------------------------------------------------------------------------

loc_EFB8:
		add.w	d0,$14(a0)

locret_EFBC:
		rts
; ---------------------------------------------------------------------------

Sonic_RollRepel:
		move.b	$26(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_EFF8
		move.b	$26(a0),d0
		jsr	(GetSine).l
		muls.w	#$50,d0
		asr.l	#8,d0
		tst.w	$14(a0)
		bmi.s	loc_EFEE
		tst.w	d0
		bpl.s	loc_EFE8
		asr.l	#2,d0

loc_EFE8:
		add.w	d0,$14(a0)
		rts
; ---------------------------------------------------------------------------

loc_EFEE:
		tst.w	d0
		bmi.s	loc_EFF4
		asr.l	#2,d0

loc_EFF4:
		add.w	d0,$14(a0)

locret_EFF8:
		rts
; ---------------------------------------------------------------------------

Sonic_SlopeRepel:
		nop
		tst.w	$3E(a0)
		bne.s	loc_F02C
		move.b	$26(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	locret_F02A
		move.w	$14(a0),d0
		bpl.s	loc_F018
		neg.w	d0

loc_F018:
		cmpi.w	#$280,d0
		bcc.s	locret_F02A
		bset	#1,$22(a0)
		move.w	#$1E,$3E(a0)

locret_F02A:
		rts
; ---------------------------------------------------------------------------

loc_F02C:
		subq.w	#1,$3E(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_JumpAngle:
		move.b	$26(a0),d0
		beq.s	locret_F04C
		bpl.s	loc_F042
		addq.b	#2,d0
		bcc.s	loc_F040
		moveq	#0,d0

loc_F040:
		bra.s	loc_F048
; ---------------------------------------------------------------------------

loc_F042:
		subq.b	#2,d0
		bcc.s	loc_F048
		moveq	#0,d0

loc_F048:
		move.b	d0,$26(a0)

locret_F04C:
		rts
; ---------------------------------------------------------------------------

Sonic_Floor:
		move.w	$10(a0),d1
		move.w	$12(a0),d2
		jsr	(CalcAngle).l
		subi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	loc_F104
		cmpi.b	#$80,d0
		beq.w	loc_F160
		cmpi.b	#$C0,d0
		beq.w	loc_F1BC

loc_F07C:		
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_F08E
		sub.w	d1,8(a0)
		move.w	#0,$10(a0)

loc_F08E:
		bsr.w	sub_1068C
		tst.w	d1
		bpl.s	loc_F0A0
		add.w	d1,8(a0)
		move.w	#0,$10(a0)

loc_F0A0:
		bsr.w	Sonic_HitFloor
		tst.w	d1
		bpl.s	locret_F102
		move.b	$12(a0),d0
		addq.b	#8,d0
		neg.b	d0
		cmp.b	d0,d1
		blt.s	locret_F102
		add.w	d1,$C(a0)
		move.b	d3,$26(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#0,$1C(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_F0E0
		move.w	#0,$12(a0)
		move.w	$10(a0),$14(a0)
		rts
; ---------------------------------------------------------------------------

loc_F0E0:
		move.w	#0,$10(a0)
		cmpi.w	#$FC0,$12(a0)
		ble.s	loc_F0F4
		move.w	#$FC0,$12(a0)

loc_F0F4:
		move.w	$12(a0),$14(a0)
		tst.b	d3
		bpl.s	locret_F102
		neg.w	$14(a0)

locret_F102:
		rts
; ---------------------------------------------------------------------------

loc_F104:
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_F11E
		sub.w	d1,8(a0)
		move.w	#0,$10(a0)
		move.w	$12(a0),$14(a0)
		rts
; ---------------------------------------------------------------------------

loc_F11E:
		bsr.w	Sonic_NoRunningOnWalls
		tst.w	d1
		bpl.s	loc_F132
		sub.w	d1,$C(a0)
		move.w	#0,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_F132:
		tst.w	$12(a0)
		bmi.s	locret_F15E
		bsr.w	Sonic_HitFloor
		tst.w	d1
		bpl.s	locret_F15E
		add.w	d1,$C(a0)
		move.b	d3,$26(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#0,$1C(a0)
		move.w	#0,$12(a0)
		move.w	$10(a0),$14(a0)

locret_F15E:
		rts
; ---------------------------------------------------------------------------

loc_F160:
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_F172
		sub.w	d1,8(a0)
		move.w	#0,$10(a0)

loc_F172:
		bsr.w	sub_1068C
		tst.w	d1
		bpl.s	loc_F184
		add.w	d1,8(a0)
		move.w	#0,$10(a0)

loc_F184:
		bsr.w	Sonic_NoRunningOnWalls
		tst.w	d1
		bpl.s	locret_F1BA
		sub.w	d1,$C(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_F1A4
		move.w	#0,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_F1A4:
		move.b	d3,$26(a0)
		bsr.w	Sonic_ResetOnFloor
		move.w	$12(a0),$14(a0)
		tst.b	d3
		bpl.s	locret_F1BA
		neg.w	$14(a0)

locret_F1BA:
		rts
; ---------------------------------------------------------------------------

loc_F1BC:
		bsr.w	sub_1068C
		tst.w	d1
		bpl.s	loc_F1D6
		add.w	d1,8(a0)
		move.w	#0,$10(a0)
		move.w	$12(a0),$14(a0)
		rts
; ---------------------------------------------------------------------------

loc_F1D6:
		bsr.w	Sonic_NoRunningOnWalls
		tst.w	d1
		bpl.s	loc_F1EA
		sub.w	d1,$C(a0)
		move.w	#0,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_F1EA:
		tst.w	$12(a0)
		bmi.s	locret_F216
		bsr.w	Sonic_HitFloor
		tst.w	d1
		bpl.s	locret_F216
		add.w	d1,$C(a0)
		move.b	d3,$26(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#0,$1C(a0)
		move.w	#0,$12(a0)
		move.w	$10(a0),$14(a0)

locret_F216:
		rts
; ---------------------------------------------------------------------------

Sonic_ResetOnFloor:
		btst	#4,$22(a0)
		beq.s	loc_F226
		nop
		nop
		nop
loc_F226:
		bclr	#5,$22(a0)
		bclr	#1,$22(a0)
		bclr	#4,$22(a0)
		btst	#2,$22(a0)
		beq.s	loc_F25C
		bclr	#2,$22(a0)
		move.b	#$13,$16(a0)
		move.b	#9,$17(a0)
		move.b	#0,$1C(a0)
		subq.w	#5,$C(a0)

loc_F25C:
		move.w	#0,$3E(a0)
		move.b	#0,$3C(a0)
		rts
; ---------------------------------------------------------------------------
loc_F26A:                                 ; Gets Sonic's XY position and adds it to the early debug seen in CC.
		lea	(v_objspace+$400).w,a1
		move.w	8(a0),d0
		bsr.w	sub_F290
		lea	(v_objspace+$500).w,a1
		move.w	$C(a0),d0
		bsr.w	sub_F290
		lea	(v_objspace+$600).w,a1
		move.w	$14(a0),d0
		bsr.w	sub_F290
		rts
; ---------------------------------------------------------------------------

sub_F290:
		swap	d0
		rol.l	#4,d0
		andi.b	#$F,d0
		move.b	d0,$1A(a1)
		rol.l	#4,d0
		andi.b	#$F,d0
		move.b	d0,$5A(a1)
		rol.l	#4,d0
		andi.b	#$F,d0
		move.b	d0,$9A(a1)
		rol.l	#4,d0
		andi.b	#$F,d0
		move.b	d0,$DA(a1)
		rts
; ---------------------------------------------------------------------------

Sonic_Hurt:
		bsr.w	Sonic_HurtStop
		bsr.w	SpeedToPos
		addi.w	#$30,$12(a0)
		bsr.w	Sonic_LevelBound
		bsr.w	sub_E952
		bsr.w	Sonic_Animate
		bsr.w	Sonic_DynTiles
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

Sonic_HurtStop:
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$C(a0),d0
		bcs.w	loc_FD78
		bsr.w	loc_F07C
		btst	#1,$22(a0)
		bne.s	locret_F318
		moveq	#0,d0
		move.w	d0,$12(a0)
		move.w	d0,$10(a0)
		move.w	d0,$14(a0)
		move.b	#0,$1C(a0)
		subq.b	#2,$24(a0)
		move.w	#$78,$30(a0)

locret_F318:
		rts
; ---------------------------------------------------------------------------

Sonic_Death:
		bsr.w	loc_F388
		bsr.w	ObjectFall
		bsr.w	sub_E952
		bsr.w	Sonic_Animate
		bsr.w	Sonic_DynTiles
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

Sonic_GameOver:
		move.w	(unk_FFF72E).w,d0
		addi.w	#$100,d0
		cmp.w	$C(a0),d0
		bcc.w	locret_F3AE
		move.w	#$FFC8,$12(a0)
		addq.b	#2,$24(a0)
		addq.b	#1,(byte_FFFE1C).w
		subq.b	#1,(v_lives).w
		bne.s	loc_F380
		move.w	#0,$3A(a0)
		move.b	#$39,(v_objspace+$80).w
		move.b	#$39,(v_objspace+$C0).w
		move.b	#1,(v_objspace+$DA).w
		move.w	#$8F,d0
		jsr	(PlaySFX).l
		moveq	#3,d0
		jmp	(plcAdd).l
; ---------------------------------------------------------------------------

loc_F380:
		move.w	#$3C,$3A(a0)
		;rts
; ---------------------------------------------------------------------------
loc_F388:
		move.b	(v_jpadpress2).w,d0
		andi.b	#$70,d0
		beq.s	locret_F3AE
		andi.b	#$40,d0
		bne.s	loc_F3B0
		move.b	#0,$1C(a0)	; Respawns you after a death
		subq.b	#4,$24(a0)	; The lines above seem to make the code do nothing
		move.w	$38(a0),$C(a0)
		move.w	#$78,$30(a0)

locret_F3AE:
		rts
; ---------------------------------------------------------------------------

loc_F3B0:
		move.w	#1,(LevelRestart).w
		rts
; ---------------------------------------------------------------------------

Sonic_ResetLevel:
		tst.w	$3A(a0)
		beq.s	locret_F3CA
		subq.w	#1,$3A(a0)
		bne.s	locret_F3CA
		move.w	#1,(LevelRestart).w

locret_F3CA:
		rts
; ---------------------------------------------------------------------------
		dc.b $12, 9, $A, $12, 9, $A, $12, 9, $A, $12, 9, $A, $12 ; To be decompiled.
		dc.b 9, $A, $12, 9, $12, $E, 7, $A, $E, 7, $A
; ---------------------------------------------------------------------------

Sonic_SpecialChunk:
		;cmpi.b	#3,(v_zone).w
		;beq.s	loc_F3F4
		tst.b	(v_zone).w
		bne.w	locret_F490

loc_F3F4:
		move.w	$C(a0),d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.w	8(a0),d1
		move.w	d1,d2
		lsr.w	#8,d1
		andi.w	#$7F,d1
		add.w	d1,d0
		lea	(v_lvllayout).w,a1
		move.b	(a1,d0.w),d1
		;cmp.b	(unk_FFF7AE).w,d1
		;beq.w	Sonic_CheckRoll
		;cmp.b	(unk_FFF7AF).w,d1
		;beq.w	Sonic_CheckRoll
		cmp.b	(unk_FFF7AC).w,d1
		beq.s	loc_F448
		cmp.b	(unk_FFF7AD).w,d1
		beq.s	loc_F438
		bclr	#6,1(a0)
		rts
; ---------------------------------------------------------------------------

loc_F438:
		btst	#1,$22(a0)
		beq.s	loc_F448
		bclr	#6,1(a0)
		rts
; ---------------------------------------------------------------------------

loc_F448:
		cmpi.b	#$2C,d2
		bcc.s	loc_F456
		bclr	#6,1(a0)
		rts
; ---------------------------------------------------------------------------

loc_F456:
		cmpi.b	#$E0,d2
		bcs.s	loc_F464
		bset	#6,1(a0)
		rts
; ---------------------------------------------------------------------------

loc_F464:
		btst	#6,1(a0)
		bne.s	loc_F480
		move.b	$26(a0),d1
		beq.s	locret_F490
		cmpi.b	#$80,d1
		bhi.s	locret_F490
		bset	#6,1(a0)
		rts
; ---------------------------------------------------------------------------

loc_F480:
		move.b	$26(a0),d1
		cmpi.b	#$80,d1
		bls.s	locret_F490
		bclr	#6,1(a0)

locret_F490:
		rts
; ---------------------------------------------------------------------------

Sonic_Animate:
		lea	(AniSonic).l,a1
		moveq	#0,d0
		move.b	$1C(a0),d0
		cmp.b	$1D(a0),d0
		beq.s	Sonic_AnimDo
		move.b	d0,$1D(a0)
		move.b	#0,$1B(a0)
		move.b	#0,$1E(a0)

Sonic_AnimDo:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		move.b	(a1),d0
		bmi.s	Sonic_AnimateCmd
		move.b	$22(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,1(a0)
		or.b	d1,1(a0)
		subq.b	#1,$1E(a0)
		bpl.s	Sonic_AnimDelay
		move.b	d0,$1E(a0)
; ---------------------------------------------------------------------------

Sonic_AnimDo2:
		moveq	#0,d1
		move.b	$1B(a0),d1
		move.b	1(a1,d1.w),d0
		bmi.s	Sonic_AnimEndFF

Sonic_AnimNext:
		move.b	d0,$1A(a0)
		addq.b	#1,$1B(a0)

Sonic_AnimDelay:
		rts
; ---------------------------------------------------------------------------

Sonic_AnimEndFF:
		addq.b	#1,d0
		bne.s	Sonic_AnimFE
		move.b	#0,$1B(a0)
		move.b	1(a1),d0
		bra.s	Sonic_AnimNext
; ---------------------------------------------------------------------------

Sonic_AnimFE:
		addq.b	#1,d0
		bne.s	Sonic_AnimFD
		move.b	2(a1,d1.w),d0
		sub.b	d0,$1B(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.s	Sonic_AnimNext
; ---------------------------------------------------------------------------

Sonic_AnimFD:
		addq.b	#1,d0
		bne.s	Sonic_AnimEnd
		move.b	2(a1,d1.w),$1C(a0)

Sonic_AnimEnd:
		rts
; ---------------------------------------------------------------------------

Sonic_AnimateCmd:
		subq.b	#1,$1E(a0)
		bpl.s	Sonic_AnimDelay
		addq.b	#1,d0
		bne.w	Sonic_AnimRollJump
		moveq	#0,d1
		move.b	$26(a0),d0
		move.b	$22(a0),d2
		andi.b	#1,d2
		bne.s	loc_F53E
		not.b	d0

loc_F53E:
		addi.b	#$10,d0
		bpl.s	loc_F546
		moveq	#3,d1

loc_F546:
		andi.b	#$FC,1(a0)
		eor.b	d1,d2
		or.b	d2,1(a0)
		btst	#5,$22(a0)
		bne.w	Sonic_AnimPush
		lsr.b	#4,d0
		andi.b	#6,d0
		move.w	$14(a0),d2
		bpl.s	loc_F56A
		neg.w	d2

loc_F56A:
		lea	(byte_F654).l,a1
		cmpi.w	#$600,d2
		bcc.s	loc_F582
		lea	(byte_F64C).l,a1
		move.b	d0,d1
		lsr.b	#1,d1
		add.b	d1,d0

loc_F582:
		add.b	d0,d0
		move.b	d0,d3
		neg.w	d2
		addi.w	#$800,d2
		bpl.s	loc_F590
		moveq	#0,d2

loc_F590:
		lsr.w	#8,d2
		move.b	d2,$1E(a0)
		bsr.w	Sonic_AnimDo2
		add.b	d3,$1A(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_AnimRollJump:
		addq.b	#1,d0
		bne.s	Sonic_AnimPush
		move.w	$14(a0),d2
		bpl.s	loc_F5AC
		neg.w	d2

loc_F5AC:
		lea	(byte_F664).l,a1
		cmpi.w	#$600,d2
		bcc.s	loc_F5BE
		lea	(byte_F65C).l,a1

loc_F5BE:
		neg.w	d2
		addi.w	#$400,d2
		bpl.s	loc_F5C8
		moveq	#0,d2

loc_F5C8:
		lsr.w	#8,d2
		move.b	d2,$1E(a0)
		move.b	$22(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,1(a0)
		or.b	d1,1(a0)
		bra.w	Sonic_AnimDo2
; ---------------------------------------------------------------------------

Sonic_AnimPush:
		move.w	$14(a0),d2
		bmi.s	loc_F5EC
		neg.w	d2

loc_F5EC:
		addi.w	#$800,d2
		bpl.s	loc_F5F4
		moveq	#0,d2

loc_F5F4:
		lsr.w	#6,d2
		move.b	d2,$1E(a0)

loc_F5FA:
		lea	(byte_F66C).l,a1
		move.b	$22(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,1(a0)
		or.b	d1,1(a0)
		bra.w	Sonic_AnimDo2
; ---------------------------------------------------------------------------
		include "_anim\Sonic.asm"
		even
; ---------------------------------------------------------------------------

Sonic_DynTiles:
		moveq	#0,d0
		move.b	$1A(a0),d0
		cmp.b	(unk_FFF766).w,d0
		beq.s	locret_F744
		move.b	d0,(unk_FFF766).w
		lea	(DynMapSonic).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1
		subq.b	#1,d1
		bmi.s	locret_F744
		lea	(v_sgfx_buffer).w,a3
		move.b	#1,(f_sonframechg).w

Sonic_DynReadEntry:
		moveq	#0,d2
		move.b	(a2)+,d2
		move.w	d2,d0
		lsr.b	#4,d0
		lsl.w	#8,d2
		move.b	(a2)+,d2
		lsl.w	#5,d2
		lea	(ArtSonic).l,a1
		adda.l	d2,a1

loc_F730:
		movem.l	(a1)+,d2-d6/a4-a6
		movem.l	d2-d6/a4-a6,(a3)
		lea	$20(a3),a3
		dbf	d0,loc_F730

loc_F740:
		dbf	d1,Sonic_DynReadEntry

locret_F744:
		rts
; ---------------------------------------------------------------------------

TouchObjects:
		nop
		moveq	#0,d5
		move.b	$16(a0),d5
		subq.b	#3,d5
		move.w	8(a0),d2
		move.w	$C(a0),d3
		subq.w	#8,d2
		sub.w	d5,d3
		move.w	#$10,d4
		add.w	d5,d5
		lea	(LevelObjectsList).w,a1
		move.w	#$5F,d6

loc_FB6E:
		tst.b	1(a1)
		bpl.s	loc_FB7A
		move.b	$20(a1),d0
		bne.s	loc_FBB8

loc_FB7A:
		lea	$40(a1),a1
		dbf	d6,loc_FB6E
		moveq	#0,d0

locret_FB84:
		rts
; ---------------------------------------------------------------------------
		dc.b $14, $14   
		dc.b $C, $14
		dc.b $14, $C
		dc.b 4, $10
		dc.b $C, $12
		dc.b $10, $10
		dc.b 6, 6
		dc.b $18, $C
		dc.b $C, $10
		dc.b $10, $C
		dc.b 8, 8
		dc.b $14, $10
		dc.b $14, 8
		dc.b $E, $E
		dc.b $18, $18
		dc.b $28, $10
		dc.b $10, $18
		dc.b $C, $20
		dc.b $20, $70
		dc.b $40, $20
		dc.b $80, $20
		dc.b $20, $20
		dc.b 8, 8
		dc.b 4, 4
		dc.b $20, 8
; ---------------------------------------------------------------------------

loc_FBB8:
		andi.w	#$3F,d0
		add.w	d0,d0
		lea	locret_FB84(pc,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	8(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	loc_FBD8
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	loc_FBDC
		bra.s	loc_FB7A
; ---------------------------------------------------------------------------

loc_FBD8:
		cmp.w	d4,d0
		bhi.s	loc_FB7A

loc_FBDC:
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	$C(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	loc_FBF2
		add.w	d1,d1
		add.w	d0,d1
		bcs.s	loc_FBF6
		bra.s	loc_FB7A
; ---------------------------------------------------------------------------

loc_FBF2:
		cmp.w	d5,d0
		bhi.s	loc_FB7A

loc_FBF6:
		move.b	$20(a1),d1
		andi.b	#$C0,d1
		beq.w	loc_FC6A
		cmpi.b	#$C0,d1
		beq.w	loc_FDC4
		tst.b	d1
		bmi.w	loc_FCE0
		move.b	$20(a1),d0
		andi.b	#$3F,d0
		cmpi.b	#6,d0
		beq.s	loc_FC2E
		cmpi.w	#$5A,$30(a0)
		bcc.w	locret_FC2C
		addq.b	#2,$24(a1)

locret_FC2C:
		rts
; ---------------------------------------------------------------------------

loc_FC2E:
		tst.w	$12(a0)
		bpl.s	loc_FC58
		move.w	$C(a0),d0
		subi.w	#$10,d0
		cmp.w	$C(a1),d0
		bcs.s	locret_FC68
		neg.w	$12(a0)
		move.w	#$FE80,$12(a1)
		tst.b	$25(a1)
		bne.s	locret_FC68
		addq.b	#4,$25(a1)
		rts
; ---------------------------------------------------------------------------

loc_FC58:
		cmpi.b	#2,$1C(a0)
		bne.s	locret_FC68
		neg.w	$12(a0)
		addq.b	#2,$24(a1)

locret_FC68:
		rts
; ---------------------------------------------------------------------------

loc_FC6A:
		tst.b	(v_invinc).w
		bne.s	loc_FC78
		cmpi.b	#2,$1C(a0)
		bne.s	loc_FCE0

loc_FC78:
		tst.b	$21(a1)
		beq.s	loc_FCA2
		neg.w	$10(a0)
		neg.w	$12(a0)
		asr	$10(a0)
		asr	$12(a0)
		move.b	#0,$20(a1)
		subq.b	#1,$21(a1)
		bne.s	locret_FCA0
		bset	#7,$22(a1)

locret_FCA0:
		rts
; ---------------------------------------------------------------------------

loc_FCA2:
		bset	#7,$22(a1)
		moveq	#$A,d0
		bsr.w	ScoreAdd
		move.b	#$27,0(a1)
		move.b	#0,$24(a1)
		tst.w	$12(a0)
		bmi.s	loc_FCD0
		move.w	$C(a0),d0
		cmp.w	$C(a1),d0
		bcc.s	loc_FCD8
		neg.w	$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_FCD0:
		addi.w	#$100,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_FCD8:
		subi.w	#$100,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_FCE0:
		tst.b	(v_invinc).w
		beq.s	loc_FCEA

loc_FCE6:
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_FCEA:
		nop
		tst.w	$30(a0)
		bne.s	loc_FCE6
		movea.l	a1,a2

loc_FD78:
		tst.w	(DebugRoutine).w
		bne.s	loc_FDC0
		move.b	#6,$24(a0)
		bsr.w	Sonic_ResetOnFloor
		bset	#1,$22(a0)
		move.w	#$F900,$12(a0)
		move.w	#0,$10(a0)
		move.w	#0,$14(a0)
		move.w	$C(a0),$38(a0)
		move.b	#$18,$1C(a0)
		move.w	#$A3,d0
		cmpi.b	#$36,(a2)
		bne.s	loc_FDBA
		move.w	#$A6,d0

loc_FDBA:
		jsr	(PlaySFX).l

loc_FDC0:
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_FDC4:
		move.b	$20(a1),d1
		andi.b	#$3F,d1
		cmpi.b	#$C,d1
		beq.s	loc_FDDA
		cmpi.b	#$17,d1
		beq.s	loc_FE0C
		rts
; ---------------------------------------------------------------------------

loc_FDDA:
		sub.w	d0,d5
		cmpi.w	#8,d5
		bcc.s	loc_FE08
		move.w	8(a1),d0
		subq.w	#4,d0
		btst	#0,$22(a1)
		beq.s	loc_FDF4
		subi.w	#$10,d0

loc_FDF4:
		sub.w	d2,d0
		bcc.s	loc_FE00
		addi.w	#$18,d0
		bcs.s	loc_FE04
		bra.s	loc_FE08
; ---------------------------------------------------------------------------

loc_FE00:
		cmp.w	d4,d0
		bhi.s	loc_FE08

loc_FE04:
		bra.w	loc_FCE0
; ---------------------------------------------------------------------------

loc_FE08:
		bra.w	loc_FC6A
; ---------------------------------------------------------------------------

loc_FE0C:
		addq.b	#1,$21(a1)
		rts
; ---------------------------------------------------------------------------

Sonic_AnglePosition:
		btst	#3,$22(a0)
		beq.s	loc_FE26
		moveq	#0,d0
		move.b	d0,(unk_FFF768).w
		move.b	d0,(unk_FFF76A).w
		rts
; ---------------------------------------------------------------------------

loc_FE26:
		moveq	#3,d0
		move.b	d0,(unk_FFF768).w
		move.b	d0,(unk_FFF76A).w
		move.b	$26(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	Sonic_WalkVertL
		cmpi.b	#$80,d0
		beq.w	Sonic_WalkCeiling
		cmpi.b	#$C0,d0
		beq.w	Sonic_WalkVertR
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$17(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_FEC6
		bpl.s	loc_FEC8
		cmpi.w	#$FFF2,d1
		blt.s	locret_FEE8
		add.w	d1,$C(a0)

locret_FEC6:
		rts
; ---------------------------------------------------------------------------

loc_FEC8:
		cmpi.w	#$E,d1
		bgt.s	loc_FED4
		add.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_FED4:
		bset	#1,$22(a0)
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)
		rts
; ---------------------------------------------------------------------------

locret_FEE8:
		rts
; ---------------------------------------------------------------------------
		move.l	8(a0),d2
		move.w	$10(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d2
		move.l	d2,8(a0)
		move.w	#$38,d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,$C(a0)
		rts
; ---------------------------------------------------------------------------

locret_FF0C:
		rts
; ---------------------------------------------------------------------------
		move.l	$C(a0),d3        
		move.w	$12(a0),d0
		subi.w	#$38,d0
		move.w	d0,$12(a0)
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,$C(a0)
		rts
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

sub_FF2C:
		move.l	8(a0),d2
		move.l	$C(a0),d3
		move.w	$10(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d2

loc_FF3E:
		move.w	$12(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d2,8(a0)
		move.l	d3,$C(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_Angle:
		move.b	(unk_FFF76A).w,d2
		cmp.w	d0,d1
		ble.s	loc_FF60
		move.b	(unk_FFF768).w,d2
		move.w	d0,d1

loc_FF60:
		btst	#0,d2

loc_FF64:
		bne.s	loc_FF6C
		move.b	d2,$26(a0)
		rts
; ---------------------------------------------------------------------------

loc_FF6C:
		move.b	$26(a0),d2
		addi.b	#$20,d2
		andi.b	#$C0,d2
		move.b	d2,$26(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_WalkVertR:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0

loc_FF88:
		move.b	$17(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)

loc_FFAE:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5

loc_FFD6:
		bsr.w	FindFloor
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_FFF2
		bpl.s	loc_FFF4
		cmpi.w	#$FFF2,d1
		blt.w	locret_FF0C
		add.w	d1,8(a0)

locret_FFF2:
		rts
; ---------------------------------------------------------------------------

loc_FFF4:
		cmpi.w	#$E,d1
		bgt.s	loc_10000
		add.w	d1,8(a0)

locret_FFFE:
		rts
; ---------------------------------------------------------------------------

loc_10000:
		bset	#1,$22(a0)
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_WalkCeiling:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	$17(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_1008E
		bpl.s	loc_10090
		cmpi.w	#$FFF2,d1
		blt.w	locret_FEE8
		sub.w	d1,$C(a0)

locret_1008E:
		rts
; ---------------------------------------------------------------------------

loc_10090:
		cmpi.w	#$E,d1
		bgt.s	loc_1009C
		sub.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_1009C:
		bset	#1,$22(a0)
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_WalkVertL:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$17(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_1012A
		bpl.s	loc_1012C
		cmpi.w	#$FFF2,d1
		blt.w	locret_FF0C
		sub.w	d1,8(a0)

locret_1012A:
		rts
; ---------------------------------------------------------------------------

loc_1012C:
		cmpi.w	#$E,d1
		bgt.s	loc_10138
		sub.w	d1,8(a0)
		rts
; ---------------------------------------------------------------------------

loc_10138:
		bset	#1,$22(a0)
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)
		rts
; ---------------------------------------------------------------------------

Floor_ChkTile:
		move.w	d2,d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.w	d3,d1
		lsr.w	#8,d1
		andi.w	#$7F,d1
		add.w	d1,d0
		moveq	#$FFFFFFFF,d1
		lea	(v_lvllayout).w,a1
		move.b	(a1,d0.w),d1
		beq.s	loc_10186
		bmi.s	loc_1018A
		subq.b	#1,d1
		ext.w	d1
		ror.w	#7,d1
		move.w	d2,d0
		add.w	d0,d0
		andi.w	#$1E0,d0
		add.w	d0,d1
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		add.w	d0,d1

loc_10186:
		movea.l	d1,a1
		rts
; ---------------------------------------------------------------------------

loc_1018A:
		andi.w	#$7F,d1
		btst	#6,render(a0)
		beq.s	loc_101A2
		addq.w	#1,d1
		cmpi.w	#$29,d1
		bne.s	loc_101A2
		move.w	#$51,d1

loc_101A2:
		subq.b	#1,d1
		ror.w	#7,d1
		move.w	d2,d0
		add.w	d0,d0
		andi.w	#$1E0,d0
		add.w	d0,d1
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		add.w	d0,d1
		movea.l	d1,a1
		rts
; ---------------------------------------------------------------------------

sub_101BE:
		bsr.s	Floor_ChkTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_101CE
		btst	d5,d4
		bne.s	loc_101DC

loc_101CE:
		add.w	a3,d2
		bsr.w	sub_10264
		sub.w	a3,d2
		addi.w	#$10,d1
		rts
; ---------------------------------------------------------------------------

loc_101DC:
		movea.l	(Collision).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_101CE
		lea	(colAngles).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d3,d1
		btst	#$B,d4
		beq.s	loc_10202
		not.w	d1
		neg.b	(a4)

loc_10202:
		btst	#$C,d4
		beq.s	loc_10212
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_10212:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(colWidth).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$C,d4
		beq.s	loc_1022E
		neg.w	d0

loc_1022E:
		tst.w	d0
		beq.s	loc_101CE
		bmi.s	loc_1024A
		cmpi.b	#$10,d0
		beq.s	loc_10256
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_1024A:
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_101CE

loc_10256:
		sub.w	a3,d2
		bsr.w	sub_10264
		add.w	a3,d2
		subi.w	#$10,d1
		rts
; ---------------------------------------------------------------------------

sub_10264:
		bsr.w	Floor_ChkTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_10276
		btst	d5,d4
		bne.s	loc_10284

loc_10276:
		move.w	#$F,d1
		move.w	d2,d0
		andi.w	#$F,d0
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_10284:
		movea.l	(Collision).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_10276
		lea	(colAngles).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d3,d1
		btst	#$B,d4
		beq.s	loc_102AA
		not.w	d1
		neg.b	(a4)

loc_102AA:
		btst	#$C,d4
		beq.s	loc_102BA
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_102BA:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(colWidth).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$C,d4
		beq.s	loc_102D6
		neg.w	d0

loc_102D6:
		tst.w	d0
		beq.s	loc_10276
		bmi.s	loc_102EC
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_102EC:
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_10276
		not.w	d1
		rts
; ---------------------------------------------------------------------------

FindFloor:
		bsr.w	Floor_ChkTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_1030E
		btst	d5,d4
		bne.s	loc_1031C

loc_1030E:
		add.w	a3,d3
		bsr.w	FindFloor2
		sub.w	a3,d3
		addi.w	#$10,d1
		rts
; ---------------------------------------------------------------------------

loc_1031C:
		movea.l	(Collision).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_1030E
		lea	(colAngles).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d2,d1
		btst	#$C,d4
		beq.s	loc_1034A
		not.w	d1
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_1034A:
		btst	#$B,d4
		beq.s	loc_10352
		neg.b	(a4)

loc_10352:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(colHeight).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$B,d4
		beq.s	loc_1036E
		neg.w	d0

loc_1036E:
		tst.w	d0
		beq.s	loc_1030E
		bmi.s	loc_1038A
		cmpi.b	#$10,d0
		beq.s	loc_10396
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_1038A:
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_1030E

loc_10396:
		sub.w	a3,d3
		bsr.w	FindFloor2
		add.w	a3,d3
		subi.w	#$10,d1
		rts
; ---------------------------------------------------------------------------

FindFloor2:
		bsr.w	Floor_ChkTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_103B6
		btst	d5,d4
		bne.s	loc_103C4

loc_103B6:
		move.w	#$F,d1
		move.w	d3,d0
		andi.w	#$F,d0
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_103C4:
		movea.l	(Collision).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_103B6
		lea	(colAngles).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d2,d1
		btst	#$C,d4
		beq.s	loc_103F2
		not.w	d1
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_103F2:
		btst	#$B,d4
		beq.s	loc_103FA
		neg.b	(a4)

loc_103FA:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(colHeight).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$B,d4
		beq.s	loc_10416
		neg.w	d0

loc_10416:
		tst.w	d0
		beq.s	loc_103B6
		bmi.s	loc_1042C
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_1042C:
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_103B6
		not.w	d1
		rts
; ---------------------------------------------------------------------------

LogCollision:
		rts
; ---------------------------------------------------------------------------
		lea	(colWidth).l,a1         ; Logs the Collision.
		lea	(colWidth).l,a2
		move.w	#$FF,d3

loc_1044E:
		moveq	#$10,d5
		move.w	#$F,d2

loc_10454:
		moveq	#0,d4
		move.w	#$F,d1

loc_1045A:
		move.w	(a1)+,d0
		lsr.l	d5,d0
		addx.w	d4,d4
		dbf	d1,loc_1045A
		move.w	d4,(a2)+
		suba.w	#$20,a1
		subq.w	#1,d5
		dbf	d2,loc_10454
		adda.w	#$20,a1
		dbf	d3,loc_1044E
		lea	(colWidth).l,a1
		lea	(colHeight).l,a2
		bsr.s	sub_10492
		lea	(colWidth).l,a1
		lea	(colWidth).l,a2
; ---------------------------------------------------------------------------

sub_10492:
		move.w	#$FFF,d3

loc_10496:
		moveq	#0,d2
		move.w	#$F,d1
		move.w	(a1)+,d0
		beq.s	loc_104C4
		bmi.s	loc_104AE

loc_104A2:
		lsr.w	#1,d0
		bcc.s	loc_104A8
		addq.b	#1,d2

loc_104A8:
		dbf	d1,loc_104A2
		bra.s	loc_104C6
; ---------------------------------------------------------------------------

loc_104AE:
		cmpi.w	#$FFFF,d0
		beq.s	loc_104C0

loc_104B4:
		lsl.w	#1,d0
		bcc.s	loc_104BA
		subq.b	#1,d2

loc_104BA:
		dbf	d1,loc_104B4
		bra.s	loc_104C6
; ---------------------------------------------------------------------------

loc_104C0:
		move.w	#$10,d0

loc_104C4:
		move.w	d0,d2

loc_104C6:
		move.b	d2,(a2)+
		dbf	d3,loc_10496
		rts
; ---------------------------------------------------------------------------

Sonic_WalkSpeed:
		move.l	8(a0),d3
		move.l	$C(a0),d2
		move.w	$10(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d3
		move.w	$12(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d2
		swap	d2
		swap	d3
		move.b	d0,(unk_FFF768).w
		move.b	d0,(unk_FFF76A).w
		move.b	d0,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.w	loc_105C8
		cmpi.b	#$80,d0
		beq.w	loc_10754
		andi.b	#$38,d1
		bne.s	loc_10514
		addq.w	#8,d2

loc_10514:
		cmpi.b	#$40,d0
		beq.w	loc_10822
		bra.w	sub_unusedwallrunning
; ---------------------------------------------------------------------------

sub_10520:
		move.b	d0,(unk_FFF768).w
		move.b	d0,(unk_FFF76A).w
		addi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	loc_107AE
		cmpi.b	#$80,d0
		beq.w	Sonic_NoRunningOnWalls
		cmpi.b	#$C0,d0
		beq.w	loc_10628

Sonic_HitFloor:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$17(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	(sp)+,d0
		move.b	#0,d2

loc_105A8:
		move.b	(unk_FFF76A).w,d3
		cmp.w	d0,d1
		ble.s	loc_105B6
		move.b	(unk_FFF768).w,d3
		move.w	d0,d1

loc_105B6:
		btst	#0,d3
		beq.s	locret_105BE
		move.b	d2,d3

locret_105BE:
		rts
; ---------------------------------------------------------------------------
		move.w	$C(a0),d2             
		move.w	8(a0),d3

loc_105C8:
		addi.w	#$A,d2
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.b	#0,d2

loc_105E2:
		move.b	(unk_FFF768).w,d3
		btst	#0,d3
		beq.s	locret_105EE
		move.b	d2,d3

locret_105EE:
		rts
; ---------------------------------------------------------------------------

ObjectHitFloor:
		move.w	8(a0),d3

ObjectHitFloor2:
		move.w	$C(a0),d2
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d2
		lea	(unk_FFF768).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.b	(unk_FFF768).w,d3
		btst	#0,d3
		beq.s	locret_10626
		move.b	#0,d3

locret_10626:
		rts
; ---------------------------------------------------------------------------

loc_10628:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$17(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		move.b	#$C0,d2
		bra.w	loc_105A8
; ---------------------------------------------------------------------------

sub_1068C:
		move.w	$C(a0),d2
		move.w	8(a0),d3

loc_10694:
		addi.w	#$A,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	#$C0,d2
		bra.w	loc_105E2
; ---------------------------------------------------------------------------

ObjectHitWallRight:
		add.w	8(a0),d3
		move.w	$C(a0),d2
		lea	(unk_FFF768).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	(unk_FFF768).w,d3
		btst	#0,d3
		beq.s	locret_106DE
		move.b	#$C0,d3

locret_106DE:
		rts
; ---------------------------------------------------------------------------

Sonic_NoRunningOnWalls:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	$17(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.w	(sp)+,d0
		move.b	#$80,d2
		bra.w	loc_105A8
; ---------------------------------------------------------------------------
sub_unusedwallrunning:
		move.w	$C(a0),d2
		move.w	8(a0),d3

loc_10754:
		subi.w	#$A,d2
		eori.w	#$F,d2
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.b	#$80,d2
		bra.w	loc_105E2
; ---------------------------------------------------------------------------

ObjectHitCeiling:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.b	(unk_FFF768).w,d3
		btst	#0,d3
		beq.s	locret_107AC
		move.b	#$80,d3

locret_107AC:
		rts
; ---------------------------------------------------------------------------

loc_107AE:
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$17(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		moveq	#0,d0
		move.b	$17(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	$16(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		move.b	#$40,d2
		bra.w	loc_105A8
; ---------------------------------------------------------------------------

Sonic_HitWall:
		move.w	$C(a0),d2
		move.w	8(a0),d3

loc_10822:
		subi.w	#$A,d3
		eori.w	#$F,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	#$40,d2
		bra.w	loc_105E2
; ---------------------------------------------------------------------------

ObjectHitWallLeft:
		add.w	8(a0),d3
		move.w	$C(a0),d2
		lea	(unk_FFF768).w,a4
		move.b	#0,(a4)
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	(unk_FFF768).w,d3
		btst	#0,d3
		beq.s	locret_10870
		move.b	#$40,d3

locret_10870:
		rts
; ---------------------------------------------------------------------------

GM_Special_ShowLayout:
		bsr.w	GM_Special_AniWallsandRings
		;bsr.w	GM_Special_AniItems
		move.w	d5,-(sp)
		lea	($FFFF8000).w,a1
		move.b	(unk_FFF780).w,d0
		andi.b	#$FC,d0
		jsr	(GetSine).l
		move.w	d0,d4
		move.w	d1,d5
		muls.w	#$18,d4
		muls.w	#$18,d5
		moveq	#0,d2
		move.w	(v_screenposx).w,d2
		divu.w	#$18,d2
		swap	d2
		neg.w	d2
		addi.w	#-$B4,d2
		moveq	#0,d3
		move.w	(v_screenposy).w,d3
		divu.w	#$18,d3
		swap	d3
		neg.w	d3
		addi.w	#-$B4,d3
		move.w	#$F,d7

loc_108C2:
		movem.w	d0-d2,-(sp)
		movem.w	d0-d1,-(sp)
		neg.w	d0
		muls.w	d2,d1
		muls.w	d3,d0
		move.l	d0,d6
		add.l	d1,d6
		movem.w	(sp)+,d0-d1
		muls.w	d2,d0
		muls.w	d3,d1
		add.l	d0,d1
		move.l	d6,d2
		move.w	#$F,d6

loc_108E4:
		move.l	d2,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		move.l	d1,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		add.l	d5,d2
		add.l	d4,d1
		dbf	d6,loc_108E4

		movem.w	(sp)+,d0-d2
		addi.w	#$18,d3
		dbf	d7,loc_108C2

		move.w	(sp)+,d5
		lea	($FF0000).l,a0
		moveq	#0,d0
		move.w	(v_screenposy).w,d0
		divu.w	#$18,d0
		mulu.w	#$80,d0
		adda.l	d0,a0
		moveq	#0,d0
		move.w	(v_screenposx).w,d0
		divu.w	#$18,d0
		adda.w	d0,a0
		lea	($FFFF8000).w,a4
		move.w	#$F,d7

loc_10930:
		move.w	#$F,d6

loc_10934:
		moveq	#0,d0
		move.b	(a0)+,d0
		beq.s	loc_10986
		move.w	(a4),d3
		addi.w	#$120,d3
		cmpi.w	#$70,d3
		bcs.s	loc_10986
		cmpi.w	#$1D0,d3
		bcc.s	loc_10986
		move.w	2(a4),d2
		addi.w	#$F0,d2
		cmpi.w	#$70,d2
		bcs.s	loc_10986
		cmpi.w	#$170,d2
		bcc.s	loc_10986
		lea	($FF4000).l,a5
		lsl.w	#3,d0
		lea	(a5,d0.w),a5
		movea.l	(a5)+,a1
		move.w	(a5)+,d1
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		movea.w	(a5)+,a3
		moveq	#0,d1
		move.b	(a1)+,d1
		subq.b	#1,d1
		bmi.s	loc_10986
		jsr	sub_88AA

loc_10986:
		addq.w	#4,a4
		dbf	d6,loc_10934

		lea	$70(a0),a0
		dbf	d7,loc_10930

		move.b	d5,(byte_FFF62C).w
		cmpi.b	#$50,d5
		beq.s	loc_109A6
		move.l	#0,(a2)
		rts
; ---------------------------------------------------------------------------

loc_109A6:
		move.b	#0,-5(a2)
		rts
; ---------------------------------------------------------------------------

GM_Special_AniWallsandRings:
		lea	($FF400C).l,a1
		moveq	#0,d0
		move.b	(unk_FFF780).w,d0
		lsr.b	#2,d0
		andi.w	#$F,d0
		;moveq	#$F,d1

loc_109C2:
		move.w	d0,(a1)
		addq.w	#8,a1
		dbf	d1,loc_10A26

loc_10A26:
		rts
; ---------------------------------------------------------------------------

Special_VRAMSet:dc.w $142, $142, $142, $2142
		dc.w $142, $142, $142, $142
		dc.w $2142, $2142, $2142, $142
		dc.w $2142, $2142, $2142, $2142
		dc.w $4142, $4142, $4142, $2142
		dc.w $4142, $4142, $4142, $4142
		dc.w $6142, $6142, $6142, $2142
		dc.w $6142, $6142, $6142, $6142
; ---------------------------------------------------------------------------

sub_10ACC:
		lea	(($FF4400)&$FFFFFF).l,a2
		move.w	#$1F,d0

loc_10AD6:
		tst.b	(a2)
		beq.s	locret_10AE0
		addq.w	#8,a2
		dbf	d0,loc_10AD6

locret_10AE0:
		rts
; ---------------------------------------------------------------------------

SS_Load:
		lea	($FF0000).l,a1
		move.w	#$FFF,d0

loc_10B7A:
		clr.l	(a1)+
		dbf	d0,loc_10B7A

		lea	($FF172E).l,a1
		lea	(SS_1).l,a0
		moveq	#$23,d1

loc_10B8E:
		moveq	#8,d2

loc_10B90:
		move.l	(a0)+,(a1)+
		dbf	d2,loc_10B90

		lea	$5C(a1),a1
		dbf	d1,loc_10B8E

		lea	($FF4008).l,a1
		;lea	(Map_SSWalls).l,a0
		;dc.l Map_SSWalls
		;dc.w $2142
		moveq	#$1B,d1

loc_10BAC:
		move.l	#Map_SSWalls,(a1)+
		move.w	#0,(a1)+
		;move.b	-4(a0),-1(a1)
		move.w	#$2142,(a1)+
		;dbf	d1,loc_10BAC

		lea	($FF4400).l,a1
		move.w	#$3F,d1

loc_10BC8:

		clr.l	(a1)+
		dbf	d1,loc_10BC8

		rts
; ---------------------------------------------------------------------------

                ;include "_inc\Special Stage Mappings & VRAM Pointers.asm"

		lea	($FF1020).l,a1           ; Leftover from previous build?
		lea	(SS_1).l,a0
		moveq	#$3F,d1

loc_10CA6:
		moveq	#$F,d2

loc_10CA8:
		move.l	(a0)+,(a1)+
		dbf	d2,loc_10CA8
		lea	$40(a1),a1
		dbf	d1,loc_10CA6
		rts

                include "_incObj\09 Sonic in Special Stage.asm"
                include "_incObj\10 Sonic Animation Test.asm"

		include "_inc\AnimateLevelGfx.asm"

                include "_incObj\21 HUD.asm"
		include "levels\shared\HUD\Sprite.map"
; ---------------------------------------------------------------------------

ScoreAdd:
		move.b	#1,(byte_FFFE1F).w
		lea	(unk_FFFE50).w,a2
		lea	(v_score).w,a3
		add.l	d0,(a3)
		;move.l	#999999,d1
		;cmp.l	(a3),d1
		;bhi.w	loc_1166E
		;move.l	d1,(a3)
		;move.l	d1,(a2)

loc_1166E:
		move.l	(a3),d0
		cmp.l	(a2),d0
		bcs.w	locret_11678
		move.l	d0,(a2)

locret_11678:
		rts
; ---------------------------------------------------------------------------

UpdateHUD:
		;tst.w	(f_debugmode).w
		;bne.w	loc_11746
		;tst.b	(byte_FFFE1F).w
		;beq.s	loc_1169A
		clr.b	(byte_FFFE1F).w
		move.l	#$5C800003,d0
		move.l	(v_score).w,d1
		bsr.w	sub_1187E
		bra.w 	loc_11746

loc_1169A:
		tst.b	(f_extralife).w
		beq.s	loc_116BA
		bpl.s	loc_116A6
		bsr.w	sub_117B2

loc_116A6:
		clr.b	(f_extralife).w
		move.l	#$5F400003,d0
		moveq	#0,d1
		move.w	(v_rings).w,d1
		bsr.w	sub_11874

loc_116BA:
		tst.b	(f_timecount).w
		beq.s	loc_1170E
		tst.w	(f_pause).w
		bmi.s	loc_1170E
		lea	(v_score).w,a1
		addq.b	#1,-(a1)
		cmpi.b	#60,(a1)
		bcs.s	loc_1170E
		move.b	#0,(a1)
		addq.b	#1,-(a1)
		cmpi.b	#60,(a1)
		bcs.s	loc_116EE
		move.b	#0,(a1)
		addq.b	#1,-(a1)
		cmpi.b	#9,(a1)
		bcs.s	loc_116EE
		move.b	#9,(a1)

loc_116EE:
		move.l	#$5E400003,d0
		moveq	#0,d1
		move.b	(v_time+1).w,d1
		bsr.w	sub_118F4
		move.l	#$5EC00003,d0
		moveq	#0,d1
		move.b	(v_time+2).w,d1
		bsr.w	sub_118FE

loc_1170E:
		tst.b	(byte_FFFE1C).w
		beq.s	loc_1171C
		clr.b	(byte_FFFE1C).w
		bsr.w	sub_119BA

loc_1171C:
		tst.b	(byte_FFFE58).w
		beq.s	locret_11744
		clr.b	(byte_FFFE58).w
		move.l	#$6E000002,(vdp_control_port).l
		moveq	#0,d1
		move.w	(word_FFFE54).w,d1
		bsr.w	sub_11958
		moveq	#0,d1
		move.w	(word_FFFE56).w,d1
		bsr.w	sub_11958

locret_11744:
		rts
; ---------------------------------------------------------------------------

loc_11746:
		;bsr.w	sub_1181E
		tst.b	(f_extralife).w
		beq.s	loc_1176A
		bpl.s	loc_11756
		bsr.w	sub_117B2

loc_11756:
		clr.b	(f_extralife).w
		move.l	#$5F400003,d0
		moveq	#0,d1
		move.w	(v_rings).w,d1
		bsr.w	sub_11874

loc_1176A:
		move.l	#$5EC00003,d0
		moveq	#0,d1
		move.b	(byte_FFF62C).w,d1
		bsr.w	sub_118FE
		tst.b	(byte_FFFE1C).w
		beq.s	loc_11788
		clr.b	(byte_FFFE1C).w
		bsr.w	sub_119BA

loc_11788:
		tst.b	(byte_FFFE58).w
		beq.s	locret_117B0
		clr.b	(byte_FFFE58).w
		move.l	#$6E000002,(vdp_control_port).l
		moveq	#0,d1
		move.w	(word_FFFE54).w,d1
		bsr.w	sub_11958
		moveq	#0,d1
		move.w	(word_FFFE56).w,d1
		bsr.w	sub_11958

locret_117B0:
		rts
; ---------------------------------------------------------------------------

sub_117B2:
		move.l	#$5F400003,(vdp_control_port).l
		lea	byte_1181A(pc),a2
		move.w	#2,d2
		bra.s	loc_117E2
; ---------------------------------------------------------------------------

sub_117C6:
		lea	(vdp_data_port).l,a6
		bsr.w	sub_119BA
		move.l	#$5C400003,(vdp_control_port).l
		lea	byte_1180E(pc),a2
		move.w	#$E,d2

loc_117E2:
		lea	byte_11A26(pc),a1

loc_117E6:
		move.w	#$F,d1
		move.b	(a2)+,d0
		bmi.s	loc_11802
		ext.w	d0
		lsl.w	#5,d0
		lea	(a1,d0.w),a3

loc_117F6:
		move.l	(a3)+,(a6)
		dbf	d1,loc_117F6

loc_117FC:
		dbf	d2,loc_117E6
		rts
; ---------------------------------------------------------------------------

loc_11802:
		move.l	#0,(a6)
		dbf	d1,loc_11802
		bra.s	loc_117FC
; ---------------------------------------------------------------------------

byte_1180E:	dc.b $16, $FF, $FF, $FF, $FF, $FF, $FF, 0, 0, $14, 0, 0

byte_1181A:	dc.b $FF, $FF, 0, 0
; ---------------------------------------------------------------------------

sub_1181E:
		move.l	#$5C400003,(vdp_control_port).l
		move.w	(v_screenposx).w,d1
		swap	d1
		move.w	(v_objspace+8).w,d1
		bsr.s	sub_1183E
		move.w	(v_screenposy).w,d1
		swap	d1
		move.w	(v_objspace+$C).w,d1
; ---------------------------------------------------------------------------

sub_1183E:
		moveq	#7,d6
		lea	(ArtText).l,a1

loc_11846:
		rol.w	#4,d1
		move.w	d1,d2
		andi.w	#$F,d2
		cmpi.w	#$A,d2
		bcs.s	loc_11856
		addq.w	#7,d2

loc_11856:
		lsl.w	#5,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		swap	d1
		dbf	d6,loc_11846
		rts
; ---------------------------------------------------------------------------

sub_11874:
		lea	(Hud_100).l,a2
		moveq	#2,d6
		bra.s	loc_11886
; ---------------------------------------------------------------------------

sub_1187E:
		lea	(Hud_100000).l,a2
		moveq	#5,d6

loc_11886:
		moveq	#0,d4
		lea	byte_11A26(pc),a1

loc_1188C:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_11890:
		sub.l	d3,d1
		bcs.s	loc_11898
		addq.w	#1,d2
		bra.s	loc_11890
; ---------------------------------------------------------------------------

loc_11898:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_118A2
		move.w	#1,d4

loc_118A2:
		tst.w	d4
		beq.s	loc_118D0
		lsl.w	#6,d2
		move.l	d0,4(a6)
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)

loc_118D0:
		addi.l	#$400000,d0
		dbf	d6,loc_1188C
		rts
; ---------------------------------------------------------------------------

Hud_100000:	dc.l 100000
Hud_10000:	dc.l 10000
Hud_1000:	dc.l 1000
Hud_100:	dc.l 100
Hud_10:	        dc.l 10
Hud_1:	        dc.l 1
; ---------------------------------------------------------------------------

sub_118F4:
		lea	(Hud_1).l,a2
		moveq	#0,d6
		bra.s	loc_11906
; ---------------------------------------------------------------------------

sub_118FE:
		lea	(Hud_10).l,a2
		moveq	#1,d6

loc_11906:
		moveq	#0,d4
		lea	byte_11A26(pc),a1

loc_1190C:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_11910:
		sub.l	d3,d1
		bcs.s	loc_11918
		addq.w	#1,d2
		bra.s	loc_11910
; ---------------------------------------------------------------------------

loc_11918:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_11922
		move.w	#1,d4

loc_11922:
		lsl.w	#6,d2
		move.l	d0,4(a6)
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		addi.l	#$400000,d0
		dbf	d6,loc_1190C
		rts
; ---------------------------------------------------------------------------

sub_11958:
		lea	(Hud_1000).l,a2
		moveq	#3,d6
		moveq	#0,d4
		lea	byte_11A26(pc),a1

loc_11966:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1196A:
		sub.l	d3,d1
		bcs.s	loc_11972
		addq.w	#1,d2
		bra.s	loc_1196A
; ---------------------------------------------------------------------------

loc_11972:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_1197C
		move.w	#1,d4

loc_1197C:
		tst.w	d4
		beq.s	loc_119AC
		lsl.w	#6,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)

loc_119A6:
		dbf	d6,loc_11966
		rts
; ---------------------------------------------------------------------------

loc_119AC:
		moveq	#$F,d5

loc_119AE:
		move.l	#0,(a6)
		dbf	d5,loc_119AE
		bra.s	loc_119A6
; ---------------------------------------------------------------------------

sub_119BA:
	; lives counter, prob remove this whole code later?
		rts
		move.l	#$7BA00003,d0
		moveq	#0,d1
		move.b	(v_lives).w,d1
		lea	(Hud_10).l,a2
		moveq	#1,d6
		moveq	#0,d4
		lea	byte_11D26(pc),a1

loc_119D4:
		move.l	d0,4(a6)
		moveq	#0,d2
		move.l	(a2)+,d3

loc_119DC:
		sub.l	d3,d1
		bcs.s	loc_119E4
		addq.w	#1,d2
		bra.s	loc_119DC
; ---------------------------------------------------------------------------

loc_119E4:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_119EE
		move.w	#1,d4

loc_119EE:
		tst.w	d4
		beq.s	loc_11A14

loc_119F2:
		lsl.w	#5,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)

loc_11A08:
		addi.l	#$400000,d0
		dbf	d6,loc_119D4
		rts
; ---------------------------------------------------------------------------

loc_11A14:
		tst.w	d6
		beq.s	loc_119F2
		moveq	#7,d5

loc_11A1A:
		move.l	#0,(a6)
		dbf	d5,loc_11A1A
		bra.s	loc_11A08
; ---------------------------------------------------------------------------

byte_11A26:	incbin "artunc\HUD Numbers.bin"
                even
byte_11D26:	incbin "artunc\Lives Counter Numbers.bin"
                even

                include "_incObj\DebugMode.asm"
		include "_inc\DebugList.asm"
		include "_inc\LevelHeaders.asm"
		include "_inc\Pattern Load Cues.asm"

		align $8000,$FF ; Padding
; ===========================================================================
; Unused 8x8 Font Art
; ===========================================================================
byte_18000:	incbin "leftovers\0x18000.bin" ; Some similar art to this is used in other prototypes, such as Sonic 2 Nick Arcade
		even
; ===========================================================================
; Sega Screen\Title Screen Art and Mappings
; ===========================================================================
Nem_SegaLogo:	incbin "artnem\Sega Logo.bin"
		even
Eni_SegaLogo:	incbin "tilemaps\Sega Logo.bin"
		even
Unc_Title:	incbin "tilemaps\Title.bin"
		even
Nem_TitleFg:	incbin "artnem\Title.bin"
		even
Nem_TitleSonic:	incbin "artnem\Title Screen Sonic.bin"
		even
		include "_maps\Sonic.asm"
		include "_maps\Sonic - Dynamic Gfx Script.asm"

ArtSonic:	incbin "artunc\Sonic.bin"
		even
; ===========================================================================
; Nemesis Art
; ===========================================================================
ArtSmoke:	incbin "artnem\Smoke.bin" ; Although this never gets used, it's loaded first in the VRAM at $F400
		even
;ArtShield:	incbin "artnem\Shield.bin"
		;even
;ArtInvinStars:	incbin "artnem\Stars.bin"
		;even
;ArtFlash:	incbin "artnem\Flash.bin"
		;even
;byte_26E90:	incbin "artnem\Unused - Goggles.bin"
	        ;even

                align $400,$FF ; Padding

byte_27400:	incbin "artnem\ghz flower stalk.nem"
		even
byte_2744A:	incbin "artnem\ghz swing.nem"
		even
ArtBridge:	incbin "levels\GHZ\Bridge\Art.nem"
		even
byte_27698:	incbin "artnem\ghz checkered ball.nem"
		even
ArtSpikes:	incbin "levels\shared\Spikes\Art.nem"
		even
ArtSpikeLogs:	incbin "levels\GHZ\SpikeLogs\Art.nem"
		even
;ArtPurpleRock:	incbin "levels\GHZ\PurpleRock\Art.nem"
		;even
;ArtSmashWall:	incbin "levels\GHZ\SmashWall\Art.nem"
		;even
;ArtWall:	incbin "levels\GHZ\Wall\Art.nem"
		;even
;ArtChainPtfm:	incbin "levels\MZ\ChainPtfm\Art.nem"
		;even
;ArtButtonMZ:	incbin "levels\shared\Switch\Art MZ.nem"
		;even
;byte_2816E:	incbin "artnem\mz piston.nem"
		;even
;byte_2827A:	incbin "artnem\mz fire ball.nem"
		;even
;byte_28558:	incbin "artnem\mz lava.nem"
		;even
;byte_28E6E:	incbin "levels\MZ\PushBlock\Art.nem"
		;even
;ArtBumper:	incbin "levels\SZ\Bumper\Art.nem"
		;even
;byte_29FC0:	incbin "artnem\SZ small spiked ball.nem"
		;even
ArtButton:	incbin "levels\shared\Switch\Art.nem"
		even
byte_2A104:	incbin "artnem\swinging spiked ball.nem"
		even
Nem_Ballhog:    incbin "artnem\Enemy Ballhog.bin"
		even
Nem_Crabmeat:	incbin "artnem\Enemy Crabmeat.bin"
		even
Nem_Buzzbomber:	incbin "artnem\Enemy Buzz Bomber.bin"
		even
byte_2ADFE:     incbin "artnem\Ballhog's Bomb Explosion.bin"
		even
Nem_Burrobot:   incbin "artnem\Enemy Burrobot.bin"
		even
ArtChopper:	incbin "artnem\Enemy Chopper.bin"
		even
Nem_Jaws:	incbin "artnem\Enemy Jaws.bin"
		even
byte_2BBC2:     incbin "artnem\Ballhog's Bomb.bin"
		even
;Nem_Roller:	incbin "artnem\Enemy Roller.bin"
		;even
;ArtMotobug:	incbin "artnem\Enemy Motobug.bin"
		;even
;ArtNewtron:	incbin "artnem\Enemy Newtron.bin"
		;even
;ArtYardin:	incbin "artnem\Enemy Yadrin.bin"
		;even
;ArtBasaran:	incbin "artnem\Enemy Basaran.bin"
		;even
;ArtSplats:	incbin "artnem\Enemy Splats.bin"
		;even
;Nem_TitleCard:	incbin "artnem\Title Cards.bin"
		;even
ArtHUD:		incbin "levels\shared\HUD\Main.nem"
		even
ArtLives:	incbin "levels\shared\HUD\Lives.nem"
		even
ArtRings:	incbin "artnem\Rings.bin"
		even
ArtMonitors:	incbin "artnem\Monitors.bin"
		even
ArtExplosions:	incbin "levels\shared\Explosions\Art.nem"
		even
byte_2E6C8:	incbin "artnem\score points.nem"
		even
;ArtGameOver:	incbin "levels\shared\GameOver\Art.nem"
		;even
;ArtSpringHoriz:	incbin "levels\shared\Spring\Art Horizontal.nem"
		;even
;ArtSpringVerti:	incbin "levels\shared\Spring\Art Vertical.nem"
		;even
ArtSignPost:	incbin "artnem\Signpost.bin"
		even
ArtAnimalPocky:	incbin "levels\shared\Animals\Pocky.nem"
		even
ArtAnimalCucky:	incbin "levels\shared\Animals\Cucky.nem"
		even
ArtAnimalPecky:	incbin "levels\shared\Animals\Pecky.nem"
		even
ArtAnimalRocky:	incbin "levels\shared\Animals\Rocky.nem"
		even
ArtAnimalPicky:	incbin "levels\shared\Animals\Picky.nem"
		even
ArtAnimalFlicky:incbin "levels\shared\Animals\Flicky.nem"
		even
ArtAnimalRicky:	incbin "levels\shared\Animals\Ricky.nem"
		even

		align $1000,$FF ; Padding
; ===========================================================================
; Level Data
; ===========================================================================
Blk16_GHZ:	incbin "map16\GHZ.bin"
		even
Nem_GHZ_1st:	incbin "artnem\8x8 - GHZ1.bin"
		even
Nem_GHZ_2nd:	incbin "artnem\8x8 - GHZ2.bin"
		even
Blk256_GHZ:	incbin "map256\GHZ.bin"
		even
Blk16_LZ:	incbin "map16\LZ.bin"
		even
Nem_LZ:         incbin "artnem\8x8 - LZ.bin"
		even
Blk256_LZ:	incbin "map256\LZ.bin"
		even
Blk16_MZ:	incbin "map16\MZ.bin"
		even
Nem_MZ:         incbin "artnem\8x8 - MZ.bin"
		even
Blk256_MZ:	incbin "map256\MZ.bin"
		even
byte_3DB70:	incbin "unknown\3DB70.dat"
		even
Blk16_SLZ:	incbin "map16\SLZ.bin"
		even
Nem_SLZ:	incbin "artnem\8x8 - SLZ.bin"
		even
Blk256_SLZ:	incbin "map256\SLZ.bin"
		even
Blk16_SZ:	incbin "map16\SZ.bin"
		even
Nem_SZ:	        incbin "artnem\8x8 - SZ.bin"
		even
Blk256_SZ:	incbin "map256\SZ.bin"
		even
Blk16_CWZ:	incbin "map16\CWZ.bin"
		even
Nem_CWZ:	incbin "artnem\8x8 - CWZ.bin"
		even
Blk256_CWZ:	incbin "map256\CWZ.bin"
		even
byte_570FC:	incbin "unknown\570FC.dat"
		even
; ===========================================================================
; Boss Art
; ===========================================================================
byte_60000:	incbin "artnem\Boss - Main.bin"
		even
byte_60864:	incbin "artnem\Boss - Weapons.bin"
		even
byte_60BB0:	incbin "artnem\Prison Capsule.bin"
		even
; ===========================================================================
; Demos
; ===========================================================================
Demo_GHZ:	incbin "demodata\Intro - GHZ.bin"	; Green Hill's demo (tts)
		even

		align $3000,$FF ; Padding
; ===========================================================================
; Special Stage Data
; ===========================================================================
                include "_maps\SS Walls.asm"

ArtSpecialBlocks:incbin "artnem\Art Blocks.nem"
		even
byte_639B8:	incbin "tilemaps\SS Background 1.bin"
		even
ArtSpecialAnimals:incbin "artnem\Art Animals.nem"
		even
byte_6477C:	incbin "tilemaps\SS Background 2.bin"
		even
byte_64A7C:	incbin "artnem\ss bg misc.nem"
		even

		align $4000,$FF ; Padding
; ===========================================================================
; Collision Data
; ===========================================================================
colAngles:	incbin "collide\Angle Map.bin"
		even
colWidth:	incbin "collide\Collision Array (Normal).bin"
		even
colHeight:	incbin "collide\Collision Array (Rotated).bin"
		even
colGHZ:		incbin "collide\GHZ.bin"
		even
colLZ:		incbin "collide\LZ.bin"
		even
colMZ:		incbin "collide\MZ.bin"
		even
colSLZ:		incbin "collide\SLZ.bin"
		even
colSZ:		incbin "collide\SZ.bin"
		even
colCWZ:		incbin "collide\CWZ.bin"
		even
; ===========================================================================
; Special Stage Layout (Uncompressed)
; ===========================================================================
SS_1:           incbin "sslayout\1.bin"
		even
; ===========================================================================
; Animated Uncompressed Art
; ===========================================================================
Art_GhzWater:	incbin "artunc\GHZ Waterfall.bin"
		even
Art_GhzFlower1:	incbin "artunc\GHZ Flower Large.bin"
		even
Art_GhzFlower2:	incbin "artunc\GHZ Flower Small.bin"
		even
;Art_MzLava1:	incbin "artunc\MZ Lava Surface.bin"
		;even
;Art_MzLava2:	incbin "artunc\MZ Lava.bin"
		;even
Art_MzSaturns:	incbin "artunc\MZ Saturns.bin"
		even
;Art_MzTorch:	incbin "artunc\MZ Background torch.bin"
		;even
; ===========================================================================
; Level Layout Index
; ===========================================================================
LayoutArray:	; GHZ
		dc.w LayoutGHZ1FG-LayoutArray, LayoutGHZ1BG-LayoutArray, byte_6CE54-LayoutArray
		dc.w LayoutGHZ2FG-LayoutArray, LayoutGHZ1BG-LayoutArray, byte_6CF3C-LayoutArray
		dc.w LayoutGHZ3FG-LayoutArray, LayoutGHZ1BG-LayoutArray, byte_6D084-LayoutArray
		dc.w byte_6D088-LayoutArray, byte_6D088-LayoutArray, byte_6D088-LayoutArray
		; LZ
		dc.w LayoutLZ1FG-LayoutArray, LayoutLZBG-LayoutArray, byte_6D190-LayoutArray
		dc.w LayoutLZ2FG-LayoutArray, LayoutLZBG-LayoutArray, byte_6D216-LayoutArray
		dc.w LayoutLZ3FG-LayoutArray, LayoutLZBG-LayoutArray, byte_6D31C-LayoutArray
		dc.w byte_6D320-LayoutArray, byte_6D320-LayoutArray, byte_6D320-LayoutArray
                ; MZ
		dc.w LayoutMZ1FG-LayoutArray, LayoutMZ1BG-LayoutArray, LayoutMZ1FG-LayoutArray
		dc.w LayoutMZ2FG-LayoutArray, LayoutMZ2BG-LayoutArray, byte_6D614-LayoutArray
		dc.w LayoutMZ3FG-LayoutArray, LayoutMZ3BG-LayoutArray, byte_6D7DC-LayoutArray
		dc.w byte_6D7E0-LayoutArray, byte_6D7E0-LayoutArray, byte_6D7E0-LayoutArray
                ; SLZ
		dc.w LayoutSLZ1FG-LayoutArray, LayoutSLZBG-LayoutArray, byte_6DBE4-LayoutArray
		dc.w LayoutSLZ2FG-LayoutArray, LayoutSLZBG-LayoutArray, byte_6DBE4-LayoutArray
		dc.w LayoutSLZ3FG-LayoutArray, LayoutSLZBG-LayoutArray, byte_6DBE4-LayoutArray
		dc.w byte_6DBE4-LayoutArray, byte_6DBE4-LayoutArray, byte_6DBE4-LayoutArray
                ; SZ
		dc.w LayoutSZ1FG-LayoutArray, LayoutSZBG-LayoutArray, byte_6DCD8-LayoutArray
		dc.w LayoutSZ2FG-LayoutArray, LayoutSZBG-LayoutArray, byte_6DDDA-LayoutArray
		dc.w LayoutSZ3FG-LayoutArray, LayoutSZBG-LayoutArray, byte_6DF30-LayoutArray
		dc.w byte_6DF34-LayoutArray, byte_6DF34-LayoutArray, byte_6DF34-LayoutArray
                ; CWZ
		dc.w LayoutCWZ1-LayoutArray, LayoutCWZ2-LayoutArray, LayoutCWZ2-LayoutArray
		dc.w LayoutCWZ2-LayoutArray, byte_6E33C-LayoutArray, byte_6E33C-LayoutArray
		dc.w LayoutCWZ3-LayoutArray, LayoutCWZ3-LayoutArray, LayoutCWZ3-LayoutArray
		dc.w byte_6E344-LayoutArray, byte_6E344-LayoutArray, byte_6E344-LayoutArray
		; Ending
		dc.w LayoutTest-LayoutArray, byte_6E3CA-LayoutArray, byte_6E3CA-LayoutArray
		dc.w byte_6E3CE-LayoutArray, byte_6E3CE-LayoutArray, byte_6E3CE-LayoutArray
		dc.w byte_6E3D2-LayoutArray, byte_6E3D2-LayoutArray, byte_6E3D2-LayoutArray
		dc.w byte_6E3D6-LayoutArray, byte_6E3D6-LayoutArray, byte_6E3D6-LayoutArray

LayoutGHZ1FG:	incbin "levels\ghz1.bin"
		even
LayoutGHZ1BG:	incbin "levels\ghzbg1.bin"
		even

byte_6CE54:	dc.l 0
LayoutGHZ2FG:	incbin "levels\ghz2.bin"
		even

byte_6CF3C:	dc.l 0
LayoutGHZ3FG:	incbin "levels\ghz3.bin"
		even

byte_6D084:	dc.l 0
byte_6D088:	dc.l 0
LayoutLZ1FG:	incbin "levels\lz1.bin"
		even
LayoutLZBG:	incbin "levels\lzbg.bin"
		even

byte_6D190:	dc.l 0
LayoutLZ2FG:	incbin "levels\lz2.bin"
		even

byte_6D216:	dc.l 0
LayoutLZ3FG:	incbin "levels\lz3.bin"
		even

byte_6D31C:	dc.l 0
byte_6D320:	dc.l 0
LayoutMZ1FG:	incbin "levels\mz1.bin"
		even
LayoutMZ1BG:	incbin "levels\mzbg1.bin"
		even
LayoutMZ2FG:	incbin "levels\mz2.bin"
		even
LayoutMZ2BG:	incbin "levels\mzbg2.bin"
		even

byte_6D614:	dc.l 0
LayoutMZ3FG:	incbin "levels\mz3.bin"
		even
LayoutMZ3BG:	incbin "levels\mzbg3.bin"
		even

byte_6D7DC:	dc.l 0
byte_6D7E0:	dc.l 0
LayoutSLZ1FG:	incbin "levels\slz1.bin"
		even
LayoutSLZBG:	incbin "levels\slzbg.bin"
		even
LayoutSLZ2FG:	incbin "levels\slz2.bin"
		even
LayoutSLZ3FG:	incbin "levels\slz3.bin"
		even

byte_6DBE4:	dc.l 0
LayoutSZ1FG:	incbin "levels\sz1.bin"
		even
LayoutSZBG:	incbin "levels\szbg.bin"
		even

byte_6DCD8:	dc.l 0
LayoutSZ2FG:	incbin "levels\sz2.bin"
		even

byte_6DDDA:	dc.l 0
LayoutSZ3FG:	incbin "levels\sz3.bin"
		even

byte_6DF30:	dc.l 0
byte_6DF34:	dc.l 0
LayoutCWZ1:	incbin "levels\cwz1.bin"
		even
LayoutCWZ2:	incbin "levels\cwz2.bin"
		even
byte_6E33C:	incbin "levels\cwz2bg.bin"
		even
LayoutCWZ3:	incbin "levels\cwz3.bin"
		even

byte_6E344:	dc.l 0
LayoutTest:     incbin "leftovers\test.bin" ; Seems to be a test layout
		even

byte_6E3CA:     dc.l 0
byte_6E3CE:	dc.l 0
byte_6E3D2:	dc.l 0
byte_6E3D6:	dc.l 0

		align $2000,$FF ; Padding
; ===========================================================================
; Object Layout Index
; ===========================================================================
ObjPos_Index:   ; GHZ
		dc.w ObjPos_GHZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_GHZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_GHZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_GHZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; LZ
		dc.w ObjPos_LZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_LZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_LZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_LZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; MZ
		dc.w ObjPos_MZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_MZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_MZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_MZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; SLZ
		dc.w ObjPos_SLZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SLZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SLZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SLZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; SZ
		dc.w ObjPos_SZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; CWZ
		dc.w ObjPos_CWZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_CWZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_CWZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_CWZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w $FFFF, 0, 0

ObjPos_GHZ1:	incbin "objpos\ghz1.bin"
		even
ObjPos_GHZ2:	incbin "objpos\ghz2.bin"
		even
ObjPos_GHZ3:	incbin "objpos\ghz3.bin"
		even
ObjPos_LZ1:	incbin "objpos\lz1.bin"
		even
ObjPos_LZ2:	incbin "objpos\lz2.bin"
		even
ObjPos_LZ3:	incbin "objpos\lz3.bin"
		even
ObjPos_MZ1:	incbin "objpos\mz1.bin"
		even
ObjPos_MZ2:	incbin "objpos\mz2.bin"
		even
ObjPos_MZ3:	incbin "objpos\mz3.bin"
		even
ObjPos_SLZ1:	incbin "objpos\slz1.bin"
		even
ObjPos_SLZ2:	incbin "objpos\slz2.bin"
		even
ObjPos_SLZ3:	incbin "objpos\slz3.bin"
		even
ObjPos_SZ1:	incbin "objpos\sz1.bin"
		even
ObjPos_SZ2:	incbin "objpos\sz2.bin"
		even
;byte_729CA:	incbin "leftovers\sz1.bin"  ; Leftover from earlier builds
		;even
ObjPos_SZ3:	incbin "objpos\sz3.bin"
		even
ObjPos_CWZ1:	incbin "objpos\cwz1.bin"
		even
ObjPos_CWZ2:	incbin "objpos\cwz2.bin"
		even
ObjPos_CWZ3:	incbin "objpos\cwz3.bin"
		even

ObjPos_Null:	dc.w $FFFF, 0, 0

		align $2000,$FF ; Padding

		include "s1.prototype.sounddriver.asm"

		align $4000,$FF ; Padding

EndOfROM:
	dc.b "REPLICA BY MRLORDSITH 2023/06/23"

	END
