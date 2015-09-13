;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname _SDAPPF_sanguine_welcome_01 Extends Package Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(Actor akActor)
;BEGIN CODE
;_SDKP_sex.SendStoryEvent( akRef1 = akActor, akRef2 = _SDRAP_dreamer.GetReference() as Actor, aiValue1 = 0, aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValueInt() ) )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Keyword Property _SDKP_sex Auto
GlobalVariable Property _SDGVP_positions  Auto  
ReferenceAlias Property _SDRAP_dreamer  Auto  
