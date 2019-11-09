Scriptname SLD_MCM_config extends ski_configbase  

Import sslCreatureAnimationSlots

GlobalVariable Property _SLD_PCSubShavedON  Auto  
GlobalVariable Property _SLD_CommentProbability Auto  
GlobalVariable Property _SLD_AttackProbability Auto  
GlobalVariable Property _SLD_BeggingProbability Auto
GlobalVariable Property _SLD_BeastDialogueON Auto  
GlobalVariable Property _SLD_PCDomDialogueON Auto  
GlobalVariable Property _SLD_PCSubDialogueON Auto  
GlobalVariable Property _SLD_RomanceDialogueON Auto  
GlobalVariable Property _SLD_PCSubEnableRobbery Auto  
GlobalVariable Property _SLD_BeggingDialogueON Auto  
GlobalVariable Property _SLD_GiftDialogueON Auto  
GlobalVariable Property _SLD_BeastMenuDialogueON Auto  
GlobalVariable Property _SLD_BlacksmithQuestON Auto  
GlobalVariable Property _SLD_MageQuestON Auto  
GlobalVariable Property _SLD_MagickaMasteryON Auto  
GlobalVariable Property _SLD_PriestQuestON Auto  

Book Property _SLD_debugSpell Auto

Int iAVMod
Float  fAVMod
; SexLabFramework     property SexLab Auto

; SCRIPT VERSION ----------------------------------------------------------------------------------
;
; NOTE:
; This is an example to show you how to update scripts after they have been deployed.
;
; History
;
; 1 - Initial version
; 2 - Added color option
; 3 - Added keymap option

int function GetVersion()
	return 201901 ; Default version
endFunction


; PRIVATE VARIABLES -------------------------------------------------------------------------------

; --- Version 1 ---

; State


float	_CommentProbability		= 30.0
float	_AttackProbability		= 30.0
float	_BeggingProbability		= 30.0
float	_BaseMagicka			= 0.0
bool	_BeastDialogueON		= true
bool	_PCDomDialogueON		= true
bool	_PCSubDialogueON		= true
bool	_PCSubShavedON		= true
bool	_RomanceDialogueON		= true
bool	_PCSubEnableRobbery		= false
bool	_BeggingDialogueON		= true
bool	_GiftDialogueON		= true
bool	_BeastMenuDialogueON		= true
bool	_BlacksmithQuestON		= false
bool	_MageQuestON		= false
bool	_MagickaMasteryON		= false
bool	_PriestQuestON		= false
bool	_RegisterCustomRaces		= false
bool	_ClearGiantRaces		= false
bool	_GetDebugSpell		= false

Actor PlayerActor 

; INITIALIZATION ----------------------------------------------------------------------------------

; @overrides SKI_ConfigBase
event OnConfigInit()
	Pages = new string[2]
	Pages[0] = "Features"
	Pages[1] = "Quests"

endEvent

; @implements SKI_QuestBase
event OnVersionUpdate(int a_version)
	{Called when a version update of this script has been detected}

	; Version 2 specific updating code
	if (a_version >= 201901 && CurrentVersion < 201901)
		Pages = new string[3]
		Pages[0] = "Features"
		Pages[1] = "Quests"
		Pages[2] = "Debug"
	endIf


endEvent


; EVENTS ------------------------------------------------------------------------------------------

; @implements SKI_ConfigBase
event OnPageReset(string a_page)
	{Called when a new page is selected, including the initial empty page}

	; Load custom logo in DDS format
	if (a_page == "")
		; Image size 512x512
		; X offset = 376 - (height / 2) = 120
		; Y offset = 223 - (width / 2) = 0
		LoadCustomContent("SexLab_Dialogues/logo.dds", 120, 0)
		return
	else
		UnloadCustomContent()
	endIf

	PlayerActor = Game.GetPlayer()

	_CommentProbability			= fMin( fMax( (_SLD_CommentProbability.GetValue() as Float) , 0.0), 100.0 )
	_AttackProbability			= fMin( fMax( (_SLD_AttackProbability.GetValue() as Float) , 0.0), 100.0 )
	_BeggingProbability			= fMin( fMax( (_SLD_BeggingProbability.GetValue() as Float) , 0.0), 100.0 )
	_BaseMagicka				= fMin( fMax( (StorageUtil.GetIntValue( PlayerActor , "_SLD_baseMagicka")) , 0.0), 200.0 )
 
	_BeastDialogueON		= _SLD_BeastDialogueON.GetValue() as Int
	_PCDomDialogueON		= _SLD_PCDomDialogueON.GetValue() as Int
	_PCSubDialogueON		= _SLD_PCSubDialogueON.GetValue() as Int
	_PCSubShavedON			= _SLD_PCSubShavedON.GetValue() as Int
	_RomanceDialogueON		= _SLD_RomanceDialogueON.GetValue() as Int
	_PCSubEnableRobbery		= _SLD_PCSubEnableRobbery.GetValue() as Int
	_BeggingDialogueON		= _SLD_BeggingDialogueON.GetValue() as Int
	_GiftDialogueON			= _SLD_GiftDialogueON.GetValue() as Int
	_BeastMenuDialogueON	= _SLD_BeastMenuDialogueON.GetValue() as Int
	_BlacksmithQuestON		= _SLD_BlacksmithQuestON.GetValue() as Int
	_MageQuestON			= _SLD_MageQuestON.GetValue() as Int
	_MagickaMasteryON		= _SLD_MagickaMasteryON.GetValue() as Int
	_PriestQuestON			= _SLD_PriestQuestON.GetValue() as Int
	; _RegisterCustomRaces		= false
	; _ClearGiantRaces = false
	; _GetDebugSpell	= false
 

	If (a_page == "Features")
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption(" Seduction / Corruption ")
		AddToggleOptionST("STATE_RomanceDialogueON","Enable Seduction / Corruption", _RomanceDialogueON as Float)

		AddHeaderOption(" Player as Dom")
		AddToggleOptionST("STATE_PCDomDialogueON","Enable Player as Dom", _PCDomDialogueON as Float)

		AddHeaderOption(" Player as Sub")
		AddToggleOptionST("STATE_PCSubDialogueON","Enable Player as Sub", _PCSubDialogueON as Float)
		AddToggleOptionST("STATE_PCSubEnableRobbery","NPCs can steal slave items", _PCSubEnableRobbery	 as Float)
		AddToggleOptionST("STATE_PCSubShavedON","Player can be shaved as a slave", _PCSubShavedON	 as Float)

		AddHeaderOption(" Bestiality")
		AddToggleOptionST("STATE_BeastDialogueON","Enable Bestiality", _BeastDialogueON as Float)
 		AddToggleOptionST("STATE_BeastMenuDialogueON","Enable popup menu for creatures", _BeastMenuDialogueON as Float)

		SetCursorPosition(1)
		AddHeaderOption(" Give and Take")
		AddToggleOptionST("STATE_BeggingDialogueON","Enable Begging from NPCs", _BeggingDialogueON as Float)
		AddSliderOptionST("STATE_BeggingProbability","Begging Probability",  _BeggingProbability	 as Float,"{0} %")
 		AddToggleOptionST("STATE_GiftDialogueON","Enable Gifts to NPCs", _GiftDialogueON as Float)

		AddHeaderOption(" Shared settings")
		AddSliderOptionST("STATE_CommentProbability","Comment Probability",  _CommentProbability	 as Float,"{0} %")
		AddSliderOptionST("STATE_AttackProbability","Attack Probability",  _AttackProbability	 as Float,"{0} %")


	ElseIf (a_page == "Quests")
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption(" Blacksmith Apprentice ")
		AddToggleOptionST("STATE_BlacksmithQuestON","Become a Blacksmith", _BlacksmithQuestON as Float)
		AddHeaderOption(" Mage Apprentice ")
		AddToggleOptionST("STATE_MageQuestON","Become a Mage", _MageQuestON as Float)
		AddToggleOptionST("STATE_MagickaMasteryON","Magicka Mastery System", _MagickaMasteryON as Float)
		AddSliderOptionST("STATE_BaseMagicka","Base Magicka",  _BaseMagicka	 as Float,"{0}")
		AddHeaderOption(" Priest Apprentice ")
		AddToggleOptionST("STATE_PriestQuestON","Become a Priest", _PriestQuestON as Float, OPTION_FLAG_DISABLED)

		SetCursorPosition(1)
		AddHeaderOption(" Magicka Mastery Status")

		AddTextOption(" Magicka: " + PlayerActor.GetAV("Magicka") as Int, "", OPTION_FLAG_DISABLED)
		AddTextOption(" MagickaRate: " + PlayerActor.GetAV("MagickaRate" ) as Int, "", OPTION_FLAG_DISABLED)

		AddTextOption(" NumberPotionsToday: " + StorageUtil.GetIntValue( PlayerActor , "_SLD_numberPotionsToday") as Int, "", OPTION_FLAG_DISABLED)
		AddTextOption(" PotionToxicityTolerance: " + StorageUtil.GetIntValue( PlayerActor , "_SLD_potionToxicityTolerance") as Int, "", OPTION_FLAG_DISABLED)
		AddTextOption(" JobMageMastery: " + StorageUtil.GetIntValue( PlayerActor , "_SLD_jobMageMastery") as Int, "", OPTION_FLAG_DISABLED)
		AddTextOption(" PlayersHealthPercent: " + PlayerActor.GetActorValuePercentage("health") as Float, "", OPTION_FLAG_DISABLED)

		AddHeaderOption(" Magic items crafted")

		AddTextOption(" Enchantments: " + Game.QueryStat("Magic Items Made")  as Int, "", OPTION_FLAG_DISABLED)
		AddTextOption(" Potions: " + Game.QueryStat("Potions Mixed")  as Int, "", OPTION_FLAG_DISABLED)

	ElseIf (a_page == "Debug")
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption(" Compatibility settings")
		AddToggleOptionST("STATE_RegisterCustomRaces","Register custom races", _RegisterCustomRaces	 as Float) 
		AddToggleOptionST("STATE_ClearGiantRaces","Clear giant races", _ClearGiantRaces	 as Float) 

		AddHeaderOption(" Debug")
		AddToggleOptionST("STATE_GetDebugSpell","Get debug spell book", _GetDebugSpell	 as Float) 
	
	endIf
endEvent

; AddToggleOptionST("STATE_RomanceDialogueON","Enable Seduction / Corruption", _RomanceDialogueON as Float)
state STATE_RomanceDialogueON ; TOGGLE
	event OnSelectST()
		_SLD_RomanceDialogueON.SetValueInt( Math.LogicalXor( 1, _SLD_RomanceDialogueON.GetValueInt() ) )
		SetToggleOptionValueST( _SLD_RomanceDialogueON.GetValueInt() as Bool )
		ForcePageReset()
	endEvent

	event OnDefaultST()
		_SLD_RomanceDialogueON.SetValueInt( 1 )
		SetToggleOptionValueST( True )
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText("Adds dialogue topics to seduce or corrupt NPCs into lovers, owners or slaves.")
	endEvent

endState

; AddToggleOptionST("STATE_PCDomDialogueON","Enable Player as Dom", _PCDomDialogueON as Float)
state STATE_PCDomDialogueON ; TOGGLE
	event OnSelectST()
		_SLD_PCDomDialogueON.SetValueInt( Math.LogicalXor( 1, _SLD_PCDomDialogueON.GetValueInt() ) )
		SetToggleOptionValueST( _SLD_PCDomDialogueON.GetValueInt() as Bool )
		ForcePageReset()
	endEvent

	event OnDefaultST()
		_SLD_PCDomDialogueON.SetValueInt( 1 )
		SetToggleOptionValueST( True )
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText("Adds dialogue topics to allow the player to act as a Dom with slave NPCs.")
	endEvent

endState

; AddToggleOptionST("STATE_PCSubDialogueON","Enable Player as Sub", _PCSubDialogueON as Float)
state STATE_PCSubDialogueON ; TOGGLE
	event OnSelectST()
		_SLD_PCSubDialogueON.SetValueInt( Math.LogicalXor( 1, _SLD_PCSubDialogueON.GetValueInt() ) )
		SetToggleOptionValueST( _SLD_PCSubDialogueON.GetValueInt() as Bool )
		ForcePageReset()
	endEvent

	event OnDefaultST()
		_SLD_PCSubDialogueON.SetValueInt( 1 )
		SetToggleOptionValueST( True )
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText("Adds dialogue topics to allow the player to act as a Sub for master NPCs.")
	endEvent

endState

; AddToggleOptionST("STATE_PCSubEnableRobbery","NPCs can steal slave items", _PCSubEnableRobbery	 as Float)
state STATE_PCSubEnableRobbery ; TOGGLE
	event OnSelectST()
		_SLD_PCSubEnableRobbery.SetValueInt( Math.LogicalXor( 1, _SLD_PCSubEnableRobbery.GetValueInt() ) )
		SetToggleOptionValueST( _SLD_PCSubEnableRobbery.GetValueInt() as Bool )
		ForcePageReset()
	endEvent

	event OnDefaultST()
		_SLD_PCSubEnableRobbery.SetValueInt( 0 )
		SetToggleOptionValueST( False )
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText("NPCs will randomly help themselves to the slave player's inventory. Turning this off will limit robberies to gold only. Attention: Turning this option on can allow NPCs to steal quest items!")
	endEvent

endState

; AddToggleOptionST("STATE_PCSubShavedON","Player can be shaved as a slave", _PCSubShavedON	 as Float)
state STATE_PCSubShavedON ; TOGGLE
	event OnSelectST()
		_SLD_PCSubShavedON.SetValueInt( Math.LogicalXor( 1, _SLD_PCSubShavedON.GetValueInt() ) )
		SetToggleOptionValueST( _SLD_PCSubShavedON.GetValueInt() as Bool )
		ForcePageReset()
	endEvent

	event OnDefaultST()
		_SLD_PCSubShavedON.SetValueInt( 1 )
		SetToggleOptionValueST( True )
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText("Player as slave will have their head shaved as a default option when their owner says 'I don't like the way you look'.")
	endEvent

endState

; AddToggleOptionST("STATE_BeastDialogueON","Enable Bestiality", _BeastDialogueON as Float)
state STATE_BeastDialogueON ; TOGGLE
	event OnSelectST()
		_SLD_BeastDialogueON.SetValueInt( Math.LogicalXor( 1, _SLD_BeastDialogueON.GetValueInt() ) )
		SetToggleOptionValueST( _SLD_BeastDialogueON.GetValueInt() as Bool )
		ForcePageReset()
	endEvent

	event OnDefaultST()
		_SLD_BeastDialogueON.SetValueInt( 1 )
		SetToggleOptionValueST( True )
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText("Adds dialogue topics to behave as sub or dom for some non-aggressive creatures.")
	endEvent

endState

; AddToggleOptionST("STATE_BeggingDialogueON","Enable Begging from NPCs", _BeggingDialogueON as Float)
state STATE_BeggingDialogueON ; TOGGLE
	event OnSelectST()
		_SLD_BeggingDialogueON.SetValueInt( Math.LogicalXor( 1, _SLD_BeggingDialogueON.GetValueInt() ) )
		SetToggleOptionValueST( _SLD_BeggingDialogueON.GetValueInt() as Bool )
		ForcePageReset()
	endEvent

	event OnDefaultST()
		_SLD_BeggingDialogueON.SetValueInt( 1 )
		SetToggleOptionValueST( True )
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText("Allows the player to beg NPCs for gold. Answers will vary based on what the player is wearing (use beggar or farm clothes for better results).")
	endEvent

endState

; AddToggleOptionST("STATE_GiftDialogueON","Enable Gifts to NPCs", _GiftDialogueON as Float)
state STATE_GiftDialogueON ; TOGGLE
	event OnSelectST()
		_SLD_GiftDialogueON.SetValueInt( Math.LogicalXor( 1, _SLD_GiftDialogueON.GetValueInt() ) )
		SetToggleOptionValueST( _SLD_GiftDialogueON.GetValueInt() as Bool )
		ForcePageReset()
	endEvent

	event OnDefaultST()
		_SLD_GiftDialogueON.SetValueInt( 1 )
		SetToggleOptionValueST( True )
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText("Allows the player to give objects to NPCs.")
	endEvent

endState

; AddToggleOptionST("STATE_BeastMenuDialogueON","Enable BeastMenu to NPCs", _BeastMenuDialogueON as Float)
state STATE_BeastMenuDialogueON ; TOGGLE
	event OnSelectST()
		_SLD_BeastMenuDialogueON.SetValueInt( Math.LogicalXor( 1, _SLD_BeastMenuDialogueON.GetValueInt() ) )
		SetToggleOptionValueST( _SLD_BeastMenuDialogueON.GetValueInt() as Bool )
		ForcePageReset()
	endEvent

	event OnDefaultST()
		_SLD_BeastMenuDialogueON.SetValueInt( 1 )
		SetToggleOptionValueST( True )
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText("Replace dialogue interactions by popup menu for creature masters/slaves (to prevent a bug with frozen dialogues for beast NPCs)")
	endEvent

endState


; AddSliderOptionST("STATE_CommentProbability","Comment Probability",  _CommentProbability	 as Float,"{0} %")
state STATE_CommentProbability ; SLIDER
	event OnSliderOpenST()
		SetSliderDialogStartValue( _SLD_CommentProbability.GetValue() )
		SetSliderDialogDefaultValue( 10.0 )
		SetSliderDialogRange( 0.0, 100.0 )
		SetSliderDialogInterval( 1.0 )
	endEvent

	event OnSliderAcceptST(float value)
		float thisValue = value 
		_SLD_CommentProbability.SetValue( thisValue  )
		SetSliderOptionValueST( thisValue,"{0} %" )
	endEvent

	event OnDefaultST()
		_SLD_CommentProbability.SetValue( 30.0 )
		SetSliderOptionValueST( 30.0,"{0} %" )
	endEvent

	event OnHighlightST()
		SetInfoText("Controls random comments and actions from NPCs based on the player's current status (Sub, Dom, Lover, etc)")
	endEvent
endState

; AddSliderOptionST("STATE_AttackProbability","Comment Probability",  _AttackProbability	 as Float,"{0} %")
state STATE_AttackProbability ; SLIDER
	event OnSliderOpenST()
		SetSliderDialogStartValue( _SLD_AttackProbability.GetValue() )
		SetSliderDialogDefaultValue( 10.0 )
		SetSliderDialogRange( 0.0, 100.0 )
		SetSliderDialogInterval( 1.0 )
	endEvent

	event OnSliderAcceptST(float value)
		float thisValue = value 
		_SLD_AttackProbability.SetValue( thisValue  )
		SetSliderOptionValueST( thisValue,"{0} %" )
	endEvent

	event OnDefaultST()
		_SLD_AttackProbability.SetValue( 30.0 )
		SetSliderOptionValueST( 30.0,"{0} %" )
	endEvent

	event OnHighlightST()
		SetInfoText("Controls random attacks from NPCs and creatures based on the player's current status (Sub, Dom, Lover, etc)")
	endEvent
endState


; AddSliderOptionST("STATE_BeggingProbability","Begging Probability",  _BeggingProbability	 as Float,"{0} %")
state STATE_BeggingProbability ; SLIDER
	event OnSliderOpenST()
		SetSliderDialogStartValue( _SLD_BeggingProbability.GetValue() )
		SetSliderDialogDefaultValue( 10.0 )
		SetSliderDialogRange( 0.0, 100.0 )
		SetSliderDialogInterval( 1.0 )
	endEvent

	event OnSliderAcceptST(float value)
		float thisValue = value 
		_SLD_BeggingProbability.SetValue( thisValue  )
		SetSliderOptionValueST( thisValue,"{0} %" )
	endEvent

	event OnDefaultST()
		_SLD_BeggingProbability.SetValue( 30.0 )
		SetSliderOptionValueST( 30.0,"{0} %" )
	endEvent

	event OnHighlightST()
		SetInfoText("Chance of success when begging for items and gold. Other factors include being naked, wearing poor clothing and wearing a collar.")
	endEvent
endState

; AddToggleOptionST("STATE_BlacksmithQuestON","Become a Blacksmith", _BlacksmithQuestON as Float)
state STATE_BlacksmithQuestON ; TOGGLE
	event OnSelectST()
		_SLD_BlacksmithQuestON.SetValueInt( Math.LogicalXor( 1, _SLD_BlacksmithQuestON.GetValueInt() ) )
		SetToggleOptionValueST( _SLD_BlacksmithQuestON.GetValueInt() as Bool )
		ForcePageReset()
	endEvent

	event OnDefaultST()
		_SLD_BlacksmithQuestON.SetValueInt( 0 )
		SetToggleOptionValueST( False )
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText("Guided progression from an apprentice to a master Blacksmith.")
	endEvent

endState

; AddToggleOptionST("STATE_MageQuestON","Become a Blacksmith", _MageQuestON as Float)
state STATE_MageQuestON ; TOGGLE
	event OnSelectST()
		_SLD_MageQuestON.SetValueInt( Math.LogicalXor( 1, _SLD_MageQuestON.GetValueInt() ) )
		SetToggleOptionValueST( _SLD_MageQuestON.GetValueInt() as Bool )

		if (_SLD_MageQuestON.GetValueInt() == 1)
			SendModEvent("SLDRefreshMagicka")
		else
			_SLD_MagickaMasteryON.SetValueInt(0)
			_ResetMagicka()
		EndIf

		ForcePageReset()
	endEvent

	event OnDefaultST()
		_SLD_MageQuestON.SetValueInt( 0 )
		SetToggleOptionValueST( False )
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText("Guided progression from an apprentice to a master Mage.")
	endEvent

endState


; AddToggleOptionST("STATE_MagickaMasteryON","Become a Blacksmith", _MagickaMasteryON as Float)
state STATE_MagickaMasteryON ; TOGGLE
	event OnSelectST()

		_SLD_MagickaMasteryON.SetValueInt( Math.LogicalXor( 1, _SLD_MagickaMasteryON.GetValueInt() ) )
		SetToggleOptionValueST( _SLD_MagickaMasteryON.GetValueInt() as Bool )

		if (_SLD_MagickaMasteryON.GetValueInt()==0)
			_ResetMagicka()
			Debug.MessageBox(" Magicka Mastery system OFF\n Your Magicka has been restored to a default state.")
		Else
			Debug.MessageBox(" Magicka Mastery system ON\n Your Magicka value is dynamic and based on damages received plus progress as a Mage Apprentice. Good luck.")
		endif
 
		ForcePageReset()
	endEvent

	event OnDefaultST()
		_SLD_MagickaMasteryON.SetValueInt( 0 )
		SetToggleOptionValueST( False )
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText("Magicka level is linked to Mage Mastery progression. This feature is still EXPERIMENTAL!")
	endEvent

endState

; AddSliderOptionST("STATE_BaseMagicka","Base Magicka",  _BaseMagicka	 as Float,"{0} %")
state STATE_BaseMagicka ; SLIDER
	event OnSliderOpenST()
		SetSliderDialogStartValue( _BaseMagicka )
		SetSliderDialogDefaultValue( 0.0 )
		SetSliderDialogRange( 0.0, 200.0 )
		SetSliderDialogInterval( 10.0 )
	endEvent

	event OnSliderAcceptST(float value)
		_BaseMagicka = value 
		StorageUtil.SetIntValue( PlayerActor , "_SLD_baseMagicka", _BaseMagicka as Int)
		SetSliderOptionValueST( _BaseMagicka,"{0}" )
	endEvent

	event OnDefaultST()
		StorageUtil.SetIntValue( PlayerActor , "_SLD_baseMagicka", 0)
		SetSliderOptionValueST( 0.0,"{0}" )
	endEvent

	event OnHighlightST()
		SetInfoText("Base amount of Magicka - Increase to account for racial affinity with Magicka.")
	endEvent
endState

; AddToggleOptionST("STATE_PriestQuestON","Become a Blacksmith", _PriestQuestON as Float)
state STATE_PriestQuestON ; TOGGLE
	event OnSelectST()
		_SLD_PriestQuestON.SetValueInt( Math.LogicalXor( 1, _SLD_PriestQuestON.GetValueInt() ) )
		SetToggleOptionValueST( _SLD_PriestQuestON.GetValueInt() as Bool )
		ForcePageReset()
	endEvent

	event OnDefaultST()
		_SLD_PriestQuestON.SetValueInt( 0 )
		SetToggleOptionValueST( False )
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText("Guided progression from an apprentice to a Holy Scholar.")
	endEvent

endState

; AddToggleOptionST("STATE_RegisterCustomRaces","Register custom races", _RegisterCustomRaces	 as Float)
state STATE_RegisterCustomRaces ; TOGGLE
	event OnSelectST()
		_RegisterRaces()
		_RegisterCustomRaces  = Math.LogicalXor( 1, (_RegisterCustomRaces  as Int) )
		SetToggleOptionValueST( _RegisterCustomRaces )
		ForcePageReset()
	endEvent

	event OnDefaultST() 
		SetToggleOptionValueST( false )
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText("Register custom races from Titans of Skyrim and JackGa Monster Lore (see SkyrimLL Obscure Patches page).")
	endEvent

endState

; AddToggleOptionST("STATE_ClearGiantRaces","Clear giant races", _ClearGiantRaces	 as Float)
state STATE_ClearGiantRaces ; TOGGLE
	event OnSelectST()
		_ClearRaces()
		_ClearGiantRaces  = Math.LogicalXor( 1, (_ClearGiantRaces  as Int) )
		SetToggleOptionValueST( _ClearGiantRaces )
		ForcePageReset()
	endEvent

	event OnDefaultST() 
		SetToggleOptionValueST( false )
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText("Remove SexLab registration for giant races (giants, dragons) and some ridiculous races (bears, sabrecats, chickens, skeevers).")
	endEvent

endState

; AddToggleOptionST("STATE_GetDebugSpell","Clear giant races", _GetDebugSpell	 as Float)
state STATE_GetDebugSpell ; TOGGLE
	event OnSelectST() 
		Game.GetPlayer().AddItem(_SLD_debugSpell, 1)
		_GetDebugSpell  = Math.LogicalXor( 1, (_GetDebugSpell  as Int) )
		SetToggleOptionValueST( _GetDebugSpell )
		ForcePageReset()
	endEvent

	event OnDefaultST() 
		SetToggleOptionValueST( false )
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText("Get a spellbook with a debug spell to analyze and repair followers and masters NPCs.")
	endEvent

endState

float function fMin(float  a, float b)
	if (a<=b)
		return a
	else
		return b
	EndIf
EndFunction

float function fMax(float a, float b)
	if (a<=b)
		return b
	else
		return a
	EndIf
EndFunction
;--------------------------------------
 
Function _ResetMagicka()

	iAVMod = 100 + (PlayerActor.GetLevel() as Int) * 10
	PlayerActor.ForceAV("Magicka", iAVMod)
	fAVMod = 3.0
	PlayerActor.ForceAV("MagickaRate", fAVMod )	
EndFunction

function _RegisterRaces()
	; Adds races from Immersive Creatires, JackGa monsters and Skyrim MonsterMod

	AddRaceID("Chaurus", "00ChaurusRedRace")
	AddRaceID("Chaurus", "00scorprace")

	AddRaceID("Draugrs", "_00LichRace")
	AddRaceID("Draugrs", "_00ArmoredSkeletonBeastRace_Old")
	AddRaceID("Draugrs", "_00DraugrRaceSH")
	AddRaceID("Draugrs", "_00DraugrVarRace")

	AddRaceID("Falmers", "00FalmerRaceHulk")
	AddRaceID("Falmers", "_00FalmerRace01")
	AddRaceID("Falmers", "_00FalmerRace02")
	AddRaceID("Falmers", "_00FalmerRace03")
	AddRaceID("Falmers", "_00FalmerRace04")
	AddRaceID("Falmers", "_00FalmerRace05") 
	AddRaceID("Falmers", "_00GoblinRace") 

	; AddRaceID("Horses", "HorseRace")

	AddRaceID("Spiders", "_00ChaurusCrawlerRace")
	AddRaceID("Spiders", "_00SkeletonSpiderRace")

	; AddRaceID("LargeSpiders", "FrostbiteSpiderRaceGiant")

	AddRaceID("Trolls", "_00DLC1SwampTrollRaceArmored")

	AddRaceID("Werewolves", "WerewolfBeastRaceEvilwolf")
	AddRaceID("Werewolves", "_00WerewolfKingBeastRace") 

	AddRaceID("Wolves", "_00AspectRace")
	AddRaceID("Wolves", "HyenaRaceSlice")

	; AddRaceID("Dogs", "DogRace")

	AddRaceID("SabreCats", "TigerRaceSlice")
	AddRaceID("SabreCats", "PantherRaceSlice")
	AddRaceID("SabreCats", "LionRaceSlice")
	AddRaceID("SabreCats", "LynxRace")
	AddRaceID("SabreCats", "CatRaceSlice")

	; AddRaceID("VampireLords", "DLC1VampireBeastRace")

	AddRaceID("Gargoyles", "_00WrathBruteRace")

	; AddRaceID("Rieklings", "DLC2RieklingRace")

	; AddRaceID("Seekers", "DLC2SeekerRace")

	; AddRaceID("Lurkers", "DLC2LurkerRace")

	; AddRaceID("Spriggans", "SprigganRace")

	AddRaceID("Spriggans", "00TreeSpiritRacesmm")
	AddRaceID("FlameAtronach", "00AtronachSpiritRacesmm")


endFunction

 
function _ClearRaces()
	ClearRaceKey("Bears")
	ClearRaceKey("SabreCats")
	; ClearRaceKey("Chaurus")
	ClearRaceKey("Dragons")
	; ClearRaceKey("Draugrs")
	; ClearRaceKey("Falmers")
	ClearRaceKey("Giants")
	; ClearRaceKey("Horses")
	; ClearRaceKey("Spiders")
	; ClearRaceKey("LargeSpiders")
	; ClearRaceKey("Trolls")
	; ClearRaceKey("Werewolves")
	; ClearRaceKey("Wolves")
	; ClearRaceKey("Dogs")
	; ClearRaceKey("VampireLords")
	; ClearRaceKey("Gargoyles")
	; ClearRaceKey("Rieklings")
	; ClearRaceKey("Seekers")
	; ClearRaceKey("Lurkers")
	; ClearRaceKey("Spriggans")
	; ClearRaceKey("FlameAtronach")
	ClearRaceKey("Skeevers")
	ClearRaceKey("Chickens")
	; AddRaceID("Chickens", "ChickenRace")
	ClearRaceKey("Cows")

endFunction

