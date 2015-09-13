ScriptName _SDMES_ARMBINDER extends zadArmbinderEffect

; SD handles bound animations behavior through _sdmes_bound, rather than on the enchantment itself. Thus, remove that behavior.
Function DoRegister() 
	RegisterForSingleUpdate(5.0)
EndFunction

Event OnUpdate()
	If !libs.IsAnimating(target)
		libs.UpdateControls() ; TODO: Replace with call to centralized SD function.
	EndIf
	DoRegister()
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if akTarget != libs.PlayerRef
		return
	EndIf
	libs.Log("OnEffectStart(): Armbinder")
	target = akTarget
	Terminate = False
	if target == libs.PlayerRef
		UnregisterForAllKeys()
		; Intercept [tab] presses.
		TweenMenuKey = Input.GetMappedKey("Tween Menu")
		RegisterForKey(TweenMenuKey)
	EndIf
	if target == libs.PlayerRef
		libs.UpdateControls()
	Endif
	DoRegister()
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)
	if (akTarget == libs.PlayerRef)
		libs.UpdateControls()
	EndIf
EndEvent

Function PlayBoundIdle(idle theIdle)

EndFunction



Event OnKeyDown(Int KeyCode) 
	if !Game.IsMenuControlsEnabled() && KeyCode == TweenMenuKey && !UI.IsMenuOpen("Dialogue Menu") && !UI.IsMenuOpen("BarterMenu") && !UI.IsMenuOpen("ContainerMenu") && !UI.IsMenuOpen("Sleep/Wait Menu")
		abq.ShowArmbinderMenu()
	EndIf
EndEvent


Event OnKeyUp(int KeyCode, float HoldTime)

EndEvent


Event OnPlayerLoadGame()
	OnUpdate()
EndEvent
