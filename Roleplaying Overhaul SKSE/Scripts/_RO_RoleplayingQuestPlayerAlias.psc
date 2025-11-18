Scriptname _RO_RoleplayingQuestPlayerAlias extends ReferenceAlias  

Int Property pVersion  Auto
Int version = 0

GlobalVariable Property _RO_Roleplaying  Auto
GlobalVariable Property GameHour  Auto
SPELL Property _RO_RoleplayingSpell Auto

SPELL Property _RO_SittingSpell Auto
Bool roleplayingSitBonusEarned = false

Bool roleplayingFoodBonusEarned = true
FormList Property _RO_FoodList  Auto

Event OnInit()
	Maintenance()
endEvent


Event OnPlayerLoadGame()
	if version == 0 || version != pVersion
		Maintenance()
	endIf
endEvent


Function Maintenance()
	
	version = pVersion
	
	; Clean up invetory event filters
	RemoveAllInventoryEventFilters()
	
	; Unregister for previously registered events
	UnregisterForSleep()
	
	; Register for events on which to update the script
	RegisterForSleep()
	
	; Watch for using food
	AddInventoryEventFilter(_RO_FoodList)

endFunction


Event OnSleepStop(bool abInterrupted)

	if abInterrupted
		; inturrupted
		; Penalty to starting roleplaying value when sleep is inturrupted
		_RO_Roleplaying.SetValue(0)
	else
		roleplayingSitBonusEarned = false
		roleplayingFoodBonusEarned = false
		
		Actor player = GetActorRef()
		player.removeSpell(_RO_RoleplayingSpell)
		Float carryWeightPercent =  player.GetActorValue("InventoryWeight") / player.GetActorValue("CarryWeight")
		
		_RO_Roleplaying.SetValue(1.0 - carryWeightPercent)
		if carryWeightPercent < 0.5
			Debug.Notification("Unencumbered rest")
		endIf
	endIf

endEvent


Float sitGameHour = 0.0

Event OnSit(ObjectReference akFurniture)

	Game.GetPlayer().AddSpell(_RO_SittingSpell, false)
	sitGameHour = GameHour.GetValue() ; Get game time

endEvent


Event OnGetUp(ObjectReference akFurniture)

	if roleplayingSitBonusEarned == false && GameHour.GetValue() > sitGameHour + 1
		AddRoleplayingValue(0.5)
		roleplayingSitBonusEarned = true
		Debug.Notification("Rest and meditation help you reflect on this day.")
	endIf
	
	sitGameHour = 0
	Game.GetPlayer().RemoveSpell(_RO_SittingSpell)

endEvent


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)

	if roleplayingFoodBonusEarned == false
		roleplayingFoodBonusEarned = true
		AddRoleplayingValue(0.25)
	endIf

endEvent


Function AddRoleplayingValue(Float aValue)
	
	; Don't add 0 or negative values
	; Limit roleplaying value to 1.0
	if aValue <=0 || _RO_Roleplaying.GetValue() >= 1.0
		return
	endIf
	
	_RO_Roleplaying.Mod(aValue)

	if _RO_Roleplaying.GetValue() >= 1.0
		; Apply roleplaying bonus for the day
		GetActorRef().AddSpell(_RO_RoleplayingSpell, false)
		Debug.Notification("You are better prepared for the day.")
	endIf

endFunction