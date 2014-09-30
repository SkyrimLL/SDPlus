;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_submit_05 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor akPlayer = SexLab.PlayerRef 

If funct.checkGenderRestriction( akSpeaker,  akPlayer )
;			_SDGVP_enslaved.SetValue(1)
;			_SDGV_leash_length.SetValue(400)
;		
;			If akPlayer.WornHasKeyword( _SDKP_bound )
;					; item cleanup
;				funct.removeItemsInList( akPlayer, _SDFLP_sex_items )
;				funct.removeItemsInList( akPlayer, _SDFLP_punish_items )
;				funct.removeItemsInList( akPlayer, _SDFLP_master_items )
;			EndIf
;			Utility.Wait(2.0)
;
;			; Debug.Trace("_SDKP_enslave akAggressor:" + akAggressor + " akPlayer:" + akPlayer )

			_SDKP_enslave.SendStoryEvent( akLoc = akSpeaker.GetCurrentLocation(), akRef1 = akSpeaker, akRef2 = akPlayer, aiValue1 = 0, aiValue2 = 0)

Else
	Debug.Notification("You are not worth my time...")
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property _SDGVP_enslaved Auto
GlobalVariable Property _SDGV_leash_length Auto
Keyword Property _SDKP_bound Auto
Keyword Property _SDKP_enslave Auto
FormList Property _SDFLP_sex_items Auto
FormList Property _SDFLP_punish_items Auto
FormList Property _SDFLP_master_items Auto
_SDQS_functions Property funct Auto

SexLabFramework Property SexLab  Auto  
