;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_enslavement_00 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor slave = Alias__SDRA_slave.GetReference() as Actor
Actor master = Alias__SDRA_master.GetReference() as Actor
ObjectReference bindings =_SDRAP_bindings.GetReference() as ObjectReference
ObjectReference shackles = _SDRAP_shackles.GetReference() as ObjectReference

if Game.GetPlayer().IsInFaction(SexLabAnimatingFaction)
     Debug.Notification("SexLab cleanup: removing player from animating faction")
    Game.GetPlayer().RemoveFromFaction(SexLabAnimatingFaction)
endIf

If (_SDGVP_Ragdoll.GetValueInt() == 1 )
	_SDGVP_Ragdoll.SetValue( 0 )
EndIf

_SDGVP_passive_chance.SetValue(  50 - ( _SDGVP_demerits.GetValue() as Int)  )  
_SDGVP_anger_chance.SetValue( 50 + (_SDGVP_demerits.GetValue() as Int)  )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Faction Property SexLabAnimatingFaction  Auto  
ReferenceAlias Property _SDRAP_bindings Auto
ReferenceAlias Property _SDRAP_shackles Auto
ReferenceAlias Property Alias__SDRA_slave Auto
ReferenceAlias Property Alias__SDRA_master Auto

Keyword Property _SDKP_wrists  Auto  
Keyword Property _SDKP_ankles  Auto  

GlobalVariable Property _SDKP_trust_hands  Auto  

GlobalVariable Property _SDKP_trust_feet  Auto  

GlobalVariable Property _SDGVP_ragdoll  Auto  
GlobalVariable Property _SDGVP_passive_chance  Auto  
GlobalVariable Property _SDGVP_anger_chance  Auto  
GlobalVariable Property _SDGVP_demerits  Auto  
