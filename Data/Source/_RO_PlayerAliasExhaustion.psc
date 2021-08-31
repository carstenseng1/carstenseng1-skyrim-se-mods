Scriptname _RO_PlayerAliasExhaustion extends ReferenceAlias  


GlobalVariable Property _RO_Version  Auto
Float version = 0.0

GlobalVariable Property _RO_Debug  Auto

SPELL Property _RO_AbExhaustionDetriment Auto

bool hasInitialized = false
float exhaustion ;the current exhaustion state
float lastUpdateTime ;game time of the last update to exhaustion


Event OnInit()
	Maintenance()
endEvent


Event OnPlayerLoadGame()
	Maintenance()
endEvent


Event OnUpdateGameTime()

    UpdateExhaustion()

endEvent


Event OnSleepStop(bool abInterrupted)
	
	if abInterrupted
		return
	endIf
	
	exhaustion = 0.0
	lastUpdateTime = Utility.GetCurrentGameTime()
	
	UpdateExhaustion()
	
endEvent


Function Maintenance()
	
	if version != 0.0 && version == _RO_Version.GetValue()
		return
	endIf
	version = _RO_Version.GetValue()
	
	_RO_Note("Exhaustion Maintenance")
	
	; Unregister for previously registered events
	UnregisterForSleep()
	
	; Perform updates
	
	; Register for events on which to update the script
	RegisterForSleep()
	
	if hasInitialized == false
		hasInitialized = true
		exhaustion = 1.0
	endIf
	
	UpdateExhaustion()

endFunction


Function UpdateExhaustion()
	
	bool isDebugMode = _RO_Debug.GetValue()
	Actor Player = Game.GetPlayer()
	
	exhaustion = exhaustion + (Utility.GetCurrentGameTime() -  lastUpdateTime)
	lastUpdateTime = Utility.GetCurrentGameTime()
	
	if exhaustion >= 1.0
		exhaustion = 1.0
		Player.AddSpell(_RO_AbExhaustionDetriment, isDebugMode)
	else
		Player.RemoveSpell(_RO_AbExhaustionDetriment)
	endIf
	
	; Register to be notified every in-game day
	UnregisterForUpdateGameTime()
	RegisterForUpdateGameTime(24.0)

endFunction


Function _RO_Note(String text)

	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf

endFunction