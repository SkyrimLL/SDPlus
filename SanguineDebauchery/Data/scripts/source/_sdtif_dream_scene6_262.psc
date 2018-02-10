;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_dream_scene6_262 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.GetPlayer()
Int randomNum = Utility.RandomInt(0, 100)

kPlayer.AddItem(FoodHonningbrewMead, 2 )
kPlayer.EquipItem(FoodHonningbrewMead, 2 )
akSpeaker.AddItem(FoodHonningbrewMead, 1 )
akSpeaker.EquipItem(FoodHonningbrewMead, 1 )

Self.GetOwningQuest().SetStage(262)
Self.GetOwningQuest().SetStage(268)
_sd_sanguine_path.Setvalue(1)

StorageUtil.SetIntValue( kPlayer , "_SD_iSub", StorageUtil.GetIntValue( kPlayer , "_SD_iSub") + 2)
StorageUtil.SetIntValue( akSpeaker, "_SD_iDisposition", StorageUtil.GetIntValue( akSpeaker, "_SD_iDisposition"  ) + 2  )

If (randomNum > 50)
	akSpeaker.SendModEvent("PCSubEntertain", "Gangbang") ; Gang Bang
Else
	akSpeaker.SendModEvent("PCSubSex") ; Sex
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Potion Property FoodHonningbrewMead  Auto  

GlobalVariable Property _SD_Sanguine_path  Auto  
