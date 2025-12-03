Scriptname _RO_RoleplayingQuestPlayerAlias extends ReferenceAlias  

GlobalVariable Property _RO_Enabled  Auto
GlobalVariable Property _RO_Debug  Auto
GlobalVariable Property _RO_RoleplayingEnabled  Auto

GlobalVariable Property _RO_Roleplaying  Auto
GlobalVariable Property GameHour  Auto
SPELL Property _RO_RoleplayingSpell Auto

SPELL Property _RO_SittingSpell Auto

FormList Property _RO_FoodList  Auto

; PRIVATE VARIABLES -------------------------------------------------------------------------------

Bool roleplayingSitBonusEarned = false
Float sitGameHour = 0.0

Bool roleplayingFoodBonusEarned = true

; SCRIPT VERSION ----------------------------------------------------------------------------------

Int version = 0

; INITIALIZATION ----------------------------------------------------------------------------------

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
	
	; Clean up invetory event filters
	RemoveAllInventoryEventFilters()
	
	; Unregister for previously registered events
	UnregisterForSleep()

	; Reset local variables
	roleplayingSitBonusEarned = false
	sitGameHour = 0.0
	roleplayingFoodBonusEarned = true

	; Remove roleplaying bonus
	_RO_Roleplaying.SetValue(0)
	player.RemoveSpell(_RO_RoleplayingSpell)
	player.RemoveSpell(_RO_SittingSpell)
	
	Actor player = Game.GetPlayer()

	if (_RO_Enabled.GetValue() as Bool) && (_RO_RoleplayingEnabled.GetValue() as Bool)
		ForceRefTo(Game.GetPlayer())

		; Register for events on which to update the script
		RegisterForSleep()
	
		; Watch for using food
		AddInventoryEventFilter(_RO_FoodList)

		DebugScript("Roleplaying bonus enabled")
	else
		Clear()
		DebugScript("Roleplaying bonus disabled")
	endIf
endFunction

; EVENTS ------------------------------------------------------------------------------------------

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

; FUNCTIONS ------------------------------------------------------------------------------------------

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

; UTILITY ------------------------------------------------------------------------------------------

Function DebugScript(String akMessage)
	if _RO_Debug.GetValue() as Bool
		Debug.Trace(akMessage)
		Debug.Notification(akMessage)
	endIf
endFunction