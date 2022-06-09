; -------------------------------------------------------------------------
; Sonic CD Disassembly
; By Ralakimus 2021
; -------------------------------------------------------------------------
; Level definitions
; -------------------------------------------------------------------------

	include	"_Include/Common.i"
	include	"_Include/Main CPU.i"
	include	"_Include/Main CPU Variables.i"
	include	"_Include/Sound.i"
	include	"_Include/MMD.i"
	
; -------------------------------------------------------------------------
; Object structure
; -------------------------------------------------------------------------

	rsreset

oID		rs.b	1			; ID

oRender		rs.b	1			; Render flags
oTile		rs.w	1			; Base tile ID
oMap		rs.l	1			; Sprite mappings pointer

oX		rs.w	1			; X position
oYScr		rs.b	0			; Y position (screen mode)
oXSub		rs.w	1			; X position subpixel
oY		rs.l	1			; Y position

oXVel		rs.w	1			; X velocity
oYVel		rs.w	1			; Y velocity

oVar14		rs.b	1			; Object specific flags
oVar15		rs.b	1

oYRadius	rs.b	1			; Y radius
oXRadius	rs.b	1			; X radius
oPriority	rs.b	1			; Sprite draw priority level
oWidth		rs.b	1			; Width

oMapFrame	rs.b	1			; Sprite mapping frame ID
oAnimFrame	rs.b	1			; Animation script frame ID
oAnim		rs.b	1			; Animation ID
oPrevAnim	rs.b	1			; Previous previous animation ID
oAnimTime	rs.b	1			; Animation timer

oVar1F		rs.b	1			; Object specific flag

oVar20		rs.b	0			; Object specific flag
oColType	rs.b	1			; Collision type
oVar21		rs.b	0			; Object specific flag
oColStatus	rs.b	1			; Collision status

oStatus		rs.b	1			; Status flags
oRespawn	rs.b	1			; Respawn table entry ID
oRoutine	rs.b	1			; Routine ID
oVar25		rs.b	0			; Object specific flag
oRoutine2	rs.b	1			; Secondary routine ID
oAngle		rs.b	1			; Angle

oVar27		rs.b	1			; Object specific flag

oSubtype	rs.b	1			; Subtype ID
oSubtype2	rs.b	1			; Secondary subtype ID

oVar2A		rs.b	1			; Object specific flags
oVar2B		rs.b	1
oVar2C		rs.b	1
oVar2D		rs.b	1
oVar2E		rs.b	1
oVar2F		rs.b	1
oVar30		rs.b	1
oVar31		rs.b	1
oVar32		rs.b	1
oVar33		rs.b	1
oVar34		rs.b	1
oVar35		rs.b	1
oVar36		rs.b	1
oVar37		rs.b	1
oVar38		rs.b	1
oVar39		rs.b	1
oVar3A		rs.b	1
oVar3B		rs.b	1
oVar3C		rs.b	1
oVar3D		rs.b	1
oVar3E		rs.b	1
oVar3F		rs.b	1

oSize		rs.b	0			; Length of object structure

; -------------------------------------------------------------------------
; Player object variables
; -------------------------------------------------------------------------

oPlayerGVel		EQU	oVar14		; Ground velocity
oPlayerCharge		EQU	oVar2A		; Peelout/spindash charge timer

oPlayerCtrl		EQU	oVar2C		; Control flags
oPlayerJump		EQU	oVar3C		; Jump flag
oPlayerMoveLock		EQU	oVar3E		; Movement lock timer

oPlayerPriAngle		EQU	oVar36		; Primary angle
oPlayerSecAngle		EQU	oVar37		; Secondary angle
oPlayerStick		EQU	oVar38		; Collision stick flag

oPlayerHurt		EQU	oVar30		; Hurt timer
oPlayerInvinc		EQU	oVar32		; Invincibility timer
oPlayerShoes		EQU	oVar34		; Speed shoes timer
oPlayerReset		EQU	oVar3A		; Reset timer

oPlayerRotAngle		EQU	oVar2B		; Platform rotation angle
oPlayerRotDist		EQU	oVar39		; Platform rotation distance

oPlayerPushObj		EQU	oVar20		; ID of object being pushed on
oPlayerStandObj		EQU	oVar3D		; ID of object being stood on

; -------------------------------------------------------------------------
; RAM
; -------------------------------------------------------------------------

	rsset	WORKRAM+$2000
blockBuffer 		rs.b	$2000		; Block buffer
unkLvlBuffer2 		rs.b	$1000		; Unknown buffer
			rs.b	$3000

	rsset	WORKRAM+$FF00A000
levelLayout 		rs.b	$800		; Level layout
deformBuffer		rs.b	$200		; Deformation buffer
nemBuffer		rs.b	$200		; Nemesis decompression buffer
objDrawQueue		rs.b	$400		; Object draw queue
			rs.b	$1800
sonicArtBuf 		rs.b	$300		; Sonic art buffer
sonicRecordBuf		rs.b	$100		; Sonic position record buffer
hscroll 		rs.b	$400		; Horizontal scroll buffer

objects			rs.b	0		; Object pool
objPlayerSlot 		rs.b	oSize		; Player slot
objPlayerSlot2 		rs.b	oSize		; Player 2 slot
objHUDScoreSlot		rs.b	oSize		; HUD (score) slot
objHUDLivesSlot		rs.b	oSize		; HUD (lives) slot
objTtlCardSlot		rs.b	oSize		; Title card slot
objHUDRingsSlot		rs.b	oSize		; HUD (rings) slot
objShieldSlot 		rs.b	oSize		; Shield slot
objBubblesSlot 		rs.b	oSize		; Bubbles slot
objInvStar1Slot		rs.b	oSize		; Invincibility star 1 slot
objInvStar2Slot		rs.b	oSize		; Invincibility star 2 slot
objInvStar3Slot		rs.b	oSize		; Invincibility star 3 slot
objInvStar4Slot		rs.b	oSize		; Invincibility star 4 slot
objTimeStar1Slot	rs.b	oSize		; Time warp star 1 slot
objTimeStar2Slot	rs.b	oSize		; Time warp star 2 slot
objTimeStar3Slot	rs.b	oSize		; Time warp star 3 slot
objTimeStar4Slot	rs.b	oSize		; Time warp star 4 slot
			rs.b	oSize
			rs.b	oSize
			rs.b	oSize
			rs.b	oSize
			rs.b	oSize
			rs.b	oSize
			rs.b	oSize
			rs.b	oSize
			rs.b	oSize
			rs.b	oSize
			rs.b	oSize
			rs.b	oSize
			rs.b	oSize
			rs.b	oSize
			rs.b	oSize
objHUDIconSlot		rs.b	oSize		; HUD (life icon) slot

dynObjects 		rs.b	$60*oSize	; Dynamic object pool
objectsEnd		rs.b	0

			rs.b	$A
fmSndQueue1 		rs.b	1		; FM sound queue 1
fmSndQueue2 		rs.b	1		; FM sound queue 2
fmSndQueue3 		rs.b	1		; FM sound queue 3
			rs.b	$5F3
gameMode 		rs.b	1		; Game mode
			rs.b	1
			
playerCtrl		rs.b	0		; Player controller data
playerCtrlHold 		rs.b	1		; Player held controller data
playerCtrlTap		rs.b	1		; Player tapped controller data
p1CtrlData		rs.b	0		; Player 1 controller data
p1CtrlHold 		rs.b	1		; Player 1 held controller data
p1CtrlTap		rs.b	1		; Player 1 tapped controller data
p2CtrlData		rs.b	0		; Player 2 controller data
p2CtrlHold 		rs.b	1		; Player 2 held controller data
p2CtrlTap		rs.b	1		; Player 2 tapped controller data

			rs.l	1
vdpReg01 		rs.w	1		; VDP register 1
			rs.b	6
vintTimer 		rs.w	1		; V-BLANK interrupt timer
vscrollScreen 		rs.l	1		; Vertical scroll (full screen)
hscrollScreen 		rs.l	1		; Horizontal scroll (full screen)
			rs.b	6
vdpReg0A 		rs.w	1		; H-BLANK interrupt counter
palFadeInfo		rs.b	0		; Palette fade info
palFadeStart		rs.b	1		; Palette fade start
palFadeLen 		rs.b	1		; Palette fade length

miscVariables		rs.b	0
vintECount 		rs.b	1		; V-BLANK interrupt routine E counter
			rs.b	1
vintRoutine 		rs.b	1		; V-BLANK interrupt routine ID
			rs.b	1
spriteCount 		rs.b	1		; Sprite count
			rs.b	9
rngSeed 		rs.l	1		; RNG seed
paused 			rs.w	1		; Paused flag
			rs.l	1
dmaCmdLow		rs.w	1		; DMA command low word buffer
			rs.l	1
waterHeight 		rs.w	1		; Water height (actual)
waterHeight2		rs.w	1		; Water height (average)
			rs.b	3
waterRoutine		rs.b	1		; Water routine ID
waterFullscreen 	rs.b	1		; Water fullscreen flag
			rs.b	$17
aniArtFrames		rs.b	6		; Animated art frames
aniArtTimers		rs.b	6		; Animated art timers
			rs.b	$E
plcBuffer 		rs.b	$60		; PLC buffer
plcNemWrite 		rs.l	1		; PLC 
plcRepeat 		rs.l	1		; PLC 
plcPixel 		rs.l	1		; PLC 
plcRow 			rs.l	1		; PLC 
plcRead 		rs.l	1		; PLC 
plcShift 		rs.l	1		; PLC 
plcTileCount 		rs.w	1		; PLC 
plcProcTileCnt 		rs.w	1		; PLC 
hintFlag 		rs.w	1		; H-BLANK interrupt flag
			rs.w	1
			
cameraX 		rs.l	1		; Camera X position
cameraY 		rs.l	1		; Camera Y position
cameraBgX 		rs.l	1		; Background camera X position
cameraBgY 		rs.l	1		; Background camera Y position
cameraBg2X 		rs.l	1		; Background 2 camera X position
cameraBg2Y 		rs.l	1		; Background 2 camera Y position
cameraBg3X 		rs.l	1		; Background 3 camera X position
cameraBg3Y 		rs.l	1		; Background 3 camera Y position
destLeftBound		rs.w	1		; Camera left boundary destination
destRightBound		rs.w	1		; Camera right boundary destination
destTopBound		rs.w	1		; Camera top boundary destination
destBottomBound		rs.w	1		; Camera bottom boundary destination
leftBound 		rs.w	1		; Camera left boundary
rightBound 		rs.w	1		; Camera right boundary
topBound 		rs.w	1		; Camera top boundary
bottomBound 		rs.w	1		; Camera bottom boundary
unusedF730 		rs.w	1
leftBound3 		rs.w	1
			rs.b	6
scrollXDiff		rs.w	1		; Horizontal scroll difference
scrollYDiff		rs.w	1		; Vertical scroll difference
camYCenter 		rs.w	1		; Camera Y center
unusedF740 		rs.b	1
unusedF741 		rs.b	1
eventRoutine		rs.w	1		; Level event routine ID
scrollLock 		rs.w	1		; Scroll lock flag
unusedF746 		rs.w	1
unusedF748 		rs.w	1
horizBlkCrossed		rs.b	1		; Horizontal block crossed flag
vertiBlkCrossed		rs.b	1		; Vertical block crossed flag
horizBlkCrossedBg	rs.b	1		; Horizontal block crossed flag (background)
vertiBlkCrossedBg	rs.b	1		; Vertical block crossed flag (background)
horizBlkCrossedBg2	rs.b	2		; Horizontal block crossed flag (background 2)
horizBlkCrossedBg3	rs.b	1		; Horizontal block crossed flag (background 3)
			rs.b	1
			rs.b	1
			rs.b	1
scrollFlags 		rs.w	1		; Scroll flags
scrollFlagsBg		rs.w	1		; Scroll flags (background)
scrollFlagsBg2		rs.w	1		; Scroll flags (background 2)
scrollFlagsBg3		rs.w	1		; Scroll flags (background 3)
btmBoundShift		rs.w	1		; Bottom boundary shifting flag
			rs.w	1
			
sonicTopSpeed		rs.w	1		; Sonic top speed
sonicAcceleration	rs.w	1		; Sonic acceleration
sonicDeceleration	rs.w	1		; Sonic deceleration
sonicLastFrame		rs.b	1		; Sonic's last sprite frame ID
updateSonicArt		rs.b	1		; Update Sonic's art flag
primaryAngle		rs.b	1		; Primary angle
			rs.b	1
secondaryAngle		rs.b	1		; Secondary angle
			rs.b	1
			
objManagerRout		rs.b	1		; Object manager routine ID
			rs.b	1
objPrevCamX		rs.w	1		; Previous camera X position
objLoadAddrR		rs.l	1		; Object layout address (right side)
objLoadAddrL		rs.l	1		; Object layout address (left side)
objLoadAddr2R		rs.l	1		; Object layout address 2 (right side)
objLoadAddr2L		rs.l	1		; Object layout address 2 (left side)
boredTimer 		rs.w	1		; Bored timer
boredTimerP2 		rs.w	1		; Player 2 bored timer
timeWarpDir		rs.b	1		; Time warp direction
			rs.b	1
timeWarpTimer		rs.w	1		; Time warp timer
lookMode 		rs.b	1		; Look mode
			rs.b	1
demoPtr 		rs.l	1		; Demo data pointer
demoTimer 		rs.w	1		; Demo timer
demoS1Index 		rs.w	1		; Demo index (Sonic 1 leftover)
			rs.l	1
collisionPtr		rs.l	1		; Collision data pointer
			rs.b	6
camXCenter 		rs.w	1		; Camera X center
			rs.b	5
bossFlags		rs.b	1		; Boss flags
sonicRecordIndex	rs.w	1		; Sonic position record buffer index
bossFight 		rs.b	1		; Boss fight flag
			rs.b	1
specialChunks 		rs.l	1		; Special chunk IDs
palCycleSteps 		rs.b	7		; Palette cycle steps
palCycleTimers		rs.b	7		; Palette cycle timers
			rs.b	9
windTunnelFlag		rs.b	1		; Wind tunnel flag
			rs.b	1
			rs.b	1
waterSlideFlag 		rs.b	1		; Water slide flag
			rs.b	1
ctrlLocked 		rs.b	1		; Controls locked flag
			rs.b	3
scoreChain		rs.w	1		; Score chain
bonusCount1		rs.w	1		; Bonus countdown 1
bonusCount2		rs.w	1		; Bonus countdown 2
updateResultsBonus	rs.b	1		; Update results bonus flag
			rs.b	3
savedSR 		rs.w	1		; Saved status register
			rs.b	$24
sprites 		rs.b	$200		; Sprite buffer
waterFadePal		rs.b	$80		; Water fade palette buffer (uses part of sprite buffer)
waterPalette		rs.b	$80		; Water palette buffer
palette 		rs.b	$80		; Palette buffer
fadePalette 		rs.b	$80		; Fade palette buffer

; -------------------------------------------------------------------------
; Background section
; -------------------------------------------------------------------------
; PARAMETERS:
;	size - Size of scrion
;	id   - Section type
; -------------------------------------------------------------------------

BGSTATIC	EQU	0
BGDYNAMIC1	EQU	2
BGDYNAMIC2	EQU	4
BGDYNAMIC3	EQU	6

; -------------------------------------------------------------------------

BGSECT macro size, id
	dcb.b	(\size)/16, \id
	endm

; -------------------------------------------------------------------------
; Start debug item index
; -------------------------------------------------------------------------
; PARAMETERS:
;	off - (OPTION) Count offset
; -------------------------------------------------------------------------

__dbgID = 0
DBSTART macro off
	__dbgCount: = 0
	if narg>0
		dc.b	(__dbgCount\#__dbgID\)+(\off)
	else
		dc.b	__dbgCount\#__dbgID
	endif
	even
	endm

; -------------------------------------------------------------------------
; Debug item
; -------------------------------------------------------------------------
; PARAMETERS:
;	id       - Object ID
;	mappings - Mappings
;	tile     - Tile ID
;	flip     - Flip flags
;	priority - Priority
;	frame    - Sprite frame
;	subtype  - Subtype
;	subtype2 - Subtype 2
; -------------------------------------------------------------------------

DBGITEM macro id, mappings, tile, flip, priority, frame, subtype, subtype2
	dc.b	\id, \priority
	dc.l	\mappings
	dc.w	\tile
	dc.b	\subtype, \flip, \subtype2, \frame
	__dbgCount: = __dbgCount+1
	endm

; -------------------------------------------------------------------------
; End debug item index
; -------------------------------------------------------------------------

DBGEND macro
	__dbgCount\#__dbgID: EQU __dbgCount
	endm

; -------------------------------------------------------------------------