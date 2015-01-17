;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 147
Scriptname _sdsf_snp_07 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_89
Function Fragment_89()
;BEGIN CODE
ObjectReference slaveREF = _SDRAP_female.GetReference()
; Debug.SendAnimationEvent(slaveREF , "ZazAPC056")
	
; Debug.SendAnimationEvent(slaveREF , "IdleForceDefaultState")


If ( _SDRAP_male )
	whore.addToQueue( _SDRAP_male.GetReference() as ObjectReference )
EndIf
If ( _SDRAP_bystander_01 )
	whore.addToQueue( _SDRAP_bystander_01.GetReference() as ObjectReference )
EndIf
If ( _SDRAP_bystander_02)
	whore.addToQueue( _SDRAP_bystander_02.GetReference() as ObjectReference )
EndIf
If ( _SDRAP_bystander_03 )
	whore.addToQueue( _SDRAP_bystander_03.GetReference() as ObjectReference )
EndIf
If ( _SDRAP_bystander_04 )
	whore.addToQueue( _SDRAP_bystander_04.GetReference() as ObjectReference )
EndIf
If ( _SDRAP_bystander_05 )
	whore.addToQueue( _SDRAP_bystander_05.GetReference() as ObjectReference )
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Actor female = _SDRAP_female.GetReference() as Actor

snp._SDUIP_phase = 0
_SDGVP_snp_busy.SetValue(7)

; Debug.Notification("[dance] phase =" + snp._SDUIP_phase)

if (StorageUtil.GetIntValue(female, "_SD_iEnslaved")==1)
	Debug.Notification("Your owner forces you to dance...")
Else
	Debug.Notification("You slowly start to dance...")
EndIf

		Debug.SendAnimationEvent(female, "Unequip")
		Debug.SendAnimationEvent(female, "UnequipNoAnim")

		; Drop current weapon 
		if(female.IsWeaponDrawn())
			female.SheatheWeapon()
			Utility.Wait(2.0)
		endif
 

Game.ForceThirdPerson()
; libs.SetAnimating(Game.GetPlayer(), true)


if (fctOutfit.isArmbinderEquipped( female ))
	fctOutfit.setDeviousOutfitArms ( iDevOutfit =-1, bDevEquip = False, sDevMessage = "")
	StorageUtil.SetIntValue(Game.getPlayer() , "_SD_iHandsFreeSex", 1)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_71
Function Fragment_71()
;BEGIN CODE
snp._SDUIP_phase = 3
; Debug.Notification("[dance] phase =" + snp._SDUIP_phase)
; Debug.Notification("The urge is irresistible [dance sex]")
Utility.wait(2)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_70
Function Fragment_70()
;BEGIN CODE
snp._SDUIP_phase = 2
; Debug.Notification("[dance] phase =" + snp._SDUIP_phase)

ObjectReference slaveREF = _SDRAP_female.GetReference()
; Debug.Notification("[dance] testing idle  SDFNISc500"  ) 
 	Debug.SendAnimationEvent(slaveREF , "SDFNISc500")

Int RandomNum = Utility.RandomInt(0,2)

RandomNum = -1    ; Disabled for now.Testing if action idles are working again

If (RandomNum == 0)
	Debug.SendAnimationEvent(slaveREF , "SDFNISc500") ; 		 			
ElseIf (RandomNum == 1)
	Debug.SendAnimationEvent(slaveREF , " SDFNISc502") ;  		 											
ElseIf (RandomNum == 2)
	Debug.SendAnimationEvent(slaveREF , " SDFNISc504") ;  		 												
EndIf

; utility.wait(10)

; Debug.SendAnimationEvent(slaveREF , "IdleForceDefaultState")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_95
Function Fragment_95()
;BEGIN CODE
snp._SDUIP_phase = 4
; Debug.Notification("[dance] phase =" + snp._SDUIP_phase)

ObjectReference slaveREF = _SDRAP_female.GetReference()
;Debug.SendAnimationEvent(slaveREF , "IdleSilentBow")
slaveREF.PlayAnimation("IdleSilentBow");Inte
Utility.Wait(0.5)
; Debug.SendAnimationEvent(slaveREF , "IdleForceDefaultState")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_69
Function Fragment_69()
;BEGIN CODE
snp._SDUIP_phase = 1
; Debug.Notification("[dance] phase =" + snp._SDUIP_phase)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Actor kMaster = StorageUtil.GetFormValue( Game.getPlayer(), "_SD_CurrentOwner") as Actor
Actor male = _SDRAP_male.GetReference() as Actor
Actor female = _SDRAP_female.GetReference() as Actor

snp._SDUIP_phase = -1
; Debug.Notification("[dance] phase =" + snp._SDUIP_phase)
; Debug.Notification("The dance leaves you breathless. ")

_SDGVP_snp_busy.SetValue(-1)
; Self.GetowningQuest().Stop()
; libs.SetAnimating(Game.GetPlayer(), false)
; enslave.AddArmbinder(Game.GetPlayer(), True)
; Game.EnablePlayerControls( abMovement = True )
; Game.SetPlayerAIDriven( False )

if (StorageUtil.GetIntValue(female, "_SD_iEnslaved")==1)

	fctSlavery.UpdateSlaveStatus( Game.GetPlayer(), "_SD_iPunishmentCountToday", modValue = 1)
	fctSlavery.UpdateSlaveStatus( Game.GetPlayer(), "_SD_iPunishmentCountTotal", modValue = 1)
	fctSlavery.UpdateSlaveStatus( Game.GetPlayer(), "_SD_iGoalPunishment", modValue = 1)
	fctSlavery.UpdateSlaveStatus( Game.GetPlayer(), "_SD_iSlaveryExposure", modValue = 1)

 
	If (Utility.RandomInt(0,100) > 90) && (male != kMaster )
		; Keep hands free by accident
	ElseIf (!fctOutfit.isArmbinderEquipped(female)) && (StorageUtil.GetIntValue(female, "_SD_iHandsFree") == 0)
		fctOutfit.setDeviousOutfitArms ( iDevOutfit =-1, bDevEquip = True, sDevMessage = "")
	EndIf
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN CODE
snp._SDUIP_phase = 5
; Debug.Notification("[dance] phase =" + snp._SDUIP_phase)
Debug.Notification("Wait while they take their turns on you.")

Game.EnablePlayerControls( abMovement = True )
Game.SetPlayerAIDriven( False )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
Import Utility

_SDQS_snp Property snp Auto
_SDQS_functions Property funct  Auto
_SDQS_whore Property whore  Auto  

ReferenceAlias Property _SDRAP_male  Auto  
ReferenceAlias Property _SDRAP_female  Auto  
ReferenceAlias Property _SDRAP_bystander_01  Auto  
ReferenceAlias Property _SDRAP_bystander_02  Auto  
ReferenceAlias Property _SDRAP_bystander_03  Auto  
ReferenceAlias Property _SDRAP_bystander_04  Auto  
ReferenceAlias Property _SDRAP_bystander_05  Auto  

Keyword Property _SDKP_sex  Auto  
GlobalVariable Property _SDGVP_positions  Auto

ReferenceAlias Property _SDRAP_marker  Auto  

SexLabFramework Property SexLab  Auto  

GlobalVariable Property _SDGVP_snp_busy  Auto  
zadLibs Property libs Auto
_SDQS_fcts_slavery Property fctSlavery  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto
