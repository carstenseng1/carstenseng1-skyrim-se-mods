Scriptname _RO_EquipmentPerkScript extends ObjectReference  
{Adds a perk while the object is equipped, and removes the perk when the object is unequipped.}

Perk Property EquipPerk auto

Event OnEquipped(Actor akActor)
	akActor.AddPerk(EquipPerk)
	
	if akActor.HasPerk(EquipPerk)
		Debug.Notification("Has equip perk: Yes")
	else
		Debug.Notification("Has equip perk: No")
	endIf

EndEvent

Event OnUnEquipped(Actor akActor)
	akActor.RemovePerk(EquipPerk)

	if akActor.HasPerk(EquipPerk)
		Debug.Notification("Has equip perk: Yes")
	else
		Debug.Notification("Has equip perk: No")
	endIf

EndEvent