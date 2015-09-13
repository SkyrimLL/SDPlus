;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 7
Scriptname _sdqf_DA_Dreamworld Extends Quest Hidden

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
Stage_0()
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

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
Stage_100()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
Stage_20()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_functions Property funct  Auto
Quest Property _SD_dreamQuest  Auto

Event OnUpdate()
	if(GetStage() == 0)
		SetStage(10)
	endif

	; if(!alias_thePriest.GetRef().IsNearPlayer())
	;	Stop()
	; endif
endEvent


Function Stage_0()
	Debug.Trace("daymoyl - Teleported to Dreamworld")
	; Alias_thePlayer.GetRef().MoveTo(Alias_theTempleCenter.GetRef())
	; Alias_thePriest.GetRef().MoveTo(Alias_thePlayer.GetRef())
	RegisterForSingleUpdate(2.0)
endFunction


Function Stage_10()
	; Alias_thePriest.GetActorRef().AddSpell(HealingHand)
	; PriestScene.Start()
	; Alias_thePriest.GetActorRef().EvaluatePackage()

	SetStage(20)
	RegisterForUpdate(10.0)	
endFunction


Function Stage_20()
	; alias_thePlayer.GetRef().AddItem(HealthPotion)
	SetStage(100)
	RegisterForUpdate(10.0)
endFunction


Function Stage_100()
	_SD_dreamQuest.SetStage(100)
	UnRegisterForUpdate()
endFunction
