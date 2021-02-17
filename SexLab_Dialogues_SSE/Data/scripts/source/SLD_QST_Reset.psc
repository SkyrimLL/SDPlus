Scriptname SLD_QST_Reset extends Quest  

Quest Property _SLD_Controller  Auto  
Quest Property _SLD_MCM_menu  Auto  
Quest Property _SLD_MCM_menu_old  Auto  

Float fVersion = 0.0

Function _maintenance()
	If fVersion < 1.20190921 ; <--- Edit this value when updating
		fVersion = 1.20190921; and this
		Debug.Notification("[SLD_QST_Reset] Updating to SL Dialogues version: " + fVersion)
		; Update Code

		If ( _SLD_Controller.IsRunning() )
		;	_SLD_Controller.Stop()
		;	Debug.Messagebox("Stopping main SexLab Dialogues quest for maintenance.\n It should restart automatically." )
		;	_SLD_Controller.Start()
		EndIf

		If ( _SLD_MCM_menu_old.IsRunning() )
			_SLD_MCM_menu_old.Stop()
			Debug.Trace("[SLD_QST_Reset] Stopping old MCM menu.\n " )
		EndIf

		If ( _SLD_MCM_menu.IsRunning() )
			_SLD_MCM_menu.Stop()
			Debug.Trace("[SLD_QST_Reset] Restarting SexLab Dialogues MCM menu quest for maintenance.\n It should restart automatically." )
			_SLD_MCM_menu.Start()
		EndIf
	endif

EndFunction