Scriptname _SDMES_bound extends activemagiceffect  
{ USED }
_SDQS_functions Property funct  Auto

ReferenceAlias Property _SDRAP_master  Auto  
GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  

Keyword[] Property notKeywords  Auto  
Idle[] Property _SDIAP_bound  Auto  
Idle Property _SDIAP_reset  Auto  

Faction Property SexLabActiveFaction  Auto  


Actor kTarget
Actor kPlayer
ObjectReference kMaster

Float fRFSU = 0.1

Event OnUpdate()
	If ( kTarget.GetEquippedWeapon() )
		kTarget.UnequipItem( kTarget.GetEquippedWeapon(), false, True )
		kTarget.RemoveItem( kTarget.GetEquippedWeapon(), 1, True )
	EndIf
	If ( kTarget.GetEquippedWeapon(True) )
		kTarget.UnequipItem( kTarget.GetEquippedWeapon(True), false, True )
		kTarget.RemoveItem( kTarget.GetEquippedWeapon(True), 1, True )
	EndIf
	If ( kTarget.GetEquippedShield() )
		kTarget.UnequipItem( kTarget.GetEquippedShield(), false, True )
		kTarget.RemoveItem( kTarget.GetEquippedShield(), 1, True )
	EndIf
	If ( kTarget.GetEquippedSpell(0) )
		kTarget.UnequipSpell( kTarget.GetEquippedSpell(0), 0 )
	EndIf
	If ( kTarget.GetEquippedSpell(1) )
		kTarget.UnequipSpell( kTarget.GetEquippedSpell(1), 1 )
	EndIf

	If ( !kTarget.GetCurrentScene() && !kTarget.IsOnMount() && !kTarget.IsInFaction(SexLabActiveFaction))
		If ( Game.IsMovementControlsEnabled() && kTarget == kPlayer )
			funct.togglePlayerControlsOff()
		EndIf

		If ( kMaster && kTarget.GetDistance( kMaster ) < 512 && kTarget.GetAnimationVariableFloat("Speed") == 0 )
			If ( _SDGVP_demerits.GetValue() <= _SDGVP_demerits_join.GetValueInt() )
				kTarget.PlayIdle( _SDIAP_bound[0] )
			ElseIf ( _SDGVP_demerits.GetValue() < -10 )
				kTarget.PlayIdle( _SDIAP_bound[4] )
			ElseIf ( _SDGVP_demerits.GetValue() <  10 )
				kTarget.PlayIdle( _SDIAP_bound[2] )
			Else
				kTarget.PlayIdle( _SDIAP_bound[1] )
			EndIf
		Else
			kTarget.PlayIdle( _SDIAP_bound[0] )
		EndIf
	EndIf

	;Debug.SendAnimationEvent(kTarget, "Unequip")
	;Debug.SendAnimationEvent(kTarget, "UnequipNoAnim")
	RegisterForSingleUpdate( fRFSU )
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	kPlayer = Game.GetPlayer()
	kTarget = akTarget
	kMaster = _SDRAP_master.GetReference() as ObjectReference

	If ( kTarget == kPlayer )
		funct.togglePlayerControlsOff()
	EndIf
	akTarget.PlayIdle( _SDIAP_bound[0] )

	RegisterForSingleUpdate( fRFSU )
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	if !kTarget.IsInFaction(SexLabActiveFaction)
		Utility.Wait( 2.0 )
		Debug.SendAnimationEvent(kTarget, "IdleForceDefaultState")
	endIf
	If ( kTarget == kPlayer )
		funct.togglePlayerControlsOff( False )
	EndIf
	kTarget.PlayIdle( _SDIAP_reset )	
EndEvent

