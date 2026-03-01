DebugLists:
                dc.w @GHZ-DebugLists
                dc.w @LZ-DebugLists
                dc.w @MZ-DebugLists
                dc.w @SLZ-DebugLists
		dc.w @SZ-DebugLists
                dc.w @CWZ-DebugLists
                
dbug:	macro map,object,subtype,frame,vram
	dc.l map+(object<<24)
	dc.b subtype,frame
	dc.w vram
	endm

@GHZ:
	dc.w (@GHZend-@GHZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	MapBallhog,	$1E,	0,	0,	$2400
	dbug	MapJaws,	$2C,	0,	0,	$47B
	;dbug	MapBurrobot,	$2D,	0,	0,	$247B
	;dbug	Map1B,	$1B,	0,	0,	$4000
	@GHZend:

@LZ:	
        dc.w (@LZend-@LZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	;dbug 	MapRing,	$25,	0,	0,	$27B2
	;dbug	MapMonitor,	$26,	0,	0,	$680
	dbug	MapBurrobot,	$2D,	0,	0,	$247B
	@LZend:

@MZ:	
        dc.w (@MZend-@MZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	;dbug 	MapRing,	$25,	0,	0,	$27B2
	;dbug	MapMonitor,	$26,	0,	0,	$680
	dbug	MapBuzzbomber,	$22,	0,	0,	$444
	dbug    MapLavaball,    $13,    0,      0,      $345
	;dbug    MapMZBlocks,    $46,    0,      0,      $4000
	;dbug    MapLavafall,    $4C,    0,      0,      $63A8
	;dbug    MapLavaChase,   $4E,    0,      0,      $63A8
	;dbug    MapPushBlock,   $33,    0,      0,      $42B8
	;dbug    MapMovingPtfm,  $52,    0,      0,      $2B8
	;dbug    MapCollapseFloor,$53,   0,      0,      $62B8
	;dbug    MapLavaHurt,    $54,    0,      0,      $8680
	;dbug    MapBasaran,     $55,    0,      0,      $24B8
	;dbug	Map1B,	$1B,	0,	0,	$4000

	@MZend:

@SLZ:	
        dc.w (@SLZend-@SLZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	MapRing,	$25,	0,	0,	$27B2
	dbug	MapMonitor,	$26,	0,	0,	$680
	dbug	MapCrabmeat,	$1F,	0,	0,	$400
	;dbug	Map1B,	$1B,	0,	0,	$4000

	@SLZend:

@SZ:	
        dc.w (@SZend-@SZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	;dbug 	MapRing,	$25,	0,	0,	$27B2
	;dbug	MapMonitor,	$26,	0,	0,	$680
	;dbug    MapRoller,      $43,    0,      0,      $24B8
	dbug    MapSceneryLamp, $12,    0,      0,      0
	;dbug    MapBumper,      $47,    0,      0,      $380
	dbug	MapCrabmeat,	$1F,	0,	0,	$400
	dbug	MapBuzzbomber,	$22,	0,	0,	$444
	;dbug    MapYadrin,      $50,    0,      0,      $47B
	dbug    MapPlatform2,   $18,    0,      0,      $4000
	;dbug    MapMovingBlocks,$56,    0,      0,      $4000
	;dbug    MapSwitch,      $32,    0,      0,      $513
	;dbug	Map1B,	$1B,	0,	0,	$4000

	@SZend:

@CWZ:
        dc.w (@CWZend-@CWZ-2)/8

;		mappings	object		subtype	frame	VRAM setting
	;dbug 	MapRing,	$25,	0,	0,	$27B2
	;dbug	MapMonitor,	$26,	0,	0,	$680
	;dbug	MapCrabmeat,	$1F,	0,	0,	$400
	dbug	Map1B,	$1B,	0,	0,	$4000

	@CWZend: