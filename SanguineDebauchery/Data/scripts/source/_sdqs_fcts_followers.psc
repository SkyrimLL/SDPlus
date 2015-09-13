Scriptname _sdqs_fcts_followers extends Quest  
{ USED }
Import Utility
Import SKSE

Function sendCaptiveFollowerAway( Actor akFollower)

	Int iFormIndex 

	if (akFollower.HasKeyword( _SDKP_actorTypeNPC ))
		; Humanoid followers
		iFormIndex = _SD_CaptiveFollowersLocations.length
		(akFollower as ObjectReference).MoveTo(_SD_CaptiveFollowersLocations[Utility.RandomInt(0,iFormIndex)] as ObjectReference)

	Else
		; Animal / Creature followers
		iFormIndex = _SD_CaptiveCreatureLocations.length
		(akFollower as ObjectReference).MoveTo(_SD_CaptiveCreatureLocations[Utility.RandomInt(0,iFormIndex)] as ObjectReference)

	EndIf

EndFunction

ObjectReference[] Property _SD_CaptiveFollowersLocations  Auto  
ObjectReference[] Property _SD_CaptiveCreatureLocations  Auto  
Keyword 			Property _SDKP_actorTypeNPC  Auto
