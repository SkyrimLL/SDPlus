;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 11
Scriptname _sdtif_whore_01f Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_10
Function Fragment_10(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor whore = _SDRAP_whore.GetReference() as Actor
Int payment = Utility.RandomInt(50, 100) + Math.Floor( whore.GetAV("Speechcraft") as Int / 2 )
; add to the player first so it's registered in _SDFLP_trade_items
 
whore.AddItem(_SDMOP_egg, payment, false)


; _SDKP_sex.SendStoryEvent(akLoc = whore.GetCurrentLocation(),  akRef1 = akSpeaker, akRef2 = whore, aiValue1 = 0, aiValue2 = 0 )
akSpeaker.SendModEvent("PCSubSex") ; Sex

;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;While ( akSpeaker.IsInDialogueWithPlayer() )
;EndWhile
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Keyword Property _SDKP_sex  Auto  
MiscObject Property _SDMOP_gold  Auto  
GlobalVariable Property _SDGVP_positions  Auto  
ReferenceAlias Property _SDRAP_whore  Auto  
ReferenceAlias Property _SDRAP_master  Auto  
SexLabFramework property SexLab auto

Ingredient Property _SDMOP_egg  Auto  
