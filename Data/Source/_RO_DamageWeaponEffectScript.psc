Scriptname _RO_DamageWeaponEffectScript extends ActiveMagicEffect  

FormList Property BaseWeapons  Auto
FormList Property DamagedWeapons  Auto
GlobalVariable Property _RO_Roleplaying  Auto
Float Property pChance Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Actor player = Game.GetPlayer()
	DamageWeapon(player, player.GetEquippedWeapon())
endEvent

Function DamageWeapon(Actor akTarget, Weapon akWeapon)
	
	Int index = BaseWeapons.Find(akWeapon)
	if index >= 0
		; Debug.Notification("Base weapon found: " + index)
	else
		Debug.Notification("Base weapon not found: " + akWeapon)
		return
	endIf
	
	Float chanceMult = 1.0
	Float staminaPercentage = akTarget.GetActorValuePercentage("Stamina")
	
	; Stamina effect on chance
	chanceMult -= staminaPercentage
	
	; Roleplaying (Luck) effect on chance
	Float roleplaying = _RO_Roleplaying.GetValue()
	if roleplaying > 0
		chanceMult -= roleplaying * 0.25
	endIf
	
	if chanceMult <= 0.5
		return
	endIf
	
	Float fRand = Utility.RandomFloat()
	
	if fRand <= pChance * chanceMult
		Debug.Notification("rand: " + fRand + "  threshold: " + pChance * chanceMult)
		
		akTarget.RemoveItem(akWeapon, 1, true)
		
		Weapon damagedWeapon = DamagedWeapons.GetAt(index) as Weapon
		akTarget.EquipItem(damagedWeapon, false, true)

		; Chance to drop weapon 
		if Utility.RandomFloat() < 0.25 + 0.5 * staminaPercentage
			akTarget.DropObject(akTarget.GetEquippedWeapon())
		endIf
	endIf

endFunction

