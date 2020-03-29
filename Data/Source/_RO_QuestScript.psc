Scriptname _RO_QuestScript extends Quest  

GlobalVariable Property _RO_Version  Auto
Float version = 0.0

GlobalVariable Property _RO_Debug  Auto

SPELL Property _RO_SettingsSpell  Auto
Perk Property _RO_DestructibleWeaponPerk  Auto


Event OnInit()
	Maintenance()
endEvent


Function Maintenance()
	
	if version != 0.0 && version == _RO_Version.GetValue()
		return
	endIf
	version = _RO_Version.GetValue()
	
	Debug.Notification("Fjør Tall v" + version)
	
	Actor player = Game.GetPlayer()

	; Add default spells
	player.AddSpell(_RO_SettingsSpell, false)
	
	; Enable destructible weapons
	player.AddPerk(_RO_DestructibleWeaponPerk)

endFunction


Function _RO_Note(String text)

	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf

endFunction