Scriptname _sdqs_fcts_constraints extends Quest  
{ USED }
Import Utility
Import SKSE

Function playerAutoPilot( Bool abEnable = True )
	If ( abEnable )
	;	Game.DisablePlayerControls( abCamSwitch = True, abSneaking = True )
		Game.ForceThirdPerson()
	;	Game.SetPlayerAIDriven()
	Else
	;	Game.EnablePlayerControls( abFighting = False, abMenu = False )
	;	Game.SetPlayerAIDriven( False)
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
Function togglePlayerControlsOff( Bool abOff = True, Bool abMove = False, Bool abAct = False )
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
		Game.DisablePlayerControls( abMovement = abMove, abActivate = abAct )
	Else
		Game.EnablePlayerControls( )
	EndIf
EndFunction
