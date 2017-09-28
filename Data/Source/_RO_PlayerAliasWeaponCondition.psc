Scriptname _RO_PlayerAliasWeaponCondition extends ReferenceAlias  

GlobalVariable Property _RO_Debug Auto

FormList Property _RO_WeaponBaseLists  Auto  
FormList Property _RO_WeaponDamagedLists  Auto  
FormList Property _RO_WeaponConditionPerks Auto
FormList Property _RO_WeaponConditionSpells Auto

Int weaponIndex = -1 ; index corresponding to the weapon material type

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)

	if akBaseObject as Weapon
		RegisterForSingleUpdate(1.0)
	endIf

endEvent


Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)

	if akBaseObject as Weapon
		RegisterForSingleUpdate(1.0)
	endIf

endEvent


Event OnUpdate()

	Actor target = GetActorRef()
	RemoveWeaponConditionPerks(target)
	AddWeaponConditionPerk(target, target.GetEquippedWeapon())

endEvent


Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	
	Actor target = GetActorRef()
	Actor agActor = akAggressor as Actor
	Weapon sourceWeapon = akSource as Weapon
	
	if (agActor && sourceWeapon)
		Form RightHandWeapon = agActor.GetEquippedWeapon(); this gets the sword that the enemy had in their right hand and stores it as an object variable
		Form LeftHandWeapon = agActor.GetEquippedWeapon(true); this gets the sword that the enemy had in their left hand and stores it as an object variable
		
		if (sourceWeapon == RightHandWeapon || sourceWeapon == LeftHandWeapon)
			;Damage is from weapon and not enchantments
			if abHitBlocked
				Armor shield = target.GetEquippedShield()
				if shield
					; TODO: Damage shield
				else
					if weaponIndex >= 0 && weaponIndex < _RO_WeaponConditionSpells.GetSize()
						_RO_DebugNotification("Block:  weapon index: " + weaponIndex)
						Spell weaponConditionSpell = _RO_WeaponConditionSpells.GetAt(weaponIndex) as Spell
						weaponConditionSpell.Cast(target, NONE)
					endIf
				endIf
			endIf
		endIf
	endIf
 
EndEvent


Function RemoveWeaponConditionPerks(Actor akTarget)

	Int i = _RO_WeaponConditionPerks.GetSize()
	While i
		i -= 1
		Perk weaponConditionPerk = _RO_WeaponConditionPerks.GetAt(i) as Perk
		akTarget.RemovePerk(weaponConditionPerk)
	endWhile

endFunction


Function AddWeaponConditionPerk(Actor akTarget, Weapon akWeapon)
	
	if (!akWeapon)
		_RO_DebugNotification("No weapon")
		return
	endIf
	
	weaponIndex = -1
	
	Int i = _RO_WeaponBaseLists.GetSize()
	While i
		i -= 1
		FormList weaponList = _RO_WeaponBaseLists.GetAt(i) as FormList
		Int foundIndex = weaponList.Find(akWeapon)
		
		if foundIndex >= 0
			weaponIndex = i
			Perk weaponConditionPerk = _RO_WeaponConditionPerks.GetAt(i) as Perk
			if weaponConditionPerk
				akTarget.AddPerk(weaponConditionPerk)
				_RO_DebugNotification("Added weapon condition perk: " + i)
				i = 0
			else
				_RO_DebugNotification("Error: No perk at found index: " + i)
			endIf
		endIf
	EndWhile

endFunction

Function _RO_DebugNotification(string text)
	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf
endFunction