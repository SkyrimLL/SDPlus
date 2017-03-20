;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubBeastHungry Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kSlave = game.GetPlayer()

	Debug.Notification( "Your owner steps away and comes back with..." )
	int randomVar = Utility.RandomInt( 0, 10 ) 

	If (randomVar >= 9  )
		Debug.Notification( "..some mushroom." )
		kSlave.AddItem( Skooma, 1, True )
		kSlave.EquipItem( Skooma, True  )

		If (Utility.RandomInt( 0, 100 ) > 95)
	 		DruggedEffect.Cast( kSlave, kSlave)
		Endif

		If (Utility.RandomInt( 0, 100 ) > 30)
			Debug.Notification( "Your owner jumps you as you bend down..." )
			; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)
 			akSpeaker.SendModEvent("PCSubSex")  
 		EndIf

	Else 
		_SLD_Player.GiftFromNPC(akSpeaker, "Hungry")

	EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SPELL Property DruggedEffect  Auto  
SPELL Property DrunkEffect  Auto  

Potion Property Potato Auto  

Potion Property Skooma  Auto  

Potion Property Beef  Auto  
SLD_PlayerAlias Property _SLD_Player Auto
