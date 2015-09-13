;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_spriggans_21 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
If  (SexLab.ValidateActor( SexLab.PlayerRef ) > 0) &&  (SexLab.ValidateActor(akSpeaker) > 0) 

	Actor akRef1 = akSpeaker
	Actor akRef2 = SexLab.PlayerRef

	Debug.Messagebox( "The sweet scent of your sap drenched skin is irresistible..." )

	Game.ForceThirdPerson()
	; Debug.SendAnimationEvent(akRef2 as ObjectReference, "bleedOutStart")

	SprigganFX.Play( akSpeakerRef, 30 )
	_SDSP_host_flare.RemoteCast(akRef2 , akRef2 , akRef2 )

			sslThreadModel Thread = SexLab.NewThread()
			Thread.AddActor(akRef2 , true) ; // IsVictim = true
			Thread.AddActor(akRef1 )
			Thread.SetAnimations(SexLab.GetAnimationsByTags(2, "Sex"))
			Thread.StartThread()

EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SexLabFramework Property SexLab  Auto  

VisualEffect Property SprigganFX  Auto  

Spell Property _SDSP_host_flare  Auto
