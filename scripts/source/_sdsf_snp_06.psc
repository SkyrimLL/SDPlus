;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname _sdsf_snp_06 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
_SDGVP_snp_busy.SetValue(6)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Int idx = 0
Int itemCount = 0

Actor female = _SDRAP_female.GetReference() as Actor
ObjectReference bindings = _SDRAP_bindings.GetReference() as ObjectReference

if  bindings
	itemCount = female.GetItemCount( bindings.GetBaseObject() )
	If ( itemCount && _SDQP_enslavement.GetStage() >= 20 )
		female.RemoveItem( bindings, itemCount )
	EndIf
EndIf


While idx < _SDFLP_punish_items.GetSize()
	itemCount = female.GetItemCount( _SDFLP_punish_items.GetAt(idx) )
	If ( itemCount )
		female.RemoveItem( _SDFLP_punish_items.GetAt(idx), itemCount )
	EndIf
	idx += 1
EndWhile

_SDGVP_snp_busy.SetValue(-1)
Self.GetowningQuest().Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property _SDQP_enslavement  Auto  
ReferenceAlias Property _SDRAP_bindings  Auto  
ReferenceAlias Property _SDRAP_female  Auto  
FormList Property _SDFLP_punish_items  Auto  

GlobalVariable Property _SDGVP_snp_busy  Auto  
