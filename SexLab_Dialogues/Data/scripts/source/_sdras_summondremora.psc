Scriptname _sdras_summondremora extends Actor

Import Utility

Float fSummonTime
Float fRFSU = 2.0
Bool bDispel = False
Actor kPlayer


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
			Debug.SendAnimationEvent(Game.getPlayer() as ObjectReference, "bleedOutStart")

			Int IButton = _SD_rapeMenu.Show()

			If IButton == 0 ; Show the thing.
				StorageUtil.SetIntValue( Game.GetPlayer() , "_SD_iSub", StorageUtil.GetIntValue( Game.GetPlayer(), "_SD_iSub") + 1)
				; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", Self)
				Self.SendModEvent("PCSubSex")
			Else
				StorageUtil.SetIntValue(Game.GetPlayer(), "_SD_iDom", StorageUtil.GetIntValue(Game.GetPlayer(), "_SD_iDom") + 1)
				SexLab.ActorLib.StripActor( SexLab.PlayerRef, DoAnimate= false)
			EndIf
		EndIf
	EndIf

	If ( bDispel && !Self.GetCurrentScene() && GetCurrentRealTime() - fSummonTime >= 10.0 )
		Self.Kill()
		Return
	EndIf

	If ( Self )
		RegisterForSingleUpdate( fRFSU )
	EndIf
EndEvent

SexLabFramework Property SexLab  Auto  
Message Property _SD_rapeMenu Auto