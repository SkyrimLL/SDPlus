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

	Debug.Trace("[_sdras_load] Calling version check")

	; Debug.Notification("[_sdras_load] Test storageUtil issue")
	; Debug.Notification("[_sdras_load]     _SD_sSleepPose: " + StorageUtil.GetStringValue(kPlayer, "_SD_sSleepPose") )
	; Debug.Notification("[_sdras_load]     xpopVersionStr: " + StorageUtil.GetStringValue(kPlayer, "xpopVersionStr") )
	; Debug.Notification("[_sdras_load]     SexLab.SavedVoice: " + StorageUtil.GetStringValue(kPlayer, "SexLab.SavedVoice") )

	Debug.Trace("[_sdras_load] Test storageUtil issue")
	Debug.Trace("[_sdras_load]     _SD_sSleepPose: " + StorageUtil.GetStringValue(kPlayer, "_SD_sSleepPose") )
	Debug.Trace("[_sdras_load]     xpopVersionStr: " + StorageUtil.GetStringValue(kPlayer, "xpopVersionStr") )
	Debug.Trace("[_sdras_load]     SexLab.SavedVoice: " + StorageUtil.GetStringValue(kPlayer, "SexLab.SavedVoice") )

	_reset.Maintenance()

EndEvent