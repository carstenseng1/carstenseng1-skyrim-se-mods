Scriptname EQD_SKSE_ManagerQuestPlayerAlias extends ReferenceAlias  
{PlayerAlias script to manage destructible armor}

GlobalVariable Property EQD_Enabled  Auto
GlobalVariable Property EQD_Debug  Auto

GlobalVariable Property EQD_WeaponDurability1  Auto
GlobalVariable Property EQD_WeaponDurability2  Auto
GlobalVariable Property EQD_WeaponDurability3  Auto
GlobalVariable Property EQD_WeaponDurability4  Auto
GlobalVariable Property EQD_WeaponDurability5  Auto

GlobalVariable Property EQD_ArmorDurability1  Auto
GlobalVariable Property EQD_ArmorDurability2  Auto
GlobalVariable Property EQD_ArmorDurability3  Auto
GlobalVariable Property EQD_ArmorDurability4  Auto
GlobalVariable Property EQD_ArmorDurability5  Auto

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

; SCRIPT VERSION ----------------------------------------------------------------------------------

Int version = 0
int function GetVersion()
	return 1 ; Default version
endFunction

; PRIVATE VARIABLES -------------------------------------------------------------------------------

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

; Flags to rate limit updates
Bool bIsRegisteredForUpdate = false
Bool bIsWaitingForHit = false

; INITIALIZATION -------------------------------------------------------------------------------

Event OnInit()
	if version == 0 || version == GetVersion()
		Maintenance()
	endIf
endEvent

Event OnPlayerLoadGame()
	if version == 0 || version == GetVersion()
		Maintenance()
	endIf
endEvent

Function Maintenance()
	; Update saved last version
	version = GetVersion()

	Actor player = Game.GetPlayer()

	if EQD_Enabled.GetValue() as Bool
		DebugScript("Enabled")

		; Force ref to reassign when enabling mod
		ForceRefTo(player)

		; Add perk to manage weapon damage
		player.AddPerk(EQD_DamageWeaponPerk)
		
		; Reset update flags
		bIsRegisteredForUpdate = false
		bIsWaitingForHit = false
		
		; Register for update to assign weapon durability
		RegisterForSafeUpdate(0.1, true)
	else
		DebugScript("Disabled")

		; Clear the alias reference to the player
		Clear()

		; Remove perk for managing weapon damage
		player.RemovePerk(EQD_DamageWeaponPerk)

		; Reset slot mask variables
		; Weapon slot masks remain constant 0=left 1=right
		helmetSlotMask = -1
		cuirassSlotMask = -1
		gauntletsSlotMask = -1
		bootsSlotMask = -1
		shieldSlotMask = -1

		; Reset durability variables
		; Durability variables default to max durability of 1.0
		rightHandDurability = 1.0
		leftHandDurability = 1.0
		helmetDurability = 1.0
		cuirassDurability = 1.0
		gauntletsDurability = 1.0
		bootsDurability = 1.0
		shieldDurability = 1.0

		; Stop any pending update and reset flags
		UnregisterForUpdate()
		bIsRegisteredForUpdate = false
		bIsWaitingForHit = false
	endIf
endFunction

; EVENTS ------------------------------------------------------------------------------------------

Event OnUpdate()
{Weapon durability updates handled in event}
	; Reset flag
	bIsRegisteredForUpdate = false

	Actor player = GetActorRef()
	
	Weapon weaponRH = player.GetEquippedWeapon()
	if weaponRH
		rightHandDurability = GetWeaponDurability(weaponRH)
		DebugScript("RH Weapon: Durability: " + rightHandDurability + " Health: " + WornObject.GetItemHealthPercent(player, 1, 0))
	else
		rightHandDurability = 1.0
	endIf
	
	Weapon weaponLH = player.GetEquippedWeapon(true)
	if weaponLH
		leftHandDurability = GetWeaponDurability(weaponLH)
		DebugScript("LH Weapon: Durability: " + leftHandDurability + " Health: " + WornObject.GetItemHealthPercent(player, 0, 0))
	else
		leftHandDurability = 1.0
	endIf
endEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	; Update durability for equipped weapons if a weapon was equipped
	; Handle in OnUpdate event to only update once when equipping is completed
	if akBaseObject as Weapon
		if !RegisterForSafeUpdate()
			DebugScript("Equip Weapon - Update already registered")
		endIf
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
		DebugScript("Helmet: Durability: " + helmetDurability)
	elseIf equippedArmor.isCuirass()
		cuirassSlotMask = slotMask
		cuirassDurability = GetArmorDurability(equippedArmor)
		DebugScript("Cuirass: Durability: " +cuirassDurability)
	elseIf equippedArmor.isGauntlets()
		gauntletsSlotMask = slotMask
		gauntletsDurability = GetArmorDurability(equippedArmor)
		DebugScript("Gauntlets: Durability: " + gauntletsDurability)
	elseIf equippedArmor.isBoots()
		bootsSlotMask = slotMask
		bootsDurability = GetArmorDurability(equippedArmor)
		DebugScript("Boots: Durability: " + bootsDurability)
	elseIf equippedArmor.isShield()
		shieldSlotMask = slotMask
		shieldDurability = GetArmorDurability(equippedArmor)
		DebugScript("Shield: Durability: " + shieldDurability)
	endIf
endEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	; Update durability for equipped weapons if a weapon was equipped
	; Handle in OnUpdate event to only update once when equipping is completed
	if akBaseObject as Weapon
		if !RegisterForSafeUpdate()
			DebugScript("Unequip Weapon - Update already registered")
		endIf
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
	; Check flag to rate limit
	if bIsWaitingForHit
		DebugScript("OnHit waiting")
		return
	endIf

	; Rate limit with Wait and flag
	bIsWaitingForHit = true
	Utility.Wait(0.1)
	bIsWaitingForHit = false

	Actor player = GetActorRef()
	if !player
		return
	endIf
	
	; Add 0.05 bonus to damage value for power attacks
	Float damageBonus = 0.0
	if abPowerAttack
		damageBonus = 0.05
	endIf
	
	if abHitBlocked
		; Hit the equipped shield or weapon used to parry
		if player.GetEquippedShield()
			HitShield(damageBonus)
		elseIf player.GetEquippedWeapon()
			HitWeaponRH(damageBonus)
		endIf
	else
		HitArmor(damageBonus)
	endIf
endEvent

; FUNCTIONS ------------------------------------------------------------------------------------------

Function HitWeapon(Float damageBonus = 0.0)
	Actor player = GetActorRef()
	
	Weapon weaponRH = player.GetEquippedWeapon()
	Weapon weaponLH = player.GetEquippedWeapon(true)

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
	DebugScript("Hit Weapon RH")
	HitSlotMask(1, rightHandDurability, damageBonus)
endFunction

Function HitWeaponLH(Float damageBonus = 0.0)
	DebugScript("Hit Weapon LH")
	HitSlotMask(0, leftHandDurability, damageBonus)
endFunction

Function HitShield(Float damageBonus = 0.0)
	DebugScript("Hit Shield")
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
		DebugScript("Hit Armor: Index: " + index)
		HitSlotMask(slotMaskArray[index], durabilityArray[index], damageBonus)
endFunction

Function HitSlotMask(Int slotMask, Float durability, Float damageBonus = 0.0)
	; Determine if a valid item slot mask was selected
	if slotMask == -1
		DebugScript("Hit Slot Mask -1")
		return
	endIf
	
	; Don't run calculations if durability is max
	if durability >= 1.0
		DebugScript("Hit Slot Mask: " + slotMask + " Durability: " + durability)
		return
	endIf
	
	; Set a random damage with added bonus
	Float damage = Utility.RandomFloat() + damageBonus
	
	; Don't damage item if it passed the durability test
	if damage <= durability
		return
	endif
	
	DebugScript("Hit Slot Mask: " + slotMask + " Durability: " + durability + " Damage: " + damage)
	
	; Get the current hit item health based on the selected slot mask, hand vs armor
	Actor player = GetActorRef()
	Float itemHealth = 0.0

	If slotMask == 0 || slotMask == 1
		; Hand slot mask; 0=left 1=right
		; Must use 0 armor slot mask for hand slot mask to work
		itemHealth = WornObject.GetItemHealthPercent(player, slotMask, 0) 
	else
		; Must use invalid hand slot (-1) for armor slot mask to work
		itemHealth = WornObject.GetItemHealthPercent(player, -1, slotMask)
	endIf
	
	; Validate damageable item based on item health
	if itemHealth < 1.1
		DebugScript("Item health low: " + itemHealth)
		return
	endIf
	
	; Reduce the health percent of the item by 0.1 to reduce its tempering value
	itemHealth = itemHealth - 0.1
	if slotMask == 0 || slotMask == 1
		; Hand slot mask; 0=left 1=right
		; Must use 0 armor slot mask for hand slot mask to work
		WornObject.SetItemHealthPercent(player, slotMask, 0, itemHealth)
		Debug.Notification("Your weapon was damaged")
		DebugScript("New item health: " + WornObject.GetItemHealthPercent(player, slotMask, 0))
	else
		; Must use invalid hand slot (-1) for armor slot mask to work
		WornObject.SetItemHealthPercent(player, -1, slotMask, itemHealth)
		Debug.Notification("Your armor was damaged")
		DebugScript("New item health: " + WornObject.GetItemHealthPercent(player, -1, slotMask))
	endIf
endFunction

Float Function GetWeaponDurability(Form akWeapon)
	; Default to max durability for invalid input
	If !akWeapon
		return 1.0
	EndIf
	
	If HasKeywordInList(akWeapon, EQD_WeaponMaterialsDurability05)
		return EQD_WeaponDurability5.GetValue()
	ElseIf HasKeywordInList(akWeapon, EQD_WeaponMaterialsDurability04)
		return EQD_WeaponDurability4.GetValue()
	ElseIf HasKeywordInList(akWeapon, EQD_WeaponMaterialsDurability03)
		return EQD_WeaponDurability3.GetValue()
	ElseIf HasKeywordInList(akWeapon, EQD_WeaponMaterialsDurability02)
		return EQD_WeaponDurability2.GetValue()
	ElseIf HasKeywordInList(akWeapon, EQD_WeaponMaterialsDurability01)
		return EQD_WeaponDurability1.GetValue()
	EndIf

	; Default to durability 5 for unknown materials
	return EQD_WeaponDurability5.GetValue()
EndFunction

Float Function GetArmorDurability(Armor akArmor)
	; Default to max durability for invalid input
	if !akArmor
		return 1.0
	endIf

	if HasKeywordInList(akArmor, EQD_ArmorMaterialsDurability05)
		return EQD_ArmorDurability5.GetValue()
	elseIf HasKeywordInList(akArmor, EQD_ArmorMaterialsDurability04)
		return EQD_ArmorDurability4.GetValue()
	elseIf HasKeywordInList(akArmor, EQD_ArmorMaterialsDurability03)
		return EQD_ArmorDurability3.GetValue()
	elseIf HasKeywordInList(akArmor, EQD_ArmorMaterialsDurability02)
		return EQD_ArmorDurability2.GetValue()
	elseIf HasKeywordInList(akArmor, EQD_ArmorMaterialsDurability01)
		return EQD_ArmorDurability1.GetValue()
	endIf

	; Default to durability 5 for unknown materials
	return EQD_ArmorDurability5.GetValue()
EndFunction

; UTILITY ------------------------------------------------------------------------------------------

Function DebugScript(String asMessage)
	if EQD_Debug.GetValue() as Bool
		Debug.Trace(asMessage)
		Debug.Notification("EQD MNG: " + asMessage)
	endIf
endFunction

Bool Function HasKeywordInList(Form akBaseObject, FormList akList)
{Returns whether or not the given form has a keyword in the given list}

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

Bool Function RegisterForSafeUpdate(Float afTime = 0.1, Bool abForce = false)
{Registers for single update only if not already registered or forced}

	if bIsRegisteredForUpdate
		if abForce
			; Cancel previous update registrations
			UnregisterForUpdate()
		else
			return false
		endIf
	endIf

	bIsRegisteredForUpdate = true
	RegisterForSingleUpdate(afTime)
	return true
endFunction