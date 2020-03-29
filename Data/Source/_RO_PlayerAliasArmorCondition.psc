Scriptname _RO_PlayerAliasArmorCondition extends ReferenceAlias  

GlobalVariable Property _RO_Debug  Auto
FormList Property _RO_EquippedArmor  Auto  
Float Property pDamageBonus = 0.0 Auto

SPELL Property _RO_DestructibleWeaponSpell  Auto  

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	
	if akBaseObject as Armor
		_RO_EquippedArmor.AddForm(akBaseObject)
	endIf

endEvent


Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)

	if akBaseObject as Armor
		_RO_EquippedArmor.RemoveAddedForm(akBaseObject)
	endIf

endEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	
	Actor target = GetActorRef()
	Actor agActor = akAggressor as Actor
	Weapon sourceWeapon = akSource as Weapon
	
	; Ensure a aggressor and a source weapon is given
	if (!agActor || !sourceWeapon)
		_RO_Note("Hit without aggressor and weapon")
		return
	endIf
	
	; Ensure the agressor actually has the weapon equipped - Damage is from weapon and not enchantments
	Form RightHandWeapon = agActor.GetEquippedWeapon(); this gets the sword that the enemy had in their right hand and stores it as an object variable
	Form LeftHandWeapon = agActor.GetEquippedWeapon(true); this gets the sword that the enemy had in their left hand and stores it as an object variable
	if (sourceWeapon != RightHandWeapon && sourceWeapon != LeftHandWeapon)
		return
	endIf
	
	Float damageBonus = pDamageBonus
	if abPowerAttack
			damageBonus += 0.1
	endIf
	
	if abHitBlocked
		_RO_DestructibleArmor shield = target.GetEquippedShield() as _RO_DestructibleArmor
		if shield
			HitDestructibleArmor(shield, damageBonus)
		elseIf target.GetEquippedWeapon() as _RO_DestructibleWeapon
			_RO_DestructibleWeaponSpell.Cast(target, target)
		endIf
	else
		_RO_DestructibleArmor randArmor = GetRandomDestructibleArmor()
		if randArmor
			HitDestructibleArmor(randArmor, damageBonus)
		endIf
	endIf
 
EndEvent


_RO_DestructibleArmor Function GetRandomDestructibleArmor()

	Int maxIndex = _RO_EquippedArmor.GetSize() - 1
	if maxIndex < 4
		maxIndex = 4
	endIf
	
	Int randIndex = Utility.RandomInt(0, maxIndex)
	
	return _RO_EquippedArmor.GetAt(randIndex) as _RO_DestructibleArmor
	
endFunction


Function HitDestructibleArmor(_RO_DestructibleArmor akArmor, Float damageBonus = 0.0)
	
	if !akArmor
		_RO_Note("No armor given to damage")
		return
	endIf
	
	Actor actorRef = self.GetActorRef() as Actor
	
	Float damage = Utility.RandomFloat() + damageBonus
	
	_RO_Note("Hit armor: " + damage)
	if damage > akArmor.Durability.GetValue()
		actorRef.UnequipItem(akArmor)
		actorRef.RemoveItem(akArmor, 1, true)
		actorRef.EquipItem(akArmor.DamagedArmor, false, true)
	endIf

endFunction


Function _RO_Note(String text)

	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf

endFunction
