Scriptname _SDMES_sprigganSap extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Debug.Trace("_SDMES_sprigganSap " + akTarget)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  Debug.Trace("_SDMES_sprigganSap " + akTarget)
EndEvent
