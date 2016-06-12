;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname SLD_TIF_PCSubBeastEnslave Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Form speakerRaceForm = akspeaker.GetActorBase().GetRace() as Form

if RaceBeastMasterList.HasForm(speakerRaceForm )

	Debug.Notification(" (tries to overpower you) ")

	fctDialogue.SetNPCDialogueState ( akSpeaker )
 
	fctDialogue.StartPlayerClaimedBeast( akSpeaker)
else
	Debug.Notification("[SD] beast enslavement attempt failed")


endIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SLD_QST_Main Property fctDialogue  Auto

GlobalVariable Property isRaceBeastMaster  Auto  

FormList Property RaceBeastMasterList  Auto  
