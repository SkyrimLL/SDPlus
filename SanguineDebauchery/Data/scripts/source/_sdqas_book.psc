Scriptname _SDQAS_book extends ReferenceAlias  

GlobalVariable Property _SDGVP_spriggan_secret  Auto 
Spell Property _SDSP_callSpriggan  Auto  


Event OnRead()
	If ( Self.GetOwningQuest().GetStage() >= 10 && Self.GetOwningQuest().GetStage() < 60)
		_SDGVP_spriggan_secret.SetValue( 1 )
		If ( !Self.GetOwningQuest().IsObjectiveCompleted( 20 ) )
			Self.GetOwningQuest().SetObjectiveCompleted( 20 )
		EndIf
		Self.GetOwningQuest().SetObjectiveCompleted( 30 )
		Self.GetOwningQuest().SetStage( 60 )
		Game.GetPlayer().AddSpell( _SDSP_callSpriggan )
	EndIf
EndEvent

