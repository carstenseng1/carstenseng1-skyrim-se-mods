Scriptname EQD_DestructibleArmorQuestPlayerAlias extends ReferenceAlias  
{PlayerAlias script to manage destructible armor}


Int version = 0

Bool Property pDebugTrace = false  Auto
Bool Property pDebugNotification = false  Auto

Float Property pPowerAttackDamageBonus = 0.0  Auto

Quest Property EQD_DestructibleWeaponQuest  Auto 

Float kDurability1 = 0.1  
Float kDurability2 = 0.2
Float kDurability3 = 0.3
Float kDurability4 = 0.4
Float kDurability5 = 0.5

FormList Property EQD_BootsDurability1  Auto
FormList Property EQD_BootsDurability2  Auto
FormList Property EQD_BootsDurability3  Auto
FormList Property EQD_BootsDurability4  Auto
FormList Property EQD_BootsDurability5  Auto

FormList Property EQD_CuirassDurability1  Auto
FormList Property EQD_CuirassDurability2  Auto
FormList Property EQD_CuirassDurability3  Auto
FormList Property EQD_CuirassDurability4  Auto
FormList Property EQD_CuirassDurability5  Auto

FormList Property EQD_GauntletsDurability1  Auto
FormList Property EQD_GauntletsDurability2  Auto
FormList Property EQD_GauntletsDurability3  Auto
FormList Property EQD_GauntletsDurability4  Auto
FormList Property EQD_GauntletsDurability5  Auto

FormList Property EQD_HelmetDurability1  Auto
FormList Property EQD_HelmetDurability2  Auto
FormList Property EQD_HelmetDurability3  Auto
FormList Property EQD_HelmetDurability4  Auto
FormList Property EQD_HelmetDurability5  Auto

FormList Property EQD_ShieldDurability1  Auto
FormList Property EQD_ShieldDurability2  Auto
FormList Property EQD_ShieldDurability3  Auto
FormList Property EQD_ShieldDurability4  Auto
FormList Property EQD_ShieldDurability5  Auto

FormList Property EQD_BootsDurability1Damaged  Auto
FormList Property EQD_BootsDurability2Damaged  Auto
FormList Property EQD_BootsDurability3Damaged  Auto
FormList Property EQD_BootsDurability4Damaged  Auto
FormList Property EQD_BootsDurability5Damaged  Auto

FormList Property EQD_CuirassDurability1Damaged  Auto
FormList Property EQD_CuirassDurability2Damaged  Auto
FormList Property EQD_CuirassDurability3Damaged  Auto
FormList Property EQD_CuirassDurability4Damaged  Auto
FormList Property EQD_CuirassDurability5Damaged  Auto

FormList Property EQD_GauntletsDurability1Damaged  Auto
FormList Property EQD_GauntletsDurability2Damaged  Auto
FormList Property EQD_GauntletsDurability3Damaged  Auto
FormList Property EQD_GauntletsDurability4Damaged  Auto
FormList Property EQD_GauntletsDurability5Damaged  Auto

FormList Property EQD_HelmetDurability1Damaged  Auto
FormList Property EQD_HelmetDurability2Damaged  Auto
FormList Property EQD_HelmetDurability3Damaged  Auto
FormList Property EQD_HelmetDurability4Damaged  Auto
FormList Property EQD_HelmetDurability5Damaged  Auto

FormList Property EQD_ShieldDurability1Damaged  Auto
FormList Property EQD_ShieldDurability2Damaged  Auto
FormList Property EQD_ShieldDurability3Damaged  Auto
FormList Property EQD_ShieldDurability4Damaged  Auto
FormList Property EQD_ShieldDurability5Damaged  Auto

Armor equippedShield = NONE
Armor equippedCuirass = NONE
Armor equippedHelmet = NONE
Armor equippedGauntlets = NONE
Armor equippedBoots = NONE

Armor damagedShield = NONE
Armor damagedCuirass = NONE
Armor damagedHelmet = NONE
Armor damagedGauntlets = NONE
Armor damagedBoots = NONE

Float equippedShieldDurability = 0.0
Float equippedCuirassDurability = 0.0
Float equippedHelmetDurability = 0.0
Float equippedGauntletsDurability = 0.0
Float equippedBootsDurability = 0.0


Event OnInit()
	Maintenance()
endEvent

Event OnPlayerLoadGame()
	if version == 0 || version != 0 ; Hard coded script version. Set 0 to force maintenance
		Maintenance()
	endIf
endEvent

Function Maintenance()
	
	ScriptDebug("Destructible Armor Maintenance")
	
	; Hard coded script version. Set 0 to force maintenance
	version = 0
	
	; Remove all tracked destructible armor
	ClearRegisteredShield()
	ClearRegisteredCuirass()
	ClearRegisteredHelmet()
	ClearRegisteredGauntlets()
	ClearRegisteredBoots()

endFunction


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	
	; Ensure the equipped item is Armor
	Armor equippedArmor = akBaseObject as Armor
	if !equippedArmor
		return
	endIf
	
	; Store the Base Object for the equipped Armor since the reference is not persistent
	Actor actorRef = self.GetActorRef() as Actor
	if equippedArmor == actorRef.GetEquippedShield()
		RegisterShield(equippedArmor)
	else
		RegisterArmor(equippedArmor)
	endIf

endEvent


Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	
	; Ensure the equipped item is Armor
	Armor unequippedArmor = akBaseObject as Armor
	if !unequippedArmor
		return
	endIf
	
	; Remove Armor from tracking lists
	if equippedShield == unequippedArmor
		equippedShield = NONE
		equippedShieldDurability = 0.0
		damagedShield = NONE
		ScriptDebug("Shield unregistered")
	elseIf equippedCuirass == unequippedArmor
		equippedCuirass = NONE
		equippedCuirassDurability = 0.0
		damagedCuirass = NONE
		ScriptDebug("Cuirass unregistered")
	elseIf equippedHelmet == unequippedArmor
		equippedHelmet = NONE
		equippedHelmetDurability = 0.0
		damagedHelmet = NONE
		ScriptDebug("Helmet unregistered")
	elseIf equippedGauntlets == unequippedArmor
		equippedGauntlets = NONE
		equippedGauntletsDurability = 0.0
		damagedGauntlets = NONE
		ScriptDebug("Gauntlets unregistered")
	elseIf equippedBoots == unequippedArmor
		equippedBoots = NONE
		equippedBootsDurability = 0.0
		damagedBoots = NONE
		ScriptDebug("Boots unregistered")
	endIf

endEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	
	Actor player = GetActorRef()
	Actor agActor = akAggressor as Actor
	Weapon sourceWeapon = akSource as Weapon
	
	; Ensure a aggressor and a source weapon is given
	if (!agActor || !sourceWeapon)
		ScriptDebug("Hit without aggressor and weapon")
		return
	endIf
	
	; Ensure the agressor actually has the weapon equipped - Damage is from weapon and not enchantments
	Form RightHandWeapon = agActor.GetEquippedWeapon(); this gets the sword that the enemy had in their right hand and stores it as an object variable
	Form LeftHandWeapon = agActor.GetEquippedWeapon(true); this gets the sword that the enemy had in their left hand and stores it as an object variable
	if (sourceWeapon != RightHandWeapon && sourceWeapon != LeftHandWeapon)
		ScriptDebug("Hit with non-weapon")
		return
	endIf
	
	Float damageBonus = 0.0
	if abPowerAttack
		damageBonus = pPowerAttackDamageBonus
	endIf
	
	if abHitBlocked
		; Hit the equipped shield or weapon used to parry
		if player.GetEquippedShield()
			; Attempt to damage the shield
			HitShield(damageBonus)
		elseIf player.GetEquippedWeapon()
			ScriptDebug("Hit weapon from parry")
			; Call to damage weapon quest
			EQD_DestructibleWeaponQuestPlayerAlias playerAlias = EQD_DestructibleWeaponQuest.GetAlias(5) as EQD_DestructibleWeaponQuestPlayerAlias
			playerAlias.HitWeapon()
		endIf
	else
		; Hit a random piece of armor
		HitRandomArmor(damageBonus)
	endIf
 
EndEvent


Function HitRandomArmor(Float akDamageBonus)
	
	; Choose a random Armor from the equipped armor list
	; 0 = cuirass
	; 1 = helmet
	; 2 = gauntlets
	; 3 = boots
	
	Int slotNum = Utility.RandomInt(0, 4)
	if slotNum == 0
		ScriptDebug("Hit Cuirass")
		HitArmor(equippedCuirass, damagedCuirass, equippedCuirassDurability, akDamageBonus)
	elseIf slotNum == 1
		ScriptDebug("Hit Helmet")
		HitArmor(equippedHelmet, damagedHelmet, equippedHelmetDurability, akDamageBonus)
	elseIf slotNum == 2
		ScriptDebug("Hit Gauntlets")
		HitArmor(equippedGauntlets, damagedGauntlets, equippedGauntletsDurability, akDamageBonus)
	elseIf slotNum == 3
		ScriptDebug("Hit Boots")
		HitArmor(equippedBoots, damagedBoots, equippedBootsDurability, akDamageBonus)
	endIf

EndFunction


Function HitArmor(Armor akArmor, Armor akDamagedArmor, Float akDurability, Float akDamageBonus = 0.0)
	
	; Validate given armor is destructible
	if !akArmor
		ScriptDebug("Hit no registered armor")
		return
	endIf
	
	if !akDamagedArmor
		ScriptDebug("Hit with no damaged armor version")
		return
	endIf
	
	if akDurability >= 1.0
		ScriptDebug("Hit with max durability")
		return
	endIf
	
	; Get a random damage, increased by bonus from power attack, limited to 1.0
	Float damage = Utility.RandomFloat() + akDamageBonus
	if damage > 1.0
		damage = 1.0
	endIf
	
	ScriptDebug("Hit armor: Damage: " + damage + " Durability: " + akDurability)
	
	if damage > akDurability
		Actor actorRef = self.GetActorRef()
				
		; Unequip and remove the current armor reference being damaged
		actorRef.UnequipItem(akArmor, false, true)
		actorRef.RemoveItem(akArmor, 1, true)
		
		; Add and equip the damaged version of the armor
		actorRef.EquipItem(akDamagedArmor, false, true)
		
		; Message player
		Debug.Notification("Your armor is damaged")
	endIf

endFunction


Function HitShield(Float akDamageBonus = 0.0)
	
	Actor player = GetActorRef()
	Armor shield = player.GetEquippedShield()

	; Register shield in case it was missed
	if equippedShield != shield
		RegisterShield(shield)
		Utility.Wait(0.1)
	endIf

	HitArmor(equippedShield, damagedShield, equippedShieldDurability, akDamageBonus)

endFunction


Function RegisterShield(Armor akShield)
	
	if !akShield
		ScriptDebug("RegisterShield with NONE")
		ClearRegisteredShield()
		return
	endIf

	Bool isRegistered = false
	
	isRegistered = RegisterShieldWithDurabilityAndList(akShield, kDurability1, EQD_ShieldDurability1)
	if isRegistered
		return
	endIf
	
	isRegistered = RegisterShieldWithDurabilityAndList(akShield, kDurability2, EQD_ShieldDurability2)
	if isRegistered
		return
	endIf
	
	isRegistered = RegisterShieldWithDurabilityAndList(akShield, kDurability2, EQD_ShieldDurability2)
	if isRegistered
		return
	endIf
	
	isRegistered = RegisterShieldWithDurabilityAndList(akShield, kDurability3, EQD_ShieldDurability3)
	if isRegistered
		return
	endIf
	
	isRegistered = RegisterShieldWithDurabilityAndList(akShield, kDurability4, EQD_ShieldDurability4)
	if isRegistered
		return
	endIf
	
	isRegistered = RegisterShieldWithDurabilityAndList(akShield, kDurability5, EQD_ShieldDurability5)
	if isRegistered
		return
	endIf
	
	; Function should have returned if shield was registered properly
	; Clear the registered shield if we reach this point
	ClearRegisteredShield()

endFunction

Bool Function RegisterShieldWithDurabilityAndList(Armor akShield, Float akDurability, FormList akList)
	
	Int index = EQD_ShieldDurability1.Find(akShield)
	if index == -1
		return false
	endIf
	
	Armor foundDamagedShield = EQD_ShieldDurability1Damaged.GetAt(index) as Armor
	if !foundDamagedShield
		return false
	endIf
	
	equippedShield = akShield
	equippedShieldDurability = kDurability1
	damagedShield = foundDamagedShield
	
	ScriptDebug("Shield registered: Durability: " + equippedShieldDurability)
	return true

endFunction


Function ClearRegisteredShield()
	
	equippedShield = NONE
	equippedShieldDurability = 0.0
	damagedShield = NONE
	
endFunction


Function RegisterArmor(Armor akArmor)
	
	Bool isRegistered = false
	
	isRegistered = RegisterArmorWithDurabilityAndLists(akArmor, kDurability1, \
			EQD_CuirassDurability1, \
			EQD_HelmetDurability1, \
			EQD_GauntletsDurability1, \
			EQD_BootsDurability1)
	if isRegistered
		return
	endIf
	
	isRegistered = RegisterArmorWithDurabilityAndLists(akArmor, kDurability2, \
			EQD_CuirassDurability2, \
			EQD_HelmetDurability2, \
			EQD_GauntletsDurability2, \
			EQD_BootsDurability2)
	if isRegistered
		return
	endIf
	
	isRegistered = RegisterArmorWithDurabilityAndLists(akArmor, kDurability3, \
			EQD_CuirassDurability3, \
			EQD_HelmetDurability3, \
			EQD_GauntletsDurability3, \
			EQD_BootsDurability3)
	if isRegistered
		return
	endIf
	
	isRegistered = RegisterArmorWithDurabilityAndLists(akArmor, kDurability4, \
			EQD_CuirassDurability4, \
			EQD_HelmetDurability4, \
			EQD_GauntletsDurability4, \
			EQD_BootsDurability4)
	if isRegistered
		return
	endIf
	
	isRegistered = RegisterArmorWithDurabilityAndLists(akArmor, kDurability5, \
			EQD_CuirassDurability5, \
			EQD_HelmetDurability5, \
			EQD_GauntletsDurability5, \
			EQD_BootsDurability5)
	if isRegistered
		return
	endIf
	
endFunction


Bool Function RegisterArmorWithDurabilityAndLists(Armor akArmor, Float akDurability, FormList akCuirassList, FormList akHelmetList, FormList akGauntletsList, FormList akBootsList)
	
	Int index = -1
	
	index = akCuirassList.Find(akArmor)
	if index != -1
		Armor foundDamaged = GetDamagedCuirassWithDurabilityAndIndex(akDurability, index)
		if foundDamaged
			equippedCuirass = akArmor
			equippedCuirassDurability = akDurability
			damagedCuirass = foundDamaged
			ScriptDebug("Cuirass registered: Durability: " + equippedCuirassDurability)
			return true
		else
			ScriptDebug("Register Cuirass with no damaged version")
			ClearRegisteredCuirass()
			return true
		endIf
	endIf
	
	index = akHelmetList.Find(akArmor)
	if index != -1
		Armor foundDamaged = GetDamagedHelmetWithDurabilityAndIndex(akDurability, index)
		if foundDamaged
			equippedHelmet = akArmor
			equippedHelmetDurability = akDurability
			damagedHelmet = foundDamaged
			ScriptDebug("Helmet registered: Durability: " + equippedHelmetDurability)
			return true
		else
			ScriptDebug("Register Helmet with no damaged version")
			ClearRegisteredHelmet()
			return true
		endIf
	endIf
	
	index = akGauntletsList.Find(akArmor)
	if index != -1
		Armor foundDamaged = GetDamagedGauntletsWithDurabilityAndIndex(akDurability, index)
		if foundDamaged
			equippedGauntlets = akArmor
			equippedGauntletsDurability = akDurability
			damagedGauntlets = foundDamaged
			ScriptDebug("Gauntlets registered: Durability: " + equippedGauntletsDurability)
			return true
		else
			ScriptDebug("Register Gauntlets with no damaged version")
			ClearRegisteredGauntlets()
			return true
		endIf
	endIf

	index = akBootsList.Find(akArmor)
	if index != -1
		Armor foundDamaged = GetDamagedBootsWithDurabilityAndIndex(akDurability, index)
		if foundDamaged
			equippedBoots = akArmor
			equippedBootsDurability = akDurability
			damagedBoots = foundDamaged
			ScriptDebug("Boots registered: Durability: " + equippedBootsDurability)
			return true
		else
			ScriptDebug("Register Boots with no damaged version")
			ClearRegisteredBoots()
			return true
		endIf
	endIf
	
	; Armor not found in given lists
	return false
	
EndFunction


Armor Function GetDamagedCuirassWithDurabilityAndIndex(Float akDurability, Int index)

	if akDurability == kDurability1
		return EQD_CuirassDurability1Damaged.GetAt(index) as Armor
	elseIf akDurability == kDurability2
		return EQD_CuirassDurability2Damaged.GetAt(index) as Armor
	elseIf akDurability == kDurability3
		return EQD_CuirassDurability3Damaged.GetAt(index) as Armor
	elseIf akDurability == kDurability4
		return EQD_CuirassDurability4Damaged.GetAt(index) as Armor
	elseIf akDurability == kDurability5
		return EQD_CuirassDurability5Damaged.GetAt(index) as Armor
	endIf
	
	return NONE

EndFunction


Armor Function GetDamagedHelmetWithDurabilityAndIndex(Float akDurability, Int index)

	if akDurability == kDurability1
		return EQD_HelmetDurability1Damaged.GetAt(index) as Armor
	elseIf akDurability == kDurability2
		return EQD_HelmetDurability2Damaged.GetAt(index) as Armor
	elseIf akDurability == kDurability3
		return EQD_HelmetDurability3Damaged.GetAt(index) as Armor
	elseIf akDurability == kDurability4
		return EQD_HelmetDurability4Damaged.GetAt(index) as Armor
	elseIf akDurability == kDurability5
		return EQD_HelmetDurability5Damaged.GetAt(index) as Armor
	endIf
	
	return NONE

EndFunction


Armor Function GetDamagedGauntletsWithDurabilityAndIndex(Float akDurability, Int index)

	if akDurability == kDurability1
		return EQD_GauntletsDurability1Damaged.GetAt(index) as Armor
	elseIf akDurability == kDurability2
		return EQD_GauntletsDurability2Damaged.GetAt(index) as Armor
	elseIf akDurability == kDurability3
		return EQD_GauntletsDurability3Damaged.GetAt(index) as Armor
	elseIf akDurability == kDurability4
		return EQD_GauntletsDurability4Damaged.GetAt(index) as Armor
	elseIf akDurability == kDurability5
		return EQD_GauntletsDurability5Damaged.GetAt(index) as Armor
	endIf
	
	return NONE

EndFunction


Armor Function GetDamagedBootsWithDurabilityAndIndex(Float akDurability, Int index)

	if akDurability == kDurability1
		return EQD_BootsDurability1Damaged.GetAt(index) as Armor
	elseIf akDurability == kDurability2
		return EQD_BootsDurability2Damaged.GetAt(index) as Armor
	elseIf akDurability == kDurability3
		return EQD_BootsDurability3Damaged.GetAt(index) as Armor
	elseIf akDurability == kDurability4
		return EQD_BootsDurability4Damaged.GetAt(index) as Armor
	elseIf akDurability == kDurability5
		return EQD_BootsDurability5Damaged.GetAt(index) as Armor
	endIf
	
	return NONE

EndFunction


Function ClearRegisteredCuirass()
	
	equippedCuirass = NONE
	equippedCuirassDurability = 0.0
	damagedCuirass = NONE

endFunction


Function ClearRegisteredHelmet()
	
	equippedHelmet = NONE
	equippedHelmetDurability = 0.0
	damagedHelmet = NONE

endFunction


Function ClearRegisteredGauntlets()
	
	equippedGauntlets = NONE
	equippedGauntletsDurability = 0.0
	damagedGauntlets = NONE

endFunction


Function ClearRegisteredBoots()
	
	equippedBoots = NONE
	equippedBootsDurability = 0.0
	damagedBoots = NONE

endFunction


Function ScriptDebug(String akMessage)

	if pDebugTrace
		Debug.Trace(akMessage)
	endIf
	
	if pDebugNotification
		Debug.Notification(akMessage)
	endIf

endFunction