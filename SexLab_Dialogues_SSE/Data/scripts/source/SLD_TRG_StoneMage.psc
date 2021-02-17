Scriptname SLD_TRG_StoneMage extends ObjectReference  

quest property _SLD_QST_JobMage auto	
SPELL property _SLD_SP_StoneMage auto

ReferenceAlias Property _SLD_SkyShardRefAlias  Auto  

Bool bShowMessageOnce = False

auto STATE waitingForActor
	EVENT onTriggerEnter(objectReference triggerRef)
		; check for correct actor
		actor actorRef = triggerRef as actor
		actor PlayerActor = Game.GetPlayer() 
		ObjectReference SkyShardRef = _SLD_SkyShardRefAlias.GetReference()
		Form SkyShardForm = SkyShardRef  as Form

		if actorRef != None && (actorRef == PlayerActor ) && (_SLD_QST_JobMage.IsStageDone(105) )
			; debug.notification("[_SLD_TRG_StoneMage] Mage stone triggered - casting spell")
			_SLD_SP_StoneMage.RemoteCast(triggerRef, PlayerActor  )
			SkyShardForm.SetName("Glowing SkyShard")

			_SLD_QST_JobMage.SetStage(415)
			
			if (!bShowMessageOnce)
				Debug.Messagebox("The Skyshard reacts to the stone and starts glowing around you" )
			Endif

			bShowMessageOnce = true
			; gotoState("hasBeenTriggered")
			; disable()
		else
			; debug.notification("[_SLD_TRG_StoneMage] Mage stone triggered - skip")

		endif
	endEVENT
endSTATE

STATE hasBeenTriggered
	; this is an empty state.
endSTATE