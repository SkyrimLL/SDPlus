Scriptname SLD_ME_debug extends activemagiceffect  

SexLabFramework Property SexLab  Auto  
Faction Property SexLabAnimFaction  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Actor kPlayer = Game.GetPlayer()
	
	Debug.Notification("[SLD] Debug spell")
	Debug.Trace("[SLD] Debug spell on actor: " + akTarget)

	Debug.Trace("[SLD] 		Debug - Actor current target: " + akTarget.GetDialogueTarget())
	Debug.Trace("[SLD] 		Debug - Actor current package: " + akTarget.GetCurrentPackage())
	Debug.Trace("[SLD] 		Debug - Is actor in combat?: " + akTarget.IsInCombat())
	Debug.Trace("[SLD] 		Debug - Is actor alerted?: " + akTarget.IsAlerted())
	Debug.Trace("[SLD] 		Debug - Is actor teammate with player?: " + akTarget.IsPlayerTeammate())
	Debug.Trace("[SLD] 		Debug - Actor relationship rank: " + akTarget.GetRelationshipRank(kPlayer))
	Debug.Trace("[SLD] 		Debug - SexLab validate player: " + SexLab.ValidateActor( kPlayer) )
	Debug.Trace("[SLD] 		Debug - SexLab validate actor: " + SexLab.ValidateActor( akTarget) )
	Debug.Trace("[SLD] 		Debug - Is actor in SexLab anim faction?: " + akTarget.IsInFaction(SexLabAnimFaction))

	Debug.Trace("[SLD] 		Debug - Forcing player dialogue: " )
	akTarget.AllowPCDialogue(true)
	Debug.Trace("[SLD] 		Debug - Forcing package evaluation: " )
	akTarget.EvaluatePackage()
	Debug.Trace("[SLD] 		Debug - Set player teammate: " )
	akTarget.SetPlayerTeammate(true, false)
EndEvent
