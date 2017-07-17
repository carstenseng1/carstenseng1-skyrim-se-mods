Scriptname _RO_PlayerAlias extends ReferenceAlias  

Int Property pScriptVersion Auto
SPELL Property sitSpell Auto
SPELL Property _RO_RoleplayingSpell Auto
GlobalVariable Property _RO_Roleplaying  Auto
GlobalVariable Property GameHour  Auto
Int Property pCarryWeight  Auto

Int scriptVersion
Bool roleplayingSitBonusEarned = false


Event OnInit()
	UpdateScript()
endEvent

; Event is only sent to the player actor. This would probably be on a magic effect or alias script
Event OnPlayerLoadGame()
	UpdateScript()
endEvent

Event OnCellLoad()
	; Debug.Notification("Player load")
	UpdateScript()
endEvent


Event OnSleepStop(bool abInterrupted)
	if abInterrupted
		; inturrupted
		; Penalty to starting roleplaying value when sleep is inturrupted
		_RO_Roleplaying.SetValue(-0.25)
	else
		roleplayingSitBonusEarned = false
		
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
		
		; Debug.Notification("Roleplaying: " + _RO_Roleplaying.GetValue())
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
		Debug.Notification("You are better prepared for the day.")
	endIf
	sitGameHour = 0
	Game.GetPlayer().RemoveSpell(sitSpell)
endEvent


Function UpdateScript()
	
	if scriptVersion != pScriptVersion
		scriptVersion = pScriptVersion
		Debug.Notification(" Roleplaying Overhaul Player Alias v" + scriptVersion)
		
		; Register for events on which to update the script
		RegisterForSleep()
	endIf
		
	if pCarryWeight > 0
		GetActorRef().SetActorValue("CarryWeight", pCarryWeight)
		; Debug.Notification("CarryWeight: " + GetActorRef().GetActorValue("CarryWeight"))
	endIf
	
endFunction

Function AddRoleplayingValue(Float aValue)

	if _RO_Roleplaying.GetValue() < 1.0
		_RO_Roleplaying.Mod(aValue)
		Debug.Notification("Roleplaying value added: " + aValue + " >> " + _RO_Roleplaying.GetValue())
		if _RO_Roleplaying.GetValue() >= 1.0
			; Apply roleplaying bonus for the day
			Game.GetPlayer().AddSpell(_RO_RoleplayingSpell)
		endIf
	endIf

endFunction
