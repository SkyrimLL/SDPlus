Scriptname _sdras_load extends ReferenceAlias  
 
_SD_reset Property _reset Auto
_SDQS_enslavement Property _SD_Enslavement Auto
_sdras_player Property _SD_Player Auto

Event OnPlayerLoadGame()
	Debug.Notification("[_sdras_load] Calling version check")
	_reset.Maintenance()

	Debug.Notification("[_sdras_load] Calling local maintenance")
	_SD_Player._Maintenance()

	Debug.Notification("[_sdras_load] Checking enslavement")
	if (StorageUtil.GetIntValue(Game.GetPlayer(), "_SD_iEnslaved") == 1)
		Debug.Notification("[_sdras_load] Calling enslavement maintenance")
		_SD_Enslavement._Maintenance()
	EndIf	
EndEvent