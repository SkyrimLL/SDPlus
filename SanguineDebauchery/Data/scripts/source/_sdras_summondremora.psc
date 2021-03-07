Scriptname _sdras_summondremora extends Actor

Import Utility

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
	kPlayer = Game.GetPlayer() 

	If ( Self )
		RegisterForSingleUpdate( fRFSU )
	EndIf
EndEvent

Event OnUpdate()
	If ( !bDispel && !Self.IsInCombat() && GetCurrentRealTime() - fSummonTime >= 10.0 )
		bDispel = True
		fSummonTime = GetCurrentRealTime() + 30.0

		Debug.Notification(".")

		If (Utility.RandomInt(0,100)>50)
			Game.ForceThirdPerson()
			; Debug.SendAnimationEvent(Game.getPlayer() as ObjectReference, "bleedOutStart")

			float AttackerStrengthPercentage = GetActorStrengthPercentage(Self)
			int AttackerStamina = Self.GetActorValue("stamina") as int
			float VictimStrengthPercentage = GetActorStrengthPercentage(kPlayer)
			int VictimStamina = kPlayer.GetActorValue("stamina") as int
			float AttackerStrength = AttackerStamina * AttackerStrengthPercentage
			float VictimStrength = VictimStamina * VictimStrengthPercentage
			Int IButton = _SD_rapeMenu.Show()

			If IButton == 0 ; Show the thing.
				StorageUtil.SetIntValue( Game.GetPlayer() , "_SD_iSub", StorageUtil.GetIntValue( Game.GetPlayer(), "_SD_iSub") + 1)
				; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", Self)
				Self.SendModEvent("PCSubSex")
			Else
				StorageUtil.SetIntValue(Game.GetPlayer(), "_SD_iDom", StorageUtil.GetIntValue(Game.GetPlayer(), "_SD_iDom") + 1)
				SendModEvent("PCSubStripped")
				SexLab.ActorLib.StripActor(SexLab.PlayerRef, DoAnimate= false, LeadIn = true)
				if AttackerStrength > VictimStrength
					Debug.MessageBox("You try to resist with all your strength, but at the end the aggressor overwhelm you...")
					Self.SendModEvent("PCSubSex")
				endIf
				if AttackerStamina > VictimStamina
					AttackerStamina = VictimStamina
				endIf
				Self.DamageActorValue("stamina",AttackerStamina) 
				kPlayer.DamageActorValue("stamina",AttackerStamina)
			EndIf
		EndIf
	EndIf

	If ( bDispel && !Self.GetCurrentScene() && GetCurrentRealTime() - fSummonTime >= 10.0 ) && (SexLab.ValidateActor( Self) > 0) && (SexLab.ValidateActor( kPlayer ) > 0)
		Self.Kill()
		Return
	EndIf

	If Self && Self.Is3DLoaded() && !Self.IsDisabled() && !Self.IsDead()
		RegisterForSingleUpdate( fRFSU )
	EndIf
EndEvent

SexLabFramework Property SexLab  Auto  
Message Property _SD_rapeMenu Auto