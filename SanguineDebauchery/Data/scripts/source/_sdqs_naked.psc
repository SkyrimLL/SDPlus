Scriptname _SDQS_naked extends Quest  

GlobalVariable Property _SDGVP_naked_rape_delay Auto
GlobalVariable Property GameDaysPassed Auto

float fNext = 0.0
float fNextAllowed = 0.02

Function Commented()
	Actor Player = Game.GetPlayer()
	fNext = GameDaysPassed.GetValue() + fNextAllowed + Utility.RandomFloat( 0.125, 0.25 )
	_SDGVP_naked_rape_delay.SetValue( fNext )
	StorageUtil.SetIntValue( Player , "_SD_iCoveted", 1)
EndFunction

; Helper function to calculate the actor strength
float Function GetActorStrengthPercentage(Actor akSubject, float Percentage = -1.0)
	If akSubject == None
		Return -1.0
	EndIf
	
	If Percentage <= 0
		Percentage = akSubject.GetActorValuePercentage("stamina")
	EndIf
	
;	float Strength = akSubject.GetMass() * Percentage
	ActorBase abSubject = akSubject.GetActorBase()
	float Strength = (akSubject.GetHeight() * akSubject.GetLength() * akSubject.GetWidth()) * (PapyrusUtil.ClampFloat(abSubject.GetWeight(), 1.0, 100.0) * 0.01) * Percentage
	
	If Strength < 0
		Strength = 0
	EndIf
	
	Return Strength
EndFunction

Function SanguineRape(Actor akSpeaker, Actor akTarget, String SexLabInTags = "Aggressive", String SexLabOutTags = "Solo")

	Actor Player = Game.GetPlayer()
	
	if (Player.IsOnMount())
		return
	EndIf

	while ( Utility.IsInMenuMode() )
		Utility.Wait( 1.0 )
	endWhile

	If (funct.checkGenderRestriction( akSpeaker,  Player))

		Game.ForceThirdPerson()
		; Debug.SendAnimationEvent(akTarget as ObjectReference, "bleedOutStart")
		float AttackerStrengthPercentage = GetActorStrengthPercentage(akSpeaker)
		int AttackerStamina = akSpeaker.GetActorValue("stamina") as int
		float VictimStrengthPercentage = GetActorStrengthPercentage(akTarget)
		int VictimStamina = akTarget.GetActorValue("stamina") as int
		float AttackerStrength = AttackerStamina * AttackerStrengthPercentage
		float VictimStrength = VictimStamina * VictimStrengthPercentage
		Int IButton = _SD_rapeMenu.Show()

		If IButton == 0 ; Show the thing.

			; Debug.Messagebox("An overwhelming craving stops you in your tracks and feeds the lust of your aggressor.")
			; Utility.Wait(2)
			StorageUtil.SetIntValue( Player , "_SD_iSub", StorageUtil.GetIntValue( Player, "_SD_iSub") + 1)
			SendModEvent("PCSubCoveted")
			funct.SanguineRape(akSpeaker, Player,SexLabInTags,SexLabOutTags )
		Else
			StorageUtil.SetIntValue(Player, "_SD_iDom", StorageUtil.GetIntValue(Player, "_SD_iDom") + 1)
			SendModEvent("PCSubStripped")
			SexLab.ActorLib.StripActor( Player, DoAnimate= false, LeadIn = true)
			if AttackerStrength > VictimStrength
				Debug.MessageBox("You try to resist with all your strength, but at the end the aggressor overwhelm you...")
				funct.SanguineRape(akSpeaker, Player,SexLabInTags,SexLabOutTags )
			endIf
			if AttackerStamina > VictimStamina
				AttackerStamina = VictimStamina
			endIf
			akSpeaker.DamageActorValue("stamina",AttackerStamina) 
			akTarget.DamageActorValue("stamina",AttackerStamina)
		EndIf
	EndIf
	
EndFunction


Function RobPlayer ( Actor akSpeaker  )
	Actor Player = Game.GetPlayer()
	Utility.Wait(0.5)
	int AttackerStamina = akSpeaker.GetActorValue("stamina") as int
	int AttackerPickpocket = (akSpeaker.GetActorValue("Pickpocket") * 0.1) as int
	int VictimStamina = Player.GetActorValue("stamina") as int

	Int IButton = _SD_robMenu.Show()

	If IButton == 0  ; Show the thing.

		StorageUtil.SetIntValue( Player , "_SD_iSub", StorageUtil.GetIntValue( Player, "_SD_iSub") + 1)

		Actor _bandit = akSpeaker
		Actor _target = Player
		int   itemCount
		int   idx
		int   stolenCnt
		int   itemType
		int   cnt
		int   ii
		int   goldVal
		Float itemWeight
		Form  nthItem = None
		Bool  canSteal
		
		itemCount = _target.getNumItems()
		stolenCnt = 0
		while idx < itemCount && stolenCnt < 1
			nthItem = _target.getNthForm(idx)
			if !nthItem
				; _notify("SLU: Null item")
				Return
			endif
		
			canSteal = False
				
			itemType = nthItem.GetType()
			if (itemType == 45) || (itemType == 26) || \
			   (itemType == 41) || (itemType == 30) || \
			   (itemType == 46) || (itemType == 27) || \
			   (itemType == 42) || (itemType == 32)
				canSteal = True
			EndIf
			
			if canSteal && _bandit != Player  && (nthItem.HasKeywordString("VendorNoSale") || nthItem.HasKeywordString("MagicDisallowEnchanting"))
				canSteal = False
				; _notify("Pick: !Q " + nthItem.GetName())
			endif
			
			if canSteal
				cnt = _target.GetItemCount(nthItem)
				goldVal = nthItem.GetGoldValue()
				itemWeight = nthItem.GetWeight()
				
				if (goldVal >= 0)
					if cnt > 1 && goldVal > 0
						ii = Math.Floor(100 / goldVal)
						if ii < cnt
							cnt = ii
						endif
					endif
					
					if cnt > 0
						; Debug.Notification("Pick: " + actorName(_bandit) + " " + actorName(_target))
						Debug.Notification("I like this! [Takes " + cnt + "x " + nthItem.GetName() + " ]")
						_target.RemoveItem(nthItem, cnt, true, _bandit)
						stolenCnt += 1
					endif
				endif
			endif
			
			idx += 1
		endWhile

		cnt = _target.GetItemCount(Gold001)
		if ( (cnt - (cnt/2)) > 10)
			Debug.Notification("You don't need that much money either.")
			_target.RemoveItem(Gold001, cnt/2, true, _bandit)
		endif

	Else
		StorageUtil.SetIntValue( Player , "_SD_iDom", StorageUtil.GetIntValue( Player, "_SD_iDom") + 1)
		SendModEvent("PCSubStripped")
		SexLab.ActorLib.StripActor( Player, VictimRef = Player, DoAnimate= false)			
		if (AttackerStamina * AttackerPickpocket) as int > VictimStamina
			Debug.MessageBox("You try to resist with all your strength, but at the end the thief manage to get all your money...")
			Player.RemoveItem(Gold001, Player.GetItemCount(Gold001), true, akSpeaker)
		endIf
		if AttackerStamina > VictimStamina
			AttackerStamina = VictimStamina
		endIf
		akSpeaker.DamageActorValue("stamina",AttackerStamina) 
		Player.DamageActorValue("stamina",AttackerStamina)
	EndIf

	Utility.Wait(1.0)
EndFunction

Function StartPlayerClaimed ( Actor akSpeaker, string tags = "" )
 	Actor Player = Game.GetPlayer()
	; Int IButton = _SD_enslaveMenu.Show()

	;If IButton == 0 ; Undress
	;	StorageUtil.SetIntValue( Player , "_SD_iSub", StorageUtil.GetIntValue( Player, "_SD_iSub") + 1)
		akSpeaker.SendModEvent("PCSubEnslaveMenu")

	;else
	;	StorageUtil.SetIntValue( Player , "_SD_iDom", StorageUtil.GetIntValue( Player, "_SD_iDom") + 1)
	;	akSpeaker.SendModEvent("PCSubSex")

	;EndIf

EndFunction

Function StartPlayerClaimedBeast ( Actor akSpeaker, string tags = "" )
 	Actor Player = Game.GetPlayer()
	; Int IButton = _SD_enslaveMenu.Show()

	;If IButton == 0 ; Undress
	;	StorageUtil.SetIntValue( Player , "_SD_iSub", StorageUtil.GetIntValue( Player, "_SD_iSub") + 1)
		akSpeaker.SendModEvent("PCSubEnslaveMenu")

	;else
	;	StorageUtil.SetIntValue( Player , "_SD_iDom", StorageUtil.GetIntValue( Player, "_SD_iDom") + 1)
	;	akSpeaker.SendModEvent("PCSubSex")

	; EndIf

EndFunction


Function StartPlayerGangRape ( Actor akSpeaker, string tags = "Sex" )
	Actor Player = Game.GetPlayer()
	Game.ForceThirdPerson()
;	Debug.SendAnimationEvent(Player as ObjectReference, "bleedOutStart")

	Int IButton = _SD_entertainMenu.Show()

	If IButton == 0 ; Show the thing.

		; If  (SexLab.ValidateActor( SexLab.PlayerREF) > 0) &&  (SexLab.ValidateActor(akSpeaker) > 0) 
			; Debug.Notification( "[Resists weakly]" )
		;	SexLab.QuickStart(SexLab.PlayerRef,  akSpeaker, Victim = SexLab.PlayerRef , AnimationTags = tags)
		; EndIf
			
		StorageUtil.SetIntValue( Player , "_SD_iSub", StorageUtil.GetIntValue( Player, "_SD_iSub") + 1)

		Int randomNum = Utility.RandomInt(0, 100)
		; StorageUtil.SetFormValue( Player , "_SD_TempAggressor", akSpeaker)

		If (randomNum > 70)
			Debug.Notification("Dance for us...")
			akSpeaker.SendModEvent("PCSubEntertain") ; Dance
		ElseIf (randomNum > 50)
			Debug.Notification("Show us what you can do...")
			akSpeaker.SendModEvent("PCSubEntertain", "Soloshow") ; Show
		ElseIf (randomNum > 30)
			Debug.Notification("Help yourselves boys!...")
			akSpeaker.SendModEvent("PCSubEntertain", "Gangbang") ; Gang bang
		Else
			Debug.Notification("Get on your knees and lift up that ass of yours...")
			akSpeaker.SendModEvent("PCSubSex") ; Sex
		EndIf



	Else
		StorageUtil.SetIntValue( Player , "_SD_iDom", StorageUtil.GetIntValue( Player, "_SD_iDom") + 1)
		SendModEvent("PCSubStripped")

		SexLab.ActorLib.StripActor( Player, VictimRef = Player, DoAnimate= false)

		If (Utility.RandomInt(0, 100)>40)
			SendModEvent("PCSubWhip")
		EndIf
	EndIf

EndFunction

Function DrugPlayer(Actor akSpeaker)
	Actor kSlave = game.GetPlayer()
	Game.ForceThirdPerson()
;	Debug.SendAnimationEvent(Player as ObjectReference, "bleedOutStart")
	float AttackerStrengthPercentage = GetActorStrengthPercentage(akSpeaker)
	int AttackerStamina = akSpeaker.GetActorValue("stamina") as int
	float VictimStrengthPercentage = GetActorStrengthPercentage(kSlave)
	int VictimStamina = kSlave.GetActorValue("stamina") as int
	float AttackerStrength = AttackerStamina * AttackerStrengthPercentage
	float VictimStrength = VictimStamina * VictimStrengthPercentage
	Int IButton = _SD_drugMenu.Show()

	If IButton == 0 ; Show the thing.

		; If  (SexLab.ValidateActor( SexLab.PlayerREF) > 0) &&  (SexLab.ValidateActor(akSpeaker) > 0) 
			; Debug.Notification( "[Resists weakly]" )
		;	SexLab.QuickStart(SexLab.PlayerRef,  akSpeaker, Victim = SexLab.PlayerRef , AnimationTags = tags)
		; EndIf
			
		StorageUtil.SetIntValue( kSlave , "_SD_iSub", StorageUtil.GetIntValue( kSlave, "_SD_iSub") + 1)


		Debug.Notification( "Your mouth is held open as you are forced to swallow..." )
		int randomVar = Utility.RandomInt( 0, 10 ) 
		 
		If (randomVar >=9 ) && (StorageUtil.GetIntValue( akSpeaker , "_SD_iDisposition") < 0 )
			Debug.Notification( "..some Skooma!" )
			kSlave.AddItem( Skooma, 1, True )
			kSlave.EquipItem( Skooma, True, True )

			Utility.Wait(3.0)

			If (Utility.RandomInt( 0, 100 ) > 30)
				Debug.Notification( "In a stupor you start dancing for no reason..." )
				; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)
	 			akSpeaker.SendModEvent("PCSubEntertain") ; Dance
	 		EndIf

		ElseIf (randomVar >= 2  )
			Debug.Notification( "..some Ale!" )
			kSlave.AddItem( Ale, 1, True )
			kSlave.EquipItem( Ale, True, True )

			Utility.Wait(3.0)

			If (Utility.RandomInt( 0, 100 ) > 70)
				Debug.Notification( "In a stupor you start dancing for no reason..." )
				; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)
	 			akSpeaker.SendModEvent("PCSubEntertain") ; Dance
	 		EndIf

		Else
			akSpeaker.SendModEvent("PCSubSex") ; Sex

		EndIf
	Else
		StorageUtil.SetIntValue( kSlave , "_SD_iDom", StorageUtil.GetIntValue( kSlave, "_SD_iDom") + 1)
		SendModEvent("PCSubStripped")

		SexLab.ActorLib.StripActor( kSlave, VictimRef = kSlave, DoAnimate= false)
		if AttackerStrength > VictimStrength
			Debug.MessageBox("You try to resist with all your strength, but now your mouth is held open as you are forced to swallow...")
			If (StorageUtil.GetIntValue( akSpeaker , "_SD_iDisposition") < 0 )
				kSlave.AddItem( Skooma, 1, True )
				kSlave.EquipItem( Skooma, True, True )
			Else
				kSlave.AddItem( Ale, 1, True )
				kSlave.EquipItem( Ale, True, True )
			EndIf
		endIf
		if AttackerStamina > VictimStamina
			AttackerStamina = VictimStamina
		endIf
		akSpeaker.DamageActorValue("stamina",AttackerStamina) 
		kSlave.DamageActorValue("stamina",AttackerStamina)

	EndIf
EndFunction

Potion Property Ale  Auto  
Potion Property Skooma  Auto  

_SDQS_functions Property funct  Auto
Message Property _SD_rapeMenu Auto
Message Property _SD_robMenu Auto
Message Property _SD_enslaveMenu Auto
Message Property _SD_entertainMenu Auto
Message Property _SD_drugMenu Auto

SexLabFramework Property SexLab  Auto  
MiscObject Property Gold001  Auto  
