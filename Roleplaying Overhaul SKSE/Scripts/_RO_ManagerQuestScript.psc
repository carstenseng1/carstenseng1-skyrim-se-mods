Scriptname _RO_ManagerQuestScript extends Quest  
{Quest script for managing main essential features of Roleplaying Overhaul}


Perk Property _RO_DestructibleWeaponPerk  Auto
Spell Property _RO_LastStandAbility  Auto
Spell Property _RO_DropGoldSpell  Auto


Function Maintenance()

	Actor player = Game.GetPlayer()
	
	; Add default spells
	player.AddSpell(_RO_LastStandAbility, false)
	player.AddSpell(_RO_DropGoldSpell, false)
	
	; Enable destructible weapons
	player.AddPerk(_RO_DestructibleWeaponPerk)

EndFunction


; Maintenance is only handled in OnInit for initial setup.
; Update maintenance is handled by the Player Alias with OnPlayerLoadGame event
Event OnInit()
	Maintenance()
endEvent




