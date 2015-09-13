Scriptname _SDQS_crime extends Quest  

Import Utility
_SDQS_functions Property funct  Auto
_SDQS_fcts_constraints Property fctConstraints  Auto

GlobalVariable Property _SDGVP_punishments  Auto  
GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_config_verboseMerits  Auto
GlobalVariable Property _SDDVP_buyoutEarned  Auto
GlobalVariable Property _SDGVP_state_playerRagdoll  Auto

ReferenceAlias Property _SDRAP_master  Auto  
ReferenceAlias Property _SDRAP_slave  Auto  

Quest Property _SDQP_enslavement  Auto  

Keyword Property _SDKP_sex  Auto  

Faction Property _SDFP_bountyhunter  Auto

Actor kMaster
Actor kSlave
Float storyStartTime


;akVictim: The ObjectReference that was victimized.
;akCriminal: The ObjectReference that committed the crime.
;akFaction: The Faction that the crime was recorded with.
;aiGoldAmount: The amount of crime gold that was logged.
;aiCrime: The type of crime that the event is for. Will be one of the following:
; -1: None
;  0: Steal
;  1: Pick-pocket
;  2: Trespass
;  3: Attack
;  4: Murder

Event OnStoryCrimeGold(ObjectReference akVictim, ObjectReference akCriminal, Form akFaction, int aiGoldAmount, int aiCrime)
	kMaster = _SDRAP_master.GetReference() as Actor
	kSlave = _SDRAP_slave.GetReference() as Actor

	If ( akFaction && akCriminal as Actor == kSlave )
		fctConstraints.actorCombatShutdown( akVictim as Actor )
		fctConstraints.actorCombatShutdown( kSlave )
		
		storyStartTime = GetCurrentRealTime()
		
		Float iDemerits = Math.Ceiling( aiGoldAmount / 10 ) as Float
		; _SDQP_enslavement.ModObjectiveGlobal( iDemerits, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

		If ( !kMaster.IsInFaction( _SDFP_bountyhunter ) )
			If (aiGoldAmount > _SDDVP_buyoutEarned.GetValue() )
				_SDDVP_buyoutEarned.SetValue(0)
			Else
				_SDDVP_buyoutEarned.Mod( 0 - aiGoldAmount )
			EndIf
			
			Debug.Notification( aiGoldAmount + " deducted from the gold earned for your freedom." )
			( akFaction as Faction ).PlayerPayCrimeGold( True, False )
		EndIf

		; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
		SendModEvent("SDPunishSlave")
		kMaster.SendModEvent("PCSubPunish")
	EndIf
	Stop()
	Reset()
EndEvent
