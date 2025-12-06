Scriptname LastStandPlayerAlias extends ReferenceAlias
{Reference Alias Script for Player to manage Last Stand}

GlobalVariable Property LastStandEnabled  Auto
GlobalVariable Property LastStandDebug  Auto
Spell Property LastStandAbility  Auto  

; SCRIPT VERSION ----------------------------------------------------------------------------------

Int version = 0
int function GetVersion()
	return 1 ; Default version
endFunction

; INITIALIZATION ----------------------------------------------------------------------------------

Event OnInit()
	if version == 0 || version != GetVersion()
		Maintenance()
	endIf
endEvent

Event OnPlayerLoadGame()
	if version == 0 || version != GetVersion()
		Maintenance()
	endIf
endEvent

; FUNCTIONS ------------------------------------------------------------------------------------------

Function Maintenance()
	; Save last updated version
	version = GetVersion()

	Actor player = Game.GetPlayer()

	if LastStandEnabled.GetValue() as Bool
		DebugScript("Enabled")
		ForceRefTo(player)
		player.AddSpell(LastStandAbility, LastStandDebug.GetValue() as Bool)
	else
		DebugScript("Disabled")
		player.RemoveSpell(LastStandAbility)
		Clear()
	endIf
endFunction

; UTILITY ------------------------------------------------------------------------------------------

Function DebugScript(String asMessage)
	if LastStandDebug.GetValue() as Bool
		Debug.Trace(asMessage)
		Debug.Notification("LastStand: " + asMessage)
	endIf
endFunction