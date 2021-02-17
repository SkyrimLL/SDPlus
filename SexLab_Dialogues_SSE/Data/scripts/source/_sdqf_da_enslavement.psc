;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 6
Scriptname _sdqf_da_enslavement Extends Quest Hidden

;BEGIN ALIAS PROPERTY theLocEdge
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theLocEdge Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLocMapMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theLocMapMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theBandit
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theBandit Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLocOutside
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theLocOutside Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theMarker Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Stage_0()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
Stage_100()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Stage_10()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


daymoyl_MonitorVariables Property Variables Auto
daymoyl_MonitorUtility Property Util Auto
daymoyl_GetYourGearScript Property RecoveryQuest Auto

Event OnUpdate()
	SetStage(10)
endEvent

Function Stage_0()
	Debug.Trace("SD enslavement - DA - Teleported to Default Location")
	Util.WaitGameHours(Variables.BlackoutTimeLapse * 24.0)

	; -----
	; DA's stealing items - disabled from now - add again later with MCM option

	; if(!RecoveryQuest.IsRunning())
	;	RecoveryQuest.Start()
	; endif
	; RecoveryQuest.SetThief(akMaster )
	; RecoveryQuest.RemoveItemsFromPlayer()

	RegisterForModEvent("da_EndBleedout", "EnslaveAtEndOfBleedout")
	RegisterForSingleUpdate(2.0)
endFunction

Function Stage_10()
	; If (Utility.RandomInt(0,100) > 90)
	; 	SendModEvent("da_StartSecondaryQuest", "Both")
	; endif

	SendModEvent("da_StartRecoverSequence")	
endFunction

Event EnslaveAtEndOfBleedout(string eventName, string strArg, float numArg, Form sender)
	Debug.Trace("SD enslavement ready")
	Stop()
endEvent

; I edited the .esp to trigger this on stage 100. It was left empty. --BM
Function Stage_100()
	Utility.Wait(4.0) ; if we could know for sure that the player is ragdolling, we could wait for the event sent at the end of ragdoll. --BM
	
	ObjectReference thePlayer = Alias_thePlayer.GetRef()
	Actor akPlayer = thePlayer as Actor
	Actor akMaster = alias_theBandit.GetRef() as Actor
	
	Debug.SendAnimationEvent(akPlayer , "ZazAPC057")
	_SDKP_enslave.SendStoryEvent( akLoc = akMaster.GetCurrentLocation(), akRef1 = akMaster as Actor, akRef2 = akPlayer, aiValue1 = 0, aiValue2 = 0)
endFunction


Keyword Property _SDKP_enslave  Auto


