;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 51
Scriptname _sdqfs_enslavement_01 Extends Quest Hidden

;BEGIN ALIAS PROPERTY _SDRA_cage_door_3
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_cage_door_3 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_slave_rags_cbbe
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_slave_rags_cbbe Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_slave
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_slave Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_companion_1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_companion_1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_ally_1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_ally_1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_slave_rags_unpb
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_slave_rags_unpb Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_companion_0
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_companion_0 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDLA_bounty_castle
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias__SDLA_bounty_castle Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_cage_door_1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_cage_door_1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_ally_0
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_ally_0 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_hostile_2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_hostile_2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_shackles
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_shackles Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_cage_door
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_cage_door Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_slave_rags_norm
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_slave_rags_norm Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_playerStorage
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_playerStorage Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_companion_2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_companion_2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_slave_rags
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_slave_rags Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_hostile_1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_hostile_1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_key
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_key Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_crop
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_crop Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_ally_2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_ally_2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_cage_marker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_cage_marker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_ally_3
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_ally_3 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDLA_capture_cell
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias__SDLA_capture_cell Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_master
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_master Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_cage
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_cage Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_hostile_4
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_hostile_4 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_bindings
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_bindings Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_ally_4
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_ally_4 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_companion_3
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_companion_3 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_ally_5
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_ally_5 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_hostile_3
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_hostile_3 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_cage_door_4
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_cage_door_4 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_cage_door_2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_cage_door_2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_collar
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_collar Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN AUTOCAST TYPE _sdqs_enslavement
Quest __temp = self as Quest
_sdqs_enslavement kmyQuest = __temp as _sdqs_enslavement
;END AUTOCAST
;BEGIN CODE
; stage 100
questShutdown()
removeSlaveItems()

Actor kMaster = Alias__SDRA_master.GetReference() as Actor
Actor kSlave = Game.GetPlayer()


Utility.Wait( 0.5 )

If ( _SDGVP_state_joined.GetValueInt() == 1 )
	; removeSlaveItems()
	_SDGVP_state_joined.SetValue( 0 )

	funct.transferFormListContents( _SDFLP_forced_allied, _SDFLP_forced_joined )
	Debug.Notification( "Joined faction count: " + _SDFLP_forced_joined.GetSize() )
EndIf

If( kSlave.IsInFaction( _SDFP_mistwatch ) )
	kSlave.SetFactionRank( _SDFP_mistwatch, -2 )
	kSlave.RemoveFromFaction( _SDFP_mistwatch )
EndIf

fctFactions.resetAllyToActor( kSlave, _SDFLP_forced_allied )
Debug.Notification( "Enslaved faction count: " + _SDFLP_forced_allied.GetSize() )

SetObjectiveCompleted( 100 )
kmyQuest.bQuestActive = False

fctSlavery.StopSlavery( kMaster, kSlave)

_SDFLP_trade_items.Revert()

SetObjectiveDisplayed(0, False)
SetObjectiveDisplayed(1, False)
SetObjectiveDisplayed(2, False)
SetObjectiveDisplayed(3, False)
SetObjectiveDisplayed(90, False)
SetObjectiveDisplayed(100, False)

SendModEvent("SDEnslavedStop") 

; Resume Deviously Helpless attacks.
SendModEvent("dhlp-Resume")

Reset()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_48
Function Fragment_48()
;BEGIN AUTOCAST TYPE _sdqs_enslavement
Quest __temp = self as Quest
_sdqs_enslavement kmyQuest = __temp as _sdqs_enslavement
;END AUTOCAST
;BEGIN CODE
; stage 100
questShutdown()
; removeSlaveItems()

Actor kMaster = Alias__SDRA_master.GetReference() as Actor
Actor kSlave = Game.GetPlayer()

Utility.Wait( 0.5 )

If ( _SDGVP_state_joined.GetValueInt() == 1 )
	_SDGVP_state_joined.SetValue( 0 )
               removeSlaveItems()

	funct.transferFormListContents( _SDFLP_forced_allied, _SDFLP_forced_joined )
	Debug.Notification( "Joined faction count: " + _SDFLP_forced_joined.GetSize() )
EndIf

fctFactions.resetAllyToActor( kSlave , _SDFLP_forced_allied )
Debug.Notification( "Enslaved faction count: " + _SDFLP_forced_allied.GetSize() )

SetObjectiveCompleted( 100 )
kmyQuest.bQuestActive = False
fctSlavery.StopSlavery( kMaster, kSlave)

_SDFLP_trade_items.Revert()

SetObjectiveDisplayed(0, False)
SetObjectiveDisplayed(1, False)
SetObjectiveDisplayed(2, False)
SetObjectiveDisplayed(3, False)
SetObjectiveDisplayed(90, False)
SetObjectiveDisplayed(100, False)

SendModEvent("SDEnslavedStop") 

; Resume Deviously Helpless attacks.
SendModEvent("dhlp-Resume")

Reset()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN CODE
Actor kMaster = Alias__SDRA_master.GetReference() as Actor
Actor kSlave = Game.GetPlayer()

SendModEvent("SDEnslavedStart") 

; Suspend Deviously Helpless attacks.
SendModEvent("dhlp-Suspend")

; fctSlavery.StartSlavery( kMaster, kSlave)

; If Game.IsFastTravelEnabled()
;	_SDGVP_state_fasttravel.SetValue( 1 )
;	Game.EnableFastTravel( False )
; EndIf

;master.AllowPCDialogue( True )

SetStage( 10 )
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_36
Function Fragment_36()
;BEGIN AUTOCAST TYPE _sdqs_enslavement
Quest __temp = self as Quest
_sdqs_enslavement kmyQuest = __temp as _sdqs_enslavement
;END AUTOCAST
;BEGIN CODE
; stage 90
questShutdown()
removeSlaveItems()

kmyQuest.bQuestActive = False
Utility.WaitGameTime( 1.0 )
Self.Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_38
Function Fragment_38()
;BEGIN CODE
_SDKP_bounty.SendStoryEvent(akRef1 = Alias__SDRA_master.GetReference() as ObjectReference, akRef2 = Alias__SDRA_slave.GetReference() as ObjectReference, aiValue1 = 0)

If ( _SDGVP_config[0].GetValue() )
;	 Alias__SDRA_slave.GetActorReference().GetActorBase().SetEssential( False )
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_40
Function Fragment_40()
;BEGIN CODE
;_SDKP_sex.SendStoryEvent( akRef1 = Alias__SDRA_master.GetReference() as ObjectReference, akRef2 = Alias__SDRA_slave.GetReference() as ObjectReference, aiValue1 = 0, aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValueInt() ) )

If ( _SDGVP_config[0].GetValue() )
;	 Alias__SDRA_slave.GetActorReference().GetActorBase().SetEssential( False )
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_29
Function Fragment_29()
;BEGIN CODE
_SDKP_thugs.SendStoryEvent(akRef1 = Alias__SDRA_master.GetReference() as ObjectReference, akRef2 = Alias__SDRA_slave.GetReference() as ObjectReference, aiValue1 = 0)

If ( _SDGVP_config[0].GetValue() )
;	 Alias__SDRA_slave.GetActorReference().GetActorBase().SetEssential( False )
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_50
Function Fragment_50()
;BEGIN AUTOCAST TYPE _sdqs_enslavement
Quest __temp = self as Quest
_sdqs_enslavement kmyQuest = __temp as _sdqs_enslavement
;END AUTOCAST
;BEGIN CODE
; stage 90
questShutdown()

kmyQuest.bQuestActive = False
Utility.WaitGameTime( 1.0 )
Self.Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_43
Function Fragment_43()
;BEGIN AUTOCAST TYPE _sdqs_enslavement
Quest __temp = self as Quest
_sdqs_enslavement kmyQuest = __temp as _sdqs_enslavement
;END AUTOCAST
;BEGIN CODE
; stage 100
questShutdown()

Actor kMaster = Alias__SDRA_master.GetReference() as Actor
Actor kSlave = Game.GetPlayer()

Utility.Wait( 0.5 )

If ( _SDGVP_state_joined.GetValueInt() == 1 )
	removeSlaveItems()
	_SDGVP_state_joined.SetValue( 0 )

	funct.transferFormListContents( _SDFLP_forced_allied, _SDFLP_forced_joined )
	Debug.Notification( "Joined faction count: " + _SDFLP_forced_joined.GetSize() )
EndIf

fctFactions.resetAllyToActor( kSlave , _SDFLP_forced_allied )
Debug.Notification( "Enslaved faction count: " + _SDFLP_forced_allied.GetSize() )


SetObjectiveCompleted( 100 )
kmyQuest.bQuestActive = False
fctSlavery.StopSlavery( kMaster, kSlave)

_SDFLP_trade_items.Revert()

SetObjectiveDisplayed(0, False)
SetObjectiveDisplayed(1, False)
SetObjectiveDisplayed(2, False)
SetObjectiveDisplayed(3, False)
SetObjectiveDisplayed(90, False)
SetObjectiveDisplayed(100, False)

SendModEvent("SDEnslavedStop") 

; Resume Deviously Helpless attacks.
SendModEvent("dhlp-Resume")

Reset()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_39
Function Fragment_39()
;BEGIN CODE
;_SDKP_sex.SendStoryEvent( akRef1 = Alias__SDRA_master.GetReference() as ObjectReference, akRef2 = Alias__SDRA_slave.GetReference() as ObjectReference, aiValue1 = 0, aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValueInt() ) )

If ( _SDGVP_config[0].GetValue() )
;	 Alias__SDRA_slave.GetActorReference().GetActorBase().SetEssential( False )
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_functions Property funct  Auto
_SDQS_snp Property snp Auto

Function questShutdown()
	Actor master = Alias__SDRA_master.GetReference() as Actor
	Actor slave = Alias__SDRA_slave.GetReference() as Actor
	
	If _SDGVP_state_fasttravel.GetValueInt() == 1
		Game.EnableFastTravel()
		_SDGVP_state_fasttravel.SetValue( 0 )
	EndIf

	_SDGVP_buyoutEarned.SetValue( 0 )
	_SDKP_trust_hands.SetValue(1)
	_SDKP_trust_feet.SetValue(1)

	
	; kill sub quests
	idx = 0
	While idx < _SDQP_subquests.Length
		_SDQP_subquests[idx].FailAllObjectives()
		_SDQP_subquests[idx].Stop()
		idx += 1
	EndWhile

	idx = 0
	While idx < _SDRAP_companions.Length
		nthActor = _SDRAP_companions[idx].GetReference() as Actor
		If ( nthActor )
			If ( nthActor.GetNoBleedoutRecovery() )
				nthActor.SetNoBleedoutRecovery( False )
			EndIf
			nthActor.EvaluatePackage()
			Debug.SendAnimationEvent( nthActor, "IdleForceDefaultState" )
		EndIf
		idx += 1
	EndWhile
	Debug.SendAnimationEvent( slave, "IdleForceDefaultState" )
EndFunction

Function removeSlaveItems()
	Actor master = Alias__SDRA_master.GetReference() as Actor
	Actor slave = Alias__SDRA_slave.GetReference() as Actor

	; item cleanup
	fctOutfit.setDeviousOutfitArms (  bDevEquip = False, sDevMessage = "You have been released from your chains")
	fctOutfit.setDeviousOutfitLegs (  bDevEquip = False, sDevMessage = "")
	fctOutfit.setDeviousOutfitBlindfold (  bDevEquip = False, sDevMessage = "")
	fctOutfit.setDeviousOutfitGag (  bDevEquip = False, sDevMessage = "")
	Utility.Wait(2.0)

	fctOutfit.setDeviousOutfitPlugAnal (  bDevEquip = False, sDevMessage = "")
	fctOutfit.setDeviousOutfitPlugVaginal (  bDevEquip = False, sDevMessage = "")
	fctOutfit.setDeviousOutfitBelt (  bDevEquip = False, sDevMessage = "")

	_SDKP_state_housekeeping.SetValue(0)
	_SDKP_trust_hands.SetValue(1)
	_SDKP_trust_feet.SetValue(1)

	idx = 0
	While idx < _SDRAP_companions.Length
		nthActor = _SDRAP_companions[idx].GetReference() as Actor
		If ( nthActor )
			funct.removeItemsInList( nthActor, _SDFLP_companion_items )
		EndIf
		idx += 1
	EndWhile
EndFunction

_SDQS_fcts_factions Property fctFactions  Auto
_SDQS_fcts_inventory Property fctInventory  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto
_SDQS_fcts_slavery Property fctSlavery  Auto

ReferenceAlias Property _SDRAP_bindings Auto
ReferenceAlias Property _SDRAP_collar Auto
ReferenceAlias[] Property _SDRAP_companions Auto
ReferenceAlias[] Property _SDRAP_allies Auto

GlobalVariable Property _SDKP_state_housekeeping  Auto  
GlobalVariable Property _SDKP_trust_hands  Auto  
GlobalVariable Property _SDKP_trust_feet  Auto  
GlobalVariable Property _SDGVP_enslaved  Auto  
GlobalVariable Property _SDGVP_buyoutEarned  Auto  
GlobalVariable Property _SDGVP_state_fasttravel  Auto  
GlobalVariable Property _SDGVP_state_joined  Auto  
GlobalVariable[] Property _SDGVP_config  Auto   
GlobalVariable Property _SDGVP_positions  Auto  

Keyword Property _SDKP_thugs  Auto  
Keyword Property _SDKP_bounty  Auto  
Keyword Property _SDKP_vampire  Auto  
Keyword Property _SDKP_sex  Auto  

FormList Property _SDFLP_trade_items  Auto  
FormList Property _SDFLP_punish_items  Auto
FormList Property _SDFLP_sex_items  Auto  
FormList Property _SDFLP_master_items  Auto  
FormList Property _SDFLP_forced_allied  Auto  
FormList Property _SDFLP_forced_joined  Auto  
FormList Property _SDFLP_companion_items  Auto  

Quest[] Property _SDQP_subquests  Auto  

Faction Property _SDFP_mistwatch  Auto  

Actor nthActor
Int itemCount
Int idx


