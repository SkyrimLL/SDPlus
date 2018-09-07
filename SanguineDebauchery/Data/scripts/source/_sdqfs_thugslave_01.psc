;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 39
Scriptname _sdqfs_thugslave_01 Extends Quest Hidden

;BEGIN ALIAS PROPERTY _SDRA_thug_2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_thug_2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_note
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_note Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_boss4
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_boss4 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_marker_capture
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_marker_capture Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_boss3
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_boss3 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDLA_boss2
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias__SDLA_boss2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDLA_dropoff
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias__SDLA_dropoff Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_master
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_master Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_thug_1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_thug_1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_mistwatch_bridge
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_mistwatch_bridge Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDLA_boss4
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias__SDLA_boss4 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_slave
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_slave Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_mistwatch_door
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_mistwatch_door Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDLA_boss1
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias__SDLA_boss1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDLA_boss3
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias__SDLA_boss3 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_mistwatch_christer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_mistwatch_christer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_boss1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_boss1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDLA_boss
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias__SDLA_boss Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_boss2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_boss2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_boss
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_boss Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_dropoff_box
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_dropoff_box Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
;BEGIN CODE
If ( kAMaster )
	kAMaster.AddToFaction( _SDFP_wiplayerenemy )
EndIf
If ( kAThug_1 )
	kAThug_1.AddToFaction( _SDFP_wiplayerenemy )
EndIf
If ( kAThug_2 )
	kAThug_2.AddToFaction( _SDFP_wiplayerenemy )
EndIf
;
; kmyQuest.stashAllStolenGoods( kAMaster, kContainer )
; kmyQuest.stashAllStolenGoods( kAThug_1, kContainer )
; kmyQuest.stashAllStolenGoods( kAThug_2, kContainer )
kNote.Enable()

Actor kChrister = Alias__SDRA_mistwatch_christer.GetActorReference()
kChrister.Enable()

ObjectReference kDoor = Alias__SDRA_mistwatch_door.GetReference()
;kDoor.Lock();

;_SDQP_enslavement.Stop()

SetObjectiveDisplayed( 30, False )
SetObjectiveDisplayed( 40 )
_SDSP_thug_scene_04.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; Game.ForceThirdPerson()
; Game.DisablePlayerControls( abMovement = true )
; Game.SetPlayerAIDriven()

_SDSP_thug_scene_02.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; stage 0
Actor kMaster  = Alias__SDRA_master.GetActorReference()
Actor kThug_1 = Alias__SDRA_thug_1.GetActorReference()
Actor kThug_2 = Alias__SDRA_thug_2.GetActorReference()

Actor kChrister = Alias__SDRA_mistwatch_christer.GetActorReference()
kChrister.Disable()

ObjectReference kDoor = Alias__SDRA_mistwatch_door.GetReference()
kDoor.Lock( False );

ObjectReference kBridge = Alias__SDRA_mistwatch_bridge.GetReference()
kBridge.SetOpen()

If ( kMaster )
	kMaster.StopCombat()
EndIf
If ( kThug_1 )
	kThug_1.StopCombat()
EndIf
If ( kThug_2 )
	kThug_2.StopCombat()
EndIf

_SDGVP_inTransit.SetValue(1)
SendModEvent("SDThugTransitStart")

alignParties( )
; main script monitors distances and
; advances to stage 10 when ready
	
;SetStage(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_27
Function Fragment_27()
;BEGIN CODE
Game.EnablePlayerControls( abMovement = true )
Game.SetPlayerAIDriven( False)

If ( kAMaster )
	kAMaster.RemoveFromFaction( _SDFP_wiplayerenemy )
EndIf
If ( kAThug_1 )
	kAThug_1.RemoveFromFaction( _SDFP_wiplayerenemy )
EndIf
If ( kAThug_2 )
	kAThug_2.RemoveFromFaction( _SDFP_wiplayerenemy )
EndIf

Actor kChrister = Alias__SDRA_mistwatch_christer.GetActorReference()
kChrister.Enable()

ObjectReference kDoor = Alias__SDRA_mistwatch_door.GetReference()
kDoor.Lock( False )

Utility.Wait(5)

Debug.Trace("[_sd_thugslave] Stage 25 - New master is humanoid")

SendModEvent("PCSubFree")


_SDGVP_inTransit.SetValue(0)
SendModEvent("SDThugTransitStop")
SendModEvent("SDMasterTransitStop")

If (kaBoss == None)
	if (kAMaster)
             kAMaster.SendModEvent("PCSubEnslaveRadius","300.0")
       else
		SendModEvent("PCSubEnslaveRadius","300.0")
	endif
Else
If ( !kABoss.IsDead() && !kABoss.IsDisabled() ) 
        Actor PlayerRef = Game.GetPlayer()
        Alias__SDRA_Master.GetReference().moveTo( kBoss )
	
        Game.FadeOutGame(true, true, 0.1, 15)
        PlayerRef.moveTo( kBoss )
	Game.FadeOutGame(false, true, 0.01, 10)

	StorageUtil.SetIntValue(kABoss, "_SD_iForcedSlavery", 1)

	Debug.MessageBox( "You finish the march bound and gagged and eventually wake up in front of your new master.")
        kABoss.SendModEvent("PCSubTransfer")
Else
	Debug.Notification("$SD_MESSAGE_MASTER_IS_DEAD_LUCK")
	if (kAMaster)
             kAMaster.SendModEvent("PCSubEnslaveRadius","300.0")
       else
		SendModEvent("PCSubEnslaveRadius","300.0")
	endif

EndIf
Endif
 
SetStage(50)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
Game.EnablePlayerControls( abMovement = true )
Game.SetPlayerAIDriven( False)

If ( kAMaster )
	kAMaster.RemoveFromFaction( _SDFP_wiplayerenemy )
EndIf
If ( kAThug_1 )
	kAThug_1.RemoveFromFaction( _SDFP_wiplayerenemy )
EndIf
If ( kAThug_2 )
	kAThug_2.RemoveFromFaction( _SDFP_wiplayerenemy )
EndIf

Actor kChrister = Alias__SDRA_mistwatch_christer.GetActorReference()
kChrister.Enable()

Debug.Notification( "You arrive to your new home.")
Utility.Wait(5)

_SDGVP_inTransit.SetValue(0)
SendModEvent("SDThugTransitStop")
SendModEvent("SDMasterTransitStop")

Debug.Trace("[_sd_thugslave] Stage 20 - New master is humanoid")

SendModEvent("PCSubFree")

If (kaBoss == None)
      if (kAMaster)
             kAMaster.SendModEvent("PCSubEnslaveRadius","300.0")
       else
             SendModEvent("PCSubEnslaveRadius","300.0")
       endif
Else
If ( !kABoss.IsDead() && !kABoss.IsDisabled() ) 
       kABoss.SendModEvent("PCSubTransfer")
Else
     Debug.Notification("$SD_MESSAGE_MASTER_IS_DEAD_LUCK")
     if (kAMaster)
             kAMaster.SendModEvent("PCSubEnslaveRadius","300.0")
       else
	SendModEvent("PCSubEnslaveRadius","300.0")
     endif



EndIf
Endif
 
SetStage(50)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN CODE
If (Alias__SDRA_master.GetActorReference())
	( Alias__SDRA_master.GetActorReference() as Actor).DeleteWhenAble()
Endif

If (Alias__SDRA_thug_1.GetActorReference() )
	( Alias__SDRA_thug_1.GetActorReference() as Actor).DeleteWhenAble()
endif

If (Alias__SDRA_thug_2.GetActorReference())
	( Alias__SDRA_thug_2.GetActorReference() as Actor).DeleteWhenAble()
Endif

Alias__SDRA_master.Clear()
Alias__SDRA_thug_1.Clear()
Alias__SDRA_thug_2.Clear()
Alias__SDRA_boss.Clear()
Alias__SDLA_boss.Clear()
Alias__SDRA_marker_capture.Clear()

; CompleteAllObjectives()
SetObjectiveDisplayed( 30, False )
SetObjectiveDisplayed( 40, False )

If ( _SDQP_WIThugs.IsRunning() )
	_SDQP_WIThugs.Stop();
EndIf

; Reset()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_34
Function Fragment_34()
;BEGIN CODE
; stage 0
Actor kMaster  = Alias__SDRA_master.GetActorReference()

If ( kMaster )
	kMaster.StopCombat()
EndIf

_SDGVP_inTransit.SetValue(1)
SendModEvent("SDMasterTransitStart")

; alignParties( )
; main script monitors distances and
; advances to stage 10 when ready
; SetStage(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_12
Function Fragment_12()
;BEGIN CODE
; advances to stage 40 when ready
fctInventory.stashAllStolenGoods( kAMaster, kContainer )
fctInventory.stashAllStolenGoods( kAThug_1, kContainer )
fctInventory.stashAllStolenGoods( kAThug_2, kContainer )

_SDSP_thug_scene_03.Start()
SetObjectiveDisplayed( 30 )
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_36
Function Fragment_36()
;BEGIN CODE
Game.EnablePlayerControls( abMovement = true )
Game.SetPlayerAIDriven( False)

If ( kAMaster )
	kAMaster.RemoveFromFaction( _SDFP_wiplayerenemy )
EndIf

Actor kChrister = Alias__SDRA_mistwatch_christer.GetActorReference()
kChrister.Enable()

Debug.Notification( "You arrive to your new home.")
Utility.Wait(5)

Debug.Trace("[_sd_thugslave] Stage 20 - New master is creature")

SendModEvent("PCSubFree")

_SDGVP_inTransit.SetValue(0)
SendModEvent("SDThugTransitStop")
SendModEvent("SDMasterTransitStop")

If (kaBoss == None)
     if (kAMaster)
             kAMaster.SendModEvent("PCSubEnslaveRadius","300.0")
       else
	SendModEvent("PCSubEnslaveRadius","300.0")
      endif
Else
If ( !kABoss.IsDead() && !kABoss.IsDisabled() ) 
       kABoss.SendModEvent("PCSubTransfer")
Else
      Debug.Notification("$SD_MESSAGE_MASTER_IS_DEAD_LUCK")
      if (kAMaster)
             kAMaster.SendModEvent("PCSubEnslaveRadius","300.0")
       else
	SendModEvent("PCSubEnslaveRadius","300.0")
      endif

EndIf
Endif
 
SetStage(50)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_38
Function Fragment_38()
;BEGIN CODE
Game.EnablePlayerControls( abMovement = true )
Game.SetPlayerAIDriven( False)

If ( kAMaster )
	kAMaster.RemoveFromFaction( _SDFP_wiplayerenemy )
EndIf

Actor kChrister = Alias__SDRA_mistwatch_christer.GetActorReference()
kChrister.Enable()

Utility.Wait(5)

_SDGVP_inTransit.SetValue(0)
SendModEvent("SDThugTransitStop")
SendModEvent("SDMasterTransitStop")

Debug.Trace("[_sd_thugslave] Stage 25 - New master is creature")

SendModEvent("PCSubFree")

If (kaBoss == None)
	if (kAMaster)
             kAMaster.SendModEvent("PCSubEnslaveRadius","300.0")
       else
		SendModEvent("PCSubEnslaveRadius","300.0")
	endif
Else
If ( !kABoss.IsDead() && !kABoss.IsDisabled() ) 
        Actor PlayerRef = Game.GetPlayer()
        Alias__SDRA_Master.GetReference().moveTo( kBoss )
	
        Game.FadeOutGame(true, true, 0.1, 15)
        PlayerRef.moveTo( kBoss )
	Game.FadeOutGame(false, true, 0.01, 10)

	StorageUtil.SetIntValue(kABoss, "_SD_iForcedSlavery", 1)

	Debug.MessageBox( "You finish the march in a blur and eventually wake up in front of your new master.")
        kABoss.SendModEvent("PCSubTransfer")
Else
	Debug.Notification("$SD_MESSAGE_MASTER_IS_DEAD_LUCK")
	if (kAMaster)
             kAMaster.SendModEvent("PCSubEnslaveRadius","300.0")
       else
		SendModEvent("PCSubEnslaveRadius","300.0")
	endif

EndIf
Endif
 
SetStage(50)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_32
Function Fragment_32()
;BEGIN CODE
; stage 0
Actor kMaster  = Alias__SDRA_master.GetActorReference()

Actor kChrister = Alias__SDRA_mistwatch_christer.GetActorReference()
kChrister.Disable()

ObjectReference kDoor = Alias__SDRA_mistwatch_door.GetReference()
kDoor.Lock( False );

ObjectReference kBridge = Alias__SDRA_mistwatch_bridge.GetReference()
kBridge.SetOpen()

If ( kMaster )
	kMaster.StopCombat()
EndIf

_SDGVP_inTransit.SetValue(1)
SendModEvent("SDMasterTransitStart")

; alignParties( )
; main script monitors distances and
; advances to stage 10 when ready
; SetStage(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_28
Function Fragment_28()
;BEGIN CODE
Game.EnablePlayerControls( abMovement = true )
Game.SetPlayerAIDriven( False)

If ( kAMaster )
	kAMaster.RemoveFromFaction( _SDFP_wiplayerenemy )
EndIf
If ( kAThug_1 )
	kAThug_1.RemoveFromFaction( _SDFP_wiplayerenemy )
EndIf
If ( kAThug_2 )
	kAThug_2.RemoveFromFaction( _SDFP_wiplayerenemy )
EndIf

Actor kChrister = Alias__SDRA_mistwatch_christer.GetActorReference()
kChrister.Enable()

Debug.Trace("[_sd_thugslave] Stage 26 - Sold by thugs")

SendModEvent("PCSubFree")

_SDGVP_inTransit.SetValue(0)
SendModEvent("SDThugTransitStop")
SendModEvent("SDmasterTransitStop")

	; Debug.Notification("$SD_MESSAGE_MASTER_IS_DEAD_LUCK")

	; _SDQP_WIThugs.Stop()
	; Stop()
	SetStage(50)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_functions Property funct Auto

GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_hardcore  Auto  

Scene Property _SDSP_thug_scene_02  Auto
Scene Property _SDSP_thug_scene_03  Auto
Scene Property _SDSP_thug_scene_04  Auto  
Quest Property _SDQP_enslavement  Auto
Quest Property _SDQP_WIThugs  Auto  
Keyword Property _SDKP_enslave  Auto
Faction Property _SDFP_wiplayerenemy  Auto  
FormList Property _SDFL_forced_allied  Auto  
Scene Property _SDSP_thug_arrest  Auto  



ObjectReference kSlave
ObjectReference kBoss
ObjectReference kContainer
ObjectReference kNote
Actor kABoss
Actor kAMaster
Actor kASlave
Actor kAThug_1
Actor kAThug_2
Actor kAClone

Function alignParties( )
	kAThug_2 = Alias__SDRA_thug_2.GetReference() as Actor
	kAThug_1 = Alias__SDRA_thug_1.GetReference() as Actor
	kASlave = Alias__SDRA_slave.GetReference() as Actor
	kAMaster = Alias__SDRA_master.GetReference() as Actor
	kABoss = Alias__SDRA_boss.GetReference() as Actor
	; SendStoryEvent
	kBoss = Alias__SDRA_boss.GetReference() as ObjectReference
	kSlave = Alias__SDRA_slave.GetReference() as ObjectReference
	kContainer = Alias__SDRA_dropoff_box.GetReference() as ObjectReference
	kNote = Alias__SDRA_note.GetReference() as ObjectReference
	
	
	fctFactions.syncActorFactions( kABoss, kASlave, _SDFL_forced_allied )
	If ( kAMaster )
		fctFactions.syncActorFactions( kABoss, kAMaster )
		kAMaster.EvaluatePackage()
	EndIf
	If ( kAThug_1 )
		fctFactions.syncActorFactions( kABoss, kAThug_1 )
		kAThug_1.EvaluatePackage()
	EndIf
	If ( kAThug_2 )
		fctFactions.syncActorFactions( kABoss, kAThug_2 )
		kAThug_2.EvaluatePackage()
	EndIf	
EndFunction

Function unAlignParties( )
	
	If ( kABoss )
		kABoss.EvaluatePackage()
	EndIf
	If ( kAMaster )
		kAMaster.EvaluatePackage()
	EndIf
	If ( kAThug_1 )
		kAThug_1.EvaluatePackage()
	EndIf
	If ( kAThug_2 )
		kAThug_2.EvaluatePackage()
	EndIf
EndFunction

GlobalVariable Property _SDGVP_inTransit  Auto  
_SDQS_fcts_inventory Property fctInventory  Auto
_SDQS_fcts_factions Property fctFactions  Auto
