;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubSkooma01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kSlave = game.GetPlayer()

	Debug.Notification( "Your mouth is held open as you are forced to swallow..." )
	int randomVar = Utility.RandomInt( 0, 10 ) 
	 
	If (randomVar >= 5  )
		If ( StorageUtil.GetIntValue( akSpeaker, "_SD_iDisposition") >= 0) && ( StorageUtil.GetIntValue( akSpeaker, "_SD_iTrust") >= 0)
			kSlave.AddItem( DoubleDistilledSkooma  , 1, True )
			kSlave.EquipItem( DoubleDistilledSkooma  , True, True )

		ElseIf ( StorageUtil.GetIntValue( akSpeaker, "_SD_iDisposition") >= 0) && ( StorageUtil.GetIntValue( akSpeaker, "_SD_iTrust") < 0)
			kSlave.AddItem( BalmoraBlue  , 1, True )
			kSlave.EquipItem( BalmoraBlue  , True, True )
		Else
			kSlave.AddItem( Skooma, 1, True )
			kSlave.EquipItem( Skooma, True, True )
		EndIf

		Utility.Wait(3.0)
	 	DruggedEffect.Cast( kSlave, kSlave)

		If (Utility.RandomInt( 0, 100 ) > 30)
			Debug.Notification( "In a stupor you start dancing for no reason..." )
			; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)
 			akSpeaker.SendModEvent("PCSubEntertain") ; Dance
 		EndIf

	ElseIf (randomVar >= 2  )
		kSlave.AddItem( DummySkooma  , 1, True )
		kSlave.EquipItem( DummySkooma  , True, True )

	Else
		kSlave.AddItem( Skooma, 1, True )
		kSlave.EquipItem( Skooma, True, True )

		akSpeaker.SendModEvent("PCSubSex") ; Sex

	EndIf

;	While ( Utility.IsInMenuMode() )
;	EndWhile
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SPELL Property DruggedEffect  Auto  
SPELL Property DrunkEffect  Auto  

Potion Property Ale  Auto  

Potion Property Skooma  Auto  

Potion Property DummySkooma  Auto  

Potion Property DoubleDistilledSkooma  Auto  

Potion Property BalmoraBlue  Auto  
