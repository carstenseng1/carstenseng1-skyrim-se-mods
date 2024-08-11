Scriptname _RO_ManagerQuestScript extends Quest  
{Quest script for managing main essential features of Roleplaying Overhaul}


GlobalVariable Property _RO_Version  Auto
Int version = 0

GlobalVariable Property _RO_Debug  Auto

SPELL Property _RO_SettingsSpell  Auto
SPELL Property _RO_LastStandAbility  Auto
Perk Property _RO_DestructibleWeaponPerk  Auto

; Maintenance is only handled in OnInit for initial setup.
; Update maintenance is handled by the Player Alias with OnPlayerLoadGame event
Event OnInit()
	Maintenance()
endEvent


Function Maintenance()
	
	version = _RO_Version.GetValueInt()
	
	_RO_Note("Fjør Tall v" + version)
	
	Actor player = Game.GetPlayer()
	bool isDebugMode = _RO_Debug.GetValue()
	
	; Add default spells
	player.AddSpell(_RO_SettingsSpell, isDebugMode)
	player.AddSpell(_RO_LastStandAbility, isDebugMode)
	
	; Enable destructible weapons
	player.AddPerk(_RO_DestructibleWeaponPerk)

endFunction


Function _RO_Note(String text)

	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf

endFunction