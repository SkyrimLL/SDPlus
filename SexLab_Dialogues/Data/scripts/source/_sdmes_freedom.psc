Scriptname _SDMES_freedom extends activemagiceffect  

_SDQS_functions Property funct  Auto

FormList Property _SDFLP_punish_items  Auto
FormList Property _SDFLP_sex_items  Auto  
FormList Property _SDFLP_master_items  Auto  

; This spell is now useless but it is called in many places related to slavery
; Keeping it in place for now in case we need to cast a spell after enslavement later on

Event OnEffectStart(Actor akTarget, Actor akCaster)
;	funct.removeItemsInList( akTarget, _SDFLP_master_items )
;	funct.removeItemsInList( akTarget, _SDFLP_punish_items )
;	funct.removeItemsInList( akTarget, _SDFLP_sex_items )

EndEvent
