Scriptname _RO_QuestScript extends Quest  

GlobalVariable Property _RO_Version  Auto
Float version = 0.0

GlobalVariable Property _RO_Debug  Auto

SPELL[] Property DefaultSpells  Auto
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
	Int i = 0
	While i < DefaultSpells.Length
		player.AddSpell(DefaultSpells[i], false)
		i = i + 1	
	endWhile
	
	; Enable destructible weapons
	player.AddPerk(_RO_DestructibleWeaponPerk)

endFunction


Function Notification(String text)

	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf

endFunction