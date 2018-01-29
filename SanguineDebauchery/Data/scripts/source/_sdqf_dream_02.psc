;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 34
Scriptname _sdqf_dream_02 Extends Quest Hidden

;BEGIN ALIAS PROPERTY _SDRA_sanguine_ff
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine_ff Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_sanguine_svana
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine_svana Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_nord_girl
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_nord_girl Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_sanguine_fm
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine_fm Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_sanguine_m
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine_m Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_irons
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_irons Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_redguard_girl
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_redguard_girl Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_leave
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_leave Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_sanguine_mm
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine_mm Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_enter
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_enter Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_sanguine_haelga
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine_haelga Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_meridiana
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_meridiana Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_imperial_girl
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_imperial_girl Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_naamah
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_naamah Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_imperial_man
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_imperial_man Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_sanguine_f
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine_f Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_dream_destination
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_dream_destination Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_sanguine_sam
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine_sam Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_sanguine
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_eisheth
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_eisheth Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_sanguine_mf
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_sanguine_mf Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_dreamer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_dreamer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_PlayerSuccubusFollower
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_PlayerSuccubusFollower Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN CODE
SetObjectiveDisplayed(220,false)
SetObjectiveDisplayed(222)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_31
Function Fragment_31()
;BEGIN CODE
SetObjectiveDisplayed(252,false)
SetObjectiveDisplayed(254)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_12
Function Fragment_12()
;BEGIN CODE
; Player dreaming after first visit
; Debug.Notification("[dream] Sanguine is welcoming you")

_SDGV_Demerits.SetValue( 0 )

kDreamer = Game.GetPlayer() as Actor
kEnter = Alias__SDRA_enter.GetReference() as ObjectReference
kLeave = Alias__SDRA_leave.GetReference() as ObjectReference

If ( kDreamer.Is3DLoaded()) && (Game.GetPlayer().GetParentCell() != _SD_SanguineDreamworld) && (StorageUtil.GetIntValue(kDreamer , "_SD_iDisableDreamworld") == 0)
    kLeave.MoveTo( kDreamer )
    kDreamer.MoveTo( kEnter )
    dreamQuest.positionVictims( 15 )
Endif

; Game.FadeOutGame(false, true, 5.0, 10.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_24
Function Fragment_24()
;BEGIN CODE
SetObjectiveDisplayed(240,false)
SetObjectiveDisplayed(242)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_25
Function Fragment_25()
;BEGIN CODE
SetObjectiveDisplayed(222,false)
SetObjectiveDisplayed(224)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_30
Function Fragment_30()
;BEGIN CODE
SetObjectiveDisplayed(250,false)
SetObjectiveDisplayed(252)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_21
Function Fragment_21()
;BEGIN CODE
; talk to alicia 1
SetObjectiveDisplayed(232)
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

;BEGIN FRAGMENT Fragment_19
Function Fragment_19()
;BEGIN CODE
SetObjectiveDisplayed(230,false)
SetObjectiveDisplayed(232,false)
SetObjectiveDisplayed(234,false)
SetObjectiveDisplayed(236,false)
SetObjectiveDisplayed(240)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; Player dreaming
Debug.Notification("[dream] Sanguine is welcoming you")
_SDQS_controller.SetObjectiveDisplayed(10)
_SDGV_Demerits.SetValue( 0 )

kDreamer = Game.GetPlayer() as Actor
kEnter = Alias__SDRA_enter.GetReference() as ObjectReference
kLeave = Alias__SDRA_leave.GetReference() as ObjectReference

If ( kDreamer.Is3DLoaded()) && (Game.GetPlayer().GetParentCell() != _SD_SanguineDreamworld) && (StorageUtil.GetIntValue(kDreamer , "_SD_iDisableDreamworld") == 0)
    kLeave.MoveTo( kDreamer )
    kDreamer.MoveTo( kEnter )

    dreamQuest.positionVictims( 10 )
Endif
; Game.FadeOutGame(false, true, 5.0, 10.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_33
Function Fragment_33()
;BEGIN CODE
SetObjectiveDisplayed(256,false)
SetObjectiveDisplayed(260)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_22
Function Fragment_22()
;BEGIN CODE
; talk to alicia 2
SetObjectiveDisplayed(234)
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

;BEGIN FRAGMENT Fragment_18
Function Fragment_18()
;BEGIN CODE
SetObjectiveDisplayed(226,false)
SetObjectiveDisplayed(230)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; Player rescued from high demerits
_SDGV_Demerits.SetValue( 0 )

; Debug.Notification("[dream] Sanguine pulls you under his thumb [ " + _SDGV_SanguineBlessing.GetValue() + " ]")


kDreamer = Game.GetPlayer() as Actor
kEnter = Alias__SDRA_enter.GetReference() as ObjectReference
kLeave = Alias__SDRA_leave.GetReference() as ObjectReference

If ( kDreamer.Is3DLoaded()) && (Game.GetPlayer().GetParentCell() != _SD_SanguineDreamworld) && (StorageUtil.GetIntValue(kDreamer , "_SD_iDisableDreamworld") == 0)
	_SDQP_enslavement.Stop()

	While ( !_SDQP_enslavement.IsStopped() )
	EndWhile
	Utility.Wait(5)

    kLeave.MoveTo( kDreamer )
    kDreamer.MoveTo( kEnter )
    dreamQuest.positionVictims( 20 )
Endif
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_23
Function Fragment_23()
;BEGIN CODE
; talk to alicia 3
SetObjectiveDisplayed(236)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_27
Function Fragment_27()
;BEGIN CODE
SetObjectiveDisplayed(224,false)
SetObjectiveDisplayed(226)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN CODE
ObjectReference DremoraSlaver= _SDRAP_sanguine.GetReference() 
SetObjectiveDisplayed(200)

If (StorageUtil.GetIntValue(none, "_SLS_iPlayerStartAlicia")!=1)
	SendModEvent("_SLS_PlayerAlicia")
Endif

if (DremoraSlaver!=None)
	DremoraSlaver.sendModEvent("PCSubEnslave")
Else
	Debug.Trace("[SD] Sanguine not ready yet... skipping enslavement in dreamworld")
Endif
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_32
Function Fragment_32()
;BEGIN CODE
SetObjectiveDisplayed(254,false)
SetObjectiveDisplayed(256)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_29
Function Fragment_29()
;BEGIN CODE
SetObjectiveDisplayed(244,false)
SetObjectiveDisplayed(250)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_16
Function Fragment_16()
;BEGIN CODE
SetObjectiveDisplayed(200,false)
SetObjectiveDisplayed(210)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
; Player rescued from imminent death without slavery option
; Debug.Notification("[dream] Sanguine pulls you back to his lap [ " + _SDGV_SanguineBlessing.GetValue() + " ]")
_SDGV_Demerits.SetValue( 0 )

kDreamer = Game.GetPlayer() as Actor
kEnter = Alias__SDRA_enter.GetReference() as ObjectReference
kLeave = Alias__SDRA_leave.GetReference() as ObjectReference

If ( kDreamer.Is3DLoaded()) && (Game.GetPlayer().GetParentCell() != _SD_SanguineDreamworld) && (StorageUtil.GetIntValue(kDreamer , "_SD_iDisableDreamworld") == 0)
    kLeave.MoveTo( kDreamer )
    kDreamer.MoveTo( kEnter )
 
    dreamQuest.positionVictims( 100 )
Endif

; Game.FadeOutGame(false, true, 5.0, 10.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_28
Function Fragment_28()
;BEGIN CODE
SetObjectiveDisplayed(242,false)
SetObjectiveDisplayed(244)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_17
Function Fragment_17()
;BEGIN CODE
SetObjectiveDisplayed(210,false)
SetObjectiveDisplayed(220)
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


_SDQS_fcts_outfit Property fctOutfit  Auto


GlobalVariable Property _SDGV_Demerits  Auto  

Cell Property _SD_SanguineDreamworld  Auto  
