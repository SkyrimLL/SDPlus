;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname _SD_snp_10_start Extends Scene Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
Debug.Notification("$[SNP] Your owner found you...")
_SDGVP_snp_busy.SetValue(-1)
; Self.GetowningQuest().Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
_SDGVP_snp_busy.SetValue(10)
Debug.Notification("$[SNP] Your owner is looking for you...")
; Alias_Master.GetReference().MoveTo( Alias_Slave.GetReference() )
; Utility.Wait(1.0)
; Debug.Notification("Master stopped")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property Alias_Master  Auto  

ReferenceAlias Property Alias_Slave  Auto  

GlobalVariable Property _SDGVP_snp_busy  Auto  
