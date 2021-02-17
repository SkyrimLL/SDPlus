;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_HelpFollower01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor akPlayer = Game.GetPlayer()

; Emergency clear up of inventory items
akSpeaker.RemoveAllItems(akTransferTo = akPlayer )
akSpeaker.SetOutfit(nakedOutfit)

akSpeaker.SendModEvent("SDClearDevice","Gag")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Outfit Property nakedOutfit  Auto  
