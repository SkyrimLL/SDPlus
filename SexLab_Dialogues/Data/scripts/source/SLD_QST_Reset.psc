Scriptname SLD_QST_Reset extends Quest  

Quest Property _SLD_Controller  Auto  
Quest Property _SLD_MCM_menu  Auto  

Float fVersion = 0.0

Function _maintenance()
	If fVersion < 1.20190907 ; <--- Edit this value when updating
		fVersion = 1.20190907; and this
		Debug.Notification("Updating to SL Dialogues version: " + fVersion)
		; Update Code

		If ( _SLD_Controller.IsRunning() )
		;	_SLD_Controller.Stop()
		;	Debug.Messagebox("Stopping main SexLab Dialogues quest for maintenance.\n It should restart automatically." )
		;	_SLD_Controller.Start()
		EndIf

		If ( _SLD_MCM_menu.IsRunning() )
			_SLD_MCM_menu.Stop()
			Debug.Trace("Restarting SexLab Dialogues MCM menu quest for maintenance.\n It should restart automatically." )
			_SLD_MCM_menu.Start()
		EndIf
	endif

EndFunction