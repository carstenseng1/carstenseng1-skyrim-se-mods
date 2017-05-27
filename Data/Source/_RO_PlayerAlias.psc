Scriptname _RO_PlayerAlias extends ReferenceAlias  

Int Property pScriptVersion Auto
SPELL Property sitSpell Auto
SPELL Property _RO_RoleplayingSpell Auto
GlobalVariable Property _RO_Roleplaying  Auto
GlobalVariable Property GameHour  Auto

Int scriptVersion


Event OnInit()
	UpdateScript()
endEvent

Bool roleplayingSitBonusEarned = false

Event OnSleepStop(bool abInterrupted)
	if abInterrupted
		; inturrupted
		; Penalty to starting roleplaying value when sleep is inturrupted
		_RO_Roleplaying.SetValue(-0.25)
	else
		if scriptVersion != pScriptVersion
			UpdateScript()
		endIf
		
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
		
		Debug.Notification("Roleplaying: " + _RO_Roleplaying.GetValue())
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
	
	scriptVersion = pScriptVersion
	
	Debug.Notification("Player Alias Script Version: " + scriptVersion)

	; Register for events on which to update the script
	RegisterForSleep()
	
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