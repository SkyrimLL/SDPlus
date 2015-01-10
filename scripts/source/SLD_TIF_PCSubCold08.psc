;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubCold08 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
StorageUtil.SetIntValue( Game.GetPlayer(), "_SD_iEnableArmorEquip", 0)
StorageUtil.SetIntValue( Game.GetPlayer(), "_SD_iEnableClothingEquip", 0)

Int randomNum = Utility.RandomInt(0, 100)
StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)

If (randomNum > 50)
	Debug.Notification("Show us what you can do...")
	SendModEvent("PCSubEntertain", "Soloshow") ; Show
ElseIf (randomNum > 30)
	Debug.Notification("Help yourselves boys!...")
	SendModEvent("PCSubEntertain", "Gangbang") ; Gang bang
Else
	Debug.Notification("Get on your knees and lift up that ass of yours...")
	SendModEvent("PCSubSex") ; Sex
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SPELL Property DruggedEffect  Auto  
SPELL Property DrunkEffect  Auto  

Potion Property Ale  Auto  

Potion Property Skooma  Auto  

Armor  Property _SD_SlaveRags  Auto  
