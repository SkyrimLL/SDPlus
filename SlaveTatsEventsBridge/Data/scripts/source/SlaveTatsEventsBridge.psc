scriptname SlaveTatsEventsBridge extends ReferenceAlias

;/
========================================================================
Version control
========================================================================
/;
string function VERSION() global
	return "0.0.1"
endfunction


Event OnInit()
	registerStuff()
EndEvent

Event OnPlayerLoadGame()
	registerStuff()
EndEvent



;/
========================================================================
register the events, called by the engine
========================================================================
/;
function registerStuff()
	UnregisterForAllModEvents()
	debug.Trace("[STEB] Registering events")
	RegisterForModEvent("STSimpleAddTattoo", "OnSimpleAddTattoo")
	RegisterForModEvent("STSimpleRemoveTattoo", "OnSimpleRemoveTattoo")
	RegisterForModEvent("STAddTattoo", "OnAddTattoo")
	RegisterForModEvent("STRemoveAllSectionTattoo", "OnRemoveAllSectionTattoo")
	debug.notification("SlaveTats Events Bridge v" + VERSION())

	;hacky test?
	RegisterForSingleUpdate(10)
endfunction

;my hacky testing, leave me alone! >:(
Event OnUpdate()
	;/
	debug.notification("[steb] removing all from section")
	int eventCall = ModEvent.Create("STRemoveAllSectionTattoo")
	if eventCall
		ModEvent.PushForm(eventCall, Game.GetPlayer())
		ModEvent.PushString(eventCall, "Bimbo")
		ModEvent.PushBool(eventCall, true)
		ModEvent.PushBool(eventCall, false)
		ModEvent.Send(eventCall)
	endIf
	debug.notification("[steb] adding tattoo")
	int eventCall = ModEvent.Create("STAddTattoo")
	if eventCall
		ModEvent.PushForm(eventCall, Game.GetPlayer())
		ModEvent.PushString(eventCall, "Symbolic")
		ModEvent.PushString(eventCall, "Ass Arrow")
		ModEvent.PushInt(eventCall, 0x00FF0000)
		ModEvent.PushBool(eventCall, true)
		ModEvent.PushBool(eventCall, false)
		ModEvent.PushInt(eventCall, 0x00FF0000)
		ModEvent.PushBool(eventCall, true)
		ModEvent.PushBool(eventCall, true)
		ModEvent.Send(eventCall)
	endIf
	/;
EndEvent

;/
========================================================================
Add a tattoo. Will trigger a mod event called STSimpleAddTattooReturn with the same parameters and a bool indicating if it had sucess
Example:
	int STevent = ModEvent.Create("STSimpleAddTattoo") 
	if (STevent)
	    ModEvent.PushForm(STevent, akActor)         ; Form - actor
	    ModEvent.PushString(STevent, sSection)     	; String - tattoo section (the folder name)
	    ModEvent.PushString(STevent, sTatooName)    ; String - name of tattoo
	    ModEvent.PushInt(STevent, iColor)           ; Int - color (0xAARRGGBB: alpha, red, green, blue)
	    ModEvent.PushBool(STevent, false)           ; Bool - last = false (the tattoos are only applied when last = true, use it on batches)
	    ModEvent.PushBool(STevent, true)            ; Bool - silent = true (do not show a message)
	    ModEvent.Send(STevent)
	endif
========================================================================
/;
Event OnSimpleAddTattoo(Form _form, String _section, String _name, int _color, bool _last, bool _silent)
	float _alpha = 1.0
    if (_form as Actor)
		debug.Trace("[STEB] OnSimpleAddTattoo " + _section + " / " + _name)

		;slh temporary hack, all events are being sent as last=false
		if (_section == "Bimbo")
			_last = true
		endif
		bool added = false
		if SlaveTats.VERSION() as bool
			;bool function simple_add_tattoo(Actor target, string section, string name, int color = 0, bool last = true, bool silent = false, float alpha = 1.0) global
			added = SlaveTats.simple_add_tattoo(_form as Actor, _section, _name, _color, _last, _silent, _alpha)
		endif
		int STcallback = ModEvent.Create("STSimpleAddTattooReturn")
		if (STcallback)
			ModEvent.PushForm(STcallback, _form)
			ModEvent.PushString(STcallback, _section)
			ModEvent.PushString(STcallback, _name)
			ModEvent.PushInt(STcallback, _color)
			ModEvent.PushBool(STcallback, _last)
			ModEvent.PushBool(STcallback, _silent)
			ModEvent.PushBool(STcallback, added)
			ModEvent.Send(STcallback)
		endif
	else
		debug.Trace("[STEB] ERROR: called OnSimpleAddTattoo on a not-actor")
	endIf
EndEvent


;/
========================================================================
Add a tattoo, with more SlaveTats parameters
parameters:
	- Form _form: target actor
	- String _section: section name, ie, folder name on disk
	- String _name: tattoo name
	- int _color: alpha, red, green, blue
	- bool _last: use on batches, ST only applies all tattoos when receiving a last=true
	- bool _silent: do not show messages
	- int _glowColor: tattoo glow color
	- bool _gloss: gloss effect
	- bool _lock: do not let the user remove it from the mcm menu
========================================================================
/;
Event OnAddTattoo(Form _form, String _section, String _name, int _color, bool _last, bool _silent, int _glowColor, bool _gloss, bool _lock)
	float _alpha = 1.0
	if !_form as Actor
		return
	endIf

	string poolName = "STEB_OnAddTattoo"

	;where the search results are
	int foundTattoos = JValue.addToPool(JArray.object(), poolName)

	;the search template, based on the tattoo json
	int searchTemplate = JValue.addToPool(JValue.objectFromPrototype("{\"name\": \"" + _name + "\", \"section\":\"" + _section + "\"}"), poolName)

	int tattoo = 0
	
	;search for the template
	if SlaveTats.query_available_tattoos(searchTemplate, foundTattoos) ;returns true if an error ocurred
		debug.trace("[STEB] ERROR: OnAddTattoo query error")
		JValue.cleanPool(poolName)
		return
	endIf

	;set the optional parameters
	tattoo = JArray.getObj(foundTattoos, 0)
	JMap.setInt(tattoo, "color", _color)
    JMap.setFlt(tattoo, "invertedAlpha", 1.0 - _alpha)

	if _glowColor > 0
		JMap.setInt(tattoo, "glow", _glowColor)
	endif

	if _gloss
		JMap.setInt(tattoo, "gloss", 1)
	endIf

	if _lock
		JMap.setInt(tattoo, "locked", 1)
	endIf

	if SlaveTats.add_tattoo(_form as Actor, tattoo)
		debug.trace("[STEB] ERROR: OnAddTattoo add_tattoo error")
		JValue.cleanPool(poolName)
		return
	endIf
	
	if _last
		if SlaveTats.synchronize_tattoos(_form as Actor, _silent)
			Debug.Notification("[STEB] ERROR: OnAddTattoo synchronize_tattoos failed")
			JValue.cleanPool(poolName)
			return
		endif
	endIf
	    
	JValue.cleanPool(poolName)
EndEvent

;/
========================================================================
Remove a tattoo. Will trigger a mod event called STSimpleRemoveTattooReturn with the same parameters and a bool indicating if it had sucess
Example:
	int STevent = ModEvent.Create("STSimpleRemoveTattoo") 
	if (STevent)
	    ModEvent.PushForm(STevent, akActor)         ; Form - actor
	    ModEvent.PushString(STevent, sSection)     	; String - tattoo section (the folder name)
	    ModEvent.PushString(STevent, sTatooName)    ; String - name of tattoo
	    ModEvent.PushBool(STevent, false)           ; Bool - last = false (the tattoos are only removed when last = true, use it on batches)
	    ModEvent.PushBool(STevent, true)            ; Bool - silent = true (do not show a message)
	    ModEvent.Send(STevent)
	endif
========================================================================
/;
Event OnSimpleRemoveTattoo(Form _form, String _section, String _name, bool _last, bool _silent)
	if (_form as Actor)
		debug.Trace("[STEB] OnSimpleRemoveTattoo" + _section + " / " + _name)
		bool removed = SlaveTats.simple_remove_tattoo(_form as Actor, _section, _name, _last, _silent)
		int STcallback = ModEvent.Create("STSimpleRemoveTattooReturn")
		if (STcallback)
			ModEvent.PushForm(STcallback, _form)
	        ModEvent.PushString(STcallback, _section)
	        ModEvent.PushString(STcallback, _name)
	        ModEvent.PushBool(STcallback, _last)
	        ModEvent.PushBool(STcallback, _silent)
	        ModEvent.PushBool(STcallback, removed)
	        ModEvent.Send(STcallback)
		endif
	else
		debug.Trace("[STEB] ERROR: called OnSimpleRemoveTattoo on a not-actor")
	endIf
EndEvent

;/
========================================================================
Remove all tattoos from a determined section.
parameters:
	- Form _form: target
	- String _section: section name, ie, folder name on disk
	- bool _ignoreLock: remove locked tattoos too
	- bool _silent: do not show any message on the screen
========================================================================
/;
Event OnRemoveAllSectionTattoo(Form _form, String _section, bool _ignoreLock, bool _silent)
	if !_form as Actor
		debug.Trace("[STEB] ERROR: called OnRemoveAllSectionTattoo on a not-actor")
		return
	endIf

	string poolName = "STEB_OnRemoveAllSectionTattoo"
	;the search template, based on the tattoo json
	int searchTemplate = JValue.addToPool(JValue.objectFromPrototype("{\"section\":\"" + _section + "\"}"), poolName)

	if SlaveTats.remove_tattoos(_form as Actor, searchTemplate, _ignoreLock, _silent)
		debug.Trace("[STEB] ERROR: RemoveAllSectionTattoo remove_tattoos error")
	endIf

	if SlaveTats.synchronize_tattoos(_form as Actor, _silent)
		debug.Trace("[STEB] ERROR: RemoveAllSectionTattoo synchronize_tattoos error")
	endIf

	JValue.cleanPool(poolName)
EndEvent