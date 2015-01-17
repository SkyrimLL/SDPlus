Scriptname SLD_PlayerAlias extends ReferenceAlias  

ReferenceAlias Property PlayerAlias  Auto  
SexLabFramework     property SexLab Auto

SLD_QST_Reset Property _SLD_Reset Auto
SLD_QST_Main Property _SLD_Main Auto

Bool isPlayerEnslaved = False
Bool isPlayerPregnant = False
Bool isPlayerSuccubus = False

Event OnPlayerLoadGame()
	_SLD_Reset._maintenance()
	
	_maintenance()
	_updateGlobals()
EndEvent

Function _maintenance()


	UnregisterForAllModEvents()
	Debug.Trace("SexLab Dialogues: Reset SexLab events")
	; RegisterForModEvent("AnimationStart", "OnSexLabStart")
	RegisterForModEvent("AnimationEnd",   "OnSexLabEnd")
	; RegisterForModEvent("OrgasmStart",    "OnSexLabOrgasm")
	RegisterForModEvent("SLDRefreshNPCDialogues",   "OnSLDRefreshNPCDialogues")



	isPlayerEnslaved = StorageUtil.GetIntValue( Game.GetPlayer(), "_SD_iEnslaved") as Bool
	isPlayerPregnant = StorageUtil.GetIntValue( Game.GetPlayer(), "_SLH_isPregnant") as Bool
	isPlayerSuccubus = StorageUtil.GetIntValue( Game.GetPlayer(), "_SLH_isSuccubus") as Bool

	Game.GetPlayer().AddSpell( RestSpell )
EndFunction

Function _updateGlobals()
	_SLD_isPlayerPregnant.SetValue(isPlayerPregnant as Int)
	_SLD_isPlayerSuccubus.SetValue(isPlayerSuccubus as Int)
	_SLD_isPlayerEnslaved.SetValue(isPlayerEnslaved as Int)

	If (StorageUtil.HasIntValue( Game.GetPlayer(), "_SD_iSlaveryLevel"))
		_SLD_PCSubSlaveryLevel.SetValue(  StorageUtil.GetIntValue( Game.GetPlayer() , "_SD_iSlaveryLevel") )
	Else
		_SLD_PCSubSlaveryLevel.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( Game.GetPlayer(), "_SD_iEnslaved"))
		_SLD_PCSubEnslaved.SetValue(  StorageUtil.GetIntValue( Game.GetPlayer() , "_SD_iEnslaved") )
	Else
		_SLD_PCSubEnslaved.SetValue( 0 )
	EndIf

	If (StorageUtil.HasStringValue( Game.GetPlayer() , "_SD_sDefaultStance"))
		If (StorageUtil.GetStringValue( Game.GetPlayer(), "_SD_sDefaultStance") == "Crawling")
			_SLD_PCSubDefaultStance.SetValue(  2 )
		ElseIf (StorageUtil.GetStringValue( Game.GetPlayer(), "_SD_sDefaultStance") == "Kneeling")
			_SLD_PCSubDefaultStance.SetValue(  1 )
		ElseIf (StorageUtil.GetStringValue( Game.GetPlayer(), "_SD_sDefaultStance") == "Standing")
			_SLD_PCSubDefaultStance.SetValue(  0 )
		EndIf
	Else
		_SLD_PCSubDefaultStance.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( Game.GetPlayer() , "_SD_iEnableStand"))
		_SLD_PCSubEnableStand.SetValue(  StorageUtil.GetIntValue( Game.GetPlayer() , "_SD_iEnableStand") )
	Else
		_SLD_PCSubEnableStand.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( Game.GetPlayer() , "_SD_iEnableLeash"))
		_SLD_PCSubEnableLeash.SetValue(  StorageUtil.GetIntValue( Game.GetPlayer() , "_SD_iEnableLeash") )
	Else
		_SLD_PCSubEnableLeash.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( Game.GetPlayer() , "_SD_iHandsFree"))
		_SLD_PCSubHandsFree.SetValue(  StorageUtil.GetIntValue( Game.GetPlayer() , "_SD_iHandsFree") )
	Else
		_SLD_PCSubHandsFree.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( Game.GetPlayer() , "_SD_iDominance"))
		_SLD_PCSubDominance.SetValue(  StorageUtil.GetIntValue( Game.GetPlayer() , "_SD_iDominance") )
	Else
		_SLD_PCSubDominance.SetValue( 0 )
	EndIf

EndFunction

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	ObjectReference akActorREF= Game.GetPlayer() as ObjectReference
	Actor akActor= Game.GetPlayer()

	_updateGlobals()
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

	If (_hasPlayer(actors))
		;
	EndIf

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
			aBase = _actors[idx].GetBaseObject() as ActorBase
			aRace = aBase.GetRace()
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