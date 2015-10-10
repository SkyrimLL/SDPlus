Scriptname SLD_QST_Reset extends Quest  

Quest Property _SLD_Controller  Auto  

Float fVersion = 0.0

Function _maintenance()
	If fVersion < 1.20151010 ; <--- Edit this value when updating
		fVersion = 1.20151010; and this
		Debug.Notification("Updating to SL Dialogues version: " + fVersion)
		; Update Code

		If ( _SLD_Controller.IsRunning() )
		;	_SLD_Controller.Stop()
		;	Debug.Messagebox("Stopping main SexLab Dialogues quest for maintenance.\n It should restart automatically." )
		;	_SLD_Controller.Start()
		EndIf

	endif

EndFunction