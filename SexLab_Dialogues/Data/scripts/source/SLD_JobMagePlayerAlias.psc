Scriptname SLD_JobMagePlayerAlias extends ReferenceAlias  

GlobalVariable Property _SLD_jobMageON Auto  
GlobalVariable Property _SLD_jobMageMastery Auto  
GlobalVariable Property _SLD_MagickaMasteryON Auto  

Potion Property RejuvenationPotion  Auto  
Keyword Property RejuvenationPotionKeyword  Auto  

Int iRejuvenationPotionCount = 0

Event OnPlayerLoadGame()

	_maintenance()

EndEvent

Event Init()

	_maintenance()

EndEvent

Function _maintenance()
	Actor PlayerActor = Game.GetPlayer()
	StorageUtil.SetIntValue( PlayerActor , "_SLD_jobMageMastery", _SLD_jobMageMastery.GetValue() as Int)

	UnregisterForAllModEvents()
	RegisterForModEvent("SLDRefreshMagicka",   "OnSLDRefreshMagicka")
	RegisterForModEvent("SLDRefreshMageMastery",   "OnSLDRefreshMageMastery")

	RegisterForSleep()
EndFunction

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	  ; debug.Notification(" Player receives  " + aiItemCount + "x " + akBaseItem + " from the world")
	  if (akBaseItem != None)
		  ; debug.Notification(" Player receives  " + akBaseItem.GetName() )
		  ; debug.Notification(" Is object a rejunevation potion  " + akBaseItem.HasKeyword(RejuvenationPotionKeyword))

	      If ( akBaseItem.GetName() == "Potion of Rejuvenation"  )
	      ;  akActor.Equipitem(HypnosisCirclet)
	      	; Debug.Notification("Rejuvenation potion crafted.")
	      	If (JobMageQuest.GetStageDone(65)==1) && (JobMageQuest.GetStageDone(70)==0)
	      		iRejuvenationPotionCount = iRejuvenationPotionCount + 1
	      		if (iRejuvenationPotionCount==10)
	      			JobMageQuest.SetStage(68)
	      		endif
	      	endif
	      EndIf
	  endif
EndEvent

Event OnSLDRefreshMagicka(String _eventName, String _args, Float _argc, Form _sender)
 	Actor kActor = _sender as Actor
	Int iBonus = _argc as Int
	String iEventString = _args


	_updateMagicka(iBonus) 
EndEvent

Event OnSLDRefreshMageMastery(String _eventName, String _args, Float _argc, Form _sender)
 	Actor kActor = _sender as Actor
	Int iBonus = _argc as Int
	String iEventString = _args


	_updateMageMastery(iBonus) 
EndEvent

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	    if (aeCombatState == 0)
	      	; Debug.Trace("We have left combat with the NPC!")

			_updateMagicka()

	    elseif (aeCombatState == 1)
	      	; Debug.Trace("We have entered combat with the NPC!")
		
			_updateMagicka(20)

	    EndIf
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	_updateMagicka()
EndEvent

Event OnSleepStop(bool abInterrupted)
	_updateMagicka()
endEvent

Function _updateMagicka(Int iBonus = 1)
	Actor PlayerActor = Game.GetPlayer()
	Float fJobMageMastery = 1.0 + (_SLD_jobMageMastery.GetValue() as Float)
	float fPlayersHealthPercent = PlayerActor.GetActorValuePercentage("health") 
	Int iAVMod
	Float  fAVMod

	If (_SLD_jobMageON.GetValue()==0)
		return
	endif

	If (_SLD_MagickaMasteryON.GetValue()==0)
		return
	endif

	; Actor values - https://en.uesp.net/wiki/Tes5Mod:Actor_Value_Indices

	iAVMod = iBonus + ((10 * fJobMageMastery * (1.0 - fPlayersHealthPercent)) as Int )

	PlayerActor.ForceAV("Magicka", iAVMod)

	fAVMod = ((iBonus as Float) / 10.0) + ( (fJobMageMastery / 100.0)  +  (100.0 - (100 * fPlayersHealthPercent)) ) / 2.0

	If (fAVMod < 200.0)
		PlayerActor.ForceAV("MagickaRate", fAVMod )
	Else 
		PlayerActor.ForceAV("MagickaRate", 200.0)
	EndIf

EndFunction

Function _updateMageMastery(Int iBonus = 1)
	Actor PlayerActor = Game.GetPlayer()
	Float fJobMageMastery = 1.0 + (_SLD_jobMageMastery.GetValue() as Float)
	float fPlayersHealthPercent = PlayerActor.GetActorValuePercentage("health") 
	Int iAVMod
	Float  fAVMod

	If (_SLD_jobMageON.GetValue()==0)
		return
	endif



EndFunction


Quest Property JobMageQuest  Auto  
