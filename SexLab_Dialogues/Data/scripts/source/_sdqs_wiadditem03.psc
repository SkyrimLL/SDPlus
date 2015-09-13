Scriptname _SDQS_WIAddItem03 extends WorldInteractionsScript  Conditional
{Local extension of WorldInteractionScript}

Book Property pContract  Auto  Conditional
{The contract found on the thugs where the victim hires them to attack the player.}

float vThugDay Conditional
;Turn on the thugs when GameDaysPassed > than this.

ReferenceAlias Property pThug1  Auto  
{Pointer to Thug1 alias}
ReferenceAlias Property pThug2  Auto  
{Pointer to Thug3 alias}
ReferenceAlias Property pThug3  Auto  
{Pointer to Thug3 alias}

Location Property pDebugPlayerLoc Auto
Location Property pDebugThugLoc Auto

Bool pThug1Dead
Bool pThug1MarkedForDelete = False
Bool pThug2Dead
Bool pThug2MarkedForDelete = False
Bool pThug3Dead
Bool pThug3MarkedForDelete = False

;pGameDaysPassed is property declared in parent script, and set in the quest form, not surprisingly it points to the global variable GameDaysPassed

Event OnInit()
	pThug1MarkedForDelete = False
	pThug2MarkedForDelete = False
	pThug3MarkedForDelete = False
EndEvent

STATE polling	;set in stage 0
	EVENT onUpdate()	;registered in stage 0
; 		debug.trace("WIAdditem03Script polling for GameDaysPassed > vThugDay")
		if vThugDay == 0
			vThugDay = pGameDaysPassed.value + 1
; 			debug.trace("WIAdditem03Script setting vThugDay to " + vThugDay)
		elseif pGameDaysPassed.value > vThugDay
; 			debug.trace("WIAdditem03Script: GameDaysPassed > vThugDay, checking player not in the same location as Thug1")
			
			pDebugPlayerLoc = Game.getPlayer().getCurrentLocation()
			pDebugThugLoc = pThug1.getReference().getCurrentLocation()

			if Game.getPlayer().getCurrentLocation() != pThug1.getReference().getCurrentLocation()
				setstage(10)	;enable thugs
				gotoState("thugwatch")
			endif

		endif
	endEVENT
endSTATE

State thugwatch
	Event OnUpdate()
		pThug1Dead = ( pThug1.getReference() as Actor ).IsDead()
		pThug2Dead = ( pThug2.getReference() as Actor ).IsDead()
		pThug3Dead = ( pThug3.getReference() as Actor ).IsDead()
		
		If ( pThug1Dead && !pThug1MarkedForDelete )
			( pThug1.getReference() as ObjectReference ).DeleteWhenAble()
			pThug1MarkedForDelete = True
		EndIf
		If ( pThug2Dead && !pThug2MarkedForDelete )
			( pThug2.getReference() as ObjectReference ).DeleteWhenAble()
			pThug2MarkedForDelete = True
		EndIf
		If ( pThug2Dead && !pThug3MarkedForDelete )
			( pThug3.getReference() as ObjectReference ).DeleteWhenAble()
			pThug3MarkedForDelete = True
		EndIf
		
		If ( pThug1MarkedForDelete && pThug2MarkedForDelete && pThug3MarkedForDelete )
			Stop()
		EndIf
	EndEvent
EndState

