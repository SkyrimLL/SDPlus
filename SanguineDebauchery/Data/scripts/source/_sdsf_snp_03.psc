;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 115
Scriptname _sdsf_snp_03 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_32
Function Fragment_32()
;BEGIN CODE
snp._SDUIP_phase = -1
; Debug.Notification("[punishment] phase =" + snp._SDUIP_phase)

Debug.Notification("The worst is over... for now..")
Actor kMaster = StorageUtil.GetFormValue( Game.getPlayer(), "_SD_CurrentOwner") as Actor
Actor male = _SDRAP_male.GetReference() as Actor
Actor female = _SDRAP_female.GetReference() as Actor

_SDGVP_trust_hands.SetValue(0)
_SDGVP_trust_feet.SetValue(0)

; Game.FadeOutGame(True, True, 3.0, 2.0)

;funct.toggleActorClothing ( male, False )
; funct.toggleActorClothing ( female, False )

Game.EnablePlayerControls( abMovement = True )
Game.SetPlayerAIDriven( False )

		if(female.IsWeaponDrawn())
			female.SheatheWeapon()
			Utility.Wait(2.0)
		endif

 Debug.SendAnimationEvent(female , "IdleForceDefaultState")

_SDGVP_snp_busy.SetValue(-1)
; libs.SetAnimating(Game.GetPlayer(), true)


; Self.GetowningQuest().Stop()
fctSlavery.UpdateSlaveStatus( Game.GetPlayer(), "_SD_iPunishmentCountToday", modValue = 1)
fctSlavery.UpdateSlaveStatus( Game.GetPlayer(), "_SD_iPunishmentCountTotal", modValue = 1)
fctSlavery.UpdateSlaveStatus( Game.GetPlayer(), "_SD_iGoalPunishment", modValue = 1)
fctSlavery.UpdateSlaveStatus( Game.GetPlayer(), "_SD_iSlaveryExposure", modValue = 1)

Utility.Wait(2)
; Game.FadeOutGame(False, True, 15.0, 5.0)

	If (Utility.RandomInt(0,100) > 90) && (male != kMaster )
		; Keep hands free by accident
		If (Utility.RandomInt(0,100) > 70) 
			female.SendModEvent("da_ForceBleedout")
		EndIf

	ElseIf (!fctOutfit.isArmbinderEquipped(female)) && (StorageUtil.GetIntValue(female, "_SD_iHandsFree") == 0)
		fctOutfit.setMasterGearByRace( male, female )
		fctOutfit.equipDeviceByString( sDeviceString = "Armbinders" )
	EndIf


; female.SendModEvent("da_ForceBlackout")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_95
Function Fragment_95()
;BEGIN CODE
snp._SDUIP_phase = 5
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_93
Function Fragment_93()
;BEGIN CODE
snp._SDUIP_phase = 4
Debug.Notification("You are left to ponder your fate...")

Game.DisablePlayerControls( abMovement = true )
Game.SetPlayerAIDriven()

Utility.Wait(1.0)


fctSlavery.PlayPunishmentIdle(  )


Utility.Wait(1.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_68
Function Fragment_68()
;BEGIN CODE
snp._SDUIP_phase = 1
; Debug.Notification("[punishment] phase =" + snp._SDUIP_phase)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
snp._SDUIP_phase = 0
_SDGVP_snp_busy.SetValue(3)
; libs.SetAnimating(Game.GetPlayer(),true)

; Game.FadeOutGame(True, True, 3.0, 2.0)

; Debug.Notification("[punishment] phase =" + snp._SDUIP_phase)
Debug.Notification("You brace for the coming punishment...")

Actor female = _SDRAP_female.GetReference() as Actor
Actor male = _SDRAP_male.GetReference() as Actor
ObjectReference marker = _SDRAP_marker.GetReference() as ObjectReference

marker.MoveTo( female, 128 * Math.Sin( female.GetAngleZ() ), 128 * Math.Cos( female.GetAngleZ() ), female.GetHeight() )

if (fctOutfit.isArmbinderEquipped( female ))  
	fctOutfit.clearDeviceByString( sDeviceString = "Armbinders" )
	StorageUtil.SetIntValue(female , "_SD_iHandsFreeSex", 1)
EndIf

Utility.Wait(1)

Game.DisablePlayerControls( abMovement = true )
Game.SetPlayerAIDriven()

; Game.FadeOutGame(False, True, 15.0, 5.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_18
Function Fragment_18(ReferenceAlias akAlias)
;BEGIN CODE
; Game.FadeOutGame(True, True, 3.0, 2.0)
; Utility.Wait(2)
; Actor female = _SDRAP_female.GetReference() as Actor
; Debug.SendAnimationEvent(female, "IdleForceDefaultState")
;female.PushActorAway(female, 0.1)
; Game.FadeOutGame(False, True, 15.0, 5.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_94
Function Fragment_94()
;BEGIN CODE
snp._SDUIP_phase = 3
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_87
Function Fragment_87()
;BEGIN CODE
snp._SDUIP_phase = 2
; Debug.Notification("[punishment] phase =" + snp._SDUIP_phase)

fctSlavery.PlayPunishmentIdle(  )

Utility.Wait(4.0)


; Game.DisablePlayerControls( abMovement = true )
; Game.SetPlayerAIDriven( False )
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
zadLibs Property libs Auto
_SDQS_fcts_slavery Property fctSlavery  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto
