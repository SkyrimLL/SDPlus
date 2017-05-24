;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_thugslave_shortcut Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Int iRandomFate = Utility.RandomInt(0,100)
Bool bPlayerSold = false

if (!bPlayerSold) && (iRandomFate>80)
	bPlayerSold = WolfClubEnslave()

	if (bPlayerSold)
		kQuest.SetStage(26)
		Debug.MessageBox("Your owner wraps a bag over your head and leads you in total darkness. After what seem like hour, you finally stop inside of a cave. In the distance, the sounds of laughs and drinks are mixed with load moans and menacing howls.")
	endif
endIf

if (!bPlayerSold) && (iRandomFate>40)
	bPlayerSold = SimpleSlaveryEnslave()

	if (bPlayerSold)
		kQuest.SetStage(26)
		Debug.MessageBox("Your owner wraps a bag over your head and leads you in total darkness. The long and harrowing walk stops in what sounds like a wooden warehouse. Sounds of chains and appreciative whispers reveal you are being sold to a slave auction house.")
	endif
endIf

if (!bPlayerSold) && (iRandomFate>20)
	bPlayerSold = RedWaveEnslave()

	if (bPlayerSold)
		kQuest.SetStage(26)
		Debug.MessageBox("Your owner wraps a bag over your head and leads you in total darkness. After hours of a painful walk, you finally stop inside of a boat. A strong smell of smoke, booze and sweat fills the air around you. Laughs and moans are coming from below deck. Are you being sold to a brothel?")
	endif
endIf

if (!bPlayerSold)
	Game.FadeOutGame(true, true, 0.1, 15)
	kQuest.SetStage(25)
endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property kQuest  Auto  


bool function WolfClubEnslave() global
	int handle = ModEvent.Create("WolfClubEnslavePlayer")
	if handle
		return ModEvent.Send(handle)
	endif
	return false
endfunction

bool function SimpleSlaveryEnslave() global
	int idx = Game.GetModByName( "SimpleSlavery.esp" )
	if ( idx != 255 )
	    ;; The mod is loaded, so we can use it:
	    ObjectReference PlayerActorRef = Game.GetPlayer() as ObjectReference
	    PlayerActorRef.SendModEvent("SSLV Entry")
	    return true
	    ;; ... other stuff for your mod ...
	else
	    ;; ... other stuff for your mod ...
	endIf
	return false
endfunction


bool function RedWaveEnslave( )  

	IF (StorageUtil.GetIntValue(none, "_SLS_iStories")==1)
		SendModEvent("_SLS_PCStartRedWave","No Pregnancy")
		return True
	Else
		return False
	Endif

EndFunction