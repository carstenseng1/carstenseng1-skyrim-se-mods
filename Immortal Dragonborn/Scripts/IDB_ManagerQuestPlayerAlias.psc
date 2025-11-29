Scriptname IDB_ManagerQuestPlayerAlias extends ReferenceAlias  
{Quest Alias referencing the Player Actor to manage Immortal Dragonborn Mod}


Int version = 0

GlobalVariable Property IDB_Enabled  Auto
Quest Property IDB_ManagerQuest  Auto
SPELL Property IDB_AvoidDeathAbility  Auto 

Event OnInit()
	RegisterForSingleUpdate(0.1)
endEvent

Event OnPlayerLoadGame()
	if version == 0 || version != 1 ; Hard coded script version. Set 0 to force update
		RegisterForSingleUpdate(0.1)
	endIf
endEvent

Event OnUpdate()
	version = 1
	;Debug.Notification("Immortal Dragonborn")
	
	if IDB_Enabled.GetValue() as Bool
		GetActorRef().AddSpell(IDB_AvoidDeathAbility, false)
	else
		GetActorRef().RemoveSpell(IDB_AvoidDeathAbility)
		IDB_ManagerQuest.Stop()
		Clear()
	endIf
endEvent