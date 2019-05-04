Scriptname _sdras_load extends ReferenceAlias
 
_SD_reset Property _reset Auto
_SDQS_enslavement Property _SD_Enslavement Auto
_sdras_player Property _SD_Player Auto

Event OnPlayerLoadGame()
	Actor kPlayer = Game.GetPlayer()
	; Debug.Notification("[_sdras_load] Checking enslavement")
	; if (StorageUtil.GetIntValue(Game.GetPlayer(), "_SD_iEnslaved") == 1)
		; Debug.Notification("[_sdras_load] Calling enslavement maintenance")
	;	_SD_Enslavement._Maintenance()
	; EndIf	

	; Debug.Trace("[_sdras_load] Calling _sd_player maintenance")
	; _SD_Player._Maintenance()

	; Debug.Trace("[_sdras_load] Calling version check")

	; Debug.Notification("[_sdras_load] Test storageUtil issue")
	; Debug.Notification("[_sdras_load]     _SD_sSleepPose: " + StorageUtil.GetStringValue(kPlayer, "_SD_sSleepPose") )
	; Debug.Notification("[_sdras_load]     xpopVersionStr: " + StorageUtil.GetStringValue(kPlayer, "xpopVersionStr") )
	; Debug.Notification("[_sdras_load]     SexLab.SavedVoice: " + StorageUtil.GetStringValue(kPlayer, "SexLab.SavedVoice") )

	Debug.Trace("[_sdras_load] Test storageUtil issue")
	Debug.Trace("[_sdras_load]     _SD_sSleepPose: " + StorageUtil.GetStringValue(kPlayer, "_SD_sSleepPose") )
	Debug.Trace("[_sdras_load]     xpopVersionStr: " + StorageUtil.GetStringValue(kPlayer, "xpopVersionStr") )
	Debug.Trace("[_sdras_load]     SexLab.SavedVoice: " + StorageUtil.GetStringValue(kPlayer, "SexLab.SavedVoice") )

	_reset.Maintenance()

	; Mod detection / compatibility
	StorageUtil.SetIntValue(none, "_SLS_isEstrusChaurusON", 0)
	StorageUtil.SetIntValue(none, "_SLS_isBeeingFemaleON", 0)
	StorageUtil.SetIntValue(none, "_SLS_isCagedFollowerON", 0)
	StorageUtil.SetFormValue( none, "_SD_SexLabDefeatDialogueBlockFaction", None)

	int idx = Game.GetModCount()
	string modName = ""
	while idx > 0
		idx -= 1
		modName = Game.GetModName(idx)
		if modName == "EstrusChaurus.esp"
			StorageUtil.SetIntValue(none, "_SLS_isEstrusChaurusON",  1) 
			StorageUtil.SetFormValue(none, "_SLS_getEstrusChaurusBreederSpell",  Game.GetFormFromFile(0x00019121, modName)) ; as Spell

		elseif modName == "BeeingFemale.esm"
			StorageUtil.SetIntValue(none, "_SLS_isBeeingFemaleON",  1) 
			StorageUtil.SetFormValue(none, "_SLS_getBeeingFemalePregnancySpell",  Game.GetFormFromFile(0x000028A0, modName)) ; as Spell

		elseif modName == "CagedFollowers.esp"
			StorageUtil.SetIntValue(none, "_SLS_isCagedFollowerON",  1) 
			StorageUtil.SetFormValue(none, "_SLS_getCagedFollowerQuestKeyword",  Game.GetFormFromFile(0x0000184d, modName)) ; as Keyword

		elseif modName == "SexLabDefeat.esp"
			Faction DefeatDialogueBlockFaction = Game.GetFormFromFile(0x0008C862, modName) As Faction
			StorageUtil.SetFormValue( none, "_SD_SexLabDefeatDialogueBlockFaction", DefeatDialogueBlockFaction as Form)

		endif
	endWhile
EndEvent
