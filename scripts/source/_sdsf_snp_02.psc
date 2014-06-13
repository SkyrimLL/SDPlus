;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 22
Scriptname _sdsf_snp_02 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_21
Function Fragment_21()
;BEGIN CODE
_SDGVP_snp_busy.SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Actor male = _SDRAP_male.GetReference() as Actor
Actor female = _SDRAP_female.GetReference() as Actor

;snp.updatePos( male, female )

;funct.toggleActorClothing( male )
;funct.toggleActorClothing( female )

_SDSP_sex.Cast(male, female)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Actor male = _SDRAP_male.GetReference() as Actor
Actor female = _SDRAP_female.GetReference() as Actor

; fctConstraints.togglePlayerControlsOff( False )
_SDQP_sprigganslave.SetStage( 10 )

_SDGVP_snp_busy.SetValue(-1)
Self.GetowningQuest().Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_snp Property snp Auto
_SDQS_functions Property funct  Auto

ReferenceAlias Property _SDRAP_male  Auto  
{ref 1}
ReferenceAlias Property _SDRAP_female  Auto  
{ref 2}
Spell Property _SDSP_sex  Auto

Quest Property _SDQP_sprigganslave  Auto  
_SDQS_fcts_constraints Property fctConstraints  Auto
GlobalVariable Property _SDGVP_snp_busy  Auto  
