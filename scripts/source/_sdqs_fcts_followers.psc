Scriptname _sdqs_fcts_followers extends Quest  
{ USED }
Import Utility
Import SKSE

Function sendCaptiveFollowerAway( Actor akFollower)

	Int iFormIndex = _SD_CaptiveFollowersLocations.length

	(akFollower as ObjectReference).MoveTo(_SD_CaptiveFollowersLocations[Utility.RandomInt(0,iFormIndex)] as ObjectReference)

EndFunction

ObjectReference[] Property _SD_CaptiveFollowersLocations  Auto  