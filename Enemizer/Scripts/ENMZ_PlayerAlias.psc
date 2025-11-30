Scriptname ENMZ_PlayerAlias extends ReferenceAlias
{Player alias to manage Enemizer}

Int version = 0

Quest Property ENMZ_ManagerQuest  Auto


Event OnInit()
	version = 1
	RegisterForSingleUpdate(0.1)
endEvent

Event OnPlayerLoadGame()
	if version == 0 || version != 1 ; Hard coded script version. Set 0 to force update
		version = 1
		RegisterForSingleUpdate(0.1)
	endIf
endEvent

