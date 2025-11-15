Scriptname _RO_EquipmentPerkScript extends ObjectReference  
{Adds a perk while the object is equipped, and removes the perk when the object is unequipped.}

GlobalVariable Property _RO_Debug  Auto

Perk Property EquipPerk  Auto
Bool Property PlayerOnly  = true  Auto


Event OnEquipped(Actor akActor)

	if PlayerOnly && akActor != Game.GetPlayer()
		_RO_Note("Equipped on non-player")
		return
	endIf
	
	akActor.AddPerk(EquipPerk)
	
	if akActor.HasPerk(EquipPerk)
		_RO_Note("Has equip perk: Yes")
	else
		_RO_Note("Has equip perk: No")
	endIf

EndEvent


Event OnUnEquipped(Actor akActor)
	
	if PlayerOnly && akActor != Game.GetPlayer()
		return
	endIf
	
	akActor.RemovePerk(EquipPerk)

	if akActor.HasPerk(EquipPerk)
		_RO_Note("Has equip perk: Yes")
	else
		_RO_Note("Has equip perk: No")
	endIf

EndEvent


Function _RO_Note(String text)
	
	if _RO_Debug.GetValue() == 1.0
		Debug.Notification(text)
	endIf

endFunction