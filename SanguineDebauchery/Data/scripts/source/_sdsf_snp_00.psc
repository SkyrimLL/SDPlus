;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 159
Scriptname _sdsf_snp_00 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
Actor player = Game.GetPlayer()

Actor male = _SDRAP_male.GetReference() as Actor
Actor female = _SDRAP_female.GetReference() as Actor

Debug.SendAnimationEvent(player , "UnequipNoAnim")
  
_SDSP_sex.Cast( male, female )
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_28
Function Fragment_28()
;BEGIN CODE
snp._SDUIP_phase = -1

; Debug.Notification("You are left on the ground, panting [sex end]")

Actor male = _SDRAP_male.GetReference() as Actor
Actor female = _SDRAP_female.GetReference() as Actor
ObjectReference strapon = _SDRAP_strapon.GetReference() as ObjectReference

;funct.toggleActorClothing ( male, False )
;funct.toggleActorClothing ( female, False )

male.DispelSpell(_SDSP_sex)
female.DispelSpell(_SDSP_sex)

If ( male.HasKeyword( _SDKP_vampire ) )
	female.DoCombatSpellApply( _SDSP_vampire, female )
EndIf

_SDGVP_snp_busy.SetValue(-1)
; Self.GetowningQuest().Stop()
; libs.SetAnimating(Game.GetPlayer(),false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_57
Function Fragment_57()
;BEGIN CODE
snp._SDUIP_phase = 0
_SDGVP_snp_busy.SetValue(0)
; Debug.Notification("Hands grope you as you walk by [" + snp._SDUIP_phase+"]")

; Debug.Notification("Hands grope you as you walk by [sex start]")
; libs.SetAnimating(Game.GetPlayer(), true)


if (fctOutfit.isArmbinderEquipped( Game.getPlayer()  )) && (Utility.RandomInt(0,100) > 30)
	fctOutfit.setDeviceArms ( bDevEquip = False, sDevMessage = "")
	StorageUtil.SetIntValue(Game.getPlayer() , "_SD_iHandsFreeSex", 1)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_81
Function Fragment_81()
;BEGIN CODE
snp._SDUIP_phase = 1
; Debug.Notification("[sex] phase =" + snp._SDUIP_phase)

Actor female = _SDRAP_female.GetReference() as Actor
ObjectReference marker = _SDRAP_marker.GetReference() as ObjectReference

marker.MoveTo( female, -64, 0, 0 )
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_117
Function Fragment_117()
;BEGIN CODE
;Actor male = _SDRAP_male.GetReference() as Actor
;Actor female = _SDRAP_female.GetReference() as Actor

;male.DispelSpell(_SDSP_sex)
;female.DispelSpell(_SDSP_sex)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_29
Function Fragment_29()
;BEGIN CODE
snp._SDUIP_phase = 2
; Debug.Notification("[sex] phase =" + snp._SDUIP_phase)

Actor male = _SDRAP_male.GetReference() as Actor
Actor female = _SDRAP_female.GetReference() as Actor

; snp.updatePos( male, female )

_SDSP_spent.Cast( male, female )
_SDSP_spent.Cast( female, male )

If ( female == Game.GetPlayer() && female.HasKeyword( _SDKP_vampire ) && _SDGVP_config_sexvampire.GetValueInt() == 1 )
;	female.StartVampireFeed( male )
;	PlayerVampireQuest.VampireFeed()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Import Utility

_SDQS_snp Property snp Auto
_SDQS_functions Property funct  Auto
PlayerVampireQuestScript Property PlayerVampireQuest  Auto  

ReferenceAlias Property _SDRAP_male  Auto  
ReferenceAlias Property _SDRAP_female  Auto  
ReferenceAlias Property _SDRAP_sanguine  Auto  
ReferenceAlias Property _SDRAP_sanguine_marker  Auto  
ReferenceAlias Property _SDRAP_marker  Auto  
ReferenceAlias Property _SDRAP_strapon  Auto  

Spell Property _SDSP_sex  Auto
Spell Property _SDSP_spent  Auto  
Spell Property _SDSP_vampire  Auto  

Keyword Property _SDKP_sex  Auto  

GlobalVariable Property _SDGVP_positions  Auto  
GlobalVariable Property _SDGVP_config_sexvampire  Auto  

Keyword Property _SDKP_vampire  Auto  


GlobalVariable Property _SDGVP_snp_busy  Auto  
_SDQS_fcts_slavery Property fctSlavery  Auto
zadlibs Property libs  Auto  
_SDQS_fcts_outfit Property fctOutfit  Auto
