Scriptname _SDMES_host extends activemagiceffect  

VisualEffect Property SprigganFX  Auto
Spell Property _SDSP_call  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if ( _SDGVP_sprigganEnslaved.GetValue() == 0 ) && (_SD_spriggan.GetStage()>0)
	    _SDGVP_sprigganEnslaved.SetValue(1)
	    akCaster.AddSpell( _SDSP_call )
	    SprigganFX.Play( akCaster, -1 )
      EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	akCaster.RemoveSpell( _SDSP_call )
	SprigganFX.Stop( akCaster )
EndEvent

Event OnUpdate()
	Actor kTarget = GetTargetActor()

	if ( _SDGVP_sprigganEnslaved.GetValue() == 0 ) && (_SD_spriggan.GetStage()>0)
	    _SDGVP_sprigganEnslaved.SetValue(1)
      EndIf

	If (Utility.RandomInt( 0, 100 ) > 80 ) && ( _SDGVP_sprigganEnslaved.GetValue() == 1 )
		Debug.Notification( "A heatwave of pleasure blossoms deep inside you." )
		kTarget.SetExpressionOverride( 16, Utility.RandomInt( 60, 90 ) )
	;	kTarget.PlayIdle(snp._SDIAP_4phase_female[ 1 ])
	EndIf	

	RegisterForSingleUpdateGameTime( 1.5 )
ENDEVENT


GlobalVariable Property _SDGVP_sprigganEnslaved  Auto  
Quest Property _SD_spriggan  Auto