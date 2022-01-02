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
		_RO_Note("Weapon is not destructible: " + hitWeapon)
		return
	endIf
	
	; Get random base factor to damage weapon
	Float damage = Utility.RandomFloat()
	
	; Stamina effect on chance to damage weapon
	Float staminaDamageBonus = pStaminaFactor * (1.0 - player.GetActorValuePercentage("Stamina"))
	
	; Get weapon durability
	Float durability = destructibleWeapon.Durability.GetValue()
	
	_RO_Note("Hit Weapon " + damage + staminaDamageBonus + "  Durability " + durability)
	if damage + staminaDamageBonus > durability
		; Unequip all weaons to eliminate buggy ObjectReference weirdness
		if weaponRH
			player.UnequipItem(weaponRH, false, true)
		endIf
		if weaponLH
			player.UnequipItem(weaponLH, false, true)
		endIf
		
		; Remove the weapon
		player.RemoveItem(destructibleWeapon, 1, true)
		
		; Add the damaged version if available
		Weapon damagedWeapon = destructibleWeapon.damagedWeapon
		if damagedWeapon
			player.AddItem(damagedWeapon, 1, true)
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
