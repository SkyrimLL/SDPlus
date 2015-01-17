Scriptname _sdmes_falmerglowlight extends activemagiceffect  



Event OnEffectStart(Actor akTarget, Actor akCaster)
		If (StorageUtil.GetIntValue(none, "_SLH_iHormones")==1)
			Int iFalmerSkinColor = Math.LeftShift(255, 24) + Math.LeftShift(100, 16) + Math.LeftShift(200, 8) + 255
			Float breastMod = 0.05
			Float weightMod = 2.0

			If (Utility.RandomInt(0,100)>80)
				Int randomNum = Utility.RandomInt(0,100)
				If (randomNum>90)
					Debug.MessageBox("Glowing fluids spread from the Falmer's skin across yours like quicksilver, making your breasts grow and tingle painfully with poisonous ripples. ")
					breastMod = 0.5
					weightMod = 15.0
					StorageUtil.SetIntValue(none, "_SLH_iForcedRairLoss", 1)

				ElseIf (randomNum>80)
					Debug.MessageBox("The purpose of the glowing substance is clear to you now, fattening you up for breeding and turning you into an irresistible beacon for the Falmers and their pets.")
					breastMod = 0.25
					weightMod = 10.0
					StorageUtil.SetIntValue(none, "_SLH_iForcedRairLoss", 1)

				ElseIf (randomNum>40)
					Debug.Notification("Your skin burns under glowing droplets.")
					breastMod = 0.1
					weightMod = 5.0

				ElseIf (randomNum>20)
					Debug.Notification("The tingling in your nipples is driving you mad.")
					breastMod = 0.25
					weightMod = 2.0

				EndIf

			EndIf

			StorageUtil.SetIntValue(none, "_SLH_iSkinColor", iFalmerSkinColor ) 
			StorageUtil.SetFloatValue(none, "_SLH_fBreast", StorageUtil.GetFloatValue(none, "_SLH_fBreast" ) + breastMod ) 
			StorageUtil.SetFloatValue(none, "_SLH_fWeight", StorageUtil.GetFloatValue(none, "_SLH_fWeight" ) + weightMod ) 
			StorageUtil.SetIntValue(none, "_SLH_iForcedRefresh", 1)
		EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)

EndEvent