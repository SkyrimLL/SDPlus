Scriptname SLD_beastFollowerScript extends ReferenceAlias  

GlobalVariable Property _SLD_BeastDialogueON Auto  

; DialogueFollowerScript Property DialogueFollower Auto
GlobalVariable Property _SLD_GiftDialogueON Auto  
Message Property _SLD_beastMenu  Auto  

SLD_QST_Main Property fctDialogue  Auto
SLD_PlayerAlias Property _SLD_Player Auto
SPELL Property RestSpell  Auto  
FormList Property _SLD_GiftFilter  Auto  

;Actor property dog auto

event onActivate(objectReference AkActivator)
	ObjectReference kActorRef = self.GetReference()
	Actor kActor = kActorRef as Actor

	If (_SLD_BeastDialogueON.GetValue() == 0)
		Return
	EndIf
	
	If (kActor.IsDead())
		Debug.Trace( "[SLD] Attemping to activate a dead creature." )
		Return
	EndIf

	;if player does not have an animal, make this animal player's animal
	;	(DialogueFollower as DialogueFollowerScript).SetAnimal(kActor )
	kActor.AllowPCDialogue(true)
	; kActor.SetHeadTracking(true)
	fctDialogue.SetNPCDialogueState ( kActor )
 
	; If creature doesn't allow punishments, disable forced collar stance

	Debug.Trace("[SLD] 	Debug - Actor current package: " + kActor.GetCurrentPackage())

	; Test popup message
	; StorageUtil.SetIntValue(Game.GetPlayer(), "_SD_iDisablePlayerAutoKneeling", 1)
	; StorageUtil.SetIntValue(Game.GetPlayer(), "_SD_iEnableStand", 1)
	; StorageUtil.SetIntValue(Game.GetPlayer(), "_SD_iEnableKneel", 1)
	; StorageUtil.SetIntValue(Game.GetPlayer(), "_SD_iEnableCrawl", 1)

	; Debug.Messagebox("You catch their attention.")

	Int IButton = _SLD_beastMenu.Show()

	If IButton == 0 ; Show the thing.
		; 1-Roll over (Submit)
		_beastSex(kActor)

	ElseIf IButton == 1
		; 2-Beg (Hungry)
		_beastHungry(kActor)

	ElseIf IButton == 2
		; 3-Whine (Tired)
		_beastSleepy(kActor)

	ElseIf IButton == 3
		; 4-Fetch (Gift)
		_beastGift(kActor)

	ElseIf IButton == 4
		; 5-Exit
	Endif

endEvent



Function _beastSex(Actor akSpeaker)
	Actor kPlayer = Game.getPlayer()

	StorageUtil.SetIntValue( kPlayer , "_SD_iSub", StorageUtil.GetIntValue( kPlayer, "_SD_iSub") + 1)

	If (Utility.RandomInt(0,100)>70)
		StorageUtil.SetFloatValue(kPlayer, "_SD_iNextSexTime", 0.0)
	Endif

	akSpeaker.SendModEvent("PCSubSex") ; Sex

EndFunction


Function _beastHungry(Actor akSpeaker)
	_SLD_Player.GiftFromNPC(akSpeaker, "Hungry")
EndFunction

Function _beastSleepy(Actor akSpeaker)
	Actor kPlayer = Game.getPlayer()

	StorageUtil.SetIntValue(  kPlayer, "_SD_iSleepType",3)
	RestSpell.Cast( kPlayer )
EndFunction

Function _beastGift(Actor akSpeaker)
	akSpeaker.ShowGiftMenu( True, _SLD_GiftFilter, True )
EndFunction
