; -------------------------------------------------------------------------
; Sonic CD Disassembly
; By Ralakimus 2021
; -------------------------------------------------------------------------
; Powerup object
; -------------------------------------------------------------------------

ObjPowerup:
	moveq	#0,d0
	move.b	oRoutine(a0),d0
	move.w	ObjPowerup_Index(pc,d0.w),d1
	jmp	ObjPowerup_Index(pc,d1.w)

; -------------------------------------------------------------------------
ObjPowerup_Index:
	dc.w	ObjPowerup_Init-ObjPowerup_Index
	dc.w	ObjPowerup_Shield-ObjPowerup_Index
	dc.w	ObjPowerup_InvStars-ObjPowerup_Index
	dc.w	ObjPowerup_TimeStars-ObjPowerup_Index
; -------------------------------------------------------------------------

ObjPowerup_Init:
	addq.b	#2,oRoutine(a0)
	move.l	#MapSpr_Powerup,oMap(a0)
	move.b	#4,oRender(a0)
	move.b	#1,oPriority(a0)
	move.b	#$10,oWidth(a0)
	move.w	#$544,oTile(a0)
	tst.b	oAnim(a0)
	beq.s	.End
	addq.b	#2,oRoutine(a0)
	cmpi.b	#5,oAnim(a0)
	bcs.s	.End
	addq.b	#2,oRoutine(a0)

.End:
	rts

; -------------------------------------------------------------------------

ObjPowerup_Shield:
	tst.b	shieldFlag
	beq.s	.Delete
	tst.b	timeWarpFlag
	bne.s	.End
	tst.b	invincibleFlag
	bne.s	.End
	move.w	objPlayerSlot+oX.w,oX(a0)
	move.w	objPlayerSlot+oY.w,oY(a0)
	move.b	objPlayerSlot+oStatus.w,oStatus(a0)
	cmpi.b	#6,levelZone
	bne.s	.Animate
	ori.b	#$80,2(a0)
	tst.b	lvlDrawLowPlane
	beq.s	.Animate
	andi.b	#$7F,2(a0)

.Animate:
	lea	Ani_Powerup,a1
	jsr	AnimateObject
	bra.w	ObjPowerup_ChkSaveRout

; -------------------------------------------------------------------------

.End:
	rts

; -------------------------------------------------------------------------

.Delete:
	jmp	DeleteObject

; -------------------------------------------------------------------------

ObjPowerup_InvStars:
	tst.b	timeWarpFlag
	beq.s	.NoTimeWarp
	rts

; -------------------------------------------------------------------------

.NoTimeWarp:
	tst.b	invincibleFlag
	bne.s	ObjPowerup_ShowStars
	jmp	DeleteObject

; -------------------------------------------------------------------------

ObjPowerup_TimeStars:
	tst.b	timeWarpFlag
	bne.s	ObjPowerup_ShowStars
	jmp	DeleteObject

; -------------------------------------------------------------------------

ObjPowerup_ShowStars:
	cmpi.b	#6,levelZone
	bne.s	.GotPriority
	ori.b	#$80,oTile(a0)
	tst.b	lvlDrawLowPlane
	beq.s	.GotPriority
	andi.b	#$7F,oTile(a0)

.GotPriority:
	move.w	sonicRecordIndex.w,d0
	move.b	oAnim(a0),d1
	subq.b	#1,d1
	cmpi.b	#4,d1
	bcs.s	.GotDelta
	subq.b	#4,d1

.GotDelta:
	lsl.b	#3,d1
	move.b	d1,d2
	add.b	d1,d1
	add.b	d2,d1
	addq.b	#4,d1
	sub.b	d1,d0
	move.b	oVar30(a0),d1
	sub.b	d1,d0
	addq.b	#4,d1
	cmpi.b	#$18,d1
	bcs.s	.NoCap
	moveq	#0,d1

.NoCap:
	move.b	d1,oVar30(a0)
	lea	sonicRecordBuf.w,a1
	lea	(a1,d0.w),a1
	move.w	(a1)+,oX(a0)
	move.w	(a1)+,oY(a0)
	move.b	objPlayerSlot+oStatus.w,oStatus(a0)
	lea	Ani_Powerup,a1
	jsr	AnimateObject

; -------------------------------------------------------------------------

ObjPowerup_ChkSaveRout:
	move.b	lvlLoadShieldArt,d0
	andi.b	#$F,d0
	cmpi.b	#8,d0
	bcs.s	.SaveRout
	rts

; -------------------------------------------------------------------------

.SaveRout:
	cmp.b	oRoutine(a0),d0
	beq.s	.Display
	move.b	oRoutine(a0),lvlLoadShieldArt
	bset	#7,lvlLoadShieldArt

.Display:
	jmp	DrawObject
	
; -------------------------------------------------------------------------

LoadShieldArt:
	bclr	#7,lvlLoadShieldArt
	beq.s	.End
	moveq	#0,d0
	move.b	lvlLoadShieldArt,d0
	subq.b	#2,d0
	add.w	d0,d0
	movea.l	ShieldArtIndex(pc,d0.w),a1
	lea	lvlDMABuffer,a2
	move.w	#$FF,d0

.Loop:
	move.l	(a1)+,(a2)+
	dbf	d0,.Loop
	lea	VDPCTRL,a5
	move.l	#$94029340,(a5)
	move.l	#$968C95C0,(a5)
	move.w	#$977F,(a5)
	move.w	#$6880,(a5)
	move.w	#$82,dmaCmdLow.w
	move.w	dmaCmdLow.w,(a5)

.End:
	rts
; End of function LoadShieldArt

; -------------------------------------------------------------------------

ShieldArtIndex:
	dc.l	ArtUnc_Shield
	dc.l	ArtUnc_InvStars
	dc.l	ArtUnc_TimeStars
	dc.l	ArtUnc_GameOver
	dc.l	ArtUnc_TimeOver

; -------------------------------------------------------------------------
