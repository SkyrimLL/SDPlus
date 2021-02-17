Scriptname _SDAS_sprigganhostarmor extends ReferenceAlias

Import Utility

SexLabFramework property SexLab auto
Spell Property _SDSP_cum  Auto

Actor kWearer  = none
Bool bAllowRFU = false

Auto State nothing
	Event OnUpdate()

	EndEvent
EndState

State orgasm
	Event OnUpdate()

	EndEvent
EndState

Event OnInit()

EndEvent

Event OnUpdateGameTime()
	If ( !bAllowRFU )
		Return
	EndIf

	; do nothing
	While ( kWearer.GetCurrentScene() || kWearer.GetDialogueTarget() || kWearer.IsInCombat() || !kWearer.Is3DLoaded() || kWearer.GetSleepState() || kWearer.GetSitState() )
	; lets try not to mess up quests or kill the Player
	EndWhile

	RegisterForSingleUpdateGameTime( RandomFloat( 0.5, 1.5 ) )
	_SDSP_cum.RemoteCast(kWearer, kWearer, kWearer)

	If  (SexLab.ValidateActor( kWearer ) > 0) 
	
    	; actor[] sexActors = new actor[1]
    	; sexActors[0] = kWearer

    	; sslBaseAnimation[] anims = SexLab.GetAnimationsByTag(1, "Solo")

    	; SexLab.StartSex(sexActors, anims)

    	SexLab.QuickStart(kWearer, AnimationTags = "Solo")
    EndIf
EndEvent

Event OnEquipped(Actor akActor)
	kWearer = akActor

	bAllowRFU = True
	RegisterForSingleUpdateGameTime( 0.5 )
EndEvent

Event OnUnequipped(Actor akActor)
	bAllowRFU = False

	if(akActor == Game.getPlayer() && kQuest.GetStage() > 0 && kQuest.GetStage() <= 60)
		Form akArmor = (Self.GetReference() as ObjectReference).GetBaseObject()
		Game.GetPlayer().EquipItem(akArmor, abPreventRemoval = true, abSilent = true)
	endif
EndEvent

Quest Property kQuest  Auto  
