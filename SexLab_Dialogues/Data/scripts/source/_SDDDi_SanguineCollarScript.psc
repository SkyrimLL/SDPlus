Scriptname _SDDDi_SanguineCollarScript extends zadRestraintScript  

Function OnEquippedPre(actor akActor, bool silent=false)
	if !silent
		libs.NotifyActor("You slip the collar around "+GetMessageName(akActor)+" neck, and it locks in place with a soft click.", akActor, true)
	EndIf
	Parent.OnEquippedPre(akActor, silent)
EndFunction

Function OnEquippedPost(actor akActor)
	libs.Log("RestraintScript OnEquippedPost Collar")
	
EndFunction

Function OnUnEquippedPost(actor akActor)
	Utility.Wait(5)
	akActor.RemoveItem(deviceInventory, 1, true)
EndFunction
