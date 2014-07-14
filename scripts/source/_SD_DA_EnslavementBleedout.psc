Scriptname _SD_DA_EnslavementBleedout extends daymoyl_questtemplate  

 
daymoyl_MonitorVariables 	Property Variables Auto
daymoyl_MonitorUtility 		Property Util 		Auto

Location thisLocation
Actor thisPlayer
Actor thisAggressor

bool	bFirstUpdate

Bool Function QuestCondition(Location akLocation, Actor akAggressor, Actor akFollower)
{Condition that must be satisfied for the quest to fire. Should be overloaded in the childs}
	Debug.Trace("SD DA enslavement bleedout: condition")

	thisLocation = akLocation
	thisPlayer = Game.GetPlayer()
	thisAggressor = akAggressor

	UnregisterForModEvent("da_PlayerRecovered")
	
	if (Utility.RandomInt(0,100)> 80 ) 
		return true
	else
		return false
	endif
EndFunction
 
 
bool Function QuestStart(Location akLocation, Actor akAggressor, Actor akFollower)
	Debug.Trace("SD DA enslavement bleedout: selected")
	; akMaster = akAggressor

	thisLocation = akLocation
	thisPlayer = Game.GetPlayer()
	thisAggressor = akAggressor

	Util.WaitGameHours(Variables.BlackoutTimeLapse * 24.0)
	; if you need to move the player, do it here
	
	bFirstUpdate = true
	RegisterForSingleUpdate(Variables.BlackoutRealTimeLapse)
		; this is necessary because we need to wait a few sec for a nice transition but this function needs to return asap.
	return true
endFunction


Event OnUpdate()
	if(bFirstUpdate)
		RegisterForModEvent("da_PlayerRecovered", "EnslaveAtEndOfBleedout")
		SendModEvent("da_StartRecoverSequence", numArg = 9999.0)		
		RegisterForSingleUpdate(10.0)
		bFirstUpdate = false
	else
		Debug.Trace("SD DA enslavement bleedout failed: Timeout")
		UnregisterForModEvent("da_PlayerRecovered")	
		
		; what to do? do we risk starting enslavement anyway?
	endif
endEvent


Event EnslaveAtEndOfBleedout(string eventName, string strArg, float numArg, Form sender) ; player has finished ragdolling/animating and controls are all back

	Debug.Trace("SD DA enslavement bleedout start")
	UnregisterForUpdate()
	UnregisterForModEvent("da_PlayerRecovered")

	Actor akPlayer = thisPlayer
	Actor akMaster = thisAggressor

	If (akMaster) && (akPlayer)
		If ( !fctFactions.checkIfSpriggan ( akMaster) && fctFactions.actorFactionInList( akMaster, _SDFL_allowed_creature_sex )  && ( fctOutfit.isPunishmentEquipped (akPlayer) && ( !akPlayer.WornHasKeyword( _SDKP_armorCuirass )) ) ) || ( akMaster.IsInFaction( _SDFP_humanoidCreatures ) )  && !fctFactions.actorFactionInList( akMaster, _SDFL_banned_sex )  
				; Debug.Notification( "(Rape attempt)")


			If  (SexLab.ValidateActor( akPlayer) > 0) &&  (SexLab.ValidateActor(akMaster) > 0) && (Utility.RandomInt(0,100)>80)
				_SDSP_spent.Cast(akPlayer, akPlayer)

				SexLab.QuickStart(SexLab.PlayerRef, akMaster, Victim = SexLab.PlayerRef, AnimationTags = "Aggressive")

			EndIf
		ElseIf ( !fctFactions.checkIfSpriggan ( akMaster) && ( akMaster.HasKeyword( _SDKP_actorTypeNPC )) )  
				; Debug.Notification( "(Rape attempt)")

			If  (SexLab.ValidateActor( akPlayer) > 0) &&  (SexLab.ValidateActor(akMaster) > 0) && (Utility.RandomInt(0,100)>80)
				_SDSP_spent.Cast(akPlayer, akPlayer)

				SexLab.QuickStart(SexLab.PlayerRef, akMaster, Victim = SexLab.PlayerRef, AnimationTags = "Aggressive")

			EndIf
		; ElseIf (Utility.RandomInt(0,100)<= ((_SDGVP_health_threshold.GetValue() as Int) / 10) ) && ( (akMaster.HasKeyword( _SDKP_actorTypeNPC ) || (akMaster.GetRace() == falmerRace)) && funct.checkGenderRestriction( akMaster, akPlayer ) ) && !fctFactions.actorFactionInList( akMaster, _SDFLP_banned_factions ) 
			; Debug.SendAnimationEvent(akPlayer , "ZazAPC057")
			; _SDGV_leash_length.SetValue(400)
			; _SDKP_enslave.SendStoryEvent( akLoc = akMaster.GetCurrentLocation(), akRef1 = akMaster as Actor, akRef2 = akPlayer, aiValue1 = 0, aiValue2 = 0)
		EndIf
	else
		Debug.MessageBox("[SD] Problem - Aggressor was reset before enslavement in _SD_DA_EnslavementBleedout.")
	EndIf
endEvent
 

GlobalVariable Property _SDGVP_gender_config  Auto

_SDQS_functions 	Property funct  		Auto
_SDQS_fcts_factions Property fctFactions  Auto

Race 				Property FalmerRace  	Auto  
Keyword 			Property _SDKP_actorTypeNPC  Auto
Keyword 			Property _SDKP_enslave  Auto
FormList 			Property _SDFLP_banned_factions  Auto
GlobalVariable 		Property _SDGVP_health_threshold  Auto  
GlobalVariable 		Property _SDGV_leash_length  Auto

; spriggan enslavement
Keyword Property _SDKP_spriggan  Auto
FormList Property _SDFLP_spriggan_factions  Auto
Faction Property _SDFP_humanoidCreatures  Auto
FormList Property _SDFL_allowed_creature_sex  Auto  
Spell Property _SDSP_spent Auto
Keyword Property _SDKP_clothChest  Auto
Keyword Property _SDKP_armorCuirass  Auto
Keyword Property _SDKP_bound  Auto
Keyword Property _SDKP_punish  Auto
Keyword Property _SDKP_DDi  Auto
FormList Property _SDFL_banned_sex  Auto  
SexLabFramework property SexLab auto

_SDQS_fcts_outfit Property fctOutfit  Auto
ReferenceAlias Property Alias_theBandit  Auto  
