Scriptname SLD_TRG_MGR02FocalPointTrigger extends ObjectReference  

Quest Property JobMageQuest  Auto  
Spell Property FocalEffectSpell  Auto 

Event OnActivate(ObjectReference akActionRef)
	Actor akActor = akActionRef as Actor
	Actor akPlayer = Game.getPlayer() as Actor

	if (akActor == akPlayer) && (JobMageQuest.GetStageDone(105))
		 FocalEffectSpell.cast(Self, akActionRef)
		 Debug.Messagebox("The Skyshard is glowing faster.")
	endif


EndEvent