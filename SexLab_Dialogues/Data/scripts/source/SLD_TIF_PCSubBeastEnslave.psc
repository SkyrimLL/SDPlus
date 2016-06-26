;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname SLD_TIF_PCSubBeastEnslave Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
ActorBase akActorBase = akspeaker.GetLeveledActorBase() as ActorBase
Form speakerRaceForm = akActorBase.GetRace() as Form

; Debug.Notification("[SD] beast enslavement - Race: " + akActorBase.GetRace().GetName())
Debug.Trace("[SD] beast enslavement - Race: " + akActorBase.GetRace().GetName())

Int valueCount = StorageUtil.FormListCount(none, "_SD_lRaceMastersList")
int i = 0
Form thisRace
String sRaceName
Bool bRaceMatch = False

while(i < valueCount) && (!bRaceMatch)
	thisRace = StorageUtil.FormListGet(none, "_SD_lRaceMastersList", i)
	sRaceName = thisRace.GetName()
	
	If (sRaceName == "")
		sRaceName = speakerRaceForm as String
	endif

	If (StorageUtil.GetStringValue( thisRace, "_SD_sRaceType") == "Beast"  ) && (thisRace == speakerRaceForm); (StringUtil.Find(sRaceName, akActorBase.GetRace().GetName())!= -1)
		Debug.Trace("	Race [" + i + "] = " + sRaceName + " Race formID: " + thisRace + " FormID to match: " + speakerRaceForm)
		bRaceMatch = True
		Debug.Notification(" (tries to overpower you) ")

		fctDialogue.SetNPCDialogueState ( akSpeaker )
	 
		fctDialogue.StartPlayerClaimedBeast( akSpeaker)
	endif

	i += 1
EndWhile


if  (!bRaceMatch)
	; Debug.Notification("[SD] beast enslavement attempt failed")
	Debug.Trace("[SD] beast enslavement attempt failed")


endIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SLD_QST_Main Property fctDialogue  Auto

; Deprecated - using storageUtil list instead (as defined by SD+)
GlobalVariable Property isRaceBeastMaster  Auto  

FormList Property RaceBeastMasterList  Auto  
