Scriptname _sdqs_dream_destinations extends Quest  
 

ReferenceAlias Property _SDRA_dest_list  Auto  
ReferenceAlias Property _SDRA_dest_inn  Auto  
ReferenceAlias Property _SDRA_dest_ship  Auto  
ReferenceAlias Property _SDRA_dest_falmer  Auto  
ReferenceAlias Property _SDRA_dest_house  Auto  
ReferenceAlias Property _SDRA_dest_cemetary  Auto  

Function getDestination ( )
	int RandomNum
	ReferenceAlias destinationAlias = None

	RandomNum = Utility.RandomInt(0, 100)

	if (RandomNum > 80)
		_SDRA_dream_destination.ForceRefTo( _SDRA_dest_house.GetReference() as ObjectReference )
	ElseIf (RandomNum > 70)
		_SDRA_dream_destination.ForceRefTo(_SDRA_dest_inn.GetReference() as ObjectReference )
	ElseIf (RandomNum > 50)
		_SDRA_dream_destination.ForceRefTo( _SDRA_dest_cemetary.GetReference() as ObjectReference )
	ElseIf (RandomNum > 30)
		_SDRA_dream_destination.ForceRefTo( _SDRA_dest_ship.GetReference() as ObjectReference )
	Else
		_SDRA_dream_destination.ForceRefTo( _SDRA_dest_falmer.GetReference() as ObjectReference )
	EndIf

	; _SDRA_dream_destination.ForceRefTo(  _SDRA_dest_list.GetReference() as ObjectReference )

EndFunction

Event OnInit()
	
;	Debug.Notification("[_sd_dream_dest] House: " +   _SDRA_dest_house.GetReference() as ObjectReference )
;	Debug.Notification("[_sd_dream_dest] Inn: " +   _SDRA_dest_inn.GetReference() as ObjectReference )
;	Debug.Notification("[_sd_dream_dest] Cemetary: " +   _SDRA_dest_cemetary.GetReference() as ObjectReference )
;	Debug.Notification("[_sd_dream_dest] Ship: " +   _SDRA_dest_ship.GetReference() as ObjectReference )
;	Debug.Notification("[_sd_dream_dest] Falmer: " +   _SDRA_dest_falmer.GetReference() as ObjectReference )
 
EndEvent

 
ReferenceAlias Property _SDRA_dest_location  Auto  

ReferenceAlias Property _SDRA_destination  Auto  

ReferenceAlias Property _SDRA_dream_destination  Auto  
