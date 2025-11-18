Scriptname _RO_DestructibleArmorQuestPlayerAlias extends ReferenceAlias  
{PlayerAlias script to manage destructible armor}


Float Property pDurability01  Auto
Float Property pDurability02  Auto
Float Property pDurability03  Auto
Float Property pDurability04  Auto
Float Property pDurability05  Auto

FormList Property _RO_ArmorMaterialsDurability01  Auto
FormList Property _RO_ArmorMaterialsDurability02  Auto
FormList Property _RO_ArmorMaterialsDurability03  Auto
FormList Property _RO_ArmorMaterialsDurability04  Auto
FormList Property _RO_ArmorMaterialsDurability05  Auto

FormList Property _RO_WeaponMaterialsDurability01  Auto
FormList Property _RO_WeaponMaterialsDurability02  Auto
FormList Property _RO_WeaponMaterialsDurability03  Auto
FormList Property _RO_WeaponMaterialsDurability04  Auto
FormList Property _RO_WeaponMaterialsDurability05  Auto
  
Float Property pPowerAttackDamageMult = 1.0  Auto  

; Local variables to track slot masks for equipped armor
; Set on equip and cleared on unequip because masks may vary based on the item
Int rightHandSlotMask = 0 ; Constant and only using right because only RH weapon blocks hits
Int helmetSlotMask = -1
Int cuirassSlotMask = -1
Int gauntletsSlotMask = -1
Int bootsSlotMask = -1
Int shieldSlotMask = -1

Float rightHandDurability = 1.0
Float helmetDurability = 1.0
Float cuirassDurability = 1.0
Float gauntletsDurability = 1.0
Float bootsDurability = 1.0
Float shieldDurability = 1.0


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	
	; Ensure the equipped item is Armor
	Armor equippedArmor = akBaseObject as Armor
	if equippedArmor
		; Set slot mask value for armor based on its type
		int slotMask = equippedArmor.GetSlotMask()
		if equippedArmor.isHelmet()
			helmetSlotMask = slotMask
			helmetDurability = GetArmorDurability(equippedArmor)
		elseIf equippedArmor.isCuirass()
			cuirassSlotMask = slotMask
			cuirassDurability = GetArmorDurability(equippedArmor)
		elseIf equippedArmor.isGauntlets()
			gauntletsSlotMask = slotMask
			gauntletsDurability = GetArmorDurability(equippedArmor)
		elseIf equippedArmor.isBoots()
			bootsSlotMask = slotMask
			bootsDurability = GetArmorDurability(equippedArmor)
		elseIf equippedArmor.isShield()
			shieldSlotMask = slotMask
			shieldDurability = GetArmorDurability(equippedArmor)
		endIf
		
		; Done setting armor values
		return
	endIf
	
	; Set durability for weapon equipped in right hand if that what was equipped
	Weapon equippedWeapon = akBaseObject as Weapon
	if equippedWeapon && GetActorRef().GetEquippedWeapon()
		rightHandDurability = GetWeaponDurability(equippedWeapon)
	endIf

endEvent


Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	
	; Ensure the unequipped item is Armor
	Armor unequippedArmor = akBaseObject as Armor
	if !unequippedArmor
		return
	endIf
	
	; Clear slot mask value for armor based on its type
	if unequippedArmor.isHelmet()
		helmetSlotMask = -1
	elseIf unequippedArmor.isCuirass()
		cuirassSlotMask = -1
	elseIf unequippedArmor.isGauntlets()
		gauntletsSlotMask = -1
	elseIf unequippedArmor.isBoots()
		bootsSlotMask = -1
	elseIf unequippedArmor.isShield()
		shieldSlotMask = -1
	endIf

endEvent


Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	
	Actor target = GetActorRef()
	
	; Determine which equipment slot is taking the hit
	Int hitSlotMask = -1
	Float durability = 1.0
	
	if abHitBlocked
		; Hit the equipped shield or weapon used to parry
		if  GetActorRef().GetEquippedShield()
			hitSlotMask = shieldSlotMask
			durability = shieldDurability
		elseIf GetActorRef().GetEquippedWeapon()
			hitSlotMask = rightHandSlotMask
			durability = rightHandDurability
		endIf
	else
		; Hit a random piece of armor
		Int[] armorSlotMaskArray = new Int[4]
		armorSlotMaskArray[0] = helmetSlotMask
		armorSlotMaskArray[1] = cuirassSlotMask
		armorSlotMaskArray[2] = gauntletsSlotMask
		armorSlotMaskArray[3] = bootsSlotMask
		
		Float[] armorDurabilityArray = new Float[4]
		armorDurabilityArray[0] = helmetDurability
		armorDurabilityArray[1] = cuirassDurability
		armorDurabilityArray[2] = gauntletsDurability
		armorDurabilityArray[3] = bootsDurability
		
		int index = Utility.RandomInt(0, 3)
		hitSlotMask = armorSlotMaskArray[index]
		durability = armorDurabilityArray[index]
	endIf
	
	; Determine if a valid item slot mask was selected
	if hitSlotMask == -1
		return
	endIf
	
	; Set the damage for the hit to the item
	Float damageMult = 1.0
	if abPowerAttack
		damageMult = pPowerAttackDamageMult
	endIf
	Float damage = Utility.RandomFloat() * damageMult
		
	; Don't damage item if it passed the durability test
	if damage <= durability
		return
	endif
	
	; Get the current hit item health based on the selected slot mask, hand vs armor
	Float hitItemHealth = 0.0
	If hitSlotMask == rightHandSlotMask
		hitItemHealth = WornObject.GetItemHealthPercent(GetActorRef(), hitSlotMask, -1)
	else
		hitItemHealth = WornObject.GetItemHealthPercent(GetActorRef(), -1, hitSlotMask)
	endIf
	
	; Validate damageable item based on item health
	if hitItemHealth < 1.1
		return
	endIf
	
	; Reduce the health percent of the item by 0.1 to reduce its tempering value
	hitItemHealth = hitItemHealth - 0.1
	if hitSlotMask == rightHandSlotMask
		WornObject.SetItemHealthPercent(GetActorRef(), hitSlotMask, -1, hitItemHealth)
		Debug.Notification("Your weapon was damaged")
	else
		WornObject.SetItemHealthPercent(GetActorRef(), -1, hitSlotMask, hitItemHealth)
		Debug.Notification("Your armor was damaged")
	endIf
 
EndEvent

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


Float Function GetArmorDurability(Armor akArmor)
	
	; Default to max durability for invalid input
	if !akArmor
		return 1.0
	endIf
	
	if HasKeywordInList(akArmor, _RO_ArmorMaterialsDurability05)
		return pDurability05
	elseIf HasKeywordInList(akArmor, _RO_ArmorMaterialsDurability04)
		return pDurability04
	elseIf HasKeywordInList(akArmor, _RO_ArmorMaterialsDurability03)
		return pDurability03
	elseIf HasKeywordInList(akArmor, _RO_ArmorMaterialsDurability02)
		return pDurability02
	elseIf HasKeywordInList(akArmor, _RO_ArmorMaterialsDurability01)
		return pDurability01
	endIf

	; Default to max durability for unknown materials
	return 1.0

EndFunction


Float Function GetWeaponDurability(Form akWeapon)
	
	; Default to max durability for invalid input
	If !akWeapon
		return 1.0
	EndIf
	
	If HasKeywordInList(akWeapon, _RO_WeaponMaterialsDurability05)
		return pDurability05
	ElseIf HasKeywordInList(akWeapon, _RO_WeaponMaterialsDurability04)
		return pDurability04
	ElseIf HasKeywordInList(akWeapon, _RO_WeaponMaterialsDurability03)
		return pDurability03
	ElseIf HasKeywordInList(akWeapon, _RO_WeaponMaterialsDurability02)
		return pDurability02
	ElseIf HasKeywordInList(akWeapon, _RO_WeaponMaterialsDurability01)
		return pDurability01
	EndIf

	; Default to max durability for unknown materials
	return 1.0

EndFunction
