Scriptname _RO_PlayerAliasArmorCondition extends ReferenceAlias  

GlobalVariable Property _RO_Debug Auto

FormList Property _RO_ArmorBaseLists  Auto  
FormList Property _RO_ArmorDamagedLists  Auto  
FormList Property _RO_EquippedArmor  Auto  
Float Property pChance  Auto

Int[] armorListIndexArray
ObjectReference[] armorRefArray

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	
	if akBaseObject as Armor
		_RO_EquippedArmor.AddForm(akBaseObject)
		
		Int index = _RO_EquippedArmor.Find(akBaseObject)
		if index >= 0
			_RO_DebugNotification("Armor added. index: " + index)
		else
			_RO_DebugNotification("Faild to add armor.")
		endIf
	endIf

endEvent


Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)

	if akBaseObject as Armor
		_RO_EquippedArmor.RemoveAddedForm(akBaseObject)
		
		Int index = _RO_EquippedArmor.Find(akBaseObject)
		if index < 0
			_RO_DebugNotification("Armor removed")
		endIf
	endIf

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
			if abHitBlocked == false
				Float fRand = Utility.RandomFloat()
				Float fMult = _RO_EquippedArmor.GetSize()
				if fMult == 0
					return
				endIf
				
				if abPowerAttack
					fMult += 1.0
				endIf
				
				if fRand * fMult <= pChance
					DamageRandomArmor()
				endIf
			endIf
		endIf
	endIf
 
EndEvent


Function DamageRandomArmor()

	Int randIndex = Math.Floor( Utility.RandomFloat() * _RO_EquippedArmor.GetSize() )
	
	Armor targetArmor = _RO_EquippedArmor.GetAt(randIndex) as Armor
	if !targetArmor
		_RO_DebugNotification("No armor at index: " + randIndex)
		return
	endIf
	
	DamageArmor(targetArmor)
	
endFunction

Function DamageArmor(Armor akArmor)
	
	if (!akArmor)
		_RO_DebugNotification("No armor given to damage")
		return
	endIf
	
	Actor actorRef = self.GetActorRef() as Actor
	if !actorRef.IsEquipped(akArmor)
		_RO_DebugNotification("Cannot damage armor that is not equipped.")
		return
	endIf
	
	Int i = _RO_ArmorBaseLists.GetSize()
	while i
		i -= 1
		FormList armorList = _RO_ArmorBaseLists.GetAt(i) as FormList
		Int foundIndex = armorList.Find(akArmor)
		
		if foundIndex >= 0
			i = 0 ; stop iterating
			FormList damagedArmorList = _RO_ArmorDamagedLists.GetAt(i) as FormList
			Armor damagedArmor = damagedArmorList.GetAt(foundIndex) as Armor
			if damagedArmor
				actorRef.UnequipItem(akArmor)
				actorRef.RemoveItem(akArmor)
				; actorRef.AddItem(damagedArmor)
				actorRef.EquipItem(damagedArmor)
			else
				_RO_DebugNotification("No damaged armor at index: " + foundIndex)
			endIf
		endIf
	endWhile

endFunction

Function _RO_DebugNotification(string text)

	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf

endFunction
