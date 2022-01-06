Scriptname _RO_DestructibleArmorQuestPlayerAlias extends ReferenceAlias  
{PlayerAlias script to manage destructible armor}


GlobalVariable Property _RO_Version  Auto
Int version = 0

GlobalVariable Property _RO_Debug  Auto

FormList Property _RO_EquippedArmor  Auto  
Float Property pNormalDamageBase = 0.0  Auto
Float Property pPowerAttackDamageBase = 0.0  Auto
SPELL Property _RO_DestructibleWeaponSpell  Auto  

Armor equippedShield


Event OnInit()
	Maintenance()
endEvent

Event OnPlayerLoadGame()
	if version == 0 || version != _RO_Version.GetValueInt()
		Maintenance()
	endIf
endEvent

Function Maintenance()
	
	_RO_Note("Fjør Tall: Destructible Armor Maintenance")
	version = _RO_Version.GetValueInt()
	
	; Remove all tracked destructible armor
	_RO_EquippedArmor.Revert()
	equippedShield = NONE

endFunction


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	
	; Ensure the equipped item is Armor
	Armor equippedArmor = akBaseObject as Armor
	if !equippedArmor
		return
	endIf
	
	; Store the Base Object for the equipped Armor since the reference is not persistent
	Actor actorRef = self.GetActorRef() as Actor
	if equippedArmor == actorRef.GetEquippedShield()
		equippedShield = equippedArmor
		_RO_Note("Shield registered: " + equippedShield.GetFormID())
	else
		_RO_EquippedArmor.AddForm(equippedArmor)
		_RO_Note("Armor registered: " + equippedArmor.GetFormID())
	endIf

endEvent


Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	
	; Ensure the equipped item is Armor
	if !(akBaseObject as Armor)
		return
	endIf
	
	; Remove Armor from tracking lists
	if _RO_EquippedArmor.HasForm(akBaseObject)
		_RO_EquippedArmor.RemoveAddedForm(akBaseObject)
		_RO_Note("Armor unregistered: " + akBaseObject.GetFormID())
	endIf

	; Clear reference to equipped shield if the unequipped object is the currently tracked shield
	if akBaseObject == equippedShield
		equippedShield = NONE
		_RO_Note("Shield unregistered: " + akBaseObject.GetFormID())
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
	
	Float damageBase = 0.0
	if abPowerAttack
		damageBase = pPowerAttackDamageBase
	else
		damageBase = pNormalDamageBase
	endIf
	
	if abHitBlocked
		; Hit the equipped shield or weapon used to parry
		Armor targetShield = target.GetEquippedShield()
		if targetShield
			; Update reference to equippedShield in case it was missed
			equippedShield = targetShield
			
			; Attempt to damage the shield
			HitArmor(equippedShield as _RO_DestructibleArmor, damageBase)
		elseIf target.GetEquippedWeapon() as _RO_DestructibleWeapon
			_RO_Note("Hit weapon from parry")
			_RO_DestructibleWeaponSpell.Cast(target, target)
		endIf
	else
		; Hit a random piece of armor
		_RO_DestructibleArmor randArmor = GetRandomDestructibleArmor()
		if randArmor
			HitArmor(randArmor, damageBase)
		endIf
	endIf
 
EndEvent


_RO_DestructibleArmor Function GetRandomDestructibleArmor()
	
	; Get a range of indices to check for equipped armor to damage
	; Use at least 4 to accomodate 4 armor slots
	Int maxIndex = _RO_EquippedArmor.GetSize() - 1
	if maxIndex < 4
		maxIndex = 4
	endIf
	
	; Choose a random Armor from the equipped armor list
	Int randIndex = Utility.RandomInt(0, maxIndex)
	Form randForm = _RO_EquippedArmor.GetAt(randIndex)
		
	; Abort now if no form was selected
	if !randForm
		return NONE
	endIf
	
	; Check that the chosen armor is equipped and remove from the list if not
	if !GetActorRef().isEquipped(randForm)
		_RO_Note("Hit armor that is not equipped: " + randForm.GetFormID())
		_RO_EquippedArmor.RemoveAddedForm(randForm)
		
		; Abort since we selected an invalid armor
		return NONE
	endIf
	
	;  Return random armor cast as destructible
	; Non-destructible armor will return NONE. This is intended.
	return randForm as _RO_DestructibleArmor

endFunction


Function HitArmor(_RO_DestructibleArmor akArmor, Float damageBase = 0.0)
	
	; Validate destructible given armor
	if !akArmor || !akArmor.DamagedArmor
		_RO_Note("Hit non-destructible armor: " + akArmor.GetFormID())
		return
	endIf
	
	Float damage = Utility.RandomFloat() + damageBase
	Float durability = akArmor.Durability.GetValue()
	
	_RO_Note("Hit armor: " + akArmor.GetFormID() + " damage: " + damage + " durability: " + durability)
	if damage > durability
		Actor actorRef = self.GetActorRef()
				
		; Unequip and remove the current armor reference being damaged
		actorRef.UnequipItem(akArmor, false, true)
		actorRef.RemoveItem(akArmor, 1, true)
		
		; Add and equip the damaged version of the armor
		actorRef.EquipItem(akArmor.DamagedArmor, false, true)
		
		; Message player
		Debug.Notification("Your armor is damaged")
	endIf

endFunction


Function _RO_Note(String text)

	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf

endFunction