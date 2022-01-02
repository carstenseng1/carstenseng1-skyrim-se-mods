Scriptname _RO_ManagerQuestScript extends Quest  
{Quest script for managing main essential features of Roleplaying Overhaul}


GlobalVariable Property _RO_Version  Auto
Float version = 0.0

GlobalVariable Property _RO_Debug  Auto

SPELL Property _RO_SettingsSpell  Auto
SPELL Property _RO_LastStandAbility  Auto
Perk Property _RO_DestructibleWeaponPerk  Auto


Event OnInit()
	Maintenance()
endEvent


Function Maintenance()
	
	if version != 0.0 && version == _RO_Version.GetValue()
		return
	endIf
	version = _RO_Version.GetValue()
	
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