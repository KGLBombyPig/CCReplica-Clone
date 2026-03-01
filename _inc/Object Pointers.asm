; ---------------------------------------------------------------------------
; Object pointers
; ---------------------------------------------------------------------------
                dc.l ObjSonic                                                ; 01
                dc.l Obj02                                                   ; 02
                dc.l Obj03                                                   ; 03
                dc.l Obj04                                                   ; 04
                dc.l Obj05                                                   ; 05
                dc.l Obj06                                                   ; 06
                dc.l Obj07                                                   ; 07
		dc.l NullObject                                              ; 08
                dc.l ObjSonicSpecial                                         ; 09
                dc.l NullObject                                              ; 0A
                dc.l NullObject                                              ; 0B
		dc.l NullObject                                              ; 0C
                dc.l ObjSignpost                                             ; 0D
                dc.l ObjTitleSonic                                           ; 0E
                dc.l ObjTitleText                                            ; 0F
		dc.l ObjAniTest                                              ; 10
                dc.l ObjBridge                                               ; 11
                dc.l ObjSceneryLamp                                          ; 12
                dc.l ObjLavaMaker                                            ; 13
		dc.l ObjLavaball                                             ; 14
                dc.l ObjSwingPtfm                                            ; 15
                dc.l NullObject                                              ; 16
                dc.l ObjSpikeLogs                                            ; 17
		dc.l ObjPlatform                                             ; 18
                dc.l ObjRollingBall                                          ; 19
                dc.l ObjCollapsePtfm                                         ; 1A
                dc.l Obj1B                                                   ; 1B
		dc.l ObjScenery                                              ; 1C
                dc.l ObjUnkSwitch                                            ; 1D
                dc.l ObjBallhog                                              ; 1E
                dc.l ObjCrabmeat                                             ; 1F
		dc.l ObjCannonball                                           ; 20
                dc.l ObjHUD                                                  ; 21
                dc.l ObjBuzzbomber                                           ; 22
                dc.l ObjBuzzMissile                                          ; 23
		dc.l ObjCannonballExplode                                    ; 24
                dc.l ObjRings                                                ; 25
                dc.l ObjMonitor                                              ; 26
                dc.l ObjExplode                                              ; 27
		dc.l ObjAnimals                                              ; 28
                dc.l ObjPoints                                               ; 29
                dc.l Obj2A                                                   ; 2A
                dc.l ObjChopper                                              ; 2B
                dc.l ObjJaws                                                 ; 2C

NullObject:
		;bra.w	DeleteObject	; It would be safer to have this instruction here, but instead it just falls through to ObjectFall