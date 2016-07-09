;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubBeastThirsty Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kSlave = game.GetPlayer()

	Debug.Notification( "Your owner steps back and ..." )
	int randomVar = Utility.RandomInt( 0, 10 ) 
	 
	If (randomVar >=9 )
		Debug.Notification( ".. pees in front of you!" )
		kSlave.AddItem( Skooma, 1, True )
		kSlave.EquipItem( Skooma, True )

		If (Utility.RandomInt( 0, 100 ) > 95)
			DruggedEffect.Cast( kSlave, kSlave)
 		EndIf

	ElseIf (randomVar >= 2  )
		Debug.Notification( "., licks your face!" )
		kSlave.AddItem( Ale, 1, True )
		kSlave.EquipItem( Ale, True)

		Utility.Wait(3.0)

		If (Utility.RandomInt( 0, 100 ) > 95)
			DrunkEffect.Cast( kSlave, kSlave)
 		EndIf

	Else
		akSpeaker.SendModEvent("PCSubSex") ; Sex

	EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SPELL Property DruggedEffect  Auto  
SPELL Property DrunkEffect  Auto  

Potion Property Ale  Auto  

Potion Property Skooma  Auto  
