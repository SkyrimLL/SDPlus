;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 26
Scriptname _sdqf_sprigganslave_01 Extends Quest Hidden

;BEGIN ALIAS PROPERTY _SDQA_host
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDQA_host Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDQA_spriggan
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDQA_spriggan Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDQA_hostarmor_unpb_b
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDQA_hostarmor_unpb_b Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDQA_hostarmor_unpb
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDQA_hostarmor_unpb Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDQA_hostarmor_cbbe
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDQA_hostarmor_cbbe Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDQA_sprigganbook
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDQA_sprigganbook Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDQA_hostarmor
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDQA_hostarmor Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDQA_safetysprigganmarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDQA_safetysprigganmarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDQA_hostarmor_cbbe_b
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDQA_hostarmor_cbbe_b Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDLA_book_location
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias__SDLA_book_location Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDQA_spriggangrove
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias__SDQA_spriggangrove Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDQA_sprigganmarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDQA_sprigganmarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDQA_companion
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDQA_companion Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
( Alias__SDQA_spriggan.GetReference() as ObjectReference ).MoveTo( Alias__SDQA_sprigganmarker.GetReference() as ObjectReference )
SetObjectiveDisplayed( 10 )
_SD_spriggan_punishment.SetValue(1)

If ( _SDGVP_spriggan_secret.GetValueInt() == 1 )
	 Self.SetStage( 60 )
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN CODE
; stage 90
oHost = Alias__SDQA_host.GetReference() as ObjectReference

_SD_host_flare.RemoteCast( oHost, aHost, aHost )
Utility.Wait(0.5)

fctFactions.resetAllyToActor( oHost as Actor, _SDFLP_forced_allied )
CompleteAllObjectives()

Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_21
Function Fragment_21()
;BEGIN CODE
Actor kSlave = Game.getPlayer()

_SDGVP_sprigganEnslaved.SetValue(1)
StorageUtil.SetIntValue(Game.GetPlayer(), "_SD_iSprigganInfected", 1)
StorageUtil.SetIntValue(Game.GetPlayer(),"_SD_iDisableDreamworldOnSleep", 1)

SendModEvent("SDSprigganStart")

; Suspend Deviously Helpless attacks.
SendModEvent("dhlp-Suspend")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_24
Function Fragment_24()
;BEGIN CODE
; stage 70

; Fix end sequence with Matron
ObjectReference aHuskLocation = Alias__SDQA_safetysprigganmarker.GetReference() 

Game.GetPlayer().MoveTo( aHuskLocation  )
Game.ForceThirdPerson()
Utility.Wait(1.0)

aHost = Alias__SDQA_host.GetReference() as Actor
aSpriggan = Alias__SDQA_spriggan.GetReference() as Actor
oHost = Alias__SDQA_host.GetReference() as ObjectReference
oSpriggan = Alias__SDQA_spriggan.GetReference() as ObjectReference
oHostArmor = Alias__SDQA_hostarmor.GetReference() as ObjectReference

_SDS_spriggan_bloom.RemoteCast( oHost, aHost, aHost )
_SD_sprigganHusk.moveto( oHost )
Pacify.RemoteCast( oHost, aHost, aHost )

; Game.GetPlayer().AddToFaction(SprigganFaction)
; _SDSP_cum.RemoteCast( oHost, aHost, aHost )

; Debug.MessageBox("The spriggan roots crawl away from your body and into the ground around the fertile husk...")
; aHost.RemoveItem( oHostArmor.GetBaseObject(), aHost.GetItemCount( oHostArmor.GetBaseObject() )  )

	; fctOutfit.setDeviousOutfitID ( iOutfit = -1, sMessage = "The spriggan roots crawl away from your body and into the ground around the fertile husk, leaving residues on your hands and feet...")
		
	if fctOutfit.isDeviceEquippedKeyword( Game.GetPlayer(),  "_SD_DeviousSpriggan", "Belt"  )
		fctOutfit.setDeviousOutfitBelt (  iDevOutfit = 7, bDevEquip = False, sDevMessage = "The spriggan roots crawl away from your body and into the ground around the fertile husk, leaving residues on your hands and feet...")	
	EndIf

	if fctOutfit.isDeviceEquippedKeyword( Game.GetPlayer(),  "_SD_DeviousSpriggan", "Blindfold"  )
		fctOutfit.setDeviousOutfitBlindfold ( iDevOutfit = 7,  bDevEquip = False, sDevMessage = "")	
	Endif

; _SD_sprigganHusk.Enable()

; aSpriggan.SetRestrained(false)
; oSpriggan.Enable()
If ( aSpriggan.IsDead() )
;	aSpriggan.Resurrect()
EndIf

fctConstraints.actorCombatShutdown( aSpriggan )
fctConstraints.actorCombatShutdown( aHost )

; _SDSP_cum.RemoteCast( oHost, aHost, aHost )

; _SDKP_sex.SendStoryEvent( akRef1 = oSpriggan, akRef2 = oHost, aiValue1 = 0, aiValue2 = Utility.RandomInt( 0, 4 ) )

	If  (SexLab.ValidateActor( SexLab.PlayerRef ) > 0)
		; HACK: select rough sexlab animations 
		; sslBaseAnimation[] animations = SexLab.GetAnimationsByTag(1, "Masturbation", "Female")

		; HACK: get actors for sexlab
		; actor[] sexActors = new actor[1]
		; sexActors[0] = SexLab.PlayerRef

		; HACK: start sexlab animation
		; SexLab.StartSex(sexActors, animations)


		sslThreadModel Thread = SexLab.NewThread()
		Thread.AddActor(SexLab.PlayerRef, true) ; // IsVictim = true
		Thread.SetAnimations(SexLab.GetAnimationsByTags(1, "Solo,F","Estrus,Dwemer"))
		Thread.StartThread()
	EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_19
Function Fragment_19()
;BEGIN CODE
SetObjectiveDisplayed( 60 )
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_18
Function Fragment_18()
;BEGIN AUTOCAST TYPE _sdqs_sprigganslave
Quest __temp = self as Quest
_sdqs_sprigganslave kmyQuest = __temp as _sdqs_sprigganslave
;END AUTOCAST
;BEGIN CODE
; stage 100
Alias__SDQA_spriggan.Clear()
Alias__SDQA_host.Clear()
Alias__SDQA_spriggangrove.Clear()
Alias__SDQA_hostarmor.Clear()
Alias__SDQA_sprigganmarker.Clear()

kmyQuest.bQuestActive = False

Game.GetPlayer().RemoveFromFaction(SprigganFaction)
Game.GetPlayer().RemoveFromFaction(GiantFaction)
StorageUtil.SetIntValue(Game.GetPlayer(),"_SD_iDisableDreamworldOnSleep", 0)

fctOutfit.setDeviousOutfitArms ( iDevOutfit = 7, bDevEquip = False, sDevMessage = "")	
fctOutfit.setDeviousOutfitLegs ( iDevOutfit = 7,  bDevEquip = False, sDevMessage = "")	

SendModEvent("SDSprigganStop")

_SDGVP_sprigganEnslaved.SetValue(0)
_SD_spriggan_punishment.SetValue(0)
StorageUtil.SetIntValue(Game.GetPlayer(), "_SD_iSprigganInfected", 0)

If ( kmyQuest.IsObjectiveDisplayed(10) )
	kmyQuest.SetObjectiveDisplayed(10, False)
EndIf

; Resume Deviously Helpless attacks.
SendModEvent("dhlp-Resume")

_SDGVP_sprigganenslaved.SetValue(0)
UnregisterForUpdate()

SetObjectiveDisplayed(20, False)
SetObjectiveDisplayed(30, False)
SetObjectiveDisplayed(60, False)
Reset()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
; stage 70

; Fix end sequence with Matron

aHost = Alias__SDQA_host.GetReference() as Actor
aSpriggan = Alias__SDQA_spriggan.GetReference() as Actor
oHost = Alias__SDQA_host.GetReference() as ObjectReference
oSpriggan = Alias__SDQA_spriggan.GetReference() as ObjectReference
oHostArmor = Alias__SDQA_hostarmor.GetReference() as ObjectReference

_SDS_spriggan_bloom.RemoteCast( oHost, aHost, aHost )
_SD_sprigganHusk.moveto( oHost )
Pacify.RemoteCast( oHost, aHost, aHost )

; Game.GetPlayer().AddToFaction(SprigganFaction)
; _SDSP_cum.RemoteCast( oHost, aHost, aHost )

; Debug.MessageBox("The spriggan roots crawl away from your body and into the ground around the fertile husk...")
; aHost.RemoveItem( oHostArmor.GetBaseObject(), aHost.GetItemCount( oHostArmor.GetBaseObject() )  )

	; fctOutfit.setDeviousOutfitID ( iOutfit = -1, sMessage = "The spriggan roots crawl away from your body and into the ground around the fertile husk, leaving residues on your hands and feet...")
		
	if fctOutfit.isDeviceEquippedKeyword( Game.GetPlayer(),  "_SD_DeviousSpriggan", "Belt"  )
		fctOutfit.setDeviousOutfitBelt (  iDevOutfit = 7, bDevEquip = False, sDevMessage = "The spriggan roots crawl away from your body and into the ground around the fertile husk, leaving residues on your hands and feet...")	
	EndIf

	if fctOutfit.isDeviceEquippedKeyword( Game.GetPlayer(),  "_SD_DeviousSpriggan", "Blindfold"  )
		fctOutfit.setDeviousOutfitBlindfold ( iDevOutfit = 7,  bDevEquip = False, sDevMessage = "")	
	Endif

; _SD_sprigganHusk.Enable()

; aSpriggan.SetRestrained(false)
; oSpriggan.Enable()
If ( aSpriggan.IsDead() )
;	aSpriggan.Resurrect()
EndIf

fctConstraints.actorCombatShutdown( aSpriggan )
fctConstraints.actorCombatShutdown( aHost )

; _SDSP_cum.RemoteCast( oHost, aHost, aHost )

; _SDKP_sex.SendStoryEvent( akRef1 = oSpriggan, akRef2 = oHost, aiValue1 = 0, aiValue2 = Utility.RandomInt( 0, 4 ) )

	If  (SexLab.ValidateActor( SexLab.PlayerRef ) > 0)
		; HACK: select rough sexlab animations 
		; sslBaseAnimation[] animations = SexLab.GetAnimationsByTag(1, "Masturbation", "Female")

		; HACK: get actors for sexlab
		; actor[] sexActors = new actor[1]
		; sexActors[0] = SexLab.PlayerRef

		; HACK: start sexlab animation
		; SexLab.StartSex(sexActors, animations)


		sslThreadModel Thread = SexLab.NewThread()
		Thread.AddActor(SexLab.PlayerRef, true) ; // IsVictim = true
		Thread.SetAnimations(SexLab.GetAnimationsByTags(1, "Solo,F","Estrus,Dwemer"))
		Thread.StartThread()
	EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN CODE
; stage 80
aHost = Alias__SDQA_host.GetReference() as Actor
oHost = Alias__SDQA_host.GetReference() as ObjectReference
oSpriggan = Alias__SDQA_spriggan.GetReference() as ObjectReference

oSpriggan.Disable()
; oSpriggan.placeAtMe( _SDABP_sprigganmatron )
oSpriggan.Delete()

_SDSP_cum.RemoteCast( oHost, aHost, aHost )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_snp Property snp Auto
_SDQS_functions Property funct  Auto
_SDQS_fcts_constraints Property fctConstraints  Auto
_SDQS_fcts_inventory Property fctInventory  Auto
_SDQS_fcts_factions Property fctFactions  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

Keyword Property _SDKP_sex  Auto  
ActorBase Property _SDABP_sprigganmatron  Auto
Spell Property _SDSP_cum  Auto
SPELL Property _SDSP_summon  Auto  
Keyword Property _SDKP_spriggan  Auto  
FormList Property _SDFLP_forced_allied  Auto  
GlobalVariable Property _SDGVP_spriggan_secret  Auto  
GlobalVariable Property _SDGVP_enslaved  Auto

Actor aHost
Actor aSpriggan
ObjectReference oHost
ObjectReference oSpriggan
ObjectReference oHostArmor

ObjectReference Property _SD_sprigganHusk  Auto  

SexLabFramework Property SexLab  Auto  

SPELL Property _SD_host_flare  Auto  

GlobalVariable Property _SDGVP_sprigganEnslaved  Auto  

Faction Property SprigganFaction  Auto  

GlobalVariable Property _SD_spriggan_punishment  Auto  

SPELL Property _SDS_spriggan_bloom  Auto  

Faction  Property GiantFaction  Auto  

ObjectReference Property _SD_SprigganSafetyLocationREF  Auto  

SPELL Property Pacify  Auto  
