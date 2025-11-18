Scriptname _RO_ManagerQuestPlayerAlias extends ReferenceAlias  
{Player Alias script for capturing player events and managing essential features of Roleplaying Overhaul}


Int Property pVersion  Auto
Int version = 0

_RO_ManagerQuestScript Property _RO_ManagerQuest  Auto  


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
	_RO_ManagerQuest.Maintenance()
endFunction