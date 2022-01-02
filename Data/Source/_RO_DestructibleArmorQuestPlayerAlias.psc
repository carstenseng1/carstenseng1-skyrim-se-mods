Scriptname _RO_DestructibleArmorQuestPlayerAlias extends ReferenceAlias  
{PlayerAlias script to manage destructible armor}


GlobalVariable Property _RO_Version  Auto
Float version = 0.0

GlobalVariable Property _RO_Debug  Auto

FormList Property _RO_EquippedArmor  Auto  
Float Property pDamageBonus = 0.0 Auto
SPELL Property _RO_DestructibleWeaponSpell  Auto  

ObjectReference equippedShield


Event OnInit()
	Maintenance()
endEvent

Event OnPlayerLoadGame()
	Maintenance()
endEvent

Function Maintenance()
	
	bool isDebugMode = _RO_Debug.GetValue()
	
	if version != 0.0 && version == _RO_Version.GetValue()
		return
	endIf
	version = _RO_Version.GetValue()
	
	_RO_Note("Fjør Tall: Destructible Armor Maintenance")

	; Remove all tracked destructible armor
	_RO_EquippedArmor.Revert()
	equippedShield = NONE

endFunction


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	
	; Ensure the equipped item is Armor
	if !akBaseObject as Armor
		return
	endIf
	
	; Store the ObjectReference for the equipped Armor
	Actor actorRef = self.GetActorRef() as Actor
	if akBaseObject == actorRef.GetEquippedShield()
		equippedShield = akReference
	else
		_RO_EquippedArmor.AddForm(akReference)
	endIf

endEvent


Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)

	; Remove both Base Object and Reference from tracking lists
	; Old versions of this script used Base Object while newer versions use Reference
	; Removing both ensures cleanup
	if _RO_EquippedArmor.HasForm(akBaseObject)
		_RO_EquippedArmor.RemoveAddedForm(akBaseObject)
	endIf
	if _RO_EquippedArmor.HasForm(akReference)
		_RO_EquippedArmor.RemoveAddedForm(akReference)
	endIf

	; Clear reference to equipped shield if the unequipped object reference is the currently tracked shield
	if akReference == equippedShield
		equippedShield = NONE
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
		; Hit the equipped shield or weapon used to parry
		if equippedShield.GetBaseObject() as _RO_DestructibleArmor
			HitArmor(equippedShield, damageBonus)
		elseIf target.GetEquippedWeapon() as _RO_DestructibleWeapon
			_RO_DestructibleWeaponSpell.Cast(target, target)
		endIf
	else
		; Hit a random piece of armor
		ObjectReference armorRef = GetRandomDestructibleArmorRef()
		if armorRef
			HitArmor(armorRef, damageBonus)
		endIf
	endIf
 
EndEvent


ObjectReference Function GetRandomDestructibleArmorRef()

	Int maxIndex = _RO_EquippedArmor.GetSize() - 1
	if maxIndex < 4
		maxIndex = 4
	endIf
	
	; Choose a random ObjectReference from the equipped armor list
	; If the chosen ObjectReference has a base object that is destructible armor, return the reference
	Int randIndex = Utility.RandomInt(0, maxIndex)
	ObjectReference ref = _RO_EquippedArmor.GetAt(randIndex) as ObjectReference
	if ref.GetBaseObject() as _RO_DestructibleArmor
		return ref
	endIf
	
	; Return NONE if an ObjectReference for a destructible armor was not selected
	return NONE

endFunction


Function HitArmor(ObjectReference akArmorRef, Float damageBonus = 0.0)
	
	; Ensure given ObjectReference is for a destructible armor
	_RO_DestructibleArmor destructibleArmor = akArmorRef.GetBaseObject() as _RO_DestructibleArmor
	if !destructibleArmor
		_RO_Note("No destructible armor ref given to damage")
		return
	endIf
	
	Actor actorRef = self.GetActorRef() as Actor
	
	Float damage = Utility.RandomFloat() + damageBonus
	
	_RO_Note("Hit armor: " + damage)
	if damage > destructibleArmor.Durability.GetValue()
		; Unequip and remove the current armor reference being damaged
		actorRef.UnequipItem(akArmorRef)
		actorRef.RemoveItem(akArmorRef, 1, true)
		
		; Add and equip the damaged version of the armor
		actorRef.EquipItem(destructibleArmor.DamagedArmor, false, true)
	endIf

endFunction


Function _RO_Note(String text)

	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf

endFunction