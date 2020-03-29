Scriptname _RO_DamageWeaponEffectScript extends ActiveMagicEffect  

GlobalVariable Property _RO_Debug  Auto

Bool Property pIsBash = false  Auto
Float Property pStaminaFactor = 0.0  Auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	; Both caster and target are the hit actor when used with a Perk: Apply Combat Hit Spell
	; Therefore, we must just get a reference to the player and ensure this spell is only cast when the player's weapon should be damaged
	Actor player = Game.GetPlayer()
	
	; Don't damage weapon when bashing with a shield
	if pIsBash && player.GetEquippedShield()
		return
	endIf
	
	; Find weapon to hit
	; Choose between left or right hand weapon when dual wielding
	_RO_DestructibleWeapon rhWeapon =  player.GetEquippedWeapon() as _RO_DestructibleWeapon
	_RO_DestructibleWeapon lhWeapon =  player.GetEquippedWeapon(true) as _RO_DestructibleWeapon
	_RO_DestructibleWeapon hitWeapon
	if rhWeapon && lhWeapon
		; 3 : 2 odds to hit right vs. left
		if Utility.RandomInt(1, 5) <= 3
			hitWeapon = rhWeapon
		else
			hitWeapon = lhWeapon
		endIf
	elseIf rhWeapon
		hitWeapon = rhWeapon
	elseIf lhWeapon
		hitWeapon = lhWeapon
	endIf
	
	if hitWeapon
		DamageWeapon(player, hitWeapon)
	endIf
	
endEvent


Function DamageWeapon(Actor akTarget, _RO_DestructibleWeapon akWeapon)

	; Get random base factor to damage weapon
	Float damage = Utility.RandomFloat()
	
	; Stamina effect on chance to damage weapon
	Float staminaDamageBonus = pStaminaFactor * (1.0 - akTarget.GetActorValuePercentage("Stamina"))
	
	; Get weapon durability
	Float durability = akWeapon.Durability.GetValue()
	
	_RO_Note("Hit Weapon " + damage + staminaDamageBonus + "  Durability " + durability)
	if damage + staminaDamageBonus > durability
		; Remove the weapon
		akTarget.RemoveItem(akWeapon, 1, true)

		; Equip the damaged version if available
		if akWeapon.damagedWeapon
			akTarget.EquipItem(akWeapon.damagedWeapon, false, true)
		endIf
		
		; Add broken parts to inventory
		Int i = 0
		While i < akWeapon.BrokenItems.Length
			akTarget.AddItem(akWeapon.BrokenItems[i], 1, true)
			i += 1
		endWhile
	endIf
	
	; Chance to drop weapon 
	;if Utility.RandomFloat() < 0.25 + 0.5 * staminaPercentage
	;	akTarget.DropObject(akTarget.GetEquippedWeapon())
	;endIf

endFunction

Function _RO_Note(String text)

	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf

endFunction