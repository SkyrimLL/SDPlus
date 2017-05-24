Scriptname _sdmes_sanguineDeviceBound extends activemagiceffect  

_SDQS_functions Property funct  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto
Race Property DremoraRace Auto

Float fRFSU = 60.0
Float fTimer = 60.0

Actor kPlayer 

Event OnEffectStart(Actor akTarget, Actor akCaster)

	kPlayer = akTarget
	StorageUtil.SetFormValue(kPlayer, "_SD_fSlaveryGearRace", DremoraRace)
	StorageUtil.SetFormValue(kPlayer, "_SD_fSlaveryGearActor", none)
	Debug.Trace("[SD] _sdmes_sanguineDeviceBound: OnEffectStart")
	
	if (!fctOutfit.isCollarEquipped (  akTarget ))
		fctOutfit.equipDeviceByString ( sDeviceString = "Collar")
	Else
		Debug.Trace("[SD] Skipping sanguine collar - slot in use")
	EndIf

	if (!fctOutfit.isArmsEquipped (  akTarget ))  && !fctOutfit.isYokeEquipped( akTarget )  && (Utility.RandomInt(0,100) > 40)
		fctOutfit.equipDeviceByString ( sDeviceString = "Armbinders")
	Else
		Debug.Trace("[SD] Skipping sanguine cuffs - slot in use")
	EndIf

	if (!fctOutfit.isLegsEquipped (  akTarget )) && (Utility.RandomInt(0,100) > 40)
		fctOutfit.equipDeviceByString ( sDeviceString = "LegCuffs")
	Else
		Debug.Trace("[SD] Skipping sanguine shackles - slot in use")
	EndIf
	
	if (!fctOutfit.IsGagEquipped (  akTarget )) && (Utility.RandomInt(0,100) > 40)
		fctOutfit.equipDeviceByString ( sDeviceString = "Gag")
	Else
		Debug.Trace("[SD] Skipping sanguine gag ")
	EndIf

	if (!fctOutfit.isPiercingsVaginalEquipped (  akTarget )) && (Utility.RandomInt(0,100) > 40)
		fctOutfit.equipDeviceByString ( sDeviceString = "VaginalPiercing")
	Else
		Debug.Trace("[SD] Skipping sanguine piercing ")
	EndIf

	fTimer = fRFSU * Utility.RandomInt(7 - StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryLevel") , 11  - StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryLevel"))
	Debug.Trace("[SD] Sanguine items timer: " + fTimer)
	RegisterForSingleUpdate( fTimer )
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Debug.Trace("[SD] _sdmes_sanguineDeviceBound: OnEffectFinish")
	If (fctOutfit.countDeviousSlotsByKeyword (  akTarget, "_SD_DeviousSanguine" )>0) && (Utility.RandomInt(0,100) > 40)
		_SDSP_freedom.RemoteCast( kPlayer, kPlayer, kPlayer )
	EndIf

EndEvent

Event OnUpdate()
	If (fctOutfit.countDeviousSlotsByKeyword (  kPlayer, "_SD_DeviousSanguine" )>0)
		Debug.Trace("[SD] Sanguine items timer: OnUpdate " )
		_SDSP_freedom.RemoteCast( kPlayer, kPlayer, kPlayer )
	EndIf

	fTimer = fRFSU * Utility.RandomInt(7 - StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryLevel") , 11  - StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryLevel"))
	Debug.Trace("[SD] Sanguine items timer: " + fTimer)
	RegisterForSingleUpdate( fTimer )
EndEvent

Spell Property _SDSP_freedom  Auto  