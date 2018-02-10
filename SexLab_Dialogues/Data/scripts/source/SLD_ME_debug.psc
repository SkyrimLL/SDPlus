Scriptname SLD_ME_debug extends activemagiceffect  

SexLabFramework Property SexLab  Auto  
Faction Property SexLabAnimFaction  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Actor kPlayer = Game.GetPlayer()
	Faction nthFaction
	Form nthForm
	
	Debug.Notification("[SLD] Debug spell")
	Debug.Trace("[SLD] Debug spell on actor: " + akTarget)

	Debug.Trace("[SLD] 		Debug - Actor current target: " + akTarget.GetDialogueTarget())
	Debug.Trace("[SLD] 		Debug - Actor current package: " + akTarget.GetCurrentPackage())
	Debug.Trace("[SLD] 		Debug - Actor current scene: " + akTarget.GetCurrentScene() )
	Debug.Trace("[SLD] 		Debug - Is actor in combat?: " + akTarget.IsInCombat())
	Debug.Trace("[SLD] 		Debug - Is actor alerted?: " + akTarget.IsAlerted())
	Debug.Trace("[SLD] 		Debug - Is actor teammate with player?: " + akTarget.IsPlayerTeammate())
	Debug.Trace("[SLD] 		Debug - Actor relationship rank: " + akTarget.GetRelationshipRank(kPlayer))
	Debug.Trace("[SLD] 		Debug - SexLab validate player: " + SexLab.ValidateActor( kPlayer) )
	Debug.Trace("[SLD] 		Debug - SexLab validate actor: " + SexLab.ValidateActor( akTarget) )
	Debug.Trace("[SLD] 		Debug - Is actor in SexLab anim faction?: " + akTarget.IsInFaction(SexLabAnimFaction))

	; Add display of factions for NPC
	Faction[] ActorFactions = akTarget.GetFactions(-128, 127);The maximum range allowed.
	Debug.Trace("[SLD] 		Debug - Actor is a part of the following factions: ")
	Int iFormIndex = ActorFactions.Length
	While ( iFormIndex > 0 )
		iFormIndex -= 1
		nthFaction = ActorFactions[iFormIndex]
		nthForm = nthFaction as Form
		If ( nthFaction )
			; Debug.Notification("	Master Faction: " + nthFaction)
			Debug.Trace("				Faction: " + nthForm.GetName() + " - (" + nthFaction + ")")
		Endif
	Endwhile

	Debug.Trace("[SLD] 		Debug ----- Applying fixes " )

	Debug.Trace("[SLD] 		Debug - Forcing player dialogue: " )
	akTarget.AllowPCDialogue(true)

	Debug.Trace("[SLD] 		Debug - Forcing package evaluation: " )
	akTarget.EvaluatePackage()

	Debug.Trace("[SLD] 		Debug - Set player teammate: " )
	akTarget.SetPlayerTeammate(true, false)

	Debug.Trace("[SLD] 		Debug - Forcing Dialogues refresh " )
	akTarget.SendModEvent("SLDRefreshNPCDialogues")

	; Debug.Trace("[SLD] 		Debug - Removing all items " )
	; akTarget.RemoveAllItems(akTransferTo = kPlayer , abKeepOwnership = True)

	; Debug.Trace("[SLD] 		Debug - Reset Health " )
	; akTarget.ResetHealthAndLimbs()

	; Debug.Trace("[SLD] 		Debug - Removing from all factions " )
	; akTarget.RemoveFromAllFactions()

	; Debug.Trace("[SLD] 		Debug - Resurrect " )
	; akTarget.Resurrect()

	Faction DefeatDialogueBlockFaction = Game.GetFormFromFile(0x0008C862, "SexLabDefeat.esp") As Faction
	If (DefeatDialogueBlockFaction != None)
		If (akTarget.IsInFaction(DefeatDialogueBlockFaction))
	 		Debug.Trace("[SLD] 		Debug - NPC is in Dialogue Blocking Faction from Defeat" )
	 		akTarget.RemoveFromFaction(DefeatDialogueBlockFaction)
		Else
	 		Debug.Trace("[SLD] 		Debug - NPC is NOT in Dialogue Blocking Faction from Defeat" )
		Endif
	Endif


EndEvent
