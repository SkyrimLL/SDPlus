Scriptname _sdmes_falmerglowlight extends activemagiceffect  



Event OnEffectStart(Actor akTarget, Actor akCaster)
		Int iFalmerSkinColor = Math.LeftShift(255, 24) + Math.LeftShift(100, 16) + Math.LeftShift(200, 8) + 255
		StorageUtil.SetIntValue(none, "_SLH_iSkinColor", iFalmerSkinColor ) 
		StorageUtil.SetFloatValue(none, "_SLH_fBreast", 2.5 ) 
		StorageUtil.SetFloatValue(none, "_SLH_fWeight", 20.0 ) 
		StorageUtil.SetIntValue(none, "_SLH_iForcedRefresh", 1)

EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)

EndEvent