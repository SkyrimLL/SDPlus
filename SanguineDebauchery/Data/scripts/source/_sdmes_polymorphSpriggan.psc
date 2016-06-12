Scriptname _sdmes_polymorphSpriggan extends activemagiceffect  
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
Spell Property TransformationSpell Auto
Spell Property TransformationEffect Auto
Spell Property DiseaseSanguinareVampiris Auto
Spell Property VampireSunDamage01 auto
Spell Property VampireSunDamage02 auto
Spell Property VampireSunDamage03 auto
Spell Property VampireSunDamage04 auto

Actor Player 
;======================================================================================;

; EVENTS /

;=============/

Float fRFSU = 0.1
Int   iDaysPassed 
int   iGameDateLastCheck = -1
Int   iDaysSinceLastCheck

Event OnEffectStart(Actor Target, Actor Caster)
    Player = Game.GetPlayer()

    if (Target.GetActorBase().GetRace() != PolymorphRace)
        TransformationEffect.Cast(Player,Player)
        Player.UnequipAll()

        ; Player.RemoveAllItems(LycanStash)

    	; get player's race so we have it permanently for werewolf switch back
    	PlayerOriginalRace = Player.GetRace()
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

        Player.DispelSpell (DiseaseSanguinareVampiris)
        Player.DispelSpell (VampireSunDamage01)
        Player.DispelSpell (VampireSunDamage02)
        Player.DispelSpell (VampireSunDamage03)
        Player.DispelSpell (VampireSunDamage04)

     ; unequip magic
        Spell left = Player.GetEquippedSpell(0)
        Spell right = Player.GetEquippedSpell(1)
        Spell power = Player.GetEquippedSpell(2)
        Shout voice = Player.GetEquippedShout()
        if (left != None)
            Player.UnequipSpell(left, 0)
        endif
        if (right != None)
            Player.UnequipSpell(right, 1)
        endif
        if (power != None)
            ; some players are overly clever and sneak a power equip between casting
            ;  beast form and when we rejigger them there. this will teach them.
    ;         Debug.Trace("WEREWOLF: " + power + " was equipped; removing.")
            Player.UnequipSpell(power, 2)
        else
    ;         Debug.Trace("WEREWOLF: No power equipped.")
        endif
        if (voice != None)
            ; same deal here, but for shouts
    ;         Debug.Trace("WEREWOLF: " + voice + " was equipped; removing.")
            Player.UnequipShout(voice)
        else
    ;         Debug.Trace("WEREWOLF: No shout equipped.")
        endif

     ; unequip weapons
        Weapon wleft = Player.GetEquippedWeapon(0)
        Weapon wright = Player.GetEquippedWeapon(1)
        if (left != None)
            Player.UnequipItem(wleft, 0)
        endif
        if (right != None)
            Player.UnequipItem(wright, 1)
        endif
       
        Debug.SetGodMode(true)
        Player.ResetHealthAndLimbs()

        Game.ForceThirdPerson()

        Player.RestoreActorValue("magicka", 999999999999)
        Player.RestoreActorValue("stamina", 999999999999)
        Player.RestoreActorValue("health", 999999999999)
        Target.SetRace(PolymorphRace)
        Player.SetHeadTracking(false)
        Player.AddSpell(SPELLCLEAR1)
        Player.EquipSpell(SPELLCLEAR1, 0)
        Player.AddSpell(SPELLCLEAR2)
        Player.EquipSpell(SPELLCLEAR2, 1)
        Player.AddItem(WEAPONCLEAR1)
        Player.EquipItem(WEAPONCLEAR1, 0)
        Player.AddItem(WEAPONCLEAR2)
        Player.EquipItem(WEAPONCLEAR2, 1)
        Player.EquipSpell(PolymorphSpell, 1)
        Player.AddSpell(PolymorphSpell)
        Player.EquipSpell(PolymorphSpell, 1)
        Player.AddToFaction(MonsterFaction)
        Player.AddItem(MonsterWeapon, 0, true)
        Player.EquipItem(MonsterWeapon, 0, true)
        Player.AddItem(MonsterAmmo, 99, true)
        Player.EquipItem(MonsterAmmo, 99, true)
        Player.AddItem(MonsterArmor, 1, true)
        Player.EquipItem(MonsterArmor, 1, true)
        Game.DisablePlayerControls(false, false, false, false, false, true, false)
        Game.SetPlayerReportCrime(false)
        Player.SetAttackActorOnSight(true)
        Player.AddToFaction(PlayerWerewolfFaction)
        Player.AddShout(MonsterShout)
        Player.EquipShout(MonsterShout)
        int playersHealth = Player.GetActorValue("health") as int
        PlayerHP = playersHealth
        int playersMagicka = Player.GetActorValue("magicka") as int
        PlayerMG = playersMagicka
        int playersStamina = Player.GetActorValue("stamina") as int
        PlayerST = playersStamina
        Player.SetActorValue("health", (PlayerHP/4 + HP))
        Player.SetActorValue("magicka", (PlayerMG/4 + Magicka))
        Player.SetActorValue("stamina", (PlayerST/4 + Stamina))
        Player.SetActorValue("healrate", 1)
        Player.RestoreActorValue("health", 999999999999)
        VFX1.Play(Caster)
        VFX2.Play(Caster)
        Debug.SetGodMode(false)

        SprigganFX.Play( Player, 30 )

        If StorageUtil.HasIntValue(Player, "_SD_iSprigganTransformCount")
            StorageUtil.SetIntValue(Player, "_SD_iSprigganTransformCount", StorageUtil.GetIntValue(Player, "_SD_iSprigganTransformCount") + 1)
        Else
            StorageUtil.SetIntValue(Player, "_SD_iSprigganTransformCount", 1)
        EndIf

        StorageUtil.SetIntValue(Player, "_SD_iSprigganPlayer", 1)

        RegisterForSingleUpdate( fRFSU )

    endif
EndEvent

Event OnUpdate()
    iDaysPassed = Game.QueryStat("Days Passed")

    if (iGameDateLastCheck == -1)
        iGameDateLastCheck = iDaysPassed
    EndIf

    iDaysSinceLastCheck = (iDaysPassed - iGameDateLastCheck ) as Int
    ; Debug.Notification( "[SD] Player status - days: " + iDaysSinceLastCheck + " > " + StorageUtil.GetIntValue(Player, "_SD_iSprigganTransformCount") )

    If (iDaysSinceLastCheck >= StorageUtil.GetIntValue(Player, "_SD_iSprigganTransformCount"))
        Player.AddItem(ReturnItem, 1 , True)
    Endif

    RegisterForSingleUpdate( fRFSU )
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    Player = Game.GetPlayer()

    if akBaseItem == (ReturnItem)
        Debug.Trace("I picked up " + aiItemCount + "x " + akBaseItem + " from the world")
         TransformationEffect.Cast(Player,Player)
  
        Player.RemoveItem(ReturnItem, 1, True)
        Player.RemoveSpell(PolymorphSpell)
        Player.UnEquipSpell(PolymorphSpell, 0)
        Player.RemoveFromFaction(MonsterFaction)
        Player.RemoveItem(MonsterWeapon)
        Player.UnEquipItem(MonsterWeapon, 1)
        Player.RemoveShout(MonsterShout)
        Player.UnEquipShout(MonsterShout)
        Player.RemoveItem(MonsterAmmo, 99)
        Player.UnEquipItem(MonsterAmmo)
        Player.RemoveItem(MonsterArmor)
        Player.UnEquipItem(MonsterArmor)
        Player.AddSpell(SPELLCLEAR1)
        Player.EquipSpell(SPELLCLEAR1, 0)
        Player.AddSpell(SPELLCLEAR2)
        Player.EquipSpell(SPELLCLEAR2, 1)
        Player.AddItem(WEAPONCLEAR1)
        Player.EquipItem(WEAPONCLEAR1, 0)
        Player.AddItem(WEAPONCLEAR2)
        Player.EquipItem(WEAPONCLEAR2, 1)
        Game.EnablePlayerControls()
        Game.SetPlayerReportCrime(true)
        Player.SetAttackActorOnSight(false)
        Player.RemoveFromFaction(PlayerWerewolfFaction)
        Debug.Trace("WEREWOLF: Setting race " + (CompanionsTrackingQuest as CompanionsHousekeepingScript).PlayerOriginalRace + " on " + Player)
        VFX3.Play(Player, afTime = 3)
        Player.SetRace(PlayerOriginalRace)
        Player.SetActorValue("health", (PlayerHP))
        Player.SetActorValue("magicka", (PlayerMG))
        Player.SetActorValue("stamina", (PlayerST))
        Player.SetActorValue("healrate", 1)
        VFX1.Stop(Player)
        VFX2.Stop(Player)
        Player.RestoreActorValue("health", 999999999999999999999999999)
        Player.DispelSpell(TransformationSpell)
        
        Player.SetScale (1.0)

        SprigganFX.Play( Player, 30 )
        StorageUtil.SetIntValue(Player, "_SD_iSprigganPlayer", 0)
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

VisualEffect Property SprigganFX  Auto  
