Scriptname ENMZ_SpawnActor extends actor  
{Enemizer mod script for Actor that can spawn another enemy}

ActorBase Property pSpawnedActorBase  Auto
ActorBase Property pRequiredActorBase  Auto
Int Property pAdditionalSpawnCount = 0  Auto
Quest Property ENMZ_ManagerQuest  Auto

Bool bHasSpawned = false

Event OnLoad()
	(ENMZ_ManagerQuest as ENMZ_ManagerQuestScript).Spawn(self)
	bHasSpawned = true
endevent

Bool Function GetHasSpawned()
	return bHasSpawned
endFunction