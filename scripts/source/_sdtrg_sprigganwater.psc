Scriptname _sdtrg_sprigganwater extends ObjectReference  

Event OnActivate(ObjectReference akActivator)
    Actor Player = Game.GetPlayer() as Actor
    ActorBase PlayerBase = Player.GetActorBase()

    if (PlayerBase.GetRace() == PolymorphRace)
        Player.AddItem(ReturnItem, 1 , True)
    else
; 		Debug.Trace("T01: Registering for IdleFurnitureExit.")
		RegisterForAnimationEvent(Game.GetPlayer(), "IdleFurnitureExit")
		Utility.Wait(10)
        Player.ResetHealthAndLimbs()
		UnregisterForAnimationEvent(Game.GetPlayer(), "IdleFurnitureExit")

 
	endif
EndEvent


Event OnAnimationEvent(ObjectReference akSource, string asEventName)
    Actor Player = Game.GetPlayer() as Actor
    ActorBase PlayerBase = Player.GetActorBase()

    if (PlayerBase.GetRace() != PolymorphRace)

	    if (asEventName == "IdleFurnitureExit" && akSource == Game.GetPlayer())
    		UnregisterForAnimationEvent(Game.GetPlayer(), "IdleFurnitureExit")
	 
   	 endif
    Endif
EndEvent

Race Property PolymorphRace auto
Weapon Property ReturnItem Auto