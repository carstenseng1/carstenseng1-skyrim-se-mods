Scriptname _RO_DamageWeaponEffectScript extends ActiveMagicEffect  

GlobalVariable Property _RO_Debug  Auto

Bool Property pIsBash = false  Auto
Float Property pStaminaFactor = 0.0  Auto
SPELL Property _RO_TimeSlowdownShort  Auto 


Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	; Both caster and target are the hit actor when used with a Perk: Apply Combat Hit Spell
	; Therefore, we must just get a reference to the player and ensure this spell is only cast when the player's weapon should be damaged
	Actor player = Game.GetPlayer()
	
	; Don't damage weapon when bashing with a shield
	if pIsBash && player.GetEquippedShield()
		return
	endIf
	
	Weapon weaponRH = player.GetEquippedWeapon()
	Weapon weaponLH = player.GetEquippedWeapon(true)
	Weapon hitWeapon = NONE
	Bool isLeftHand = false
	
	; Select a weapon to attempt to possibly damage
	if weaponRH && weaponLH
		if Utility.RandomInt(0,1) == 0
			hitWeapon = weaponRH
		else
			hitWeapon = weaponLH
			isLeftHand = true
		endIf
	elseIf weaponRH
		hitWeapon = weaponRH
	elseIf weaponLH
		hitWeapon = weaponLH
		isLeftHand = true
	else
		_RO_Note("No weapon found to damage")
		return;
	endIf
	
	_RO_DestructibleWeapon destructibleWeapon = hitWeapon as _RO_DestructibleWeapon
	if !destructibleWeapon
		if isLeftHand
			_RO_Note("LH Weapon is not destructible: " + hitWeapon.GetFormID())
		else
			_RO_Note("RH Weapon is not destructible: " + hitWeapon.GetFormID())
		endIf
		return
	endIf
	
	; Get random base factor to damage weapon
	Float damage = Utility.RandomFloat()
	
	; Stamina effect on chance to damage weapon
	Float staminaDamageBonus = pStaminaFactor * (1.0 - player.GetActorValuePercentage("Stamina"))
	
	; Get weapon durability
	Float durability = destructibleWeapon.Durability.GetValue()
	
	if isLeftHand
		_RO_Note("Hit LH Weapon " + damage + staminaDamageBonus + "  Durability " + durability)
	else
		_RO_Note("Hit RH Weapon " + damage + staminaDamageBonus + "  Durability " + durability)
	endIf
	
	if damage + staminaDamageBonus > durability	
		; Unequip and remove the weapon
		player.UnequipItem(destructibleWeapon, false, true)
		player.RemoveItem(destructibleWeapon, 1, true)
		
		; Add the damaged version if available
		Weapon damagedWeapon = destructibleWeapon.damagedWeapon
		if damagedWeapon
			; Add the damaged version of the weapon
			player.AddItem(damagedWeapon, 1, true)
			
			; Equip the newly added damaged weapon if applicable
			if isLeftHand
				if weaponRH
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
		endIf
		
		; Add broken parts to inventory
		Int i = 0
		While i < destructibleWeapon.BrokenItems.Length
			player.AddItem(destructibleWeapon.BrokenItems[i], 1, true)
			i += 1
		endWhile
		
		; Notify player the weapon was damaged
		Debug.Notification("Your weapon is damaged")
		_RO_TimeSlowdownShort.Cast(Player)
	endIf

endEvent


Function _RO_Note(String text)

	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf

endFunction
