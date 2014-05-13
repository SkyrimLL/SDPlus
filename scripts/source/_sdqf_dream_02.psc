;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 12
Scriptname _sdqf_dream_02 Extends Quest Hidden

;BEGIN ALIAS PROPERTY _SDRA_dream_destination
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_dream_destination Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_enter
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_enter Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_irons
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_irons Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_dreamer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_dreamer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_meridiana
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_meridiana Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_eisheth
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_eisheth Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_sanguine_mf
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine_mf Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_naamah
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_naamah Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_leave
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_leave Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_nord_girl
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_nord_girl Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_imperial_man
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_imperial_man Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_sanguine_ff
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine_ff Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_sanguine_fm
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine_fm Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_sanguine
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_sanguine_mm
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine_mm Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; Player dreaming
Debug.Notification("[dream] Sanguine is welcoming you")
_SDQS_controller.SetObjectiveDisplayed(10)
_SDGV_SanguineBlessing.SetValue(_SDGV_SanguineBlessing.GetValue() + 1)
; Game.FadeOutGame(true, true, 0.1, 15)

kDreamer = Game.GetPlayer() as Actor
kEnter = Alias__SDRA_enter.GetReference() as ObjectReference
kLeave = Alias__SDRA_leave.GetReference() as ObjectReference

kLeave.MoveTo( kDreamer )
kDreamer.MoveTo( kEnter )
dreamQuest.positionVictims( GetStage() )

; Game.FadeOutGame(false, true, 5.0, 10.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
; Player rescued from imminent death without slavery option
Debug.Notification("[dream] Sanguine pulls you back to his lap [ " + _SDGV_SanguineBlessing.GetValue() + " ]")
_SDGV_SanguineBlessing.SetValue(_SDGV_SanguineBlessing.GetValue() + 1)
; Game.FadeOutGame(true, true, 0.1, 15)

kDreamer = Game.GetPlayer() as Actor
kEnter = Alias__SDRA_enter.GetReference() as ObjectReference
kLeave = Alias__SDRA_leave.GetReference() as ObjectReference

kLeave.MoveTo( kDreamer )
kDreamer.MoveTo( kEnter )

; Debug.SetGodMode( True )
; kDreamer.EndDeferredKill()
; Debug.SetGodMode( False )

dreamQuest.positionVictims( GetStage() )

; Game.FadeOutGame(false, true, 5.0, 10.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
; stage 999

; Alias__SDQA_spriggan.Clear()
_SDRAP_dreamer.Clear()
_SDRAP_enter.Clear()  
_SDRAP_leave.Clear()  
_SDRAP_naamah.Clear()  
_SDRAP_meridiana.Clear()  
_SDRAP_sanguine.Clear()  
_SDRAP_nord_girl.Clear()  
_SDRAP_imperial_man.Clear()    
_SDRAP_eisheth.Clear()  
_SDLA_safeHarbor.Clear() 


UnregisterForUpdate()

; SetObjectiveDisplayed(20, False)

Reset()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Debug.Notification("[dream] Sanguine is watching")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; Player rescued from high demerits
_SDGV_SanguineBlessing.SetValue(_SDGV_SanguineBlessing.GetValue() + 1)

Debug.Notification("[dream] Sanguine pulls you under his thumb [ " + _SDGV_SanguineBlessing.GetValue() + " ]")


; Game.FadeOutGame(true, true, 0.1, 15)

	_SDQP_enslavement.Stop()

	While ( !_SDQP_enslavement.IsStopped() )
	EndWhile
	Utility.Wait(5)


kDreamer = Game.GetPlayer() as Actor
kEnter = Alias__SDRA_enter.GetReference() as ObjectReference
kLeave = Alias__SDRA_leave.GetReference() as ObjectReference

kLeave.MoveTo( kDreamer )
kDreamer.MoveTo( kEnter )
dreamQuest.positionVictims( GetStage() )

Debug.Notification("[Dream] healing")
kDreamer.SetAV("health",1.0 )
kDreamer.RestoreAV("health", kDreamer.GetBaseAV("health") )

; Game.FadeOutGame(false, true, 5.0, 10.0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property _SDGV_SanguineBlessing  Auto  

Actor kSanguine
Actor kDreamer
Actor kMeridiana
Actor kNaamah
Actor kEisheth
ObjectReference kEnter
ObjectReference kLeave

ObjectReference Property _SD_sanguineHome  Auto  

_sdqs_dream Property dreamQuest  Auto  

ReferenceAlias Property _SDRAP_dreamer  Auto  
ReferenceAlias Property _SDRAP_enter  Auto  
ReferenceAlias Property _SDRAP_leave  Auto  
ReferenceAlias Property _SDRAP_naamah  Auto  
ReferenceAlias Property _SDRAP_meridiana  Auto  
ReferenceAlias Property _SDRAP_sanguine  Auto  
ReferenceAlias Property _SDRAP_nord_girl  Auto  
ReferenceAlias Property _SDRAP_imperial_man  Auto    
ReferenceAlias Property _SDRAP_eisheth  Auto  
ReferenceAlias Property _SDLA_safeHarbor  Auto  

Quest Property _SDQS_controller  Auto  

_sdqs_functions Property funct  Auto  

Quest Property _SDQP_enslavement  Auto  



