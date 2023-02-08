Scriptname _sd_trg_akatosh_avatar extends ObjectReference  

ObjectReference Property _SLS_AkatoshMarkerRef  Auto  
ObjectReference Property _SLS_AkatoshRef  Auto  
ObjectReference Property _SLS_KynarethRef  Auto  

Weather Property BadWeather Auto
Sound Property ThunderFX Auto

SPELL Property AkatoshSkinFX Auto
SPELL Property LightningStrike Auto
SPELL Property LightningStorm Auto
SPELL Property LightningCloak Auto

Event OnTriggerEnter(ObjectReference akActionRef)
	Actor akActor = akActionRef as Actor
	Actor kPlayer = Game.getPlayer()
	Actor kAkatosh = _SLS_AkatoshRef as Actor

	; Debug.Notification("Someone walks in Sanctum: " + akActionRef)
	; Debug.Notification("SybilREF: " + SybilREF)
	; Debug.Notification("TRG Quest: " + InitiationQuest)

	; 3d will not be loaded in some situations, such as werewolf transformations.
	; Skip body update if 3d not loaded.
	If ( !(akActionRef as Actor).Is3DLoaded() )
		return
	EndIf

	If UI.IsMenuOpen("Console") || UI.IsMenuOpen("Main Menu") || UI.IsMenuOpen("Loading Menu") || UI.IsMenuOpen("MessageBoxMenu")
		return
	EndIf

	If (akActor == kPlayer)  

		Sound.SetInstanceVolume(ThunderFX.Play(kPlayer), 1.0)
		BadWeather.SetActive(true)
		_SLS_AkatoshMarkerRef.enable()

		kAkatosh.SetAlpha(0.8)
		AkatoshSkinFX.cast(_SLS_AkatoshRef, _SLS_AkatoshRef)

		; AkatoshSkinFX.cast(_SLS_KynarethRef, _SLS_KynarethRef)

		; LightningStrike.cast(_SLS_AkatoshMarkerRef, _SLS_AkatoshRef)
		; LightningStorm.cast(_SLS_AkatoshMarkerRef, _SLS_AkatoshMarkerRef)
		LightningCloak.cast(_SLS_AkatoshRef, _SLS_AkatoshRef)

	EndIf
EndEvent