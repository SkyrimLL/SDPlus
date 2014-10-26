;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_status_01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; Self.GetOwningQuest().ModObjectiveGlobal( Utility.RandomInt( 1, 5), _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

if (_SDGVP_demerits.GetValue()>=100)
	Debug.MessageBox("What am I going to do with you? (Furious) \n " + _SDGVP_demerits.GetValue() as Int +" / " +_SDGVP_demerits_join.GetValue() as Int + " to complete your training. \n Now get me some gold!  \n ( " + _SDGVP_buyout.GetValue()  as Int + " gold left)" ) 
Elseif (_SDGVP_demerits.GetValue()>=50)
	Debug.MessageBox("Your defiance is futile... (Angry) \n " + _SDGVP_demerits.GetValue() as Int + " / " +_SDGVP_demerits_join.GetValue() as Int + " to complete your training.  \n Islands are not cheap, you still owe me. \n ( " + _SDGVP_buyout.GetValue()  as Int + " gold left)" ) 
Else
	Debug.MessageBox("Don't make me regret not killing you! (Annoyed)  \n " + _SDGVP_demerits.GetValue() as Int + " / " +_SDGVP_demerits_join.GetValue() as Int + " to complete your training.  \n Now make yourself useful. \n ( " + _SDGVP_buyout.GetValue()  as Int + " gold left)" ) 
 
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property _SDGVP_demerits  Auto  

GlobalVariable Property _SDGVP_buyout  Auto  

GlobalVariable Property _SDGVP_demerits_join  Auto  

GlobalVariable Property _SDGVP_config_verboseMerits  Auto  
