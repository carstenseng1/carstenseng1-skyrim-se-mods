Scriptname EQD_DestructibleWeaponQuestPlayerAlias extends ReferenceAlias  
{PlayerAlias script to manage destructible weapons}


Int version = 0

Bool Property pDebugTrace = false  Auto
Bool Property pDebugNotification = false  Auto

Perk Property EQD_DestructibleWeaponPerk  Auto

Float kDurability1 = 0.975
Float kDurability2 = 0.98
Float kDurability3 = 0.985
Float kDurability4 = 0.99
Float kDurability5 = 0.995
Float kStaminaFactor = 0.05

FormList Property EQD_WeaponsDurability1  Auto
FormList Property EQD_WeaponsDurability2  Auto
FormList Property EQD_WeaponsDurability3  Auto
FormList Property EQD_WeaponsDurability4  Auto
FormList Property EQD_WeaponsDurability5  Auto

FormList Property EQD_WeaponsDurability1Damaged  Auto
FormList Property EQD_WeaponsDurability2Damaged  Auto
FormList Property EQD_WeaponsDurability3Damaged  Auto
FormList Property EQD_WeaponsDurability4Damaged  Auto
FormList Property EQD_WeaponsDurability5Damaged  Auto

Weapon equippedWeaponRH = NONE
Weapon equippedWeaponLH = NONE

Weapon damagedWeaponRH = NONE
Weapon damagedWeaponLH = NONE

Float equippedWeaponRHDurability = 0.0
Float equippedWeaponLHDurability = 0.0

Event OnInit()
	Maintenance()
endEvent

Event OnPlayerLoadGame()
	if version == 0 || version != 1
		Maintenance()
	endIf
endEvent

Function Maintenance()
	
	version = 1
	
	Actor actorRef = self.GetActorRef() as Actor
	
	; Clean
	actorRef.RemovePerk(EQD_DestructibleWeaponPerk)
	ClearRegisteredWeapon(true, true)
	
	; Add
	actorRef.AddPerk(EQD_DestructibleWeaponPerk)
	RegisterForSingleUpdate(0.1)

endFunction


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	
	; Ensure the equipped item is a Weapon
	if !(akBaseObject as Weapon)
		return
	endIf
	
	; Handle equipped weapon registration in OnUpdate event to prevent registering while in menu
	RegisterForSingleUpdate(0.1)

endEvent


Event OnUpdate()
	
	; Store the Base Object for the equipped Weapons since the reference is not persistent
	RegisterWeapon()
	RegisterWeapon(true)

endEvent


Float Function GetDurabilityForWeapon(Weapon akWeapon)
	
	; Return 0.0 for invalid input
	if !akWeapon
		ScriptDebug("Get durability for non weapon")
		return 0.0
	endIf
	
	; Default to non-damageable durability of 1.0
	Float durability = 1.0
	
	if EQD_WeaponsDurability5.HasForm(akWeapon)
		 durability = kDurability5
	elseIf EQD_WeaponsDurability4.HasForm(akWeapon)
		durability = kDurability4
	elseIf EQD_WeaponsDurability3.HasForm(akWeapon)
		durability = kDurability3
	elseIf EQD_WeaponsDurability2.HasForm(akWeapon)
		durability = kDurability2
	elseIf EQD_WeaponsDurability1.HasForm(akWeapon)
		durability = kDurability1
	endIf
	
	ScriptDebug("Get Weapon Durability: " + durability)
	return durability

EndFunction


FormList Function GetWeaponsListForDurability(Float akDurability)

	if akDurability == kDurability1
		return EQD_WeaponsDurability1
	elseIf akDurability == kDurability2
		return EQD_WeaponsDurability2
	elseIf akDurability == kDurability3
		return EQD_WeaponsDurability3
	elseIf akDurability == kDurability4
		return EQD_WeaponsDurability4
	elseIf akDurability == kDurability5
		return EQD_WeaponsDurability5
	endIf

	return NONE

endFunction


FormList Function GetDamagedWeaponsListForDurability(Float akDurability)

	if akDurability == kDurability1
		return EQD_WeaponsDurability1Damaged
	elseIf akDurability == kDurability2
		return EQD_WeaponsDurability2Damaged
	elseIf akDurability == kDurability3
		return EQD_WeaponsDurability3Damaged
	elseIf akDurability == kDurability4
		return EQD_WeaponsDurability4Damaged
	elseIf akDurability == kDurability5
		return EQD_WeaponsDurability5Damaged
	endIf

	return NONE

endFunction


Bool Function RegisterWeapon(Bool abLeftHand = false)

	Actor actorRef = self.GetActorRef() as Actor
	Weapon equippedWeapon = actorRef.GetEquippedWeapon(abLeftHand)
	
	; Clear registered weapon for the given hand if no equipped weapon found
	if !equippedWeapon
		ClearRegisteredWeapon(!abLeftHand, abLeftHand)
		return false
	endIf
	
	; Clear registered weapon for the given hand if durability is max
	Float durability = GetDurabilityForWeapon(equippedWeapon)
	if durability >= 1.0
		ClearRegisteredWeapon(!abLeftHand, abLeftHand)
		return false
	endIf
	
	FormList weaponsList = GetWeaponsListForDurability(durability)
	Int index = weaponsList.Find(equippedWeapon)
	
	; Clear registered weapon for the given hand if equipped weapon is not in list
	if index == -1
		ClearRegisteredWeapon(!abLeftHand, abLeftHand)
		return false
	endIf
	
	Weapon damagedWeapon = NONE
	FormList damagedWeaponsList = GetDamagedWeaponsListForDurability(durability)
	damagedWeapon = damagedWeaponsList.GetAt(index) as Weapon
	
	; Clear registered weapon for the given hand if no damaged version is found
	if !damagedWeapon
		ClearRegisteredWeapon(!abLeftHand, abLeftHand)
		return false
	endIf
	
	if abLeftHand
		equippedWeaponLH = equippedWeapon
		equippedWeaponLHDurability = durability
		damagedWeaponLH = damagedWeapon
		ScriptDebug("LH Weapon registered: Durability: " + equippedWeaponLHDurability + " Has Damaged: " + (damagedWeaponLH != NONE))
		return true
	else
		equippedWeaponRH = equippedWeapon
		equippedWeaponRHDurability = durability
		damagedWeaponRH = damagedWeapon
		ScriptDebug("RH Weapon registered: Durability: " + equippedWeaponRHDurability + " Has Damaged: " + (damagedWeaponRH != NONE))
		return true
	endIf
	
	return false

endFunction


Function ClearRegisteredWeapon(Bool akRight, Bool akLeft)
	
	if akRight
		equippedWeaponRH = NONE
		equippedWeaponRHDurability = 0.0
		damagedWeaponRH = NONE
	endIf
	
	if akLeft
		equippedWeaponLH = NONE
		equippedWeaponLHDurability = 0.0
		damagedWeaponLH = NONE
	endIf

endFunction


Function HitWeapon()
	
	Actor player = self.GetActorRef() as Actor

	Weapon hitWeapon = NONE
	Weapon damagedWeapon = NONE
	Float durability = 1.0
	Bool isLeftHand = false
	
	; Select a weapon to attempt to possibly damage
	if equippedWeaponRH && equippedWeaponLH
		if Utility.RandomInt(0,1) == 0
			hitWeapon = equippedWeaponRH
			damagedWeapon = damagedWeaponRH
			durability = equippedWeaponRHDurability
		else
			hitWeapon = equippedWeaponLH
			damagedWeapon = damagedWeaponLH
			durability = equippedWeaponLHDurability
			isLeftHand = true
		endIf
	elseIf equippedWeaponRH
		hitWeapon = equippedWeaponRH
		damagedWeapon = damagedWeaponRH
		durability = equippedWeaponRHDurability
	elseIf equippedWeaponLH
		hitWeapon = equippedWeaponLH
		damagedWeapon = damagedWeaponLH
		durability = equippedWeaponLHDurability
		isLeftHand = true
	endIf

	if !hitWeapon
		ScriptDebug("No weapon found to damage")
		return
	endIf
	
	if !damagedWeapon 
		ScriptDebug("No damaged version of weapon")
		return
	endIf

	if durability >= 1.0
		ScriptDebug("Weapon not damageable: " + hitWeapon.GetFormID() + " durability: " + durability)
		return
	endIf
	
	; Get random base factor to damage weapon
	Float baseDamage = Utility.RandomFloat()
	
	; Stamina effect on chance to damage weapon
	Float staminaDamageBonus = kStaminaFactor * (1.0 - player.GetActorValuePercentage("Stamina"))
	
	; Combine base damage and stamina bonus for total damage to weapon
	Float damage = baseDamage + staminaDamageBonus

	if isLeftHand
		ScriptDebug("Hit LH Weapon: Base Damage: " + baseDamage + \
			" Stamina Factor: " + staminaDamageBonus + \
			"  Durability " + durability)
	else
		ScriptDebug("Hit RH Weapon: Base Damage: " + baseDamage + \
			" Stamina Factor: " + staminaDamageBonus + \
			"  Durability " + durability)
	endIf
	
	if damage > durability	
		; Unequip and remove the weapon
		; Form akItem, bool abPreventEquip = false, bool abSilent = false
		player.UnequipItem(hitWeapon, false, true)
		player.RemoveItem(hitWeapon, 1, true)
		
		; Add the damaged version of the weapon
		player.AddItem(damagedWeapon, 1, true)

		; Equip the newly added damaged weapon if applicable
		if isLeftHand
			if equippedWeaponRH
				; Don't equip the damaged version since it will equip on the right hand
			else
				; Equip the damaged version, even though it will switch to the right hand
				player.EquipItem(damagedWeapon, false, true)
			endIf
		else
			; Equip the damaged weapon to replace the old one in the right hand
			; This can happen somewhat seemlessly
			player.EquipItem(damagedWeapon, false, true)
		endIf
		
		; Add broken parts to inventory
		FormList BrokenItemParts = NONE
		Int i = 0
		Int size = BrokenItemParts.GetSize()
		While i < size
			player.AddItem(BrokenItemParts.GetAt(i), 1, true)
			i += 1
		endWhile
		
		; Notify player the weapon was damaged
		Debug.Notification("Your weapon is damaged")
	endIf

endFunction


Function ScriptDebug(String akMessage)

	if pDebugTrace
		Debug.Trace(akMessage)
	endIf
	
	if pDebugNotification
		Debug.Notification(akMessage)
	endIf

endFunction