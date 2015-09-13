Scriptname _SDDDi_SprigganCuirassScript extends zadBeltScript  

Function OnEquippedPre(actor akActor, bool silent=false)
	if !silent
		if akActor == libs.PlayerRef
		;	libs.NotifyActor("You step in to the harness, securing it tightly against your body.", akActor, true)
		Else
		;	libs.NotifyActor(GetMessageName(akActor) +" steps in to the harness, securing it tightly against her body.", akActor, true)
			
		EndIf
	EndIf
	Parent.OnEquippedPre(akActor, silent=true)
EndFunction

int Function OnEquippedFilter(actor akActor, bool silent=false)
	if akActor == none
		akActor == libs.PlayerRef
	EndIf
	return 0
EndFunction

Function OnUnEquippedPost(actor akActor)
	Utility.Wait(5)
	akActor.RemoveItem(deviceInventory, 1, true)
EndFunction


Function OnEquippedPost(actor akActor)
	; libs.Log("RestraintScript OnEquippedPost BodyHarness")
	Parent.OnEquippedPost(akActor)
EndFunction

Function DeviceMenuExt(Int msgChoice)

EndFunction