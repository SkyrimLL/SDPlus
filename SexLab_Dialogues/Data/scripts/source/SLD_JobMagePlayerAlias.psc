Scriptname SLD_JobMagePlayerAlias extends ReferenceAlias  

Quest Property JobMageQuest  Auto  

GlobalVariable Property _SLD_jobMageON Auto  
GlobalVariable Property _SLD_jobMageMastery Auto  
GlobalVariable Property _SLD_MagickaMasteryON Auto  

ObjectReference Property _SLD_SkyShardRef  Auto  
ReferenceAlias Property _SLD_SkyShardRefAlias  Auto  

Potion Property RejuvenationPotion  Auto  
Keyword Property RejuvenationPotionKeyword  Auto  

Spell Property PotionToxicityDiseaseLow  Auto  
Spell Property PotionToxicityDiseaseHigh  Auto  
Spell Property PotionToxicityDiseaseImmunity  Auto  
MagicEffect Property METoxicityDiseaseLow  Auto  
MagicEffect Property METoxicityDiseaseHigh  Auto  
MagicEffect Property METoxicityDiseaseImmunity  Auto  

Int iRejuvenationPotionCount = 0
Int iNumberPotionsToday
Int iLastNumberPotionsUsed = -1


int daysPassed
int iGameDateLastCheck = -1
int iDaysSinceLastCheck
int iDebtLastCheck

Event OnPlayerLoadGame()

	_maintenance()
	RegisterForSingleUpdate(10)

EndEvent

Event Init()

	_maintenance()
	RegisterForSingleUpdate(10)

EndEvent

Function _maintenance()
	Actor PlayerActor = Game.GetPlayer()
	StorageUtil.SetIntValue( PlayerActor , "_SLD_jobMageMastery", _SLD_jobMageMastery.GetValue() as Int)

	UnregisterForAllModEvents()
	RegisterForModEvent("SLDRefreshMagicka",   "OnSLDRefreshMagicka")
	RegisterForModEvent("SLDRefreshMageMastery",   "OnSLDRefreshMageMastery")

	_updateMagicka() 
	_updateMageMastery()

	; Fixing missing aliases from baked in game/quest
	if (_SLD_SkyShardRefAlias.GetReference() == None)
		debug.notification("Fixing missing Sky Shard ref " + _SLD_SkyShardRef)
		_SLD_SkyShardRefAlias.ForceRefTo(_SLD_SkyShardRef)
	Endif

	; Initialize potions count for today
	If (iLastNumberPotionsUsed == -1)
		iLastNumberPotionsUsed = Game.QueryStat("Potions Used")
	EndIf

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
	_updateMageMastery()
EndEvent

Event OnSleepStop(bool abInterrupted)
	_updateMagicka()
	_updateMageMastery()
endEvent

Event OnUpdate()
 	Actor PlayerActor= Game.GetPlayer() as Actor
	Location currentLocation = Game.GetPlayer().GetCurrentLocation()

	If  !Self || (_SLD_jobMageON.GetValue()==0)
		Return
	EndIf

 	daysPassed = Game.QueryStat("Days Passed")

 	; Initial values
 	if (iGameDateLastCheck == -1)
 		iGameDateLastCheck = daysPassed
 	endIf
 
	iDaysSinceLastCheck = (daysPassed - iGameDateLastCheck ) as Int

	If (iDaysSinceLastCheck > 0)
		; New day
		iNumberPotionsToday=0
		iLastNumberPotionsUsed = Game.QueryStat("Potions Used")

	else
		_updateMagicka()
		_updateMageMastery()

	endIf

	iGameDateLastCheck = daysPassed  

	RegisterForSingleUpdate(10)
EndEvent


Function _updateMagicka(Int iBonus = 1)
	Actor PlayerActor = Game.GetPlayer()
	Float fJobMageMastery = 1.0 + (_SLD_jobMageMastery.GetValue() as Float)
	float fPlayersHealthPercent = PlayerActor.GetActorValuePercentage("health") 
	Int iAVMod
	Int iPotionToxicityTolerance
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
		fAVMod = 200.0
	EndIf 
		
	PlayerActor.ForceAV("MagickaRate", fAVMod )

	iNumberPotionsToday= iLastNumberPotionsUsed - Game.QueryStat("Potions Used")

	iPotionToxicityTolerance = 1 + (Game.QueryStat("Potions Used") / Game.QueryStat("Days Passed"))  + ((fJobMageMastery as Int) / 40)

	if (fJobMageMastery < 100)
		if (iNumberPotionsToday > (iPotionToxicityTolerance * 2) ) && (!PlayerActor.HasMagicEffect(METoxicityDiseaseHigh))
			Debug.MessageBox("You contracted Rockjoint from drinking too many potions in a day.")
			PotionToxicityDiseaseHigh.RemoteCast(PlayerActor as ObjectReference, PlayerActor, PlayerActor as ObjectReference)
			
		elseif (iNumberPotionsToday > iPotionToxicityTolerance ) && (!PlayerActor.HasMagicEffect(METoxicityDiseaseLow))
			Debug.MessageBox("You contracted the Rattles from drinking too many potions in a day.")
			PotionToxicityDiseaseLow.RemoteCast(PlayerActor as ObjectReference, PlayerActor, PlayerActor as ObjectReference)
			
		Endif
	else
		if (!PlayerActor.HasMagicEffect(METoxicityDiseaseImmunity))
			PotionToxicityDiseaseImmunity.RemoteCast(PlayerActor as ObjectReference, PlayerActor, PlayerActor as ObjectReference)
			
		Endif
	EndIf

	Debug.Trace("[SLD] Magicka: " + iAVMod)
	Debug.Trace("[SLD] MagickaRate: " + fAVMod)
	Debug.Trace("[SLD] iNumberPotionsToday: " + iNumberPotionsToday)
	Debug.Trace("[SLD] iPotionToxicityTolerance: " + iPotionToxicityTolerance)
	Debug.Trace("[SLD] fJobMageMastery: " + fJobMageMastery)
	Debug.Trace("[SLD] fPlayersHealthPercent: " + fPlayersHealthPercent) 
EndFunction

Function _updateMageMastery(Int iBonus = 1)
	Actor PlayerActor = Game.GetPlayer()
	Int iJobMageMastery = 0
	float fPlayersHealthPercent = PlayerActor.GetActorValuePercentage("health") 
	Int iAVMod
	Float  fAVMod

	If (_SLD_jobMageON.GetValue()==0)
		return
	endif

	; Favorite Spell -    The spell that is most often used.
	; Favorite School - The school of magic that is most often used.
	; Times Shouted -     
	; Favorite Shout    - The shout that is most often used.

	; Skill Books Read / Books Read - measure of scholar
	iJobMageMastery = iJobMageMastery + Game.QueryStat("Skill Books Read")
	iJobMageMastery = iJobMageMastery + Game.QueryStat("Books Read") / 2
	; College of Winterhold Quests Completed - Useful for magicka mastery
	iJobMageMastery = iJobMageMastery + Game.QueryStat("College of Winterhold Quests Completed") * 2
	; Daedric Quests Completed - useful to unlock Necromancy path
	iJobMageMastery = iJobMageMastery + Game.QueryStat("Daedric Quests Completed") * 5
	; Spells Learned - Reading a spell tome is all that is required to learn a spell.
	iJobMageMastery = iJobMageMastery + Game.QueryStat("Spells Learned")
	; Dragon Souls Collected -    Souls collected from slain dragons.
	iJobMageMastery = iJobMageMastery + Game.QueryStat("Dragon Souls Collected") * 2
	; Words of Power Learned -    Words are either learnt from Word Walls or from individuals such as the Greybeards or Durnehviir.
	iJobMageMastery = iJobMageMastery + Game.QueryStat("Words of Power Learned") * 3
	; Words of Power Unlocked - Word are only unlocked when a Dragon Soul is spent to unlock it.
	iJobMageMastery = iJobMageMastery + Game.QueryStat("Words of Power Unlocked") * 5
	; Shouts Learned    - Learning a shout means that at least one of the three Words of Power is known for a specific shout.
	iJobMageMastery = iJobMageMastery + Game.QueryStat("Shouts Learned") * 2
	; Shouts Mastered    - Mastery is achieved by unlocking all three Words of Power of a shout.
	iJobMageMastery = iJobMageMastery + Game.QueryStat("Shouts Mastered") * 5
	; Soul Gems Used -    Defined as either to recharge a weapon or enchant an item.
	iJobMageMastery = iJobMageMastery + Game.QueryStat("Soul Gems Used")
	; Souls Trapped -    Souls can only be trapped with the Soul Trap spell or with a weapon that bears the soul trap enchantment.
	iJobMageMastery = iJobMageMastery + Game.QueryStat("Souls Trapped") * 2
	; Magic Items -  Made    Number of items made via Enchanting.
	iJobMageMastery = iJobMageMastery + Game.QueryStat("Magic Items Made") / 2
	; Potions Mixed -    Number of potions made at an alchemy lab
	iJobMageMastery = iJobMageMastery + Game.QueryStat("Potions Mixed") / 2
	; Potions Used    - Could be useful for potion toxicity
	iJobMageMastery = iJobMageMastery + Game.QueryStat("Potions Used") / 5
	; Ingredients Eaten - Learn magic effects
	iJobMageMastery = iJobMageMastery + Game.QueryStat("Ingredients Eaten") / 5

	_SLD_jobMageMastery.SetValue(iJobMageMastery)
	StorageUtil.SetIntValue( PlayerActor , "_SLD_jobMageMastery", iJobMageMastery)

	Debug.Trace("[SLD] Mage Mastery: " + iJobMageMastery)
EndFunction



