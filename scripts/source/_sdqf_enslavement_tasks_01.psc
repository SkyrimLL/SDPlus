;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 27
Scriptname _sdqf_enslavement_tasks_01 Extends Quest Hidden

;BEGIN ALIAS PROPERTY _SDRA_slave
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_slave Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_master
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_master Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN CODE
Self.CompleteAllObjectives()
Self.SetObjectiveDisplayed(10, False)
Self.SetObjectiveDisplayed(20, False)

Actor slave = Alias__SDRA_slave.GetReference() as Actor
Actor master = Alias__SDRA_master.GetReference() as Actor
ObjectReference bindings =_SDRAP_bindings.GetReference() as ObjectReference
ObjectReference shackles = _SDRAP_shackles.GetReference() as ObjectReference

If ( _SDGVP_demerits.GetValue() as Int) > Math.Abs( 2 * ( _SDGVP_demerits.GetValue() as Int) / 3)
    _SDKP_trust_hands.SetValue(1)
Else
    _SDKP_trust_hands.SetValue(0)
EndIf

Reset()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
Actor kMaster = Alias__SDRA_master.GetReference() as Actor
Actor kSlave = Alias__SDRA_slave.GetReference() as Actor

; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValue() as Int ) )
; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 1 )
;_SDQP_enslavement.ModObjectiveGlobal( -1.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

Self.CompleteAllObjectives()
Self.SetObjectiveDisplayed(10, False)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN CODE
Self.CompleteAllObjectives()
Self.SetObjectiveDisplayed(10, False)
Self.SetObjectiveDisplayed(20, False)

Actor slave = Alias__SDRA_slave.GetReference() as Actor
Actor master = Alias__SDRA_master.GetReference() as Actor
ObjectReference bindings =_SDRAP_bindings.GetReference() as ObjectReference
ObjectReference shackles = _SDRAP_shackles.GetReference() as ObjectReference

_SDKP_trust_hands.SetValue(0)


Reset()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
Actor kMaster = Alias__SDRA_master.GetReference() as Actor
Actor kSlave = Alias__SDRA_slave.GetReference() as Actor

;_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValue() as Int ) )
;_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 1 )
; _SDQP_enslavement.ModObjectiveGlobal( 1.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

_SDKP_trust_hands.SetValue(0)

Self.FailAllObjectives()
Self.SetObjectiveDisplayed(20, False)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Debug.Trace("_SD::" + Self + " at stage " + Self.GetStage()+ " fail")
Actor kMaster = Alias__SDRA_master.GetReference() as Actor
Actor kSlave = Alias__SDRA_slave.GetReference() as Actor

;_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValue() as Int ) )
;_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 1 )
; _SDQP_enslavement.ModObjectiveGlobal( 1.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )


Self.FailAllObjectives()
Self.SetObjectiveDisplayed(10, False)
Self.SetStage( 12 )
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
Actor kMaster = Alias__SDRA_master.GetReference() as Actor
Actor kSlave = Alias__SDRA_slave.GetReference() as Actor

;_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValue() as Int ) )
; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 1 )
; _SDQP_enslavement.ModObjectiveGlobal( -1.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

_SDKP_trust_hands.SetValue(1)

Self.CompleteAllObjectives()
Self.SetObjectiveDisplayed(20, False)
Self.SetStage( 22 )
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_24
Function Fragment_24()
;BEGIN CODE
Actor slave = Alias__SDRA_slave.GetReference() as Actor
Actor master = Alias__SDRA_master.GetReference() as Actor
ObjectReference bindings =_SDRAP_bindings.GetReference() as ObjectReference
ObjectReference shackles = _SDRAP_shackles.GetReference() as ObjectReference

_SDKP_trust_hands.SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property _SDQP_enslavement  Auto  

Keyword Property _SDKP_sex  Auto  
GlobalVariable Property _SDGVP_positions  Auto  
GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_config_verboseMerits  Auto

ReferenceAlias Property _SDRAP_bindings Auto
ReferenceAlias Property _SDRAP_shackles Auto
 
GlobalVariable Property _SDKP_trust_hands  Auto  

GlobalVariable Property _SDKP_trust_feet  Auto  

Keyword Property _SDKP_wrists  Auto  

Keyword Property _SDKP_ankles  Auto  
