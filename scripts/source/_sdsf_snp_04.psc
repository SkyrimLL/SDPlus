;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 83
Scriptname _sdsf_snp_04 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_47
Function Fragment_47()
;BEGIN CODE
snp._SDUIP_phase = 0
_SDGVP_snp_busy.SetValue(4)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_30
Function Fragment_30()
;BEGIN CODE
snp._SDUIP_phase = -1

Actor male = _SDRAP_male.GetReference() as Actor
Actor female = _SDRAP_female.GetReference() as Actor
;ObjectReference strapon = _SDRAP_strapon.GetReference() as ObjectReference

;If ( male && strapon )
;	male.UnequipItem(  strapon.GetBaseObject() as Armor )
;	male.RemoveItem(  strapon.GetBaseObject() as Armor )
;	strapon.Delete()
;EndIf

; funct.toggleActorClothing ( male, False )
; funct.toggleActorClothing ( female, False )

;male.DispelSpell(_SDSP_sex)
;female.DispelSpell(_SDSP_sex)

female.PushActorAway(female, 0.1)
male.PushActorAway(male, 0.1)

;If ( male.HasKeyword( _SDKP_vampire ) )
;	female.DoCombatSpellApply( _SDSP_vampire, female )
;EndIf

_SDGVP_snp_busy.SetValue(-1)
Self.GetowningQuest().Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_79
Function Fragment_79()
;BEGIN CODE
snp._SDUIP_phase = 1
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_81
Function Fragment_81()
;BEGIN CODE
snp._SDUIP_phase = 3
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_80
Function Fragment_80()
;BEGIN CODE
snp._SDUIP_phase = 2
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_82
Function Fragment_82()
;BEGIN CODE
snp._SDUIP_phase = 4
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Import Utility

_SDQS_snp Property snp Auto
_SDQS_functions Property funct  Auto

ReferenceAlias Property _SDRAP_male  Auto  
{ref 1}
ReferenceAlias Property _SDRAP_female  Auto  
{ref 2}

GlobalVariable Property _SDGVP_snp_busy  Auto  
