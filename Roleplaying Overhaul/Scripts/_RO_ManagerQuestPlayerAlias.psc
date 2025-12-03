Scriptname _RO_ManagerQuestPlayerAlias extends ReferenceAlias  
{Player Alias script for capturing player events and managing essential features of Roleplaying Overhaul}

GlobalVariable Property _RO_Enabled  Auto
GlobalVariable Property _RO_Debug  Auto

Perk Property _RO_SlowSkillAdvancementPerk  Auto
Spell Property _RO_DropGoldSpell  Auto

Int version = 0

Event OnInit()
	Maintenance()
endEvent


Event OnPlayerLoadGame()
	if version == 0 || version != 1
		Maintenance()
	endIf
endEvent


Function Maintenance()
	
	version = 1

	Actor player = Game.GetPlayer()
	
	if _RO_Enabled.GetValue() as Bool
		; Set player ref
		ForceRefTo(player)

		; Add default perks & spells
		player.AddPerk(_RO_SlowSkillAdvancementPerk)
		player.AddSpell(_RO_DropGoldSpell, _RO_Debug.GetValue() as Bool)
	else
		; Clear player ref
		Clear()

		; Remove default perks & spells
		player.RemovePerk(_RO_SlowSkillAdvancementPerk)
		player.RemoveSpell(_RO_DropGoldSpell)
	endIf

endFunction