;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 8
Scriptname _sdsf_thug_scene_02a Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Game.EnablePlayerControls( abMovement = True )
Game.SetPlayerAIDriven( False )

Self.GetOwningQuest().SetStage(20)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
; Game.DisablePlayerControls( abMovement = true )
; Game.SetPlayerAIDriven()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
ObjectReference kBoss = Alias__SDRA_boss.GetReference() as ObjectReference
Actor PlayerRef = Game.GetPlayer()

Game.FadeOutGame(true, true, 0.1, 15)

Alias__SDRA_Master.GetReference().moveTo( kBoss )
PlayerRef.moveTo( kBoss )

Debug.MessageBox( "You finish the march bound and gagged.")
Utility.Wait(5)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property Alias__SDRA_master  Auto  

ReferenceAlias Property Alias__SDRA_boss  Auto  
