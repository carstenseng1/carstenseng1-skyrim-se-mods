Scriptname IDB_ManagerQuestPlayerAlias extends ReferenceAlias  
{Quest Alias referencing the Player Actor to manage Immortal Dragonborn Mod}

GlobalVariable Property IDB_Enabled  Auto
GlobalVariable Property IDB_Debug  Auto

SPELL Property IDB_AvoidDeathAbility  Auto 

; SCRIPT VERSION ----------------------------------------------------------------------------------

Int version = 0
Int Function GetVersion()
	return 1
endFunction

; INITIALIZATION -------------------------------------------------------------------------------

Event OnInit()
	Maintenance()
endEvent

Event OnPlayerLoadGame()
	if version == 0 || version != GetVersion()
		Maintenance()
	endIf
endEvent

; EVENTS ------------------------------------------------------------------------------------------

Event Maintenance()
	version = GetVersion()
	
	Actor player = Game.GetPlayer()

	if IDB_Enabled.GetValue() as Bool
		DebugScript("Immortal Dragonborn Enabled")
		ForceRefTo(player)
		player.AddSpell(IDB_AvoidDeathAbility, IDB_Debug.GetValue() as Bool)
	else
		DebugScript("Immortal Dragonborn Disabled")
		player.RemoveSpell(IDB_AvoidDeathAbility)
		Clear()
	endIf
endEvent

; UTILITY ------------------------------------------------------------------------------------------

Function DebugScript(String asMessage)
	if IDB_Debug.GetValue() as Bool
		Debug.Trace(asMessage)
		Debug.Notification(asMessage)
	endIf
endFunction