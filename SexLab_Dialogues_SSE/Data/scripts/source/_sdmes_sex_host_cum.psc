Scriptname _SDMES_sex_host_cum extends activemagiceffect  

Race Property _SDRP_flowering_spriggan  Auto  
ReferenceAlias Property _SDRAP_spriggan  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If ( akTarget.GetRace() == _SDRP_flowering_spriggan && akTarget != _SDRAP_spriggan.GetReference() as Actor)
		akTarget.Kill()
		akTarget.DeleteWhenAble()
	EndIf
EndEvent

