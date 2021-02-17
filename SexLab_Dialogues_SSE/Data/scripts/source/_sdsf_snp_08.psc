;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname _sdsf_snp_08 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
snp._SDUIP_phase = 0
_SDGVP_snp_busy.SetValue(8)

Actor female = Game.GetPlayer() ; _SDRAP_female.GetReference() as Actor
_SDSP_host_punish.Cast( female, female )
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
snp._SDUIP_phase = 1
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
snp._SDUIP_phase = -1

Actor female = Game.GetPlayer() ; _SDRAP_female.GetReference() as Actor
female.DispelSpell( _SDSP_host_punish )

; female.PushActorAway(female, 0.1)

_SDGVP_snp_busy.SetValue(-1)
; Self.GetowningQuest().Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_snp Property snp Auto
ReferenceAlias Property _SDRAP_female  Auto 
SPELL Property _SDSP_host_punish  Auto  

GlobalVariable Property _SDGVP_snp_busy  Auto  
