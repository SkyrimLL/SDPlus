Scriptname sd_addon_summon_gargoyle extends ObjectReference  

;      https://www.creationkit.com/index.php?title=Complete_Example_Scripts#A_Fully_Functional_Dwemer_Button
 
Event OnCellAttach() ; this event runs when cell is loaded containing this scripted object
	PlayAnimation("Open")
EndEvent
 
Event OnActivate(ObjectReference akActionRef)
	If akActionRef == PlayerREF
		PlayAnimationAndWait("Trigger01", "done") ; sound and animation
	        If QSTAstrolabeButtonPressX
		     QSTAstrolabeButtonPressX.Play(Self)
	        EndIf
	        Debug.MessageBox("Joy!") ; actual code for what button should do
	EndIf
EndEvent

Actor Property PlayerREF Auto
Sound Property QSTAstrolabeButtonPressX Auto
 