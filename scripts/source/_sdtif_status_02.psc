;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_status_02 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Self.GetOwningQuest().ModObjectiveGlobal(  5.0 -  Utility.RandomInt( 1, 6), _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

if (_SDGVP_demerits.GetValue()<= -100)
	Debug.MessageBox("You are doing very well, pet (Satisfied) \n " + _SDGVP_demerits.GetValue() as Int + "  \n Why don't you get back to work? \n ( " + _SDGVP_buyout.GetValue() as Int + " gold left)" ) 
Elseif (_SDGVP_demerits.GetValue()<=-50)
	Debug.MessageBox("Keep up and we may do something of you.. (Happy) \n " + _SDGVP_demerits.GetValue() as Int + "  \n You still owe me. \n ( " + _SDGVP_buyout.GetValue() as Int + " gold left)" ) 

Else
	Debug.MessageBox("Don't think you are getting anywhere, slave (Tentative) \n " + _SDGVP_demerits.GetValue() as Int + "  \n Now make yourself useful. \n ( " + _SDGVP_buyout.GetValue() as Int + " gold left)" ) 
 
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property _SDGVP_demerits  Auto  

GlobalVariable Property _SDGVP_buyout  Auto  

GlobalVariable Property _SDGVP_demerits_join  Auto  

GlobalVariable Property _SDGVP_config_verboseMerits  Auto  
