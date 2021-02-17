Scriptname SLD_SkyShardAlias extends ReferenceAlias  

Quest Property _SLD_MageQuest  Auto  

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	Actor akActor = None	

	akActor = akNewContainer as Actor

	Debug.Notification("Skyshard changes hands..")
	Debug.Trace("[SD] Skyshard On Container changed")
	Debug.Trace("[SD] akNewContainer: " + akNewContainer)
	Debug.Trace("[SD] Game.GetPlayer(): " + Game.GetPlayer())
	Debug.Trace("[SD] _SLD_MageQuest.GetStageDone(100): " + _SLD_MageQuest.GetStageDone(100))
	Debug.Trace("[SD] _SLD_MageQuest.GetStageDone(105): " + _SLD_MageQuest.GetStageDone(105))


	if (akNewContainer == Game.GetPlayer()) && (_SLD_MageQuest.GetStageDone(100)==1) && (_SLD_MageQuest.GetStageDone(105)==0)
		_SLD_MageQuest.SetStage(105)
	endif

EndEvent