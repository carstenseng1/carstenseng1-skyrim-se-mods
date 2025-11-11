Scriptname _RO_ManagerQuestScript extends Quest  
{Quest script for managing main essential features of Roleplaying Overhaul}


GlobalVariable Property _RO_Version  Auto
Int version = 0

GlobalVariable Property _RO_Debug  Auto

Spell Property _RO_LastStandAbility  Auto
Perk Property _RO_DestructibleWeaponPerk  Auto

MiscObject Property Gold001  Auto
Spell Property _RO_DropGoldSpell  Auto

Function Notification(String text)

	If _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	EndIf

EndFunction


Function Maintenance()
	
	version = _RO_Version.GetValueInt()
	
	Notification("Fjør Tall v" + version)
	
	Actor player = Game.GetPlayer()
	bool isDebugMode = _RO_Debug.GetValue()
	
	; Add default spells
	player.AddSpell(_RO_LastStandAbility, isDebugMode)
	player.AddSpell(_RO_DropGoldSpell, isDebugMode)
	
	; Enable destructible weapons
	player.AddPerk(_RO_DestructibleWeaponPerk)

EndFunction


Function UpdateDropGoldOption(ObjectReference akRef = NONE)
	
EndFunction


; Maintenance is only handled in OnInit for initial setup.
; Update maintenance is handled by the Player Alias with OnPlayerLoadGame event
Event OnInit()
	Maintenance()
endEvent


