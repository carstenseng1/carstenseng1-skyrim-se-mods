Scriptname _RO_DamageWeaponEffectScript extends ActiveMagicEffect  


Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	Actor player = Game.GetPlayer()
	Weapon playerWeapon =  player.GetEquippedWeapon()
	
	if playerWeapon as _RO_DestructibleWeapon
		 _RO_DestructibleWeapon destructible =  playerWeapon as _RO_DestructibleWeapon
		DamageWeapon(player, playerWeapon as _RO_DestructibleWeapon)
	EndIf
	
endEvent


Function DamageWeapon(Actor akTarget, _RO_DestructibleWeapon akWeapon)

	Float durability = akWeapon.Durability.GetValue()
	
	; Stamina effect on chance to damage weapon
	Float staminaMult = 0.75 + 0.25 * akTarget.GetActorValuePercentage("Stamina")
		
	Float fRand = Utility.RandomFloat()
	
	if fRand >= durability * staminaMult

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
