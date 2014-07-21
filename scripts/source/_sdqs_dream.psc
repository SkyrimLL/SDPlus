Scriptname _SDQS_dream extends Quest  Conditional

_SDQS_functions Property funct  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

ReferenceAlias Property _SDRAP_dreamer  Auto  
ReferenceAlias Property _SDRAP_enter  Auto  
ReferenceAlias Property _SDRAP_leave  Auto  
ReferenceAlias Property _SDRAP_naamah  Auto  
ReferenceAlias Property _SDRAP_meridiana  Auto  
ReferenceAlias Property _SDRAP_sanguine  Auto  
ReferenceAlias Property _SDRAP_nord_girl  Auto  
ReferenceAlias Property _SDRAP_imperial_man  Auto    
ReferenceAlias Property _SDRAP_eisheth  Auto  
ReferenceAlias Property _SDLA_safeHarbor  Auto  

Quest Property _SD_dream_destinations  Auto  
_sdqs_dream_destinations property dreamDest Auto
SexLabFrameWork Property SexLab Auto

Actor kDreamer
ObjectReference kSafeHarbor 
ObjectReference kEnter
ObjectReference kLeave
Actor kNaamah
Actor kSanguine
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
	kDreamer = Game.GetPlayer() as Actor
	kEnter = _SDRAP_enter.GetReference() as ObjectReference
	kLeave = _SDRAP_leave.GetReference() as ObjectReference
	kSanguine = _SDRAP_sanguine.GetReference() as Actor
	kNaamah = _SDRAP_naamah.GetReference() as Actor
	kMeridiana = _SDRAP_meridiana.GetReference() as Actor
	kNordGirl = _SDRAP_nord_girl.GetReference() as Actor
	kRedguardGirl = _SDRAP_redguard_girl.GetReference() as Actor
	kImperialMan = _SDRAP_imperial_man.GetReference() as Actor
	kEisheth = _SDRAP_eisheth.GetReference() as Actor

	Actor kDremoraChallenger = _SD_DremoraChallenger as Actor


	kDreamer.StopCombatAlarm()
	kDreamer.StopCombat()
	Utility.Wait(0.1)

	Game.SetPlayerAIDriven(false)
	Game.SetInCharGen(false, false, false)
	Game.EnablePlayerControls() ; just in case	

	; Debug.SendAnimationEvent(Game.GetPlayer(), "IdleForceDefaultState")
	; Game.SetCameraTarget(Game.GetPlayer())

    ; Game.DisablePlayerControls(abMovement = false, abFighting = false, abCamSwitch = true, abMenu = false, abActivate = false, abJournalTabs = false, aiDisablePOVType = 1)
    Game.ForceThirdPerson()
    ; Game.ShowFirstPersonGeometry(false)
	; Utility.Wait(0.1)

    ; Game.EnablePlayerControls(abMovement = false, abFighting = false, abCamSwitch = true, abLooking = false, abSneaking = false, abMenu = false, abActivate = false, abJournalTabs = false, aiDisablePOVType = 1)
    ; Game.ShowFirstPersonGeometry(true)

	Game.DisablePlayerControls( abMenu = True )
	SexLab.ActorLib.StripActor(kDreamer, DoAnimate= false)

	Utility.Wait(0.1)

	kDreamer.resethealthandlimbs()

	; _SDSP_spent.Cast( kDreamer, kDreamer)

	kSanguine.Enable()
	StorageUtil.StringListAdd(kSanguine, "_DDR_DialogExclude", "SD+:Sanguine")
	StorageUtil.StringListAdd(kNordGirl, "_DDR_DialogExclude", "SD+:Sanguine")
	StorageUtil.StringListAdd(kRedguardGirl, "_DDR_DialogExclude", "SD+:Sanguine")

	Utility.Wait(1.0)

	kSanguine.StopCombatAlarm()
	kSanguine.StopCombat()
	Utility.Wait(0.1)
	
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
	EndIf

	if ( bSchlongEnabled && kSanguine.GetLeveledActorBase().GetSex() == 0 )
		fSchlong = Utility.RandomFloat(1.2, 2.0) ; NetImmerse.GetNodeScale(kSanguine, "NPC GenitalsBase [GenBase]", false)

		NetImmerse.SetNodeScale(kSanguine, "NPC GenitalsBase [GenBase]", fSchlong , false)
		NetImmerse.SetNodeScale(kSanguine, "NPC GenitalsBase [GenBase]", fSchlong , true)
	EndIf


	Utility.Wait(2.0)
	kSanguine.QueueNiNodeUpdate()
	Utility.Wait(2.0)	

	_SDSP_SanguineBound.RemoteCast(kDreamer, kDreamer, kDreamer)


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

ObjectReference Property _SD_DremoraChallenger  Auto  

ReferenceAlias Property _SDRAP_redguard_girl  Auto  

SPELL Property _SDSP_SanguineBound  Auto  
