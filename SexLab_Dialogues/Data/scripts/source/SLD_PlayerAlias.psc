Scriptname SLD_PlayerAlias extends ReferenceAlias  

ReferenceAlias Property PlayerAlias  Auto  
SexLabFramework     property SexLab Auto

SLD_QST_Reset Property _SLD_Reset Auto
SLD_QST_Main Property _SLD_Main Auto

Bool isPlayerEnslaved = False
Bool isPlayerPregnant = False
Bool isPlayerSuccubus = False

Event OnInit()
	_SLD_Reset._maintenance()
	
	_maintenance()
	_updateGlobals()
EndEvent

Event OnPlayerLoadGame()
	_SLD_Reset._maintenance()
	
	_maintenance()
	_updateGlobals()
EndEvent

Function _maintenance()
	Actor PlayerActor = Game.GetPlayer()

	UnregisterForAllModEvents()
	Debug.Trace("SexLab Dialogues: Reset SexLab events")
	RegisterForModEvent("AnimationStart", "OnSexLabStart")
	RegisterForModEvent("AnimationEnd",   "OnSexLabEnd")
	; RegisterForModEvent("OrgasmStart",    "OnSexLabOrgasm")
	RegisterForModEvent("SLDRefreshNPCDialogues",   "OnSLDRefreshNPCDialogues")
	RegisterForModEvent("SLDRobPlayer",   "OnSLDRobPlayer")
	RegisterForModEvent("SLDGiftPlayer",   "OnSLDGiftPlayer")

	RegisterForModEvent("PCSubChangeLook",   "OnSDChangeLook")

	If (StorageUtil.GetIntValue(none, "_SLH_iHormones")!=1) ; If Hormones isn't defined, create our own shave head event
		RegisterForModEvent("SLHShaveHead",   "OnShaveHead")
	Endif


	isPlayerEnslaved = StorageUtil.GetIntValue( PlayerActor, "_SD_iEnslaved") as Bool
	isPlayerPregnant = StorageUtil.GetIntValue( PlayerActor, "_SLH_isPregnant") as Bool
	isPlayerSuccubus = StorageUtil.GetIntValue( PlayerActor, "_SLH_isSuccubus") as Bool

	PlayerActor.AddSpell( RestSpell )

	StorageUtil.SetIntValue( none, "_SLD_version", 2015021601)

	If (!StorageUtil.HasIntValue(none, "_SLD_iDialogues"))
		StorageUtil.SetIntValue(none, "_SLD_iDialogues", 1)
	EndIf

EndFunction

Function _updateGlobals()
	Actor PlayerActor = Game.GetPlayer()

	_SLD_isPlayerPregnant.SetValue(isPlayerPregnant as Int)
	_SLD_isPlayerSuccubus.SetValue(isPlayerSuccubus as Int)
	_SLD_isPlayerEnslaved.SetValue(isPlayerEnslaved as Int)

	If (StorageUtil.HasIntValue( PlayerActor, "_SD_iSlaveryLevel"))
		_SLD_PCSubSlaveryLevel.SetValue(  StorageUtil.GetIntValue( PlayerActor , "_SD_iSlaveryLevel") )
	Else
		_SLD_PCSubSlaveryLevel.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( PlayerActor, "_SD_iEnslaved"))
		_SLD_PCSubEnslaved.SetValue(  StorageUtil.GetIntValue( PlayerActor , "_SD_iEnslaved") )
	Else
		_SLD_PCSubEnslaved.SetValue( 0 )
	EndIf

	If (StorageUtil.HasStringValue( PlayerActor , "_SD_sDefaultStance"))
		If (StorageUtil.GetStringValue( PlayerActor, "_SD_sDefaultStance") == "Crawling")
			_SLD_PCSubDefaultStance.SetValue(  2 )
		ElseIf (StorageUtil.GetStringValue( PlayerActor, "_SD_sDefaultStance") == "Kneeling")
			_SLD_PCSubDefaultStance.SetValue(  1 )
		ElseIf (StorageUtil.GetStringValue( PlayerActor, "_SD_sDefaultStance") == "Standing")
			_SLD_PCSubDefaultStance.SetValue(  0 )
		EndIf
	Else
		_SLD_PCSubDefaultStance.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( PlayerActor , "_SD_iEnableStand"))
		_SLD_PCSubEnableStand.SetValue(  StorageUtil.GetIntValue( PlayerActor , "_SD_iEnableStand") )
	Else
		_SLD_PCSubEnableStand.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( PlayerActor , "_SD_iEnableLeash"))
		_SLD_PCSubEnableLeash.SetValue(  StorageUtil.GetIntValue( PlayerActor , "_SD_iEnableLeash") )
	Else
		_SLD_PCSubEnableLeash.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( PlayerActor , "_SD_iHandsFree"))
		_SLD_PCSubHandsFree.SetValue(  StorageUtil.GetIntValue( PlayerActor , "_SD_iHandsFree") )
	Else
		_SLD_PCSubHandsFree.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( PlayerActor , "_SD_iDominance"))
		_SLD_PCSubDominance.SetValue(  StorageUtil.GetIntValue( PlayerActor , "_SD_iDominance") )
	Else
		_SLD_PCSubDominance.SetValue( 0 )
	EndIf

EndFunction

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	ObjectReference akActorREF= Game.GetPlayer() as ObjectReference
	Actor akActor= Game.GetPlayer()

	_updateGlobals()
EndEvent

Event OnSLDRobPlayer(String _eventName, String _args, Float _argc, Form _sender)
 	Actor kActor = _sender as Actor

	_SLD_Main.RobPlayer(kActor)
EndEvent

Event OnSLDGiftPlayer(String _eventName, String _args, Float _argc, Form _sender)
 	Actor kActor = _sender as Actor

	_SLD_Main.GiftPlayer(kActor)
EndEvent

Event OnSexLabStart(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference PlayerREF= PlayerAlias.GetReference()
	Actor PlayerActor= PlayerAlias.GetReference() as Actor
	ActorBase pActorBase = PlayerActor.GetActorBase()
    sslBaseAnimation animation = SexLab.HookAnimation(_args)
    Bool isPCVictim = False
    Bool isPCRapist = False
    Bool isPCBimbo = False
    Bool isAnimCorruption = False
    Bool isAnimSeduction = False
    Int iDisposition
    Int iTrust
    Int iSexCount

	if !Self || !SexLab 
		Debug.Trace("SexLab Dialogues: Critical error on SexLab Start")
		Return
	EndIf


	Actor[] actors  = SexLab.HookActors(_args)
	Actor   victim  = SexLab.HookVictim(_args)
	Actor[] victims = new Actor[1]
	victims[0] = victim
	
	; if config.bDebugMsg
	; 	_listActors("End: ", actors)
	; EndIf

	; If (_hasPlayer(actors))
		;
	; EndIf

	If (animation.HasTag("Masturbation") || animation.HasTag("Solo")) && (actors.Length == 1) && (actors[0] == PlayerActor)
		; Catch masturbation events
		_SLD_PCMasturbating.SetValue(1)

	ElseIf (_hasPlayer(actors))

		if (victim == PlayerActor)
			; Player is a victim
			isPCVictim = True

		ElseIf (victim != None)
			; Player is a rapist
			isPCRapist = True

		endif

		isPCBimbo = StorageUtil.GetIntValue(PlayerActor, "_SLH_iBimbo") as Bool

		If isPCBimbo  
			; Enable Bimbo Override as single rape (for now)
			StorageUtil.SetIntValue( PlayerActor , "_SD_iSlaveryLevel", 6)
		Endif

		if ( animation.HasTag("Aggressive") || animation.HasTag("Anal")  || animation.HasTag("Dirty")  || animation.HasTag("Fisting")  || animation.HasTag("Orgy")  || animation.HasTag("Rough") )
			; - Corruption
			isAnimCorruption = True

		Elseif ( animation.HasTag("Cuddling") || animation.HasTag("Foreplay")  || animation.HasTag("Hugging")  || animation.HasTag("Kissing")  || animation.HasTag("LeadIn")  || animation.HasTag("Loving") )
			; - Seduction
			isAnimSeduction = True 

		EndIf


		int idx = 0
		while idx < actors.Length
			if actors[idx] == PlayerActor
				; Actor is Player

			else

				If !(StorageUtil.HasIntValue( actors[idx] , "_SD_iSeduction"))
					StorageUtil.SetIntValue( actors[idx] , "_SD_iSeduction", 0 )
				EndIf

				If !(StorageUtil.HasIntValue( actors[idx] , "_SD_iCorruption"))
					StorageUtil.SetIntValue( actors[idx] , "_SD_iCorruption", 0 )
				EndIf

				If !(StorageUtil.HasIntValue( actors[idx] , "_SD_iDisposition"))
					StorageUtil.SetIntValue( actors[idx] , "_SD_iDisposition", 0 )
				EndIf

				If !(StorageUtil.HasIntValue( actors[idx] , "_SD_iTrust"))
					StorageUtil.SetIntValue( actors[idx] , "_SD_iTrust", actors[idx].GetRelationshipRank(PlayerActor ) )
				EndIf

				If !(StorageUtil.HasIntValue(actors[idx], "_SD_iRelationshipType"))
					StorageUtil.SetIntValue(actors[idx], "_SD_iRelationshipType" , actors[idx].GetRelationshipRank(PlayerActor) )
				EndIf				

				If !isPCVictim && !isPCRapist
					StorageUtil.SetIntValue( actors[idx] , "_SD_iDisposition", iMin( iMax( StorageUtil.GetIntValue( actors[idx] , "_SD_iDisposition") + 1 , -10), 10) )
					StorageUtil.SetIntValue( actors[idx] , "_SD_iTrust", iMin( iMax( StorageUtil.GetIntValue( actors[idx] , "_SD_iTrust") + 1 , -10), 10)  )
				EndIf

				If isPCRapist
					If !(StorageUtil.HasIntValue( actors[idx] , "_SD_iRapeCountPCDom"))
						StorageUtil.SetIntValue( actors[idx] , "_SD_iRapeCountPCDom", 0 )
					Else
						StorageUtil.SetIntValue( actors[idx] , "_SD_iRapeCountPCDom", StorageUtil.GetIntValue( actors[idx] , "_SD_iRapeCountPCDom") + 1)
					EndIf
				EndIf

				If isPCVictim
					If !(StorageUtil.HasIntValue( actors[idx] , "_SD_iRapeCountPCSub"))
						StorageUtil.SetIntValue( actors[idx] , "_SD_iRapeCountPCSub", 0 )
					Else
						StorageUtil.SetIntValue( actors[idx] , "_SD_iRapeCountPCSub", StorageUtil.GetIntValue( actors[idx] , "_SD_iRapeCountPCSub") + 1)
					EndIf
				EndIf

				iDisposition = StorageUtil.GetIntValue( actors[idx] , "_SD_iDisposition")
				iTrust = StorageUtil.GetIntValue( actors[idx] , "_SD_iTrust")

				; isPCVictim 
				; isPCRapist 
				; isAnimCorruption
				; isAnimSeduction 

				; 4: Lover
				; 3: Ally
				; 2: Confidant
				; 1: Friend
				; 0: Acquaintance
				; -1: Rival
				; -2: Foe
				; -3: Enemy
				; -4: Archnemesis

				iSexCount = SexLab.PlayerSexCount( actors[idx] )

				If (iTrust >= 0 ) && (iDisposition >= 0) && !isPCVictim && !isPCRapist 
					if isAnimSeduction
						StorageUtil.SetIntValue( actors[idx] , "_SD_iSeduction", StorageUtil.GetIntValue( actors[idx] , "_SD_iSeduction") + 1 )
					ElseIf isAnimCorruption
						StorageUtil.SetIntValue( actors[idx] , "_SD_iCorruption", StorageUtil.GetIntValue( actors[idx] , "_SD_iCorruption") + 1 )
					EndIf

					If (iSexCount >= 2) ; Friend
						If (actors[idx].GetRelationshipRank(PlayerActor) == 0 )
							actors[idx].SetRelationshipRank(PlayerActor, 1 )
							StorageUtil.SetIntValue(actors[idx], "_SD_iRelationshipType", 1 )

						Elseif (StorageUtil.GetIntValue(actors[idx], "_SD_iRelationshipType") <= 4)
							StorageUtil.SetIntValue(actors[idx], "_SD_iRelationshipType" , actors[idx].GetRelationshipRank(PlayerActor) )
						EndIf
						

					ElseIf (iSexCount >= 4) ; Confident
						If (actors[idx].GetRelationshipRank(PlayerActor) >= 0 ) && (actors[idx].GetRelationshipRank(PlayerActor) <= 1)
							actors[idx].SetRelationshipRank(PlayerActor, 2 )
							StorageUtil.SetIntValue(actors[idx], "_SD_iRelationshipType", 2 )

						Elseif (StorageUtil.GetIntValue(actors[idx], "_SD_iRelationshipType") <= 4)
							StorageUtil.SetIntValue(actors[idx], "_SD_iRelationshipType" , actors[idx].GetRelationshipRank(PlayerActor) )
						EndIf
						

					ElseIf (iSexCount >= 8) ; Ally
						If (actors[idx].GetRelationshipRank(PlayerActor) >= 0 ) && (actors[idx].GetRelationshipRank(PlayerActor) <= 2)
							actors[idx].SetRelationshipRank(PlayerActor, 3 )
							StorageUtil.SetIntValue(actors[idx], "_SD_iRelationshipType", 3 )
							actors[idx].AddToFaction(PotentialFollowerFaction)
							actors[idx].AddToFaction(CurrentFollowerFaction)
							actors[idx].SetFactionRank( CurrentFollowerFaction, -1)
							actors[idx].SetAV( "Assistance", 2)
							actors[idx].SetAV( "Confidence", 3)

						Elseif (StorageUtil.GetIntValue(actors[idx], "_SD_iRelationshipType") <= 4)
							StorageUtil.SetIntValue(actors[idx], "_SD_iRelationshipType" , actors[idx].GetRelationshipRank(PlayerActor) )
						EndIf
						

					ElseIf (iSexCount >= 16) ; Lover
						If (actors[idx].GetRelationshipRank(PlayerActor) >= 0 ) && (actors[idx].GetRelationshipRank(PlayerActor) <= 3)
							actors[idx].SetRelationshipRank(PlayerActor, 4 )
							StorageUtil.SetIntValue(actors[idx], "_SD_iRelationshipType", 4 )
							actors[idx].AddToFaction(PotentialFollowerFaction)
							actors[idx].AddToFaction(CurrentFollowerFaction)
							actors[idx].SetFactionRank( CurrentFollowerFaction, -1)
							actors[idx].AddToFaction(PotentialMarriageFaction)
							actors[idx].SetAV( "Assistance", 2)
							actors[idx].SetAV( "Confidence", 3)

						Elseif (StorageUtil.GetIntValue(actors[idx], "_SD_iRelationshipType") <= 4)
							StorageUtil.SetIntValue(actors[idx], "_SD_iRelationshipType" , actors[idx].GetRelationshipRank(PlayerActor) )
						EndIf
						
					EndIf

				ElseIf isPCVictim && (StorageUtil.GetIntValue( actors[idx] , "_SD_iRapeCountPCSub") >= 10)
					; Enable PCSub topics
					StorageUtil.SetIntValue(actors[idx], "_SD_iRelationshipType", -5 )

				ElseIf isPCRapist && ( StorageUtil.GetIntValue( actors[idx] , "_SD_iRapeCountPCDom") >= 10)
					; Enable PCDom topics

					StorageUtil.SetIntValue(actors[idx], "_SD_iRelationshipType", 5 )

					If ( StorageUtil.GetIntValue( actors[idx] , "_SD_iRapeCountPCDom") <= 20) && (Utility.RandomInt(0,100) >80)
						actors[idx].SetRelationshipRank(PlayerActor, -2)
						actors[idx].SetActorValue("Aggression", 1)
						actors[idx].SetActorValue("Confidence", 3)
						actors[idx].SetActorValue("Assistance", 0)
						Debug.Notification("Get away from me!")
					Else
						Debug.Notification("Enough... please! I will do anything you want!")
						actors[idx].SetRelationshipRank(PlayerActor, 1)
						actors[idx].SetActorValue("Aggression", 0)
						actors[idx].SetActorValue("Confidence", 0)
						actors[idx].SetActorValue("Assistance", 0)

						; Puppet master spell disabled here - making an NPC a slave opens up a manual Puppet Master topic
						; StorageUtil.SetIntValue(PlayerActor, "Puppet_CastTarget", 1)
						; StorageUtil.SetFormValue(PlayerActor, "Puppet_NewTarget", actors[idx] )
					EndIf

				EndIf	

				If isPCBimbo && (StorageUtil.GetIntValue( actors[idx] , "_SD_iRapeCountPCSub") >= 1)
					; Enable Bimbo Override as single rape (for now)
					StorageUtil.SetIntValue(actors[idx], "_SD_iRelationshipType", -5 )
				Endif

;				Debug.Notification("[SLD] sx: " + iSexCount + " rpd: " + StorageUtil.GetIntValue( actors[idx] , "_SD_iRapeCountPCDom")  + " rps: " + StorageUtil.GetIntValue( actors[idx] , "_SD_iRapeCountPCSub") )
;				Debug.Notification("[SLD] d: " + StorageUtil.GetIntValue( actors[idx] , "_SD_iDisposition") + " t: " + StorageUtil.GetIntValue( actors[idx] , "_SD_iTrust") + " s: " + StorageUtil.GetIntValue( actors[idx] , "_SD_iSeduction") + " c: " + StorageUtil.GetIntValue( actors[idx] , "_SD_iCorruption") + " r: " + StorageUtil.GetIntValue(actors[idx], "_SD_iRelationshipType") )

				Debug.Trace("[SLD] isPCVictim: " + isPCVictim + " isPCRapist: " + isPCRapist  + " isAnimCorruption: " + isAnimCorruption + " isAnimSeduction: " + isAnimSeduction )
				Debug.Trace("[SLD] sexCount: " + iSexCount + " rapePCDom: " + StorageUtil.GetIntValue( actors[idx] , "_SD_iRapeCountPCDom")  + " rapePCSub: " + StorageUtil.GetIntValue( actors[idx] , "_SD_iRapeCountPCSub") )
				Debug.Trace("[SLD] _SD_iDisposition: " + StorageUtil.GetIntValue( actors[idx] , "_SD_iDisposition") + " _SD_iTrust: " + StorageUtil.GetIntValue( actors[idx] , "_SD_iTrust") + " _SD_iSeduction: " + StorageUtil.GetIntValue( actors[idx] , "_SD_iSeduction") + " _SD_iCorruption: " + StorageUtil.GetIntValue( actors[idx] , "_SD_iCorruption") + " _SD_iRelationshipType: " + StorageUtil.GetIntValue(actors[idx], "_SD_iRelationshipType") )
			endif

			idx += 1
		endwhile
	EndIf

EndEvent 


Event OnSexLabEnd(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference PlayerREF= PlayerAlias.GetReference()
	Actor PlayerActor= PlayerAlias.GetReference() as Actor
	ActorBase pActorBase = PlayerActor.GetActorBase()
    sslBaseAnimation animation = SexLab.HookAnimation(_args)

	if !Self || !SexLab 
		Debug.Trace("SexLab Dialogues: Critical error on SexLab End")
		Return
	EndIf


	Actor[] actors  = SexLab.HookActors(_args)
	Actor   victim  = SexLab.HookVictim(_args)
	Actor[] victims = new Actor[1]
	victims[0] = victim
	
	; if config.bDebugMsg
	; 	_listActors("End: ", actors)
	; EndIf

	; If (_hasPlayer(actors))
		;
	; EndIf

	_SLD_PCMasturbating.SetValue(0)

EndEvent 

Event OnSexLabOrgasm(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference PlayerREF= PlayerAlias.GetReference()
	Actor PlayerActor= PlayerAlias.GetReference() as Actor
 

	if !Self || !SexLab 
		Debug.Trace("SexLab Dialogues: Critical error on SexLab Orgasm")
		Return
	EndIf

	Actor[] actors  = SexLab.HookActors(_args)
	Actor   victim  = SexLab.HookVictim(_args)
	Actor[] victims = new Actor[1]
	victims[0] = victim

	If (_hasPlayer(actors))
		Debug.Trace("SexLab Dialogues: Orgasm!")

	EndIf
	
EndEvent

Event OnSLDRefreshNPCDialogues(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference PlayerREF= PlayerAlias.GetReference()
	Actor PlayerActor= PlayerAlias.GetReference() as Actor
 	Actor kActor = _sender as Actor

 	if (kActor != None)
 		_SLD_Main.SetNPCDialogueState( kActor )
	EndIf
EndEvent

Event OnSDChangeLook(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iEventCode = _argc as Int
	String iEventString = _args

	Debug.Trace("[_sdras_player] Receiving slave change look story event [" + _args  + "] [" + _argc as Int + "]")
 
 	; Event currently defined in SexLab Dialogues... change that later
	_SLD_Main.ChangePlayerLook(kActor)
EndEvent

Event OnSDShaveHead(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iEventCode = _argc as Int
	String iEventString = _args

	Debug.Trace("[_sdras_player] Receiving slave change look story event [" + _args  + "] [" + _argc as Int + "]")
 
 	; Event currently defined in SexLab Dialogues... change that later
	_SLD_Main.ShaveHead(kActor)
EndEvent


int function iMin(int a, int b)
	if (a<=b)
		return a
	else
		return b
	EndIf
EndFunction

int function iMax(int a, int b)
	if (a<b)
		return b
	else
		return a
	EndIf
EndFunction

float function fMin(float  a, float b)
	if (a<=b)
		return a
	else
		return b
	EndIf
EndFunction

float function fMax(float a, float b)
	if (a<b)
		return b
	else
		return a
	EndIf
EndFunction

Bool Function _hasPlayer(Actor[] _actors)
	ObjectReference PlayerREF= PlayerAlias.GetReference()

	int idx = 0
	while idx < _actors.Length
		if _actors[idx] == PlayerRef
			return True
		endif
		idx += 1
	endwhile
	Return False
EndFunction

Bool Function _hasActor(Actor[] _actors, Actor thisActor)

	int idx = 0
	while idx < _actors.Length
		if _actors[idx] == thisActor as ObjectReference
			return True
		endif
		idx += 1
	endwhile
	Return False
EndFunction

Bool Function _hasRace(Actor[] _actors, Race thisRace)
	ActorBase aBase 
	Race aRace 

	int idx = 0
	while idx < _actors.Length
		if (_actors[idx])
			; aBase = _actors[idx].GetBaseObject() as ActorBase
			aRace = _actors[idx].GetLeveledActorBase().GetRace()
			if aRace == thisRace
				return True
			endif
		EndIf
		idx += 1
	endwhile
	Return False
EndFunction

SPELL Property RestSpell Auto

GlobalVariable Property _SLD_isPlayerPregnant auto
GlobalVariable Property _SLD_isPlayerSuccubus auto
GlobalVariable Property _SLD_isPlayerEnslaved auto

GlobalVariable Property _SLD_PCSubDefaultStance Auto
GlobalVariable Property _SLD_PCSubEnableStand Auto
GlobalVariable Property _SLD_PCSubEnableLeash Auto
GlobalVariable Property _SLD_PCSubHandsFree Auto
GlobalVariable Property _SLD_PCSubDominance Auto
GlobalVariable Property _SLD_PCSubSlaveryLevel Auto
GlobalVariable Property _SLD_PCSubEnslaved Auto

GlobalVariable Property _SLD_PCMasturbating Auto

Faction Property PotentialFollowerFaction Auto
Faction Property CurrentFollowerFaction Auto
Faction Property PotentialMarriageFaction Auto