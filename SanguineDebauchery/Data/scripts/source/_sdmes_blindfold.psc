Scriptname _SDMES_blindfold extends ActiveMagicEffect  

ImageSpaceModifier Property _SDISMP_blindfold  Auto  
ReferenceAlias Property _SDRAP_master  Auto  
Keyword Property _SDKP_sex  Auto  
GlobalVariable Property _SDGVP_const_shortleash  Auto  
GlobalVariable Property _SDGVP_const_caged  Auto  

Actor kSlave
ObjectReference kMaster

Float fRFSU = 0.1

Float UI1
Float UI2
Float UI3
Float UI4

Event OnUpdate()
	If ( !kSlave.GetCurrentScene() && !_SDGVP_const_caged.GetValueInt() && ( kMaster as Actor ).HasLOS( kSlave ) && kSlave.GetDistance(kMaster) > _SDGVP_const_shortleash.GetValueInt() )
	;	_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 1)
	EndIf

	RegisterForSingleUpdate( fRFSU )
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	kSlave = akTarget
	kMaster = _SDRAP_master.GetReference() as ObjectReference

	_SDISMP_blindfold.Apply()
	
	UI1 = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.CompassShoutMeterHolder._alpha")
	UI2 = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.CompassShoutMeterHolder.Compass.DirectionRect._alpha")
	UI3 = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.CompassShoutMeterHolder.Compass.CompassFrame._alpha")
	UI4 = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.FloatingQuestMarker_mc._alpha")
	UI.SetNumber("HUD Menu", "_root.HUDMovieBaseInstance.CompassShoutMeterHolder._alpha", 0.0)
	UI.SetNumber("HUD Menu", "_root.HUDMovieBaseInstance.CompassShoutMeterHolder.Compass.DirectionRect._alpha", 0.0)
	UI.SetNumber("HUD Menu", "_root.HUDMovieBaseInstance.CompassShoutMeterHolder.Compass.CompassFrame._alpha", 0.0)
	UI.SetNumber("HUD Menu", "_root.HUDMovieBaseInstance.FloatingQuestMarker_mc._alpha", 0.0)

	RegisterForSingleUpdate( fRFSU )
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UI.SetNumber("HUD Menu", "_root.HUDMovieBaseInstance.CompassShoutMeterHolder._alpha", UI1)
	UI.SetNumber("HUD Menu", "_root.HUDMovieBaseInstance.CompassShoutMeterHolder.Compass.DirectionRect._alpha", UI2)
	UI.SetNumber("HUD Menu", "_root.HUDMovieBaseInstance.CompassShoutMeterHolder.Compass.CompassFrame._alpha", UI3)
	UI.SetNumber("HUD Menu", "_root.HUDMovieBaseInstance.FloatingQuestMarker_mc._alpha", UI4)

	_SDISMP_blindfold.Remove()
EndEvent
