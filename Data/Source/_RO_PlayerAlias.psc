Scriptname _RO_PlayerAlias extends ReferenceAlias  

GlobalVariable Property _RO_Version  Auto
GlobalVariable Property _RO_Debug  Auto  
SPELL[] Property DefaultSpells  Auto

SPELL Property sitSpell Auto
SPELL Property _RO_RoleplayingSpell Auto
GlobalVariable Property _RO_Roleplaying  Auto
GlobalVariable Property GameHour  Auto
FormList Property _RO_FoodList  Auto

Perk Property _RO_DestructibleWeaponPerk  Auto  

Float version = 0.0
Bool roleplayingSitBonusEarned = false
Bool roleplayingFoodBonusEarned = true


Event OnInit()
	UpdateScript()
endEvent

Event OnPlayerLoadGame()
	UpdateScript()
endEvent


Event OnSleepStop(bool abInterrupted)
	if abInterrupted
		; inturrupted
		; Penalty to starting roleplaying value when sleep is inturrupted
		_RO_Roleplaying.SetValue(0)
	else
		roleplayingSitBonusEarned = false
		roleplayingFoodBonusEarned = false
		
		Actor player = Game.GetPlayer()
		player.removeSpell(_RO_RoleplayingSpell)
		Float carryWeightPercent =  player.GetActorValue("InventoryWeight") / player.GetActorValue("CarryWeight")
		
		if carryWeightPercent < 0.25
			_RO_Roleplaying.SetValue(0.5)
			Debug.Notification("Unencumbered rest")
		elseIf carryWeightPercent < 0.5
			_RO_Roleplaying.SetValue(0.25)
			Debug.Notification("Unencumbered rest")
		else
			_RO_Roleplaying.SetValue(0)
		endIf
		
		_RO_DebugNotification("Immersion: " + _RO_Roleplaying.GetValue())
	endIf
endEvent


Float sitGameHour = 0.0
Event OnSit(ObjectReference akFurniture)
	Game.GetPlayer().AddSpell(sitSpell, false)
	sitGameHour = GameHour.GetValue() ; Get game time
endEvent


Event OnGetUp(ObjectReference akFurniture)
	if roleplayingSitBonusEarned == false && GameHour.GetValue() > sitGameHour + 1
		AddRoleplayingValue(0.5)
		roleplayingSitBonusEarned = true
		; Debug.Notification("Rest and meditation help you reflect on this day.")
	endIf
	sitGameHour = 0
	Game.GetPlayer().RemoveSpell(sitSpell)
endEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	if roleplayingFoodBonusEarned == false
		roleplayingFoodBonusEarned = true
		_RO_DebugNotification("Immersion object equipped")
		AddRoleplayingValue(0.25)
	endIf
endEvent
	


Function UpdateScript()
	
	if version != 0 && version == _RO_Version.GetValue()
		return
	endIf
	
	version = _RO_Version.GetValue()
	Debug.Notification("Roleplaying Overhaul v" + version)
	
	Actor player = Game.GetPlayer()
	
	; Add default spells
	Int i = 0
	While i < DefaultSpells.Length
		Bool bNotify = false
		if _RO_Debug.GetValue() == 1
			bNotify = true
		endIf
		player.AddSpell(DefaultSpells[i], bNotify)
		i = i + 1	
	endWhile
	
	; Register for events on which to update the script
	RegisterForSleep()
	
	; Watch for using food
	AddInventoryEventFilter(_RO_FoodList)
	
	; Enable destructible weapons
	player.AddPerk(_RO_DestructibleWeaponPerk)
	
endFunction

Function AddRoleplayingValue(Float aValue)

	if _RO_Roleplaying.GetValue() < 1.0
		_RO_Roleplaying.Mod(aValue)
		_RO_DebugNotification("Immersion added: " + aValue + " >> " + _RO_Roleplaying.GetValue())

		if _RO_Roleplaying.GetValue() >= 1.0
			; Apply roleplaying bonus for the day
			Game.GetPlayer().AddSpell(_RO_RoleplayingSpell, false)
			Debug.Notification("You are better prepared for the day.")
		endIf
	endIf

endFunction

Function _RO_DebugNotification(string text)

	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf

endFunction
