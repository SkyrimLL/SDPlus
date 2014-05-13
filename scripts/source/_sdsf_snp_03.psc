;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 86
Scriptname _sdsf_snp_03 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_68
Function Fragment_68()
;BEGIN CODE
snp._SDUIP_phase = 1
; Debug.Notification("[punishment] phase =" + snp._SDUIP_phase)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_18
Function Fragment_18(ReferenceAlias akAlias)
;BEGIN CODE
Game.FadeOutGame(True, True, 3.0, 2.0)
Utility.Wait(2)
Actor female = _SDRAP_female.GetReference() as Actor
Debug.SendAnimationEvent(female, "IdleForceDefaultState")
;female.PushActorAway(female, 0.1)
Game.FadeOutGame(False, True, 15.0, 5.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
snp._SDUIP_phase = 0
_SDGVP_snp_busy.SetValue(3)

; Debug.Notification("[punishment] phase =" + snp._SDUIP_phase)
Debug.Notification("This is going to hurt! [punishment start]")

Actor female = _SDRAP_female.GetReference() as Actor
Actor male = _SDRAP_male.GetReference() as Actor
ObjectReference marker = _SDRAP_marker.GetReference() as ObjectReference

marker.MoveTo( female, 128 * Math.Sin( female.GetAngleZ() ), 128 * Math.Cos( female.GetAngleZ() ), female.GetHeight() )

; _SDGVP_trust_hands.SetValue(1)
; _SDGVP_trust_feet.SetValue(1)

;funct.toggleActorClothing ( male, False )
funct.toggleActorClothing ( female, True )

; female.UnequipAll()

Game.FadeOutGame(True, True, 3.0, 2.0)
Utility.Wait(2)
Game.FadeOutGame(False, True, 15.0, 5.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_34
Function Fragment_34()
;BEGIN CODE
snp._SDUIP_phase = 2
Debug.Notification("[punishment] phase =" + snp._SDUIP_phase)

; Game.DisablePlayerControls( abMovement = true )

ObjectReference slaveREF = _SDRAP_female.GetReference()

Int RandomNum = (_SDGVP_demerits.GetValue() as Int) / 10

; Debug.Notification("[punishment] Position: " + RandomNum  ) 
; Debug.Trace("[punishment] Position: " + RandomNum  ) 

RandomNum = -1  ; skipping for now

If (RandomNum == 0)
	Debug.SendAnimationEvent(slaveREF , "ZazAPC002") ; 		HandsBehindStandLegsSpread				
ElseIf (RandomNum == 1)
	Debug.SendAnimationEvent(slaveREF , " ZazAPC003") ;  		HandsBehindStandBowDown													
ElseIf (RandomNum == 2)
	Debug.SendAnimationEvent(slaveREF , " ZazAPC011") ;  		HandsBehindLieFaceDown												
ElseIf (RandomNum == 3)
	Debug.SendAnimationEvent(slaveREF , " ZazAPC013") ;  		HandsBehindLieFaceUp						
ElseIf (RandomNum == 4)
	Debug.SendAnimationEvent(slaveREF , " ZazAPC014") ;  		HandsBehindLieSideCurlUp					
ElseIf (RandomNum == 5)
	Debug.SendAnimationEvent(slaveREF , " ZazAPCAO014") ;  		PostRestraintStandHandUp
ElseIf (RandomNum == 6)
	Debug.SendAnimationEvent(slaveREF , " ZazAPC016") ;  		HandsBehindKneelHigh						
ElseIf (RandomNum == 7)
	Debug.SendAnimationEvent(slaveREF , " ZazAPC017") ;  		HandsBehindKneelHighLegSpread					
ElseIf (RandomNum == 8)
	Debug.SendAnimationEvent(slaveREF , " ZazAPC019") ;  		HandsBehindKneelLegSpread					
ElseIf (RandomNum == 9)
	Debug.SendAnimationEvent(slaveREF , " ZazAPCAO014") ;  		PostGibbetKneel
ElseIf (RandomNum == 10)
	Debug.SendAnimationEvent(slaveREF , " ZazAPCAO003") ;  	    PostGibbetStand
ElseIf (RandomNum == 11)
	Debug.SendAnimationEvent(slaveREF , " ZazAPC054") ; 		HandsBehindLieFaceUpLegsSpread-Struggle I
ElseIf (RandomNum == 12)
	Debug.SendAnimationEvent(slaveREF , " ZazAPC055") ;  		HandsBehindLieFaceUpLegsSpread-Struggle II
ElseIf (RandomNum == 13)
	Debug.SendAnimationEvent(slaveREF , " ZazAPC056") ;  		HogTieFaceDownLegsSpread
ElseIf (RandomNum == 14)
	Debug.SendAnimationEvent(slaveREF , " ZazAPC057") ;  		FrogTieFaceDownStruggle
ElseIf (RandomNum >= 15)
	Debug.SendAnimationEvent(slaveREF , " ZazAPC015") ;  		HandsBehindLieHogtieFaceDown					
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_32
Function Fragment_32()
;BEGIN CODE
snp._SDUIP_phase = -1
; Debug.Notification("[punishment] phase =" + snp._SDUIP_phase)

Debug.Notification("Now get out of my sight slave. [punishment end]")
Actor female = _SDRAP_female.GetReference() as Actor

_SDGVP_trust_hands.SetValue(0)
_SDGVP_trust_feet.SetValue(0)

;funct.toggleActorClothing ( male, False )
; funct.toggleActorClothing ( female, False )

Game.EnablePlayerControls( abMovement = True )
Game.SetPlayerAIDriven( False )

Game.FadeOutGame(True, True, 3.0, 2.0)
Utility.Wait(2)
Game.FadeOutGame(False, True, 15.0, 5.0)

_SDGVP_snp_busy.SetValue(-1)
; Self.GetowningQuest().Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_79
Function Fragment_79()
;BEGIN CODE
Game.SetPlayerAIDriven()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_snp Property snp Auto
_SDQS_functions Property funct  Auto
_SDQS_enslavement Property enslave  Auto  

Quest Property _SDQP_enslavement  Auto  

ReferenceAlias Property _SDRAP_female  Auto  
ReferenceAlias Property _SDRAP_male  Auto  
ReferenceAlias Property _SDRAP_marker  Auto  
ReferenceAlias Property _SDRAP_bindings  Auto    

FormList Property _SDFLP_punish_items  Auto
SPELL Property _SDSP_punish  Auto  

imageSpaceModifier property _SDISM_fadeout auto ; 4 sec
imageSpaceModifier property _SDISM_blackout auto ; 10 sec
imageSpaceModifier property _SDISM_fadein auto ; 2 sec

GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_config_verboseMerits  Auto

Faction Property _SDFP_slaverCrimeFaction  Auto 
SexLabFramework property SexLab auto

GlobalVariable Property _SDGVP_snp_busy  Auto  

GlobalVariable Property _SDGVP_trust_hands  Auto  

GlobalVariable Property _SDGVP_trust_feet  Auto  
