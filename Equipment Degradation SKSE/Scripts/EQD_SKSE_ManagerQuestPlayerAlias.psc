Scriptname EQD_SKSE_ManagerQuestPlayerAlias extends ReferenceAlias  
{PlayerAlias script to manage destructible armor}

Int version = 0
Bool bDebugTrace = true
Bool bDebugNotification = true

Float kWeaponDurability01 = 0.1 ; 0.97
Float kWeaponDurability02 = 0.2 ; 0.975
Float kWeaponDurability03 = 0.3 ; 0.98
Float kWeaponDurability04 = 0.4 ; 0.985
Float kWeaponDurability05 = 0.5 ; 0.99

Float kArmorDurability01 = 0.1 ; 0.95
Float kArmorDurability02 = 0.2 ; 0.96
Float kArmorDurability03 = 0.3 ; 0.97
Float kArmorDurability04 = 0.4 ; 0.98
Float kArmorDurability05 = 0.5 ; 0.99

Float kPowerAttackDamageBonus = 0.05

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

; Weapon slot masks remain constant
Int rightHandSlotMask = 1
Int leftHandSlotMask = 0

; Local variables to track slot masks for equipped armor
; Set on equip and cleared on unequip because masks may vary based on the item
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
		Maintenance()
	endIf
endEvent


Function Maintenance()
	
	ScriptDebug("EQD Maintenance")
	
	version = 1
	
	Actor player = GetActorRef()
	player.AddPerk(EQD_DamageWeaponPerk)
	RegisterForSingleUpdate(0.1)

endFunction


Event OnUpdate()
	
	Actor selfRef = GetActorRef()
	
	Weapon weaponRH = selfRef.GetEquippedWeapon()
	if weaponRH
		rightHandDurability = GetWeaponDurability(weaponRH)
		ScriptDebug("RH Weapon: Durability: " + rightHandDurability + " Health: " + WornObject.GetItemHealthPercent(selfRef, rightHandSlotMask, -1))
	else
		rightHandDurability = 1.0
	endIf
	
	Weapon weaponLH = selfRef.GetEquippedWeapon(true)
	if weaponLH
		leftHandDurability = GetWeaponDurability(weaponLH)
		ScriptDebug("LH Weapon: Durability: " + leftHandDurability + " Health: " + WornObject.GetItemHealthPercent(selfRef, rightHandSlotMask, -1))
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
	
	; Set the damage for the hit to the item
	Float damageBonus = 0.0
	if abPowerAttack
		damageBonus = kPowerAttackDamageBonus
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
	HitSlotMask(rightHandSlotMask, rightHandDurability, damageBonus)

endFunction


Function HitWeaponLH(Float damageBonus = 0.0)
	
	ScriptDebug("Hit Weapon LH")
	HitSlotMask(leftHandSlotMask, leftHandDurability, damageBonus)

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
	If slotMask == rightHandSlotMask || slotMask == leftHandSlotMask
		itemHealth = WornObject.GetItemHealthPercent(selfRef, slotMask, -1)
	else
		itemHealth = WornObject.GetItemHealthPercent(selfRef, -1, slotMask)
	endIf
	
	; Validate damageable item based on item health
	if itemHealth < 1.1
		ScriptDebug("Item health low: " + itemHealth)
		return
	endIf
	
	; Reduce the health percent of the item by 0.1 to reduce its tempering value
	itemHealth = itemHealth - 0.1
	if slotMask == rightHandSlotMask || slotMask == leftHandSlotMask
		WornObject.SetItemHealthPercent(selfRef, slotMask, -1, itemHealth)
		Debug.Notification("Your weapon was damaged")
		ScriptDebug("New item health: " + WornObject.GetItemHealthPercent(selfRef, slotMask, -1))
	else
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
		return kWeaponDurability05
	ElseIf HasKeywordInList(akWeapon, EQD_WeaponMaterialsDurability04)
		return kWeaponDurability04
	ElseIf HasKeywordInList(akWeapon, EQD_WeaponMaterialsDurability03)
		return kWeaponDurability03
	ElseIf HasKeywordInList(akWeapon, EQD_WeaponMaterialsDurability02)
		return kWeaponDurability02
	ElseIf HasKeywordInList(akWeapon, EQD_WeaponMaterialsDurability01)
		return kWeaponDurability01
	EndIf

	; Default to durability 5 for unknown materials
	return kWeaponDurability05

EndFunction


Float Function GetArmorDurability(Armor akArmor)
	
	; Default to max durability for invalid input
	if !akArmor
		return 1.0
	endIf
	
	if HasKeywordInList(akArmor, EQD_ArmorMaterialsDurability05)
		return kArmorDurability05
	elseIf HasKeywordInList(akArmor, EQD_ArmorMaterialsDurability04)
		return kArmorDurability04
	elseIf HasKeywordInList(akArmor, EQD_ArmorMaterialsDurability03)
		return kArmorDurability03
	elseIf HasKeywordInList(akArmor, EQD_ArmorMaterialsDurability02)
		return kArmorDurability02
	elseIf HasKeywordInList(akArmor, EQD_ArmorMaterialsDurability01)
		return kArmorDurability01
	endIf

	; Default to durability 5 for unknown materials
	return kArmorDurability05

EndFunction


Function ScriptDebug(String akMessage)

	if bDebugTrace
		Debug.Trace(akMessage)
	endIf
	
	if bDebugNotification
		Debug.Notification(akMessage)
	endIf

endFunction