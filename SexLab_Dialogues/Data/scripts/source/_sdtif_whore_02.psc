;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 9
Scriptname _sdtif_whore_02 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_6
Function Fragment_6(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;While ( akSpeaker.IsInDialogueWithPlayer() )
;EndWhile
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor whore = _SDRAP_whore.GetReference() as Actor
Int payment = Utility.RandomInt(50, 100) + Math.Floor( whore.GetAV("Speechcraft") as Int / 2 )
; add to the player first so it's registered in _SDFLP_trade_items
whore.AddItem(_SDMOP_gold, payment, false)

; _SDKP_sex.SendStoryEvent(akLoc = whore.GetCurrentLocation(),  akRef1 = akSpeaker, akRef2 = whore, aiValue1 = 0, aiValue2 = 0 )
akSpeaker.SendModEvent("PCSubSex") ; Sex

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
