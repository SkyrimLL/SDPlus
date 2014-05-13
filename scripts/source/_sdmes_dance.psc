Scriptname _SDMES_dance extends activemagiceffect  

Keyword Property _SDKP_sex  Auto  
GlobalVariable Property _SDGVP_dances  Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	_SDKP_sex.SendStoryEvent(akLoc = akCaster.GetCurrentLocation(), akRef1 = akTarget, akRef2 = akCaster, aiValue1 = 7, aiValue2 = 1 + Utility.RandomInt( 0, _SDGVP_dances.GetValueInt() ) )
	;_SDKP_sex.SendStoryEvent(akLoc = akCaster.GetCurrentLocation(), akRef1 = akTarget, akRef2 = akCaster, aiValue1 = 0, aiValue2 = 6 )
EndEvent
