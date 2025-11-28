Scriptname IDB_ManagerQuestPlayerAlias extends ReferenceAlias  
{Quest Alias referencing the Player Actor to manage Immortal Dragonborn Mod}


Int version = 0

SPELL Property IDB_AvoidDeathAbility  Auto 

Event OnInit()
	Maintenance()
endEvent

Event OnPlayerLoadGame()
	if version == 0 || version != 1 ; Hard coded script version. Set 0 to force maintenance
		version = 1
		Maintenance()
	endIf
endEvent

Function Maintenance()
	Debug.Notification("Immortal Dragonborn")
	GetActorRef().AddSpell(IDB_AvoidDeathAbility)
endFunction