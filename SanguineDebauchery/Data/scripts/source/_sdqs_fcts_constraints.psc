Scriptname _sdqs_fcts_constraints extends Quest  
{ USED }
Import Utility
Import SKSE

_SDQS_functions Property funct  Auto
_SDQS_fcts_slavery Property fctSlavery  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

zadLibs Property libs Auto

Idle Property _SD_crawlMoveBackward Auto
Idle Property _SD_crawlStrafeBackLeft Auto
Idle Property _SD_crawlStrafeBackRight Auto
Idle Property _SD_crawlMoveForward Auto
Idle Property _SD_crawlStrafeStartRight Auto
Idle Property _SD_crawlStrafeStartLeft Auto
Idle Property _SD_crawlTurnLeft Auto
Idle Property _SD_crawlTurnRight Auto

int Property ModID Auto 
int Property mt_base Auto
int Property mtx_base Auto
int Property mtidle_base Auto
int Property sneakidle_base Auto
int Property sneakmt_base Auto
int Property ModCRC Auto
int Property ABC_ModID Auto
int Property ABC_mtidle Auto

ReferenceAlias Property _SDRAP_leash_center  Auto

ReferenceAlias Property _SDRAP_master  Auto  
GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_ArmbinderKnee  Auto  
GlobalVariable Property _SDGVP_DefaultStance Auto
GlobalVariable Property _SDGVP_AutoStance  Auto  

Keyword[] Property notKeywords  Auto  
Idle[] Property _SDIAP_bound  Auto  
Idle Property _SDIAP_reset  Auto  

Faction Property SexLabActiveFaction  Auto  
SexLabFramework property SexLab auto

Int sleepType
Actor kTarget
Actor kPlayer
ObjectReference kMaster
Int iOverride = -1

Int iTrust  
Int iDisposition 
Float fKneelingDistance 

Float fRFSU = 0.1
int throttle = 0 
String sPlayerLastStance = "" 

Bool bIsYokeEquipped = false
Bool bIsArmbinderEquipped = false
Bool bIsWristRestraintEquipped = false
Bool bIsYokeBBEquipped = false
Bool bIsArmbinderElbowEquipped = false
Bool bIsCuffsFrontEquipped = false
Bool bIsStraitJacketEquipped = false

Event OnInit()
;	_maintenance()
	InitAA()
EndEvent

Function InitAA()
	; Debug.Trace("[_sdras_load] Init SD+ FNIS aa")
	kPlayer = Game.getPlayer()

	ModCRC = FNIS_aa.GetInstallationCRC()  

	if ( ModCRC == 0 )    ; Installation Error: no AA generated by FNIS  
	else    
	  	ModID = FNIS_aa.GetAAModID("sdc", "sanguinesDebauchery", false) ; true during test only    
		mt_base=FNIS_aa.GetGroupBaseValue(ModID,FNIS_aa._mt(),"sanguinesDebauchery",false) 
		mtx_base=FNIS_aa.GetGroupBaseValue(ModID,FNIS_aa._mtx(),"sanguinesDebauchery",false) 
		mtidle_base=FNIS_aa.GetGroupBaseValue(ModID,FNIS_aa._mtidle(),"sanguinesDebauchery",false) 
		; sneakidle_base=FNIS_aa.GetGroupBaseValue(ModID,FNIS_aa._sneakidle(),"sanguinesDebauchery",true) 
		; sneakmt_base=FNIS_aa.GetGroupBaseValue(ModID,FNIS_aa._sneakmt(),"sanguinesDebauchery",true) 

		ABC_ModID = FNIS_aa.GetAAModID("abc", "DeviousDevices", false) 
		ABC_mtidle = FNIS_aa.GetGroupBaseValue(ABC_ModID, FNIS_aa._mtidle(), "DeviousDevices", false)

		; Debug.Notification("[SD] Crawl override initialized")
	endif

	; Debug.Trace("[SD] SD+ FNIS aa loaded")
	; Debug.Notification("[SD] SD+ FNIS aa loaded")

EndFunction


Function SetAnimating( Bool abEnable = True )
	; set to False to disable DDi animations temporarily
	libs.SetAnimating(libs.playerRef, abEnable)
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

Function actorCombatShutdown( Actor akAttacker, Actor akActor )
	If ( !akActor )
		Return
	EndIf

	; Drop current weapon - Do this first to prevent camera stuck in combat mode
	if(akActor.IsWeaponDrawn())
		akActor.SheatheWeapon()
		Utility.Wait(1.0)
	endif
	
	; Debug.Notification("[_sdqs_functions] Actor ordered to stand down")
	Debug.SendAnimationEvent(akActor, "Unequip")
	Debug.SendAnimationEvent(akActor, "UnequipNoAnim")

	If ( akActor.IsSneaking() )
		akActor.StartSneaking()
	EndIf
	akActor.StopCombatAlarm()
	akActor.Stopcombat()
	akAttacker.StopCombatAlarm()
	akAttacker.Stopcombat()
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



Function CollarEffectStart(Actor akTarget, Actor akCaster)
	kPlayer = Game.GetPlayer()
	kTarget = akTarget
	kMaster = StorageUtil.GetFormValue(kPlayer, "_SD_CurrentOwner") as Actor

	If ( kTarget == kPlayer ) && (StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryCollarOn") == 1)
		togglePlayerControlsOff()
		PlayIdleWrapper(kPlayer, _SDIAP_bound[0] )

		; Debug.Messagebox("The collar snaps around your neck.\nYou feel sluggish and unable to resist your owner's commands.")
	EndIf
 
EndFunction

Function CollarEffectFinish(Actor akTarget, Actor akCaster)

	If ( kTarget == kPlayer ) && (StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryCollarOn") == 1)
		if (StorageUtil.GetIntValue( kPlayer, "_SL_iPlayerSexAnim") == 0 )
			Utility.Wait( 2.0 )
			Debug.SendAnimationEvent(kPlayer, "IdleForceDefaultState")
		endIf

		togglePlayerControlsOff( False )
		kPlayer.PlayIdle( _SDIAP_reset )	

		; Debug.Messagebox("The collar releases its grasp around your will, leaving behind a screaming headache and bruises around your neck.")
		Debug.Notification("$The collar releases its grasp around your will...")
	EndIf

EndFunction

Function CollarUpdate()
	if (kPlayer == none)
		kPlayer = Game.getPlayer()
	endif

	kMaster = StorageUtil.GetFormValue(kPlayer, "_SD_CurrentOwner") as Actor
	bIsWristRestraintEquipped = fctOutfit.isWristRestraintEquipped( kPlayer ) 
	bIsYokeEquipped = fctOutfit.isYokeEquipped( kPlayer ) 
	bIsArmbinderEquipped = fctOutfit.isArmbinderEquipped( kPlayer ) 
	bIsYokeBBEquipped = fctOutfit.isYokeBBEquipped( kPlayer ) 
	bIsArmbinderElbowEquipped = fctOutfit.isArmbinderElbowEquipped( kPlayer ) 
	bIsCuffsFrontEquipped = fctOutfit.isCuffsFrontEquipped( kPlayer ) 
	bIsStraitJacketEquipped  = fctOutfit.isStraitJacketEquipped( kPlayer ) 

	If (!kMaster) || (!kTarget)  || (StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryCollarOn") == 0)
		Return
	EndIf

	If (kTarget!=kPlayer)
		Return
	endif

	; If (Utility.RandomInt( 0, 100 ) >= 99 )
	;	Debug.Notification( "Your collar weighs around your neck..." )
	; EndIf

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iSleepAnywhereON") == 1)
		If (StorageUtil.HasIntValue(kPlayer, "_SD_iSleepType"))
			sleepType = StorageUtil.GetIntValue(kPlayer, "_SD_iSleepType")
		Else
			sleepType = 1
		EndIf

		; Debug.Notification("[_sdmes_bound.psc] Stance: " +  StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance"))
		; Debug.Notification("[_sdmes_bound.psc] Sleep type: " +  StorageUtil.GetIntValue(kPlayer, "_SD_iSleepType"))
		; Debug.Notification("[_sdmes_bound.psc] Sleep pose: " +  StorageUtil.GetStringValue(kPlayer, "_SD_sSleepPose"))

		If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 1)
			if(sleepType == 1) ; Kneeling
				; Debug.MessageBox("Your owner reluctantly allows you to kneel and take a rest.")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC011") ; HandsBehindLieFaceDown

			elseif(sleepType == 2) ; Sitting	
				; Debug.MessageBox("Your owner accepts to let you sit for a while. ")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC012") ;  		HandsBehindLieSide						

			elseif(sleepType == 3) ; Sleeping sideway
				; Debug.MessageBox("You are allowed to lie down and sleep for a while. ")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC013") ;  		HandsBehindLieFaceUp						

			else  ; if(sleepType == 4) ; Sleeping 
				; Debug.MessageBox("Your owner lets you sleep on the ground. ")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC014") ;  		HandsBehindLieSideCurlUp

			endif
			
		ElseIf ( !bIsWristRestraintEquipped) 
			if(sleepType == 1) ; Kneeling
				; Debug.MessageBox("Your owner reluctantly allows you to kneel and take a rest.")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC020") ; 		HandsBehindKneelBowDown

			elseif(sleepType == 2) ; Sitting	
				; Debug.MessageBox("Your owner accepts to let you sit for a while. ")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC008") ;  HandsBehindSitFloorKneestoChest

			elseif(sleepType == 3) ; Sleeping sideway
				; Debug.MessageBox("You are allowed to lie down and sleep for a while. ")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC056") ;  		HogTieFaceDownLegsSpread

			else ; if(sleepType == 4) ; Sleeping 
				; Debug.MessageBox("Your owner lets you sleep on the ground. ")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC015") ;  		HandsBehindLieHogtieFaceDown

			endif
		else  
			StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC006") ;  		HandsBehindSitFloor		

		EndIf
	EndIf
	
	; Debug.Notification("[SD] AutoKneelingOff: " + StorageUtil.GetIntValue(kPlayer, "_SD_iDisablePlayerAutoKneeling"))
	; Debug.Notification("[SD] Stand: " + fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableStand") + " - Stance:" + StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance"))

	; If !(_SDGVP_ArmbinderKnee.GetValue()==0)
	;	StorageUtil.SetIntValue(kPlayer, "_SD_iHandsFree", 1)
	;	StorageUtil.SetIntValue(kPlayer, "_SD_iEnableStand", 1)
	;	StorageUtil.SetIntValue(kPlayer, "_SD_iDisablePlayerAutoKneeling", 1)
	;	StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStanceFollower", "Standing" ) 
	; EndIf

	StorageUtil.SetIntValue(kPlayer, "_SD_iEnableStand", 1)
	StorageUtil.SetIntValue(kPlayer, "_SD_iEnableKneel", 1)
	StorageUtil.SetIntValue(kPlayer, "_SD_iEnableCrawl", 1)

	If bIsArmbinderEquipped || bIsStraitJacketEquipped
	;	Debug.Notification("[SD] SD cuffs detected" )
		; StorageUtil.SetIntValue(kPlayer, "_SD_iHandsFree", 0)
		; StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStance", "Standing")
		StorageUtil.SetIntValue(kPlayer, "_SD_iEnableCrawl", 0)
		; StorageUtil.SetIntValue(kPlayer, "_SD_iDisablePlayerAutoKneeling", 0)
		; StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStanceFollower", "Kneeling" ) 

	ElseIf bIsYokeEquipped || bIsWristRestraintEquipped
	;	Debug.Notification("[SD] Yoke detected" )
		; StorageUtil.SetIntValue(kPlayer, "_SD_iHandsFree", 1)
		; StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStance", "Standing")
		StorageUtil.SetIntValue(kPlayer, "_SD_iEnableKneel", 0)
		StorageUtil.SetIntValue(kPlayer, "_SD_iEnableCrawl", 0)
		; StorageUtil.SetIntValue(kPlayer, "_SD_iDisablePlayerAutoKneeling", 1)
		; StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStanceFollower", "Standing" ) 
		

	EndIf

	; Force disabling of auto kneeling code for now - player should be able to cycle through kneeling, standing and cawling manually and suffer consequences if master doesn't allow them to stand 
	If (StorageUtil.GetIntValue(kPlayer, "_SD_iDisablePlayerAutoKneeling")!=1) && (_SDGVP_AutoStance.GetValue()==0)
		StorageUtil.SetIntValue(kPlayer, "_SD_iDisablePlayerAutoKneeling", 1)
	Else
		StorageUtil.SetIntValue(kPlayer, "_SD_iDisablePlayerAutoKneeling", 0)
	Endif

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iDisablePlayerAutoKneeling")==1) 
		if (!kPlayer.GetCurrentScene()) && (!kPlayer.IsOnMount()) && (StorageUtil.GetIntValue( kPlayer, "_SL_iPlayerSexAnim") == 0 )
			If (sPlayerLastStance != StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance"))
				UpdateStanceOverrides()
			endif
		endif
	Else
		if (!kPlayer.GetCurrentScene()) && (!kPlayer.IsOnMount()) && (StorageUtil.GetIntValue( kPlayer, "_SL_iPlayerSexAnim") == 0 )
			sPlayerLastStance = StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance")
			UpdateStanceOverrides()
		endif
	EndIf

EndFunction

Function CollarStand()
	Bool bOk
	Int zadOverrideIndex

	if (kPlayer == none)
		kPlayer = Game.getPlayer()
	endif
	
	bIsWristRestraintEquipped = fctOutfit.isWristRestraintEquipped( kPlayer ) 
	bIsYokeEquipped = fctOutfit.isYokeEquipped( kPlayer ) 
	bIsArmbinderEquipped = fctOutfit.isArmbinderEquipped( kPlayer ) 
	bIsYokeBBEquipped = fctOutfit.isYokeBBEquipped( kPlayer ) 
	bIsArmbinderElbowEquipped = fctOutfit.isArmbinderElbowEquipped( kPlayer ) 
	bIsCuffsFrontEquipped = fctOutfit.isCuffsFrontEquipped( kPlayer ) 
	bIsStraitJacketEquipped  = fctOutfit.isStraitJacketEquipped( kPlayer ) 

	If bIsArmbinderEquipped  || bIsStraitJacketEquipped
		Debug.Notification("$[SD] Reset stance for Armbinder")
		zadOverrideIndex = 0 ;   0 - bound hands in back / 1 - yoke
		bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mtidle", ABC_mtidle , zadOverrideIndex, "DeviousDevices", false)   

	ElseIf  bIsYokeEquipped 
		Debug.Notification("$[SD] Reset stance for Yoke")
		zadOverrideIndex = 1 ;   
		bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mtidle", ABC_mtidle , zadOverrideIndex, "DeviousDevices", false)   

	ElseIf  bIsArmbinderElbowEquipped 
		Debug.Notification("$[SD] Reset stance for Armbinder Elbow")
		zadOverrideIndex = 3 ;   
		bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mtidle", ABC_mtidle , zadOverrideIndex, "DeviousDevices", false)   

	ElseIf  bIsYokeBBEquipped 
		Debug.Notification("$[SD] Reset stance for YokeBB")
		zadOverrideIndex = 4 ;  
		bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mtidle", ABC_mtidle , zadOverrideIndex, "DeviousDevices", false)   

	ElseIf  bIsCuffsFrontEquipped 
		Debug.Notification("$[SD] Reset stance for Cuffs Front")
		zadOverrideIndex = 5 ;   
		bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mtidle", ABC_mtidle , zadOverrideIndex, "DeviousDevices", false)   

	Elseif  (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") != "Crawling") ; && (iOverride != 6)
		Debug.Notification("$[SD] Reset stance for default standing")
		bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mtidle", 0, 0, "sanguinesDebauchery", false)  

		if (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Standing")	
			ResetStanceOverrides()
		EndIf		
  		; iOverride = 6
		; Debug.Notification("$[SD] Standing hands free override ON")
	;	PlayIdleWrapper(kPlayer, _SDIAP_reset )
	Endif
EndFunction

Function UpdateStanceOverrides(Bool bForceRefresh=False)
	Bool bOk

	if (kPlayer == none)
		kPlayer = Game.getPlayer()
	endif
	
	bIsWristRestraintEquipped = fctOutfit.isWristRestraintEquipped( kPlayer ) 
	kMaster = StorageUtil.GetFormValue(kPlayer, "_SD_CurrentOwner") as Actor

	If (kMaster)
		iTrust = StorageUtil.GetIntValue(kMaster, "_SD_iTrust")  
		iDisposition = StorageUtil.GetIntValue(kMaster, "_SD_iDisposition")
		fKneelingDistance = funct.floatWithinRange( 500.0 - ((iTrust as Float) * 5.0), 100.0, 2000.0 )
	else
		iTrust = 1  
		iDisposition = 1
		fKneelingDistance = 500
	endif


	If (StorageUtil.HasStringValue( kPlayer , "_SD_sDefaultStance"))
		If (StorageUtil.GetStringValue( kPlayer, "_SD_sDefaultStance") == "Crawling")
			_SDGVP_DefaultStance.SetValue(  2 )
		ElseIf (StorageUtil.GetStringValue( kPlayer, "_SD_sDefaultStance") == "Kneeling")
			_SDGVP_DefaultStance.SetValue(  1 )
		ElseIf (StorageUtil.GetStringValue( kPlayer, "_SD_sDefaultStance") == "Standing")
			_SDGVP_DefaultStance.SetValue(  0 )
		EndIf
	Else
		_SDGVP_DefaultStance.SetValue( 0 )
		StorageUtil.SetStringValue( kPlayer, "_SD_sDefaultStance", "Standing")
	EndIf

	; If (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") != sPlayerLastStance) || (bForceRefresh)
  		; if player is enslaved, has a collar and is forced to crawl
	  	if  (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Crawling") ;&& fctOutfit.isCollarEquipped( kPlayer ) && (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
	  		bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mtidle", mtidle_base, 0, "sanguinesDebauchery", false)  
	  		bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mt", mt_base, 0, "sanguinesDebauchery", false)  
	  		bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mtx", mtx_base, 0, "sanguinesDebauchery", false)  
	  		; bOk = FNIS_aa.SetAnimGroup(kPlayer, "_sneakidle", sneakidle_base, 0, "sanguinesDebauchery", true) 
	  		bOk = FNIS_aa.SetAnimGroup(kPlayer, "_sneakidle", 0, 0, "sanguinesDebauchery", false)  
	  		bOk = FNIS_aa.SetAnimGroup(kPlayer, "_sneakmt", 0, 0, "sanguinesDebauchery", false)  
			; Debug.Trace("[SD] Crawl override ON")

			if (fctOutfit.isWristRestraintEquipped( kPlayer ))  
				fctOutfit.ClearSlavePunishment(kPlayer , "WristRestraints" , true )
				StorageUtil.SetIntValue(kPlayer , "_SD_iHandsFreeSex", 1)
			EndIf
			
	  	Elseif  (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Kneeling") ; && fctOutfit.isCollarEquipped( kPlayer ) && (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1) 

			; If (( fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableStand") ) && (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Standing")) || ((!fctOutfit.isArmbinderEquipped( kPlayer))  && (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") != "Crawling") )
			; 	CollarStand()

			If ( iTrust < 0 ) && (iDisposition < 0) 
	  			bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mtidle", mtidle_base, 4, "sanguinesDebauchery", false) 
				; Debug.Trace("[SD] Kneel ground override ON")

			ElseIf ( iTrust >= 0 ) && (iDisposition < 0) 
	  			bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mtidle", mtidle_base, 2, "sanguinesDebauchery", false)
				; Debug.Trace("[SD] Kneel submissive override ON")

			Else
	  			bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mtidle", mtidle_base, 1, "sanguinesDebauchery", false) 
				; Debug.Trace("[SD] Kneel proud override ON")
			EndIf

	 
	  		; bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mt", mt_base, 0, "sanguinesDebauchery", true)  
	  		; bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mtx", mtx_base, 0, "sanguinesDebauchery", true)  
	  		; bOk = FNIS_aa.SetAnimGroup(kPlayer, "_sneakidle", sneakidle_base, 0, "sanguinesDebauchery", true)  
	  		; bOk = FNIS_aa.SetAnimGroup(kPlayer, "_sneakmt", sneakmt_base, 0, "sanguinesDebauchery", true)  
			
	  	else ; set vanilla     
	  		If (bIsWristRestraintEquipped)
	  			CollarStand()
	  		else
	  			ResetStanceOverrides()
		  	Endif
			; Debug.Trace("[SD] Stance override OFF")
	  	endif 
	; Endif

	sPlayerLastStance = StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance")
EndFunction

Function ResetStanceOverrides()
	Bool bOk
	
	if (kPlayer == none)
		kPlayer = Game.getPlayer()
	endif
	
	bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mtidle", 0, 0, "sanguinesDebauchery", false)  
	bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mt", 0, 0, "sanguinesDebauchery", false)  
	bOk = FNIS_aa.SetAnimGroup(kPlayer, "_mtx", 0, 0, "sanguinesDebauchery", false)  
	bOk = FNIS_aa.SetAnimGroup(kPlayer, "_sneakidle", 0, 0, "sanguinesDebauchery", false)  
	bOk = FNIS_aa.SetAnimGroup(kPlayer, "_sneakmt", 0, 0, "sanguinesDebauchery", false)

	; libs.BoundCombat.Remove_ABC(kPlayer) - deprecated in DDi 4.0
	libs.BoundCombat.EvaluateAA(kPlayer)
EndFunction

Function PlayIdleWrapper(actor akActor, idle theIdle)
	akActor.PlayIdle(theIdle)
EndFunction

