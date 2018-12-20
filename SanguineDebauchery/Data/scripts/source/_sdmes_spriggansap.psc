Scriptname _SDMES_sprigganSap extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Debug.Trace("_SDMES_sprigganSap " + akTarget)

  ; Why was spriggan sap effect triggered out in the wild?? next to a spriggan maybe?
  ; SendModEvent("SLHModHormone", "Pheromones", 1.0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  Debug.Trace("_SDMES_sprigganSap " + akTarget)
EndEvent
