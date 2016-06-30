Scriptname _SDMES_bound extends activemagiceffect  
{ USED }
_SDQS_functions Property funct  Auto
_SDQS_fcts_constraints Property fctConstraints  Auto
_SDQS_fcts_slavery Property fctSlavery  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

ReferenceAlias Property _SDRAP_master  Auto  
GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_ArmbinderKnee  Auto  

Keyword[] Property notKeywords  Auto  
Idle[] Property _SDIAP_bound  Auto  
Idle Property _SDIAP_reset  Auto  

Faction Property SexLabActiveFaction  Auto  
SexLabFramework property SexLab auto

Int sleepType
Actor kTarget
Actor kPlayer
ObjectReference kMaster

Int iTrust  
Int iDisposition 
Float fKneelingDistance 

Float fRFSU = 0.1
int throttle = 0 

; =============================================
; Deprecated - effect moved into fct_constraints script and called from sdras_slave script

Event OnUpdate()
	; fctConstraints.CollarUpdate()

	; RegisterForSingleUpdate( fRFSU )
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	; fctConstraints.CollarEffectStart(akTarget, akCaster)

	; RegisterForSingleUpdate( fRFSU )
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; fctConstraints.CollarEffectFinish(akTarget, akCaster)


EndEvent

