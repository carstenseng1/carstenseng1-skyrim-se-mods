Scriptname _RO_DamageWeaponEffectScript extends ActiveMagicEffect  

FormList Property BaseWeapons  Auto  
FormList Property DamagedWeapons  Auto  
Float Property pChance Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Actor player = Game.GetPlayer()
	DamageWeapon(player, player.GetEquippedWeapon())
endEvent

Function DamageWeapon(Actor akTarget, Weapon akWeapon)
	
	Int index = BaseWeapons.Find(akWeapon)
	if index >= 0
		Debug.Notification("Base weapon found: " + index)
	else
		Debug.Notification("Base weapon not found: " + akWeapon)
		return
	endIf
	
	Float chanceMult = 1.0 - akTarget.GetActorValuePercentage("Stamina")
	if chanceMult <= 0.5
		return
	endIf
	
	Float fRand = Utility.RandomFloat()
	Debug.Notification("rand: " + fRand + "  threshold: " + pChance * chanceMult)
	if fRand <= pChance * chanceMult
		akTarget.RemoveItem(akWeapon)
		
		Weapon damagedWeapon = DamagedWeapons.GetAt(index) as Weapon
		akTarget.EquipItem(damagedWeapon)
		akTarget.DropObject(akTarget.GetEquippedWeapon())
	endIf

endFunction