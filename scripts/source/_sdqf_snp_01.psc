;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 23
Scriptname _sdqf_snp_01 Extends Quest Hidden

;BEGIN ALIAS PROPERTY _SDRA_sanguine_marker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine_marker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_bed_01
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_bed_01 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_strapon
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_strapon Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_bystander_01
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_bystander_01 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_strapon_thorn
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_strapon_thorn Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_male
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_male Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_marker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_marker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_naamah
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_naamah Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_strapon_unbp
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_strapon_unbp Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDLA_lockposition
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDLA_lockposition Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDLA_current
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias__SDLA_current Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_strapon_cbbe
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_strapon_cbbe Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_bystander_02
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_bystander_02 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_bed
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_bed Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_bystander_05
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_bystander_05 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_female
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_female Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_sexlight
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sexlight Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_bystander_04
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_bystander_04 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_erect_male
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_erect_male Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_bed_02
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_bed_02 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_bystander_03
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_bystander_03 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_sanguine
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_meridiana
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_meridiana Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_bed_03
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_bed_03 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN AUTOCAST TYPE _sdqs_snp
Quest __temp = self as Quest
_sdqs_snp kmyQuest = __temp as _sdqs_snp
;END AUTOCAST
;BEGIN CODE
;stage 10

Actor male = Alias__SDRA_male.GetReference() as Actor
Actor female = Alias__SDRA_female.GetReference() as Actor
ObjectReference bed = Alias__SDRA_bed.GetReference() as ObjectReference
ObjectReference sexLight = Alias__SDRA_sexlight.GetReference() as ObjectReference

male.AllowPCDialogue( True )

If ( female )
	female.EvaluatePackage()
EndIf

If ( bed )
	bed.Delete()
EndIf

If ( sexLight )
	sexLight.Delete()
EndIf

Game.EnablePlayerControls( abMovement = True )
Game.SetPlayerAIDriven( False )

_SDGV_snp_delay.SetValue( _SDGVP_gameDaysPassed.GetValue() + 0.05 )

Alias__SDRA_male.Clear()
Alias__SDRA_female.Clear()
Alias__SDRA_sexlight.Clear()

kmyQuest.iQuestActive = 0
Reset()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
; Game.DisablePlayerControls( abMovement = true )
; Game.SetPlayerAIDriven()

Actor male = Alias__SDRA_male.GetReference() as Actor
Actor female = Alias__SDRA_female.GetReference() as Actor
fctConstraints.actorCombatShutdown( male )
fctConstraints.actorCombatShutdown( female )

male.AllowPCDialogue( False )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_snp Property snp Auto
_SDQS_config Property config Auto

FormList Property _SDFLP_invalidRace Auto  
GlobalVariable Property _SDGV_snp_delay  Auto

GlobalVariable Property _SDGVP_gameDaysPassed  Auto  
_SDQS_fcts_constraints Property fctConstraints  Auto
