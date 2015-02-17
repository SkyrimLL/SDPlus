;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_Blacksmith10 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
String sMessage ="Remember, an expert practices until he gets it right.. a master practices until he cannot get it wrong.\n"

sMessage = sMessage + "\nArmor Crafted: " + Game.QueryStat("Armor Made") + " (" + Game.QueryStat("Armor Improved")   + ")"
sMessage = sMessage + "\nWeapons Crafted: " + Game.QueryStat("Weapons Made") + " (" + Game.QueryStat("Weapons Improved")  + ")"

Debug.MessageBox( sMessage )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
