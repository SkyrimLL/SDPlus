Scriptname _sdtrg_spriggan_entrance extends ObjectReference  

ObjectReference Property _SD_KynesGroveDoorREF  Auto  


Event OnTriggerEnter(ObjectReference akActionRef)
	Actor akPlayer =  Game.GetPlayer() as Actor
    ActorBase PlayerBase = akPlayer.GetActorBase()

	If (_SD_SprigganQuest.GetStage() < 70) && (_SD_SprigganQuest.GetStage() > 10)
		Debug.Messagebox("The world fades as the very ground seems to open up around your feet and swallow you into the roots of the tree.")

		_SD_SprigganQuest.SetObjectiveCompleted( 60 )
		_SD_SprigganQuest.SetStage(75)
	Else

	   	if (akActionRef == Game.GetPlayer())  &&  ( ( (StorageUtil.GetIntValue(Game.GetPlayer(), "_SD_iSprigganInfected") == 1) || ( ( !akPlayer.WornHasKeyword( ClothingBody   )) && ( !akPlayer.WornHasKeyword( ArmorCuirass  )) ) ) || (PlayerBase.GetRace() == PolymorphRace))
			If (_SD_KynesGroveDoorREF.IsDisabled() )
				_SD_KynesGroveDoorREF.enable()
			EndIf
		Else
			If !(_SD_KynesGroveDoorREF.IsDisabled() )
				_SD_KynesGroveDoorREF.disable()
			EndIf
   		EndIf
	EndIf

EndEvent
Keyword Property ClothingBody  Auto  

Keyword Property ArmorCuirass  Auto  

Quest Property _SD_SprigganQuest  Auto  
Race Property PolymorphRace auto