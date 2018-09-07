Scriptname _SDDDi_SanguineArtifactScript extends zadEquipScript
Keyword Property zad_DeviousBelt Auto

string strFailEquip =  "Try as you might, the belt you are wearing prevents you from inserting these plugs."

int Function OnEquippedFilter(actor akActor, bool silent=false)
	; FTM optimization
	if silent && akActor != libs.PlayerRef
		return 0
	EndIf
	if akActor.WornHasKeyword(zad_DeviousBelt)
		; if akActor == libs.PlayerRef && !silent
		;	libs.NotifyActor(strFailEquip, akActor, true)
		; ElseIf  !silent
		;	libs.NotifyActor("The belt " + akActor.GetLeveledActorBase().GetName() + " is wearing prevents you from inserting these plugs.", akActor, true)
		; EndIf
		; return 2
	Endif
	return 0
EndFunction

Function OnEquippedPre(actor akActor, bool silent=false)
	string msg = ""
	if akActor == libs.PlayerRef
		if Aroused.GetActorExposure(akActor) < libs.ArousalThreshold("Desire")
			msg = "Your holes are now filled, as is your desire for pleasure."
		elseif Aroused.GetActorExposure(akActor) < libs.ArousalThreshold("Horny")
			msg = "You slowly insert the plugs inside your body openings, your lust growing with every inch they slide in."
		elseif Aroused.GetActorExposure(akActor) < libs.ArousalThreshold("Desperate")
			msg = "You insert the plugs inside your openings and take great delight in the resulting feelings of pleasure."
		else
			msg = "Barely in control of control your own body you thrust the plugs almost forcefully into the appropriate openings."
		endif
	else
		msg = akActor.GetLeveledActorBase().GetName() + " shudders as you push the plugs in to her."
	EndIf
	if !silent
		libs.NotifyActor(msg, akActor, true)
	EndIf
EndFunction


Function OnEquippedPost(actor akActor)
	Utility.Wait(5)
	bool legacyPlugs = false
	; Slots 48 and 54 Anal and Vaginal plugs      
	Form analSlot = akActor.GetWornForm(0x00040000)
	Form vagSlot = akActor.GetWornForm(0x01000000)
	if analSlot && vagSlot && analSlot == vagSlot
		legacyPlugs = true
	EndIf
	if ((!akActor.WornHasKeyword(zad_DeviousBelt))  || (akActor.WornHasKeyword(zad_DeviousBelt) && akActor.WornHasKeyword(libs.zad_PermitAnal) && !legacyPlugs && deviceRendered.HasKeyword(libs.zad_DeviousPlugAnal))) && akActor.WornHasKeyword(zad_DeviousDevice) && !akActor.WornHasKeyword(libs.zad_EffectPossessed) && akActor == libs.PlayerRef && akActor.GetActorBase().GetSex() != 0
		; libs.Log("Belt not worn: Removing plugs.")
		; RemoveDevice(akActor)
		; if akActor == libs.PlayerRef
		;	libs.NotifyPlayer("Lacking a belt to hold them in, the plugs slide out of you.")
		; else
		;	libs.NotifyNPC("Lacking a belt to hold them in, the plugs slide out of "+akActor.GetLeveledActorBase().GetName()+".")
		;	akActor.RemoveItem(deviceInventory, 1, true)
		;	libs.PlayerRef.AddItem(deviceInventory, 1, true)
		; EndIf
	EndIf
EndFunction


int Function OnUnequippedFilter(actor akActor)
	if akActor.WornHasKeyword(zad_DeviousBelt)
	;	return 1
	EndIf
	; return 1
EndFunction

Function OnUnEquippedPost(actor akActor)
	Utility.Wait(5)
	akActor.RemoveItem(deviceInventory, 1, true)
EndFunction

Function DeviceMenu(Int msgChoice = 0)
        msgChoice = zad_DeviceMsg.Show() ; display menu
	if msgChoice==0 ; Not wearing a belt, no plugs
	;	Debug.Notification("You choose to put the plugs in.")
		libs.EquipDevice(libs.PlayerRef, deviceInventory, deviceRendered, zad_DeviousDevice)
	elseif msgChoice==1 ; Wearing a belt, no plugs
		Debug.MessageBox(strFailEquip)
	elseif msgChoice==2 ; Not wearing a belt, plugs
		NoKeyFailMessage(libs.PlayerRef) ; Sanguine's artifact cannot be removed by hand.
	elseif msgChoice==3 ; Wearing a belt, plugs
		NoKeyFailMessage(libs.PlayerRef)
	Endif
	DeviceMenuExt(msgChoice)
	SyncInventory()
EndFunction
		

Function NoKeyFailMessage(Actor akActor)
	if akActor == libs.PlayerRef
		libs.NotifyPlayer("Try as you might, the glowing rings seem magically bound to your very skin.", true)
	Else
		; libs.NotifyNPC("The belt that "+akActor.GetLeveledActorBase().GetName() + " is wearing is securely locking these plugs in place. You must remove it prior to removing them.", true)
	EndIf
EndFunction
