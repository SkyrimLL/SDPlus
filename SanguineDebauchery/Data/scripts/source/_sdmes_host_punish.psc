Scriptname _SDMES_host_punish extends activemagiceffect
{ USED }
Import Utility

_SDQS_snp Property snp Auto

Sound Property _SDSMP_buzz  Auto
Sound Property _SDSMP_vib  Auto  

int i_SDSM_buzz
int i_SDSM_vib

Float fUpdateGrunt
Float fGCRT

Event OnUpdate()
	fGCRT = GetCurrentRealTime()
	Actor kCaster = GetCasterActor()

	If ( fGCRT > fUpdateGrunt )
		fUpdateGrunt = fGCRT + RandomFloat( 3.0, 5.0 )
		i_SDSM_vib = _SDSMP_vib.Play( kCaster )
		snp.updateSexPk( kCaster, kCaster )
	EndIf
	If ( Self )
		RegisterForSingleUpdate( 0.1 )
	EndIf
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Debug.Notification( "A swarm of needles suddenly crawl under your skin." )
	fUpdateGrunt = GetCurrentRealTime() + 4.0
	i_SDSM_buzz = _SDSMP_buzz.Play( akCaster )

	If ( Self )
		RegisterForSingleUpdate( 0.1 )
	EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	If ( Self )
		UnregisterForUpdate()
	EndIf
	
	If (i_SDSM_buzz != 0)
		Sound.StopInstance( i_SDSM_buzz )
	EndIf
	
	If (i_SDSM_vib != 0)
		Sound.StopInstance( i_SDSM_vib )
	EndIf
EndEvent




