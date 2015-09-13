Scriptname _SDRAS_stopquestondead extends ReferenceAlias  

Event OnDeath(Actor akKiller)
	Self.GetOwningQuest().Stop()
EndEvent
