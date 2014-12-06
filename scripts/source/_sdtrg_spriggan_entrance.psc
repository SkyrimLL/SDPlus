Scriptname _sdtrg_spriggan_entrance extends ObjectReference  

ObjectReference Property _SD_KynesGroveDoorREF  Auto  


Event OnTriggerEnter(ObjectReference akActionRef)
	Actor akPlayer =  Game.GetPlayer() as Actor

   	if ( (akActionRef == Game.GetPlayer())  &&  ( (StorageUtil.GetIntValue(Game.GetPlayer(), "_SD_iSprigganInfected") == 1) || ( ( !akPlayer.WornHasKeyword( ClothingBody   )) && ( !akPlayer.WornHasKeyword( ArmorCuirass  )) ) ) )
		If (_SD_KynesGroveDoorREF.IsDisabled() )
			_SD_KynesGroveDoorREF.enable()
		EndIf
	Else
		If !(_SD_KynesGroveDoorREF.IsDisabled() )
			_SD_KynesGroveDoorREF.disable()
		EndIf
   	EndIf

EndEvent
Keyword Property ClothingBody  Auto  

Keyword Property ArmorCuirass  Auto  

Quest Property _SD_SprigganQuest  Auto  
