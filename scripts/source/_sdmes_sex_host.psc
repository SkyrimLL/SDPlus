Scriptname _SDMES_sex_host extends activemagiceffect
{ USED }
Import Utility

_SDQS_snp Property snp Auto
_SDQS_functions Property funct Auto
_SDQS_config Property config Auto
SexLabFramework property SexLab auto

ReferenceAlias Property _SDRAP_grovemarker  Auto
ReferenceAlias Property _SDRAP_hostarmor  Auto
Keyword Property _SDKP_isbeast  Auto  

Spell Property _SDSP_cum  Auto
Sound Property _SDSM_sloppy  Auto
Sound Property _SDSM_cum  Auto

Int uiPosition
Int uiSubPosition = 0
Int uiStage = 0
Int uiSpuge = 0

int i_SDSM_sloppy_id
int i_SDSM_cum_id

Float fUpdateCum
Float fUpdateSound
Float fUpdateGrunt
Bool  bUpdateGrunt
Float fUpdateSex
Float fStartSex
Float fGCRT

Bool bUpdatePos
Bool bPositionUpdate = False

Actor kTarget
Actor kCaster
ObjectReference kHostArmor = None

VisualEffect Property SprigganFX  Auto  
Float fDistance

Event OnUpdate()
	If ( kCaster.IsDead() || kTarget.IsDead() )
		; Self.Dispel()
		Return
	EndIf

	fGCRT = GetCurrentRealTime()
	fDistance = kCaster.GetDistance( kTarget )

	If ( fGCRT > fUpdateGrunt - 0.3 && bUpdateGrunt )
		bUpdateGrunt = False
		kTarget.SetExpressionOverride( 16, RandomInt( 60, 90 ) )
	EndIf

	; A value smaller than the amount of time it takes your code to complete plus a little
	; overhead time can cause the game to freeze as the scripting system becomes overwhelmed.
	; For any value less than a few seconds RegisterForSingleUpdate is much safer.
	If ( Self )
		RegisterForSingleUpdate( 0.1 )
	EndIf
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	; Debug.Notification( "Host: Effect start" )
	kTarget = akTarget
	kCaster = akCaster
	kHostArmor = _SDRAP_hostarmor.GetReference() as ObjectReference

	fStartSex = GetCurrentRealTime()
	fUpdateSex = GetCurrentRealTime() + RandomFloat( 10.0, 15.0 )
	fUpdateGrunt = GetCurrentRealTime() + 4.0
	fUpdateSound = GetCurrentRealTime() + 1.5
	fUpdateCum = GetCurrentRealTime() + 0.2

	; HACK: position handled by sexlab
	; uiPosition = Math.Floor( snp._SDUIP_position * 4 )


	Debug.MessageBox("Roots swarm arount you...")

	; kTarget.RemoveAllItems(akTransferTo = _SD_sprigganHusk)
	; Utility.Wait(1.0)

	kCaster.RemoveAllItems(akTransferTo = kTarget)
	Utility.Wait(1.0)

	_SDSP_cum.RemoteCast(kTarget, kTarget, kTarget)
	kCaster.GetActorBase().SetProtected()
	kCaster.SetAlpha(0.0)
	SprigganFX.Play( akTarget, 120 )

	Utility.Wait(1.0)


	If  (SexLab.ValidateActor( SexLab.PlayerRef ) > 0)
		Debug.SendAnimationEvent(Game.GetPlayer(), "IdleForceDefaultState")
		; HACK: select rough sexlab animations 
		; sslBaseAnimation[] animations = SexLab.GetAnimationsByTags(1, "Masturbation,Female")

		; HACK: get actors for sexlab
		; actor[] sexActors = new actor[1]
		; sexActors[0] = SexLab.PlayerRef

		; HACK: start sexlab animation
		; SexLab.StartSex(sexActors, animations)
		SexLab.QuickStart(SexLab.PlayerRef, AnimationTags = "Solo")
	EndIf

	If ( Self )
		RegisterForSingleUpdate( 0.1 )
	EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; Debug.Notification( "Host: Effect end" )
	Game.EnablePlayerControls( abMovement = True )
	Game.SetPlayerAIDriven( False )

	If ( kCaster.IsDead() )
		kCaster.DeleteWhenAble()
	Else

	     _SD_sprigganHusk.MoveTo( _SDRAP_grovemarker.GetReference() )
	     ; _SD_sprigganHusk.Disable()

	     kCaster.MoveTo( _SDRAP_grovemarker.GetReference() )
	     kCaster.SetAlpha(1.0)
	     kCaster.SetRestrained()
	     kCaster.Disable()

	EndIf
	funct.setRandomActorExpression( kTarget, -1 )
EndEvent

ObjectReference Property _SD_sprigganHusk  Auto  
