;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_snp_18 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kSlave = _SDRAP_slave.GetReference() as Actor
ObjectReference kRags = _SDAP_clothing.GetReference() as  ObjectReference 

If ( kSlave.GetItemCount( kRags ) == 0 )
	; kSlave.AddItem( kRags, 1, True)
	akSpeaker.AddItem( kRags, 1, True)
Else
	kSlave.RemoveItem( kRags, 1, False, akSpeaker)
EndIf
; kSlave.EquipItem( kRags.GetBaseObject() )

akSpeaker.ShowGiftMenu(false, _SDFL_Clothing)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property _SDRAP_slave  Auto  
ReferenceAlias Property _SDAP_clothing  Auto  

FormList  Property _SDFL_Clothing  Auto  
