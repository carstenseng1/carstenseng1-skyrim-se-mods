Scriptname _RO_ManagerQuestScript extends Quest  
{Quest script for managing main essential features of Roleplaying Overhaul}


GlobalVariable Property _RO_Version  Auto
Int version = 0

GlobalVariable Property _RO_Debug  Auto

SPELL Property _RO_LastStandAbility  Auto
Perk Property _RO_DestructibleWeaponPerk  Auto

MiscObject Property Gold001  Auto
Potion Property _RO_DropGoldALC  Auto

; Maintenance is only handled in OnInit for initial setup.
; Update maintenance is handled by the Player Alias with OnPlayerLoadGame event
Event OnInit()
	Maintenance()
endEvent


Function Maintenance()
	
	version = _RO_Version.GetValueInt()
	
	Notification("Fjør Tall v" + version)
	
	Actor player = Game.GetPlayer()
	bool isDebugMode = _RO_Debug.GetValue()
	
	; Add default spells
	player.AddSpell(_RO_LastStandAbility, isDebugMode)
	
	; Enable destructible weapons
	player.AddPerk(_RO_DestructibleWeaponPerk)

	; Start listening for the Inventory Menu to enable dropping gold
	RegisterForMenu("InventoryMenu")

EndFunction


Function Notification(String text)

	If _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	EndIf

EndFunction


Event OnMenuOpen(String MenuName)

	; Add Drop Gold options
	Actor player = Game.GetPlayer()
	If (player.GetItemCount(Gold001) >= 100)
		player.AddItem(_RO_DropGoldALC, 1, true)
	EndIf

EndEvent


Event OnMenuClose(String MenuName)

	Game.GetPlayer().RemoveItem(_RO_DropGoldALC, 1, true)

EndEvent

