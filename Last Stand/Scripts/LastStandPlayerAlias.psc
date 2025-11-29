Scriptname LastStandPlayerAlias extends ReferenceAlias
{Reference Alias Script for Player to manage Last Stand}

Int version = 0

GlobalVariable Property LastStandEnabled  Auto
Quest Property LastStandQuest  Auto
Spell Property LastStandAbility  Auto  


Event OnInit()
	RegisterForSingleUpdate(0.1)
endEvent

Event OnPlayerLoadGame()
	if version == 0 || version != 1 ; Hard coded script version. Set 0 to force maintenance
		RegisterForSingleUpdate(0.1)
	endIf
endEvent


Event OnUpdate()
	
	Actor player = GetActorRef()
	if LastStandEnabled.GetValue() as Bool
		version = 1
		DebugScript("Last Stand v" + version)
		player.AddSpell(LastStandAbility, false)
	else
		DebugScript("Last Stand Disabled")
		player.RemoveSpell(LastStandAbility)
		LastStandQuest.Stop()
		Clear()
	endIf

endEvent


Function DebugScript(String akMessage)
	;Debug.Trace(akMessage)
	;Debug.Notification(akMessage)
endFunction