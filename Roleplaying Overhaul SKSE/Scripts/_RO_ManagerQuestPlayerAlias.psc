Scriptname _RO_ManagerQuestPlayerAlias extends ReferenceAlias  
{Player Alias script for capturing player events and managing essential features of Roleplaying Overhaul}


Perk Property _RO_DestructibleWeaponPerk  Auto
Perk Property _RO_SlowSkillAdvancementPerk  Auto
Spell Property _RO_AbLastStand  Auto
Spell Property _RO_DropGoldSpell  Auto


Event OnInit()
	Maintenance()
endEvent


Event OnPlayerLoadGame()
	Maintenance()
endEvent


Function Maintenance()
	
	Actor player = Game.GetPlayer()
	
	; Add default perks
	player.AddPerk(_RO_DestructibleWeaponPerk)
	player.AddPerk(_RO_SlowSkillAdvancementPerk)
	
	; Add default spells
	player.AddSpell(_RO_AbLastStand, false)
	player.AddSpell(_RO_DropGoldSpell, false)

endFunction