;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubCold06 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
StorageUtil.SetIntValue( Game.GetPlayer(), "_SD_iEnableArmorEquip", 1)
StorageUtil.SetIntValue( Game.GetPlayer(), "_SD_iEnableClothingEquip", 1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SPELL Property DruggedEffect  Auto  
SPELL Property DrunkEffect  Auto  

Potion Property Ale  Auto  

Potion Property Skooma  Auto  

Armor  Property _SD_SlaveRags  Auto  
