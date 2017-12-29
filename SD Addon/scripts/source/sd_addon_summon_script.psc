Scriptname sd_addon_summon_script extends ObjectReference  

; copied from qasmoke button
; and
; 


event onCellAttach()
	;Keep the button closed if the form list is empty
	if  NPCList.GetSize() == 0 
		playAnimation("Close")
	else
		playAnimation("Open")
	endIf
endEvent


auto state open
	event onActivate(objectReference akActivator)

		goToState("waiting")
		playAnimationAndWait("Trigger01","done")

		;Spawn the NPC of the player's choice
		int playerChoice = NPCOptions.Show()		
		SpawnLocation.placeatme(NPCList.GetAt(playerChoice))

		goToState("Open")
	endEvent
endState

state waiting
endState

ObjectReference Property SpawnLocation  Auto   ;Location that the NPC the player selects will spawn
FormList Property NPCList  Auto  ;List of NPCs that the player can spawn
Message Property NPCOptions Auto    ;Interface that lets the player choose an NPC to spawn.

