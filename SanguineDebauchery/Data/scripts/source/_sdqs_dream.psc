Scriptname _SDQS_dream extends Quest  Conditional

_SDQS_functions Property funct  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

ReferenceAlias Property _SDRAP_dreamer  Auto  
ReferenceAlias Property _SDRAP_enter  Auto  
ReferenceAlias Property _SDRAP_leave  Auto  
ReferenceAlias Property _SDRAP_naamah  Auto  
ReferenceAlias Property _SDRAP_meridiana  Auto  
ReferenceAlias Property _SDRAP_sanguine  Auto  
ReferenceAlias Property _SDRAP_sanguine_sam  Auto  
ReferenceAlias Property _SDRAP_sanguine_haelga  Auto  
ReferenceAlias Property _SDRAP_sanguine_m  Auto  
ReferenceAlias Property _SDRAP_sanguine_f Auto  
ReferenceAlias Property _SDRAP_nord_girl  Auto  
ReferenceAlias Property _SDRAP_imperial_man  Auto    
ReferenceAlias Property _SDRAP_eisheth  Auto  
ReferenceAlias Property _SDLA_safeHarbor  Auto  

Quest Property _SD_dream_destinations  Auto  
Quest Property SamQuest  Auto  
Quest Property HaelgaQuest  Auto  
_sdqs_dream_destinations property dreamDest Auto
SexLabFrameWork Property SexLab Auto

Int    iPlayerGender
Actor kDreamer
ObjectReference kSafeHarbor 
ObjectReference kEnter
ObjectReference kLeave
Actor kNaamah
Actor kSanguine
Actor kSanguine_sam
Actor kSanguine_haelga
Actor kSanguine_svana
Actor kSanguine_m
Actor kSanguine_f
Actor kMeridiana
Actor kNordGirl
Actor kRedguardGirl
Actor kImperialMan
Actor kEisheth
Actor kSvana
Actor kHaelga
Form fGagDevice = None
Bool bDeviousDeviceEquipped

Function sendDreamerBack( Int aiStage )
	; kSafeHarbor = _SDLA_safeHarbor.GetReference() as ObjectReference
	ReferenceAlias destinationAlias

	Game.EnablePlayerControls( abMenu = True )

	While (SexLab.ValidateActor( SexLab.PlayerRef ) <= 0)
	;
	EndWhile

    Game.FadeOutGame(true, true, 5.0, 10.0)
	StorageUtil.SetIntValue(none, "DN_ONOFF", 0)

	If ((aiStage == 10) || (aiStage == 15)) && (kEnter.GetDistance(kLeave)>200)  ; sent back to where player started
		kDreamer.MoveTo( kLeave )
		Utility.Wait( 1.0 )
		kLeave.MoveTo( kEnter )
	ElseIf (aiStage == 25) || (aiStage == 99); safety destination from pulled chain
		kDreamer.MoveTo( _SD_SafetyDest )
		Utility.Wait( 1.0 )
		kLeave.MoveTo( kEnter )
	Else
		 _SD_dream_destinations.Start()
		dreamDest.getDestination()
		Utility.Wait( 1.0 )
	      _SD_dream_destinations.Stop()

		SendModEvent("SDDreamworldStop") 

		kSafeHarbor = _SDLA_safeHarbor.GetReference() as ObjectReference 

		Debug.Trace("[_sdqs_dream] Moving to safe harbor : " + kSafeHarbor)
		If (kSafeHarbor != None)
			Debug.Trace("[_sdqs_dream] Random pick : " + kSafeHarbor)
			kDreamer.MoveTo( kSafeHarbor )
			Utility.Wait( 1.0 )
			kLeave.MoveTo( kEnter )
		ElseIf (kEnter.GetDistance(kLeave)>200)
			Debug.Trace("[_sdqs_dream] Last location : " + kSafeHarbor)
			kDreamer.MoveTo( kLeave )
			Utility.Wait( 1.0 )
			kLeave.MoveTo( kEnter )
		Else
			Debug.Trace("[_sdqs_dream] Safety dest - Honeybrew : " + kSafeHarbor)
			kDreamer.MoveTo( _SD_SafetyDest )
			Utility.Wait( 1.0 )
			kLeave.MoveTo( kEnter )
		EndIf

	EndIf
	
	; Self.SetStage( aiStage )
	Utility.Wait( 5.0 )
EndFunction

Event OnInit()
	Debug.Trace("_SDRAS_dream.OnInit()")
	kDreamer = _SDRAP_dreamer.GetReference() as Actor
	kEnter = _SDRAP_enter.GetReference() as ObjectReference
	kLeave = _SDRAP_leave.GetReference() as ObjectReference
	kSanguine = _SDRAP_sanguine.GetReference() as Actor
	kNaamah = _SDRAP_naamah.GetReference() as Actor
	kMeridiana = _SDRAP_meridiana.GetReference() as Actor
	kNordGirl = _SDRAP_nord_girl.GetReference() as Actor
	kImperialMan = _SDRAP_imperial_man.GetReference() as Actor
	kEisheth = _SDRAP_eisheth.GetReference() as Actor
EndEvent

Function positionVictims( Int aiStage )
	Int    iGenderRestrictions = _SDGVP_gender_restrictions.GetValue() as Int

	kDreamer = Game.GetPlayer() as Actor
	kEnter = _SDRAP_enter.GetReference() as ObjectReference
	kLeave = _SDRAP_leave.GetReference() as ObjectReference
	kNaamah = _SDRAP_naamah.GetReference() as Actor
	kMeridiana = _SDRAP_meridiana.GetReference() as Actor
	kNordGirl = _SDRAP_nord_girl.GetReference() as Actor
	kRedguardGirl = _SDRAP_redguard_girl.GetReference() as Actor
	kImperialMan = _SDRAP_imperial_man.GetReference() as Actor
	kEisheth = _SDRAP_eisheth.GetReference() as Actor
	kSanguine_m = _SDRAP_sanguine_m.GetReference() as Actor
	kSanguine_f = _SDRAP_sanguine_f.GetReference() as Actor
	kSanguine_sam = _SDRAP_sanguine_sam.GetReference() as Actor
	kSanguine_haelga = _SDRAP_sanguine_haelga.GetReference() as Actor
	kSanguine_svana = _SDRAP_sanguine_svana.GetReference() as Actor

	If !(kSanguine_m as ObjectReference).IsDisabled()
		(kSanguine_m as ObjectReference).Disable()
	EndIf
	If !(kSanguine_f as ObjectReference).IsDisabled()
		(kSanguine_f as ObjectReference).Disable()
	EndIf
	If !(kSanguine_sam as ObjectReference).IsDisabled()
		(kSanguine_sam as ObjectReference).Disable()
	EndIf
	If !(kSanguine_haelga as ObjectReference).IsDisabled()
		(kSanguine_haelga as ObjectReference).Disable()
	EndIf
	If !(kSanguine_svana as ObjectReference).IsDisabled()
		(kSanguine_svana as ObjectReference).Disable()
	EndIf

	iPlayerGender  = kDreamer.GetLeveledActorBase().GetSex() as Int

	If (Utility.RandomInt(0,100)>50)
		If (Utility.RandomInt(0,100)>70) && SamQuest.IsCompleted()
			kSanguine = _SDRAP_sanguine_sam.GetReference() as Actor
		Else
			kSanguine = _SDRAP_sanguine_m.GetReference() as Actor
		EndIf
	Else
		If (Utility.RandomInt(0,100)>70) && HaelgaQuest.IsCompleted()
			kSanguine = _SDRAP_sanguine_haelga.GetReference() as Actor
		Else
			kSanguine = _SDRAP_sanguine_f.GetReference() as Actor
		EndIf
	EndIf
 
	If (iPlayerGender  == 0)
		; iPlayerGender = 0 - male
		if (iGenderRestrictions == 1) 
			If (Utility.RandomInt(0,100)>70) && SamQuest.IsCompleted()
				kSanguine = _SDRAP_sanguine_sam.GetReference() as Actor
			Else
				kSanguine = _SDRAP_sanguine_m.GetReference() as Actor
			EndIf
		elseif (iGenderRestrictions == 2)
			If (Utility.RandomInt(0,100)>70) && HaelgaQuest.IsCompleted()
				kSanguine = _SDRAP_sanguine_svana.GetReference() as Actor
			Else
				kSanguine = _SDRAP_sanguine_f.GetReference() as Actor
			EndIf
		endif
			
	Else
		; iPlayerGender = 1 - female
		if (iGenderRestrictions == 1)
			If (Utility.RandomInt(0,100)>70) && HaelgaQuest.IsCompleted()
				kSanguine = _SDRAP_sanguine_svana.GetReference() as Actor
			Else
				kSanguine = _SDRAP_sanguine_f.GetReference() as Actor
			EndIf
		
		elseif (iGenderRestrictions == 2)
			If (Utility.RandomInt(0,100)>70) && SamQuest.IsCompleted()
				kSanguine = _SDRAP_sanguine_sam.GetReference() as Actor
			Else
				kSanguine = _SDRAP_sanguine_m.GetReference() as Actor
			EndIf
		
		endif
		
	EndIf

	_SDRAP_sanguine.ForceRefTo( kSanguine as ObjectReference )

	Actor kDremoraChallenger = _SD_DremoraChallenger as Actor

	SendModEvent("SDDreamworldStart") 
	_SDGVP_sanguine_blessing.SetValue( _SDGVP_sanguine_blessing.GetValue() + 1)

	kNaamah.EvaluatePackage()
	kMeridiana.EvaluatePackage()
	kEisheth.EvaluatePackage()
	kSanguine.EvaluatePackage()

	Utility.Wait(1.0)

	kMeridiana.MoveToMyEditorLocation()
	kEisheth.MoveToMyEditorLocation()
	kNordGirl.MoveToMyEditorLocation()
	kImperialMan.MoveToMyEditorLocation()
	kSanguine.MoveToMyEditorLocation()

	if (Utility.RandomInt(0,100) > 80)

		kDremoraChallenger.MoveToMyEditorLocation()
		kDremoraChallenger.enable()

		if (kDremoraChallenger.IsDead() )
			kDremoraChallenger.Resurrect()
		EndIf
	Else
		kDremoraChallenger.disable()

	EndIf

	kDreamer.StopCombatAlarm()
	kDreamer.StopCombat()
	Utility.Wait(0.1)

	; Game.SetPlayerAIDriven(false)
	; Game.SetInCharGen(false, false, false)
	; Game.EnablePlayerControls() ; just in case	

	; Debug.SendAnimationEvent(Game.GetPlayer(), "IdleForceDefaultState")
	; Game.SetCameraTarget(Game.GetPlayer())

    ; Game.DisablePlayerControls(abMovement = false, abFighting = false, abCamSwitch = true, abMenu = false, abActivate = false, abJournalTabs = false, aiDisablePOVType = 1)
    Game.ForceThirdPerson()
    ; Game.ShowFirstPersonGeometry(false)
	; Utility.Wait(0.1)

    ; Game.EnablePlayerControls(abMovement = false, abFighting = false, abCamSwitch = true, abLooking = false, abSneaking = false, abMenu = false, abActivate = false, abJournalTabs = false, aiDisablePOVType = 1)
    ; Game.ShowFirstPersonGeometry(true)

	; Game.DisablePlayerControls( abMenu = True )
	SexLab.ActorLib.StripActor(kDreamer, DoAnimate= false)

	Utility.Wait(0.1)

	; kDreamer.resethealthandlimbs()
	_SDSP_SanguineBound.RemoteCast(kDreamer, kDreamer, kDreamer)

	; _SDSP_spent.Cast( kDreamer, kDreamer)

	(kSanguine as ObjectReference).Enable()
	StorageUtil.StringListAdd(kSanguine, "_DDR_DialogExclude", "SD+:Sanguine")
	StorageUtil.StringListAdd(kNordGirl, "_DDR_DialogExclude", "SD+:Sanguine")
	StorageUtil.StringListAdd(kRedguardGirl, "_DDR_DialogExclude", "SD+:Sanguine")

	Utility.Wait(1.0)

	kSanguine.StopCombatAlarm()
	kSanguine.StopCombat()
	Utility.Wait(0.1)

	slaUtil.SetActorExhibitionist(kSanguine, True)
      slaUtil.UpdateActorExposureRate(kSanguine, 10.0)
      slaUtil.UpdateActorExposureRate(kImperialMan, 10.0)

	Debug.SendAnimationEvent(kEisheth, "ZazAPCAO212")
	Debug.SendAnimationEvent(kImperialMan,  "ZazAPCAO004")
	Debug.SendAnimationEvent(kNordGirl,  "ZazAPFSA004")

	if !kDreamer.IsInFaction(_SDP_BunkhouseFaction)
  		kDreamer.AddToFaction(_SDP_BunkhouseFaction)
	endIf

 
	; iFormIndex = _SD_sanguine_outfits.GetSize()
	; Outfit _SD_Sanguine_outfit = _SD_sanguine_outfits.GetAt(Utility.RandomInt(0,iFormIndex)) as Outfit
	; kSanguine.setoutfit( _SD_Sanguine_outfit )
	; Utility.Wait(1.0)

	; Node shape adjustments 

	; Attempt at changing weight of Sanguine randomly - issues with neck gap persist
	; Maybe an issue with it being attached to an Alias - Revisit later 
	
	; ActorBase sanguineActorBase = kSanguine.GetActorBase()
	; Float fWeightOrig = kSanguine.GetWeight()
	; Float fWeight = utility.RandomFloat(0.0, 100.0)
	; Float NeckDelta = (fWeightOrig / 100) - (fWeight / 100) ;Work out the neckdelta.
 
	; sanguineActorBase.SetWeight(fWeight) 
	; kSanguine.UpdateWeight(NeckDelta) ;Apply the changes.


	fctOutfit.sendSlaveTatModEvent(kDreamer, "SD+","Rose Stamp 1 (butt)" )
	
	Float fBreast  = 0.0
	Float fSchlong = 0.0
	Bool bEnableBreast  = NetImmerse.HasNode(kSanguine, "NPC L Breast", false)
	Bool bEnableSchlong     = NetImmerse.HasNode(kSanguine, "NPC GenitalsBase [GenBase]", false)

	Bool bBreastEnabled     = ( bEnableBreast as bool )
	Bool bSchlongEnabled     = ( bEnableSchlong as bool )

	if ( bBreastEnabled && kSanguine.GetLeveledActorBase().GetSex() == 1 )
		fBreast  = Utility.RandomFloat(0.5, 3.0) ; NetImmerse.GetNodeScale(kSanguine, "NPC L Breast", false)

		NetImmerse.SetNodeScale(kSanguine, "NPC L Breast", fBreast  , false)
		NetImmerse.SetNodeScale(kSanguine, "NPC R Breast", fBreast  , false)
		NetImmerse.SetNodeScale(kSanguine, "NPC L Breast", fBreast  , true)
		NetImmerse.SetNodeScale(kSanguine, "NPC R Breast", fBreast  , true)

		; Attempt at randomly giving a schlong to female sanguine - abandonned for now
		; Issues with getting a schlong when sanguine is back in male form
		if (StorageUtil.GetIntValue(kDreamer, "_SLH_iTG")==1)
			if (Utility.RandomInt(0, 100)>80)
	            ; kSanguine.SendModEvent("SLHSetSchlong", "UNP Bimbo")
			elseif (Utility.RandomInt(0, 100)>80)
	            ; kSanguine.SendModEvent("SLHRemoveSchlong")
	        endIf
	    endif		
	EndIf

	if ( bSchlongEnabled && kSanguine.GetLeveledActorBase().GetSex() == 0 )
		fSchlong = Utility.RandomFloat(1.2, 2.0) ; NetImmerse.GetNodeScale(kSanguine, "NPC GenitalsBase [GenBase]", false)
		; kSanguine.SendModEvent("SLHSetSchlong", "")

		NetImmerse.SetNodeScale(kSanguine, "NPC GenitalsBase [GenBase]", fSchlong , false)
		NetImmerse.SetNodeScale(kSanguine, "NPC GenitalsBase [GenBase]", fSchlong , true)
	EndIf

	Utility.Wait(2.0)
	kSanguine.QueueNiNodeUpdate()
	Utility.Wait(2.0)	

	; Random welcome scene
	Int randomNum = Utility.RandomInt(0, 100)

	If (randomNum > 80)
		kSanguine.SendModEvent("PCSubPunish") ; Punishment
	ElseIf (randomNum > 70)
		kSanguine.SendModEvent("PCSubEntertain", "Gangbang") ; Gang Bang
	ElseIf (randomNum > 60)
		kSanguine.SendModEvent("PCSubSex") ; Sex
	EndIf

EndFunction
 

ObjectReference Property _SD_SafetyDest  Auto  

Outfit Property _SDO_sanguine_chosen  Auto  

Outfit Property _SDO_naked  Auto  

Armor Property _SDA_collar_blood  Auto  

Armor Property _SDA_bindings  Auto  

Armor Property _SDA_gag  Auto  

Armor Property _SDA_sanguine_chosen  Auto  


slaUtilScr Property slaUtil  Auto  
 
FormList Property _SD_sanguine_outfits  Auto  

Faction Property _SDP_BunkhouseFaction  Auto  

GlobalVariable Property _SDGVP_enslaved Auto
GlobalVariable Property _SDGVP_enslavedSpriggan Auto
GlobalVariable Property _SDGVP_gender_restrictions Auto
ObjectReference Property _SD_DremoraChallenger  Auto  

ReferenceAlias Property _SDRAP_redguard_girl  Auto  

SPELL Property _SDSP_SanguineBound  Auto  

GlobalVariable Property _SDGVP_sanguine_blessing auto


ReferenceAlias Property _SDRAP_Sanguine_Svana  Auto  
