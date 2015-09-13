;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_sprigganhelp_01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; What manner of magic is this?

( Self.GetOwningQuest() as _SDQS_sprigganslave ).CommentTrigger()
( Self.GetOwningQuest() as _SDQS_sprigganslave ).Commented()

If  (SexLab.ValidateActor( SexLab.PlayerRef ) > 0) &&  (SexLab.ValidateActor(akSpeaker) > 0) 

	Actor akRef1 = akSpeaker
	Actor akRef2 = SexLab.PlayerRef

	Debug.Notification( "The sweet scent of your sap drenched skin is irresistible..." )
	SprigganFX.Play( akSpeakerRef, 30 )
	_SDSP_host_flare.RemoteCast(akRef2 , akRef2 , akRef2 )

      if (Utility.RandomInt(0,100) > 20)

		Int randomVar = Utility.RandomInt( 0,10 )

		if (randomVar > 8)
			; Start irresistible dance
			; _SDKP_sex.SendStoryEvent(akLoc = (akRef2 as ObjectReference).GetCurrentLocation(), akRef1 = akRef1, akRef2 = akRef2, aiValue1 = 7, aiValue2 = 0 ) ; 1 + Utility.RandomInt( 0, _SDGVP_dances.GetValueInt() ) )
			akSpeaker.SendModEvent("PCSubEntertain")

		ElseIf  (randomVar > 6)
			Debug.Notification( "The roots force your legs open ..." )
			randomVar = Utility.RandomInt( 0,100 )
			If (randomVar > 50)
				; Debug.Notification("Show us what you can do...")
				akSpeaker.SendModEvent("PCSubEntertain", "Soloshow") ; Show
			ElseIf (randomVar > 30)
				; Debug.Notification("Help yourselves boys!...")
				akSpeaker.SendModEvent("PCSubEntertain", "Gangbang") ; Gang bang
			Else
				; Debug.Notification("Get on your knees and lift up that ass of yours...")
				akSpeaker.SendModEvent("PCSubSex") ; Sex
			EndIf
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
	EndIf
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
