;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname _sdtif_release_01vag Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_4
Function Fragment_4(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = _SDRAP_player.GetReference() as Actor

Game.GetPlayer().RemoveItem(Gold, 100 )

; fctOutfit.setDeviousOutfitPlugVaginal(  bDevEquip = False, sDevMessage = "Now relax and it won't hurt much.")
fctOutfit.clearDeviceByString ( sDeviceString = "ParasiteVaginal", sOutfitString = "Parasite"  )


funct.SanguineRape(  akSpeaker, Game.GetPlayer() , SexLabInTags = "Fisting")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_functions Property funct  Auto

FormList Property _SDFLP_sex_items  Auto
FormList Property _SDFLP_punish_items  Auto
Spell Property _SDSP_freedom  Auto  
ReferenceAlias Property _SDRAP_player  Auto  

_sdqs_fcts_outfit Property fctOutfit  Auto  

MiscObject Property Gold  Auto  
