;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 8
Scriptname _SDQF_WIAddItem03_00035B5A Extends Quest Hidden

;BEGIN ALIAS PROPERTY Owner
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Owner Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Contract
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Contract Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Thug1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Thug1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Thug2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Thug2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Thug3
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Thug3 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE _SDQS_WIAddItem03
Quest __temp = self as Quest
_SDQS_WIAddItem03 kmyQuest = __temp as _SDQS_WIAddItem03
;END AUTOCAST
;BEGIN CODE
kmyquest.SetNextEventGlobals()		;lives in parent script WorldInteractionsScript

; debug.trace("WIAddItem03 stage 0 adding contracts and disabling thugs.")

;disable the thugs, add note to inventory
ObjectReference Contract = Alias_Contract.GetReference()
Contract.Enable()
Alias_Thug1.getReference().addItem(Contract)
Alias_Thug1.getReference().disable()

;Alias_Thug2.getReference().addItem(kmyquest.pContract)
Alias_Thug2.getReference().disable()

;Alias_Thug3.getReference().addItem(kmyquest.pContract)
Alias_Thug3.getReference().disable()

kmyquest.registerForUpdate(5)	;poll every 5 seconds
kmyquest.gotoState("polling")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN AUTOCAST TYPE _SDQS_WIAddItem03
Quest __temp = self as Quest
_SDQS_WIAddItem03 kmyQuest = __temp as _SDQS_WIAddItem03
;END AUTOCAST
;BEGIN CODE
;enable thugs
; debug.trace("WIAddItem03 stage 10 enabling thugs")
Alias_Thug1.getReference().enable()
Alias_Thug2.getReference().enable()
Alias_Thug3.getReference().enable()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN AUTOCAST TYPE _SDQS_WIAddItem03
Quest __temp = self as Quest
_SDQS_WIAddItem03 kmyQuest = __temp as _SDQS_WIAddItem03
;END AUTOCAST
;BEGIN CODE
; debug.trace("WIAddItem03 stage 200 - Shut Down Stage")

Actor Player = Game.GetPlayer()
Actor Thug1 = Alias_Thug1.GetActorReference()
Actor Thug2 = Alias_Thug2.GetActorReference()
Actor Thug3 = Alias_Thug3.GetActorReference()

Thug1.addToFaction(kmyquest.WIs.WIPlayerEnemyFaction)
Thug2.addToFaction(kmyquest.WIs.WIPlayerEnemyFaction)
Thug3.addToFaction(kmyquest.WIs.WIPlayerEnemyFaction)

; debug.Messagebox("Thugs found you and attack!")
Thug1.startcombat(Player)
Thug2.startcombat(Player)
Thug3.startcombat(Player)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN AUTOCAST TYPE _SDQS_WIAddItem03
Quest __temp = self as Quest
_SDQS_WIAddItem03 kmyQuest = __temp as _SDQS_WIAddItem03
;END AUTOCAST
;BEGIN CODE
Alias_Thug1.GetActorReference().DeleteWhenAble()
Alias_Thug2.GetActorReference().DeleteWhenAble()
Alias_Thug3.GetActorReference().DeleteWhenAble()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
