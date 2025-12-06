Scriptname ENMZ_PlayerAlias extends ReferenceAlias
{Player alias to manage Enemizer}

Quest Property ENMZ_ManagerQuest  Auto

; INITIALIZATION ----------------------------------------------------------------------------------

Event OnPlayerLoadGame()
	; Run maintenance with version check
	(ENMZ_ManagerQuest as ENMZ_ManagerQuestScript).Maintenance(true)
endEvent
