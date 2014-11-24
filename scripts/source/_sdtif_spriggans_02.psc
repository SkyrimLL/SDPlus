;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_spriggans_02 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; In all my years,...
( Self.GetOwningQuest() as _SDQS_sprigganslave ).Commented()

If  (SexLab.ValidateActor( SexLab.PlayerRef ) > 0) &&  (SexLab.ValidateActor(akSpeaker) > 0) 

	Actor akRef1 = akSpeaker
	Actor akRef2 = SexLab.PlayerRef

	Debug.Notification( "The sweet scent of your sap drenched skin is irresistible..." )
	SprigganFX.Play( akSpeakerRef, 30 )
	_SDSP_host_flare.RemoteCast(akRef2 , akRef2 , akRef2 )

		Int randomVar = Utility.RandomInt( 0,10 )

		if (randomVar > 8)
			; Start irresistible dance
			_SDKP_sex.SendStoryEvent(akLoc = (akRef2 as ObjectReference).GetCurrentLocation(), akRef1 = akRef1, akRef2 = akRef2, aiValue1 = 7, aiValue2 = 0 ) ; 1 + Utility.RandomInt( 0, _SDGVP_dances.GetValueInt() ) )
		ElseIf  (randomVar > 6)
			Debug.Notification( "The roots force your legs open ..." )
			sslThreadModel Thread = SexLab.NewThread()
			Thread.AddActor(akRef2) ; // IsVictim = true
			Thread.AddActor(akRef1 )
			Thread.SetAnimations(SexLab.GetAnimationsByTags(2, "Sex"))
			Thread.StartThread()
		Else 
			Debug.Notification( "The sweet scent is overwhelming..." )
			sslThreadModel Thread = SexLab.NewThread()
			Thread.AddActor(akRef1) ; // IsVictim = true

			If (akRef1.GetActorBase().getSex() == 1)
				Thread.SetAnimations(SexLab.GetAnimationsByTags(1, "Solo,F","Estrus,Dwemer"))
			Else
				Thread.SetAnimations(SexLab.GetAnimationsByTags(1, "Solo,M","Estrus,Dwemer"))
			EndIf

			Thread.StartThread()
		EndIf
Else
	Debug.Notification( "[SexLab] Actors are not ready" )
	Debug.Notification( "[SexLab] Player: " + SexLab.ValidateActor( SexLab.PlayerRef ))
	; Debug.Notification( "[SexLab] Speaker: " + SexLab.ValidateActor( akSpeaker ))
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
SexLabFramework Property SexLab  Auto  
VisualEffect Property SprigganFX  Auto  
GlobalVariable Property _SDGVP_dances  Auto
Keyword Property _SDKP_sex  Auto  
Spell Property _SDSP_host_flare  Auto
