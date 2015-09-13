Scriptname _SDMES_sex extends activemagiceffect
{ USED }
Import Utility

_SDQS_snp Property snp Auto
_SDQS_functions Property funct Auto
_SDQS_config Property config Auto
SexLabFramework property SexLab auto

Sound Property _SDSM_sloppy  Auto
Sound Property _SDSM_cum  Auto
ImpactDataSet Property _SDIDSP_cum  Auto  

Int uiPosition
Int uiSubPosition = 0
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

Bool bPositionUpdate = False

Actor kTarget
Actor kCaster

Float fDistance

Event OnUpdate()

EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)

   	If ( akTarget.IsDead() || akCaster.IsDead() )
		Self.Dispel()
		Return
	EndIf

	; Mood -  neutral = 0, angry = 1, fear, happy = 3, sad, surprised, puzzled, disgusted
	int avMood = akCaster.GetAV("Mood") as Int
	int avConfidence = akCaster.GetAV("Confidence") as Int
	int avMorality = akCaster.GetAV("Morality") as Int

	If  (avMorality < 2)  ; angry or disgusted or depraved

		funct.SanguineRape( akCaster, akTarget , "Aggressive")

	Else ; happy or brave

		funct.SanguineRape( akCaster, akTarget , "Sex")

	EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; funct.setRandomActorExpression( akTarget, -1 )
	; funct.setRandomActorExpression( akCaster, -1 )
EndEvent

 


