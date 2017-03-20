;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubInjured01a Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kSlave = game.GetPlayer()

	Debug.Notification( "Your mouth is held open as you are forced to swallow..." )
	int randomVar = Utility.RandomInt( 0, 10 ) 
	 
	If (randomVar >= 9  ) && (StorageUtil.GetIntValue( akSpeaker , "_SD_iDisposition") < 0 )
		Debug.Notification( "..some Skooma!" )
		kSlave.AddItem( Skooma, 1, True )
		kSlave.EquipItem( Skooma, True, True )
		SendModEvent("SDModMasterTrust", 2)

		Utility.Wait(3.0)
	 	DruggedEffect.Cast( kSlave, kSlave)

		If (Utility.RandomInt( 0, 100 ) > 30)
			Debug.Notification( "In a stupor you start dancing for no reason..." )
			; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)
 			akSpeaker.SendModEvent("PCSubEntertain") ; Dance
 		EndIf

	Else 
		Debug.Notification( "..some potion!" )
	 	_SLD_Player.GiftFromNPC(akSpeaker, "Hurt")


		If (Utility.RandomInt(0,100)>20)
			kSlave.AddItem( CureDiseases, 1, True )
			kSlave.EquipItem( CureDiseases, True, True )
		Endif
 
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

Potion Property CureDiseases  Auto  

Potion Property CurePoison  Auto  
SLD_PlayerAlias Property _SLD_Player Auto