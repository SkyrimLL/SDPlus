;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 6
Scriptname _SDQF_DA_SprigganEnslave Extends Quest Hidden

;BEGIN ALIAS PROPERTY theLocMapMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theLocMapMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theSpriggan
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theSpriggan Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLocEntrance
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theLocEntrance Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLair
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theLair Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thisLair
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_thisLair Auto
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
; Message Property Prompt Auto


Event OnUpdate()
	SetStage(10)
endEvent


Function Stage_0()
	Debug.Trace("SD - DA - Spriggan defeat - Teleport To Lair Entrance")
	Util.WaitGameHours(Variables.BlackoutTimeLapse)

	RegisterForModEvent("da_EndBleedout", "EnslaveAtEndOfBleedout")
	RegisterForSingleUpdate(2.0)
endFunction


Function Stage_10()
	; Prompt.Show()
	; SendModEvent("da_StartSecondaryQuest", "Both")
	SendModEvent("da_StartRecoverSequence")
endFunction

Event EnslaveAtEndOfBleedout(string eventName, string strArg, float numArg, Form sender)
	Debug.Trace("SD Spriggan enslavement ready")
	Stop()
endEvent

Function Stage_100()
	Actor akPlayer = Alias_thePlayer.GetRef() as Actor
	Actor akMaster = Alias_theSpriggan.GetRef() as Actor
	; Alias_thePlayer.GetRef().MoveTo(Alias_theMarker.GetRef())

	Debug.Notification("[SD DA integration] You are stripped and covered in roots...")

	Utility.Wait(4.0) ; if we could know for sure that the player is ragdolling, we could wait for the event sent at the end of ragdoll. --BM
	
	; Debug.SendAnimationEvent(akPlayer , "ZazAPC057")
	Debug.SendAnimationEvent(akPlayer , "ZazAPC231")

	_SDKP_spriggan.SendStoryEvent(akRef1 = akMaster, akRef2 = akPlayer, aiValue1 = 0, aiValue2 = 0)

endFunction


Keyword Property _SDKP_spriggan  Auto


