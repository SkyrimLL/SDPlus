;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 11
Scriptname _sdqfs_controller_01 Extends Quest Hidden

;BEGIN ALIAS PROPERTY _SDRA_lust
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_lust Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_player_safe
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_player_safe Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_lust_m
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_lust_m Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_lust_f
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_lust_f Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
; SetObjectiveDisplayed(0)
; ( Alias__SDRA_player.GetReference() as Actor ).StartDeferredKill()

fctSlavery.InitSlaveryState( Alias__SDRA_player.GetReference() as Actor )
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
Actor player = Alias__SDRA_player.GetReference() as Actor
ObjectReference lust_f = Alias__SDRA_lust_f.GetReference() as ObjectReference
ObjectReference lust_m = Alias__SDRA_lust_m.GetReference() as ObjectReference

; Debug.SetGodMode( True )
; player.EndDeferredKill()
; Debug.SetGodMode( False )

SetObjectiveDisplayed(0, False)

If ( lust_f )
;	player.RemoveItem( lust_f, 1, True )
EndIf
If ( lust_m )
;	player.RemoveItem( lust_m, 1, True )
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

;; USED
_SDQS_fcts_slavery Property fctSlavery  Auto
GlobalVariable Property _SDGVP_enslaved  Auto  
