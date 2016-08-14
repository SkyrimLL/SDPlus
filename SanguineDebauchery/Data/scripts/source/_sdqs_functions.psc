Scriptname _SDQS_functions extends Quest Conditional
{ USED }
Import Utility
Import SKSE

_SDQS_fcts_constraints Property fctConstraints  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

Bool Property sdBleedout = False Auto Conditional

;Int[] uiSlotMask

Actor Function GetPlayerDialogueTarget()
	Actor kPlayerRef = Game.GetPlayer()
	Actor kTargetRef = None
	Actor kNthRef    = None
 
	Cell kCell       = kPlayerRef.GetParentCell()
	Int iType        = 43 ; kNPC = 43
	Int iIndex       = kCell.GetNumRefs( iType ) 
 
	While iIndex && !kTargetRef
		iIndex -= 1
		kNthRef = kCell.GetNthRef( iIndex, iType ) as Actor
		If kNthRef != kPlayerRef && kNthRef.IsInDialogueWithPlayer()
			kTargetRef = kNthRef
		EndIf
	EndWhile
 
	Return kTargetRef
EndFunction

Actor Function findClosestHostileActorToActor(Actor akActor, float afRadius = -1.0, Bool abLeveled = True )
	Actor kReturnNPC = None
	Actor kNthNPC = None
	Cell crParentCell = akActor.GetParentCell()
	Float dist = 0.0

	Int index = 0
	Int count = crParentCell.GetNumRefs(43) ; kNPC = 43

	While index < count
		kNthNPC = crParentCell.GetNthRef(index, 43) as Actor
		
		If ( !kNthNPC.IsDead() && !kNthNPC.IsDisabled() && kNthNPC.GetActorValue("Aggression") > 0 && kNthNPC.GetActorValue("Confidence") > 0  && kNthNPC.GetRelationshipRank(akActor) <= -3 && akActor.HasLOS( kNthNPC ) && ( kReturnNPC == None || dist > akActor.GetDistance( kNthNPC ) ) )
			kReturnNPC = kNthNPC
			dist = akActor.GetDistance( kNthNPC )
		EndIf
		
		index += 1
	EndWhile

	If ( abLeveled )
		index = 0
		count = crParentCell.GetNumRefs(44) ; kLeveledCharacter = 44

		While index < count
			kNthNPC = crParentCell.GetNthRef(index, 44) as Actor
			
			If ( !kNthNPC.IsDead() && !kNthNPC.IsDisabled() && kNthNPC.GetActorValue("Aggression") > 0 && kNthNPC.GetActorValue("Confidence") > 0  && kNthNPC.GetRelationshipRank(akActor) <= -3 && akActor.HasLOS( kNthNPC ) && ( kReturnNPC == None || dist > akActor.GetDistance( kNthNPC ) ) )
				kReturnNPC = kNthNPC
				dist = akActor.GetDistance( kNthNPC )
			EndIf
			
			index += 1
		EndWhile
	EndIf

	If ( afRadius < 0.0 || dist <= afRadius )
		Return kReturnNPC
	Else
		Return None
	EndIf

EndFunction

Bool Function actorInWeakenedState( Actor akActor, Float afThreshold = 0.05 )
	Bool weakened = ( akActor.GetActorValuePercentage("health") <= afThreshold )

	; Debug.Notification("[_sdqs_functions] Weakened state: Base: " + akActor.GetBaseAV("health") )
	; Debug.Notification("[_sdqs_functions] Weakened state: " + akActor.GetActorValuePercentage("health") + "[" +afThreshold + "]")

	If (0 == 1) && ( weakened && !sdBleedout ) ; disabled because of DA
		sdBleedout = True
		Weapon krHand = akActor.GetEquippedWeapon()
		Weapon klHand = akActor.GetEquippedWeapon( True )
		If ( krHand )
			akActor.DropObject( krHand )
		EndIf
		If ( klHand )
			akActor.DropObject( klHand )
		EndIf

		akActor.StopCombatAlarm()
		akActor.StopCombat()
		Game.ForceThirdPerson()
		; Debug.SendAnimationEvent(akActor, "bleedOutStart")
	ElseIf (0 == 1) && ( sdBleedout && !weakened )
		sdBleedout = False
		; Debug.SendAnimationEvent(akActor, "bleedOutStop")
		Game.ForceThirdPerson()
	ElseIf (0 == 1) && ( sdBleedout && weakened )
		; Debug.Notification("[_sdqs_functions] Actor both Weakened and in bleedout")
	ElseIf (0 == 1) && ( !sdBleedout && !weakened )
		; Debug.Notification("[_sdqs_functions] Actor not weakened or in bleedout")
	EndIf
	
	Return weakened
EndFunction

Bool Function actorInKillState( Actor akActor, Float afBaseAVMult = 1.0, Int aiForcedMortality = 0 )
	Float health = akActor.GetAV("health")
	Float basehealth = akActor.GetBaseAV("health") * afBaseAVMult  
	Bool bloodyMess =  ( ( health < 0 && basehealth < Math.abs( health ) ) || aiForcedMortality == 1 )

	; Debug.Trace("[_sdqs_functions] Killed state: Base: " + akActor.GetBaseAV("health") + " - " + Math.abs( afBaseAVMult ) + "[" +bloodyMess + "]")
	; Debug.Trace("[_sdqs_functions] Killed state: Health:" + Math.abs( health ) + "[" +bloodyMess + "]")

	If ( bloodyMess )
		; Debug.Notification("[_sdqs_functions] Actor in killed state")
	Else
		; Debug.Notification("[_sdqs_functions] Actor not dead yet")
	EndIf

	Return ( bloodyMess )
EndFunction

; 0: Dialogue Anger
; 1: Dialogue Fear
; 2: Dialogue Happy
; 3: Dialogue Sad
; 4: Dialogue Surprise
; 5: Dialogue Puzzled
; 6: Dialogue Disgusted
; 7: Mood Neutral
; 8: Mood Anger
; 9: Mood Fear
; 10: Mood Happy
; 11: Mood Sad
; 12: Mood Surprise
; 13: Mood Puzzled
; 14: Mood Disgusted
; 15: Combat Anger
; 16: Combat Shout
Bool Function setRandomActorExpression( Actor akActor = None, Int baseIntensity = 40, Float timePassed = 0.0 )
	Int[] expressionType = New Int[3]
	Int min
	Int max

	If ( baseIntensity < 0 )
		akActor.ClearExpressionOverride()
		Return True
	EndIf

	If ( timePassed < 12.0 )
		min = intWithinRange( baseIntensity + 40, 0, 100)
		max = intWithinRange( baseIntensity + 60, 0, 100)
		expressionType[0] = 16  ; shout
		expressionType[1] = 15 ; anger
		expressionType[2] = 11 ; sad
	ElseIf ( timePassed < 36.0 )
		min = intWithinRange( baseIntensity + 20, 0, 100)
		max = intWithinRange( baseIntensity + 40, 0, 100)
		expressionType[0] = 13 ; puzzled
		expressionType[1] = 11 ; sad
		expressionType[2] = 12 ; surprise
	Else
		min = intWithinRange( baseIntensity, 0, 100)
		max = intWithinRange( baseIntensity + 20, 0, 100)
		expressionType[0] = 12 ; surprise
		expressionType[1] = 7  ; neutral
		expressionType[2] = 10 ; happy
	EndIf

	Return akActor.SetExpressionOverride( expressionType[ RandomInt(0, expressionType.Length - 1) ] ,RandomInt( min, max ) ) as Bool
EndFunction

Bool Function _hasPlayer(Actor[] _actors)
	ObjectReference PlayerREF= SexLab.PlayerRef

	int idx = 0
	while idx < _actors.Length
		if _actors[idx] == PlayerRef
			return True
		endif
		idx += 1
	endwhile
	Return False
EndFunction

Bool Function _hasActor(Actor[] _actors, Actor thisActor)

	int idx = 0
	while idx < _actors.Length
		if _actors[idx] == thisActor as ObjectReference
			return True
		endif
		idx += 1
	endwhile
	Return False
EndFunction

Bool Function _hasRace(Actor[] _actors, Race thisRace)
	ActorBase aBase 
	Race aRace 

	int idx = 0
	while idx < _actors.Length
		if (_actors[idx])
			; aBase = _actors[idx].GetBaseObject() as ActorBase
			aRace = _actors[idx].GetLeveledActorBase().GetRace()
			if aRace == thisRace
				return True
			endif
		EndIf
		idx += 1
	endwhile
	Return False
EndFunction


;; UTILITY FUNCTIONS
Int Function intMax( Int iA, Int iB )
	If ( iA >= iB )
		Return iA
	Else
		Return iB
	EndIf
EndFunction

Int Function intMin( Int iA, Int iB )
	If ( iA <= iB )
		Return iA
	Else
		Return iB
	EndIf
EndFunction

Float Function floatMax( Float iA, Float iB )
	If ( iA >= iB )
		Return iA
	Else
		Return iB
	EndIf
EndFunction

Float Function floatMin( Float iA, Float iB )
	If ( iA <= iB )
		Return iA
	Else
		Return iB
	EndIf
EndFunction

Int Function intWithinRange( Int in, Int low, Int high )
	If ( in < low )
		Return low
	EndIf
	If ( in > high )
		Return high
	EndIf
	Return in
EndFunction

Float Function floatWithinRange( Float in, Float low, Float high )
	If ( in < low )
		Return low
	EndIf
	If ( in > high )
		Return high
	EndIf
	Return in
EndFunction

Bool Function floatInRange( Float in, Float low, Float high )
	Return ( in >= low && in <= high )
EndFunction

Bool Function intInRange( Int in, Int low, Int high )
	Return ( in >= low && in <= high )
EndFunction

Float Function floatLinearInterpolation( Float bA, Float bB, Float aA, Float a, Float aB )
	Return bA + ( bB - bA )*(( a - aA )/( aB - aa ))
EndFunction

Function ArrayClear(Form[] myArray)
	Int idx = 0
	While idx < myArray.Length
		myArray[idx] = None
		idx += 1
	EndWhile
EndFunction

Bool Function isArrayClear(Form[] myArray)
	Bool bClear = True
	Int idx = 0
	While bClear && idx < myArray.Length
		bClear = ( myArray[idx] == None )
		idx += 1
	EndWhile
	Return bClear
EndFunction

Bool Function checkGenderRestriction(Actor akSpeaker, Actor akTarget)
	Int    speakerGender = akSpeaker.GetLeveledActorBase().GetSex() as Int
	Int    targetGender = akTarget.GetLeveledActorBase().GetSex() as Int
	Int    genderRestrictions = _SDGVP_gender_restrictions.GetValue() as Int
	Bool bGenderChecked = false;

	; usually, 'akTarget' is the player

	if (genderRestrictions <= 2) ; SD+ gender restriction system
		bGenderChecked = (genderRestrictions  == 0) || ( (genderRestrictions  == 1) && (speakerGender  == targetGender ) ) || ( (genderRestrictions  == 2) && (speakerGender  != targetGender ) ) 

	else ; use SexLab gender restriction system
		bGenderChecked = (SexLab.IsBisexual(akTarget)) || ( (SexLab.IsGay(akTarget)) && (speakerGender  == targetGender ) ) || ( (SexLab.IsStraight(akTarget)) && (speakerGender  != targetGender ) ) 
	EndIf

	return bGenderChecked;

EndFunction


Function SanguineRapeMenu ( Actor akSpeaker, Actor akTarget, string tags = "Sex" )
	Actor Player = Game.GetPlayer()
	Game.ForceThirdPerson()
;	Debug.SendAnimationEvent(Player as ObjectReference, "bleedOutStart")

	Int IButton = _SD_rapeMenu.Show()

	If IButton == 0 ; Show the thing.

		; If  (SexLab.ValidateActor( SexLab.PlayerREF) > 0) &&  (SexLab.ValidateActor(akSpeaker) > 0) 
			; Debug.Notification( "[Resists weakly]" )
		;	SexLab.QuickStart(SexLab.PlayerRef,  akSpeaker, Victim = SexLab.PlayerRef , AnimationTags = tags)
		; EndIf
		StorageUtil.SetIntValue( Player , "_SD_iSub", StorageUtil.GetIntValue( Player, "_SD_iSub") + 1)

		Int randomNum = Utility.RandomInt(0, 100)
		; StorageUtil.SetFormValue( Player , "_SD_TempAggressor", akSpeaker)

		SanguineRape( akSpeaker, Player , "Rough")

	Else
		StorageUtil.SetIntValue( Player , "_SD_iDom", StorageUtil.GetIntValue( Player, "_SD_iDom") + 1)
		SendModEvent("PCSubStripped")

		SexLab.ActorLib.StripActor( Player, VictimRef = Player, DoAnimate= false)

		If (Utility.RandomInt(0, 100)>40)
			akSpeaker.SendModEvent("PCSubWhip")
		EndIf
	EndIf

EndFunction

Function SanguineRapeCreatureMenu ( Actor akSpeaker, Actor akTarget, string tags = "Sex" )
	Actor Player = Game.GetPlayer()
	Game.ForceThirdPerson()
;	Debug.SendAnimationEvent(Player as ObjectReference, "bleedOutStart")

	Int IButton = _SD_rapeMenu.Show()

	If IButton == 0 ; Show the thing.

		; If  (SexLab.ValidateActor( SexLab.PlayerREF) > 0) &&  (SexLab.ValidateActor(akSpeaker) > 0) 
			; Debug.Notification( "[Resists weakly]" )
		;	SexLab.QuickStart(SexLab.PlayerRef,  akSpeaker, Victim = SexLab.PlayerRef , AnimationTags = tags)
		; EndIf
		StorageUtil.SetIntValue( Player , "_SD_iSub", StorageUtil.GetIntValue( Player, "_SD_iSub") + 1)

		Int randomNum = Utility.RandomInt(0, 100)
		; StorageUtil.SetFormValue( Player , "_SD_TempAggressor", akSpeaker)

		SanguineRape( akSpeaker, Player , "Sex")

	Else
		StorageUtil.SetIntValue( Player , "_SD_iDom", StorageUtil.GetIntValue( Player, "_SD_iDom") + 1)

	EndIf

EndFunction

Function SanguineRape(Actor akSpeaker, Actor akTarget, String SexLabInTags = "Aggressive", String SexLabOutTags = "Solo")


	If (!akSpeaker)
		Return
	EndIf
	
	If (!akTarget)
		Return
	EndIf
	
	Int    speakerGender = akSpeaker.GetLeveledActorBase().GetSex() as Int
	Int    targetGender = akTarget.GetLeveledActorBase().GetSex() as Int
	Int    genderRestrictions = _SDGVP_gender_restrictions.GetValue() as Int
	Int 	IButton = 0

	; Handling of enslaved followers
	If (StorageUtil.GetIntValue(Game.getPlayer(), "_SD_iEnslaved") ==1)
		Actor kMaster = StorageUtil.GetFormValue(Game.getPlayer(), "_SD_CurrentOwner") as Actor 
		Int valueCount = StorageUtil.FormListCount(kMaster, "_SD_lEnslavedFollower")
		int i = 0
		Actor thisActor = None

		while(i < valueCount) && (thisActor == None)
			thisActor = StorageUtil.FormListGet(kMaster, "_SD_lEnslavedFollower", i) as Actor

			i += 1
		endwhile

		Debug.Trace("[SD sex] Num followers slaves: " + valueCount as Int)

		if (thisActor!=None) && !thisActor.IsDead()
			; Pick the first available follower for now
			if (Utility.RandomInt(0,100)>70)   ; chance the owner will prefer to use a follower
				Debug.Trace("[SD sex] Master using follower" )

				if (Utility.RandomInt(0,100)>70) && (checkGenderRestriction(thisActor, akTarget))  ; chance of player + follower
					akSpeaker = thisActor
					Debug.Notification("Show me what you can do with your friend here...")

				elseif (checkGenderRestriction(akSpeaker, thisActor))  ; chance of master + follower
					akTarget = thisActor
					Debug.Notification("Let's see what your friend is capable of...")

				endif
			endif
		endif
	Endif

	; Devious devices and punishment items restrictions
	; Debug.Notification("[SD sex] Speaker gender: " + speakerGender + " [ " + akSpeaker + " ] ")
	; Debug.Notification("[SD sex] Target gender: " + targetGender + " [ " + akTarget + " ] ")

	; If (akTarget == Game.GetPlayer())

		; uiSlotMask[6] = 0x00800000  ;53  DD Cuffs (Legs)
		; uiSlotMask[7] = 0x04000000 ;56  DD Chastity Bra
		; uiSlotMask[8] = 0x20000000  ;59  DD Cuffs (Arms)

		; Masturbation scenes
		If (SexLabInTags == "Masturbation") && (SexLab.ValidateActor( akSpeaker ) > 0)

			If (SexLabInTags == "Masturbation")  
				If (speakerGender  == 0)
					SexLabInTags = "Masturbation,M"
				Else
					SexLabInTags =  "Masturbation,F"
				EndIf

				actor[] sexActors = new actor[1]
				sexActors[0] = akSpeaker
				sslBaseAnimation[] animations = SexLab.GetAnimationsByTags(1,  SexLabInTags, "Estrus,Dwemer")
				SexLab.StartSex(sexActors, animations)

				; SexLab.QuickStart(akSpeaker, AnimationTags = SexLabInTags)

			EndIf

			If (SexLabOutTags == "Masturbation")  
				If (targetGender  == 0)
					SexLabInTags = "Masturbation,M"
				Else
					SexLabInTags =  "Masturbation,F"
				EndIf

				actor[] sexActors = new actor[1]
				sexActors[0] = akTarget
				sslBaseAnimation[] animations = SexLab.GetAnimationsByTags(1,  SexLabInTags, "Estrus,Dwemer")
				SexLab.StartSex(sexActors, animations)

				; SexLab.QuickStart(akTarget, AnimationTags = SexLabInTags)

			EndIf

		; Gender restrictions - 2 actors
		ElseIf checkGenderRestriction( akSpeaker,  akTarget)

			; SexLabInTags = "Sex"  ; Reset tags for now - working on compatibility with DDi filters
		
			; Testing sexlab 1.6 - disabling gender restrictions for now / testing new 'gay filter' from sexlab
			If ( (genderRestrictions  == 1) && (speakerGender  == targetGender ) )
				If (speakerGender  == 0)
				;	SexLabInTags = SexLabInTags + ",MM"
				Else
				;	SexLabInTags = SexLabInTags + ",FF"
				EndIf
			ElseIf ( (genderRestrictions  == 2) && (speakerGender  != targetGender ) ) 
					
					If (speakerGender == 1) ; Mistress and Male slave
					;	SexLabInTags = SexLabInTags + ",Cowgirl"
					ElseIf  (speakerGender == 0) ; Master and Female slave
					;	SexLabInTags = SexLabInTags + ",Doggystyle"
					EndIf
			EndIf

			Debug.Trace("[_sd_naked] Gender check: Restrictions= " + genderRestrictions  + " [ " + akSpeaker + " / " + akTarget + " ] ")
			Debug.Trace("[_sd_naked] SexLabInTags= " + SexLabInTags )
			Debug.Trace("[_sd_naked] SexLabOutTags= " + SexLabOutTags)

			If  (SexLab.ValidateActor( akSpeaker ) > 0) &&  (SexLab.ValidateActor( akTarget ) > 0) 

				; actor[] sexActors = new actor[2]
				; sexActors[0] = akTarget
				; sexActors[1] = akSpeaker
				; sslBaseAnimation[] animations = SexLab.GetAnimationsByTags(2,  SexLabInTags,  SexLabOutTags)
				; If (animations != None)
				;  	SexLab.StartSex(sexActors, animations, victim = akTarget )
				; EndIf

				; SexLab.QuickStart(SexLab.PlayerRef, akSpeaker, Victim = SexLab.PlayerRef, AnimationTags = "Aggressive")

				sslThreadModel Thread = SexLab.NewThread()
				Thread.AddActor(akTarget, true) ; // IsVictim = true
				Thread.AddActor(akSpeaker)
				Thread.SetAnimations(SexLab.GetAnimationsByTags(2, SexLabInTags,  SexLabOutTags))
				Thread.StartThread()
			Else
				Debug.Trace("[SD] Sex: SexLab Check failed - " + SexLab.ValidateActor( akSpeaker ) + " / " + SexLab.ValidateActor( akTarget ))
				Debug.Trace("[SD] Sex: SexLab Check failed - " + SexLab.ValidateActor( akSpeaker ) + " / " + SexLab.ValidateActor( akTarget ))
			EndIf
		Else
			Debug.Trace("[_sd_naked] Gender check failed: Restrictions= " + genderRestrictions  + " [ " + speakerGender + " / " + targetGender + " ] ")
		EndIf

	; Else
	; 	Debug.Notification("[_sd_naked] Target is not the player")
	; EndIf
EndFunction

Function SanguineGangRape(Actor akSpeaker, Actor akTarget, Bool includeSpeaker = True, Bool includeTarget = False)
	actor kPervert = None

	Int idx = 0
	Int iCount = 0

	If ( includeTarget ) 
		whore.addToQueue( akTarget as ObjectReference )
	EndIf
	
	; try: Actor[] function FindAvailablePartners(actor[] Positions, int TotalActors, int Males = -1, int Females = -1, float Radius = 10000.0)
	Debug.Trace("[_sdqs_functions] Scanning for actors")
		
	While (iCount < 10) && (idx < 5)
		If ( includeSpeaker ) && (kPervert != akSpeaker)
			kPervert = SexLab.FindAvailableActor(CenterRef = SexLab.PlayerRef as ObjectReference, Radius = 600.0, IgnoreRef1 = akTarget)  	
		Else
			kPervert = SexLab.FindAvailableActor(CenterRef = SexLab.PlayerRef as ObjectReference, Radius = 600.0, IgnoreRef1 = akTarget, IgnoreRef2 = akSpeaker)  	
		EndIf

		If (kPervert!=None) 
			If (!kPervert.IsDead()) 
				whore.addToQueue( kPervert as ObjectReference )
				idx += 1
			EndIf
		EndIf

		iCount += 1
	EndWhile

	if (idx == 0)
		Debug.Trace("[_sdqs_functions] No actor found")
	EndIf

	If ( includeSpeaker )
		whore.addToQueue( akSpeaker as ObjectReference )
	EndIf


EndFunction

Function SanguineWhip( Actor akActor )
	Actor kPlayer = Game.GetPlayer()

	If (akActor == None)
		Debug.Trace("[_sdqs_functions] 	Punishment attempt by empty aggressor")
		Return
	EndIf

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryPunishmentOn") == 1)
		fctOutfit.setMasterGearByRace ( akActor, kPlayer  )
		_SDKP_sex.SendStoryEvent(akRef1 = akActor as ObjectReference, akRef2 = kPlayer as ObjectReference, aiValue1 = 5, aiValue2 = 0 )
	Endif
EndFunction

Function SanguinePunishment( Actor akActor )
	Actor kPlayer = Game.GetPlayer()
	
	If (akActor == None)
		Debug.Trace("[_sdqs_functions] 	Punishment attempt by empty aggressor")
		Return
	EndIf
 
	If (StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryPunishmentOn") == 1)
		fctOutfit.setMasterGearByRace ( akActor, kPlayer  )
		_SDKP_sex.SendStoryEvent(akRef1 = akActor as ObjectReference, akRef2 = kPlayer as ObjectReference, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )

		fctOutfit.setMasterGearByRace ( None, kPlayer  )
		StorageUtil.SetStringValue(kPlayer, "_SD_sSlaveryTat", "Slavery scars")
		StorageUtil.SetStringValue(kPlayer, "_SD_sSlaveryTatType", "SD+")
		StorageUtil.SetIntValue(kPlayer, "_SD_iSlaveryTatDuration", 5 )
		fctOutfit.sendSlaveTatModEvent(kPlayer, "SD+","Slavery scars" )

	endif
EndFunction


Function sexlabStripActor( Actor akActor )
	SexLab.StripActor(akActor, DoAnimate= false) 
EndFunction

Function removeItemsInList( Actor akActor, FormList akItemList )
	Int idx = 0
	Int iCount = 0
	Armor nthArmor = None
	Form kForm

	if (akActor)
		While idx < akItemList.GetSize()
			kForm = akItemList.GetAt(idx) 
			; nthArmor = kForm as Armor
			if (kForm)
				iCount = akActor.GetItemCount( kForm as Armor )
				If ( iCount ) && (kForm as Armor)
					akActor.RemoveItem( kForm as Armor, iCount, True )
				EndIf
			EndIf
			idx += 1
		EndWhile
	EndIf
EndFunction

Function transferFormListContents( FormList alFactionListIn, FormList alFactionListOut )
	Int index = 0
	Int size = alFactionListIn.GetSize()

	While ( index < size )
		Faction nTHfaction = alFactionListIn.GetAt(index) as Faction
		alFactionListOut.AddForm( nTHfaction )
		index += 1
	EndWhile

	alFactionListIn.Revert()
EndFunction


Message Property _SD_rapeMenu Auto

GlobalVariable Property _SDGVP_naked_rape_chance Auto
GlobalVariable Property _SDGVP_naked_rape_delay Auto
GlobalVariable Property _SDGVP_gender_restrictions Auto
GlobalVariable Property _SDGVP_punishments  Auto  
SexLabFrameWork Property SexLab Auto

Keyword Property _SDKP_punish Auto
Keyword Property _SDKP_bound Auto
Keyword Property _SDKP_gagged Auto
Keyword Property _SDKP_sex  Auto  

ObjectReference[] Property _SD_CaptiveFollowersLocations  Auto  
_SDQS_whore Property whore  Auto  
 