Scriptname SLD_QST_Main extends Quest  

Function SetNPCDialogueState ( Actor akSpeaker )
	ObjectReference akSpeakerRef = akSpeaker as objectReference
	Form kSpeakerForm = akSpeaker as Form
	Bool isSpeakerHuman = kSpeakerForm.HasKeywordString("ActorTypeNPC")

	; Force disable test dialogues
	If (_SLD_TestDialogues.GetValue() != 0)
		_SLD_TestDialogues.SetValue(0)
	EndIf

	_SLD_speakerAlias.ForceRefTo(akSpeakerRef )

	if ( (akSpeaker as ObjectReference).GetAnimationVariableInt("iDrunkVariable") == 1)
		; Debug.Notification("NPC drunk state: " + (akSpeaker as ObjectReference).GetAnimationVariableInt("iDrunkVariable"))
		_SLD_NPCdrunk.SetValue(1)
	Else
		_SLD_NPCdrunk.SetValue(0)
	EndIf

	; Variables (use StorageUtil - aliases only for AI packages) 
	; - Time first met
	; - Time last met
	; - AI status ( following, in scene, default AI )
	; - Interest level
	; - Relationship level with Player (same as RelationshipRank, from -7 to +7)

	If (StorageUtil.HasIntValue(akSpeaker, "_SD_iRelationshipType"))
		_SLD_NPCRelationshipType.SetValue( StorageUtil.GetIntValue(akSpeaker, "_SD_iRelationshipType") )
	Else
		_SLD_NPCRelationshipType.SetValue( akSpeaker.GetRelationshipRank(Game.GetPlayer()) )
	EndIf

	If (_SLD_NPCRelationshipType.GetValue() < -4)
		If (isSpeakerHuman) && (_SLD_humanMasterAlias.GetReference() != akSpeakerRef)
			_SLD_humanMasterAlias.ForceRefTo(akSpeakerRef )
		ElseIf (!isSpeakerHuman) && (_SLD_beastMasterAlias.GetReference() != akSpeakerRef)
			_SLD_beastMasterAlias.ForceRefTo(akSpeakerRef )
		EndIf

	ElseIf (_SLD_NPCRelationshipType.GetValue() > 4)
		If (isSpeakerHuman) && (_SLD_humanSlaveAlias.GetReference() != akSpeakerRef)
			_SLD_humanSlaveAlias.ForceRefTo(akSpeakerRef )
		ElseIf (!isSpeakerHuman) &&  (_SLD_beastSlaveAlias.GetReference() != akSpeakerRef)
			_SLD_beastSlaveAlias.ForceRefTo(akSpeakerRef )
		EndIf

	ElseIf (_SLD_NPCRelationshipType.GetValue() > 2 )
		If (isSpeakerHuman) && (_SLD_humanLoverAlias.GetReference() != akSpeakerRef)
			_SLD_humanLoverAlias.ForceRefTo(akSpeakerRef )
		ElseIf (!isSpeakerHuman) &&  (_SLD_beastLoverAlias.GetReference() != akSpeakerRef)
			_SLD_beastLoverAlias.ForceRefTo(akSpeakerRef )
		EndIf

	EndIf
	

	If (StorageUtil.HasIntValue( Game.GetPlayer(), "_SD_iSlaveryLevel"))
		_SLD_PCSubSlaveryLevel.SetValue(  StorageUtil.GetIntValue( Game.GetPlayer() , "_SD_iSlaveryLevel") )
	Else
		_SLD_PCSubSlaveryLevel.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( Game.GetPlayer(), "_SD_iEnslaved"))
		_SLD_PCSubEnslaved.SetValue(  StorageUtil.GetIntValue( Game.GetPlayer() , "_SD_iEnslaved") )
	Else
		_SLD_PCSubEnslaved.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( akSpeaker , "_SD_iForcedSlavery"))
		_SLD_PCSubForcedSlavery.SetValue(  StorageUtil.GetIntValue( akSpeaker  , "_SD_iForcedSlavery") )
	Else
		_SLD_PCSubForcedSlavery.SetValue( 0 )
	EndIf


	If (StorageUtil.HasIntValue( akSpeaker , "_SD_iDisposition"))
		_SLD_NPCdisposition.SetValue(  StorageUtil.GetIntValue( akSpeaker , "_SD_iDisposition") )
	Else
		_SLD_NPCdisposition.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( akSpeaker , "_SD_iTrust"))
		_SLD_NPCtrust.SetValue(  StorageUtil.GetIntValue( akSpeaker , "_SD_iTrust") )
	Else
		_SLD_NPCtrust.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( akSpeaker , "_SD_iSeduction"))
		_SLD_NPCseduction.SetValue(  StorageUtil.GetIntValue( akSpeaker , "_SD_iSeduction") )
	Else
		_SLD_NPCseduction.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( akSpeaker , "_SD_iCorruption"))
		_SLD_NPCcorruption.SetValue(  StorageUtil.GetIntValue( akSpeaker , "_SD_iCorruption") )
	Else
		_SLD_NPCcorruption.SetValue( 0 )
	EndIf

	; - Feedom status ( bought by player, sold to NPC, whoring, free )
	; - Bound location  ( editor location, set to nearby map marker )
	; - Leash length (radius around bound location)
	; - Wander duration buffer
	; - Bound owner ( set to Player, other NPC or self for freedom)

	; Temporary global variable
	; - Arousal level (from sexlab aroused)
	; - Purity level (from sexlab)
	; - Sexuality (from sexlab)

	; - NPC sex count (from sexlab)
	_SLD_NPCSexCount.SetValue(  SexLab.PlayerSexCount( akSpeaker ) )

	; - Last time sex (from sexlab)

	if ( _SLD_NPCdisposition.GetValue() > 0 )
		Debug.Notification("(smiling) Yes?")

	Elseif ( _SLD_NPCdisposition.GetValue() < 0 )
		Debug.Notification("(frowning) What is it now?")

	Endif

	; Debug.Notification("[SLD] _SLD_humanMasterAlias: " + _SLD_humanMasterAlias.GetReference() as Actor)

	Debug.Trace("[SLD] " + akSpeaker + " sex: " + _SLD_NPCSexCount.GetValue( ) + " - Rel: " +  _SLD_NPCRelationshipType.GetValue() + " - Slavery: " +  _SLD_PCSubSlaveryLevel.GetValue() )
	Debug.Trace("[SLD] Human speaker: " + isSpeakerHuman )
	Debug.Trace("[SLD] _SLD_speakerAlias: " + _SLD_speakerAlias.GetReference() as Actor)
	Debug.Trace("[SLD] _SLD_humanLoverAlias: " + _SLD_humanLoverAlias.GetReference() as Actor) 
	Debug.Trace("[SLD] _SLD_beastLoverAlias: " + _SLD_beastLoverAlias.GetReference() as Actor)  
	Debug.Trace("[SLD] _SLD_humanMasterAlias: " + _SLD_humanMasterAlias.GetReference() as Actor)
	Debug.Trace("[SLD] _SLD_humanSlaveAlias: " + _SLD_humanSlaveAlias.GetReference() as Actor)
	Debug.Trace("[SLD] _SLD_beastMasterAlias: " + _SLD_beastMasterAlias.GetReference() as Actor)
	Debug.Trace("[SLD] _SLD_beastSlaveAlias: " + _SLD_beastSlaveAlias.GetReference() as Actor)
	; Debug.Notification("[SLD] sex: " + _SLD_NPCSexCount.GetValue( ) as Int + " - Rel: " +  _SLD_NPCRelationshipType.GetValue() as Int  + " - Slavery: " +  _SLD_PCSubSlaveryLevel.GetValue() as Int  )
	Debug.Trace("[SLD] Disposition: " + _SLD_NPCdisposition.GetValue( ) as Int + " Seduction: " + _SLD_NPCseduction.GetValue( ) as Int + " Corruption: " + _SLD_NPCcorruption.GetValue( ) as Int)

EndFunction



Function StartPlayerRape ( Actor akSpeaker, string tags = "Sex" )

	Game.ForceThirdPerson()
	Debug.SendAnimationEvent(Game.GetPlayer() as ObjectReference, "bleedOutStart")

	Int IButton = _SLD_rapeMenu.Show()

	If IButton == 0 ; Show the thing.

		; If  (SexLab.ValidateActor( SexLab.PlayerREF) > 0) &&  (SexLab.ValidateActor(akSpeaker) > 0) 
			; Debug.Notification( "[Resists weakly]" )
		;	SexLab.QuickStart(SexLab.PlayerRef,  akSpeaker, Victim = SexLab.PlayerRef , AnimationTags = tags)
		; EndIf
		StorageUtil.SetIntValue( Game.GetPlayer() , "_SD_iSub", StorageUtil.GetIntValue( Game.GetPlayer(), "_SD_iSub") + 1)

		Int randomNum = Utility.RandomInt(0, 100)
		StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)

		SendModEvent("PCSubSex") ; Sex

	Else
		StorageUtil.SetIntValue( Game.GetPlayer() , "_SD_iDom", StorageUtil.GetIntValue( Game.GetPlayer(), "_SD_iDom") + 1)

		SexLab.ActorLib.StripActor( SexLab.PlayerRef, DoAnimate= false)
	EndIf

EndFunction

Function StartPlayerGangRape ( Actor akSpeaker, string tags = "Sex" )

	Game.ForceThirdPerson()
	Debug.SendAnimationEvent(Game.GetPlayer() as ObjectReference, "bleedOutStart")

	Int IButton = _SLD_rapeMenu.Show()

	If IButton == 0 ; Show the thing.

		; If  (SexLab.ValidateActor( SexLab.PlayerREF) > 0) &&  (SexLab.ValidateActor(akSpeaker) > 0) 
			; Debug.Notification( "[Resists weakly]" )
		;	SexLab.QuickStart(SexLab.PlayerRef,  akSpeaker, Victim = SexLab.PlayerRef , AnimationTags = tags)
		; EndIf
			
		StorageUtil.SetIntValue( Game.GetPlayer() , "_SD_iSub", StorageUtil.GetIntValue( Game.GetPlayer(), "_SD_iSub") + 1)

		Int randomNum = Utility.RandomInt(0, 100)
		StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)

		If (randomNum > 70)
			Debug.Notification("Dance for us...")
			SendModEvent("PCSubEntertain") ; Dance
		ElseIf (randomNum > 50)
			Debug.Notification("Show us what you can do...")
			SendModEvent("PCSubEntertain", "Soloshow") ; Show
		ElseIf (randomNum > 30)
			Debug.Notification("Help yourselves boys!...")
			SendModEvent("PCSubEntertain", "Gangbang") ; Gang bang
		Else
			Debug.Notification("Get on your knees and lift up that ass of yours...")
			SendModEvent("PCSubSex") ; Sex
		EndIf



	Else
		StorageUtil.SetIntValue( Game.GetPlayer() , "_SD_iDom", StorageUtil.GetIntValue( Game.GetPlayer(), "_SD_iDom") + 1)

		SexLab.ActorLib.StripActor( SexLab.PlayerRef, DoAnimate= false)
	EndIf

EndFunction

Function ChangePlayerLook ( Actor akSpeaker, string type = "Racemenu" )
 
	Utility.Wait(0.5)

	Int IButton = _SLD_raceMenu.Show()

	If IButton == 0  ; Show the thing.
		Game.ShowLimitedRaceMenu()
	EndIf

	Utility.Wait(1.0)

EndFunction

SexLabFramework Property SexLab  Auto  
ReferenceAlias Property _SLD_speakerAlias  Auto  
ReferenceAlias Property _SLD_humanLoverAlias  Auto  
ReferenceAlias Property _SLD_beastLoverAlias  Auto  
ReferenceAlias Property _SLD_humanMasterAlias  Auto  
ReferenceAlias Property _SLD_humanSlaveAlias  Auto  
ReferenceAlias Property _SLD_beastMasterAlias  Auto  
ReferenceAlias Property _SLD_beastSlaveAlias  Auto  

GlobalVariable Property _SLD_NPCSexCount  Auto  
GlobalVariable Property _SLD_NPCDrunk  Auto  
GlobalVariable Property _SLD_NPCDrugged  Auto  
GlobalVariable Property _SLD_PCSubSlaveryLevel Auto
GlobalVariable Property _SLD_PCSubEnslaved Auto
GlobalVariable Property _SLD_PCSubForcedSlavery Auto
GlobalVariable Property _SLD_NPCRelationshipType Auto
GlobalVariable Property _SLD_NPCdisposition Auto
GlobalVariable Property _SLD_NPCtrust Auto
GlobalVariable Property _SLD_NPCcorruption Auto
GlobalVariable Property _SLD_NPCseduction Auto

GlobalVariable Property _SLD_TestDialogues Auto

Message Property _SLD_rapeMenu  Auto  

Message Property _SLD_raceMenu  Auto  

