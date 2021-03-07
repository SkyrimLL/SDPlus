Scriptname _SDAS_SummonedSpriggan extends Actor

Import Utility

ReferenceAlias Property _SDRAP_player  Auto  
Keyword Property _SDKP_spriggan  Auto 

Keyword Property _SDKP_sex  Auto 
GlobalVariable Property _SDGVP_positions  Auto  

Float fSummonTime
Float fRFSU = 2.0
Bool bDispel = False
Actor kPlayer

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

Event OnInit()
	bDispel = False
	fSummonTime = GetCurrentRealTime()
	kPlayer = Game.GetPlayer() ; _SDRAP_player.GetReference() as Actor

	If ( Self )
		RegisterForSingleUpdate( fRFSU )
	EndIf
EndEvent

Event OnDying(Actor akKiller)
	UnregisterForUpdate()
EndEvent

Event OnUpdate()
	If ( !bDispel && !Self.IsInCombat() && GetCurrentRealTime() - fSummonTime >= 10.0 )
		bDispel = True
		fSummonTime = GetCurrentRealTime() + 30.0
		; If ( !( kPlayer.GetWornForm(0x00000004) as Armor ).HasKeyword(_SDKP_spriggan) )
		; If (_SD_spriggan_punishment.GetValue() >= 1 )
		; 	_SDKP_spriggan.SendStoryEvent(akRef1 = Self, akRef2 = kPlayer, aiValue1 = 0, aiValue2 = 0)
		; Else
			; need to summon a host in
			;_SDKP_sex.SendStoryEvent( akRef1 = Self, akRef2 = kPlayer, aiValue1 = 0, aiValue2 = RandomInt( 0, _SDGVP_positions.GetValueInt() ) )

		If (Utility.RandomInt(0,100)>50)
			Game.ForceThirdPerson()
			; Debug.SendAnimationEvent(kPlayer as ObjectReference, "bleedOutStart")

			float AttackerStrengthPercentage = GetActorStrengthPercentage(Self)
			int AttackerStamina = Self.GetActorValue("stamina") as int
			float VictimStrengthPercentage = GetActorStrengthPercentage(kPlayer)
			int VictimStamina = kPlayer.GetActorValue("stamina") as int
			float AttackerStrength = AttackerStamina * AttackerStrengthPercentage
			float VictimStrength = VictimStamina * VictimStrengthPercentage
			
			Int IButton = _SD_rapeMenu.Show()

			If IButton == 0 ; Show the thing.
				StorageUtil.SetIntValue( kPlayer , "_SD_iSub", StorageUtil.GetIntValue( kPlayer, "_SD_iSub") + 1)
				; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", Self)
				Debug.Notification("You submit to your aggressor...")
				SendModEvent("PCSubStripped")
				SexLab.ActorLib.StripActor( kPlayer, DoAnimate= false)
				Self.SendModEvent("PCSubSex")
			Else
				StorageUtil.SetIntValue(kPlayer, "_SD_iDom", StorageUtil.GetIntValue(kPlayer, "_SD_iDom") + 1)
				if AttackerStrength > VictimStrength
					Debug.Notification("You resist, but are forced to submit...")
					SendModEvent("PCSubStripped")
					SexLab.ActorLib.StripActor( kPlayer, VictimRef = kPlayer, DoAnimate= false)
					Self.SendModEvent("PCSubSex")
				else
					SendModEvent("PCSubStripped")
					SexLab.ActorLib.StripActor( kPlayer, DoAnimate= false, LeadIn = true)
					Debug.Notification("You manage to break free from your attacker...")
				endIf
				if AttackerStamina > VictimStamina
					AttackerStamina = VictimStamina
				endIf
				Self.DamageActorValue("stamina",AttackerStamina) 
				kPlayer.DamageActorValue("stamina",AttackerStamina)
			EndIf
		EndIf
	EndIf

	If ( bDispel && !Self.GetCurrentScene() && GetCurrentRealTime() - fSummonTime >= 10.0  ) && (SexLab.ValidateActor( Self) > 0) && (SexLab.ValidateActor( kPlayer ) > 0)
		Self.Kill()
		Return
	EndIf

	If ( Self )
		RegisterForSingleUpdate( fRFSU )
	EndIf
EndEvent

GlobalVariable Property _SD_spriggan_punishment  Auto  


SexLabFramework Property SexLab  Auto  
Message Property _SD_rapeMenu Auto