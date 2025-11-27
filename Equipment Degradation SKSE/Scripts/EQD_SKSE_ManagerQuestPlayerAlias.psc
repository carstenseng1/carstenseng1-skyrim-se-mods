Scriptname EQD_SKSE_ManagerQuestPlayerAlias extends ReferenceAlias  
{PlayerAlias script to manage destructible armor}

Int version = 0

Perk Property EQD_DamageWeaponPerk  Auto

FormList Property EQD_ArmorMaterialsDurability01  Auto
FormList Property EQD_ArmorMaterialsDurability02  Auto
FormList Property EQD_ArmorMaterialsDurability03  Auto
FormList Property EQD_ArmorMaterialsDurability04  Auto
FormList Property EQD_ArmorMaterialsDurability05  Auto

FormList Property EQD_WeaponMaterialsDurability01  Auto
FormList Property EQD_WeaponMaterialsDurability02  Auto
FormList Property EQD_WeaponMaterialsDurability03  Auto
FormList Property EQD_WeaponMaterialsDurability04  Auto
FormList Property EQD_WeaponMaterialsDurability05  Auto

; Local variables to track slot masks for equipped armor
; Set on equip and cleared on unequip because masks may vary based on the item
; Weapon slot masks remain constant 0=left 1=right
Int helmetSlotMask = -1
Int cuirassSlotMask = -1
Int gauntletsSlotMask = -1
Int bootsSlotMask = -1
Int shieldSlotMask = -1

; Durability variables default to max durability of 1.0
Float rightHandDurability = 1.0
Float leftHandDurability = 1.0
Float helmetDurability = 1.0
Float cuirassDurability = 1.0
Float gauntletsDurability = 1.0
Float bootsDurability = 1.0
Float shieldDurability = 1.0

Event OnInit()
	Maintenance()
endEvent

Event OnPlayerLoadGame()
	if version == 0 || version != 1 ; Hard coded script version. Set 0 to force maintenance
		version = 1
		Maintenance()
	endIf
endEvent


Function Maintenance()
	
	ScriptDebug("EQD Maintenance")
	Actor player = GetActorRef()
	player.AddPerk(EQD_DamageWeaponPerk)
	RegisterForSingleUpdate(0.1)

endFunction


Event OnUpdate()
	
	Actor selfRef = GetActorRef()
	
	Weapon weaponRH = selfRef.GetEquippedWeapon()
	if weaponRH
		rightHandDurability = GetWeaponDurability(weaponRH)
		ScriptDebug("RH Weapon: Durability: " + rightHandDurability + " Health: " + WornObject.GetItemHealthPercent(selfRef, 1, 0))
	else
		rightHandDurability = 1.0
	endIf
	
	Weapon weaponLH = selfRef.GetEquippedWeapon(true)
	if weaponLH
		leftHandDurability = GetWeaponDurability(weaponLH)
		ScriptDebug("LH Weapon: Durability: " + leftHandDurability + " Health: " + WornObject.GetItemHealthPercent(selfRef, 0, 0))
	else
		leftHandDurability = 1.0
	endIf
	
endEvent


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	
	; Update durability for equipped weapons if a weapon was equipped
	; Handle in OnUpdate event to only update once when equipping is completed
	if akBaseObject as Weapon
		RegisterForSingleUpdate(0.1)
		return
	endIf
	
	; Ensure the equipped item is Armor
	Armor equippedArmor = akBaseObject as Armor
	if !equippedArmor
		return
	endIf
	
	; Set slot mask value for armor based on its type
	int slotMask = equippedArmor.GetSlotMask()
	if equippedArmor.isHelmet()
		helmetSlotMask = slotMask
		helmetDurability = GetArmorDurability(equippedArmor)
		ScriptDebug("Helmet: Durability: " + helmetDurability)
	elseIf equippedArmor.isCuirass()
		cuirassSlotMask = slotMask
		cuirassDurability = GetArmorDurability(equippedArmor)
		ScriptDebug("Cuirass: Durability: " +cuirassDurability)
	elseIf equippedArmor.isGauntlets()
		gauntletsSlotMask = slotMask
		gauntletsDurability = GetArmorDurability(equippedArmor)
		ScriptDebug("Gauntlets: Durability: " + gauntletsDurability)
	elseIf equippedArmor.isBoots()
		bootsSlotMask = slotMask
		bootsDurability = GetArmorDurability(equippedArmor)
		ScriptDebug("Boots: Durability: " + bootsDurability)
	elseIf equippedArmor.isShield()
		shieldSlotMask = slotMask
		shieldDurability = GetArmorDurability(equippedArmor)
		ScriptDebug("Shield: Durability: " + shieldDurability)
	endIf

endEvent


Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	
	; Update durability for equipped weapons if a weapon was equipped
	; Handle in OnUpdate event to only update once when equipping is completed
	if akBaseObject as Weapon
		RegisterForSingleUpdate(0.1)
		return
	endIf
	
	; Ensure the unequipped item is Armor
	Armor unequippedArmor = akBaseObject as Armor
	if !unequippedArmor
		return
	endIf
	
	; Clear slot mask value for armor based on its type
	if unequippedArmor.isHelmet()
		helmetSlotMask = -1
		helmetDurability = 1.0
	elseIf unequippedArmor.isCuirass()
		cuirassSlotMask = -1
		cuirassDurability = 1.0
	elseIf unequippedArmor.isGauntlets()
		gauntletsSlotMask = -1
		gauntletsDurability = 1.0
	elseIf unequippedArmor.isBoots()
		bootsSlotMask = -1
		bootsDurability = 1.0
	elseIf unequippedArmor.isShield()
		shieldSlotMask = -1
		shieldDurability = 1.0
	endIf
	
endEvent


Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	
	Actor selfRef = GetActorRef()
	
	; Add 0.05 bonus to damage value for power attacks
	Float damageBonus = 0.0
	if abPowerAttack
		damageBonus = 0.05
	endIf
	
	if abHitBlocked
		; Hit the equipped shield or weapon used to parry
		if selfRef.GetEquippedShield()
			HitShield(damageBonus)
		elseIf selfRef.GetEquippedWeapon()
			HitWeaponRH(damageBonus)
		endIf
	else
		HitArmor(damageBonus)
	endIf
 
endEvent


Function HitWeapon(Float damageBonus = 0.0)
	
	Actor selfRef = GetActorRef()
	
	Weapon weaponRH = selfRef.GetEquippedWeapon()
	Weapon weaponLH = selfRef.GetEquippedWeapon(true)

	If weaponRH && weaponLH
		; Choose right or left hand at random
		if Utility.RandomInt(0,1) == 0
			HitWeaponLH(damageBonus)
		else
			HitWeaponRH(damageBonus)
		endIf
	elseIf weaponRH
		HitWeaponRH(damageBonus)
	elseIf weaponLH
		HitWeaponLH(damageBonus)
	endIf

endFunction


Function HitWeaponRH(Float damageBonus = 0.0)
	
	ScriptDebug("Hit Weapon RH")
	HitSlotMask(1, rightHandDurability, damageBonus)

endFunction


Function HitWeaponLH(Float damageBonus = 0.0)
	
	ScriptDebug("Hit Weapon LH")
	HitSlotMask(0, leftHandDurability, damageBonus)

endFunction


Function HitShield(Float damageBonus = 0.0)

	ScriptDebug("Hit Shield")
	HitSlotMask(shieldSlotMask, shieldDurability, damageBonus)

endFunction


Function HitArmor(Float damageBonus = 0.0)

		; Set array of armor slot masks
		Int[] slotMaskArray = new Int[4]
		slotMaskArray[0] = helmetSlotMask
		slotMaskArray[1] = cuirassSlotMask
		slotMaskArray[2] = gauntletsSlotMask
		slotMaskArray[3] = bootsSlotMask
		
		; Set array of armor durability
		Float[] durabilityArray = new Float[4]
		durabilityArray[0] = helmetDurability
		durabilityArray[1] = cuirassDurability
		durabilityArray[2] = gauntletsDurability
		durabilityArray[3] = bootsDurability
		
		; Hit a random piece of armor
		Int index = Utility.RandomInt(0, 3)
		ScriptDebug("Hit Armor: Index: " + index)
		HitSlotMask(slotMaskArray[index], durabilityArray[index], damageBonus)

endFunction


Function HitSlotMask(Int slotMask, Float durability, Float damageBonus = 0.0)
	
	; Determine if a valid item slot mask was selected
	if slotMask == -1
		ScriptDebug("Hit Slot Mask -1")
		return
	endIf
	
	; Don't run calculations if durability is max
	if durability >= 1.0
		ScriptDebug("Hit Slot Mask: " + slotMask + " Durability: " + durability)
		return
	endIf
	
	; Set a random damage with added bonus
	Float damage = Utility.RandomFloat() + damageBonus
	
	; Don't damage item if it passed the durability test
	if damage <= durability
		return
	endif
	
	ScriptDebug("Hit Slot Mask: " + slotMask + " Durability: " + durability + " Damage: " + damage)
	
	; Get the current hit item health based on the selected slot mask, hand vs armor
	Actor selfRef = GetActorRef()
	Float itemHealth = 0.0
	If slotMask == 0 || slotMask == 1
		; Hand slot mask; 0=left 1=right
		; Must use 0 armor slot mask for hand slot mask to work
		itemHealth = WornObject.GetItemHealthPercent(selfRef, slotMask, 0) 
	else
		; Must use invalid hand slot (-1) for armor slot mask to work
		itemHealth = WornObject.GetItemHealthPercent(selfRef, -1, slotMask)
	endIf
	
	; Validate damageable item based on item health
	if itemHealth < 1.1
		ScriptDebug("Item health low: " + itemHealth)
		return
	endIf
	
	; Reduce the health percent of the item by 0.1 to reduce its tempering value
	itemHealth = itemHealth - 0.1
	if slotMask == 0 || slotMask == 1
		; Hand slot mask; 0=left 1=right
		; Must use 0 armor slot mask for hand slot mask to work
		WornObject.SetItemHealthPercent(selfRef, slotMask, 0, itemHealth)
		Debug.Notification("Your weapon was damaged")
		ScriptDebug("New item health: " + WornObject.GetItemHealthPercent(selfRef, slotMask, 0))
	else
		; Must use invalid hand slot (-1) for armor slot mask to work
		WornObject.SetItemHealthPercent(selfRef, -1, slotMask, itemHealth)
		Debug.Notification("Your armor was damaged")
		ScriptDebug("New item health: " + WornObject.GetItemHealthPercent(selfRef, -1, slotMask))
	endIf

endFunction


Bool Function HasKeywordInList(Form akBaseObject, FormList akList)
	
	Int iIndex = akList.GetSize() ; Indices are offset by 1 relative to size
	while iIndex
		iIndex -= 1
		Keyword material = akList.GetAt(iIndex) As Keyword
		if material
			if akBaseObject.HasKeyword(material)
				return true
			endIf
		endIf
	endWhile

	return false
	
EndFunction


Float Function GetWeaponDurability(Form akWeapon)
	
	; Default to max durability for invalid input
	If !akWeapon
		return 1.0
	EndIf
	
	If HasKeywordInList(akWeapon, EQD_WeaponMaterialsDurability05)
		return 0.99
	ElseIf HasKeywordInList(akWeapon, EQD_WeaponMaterialsDurability04)
		return 0.985
	ElseIf HasKeywordInList(akWeapon, EQD_WeaponMaterialsDurability03)
		return 0.98
	ElseIf HasKeywordInList(akWeapon, EQD_WeaponMaterialsDurability02)
		return 0.975
	ElseIf HasKeywordInList(akWeapon, EQD_WeaponMaterialsDurability01)
		return 0.97
	EndIf

	; Default to durability 5 for unknown materials
	return 0.99

EndFunction


Float Function GetArmorDurability(Armor akArmor)
	
	; Default to max durability for invalid input
	if !akArmor
		return 1.0
	endIf

	if HasKeywordInList(akArmor, EQD_ArmorMaterialsDurability05)
		return 0.99
	elseIf HasKeywordInList(akArmor, EQD_ArmorMaterialsDurability04)
		return 0.98
	elseIf HasKeywordInList(akArmor, EQD_ArmorMaterialsDurability03)
		return 0.97
	elseIf HasKeywordInList(akArmor, EQD_ArmorMaterialsDurability02)
		return 0.96
	elseIf HasKeywordInList(akArmor, EQD_ArmorMaterialsDurability01)
		return 0.95
	endIf

	; Default to durability 5 for unknown materials
	return 0.99

EndFunction


Function ScriptDebug(String akMessage)

	;Debug.Trace(akMessage)
	;Debug.Notification(akMessage)

endFunction