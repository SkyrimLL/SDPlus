Scriptname _sdtrg_sprigganwater extends ObjectReference  

Event OnActivate(ObjectReference akActivator)
    Actor Player = Game.GetPlayer() as Actor
    ActorBase PlayerBase = Player.GetActorBase()

    if (PlayerBase.GetRace() == PolymorphRace)
        Player.AddItem(ReturnItem, 1 , True)
    else
; 		Debug.Trace("T01: Registering for IdleFurnitureExit.")
		RegisterForAnimationEvent(Player, "IdleFurnitureExit")
		Utility.Wait(10)
        Player.ResetHealthAndLimbs()
		UnregisterForAnimationEvent(Player, "IdleFurnitureExit")

		fctOutfit.clearDeviceByString( sDeviceString = "ParasiteAnal" )
		fctOutfit.clearDeviceByString( sDeviceString = "ParasiteVaginal" )

        If (StorageUtil.GetIntValue(Player, "_SD_iSprigganInfected") == 0) && (fctOutfit.countDeviousSlotsByKeyword (  Player,   "_SD_DeviousSpriggan" ) > 0)
            Debug.Messagebox("The spring waters wash away the residual roots clinging to your body.")

            ; fctOutfit.setDeviousOutfitArms ( iDevOutfit = 7, bDevEquip = False, sDevMessage = "")
            ; fctOutfit.setDeviousOutfitLegs ( iDevOutfit = 7, bDevEquip = False, sDevMessage = "")
            ; fctOutfit.setDeviousOutfitBelt ( iDevOutfit = 7, bDevEquip = False, sDevMessage = "")
            ; fctOutfit.setDeviousOutfitBlindfold ( iDevOutfit = 7,  bDevEquip = False, sDevMessage = "")

            fctOutfit.clearDeviceByString ( sDeviceString = "ArmCuffs"  )
            fctOutfit.clearDeviceByString ( sDeviceString = "LegCuffs", sOutfitString = "Spriggan"  )
            fctOutfit.clearDeviceByString ( sDeviceString = "Belt", sOutfitString = "Spriggan"  )
            fctOutfit.clearDeviceByString ( sDeviceString = "Blindfold", sOutfitString = "Spriggan"  )


        ElseIf (StorageUtil.GetIntValue(Player, "_SD_iSprigganInfected") == 1) && (fctOutfit.countDeviousSlotsByKeyword (  Player,   "_SD_DeviousSpriggan" ) > 0)
            Debug.Messagebox("The spriggan sap flowing in your veins is still too powerful to be washed away so easily. Try dinking at the spring later.")

        Else 
             Debug.Messagebox("The water feels rejuvinating.")

       Endif
	endif
EndEvent


Event OnAnimationEvent(ObjectReference akSource, string asEventName)
    Actor Player = Game.GetPlayer() as Actor
    ActorBase PlayerBase = Player.GetActorBase()

    if (PlayerBase.GetRace() != PolymorphRace)

	    if (asEventName == "IdleFurnitureExit" && akSource == Player)
    		UnregisterForAnimationEvent(Player, "IdleFurnitureExit")
	 
   	 endif
    Endif
EndEvent

Race Property PolymorphRace auto
Weapon Property ReturnItem Auto
_SDQS_fcts_outfit Property fctOutfit  Auto