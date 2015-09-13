Scriptname _sdmes_polymorphgeneric extends activemagiceffect  

{Transforms the player into a monster.  Created by Jared Bangerter 2012.}

;======================================================================================;

; PROPERTIES /

;=============/

Race Property PlayerOriginalRace auto

Race Property ArgonianRace auto
Race Property ArgonianRaceVampire auto
Race Property BretonRace auto
Race Property BretonRaceVampire auto
Race Property DarkElfRace auto
Race Property DarkElfRaceVampire auto
Race Property HighElfRace auto
Race Property HighElfRaceVampire auto
Race Property ImperialRace auto
Race Property ImperialRaceVampire auto
Race Property KhajiitRace auto
Race Property KhajiitRaceVampire auto
Race Property NordRace auto
Race Property NordRaceVampire auto
Race Property OrcRace auto
Race Property OrcRaceVampire auto
Race Property RedguardRace auto
Race Property RedguardRaceVampire auto
Race Property WoodElfRace auto
Race Property WoodElfRaceVampire auto

ObjectReference Property PolymorphChest  Auto  
Quest Property CompanionsTrackingQuest auto
Faction Property PlayerWerewolfFaction auto
Shout Property MonsterShout auto
Race Property PolymorphRace auto
Spell Property PolymorphSpell auto
Faction Property MonsterFaction auto
Weapon Property MonsterWeapon auto
VisualEffect Property VFX1  Auto
VisualEffect Property VFX2  Auto   
Weapon Property ReturnItem Auto
VisualEffect Property VFX3 Auto
float PlayerHP
float PlayerMG
float PlayerST
Spell Property TransformationEffect Auto
Spell Property DiseaseSanguinareVampiris Auto
Spell Property VampireSunDamage01 auto
Spell Property VampireSunDamage02 auto
Spell Property VampireSunDamage03 auto
Spell Property VampireSunDamage04 auto
;======================================================================================;

; EVENTS /

;=============/


Event OnEffectStart(Actor Target, Actor Caster)
if (Target.GetActorBase().GetRace() != PolymorphRace)
Game.GetPlayer().UnequipAll()

    ; Game.GetPlayer().RemoveAllItems(LycanStash)

	; get player's race so we have it permanently for werewolf switch back
	PlayerOriginalRace = Game.GetPlayer().GetRace()
; 	Debug.Trace("CSQ: Storing player's race as " + PlayerOriginalRace)

	if     (PlayerOriginalRace == ArgonianRaceVampire)
; 		Debug.Trace("CSQ: Player was Argonian Vampire; storing as Argonian.")
		PlayerOriginalRace = ArgonianRace
	elseif (PlayerOriginalRace == BretonRaceVampire)
; 		Debug.Trace("CSQ: Player was Breton Vampire; storing as Breton.")
		PlayerOriginalRace = BretonRace
	elseif (PlayerOriginalRace == DarkElfRaceVampire)
; 		Debug.Trace("CSQ: Player was Dark Elf Vampire; storing as Dark Elf.")
		PlayerOriginalRace = DarkElfRace
	elseif (PlayerOriginalRace == HighElfRaceVampire)
; 		Debug.Trace("CSQ: Player was Hiegh Elf Vampire; storing as High Elf.")
		PlayerOriginalRace = HighElfRace
	elseif (PlayerOriginalRace == ImperialRaceVampire)
; 		Debug.Trace("CSQ: Player was Imperial Vampire; storing as Imperial.")
		PlayerOriginalRace = ImperialRace
	elseif (PlayerOriginalRace == KhajiitRaceVampire)
; 		Debug.Trace("CSQ: Player was Khajiit Vampire; storing as Khajiit.")
		PlayerOriginalRace = KhajiitRace
	elseif (PlayerOriginalRace == NordRaceVampire)
; 		Debug.Trace("CSQ: Player was Nord Vampire; storing as Nord.")
		PlayerOriginalRace = NordRace
	elseif (PlayerOriginalRace == OrcRaceVampire)
; 		Debug.Trace("CSQ: Player was Orc Vampire; storing as Orc.")
		PlayerOriginalRace = OrcRace
	elseif (PlayerOriginalRace == RedguardRaceVampire)
; 		Debug.Trace("CSQ: Player was Redguard Vampire; storing as Redguard.")
		PlayerOriginalRace = RedguardRace
	elseif (PlayerOriginalRace == WoodElfRaceVampire)
; 		Debug.Trace("CSQ: Player was Wood Elf Vampire; storing as Wood Elf.")
		PlayerOriginalRace = WoodElfRace
	endif

; 	Debug.Trace("CSQ: Storing player's race as " + PlayerOriginalRace)

Game.GetPlayer().DispelSpell (DiseaseSanguinareVampiris)
Game.GetPlayer().DispelSpell (VampireSunDamage01)
Game.GetPlayer().DispelSpell (VampireSunDamage02)
Game.GetPlayer().DispelSpell (VampireSunDamage03)
Game.GetPlayer().DispelSpell (VampireSunDamage04)

 ; unequip magic
    Spell left = Game.GetPlayer().GetEquippedSpell(0)
    Spell right = Game.GetPlayer().GetEquippedSpell(1)
    Spell power = Game.GetPlayer().GetEquippedSpell(2)
    Shout voice = Game.GetPlayer().GetEquippedShout()
    if (left != None)
        Game.GetPlayer().UnequipSpell(left, 0)
    endif
    if (right != None)
        Game.GetPlayer().UnequipSpell(right, 1)
    endif
    if (power != None)
        ; some players are overly clever and sneak a power equip between casting
        ;  beast form and when we rejigger them there. this will teach them.
;         Debug.Trace("WEREWOLF: " + power + " was equipped; removing.")
        Game.GetPlayer().UnequipSpell(power, 2)
    else
;         Debug.Trace("WEREWOLF: No power equipped.")
    endif
    if (voice != None)
        ; same deal here, but for shouts
;         Debug.Trace("WEREWOLF: " + voice + " was equipped; removing.")
        Game.GetPlayer().UnequipShout(voice)
    else
;         Debug.Trace("WEREWOLF: No shout equipped.")
    endif

 ; unequip weapons
    Weapon wleft = Game.GetPlayer().GetEquippedWeapon(0)
    Weapon wright = Game.GetPlayer().GetEquippedWeapon(1)
    if (left != None)
        Game.GetPlayer().UnequipItem(wleft, 0)
    endif
    if (right != None)
        Game.GetPlayer().UnequipItem(wright, 1)
    endif
   
Debug.SetGodMode(true)
Game.GetPlayer().ResetHealthAndLimbs()

Game.ForceThirdPerson()

Game.GetPlayer().RestoreActorValue("magicka", 999999999999)
Game.GetPlayer().RestoreActorValue("stamina", 999999999999)
Game.GetPlayer().RestoreActorValue("health", 999999999999)
Target.SetRace(PolymorphRace)
Game.GetPlayer().SetHeadTracking(false)
Game.GetPlayer().AddSpell(SPELLCLEAR1)
Game.GetPlayer().EquipSpell(SPELLCLEAR1, 0)
Game.GetPlayer().AddSpell(SPELLCLEAR2)
Game.GetPlayer().EquipSpell(SPELLCLEAR2, 1)
Game.GetPlayer().AddItem(WEAPONCLEAR1)
Game.GetPlayer().EquipItem(WEAPONCLEAR1, 0)
Game.GetPlayer().AddItem(WEAPONCLEAR2)
Game.GetPlayer().EquipItem(WEAPONCLEAR2, 1)
Game.GetPlayer().EquipSpell(PolymorphSpell, 0)
Game.GetPlayer().AddSpell(PolymorphSpell)
Game.GetPlayer().EquipSpell(PolymorphSpell, 0)
Game.GetPlayer().AddToFaction(MonsterFaction)
Game.GetPlayer().AddItem(MonsterWeapon, 1, true)
Game.GetPlayer().EquipItem(MonsterWeapon, 1, true)
Game.GetPlayer().AddItem(MonsterAmmo, 99, true)
Game.GetPlayer().EquipItem(MonsterAmmo, 99, true)
Game.GetPlayer().AddItem(MonsterArmor, 1, true)
Game.GetPlayer().EquipItem(MonsterArmor, 1, true)
Game.DisablePlayerControls(false, false, false, false, false, true, false)
Game.SetPlayerReportCrime(false)
Game.GetPlayer().SetAttackActorOnSight(true)
Game.GetPlayer().AddToFaction(PlayerWerewolfFaction)
Game.GetPlayer().AddShout(MonsterShout)
Game.GetPlayer().EquipShout(MonsterShout)
int playersHealth = Game.GetPlayer().GetActorValue("health") as int
PlayerHP = playersHealth
int playersMagicka = Game.GetPlayer().GetActorValue("magicka") as int
PlayerMG = playersMagicka
int playersStamina = Game.GetPlayer().GetActorValue("stamina") as int
PlayerST = playersStamina
Game.GetPlayer().SetActorValue("health", (PlayerHP/4 + HP))
Game.GetPlayer().SetActorValue("magicka", (PlayerMG/4 + Magicka))
Game.GetPlayer().SetActorValue("stamina", (PlayerST/4 + Stamina))
Game.GetPlayer().SetActorValue("healrate", 1)
Game.GetPlayer().RestoreActorValue("health", 999999999999)
VFX1.Play(Caster)
VFX2.Play(Caster)
Debug.SetGodMode(false)

endif
EndEvent


Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  if akBaseItem == (ReturnItem)
    Debug.Trace("I picked up " + aiItemCount + "x " + akBaseItem + " from the world")
Game.GetPlayer().RemoveItem(ReturnItem)
Game.GetPlayer().RemoveSpell(PolymorphSpell)
Game.GetPlayer().UnEquipSpell(PolymorphSpell, 0)
Game.GetPlayer().RemoveFromFaction(MonsterFaction)
Game.GetPlayer().RemoveItem(MonsterWeapon)
Game.GetPlayer().UnEquipItem(MonsterWeapon, 1)
Game.GetPlayer().RemoveShout(MonsterShout)
Game.GetPlayer().UnEquipShout(MonsterShout)
Game.GetPlayer().RemoveItem(MonsterAmmo, 99)
Game.GetPlayer().UnEquipItem(MonsterAmmo)
Game.GetPlayer().RemoveItem(MonsterArmor)
Game.GetPlayer().UnEquipItem(MonsterArmor)
Game.GetPlayer().AddSpell(SPELLCLEAR1)
Game.GetPlayer().EquipSpell(SPELLCLEAR1, 0)
Game.GetPlayer().AddSpell(SPELLCLEAR2)
Game.GetPlayer().EquipSpell(SPELLCLEAR2, 1)
Game.GetPlayer().AddItem(WEAPONCLEAR1)
Game.GetPlayer().EquipItem(WEAPONCLEAR1, 0)
Game.GetPlayer().AddItem(WEAPONCLEAR2)
Game.GetPlayer().EquipItem(WEAPONCLEAR2, 1)
Game.EnablePlayerControls()
Game.SetPlayerReportCrime(true)
Game.GetPlayer().SetAttackActorOnSight(false)
Game.GetPlayer().RemoveFromFaction(PlayerWerewolfFaction)
Debug.Trace("WEREWOLF: Setting race " + (CompanionsTrackingQuest as CompanionsHousekeepingScript).PlayerOriginalRace + " on " + Game.GetPlayer())
VFX3.Play(Game.GetPlayer(), afTime = 3)
Game.GetPlayer().SetRace(PlayerOriginalRace)
Game.GetPlayer().SetActorValue("health", (PlayerHP))
Game.GetPlayer().SetActorValue("magicka", (PlayerMG))
Game.GetPlayer().SetActorValue("stamina", (PlayerST))
Game.GetPlayer().SetActorValue("healrate", 1)
VFX1.Stop(Game.GetPlayer())
VFX2.Stop(Game.GetPlayer())
Game.GetPlayer().RestoreActorValue("health", 999999999999999999999999999)
Game.GetPlayer().DispelSpell(TransformationEffect)
Game.GetPlayer().SetScale (1.0)

endif
endEvent



Ammo Property MonsterAmmo Auto



Armor Property MonsterArmor Auto
SPELL Property SPELLCLEAR1  Auto  

SPELL Property SPELLCLEAR2  Auto  

WEAPON Property WEAPONCLEAR1  Auto  

WEAPON Property WEAPONCLEAR2  Auto  
Int Property HP  Auto  

Int Property Magicka  Auto  

Int Property Stamina  Auto  