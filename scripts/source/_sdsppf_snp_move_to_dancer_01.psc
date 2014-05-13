;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _SDSPPF_snp_move_to_dancer_01 Extends Package Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(Actor akActor)
;BEGIN CODE
ObjectReference kFemale = _SDRAP_female.GetReference() as ObjectReference
ObjectReference kGold = akActor.DropObject( _SDMOP_gold, Utility.RandomInt( 1,4 ) )
kGold.SetActorOwner( ( kFemale as Actor ).GetActorBase() )
kGold.MoveTo(kFemale, -50 + Utility.RandomInt(0, 100), -50 + Utility.RandomInt(0, 100), Math.Floor(kFemale.GetHeight()/4) )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

MiscObject Property _SDMOP_gold  Auto  
ReferenceAlias Property _SDRAP_female  Auto  
