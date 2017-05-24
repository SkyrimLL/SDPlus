;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname _sdsf_snp_09 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
snp._SDUIP_phase = 0
_SDGVP_snp_busy.SetValue(9)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
snp._SDUIP_phase = -1

_SDGVP_snp_busy.SetValue(-1)
; Self.GetowningQuest().Stop()
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

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
snp._SDUIP_phase = 2
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Import Utility

_SDQS_snp Property snp Auto
_SDQS_functions Property funct  Auto

GlobalVariable Property _SDGVP_snp_busy  Auto  
