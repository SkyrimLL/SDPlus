Scriptname _sdqs_fcts_constraints extends Quest  
{ USED }
Import Utility
Import SKSE

zadLibs Property libs Auto

Function SetAnimating( Bool abEnable = True )
	libs.SetAnimating(Game.GetPlayer(), abEnable)
EndFunction

Function playerAutoPilot( Bool abEnable = True )
	If ( abEnable )
		Game.DisablePlayerControls( abCamSwitch = True, abSneaking = True )
		Game.ForceThirdPerson()
		Game.SetPlayerAIDriven()
	Else
		Game.EnablePlayerControls( abFighting = False, abMenu = False )
		Game.SetPlayerAIDriven( False)
	EndIf
EndFunction

Function actorCombatShutdown( Actor akActor )
	If ( !akActor )
		Return
	EndIf

	; Debug.Notification("[_sdqs_functions] Actor ordered to stand down")
	Debug.SendAnimationEvent(akActor, "UnequipNoAnim")

	If ( akActor.IsSneaking() )
		akActor.StartSneaking()
	EndIf
	akActor.StopCombatAlarm()
	akActor.Stopcombat()
	; Debug.Notification("[_sdqs_functions] Actor should be calm now")
EndFunction


; alter game defaults to my defaults
Function togglePlayerControlsOff( Bool abOff = True, Bool abMove = False, Bool abAct = False, Bool abFight = False )
	If ( abOff )
		; abMovement: Disable the player's movement controls.
		; Default: True
		; abFighting: Disable the player's combat controls.
		; Default: True
		; abCamSwitch: Disable the ability to switch point of view.
		; Default: False
		; abLooking: Disable the player's look controls.
		; Default: False
		; abSneaking: Disable the player's sneak controls.
		; Default: False
		; abMenu: Disables menu controls (Journal, Inventory, Pause, etc.).
		; Default: True
		; abActivate: Disables ability for player to activate objects.
		; Default: True
		; abJournalTabs: Disables all Journal tabs except System.
		; Default: False
		; aiDisablePOVType: What system is disabling POV.
		; 0 = Script
		; 1 = Werewolf
		; Default: 0
		Game.DisablePlayerControls( abMovement = abMove, abActivate = abAct, abFighting = abFight )
	Else
		Game.EnablePlayerControls( )
	EndIf
EndFunction

Function togglePlayerControlsOn( Bool abOn = True, Bool abMove = False, Bool abAct = False, Bool abFight = False )
	If ( abOn )
		; abMovement: Disable the player's movement controls.
		; Default: True
		; abFighting: Disable the player's combat controls.
		; Default: True
		; abCamSwitch: Disable the ability to switch point of view.
		; Default: False
		; abLooking: Disable the player's look controls.
		; Default: False
		; abSneaking: Disable the player's sneak controls.
		; Default: False
		; abMenu: Disables menu controls (Journal, Inventory, Pause, etc.).
		; Default: True
		; abActivate: Disables ability for player to activate objects.
		; Default: True
		; abJournalTabs: Disables all Journal tabs except System.
		; Default: False
		; aiDisablePOVType: What system is disabling POV.
		; 0 = Script
		; 1 = Werewolf
		; Default: 0
		Game.EnablePlayerControls( abMovement = abMove, abActivate = abAct, abFighting = abFight )
	Else
		Game.DisablePlayerControls( )
	EndIf
EndFunction

Function setLeashCenterRef( ObjectReference kCenterRef )
 
 	StorageUtil.SetFormValue(Game.GetPlayer(), "_SD_LeashCenter", kCenterRef as Form)

 EndFunction

; EXPERIMENTAL ! 
;	Idle Property laughIdle Auto ; "IdleLaugh" here from CK
;	SetReplaceAnimation(akTarget, "moveStart", laughIdle)
Function togglePlayerCrawlAnimationsOn( Bool crawlOn = True )
	ObjectReference akTarget = Game.GetPlayer() 

	if (crawlOn)
		Debug.Notification("You are forced on your knees")
		ObjectUtil.SetReplaceAnimation(akTarget, "moveBackward", _SD_crawlMoveBackward)
		ObjectUtil.SetReplaceAnimation(akTarget, "strafeBackLeft", _SD_crawlStrafeBackLeft )
		ObjectUtil.SetReplaceAnimation(akTarget, "strafeBackRight", _SD_crawlStrafeBackRight )
		ObjectUtil.SetReplaceAnimation(akTarget, "moveForward", _SD_crawlMoveForward )
		ObjectUtil.SetReplaceAnimation(akTarget, "strafeStartRight", _SD_crawlStrafeStartRight )
		ObjectUtil.SetReplaceAnimation(akTarget, "strafeStartLeft", _SD_crawlStrafeStartLeft )
		ObjectUtil.SetReplaceAnimation(akTarget, "turnLeft", _SD_crawlTurnLeft )
		ObjectUtil.SetReplaceAnimation(akTarget, "turnRight", _SD_crawlTurnRight )
	Else
		ObjectUtil.RemoveReplaceAnimation(akTarget, "moveBackward")
		ObjectUtil.RemoveReplaceAnimation(akTarget, "strafeBackLeft")
		ObjectUtil.RemoveReplaceAnimation(akTarget, "strafeBackRight")
		ObjectUtil.RemoveReplaceAnimation(akTarget, "moveForward")
		ObjectUtil.RemoveReplaceAnimation(akTarget, "strafeStartRight")
		ObjectUtil.RemoveReplaceAnimation(akTarget, "strafeStartLeft")
		ObjectUtil.RemoveReplaceAnimation(akTarget, "turnLeft")
		ObjectUtil.RemoveReplaceAnimation(akTarget, "turnRight")
	EndIf
EndFunction



Idle Property _SD_crawlMoveBackward Auto
Idle Property _SD_crawlStrafeBackLeft Auto
Idle Property _SD_crawlStrafeBackRight Auto
Idle Property _SD_crawlMoveForward Auto
Idle Property _SD_crawlStrafeStartRight Auto
Idle Property _SD_crawlStrafeStartLeft Auto
Idle Property _SD_crawlTurnLeft Auto
Idle Property _SD_crawlTurnRight Auto

ReferenceAlias Property _SDRAP_leash_center  Auto