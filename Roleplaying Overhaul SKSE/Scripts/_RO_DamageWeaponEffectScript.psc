Scriptname _RO_DamageWeaponEffectScript extends ActiveMagicEffect  

Bool Property pIsBash = false  Auto

Float Property pDurability01  Auto
Float Property pDurability02  Auto
Float Property pDurability03  Auto
Float Property pDurability04  Auto
Float Property pDurability05  Auto

FormList Property _RO_WeaponMaterialsDurability01  Auto
FormList Property _RO_WeaponMaterialsDurability02  Auto
FormList Property _RO_WeaponMaterialsDurability03  Auto
FormList Property _RO_WeaponMaterialsDurability04  Auto
FormList Property _RO_WeaponMaterialsDurability05  Auto


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
	if pIsBash
		if weaponRH
			hitWeapon = weaponRH
		elseIf weaponLH
			hitWeapon = weaponLH
			isLeftHand = true
		endIf
	elseIf weaponRH && weaponLH
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
		return;
	endIf
	
	; Get random base factor to damage weapon
	Float damage = Utility.RandomFloat()
	
	; Get weapon durability
	Float durability = GetWeaponDurability(hitWeapon)
	
	; Check damage vs durability
	if damage <= durability	
		return
	endIf
	
	; Get the current hit item health based on the selected slot mask
	Int hitSlotMask = 0 ; right hand
	if isLeftHand
		hitSlotMask = 1 ; left hand
	endIf
	
	Float hitItemHealth = WornObject.GetItemHealthPercent(player, hitSlotMask, -1)
	
	; Validate damageable item based on item health
	if hitItemHealth < 1.1
		return
	endIf
	
	; Reduce the health percent of the item by 0.1 to reduce its tempering value
	hitItemHealth = hitItemHealth - 0.1
	WornObject.SetItemHealthPercent(player, hitSlotMask, -1, hitItemHealth)
	
	Debug.Notification("Your weapon was damaged")

endEvent


Float Function GetWeaponDurability(Weapon akWeapon)
	
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


Bool Function HasKeywordInList(Form akBaseObject, FormList akList)
	
	Int iIndex = akList.GetSize() ; Indices are offset by 1 relative to size
	While iIndex
		iIndex -= 1
		Keyword material = akList.GetAt(iIndex) As Keyword
		If material
			If akBaseObject.HasKeyword(material)
				return True
			EndIf
		EndIf
	EndWhile

	return False
	
EndFunction
