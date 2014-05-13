;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 50
Scriptname _sdsf_snp_05 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
snp._SDUIP_phase = 0
_SDGVP_snp_busy.SetValue(5)

; Debug.Notification("You will regret this! [whipping start]")

Actor female = _SDRAP_female.GetReference() as Actor
ObjectReference marker = _SDRAP_marker.GetReference() as ObjectReference

; marker.MoveTo( female, 128 * Math.Sin( female.GetAngleZ() ), 128 * Math.Cos( female.GetAngleZ() ), female.GetHeight() )

Game.EnablePlayerControls( abMovement = True )
Game.SetPlayerAIDriven( False )
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
snp._SDUIP_phase = -1
Debug.Notification("Enough of that... ")



; female.PushActorAway(female, 0.000001)


Game.EnablePlayerControls( abMovement = True )
Game.SetPlayerAIDriven( False )

_SDGVP_snp_busy.SetValue(-1)
; Self.GetowningQuest().Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_27
Function Fragment_27()
;BEGIN CODE
snp._SDUIP_phase = 1
; Debug.Notification("[whipping] phase =" + snp._SDUIP_phase)

ObjectReference slaveREF = _SDRAP_female.GetReference()
; Debug.SendAnimationEvent(slaveREF , "ZazAPC055")
; utility.wait(55)

ObjectReference female = _SDRAP_female.GetReference() as ObjectReference
ObjectReference marker = _SDRAP_marker.GetReference() as ObjectReference

; marker.MoveTo( female, 64 * Math.Sin( female.GetAngleZ() ), 64 * Math.Cos( female.GetAngleZ() ), female.GetHeight() )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_snp Property snp Auto
_SDQS_functions Property funct  Auto
_SDQS_enslavement Property enslave  Auto  

Quest Property _SDQP_enslavement  Auto  

ReferenceAlias Property _SDRAP_female  Auto
ReferenceAlias Property _SDRAP_bindings  Auto    
ReferenceAlias Property _SDRAP_marker  Auto  
FormList Property _SDFLP_punish_items  Auto

ReferenceAlias Property _SDRAP_male  Auto  

GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_config_verboseMerits  Auto

Faction Property _SDFP_slaverCrimeFaction  Auto 

GlobalVariable Property _SDGVP_snp_busy  Auto  
