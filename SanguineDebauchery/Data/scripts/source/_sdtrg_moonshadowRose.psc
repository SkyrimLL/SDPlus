Scriptname _sdtrg_moonshadowRose extends ObjectReference  

ObjectReference Property TwilightGuardianRef  Auto  
ObjectReference Property SanguineRoseRef  Auto  
ObjectReference Property TempStorageRef  Auto  
Faction Property WEPlayerFriend  Auto  
Faction Property WEPlayerEnemy  Auto  
Quest Property _SD_dreamQuest  Auto  
Actor Property pClone auto 
ReferenceAlias Property tempFollowerAlias  Auto  

ObjectReference pCloneRef
ObjectReference arPortal

Bool bCloneFound = False

Event OnTriggerEnter(ObjectReference akActionRef)
	Actor akPlayer =  Game.GetPlayer() 
	Actor akTwilightGuardian = TwilightGuardianRef as Actor
	Form fSanguineRose = SanguineRoseRef as Form

	akTwilightGuardian.RemoveFromFaction(WEPlayerFriend)
	akTwilightGuardian.AddToFaction(WEPlayerEnemy)

	If ((StorageUtil.GetIntValue(fSanguineRose, "_SD_iRandomRose") == 1) && (!bCloneFound))
		; Debug.MessageBox("This is the one!")
		arPortal = SanguineRoseRef.PlaceAtMe(Game.GetFormFromFile(0x0007CD55, "Skyrim.ESM")) 
		Utility.wait( 3.0 )
		; testObject = Game.GetForm(0xBA0CB) as ObjectReference		
		bCloneFound = True
		pClone = SanguineRoseRef.PlaceAtMe(Game.GetForm(0x00000007)) as Actor
		pCloneRef = pClone as ObjectReference

		pClone.RemoveAllItems(akTransferTo = TempStorageRef, abKeepOwnership = True)
		
		pClone.SetRelationShipRank(akPlayer, 4); Because one loves him/herself
		pClone.AllowPCDialogue(false)	
		pClone.SetPlayerTeammate()
		;pClone.AddToFaction(CurrentFollowerFaction)
		;pClone.SetFactionRank(CurrentFollowerFaction, -1)
		;DialogueFollower.SetFollower(clone as ObjectReference)
		;FollowerAlias.ForceRefTo(pClone)
		pClone.EvaluatePackage()
		tempFollowerAlias.ForceRefTo(pClone)
		SanguineRoseRef.Disable()

		Debug.Messagebox("The rose reacts to your presence and lets go of your soul shard. Wait until it is fully materialized before returning back to Sanguine.")

		pClone.SetAlpha(0.5)
		Utility.wait( 5.0 )

		pClone.SetAlpha(0.7, true)
		Utility.wait( 10.0 )

		pClone.SetAlpha(0.9, true)
		Utility.wait( 15.0 )

		pClone.SetAlpha(1.0, true)

		arPortal = pCloneRef.PlaceAtMe(Game.GetFormFromFile(0x0007CD55, "Skyrim.ESM")) 
		Utility.wait( 3.0 )
		_SD_dreamQuest.SetStage(256)
		SendModEvent("SDDreamworldPull")
	Endif

	; Debug.MessageBox("You chose poorly.")

EndEvent