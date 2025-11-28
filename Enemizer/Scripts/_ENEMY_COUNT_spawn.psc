Scriptname _ENEMY_COUNT_spawn extends Actor  
{Spawn an actor on load}

ActorBase Property spawnedActorBase  Auto
ActorBase Property requiredActorBase  Auto

Int Property pSpawnCountInterior = 1  Auto
Int Property pSpawnCountExterior = 1  Auto
Float Property pSpawnChanceInterior = 0.75  Auto
Float Property pSpawnChanceExterior = 0.5 Auto

Event OnLoad()
	Spawn()
endevent

Function Spawn()
	;Require that the actor is alive
	if (self.isDead())
		return
	endIf
	
	;Require that the actor equal the required actor base if set
	;This prevents subclasses of spawning actor bases to incorrecly spawn
	if (requiredActorBase == NONE || self.GetActorBase() == requiredActorBase)
		;Check passed
	else
		;Debug.Notification("Did not spawn. Required ActorBase does not match.")
		return
	endIf
	
	;All checks passed. Will attempt spawn
	Int count = 0
	Float chance = 0.0
	if (self.isInInterior())
		count = pSpawnCountInterior
		chance = pSpawnChanceInterior
	else
		count = pSpawnCountExterior
		chance = pSpawnChanceExterior
	endIf
	
	if (chance < 0.0)
		chance = 0.0
	elseIf (chance > 1.0)
		chance = 1.0
	endIf
	
	if (count == 0)
		;Debug.Notification("Did not spawn. Attempt count is 0")
	endIf
	
	while count
		count -= 1
		Float random = Utility.RandomFloat()
		if (chance >= random)
			self.PlaceActorAtMe(spawnedActorBase)
			Debug.Notification("Spawned enemy. chance:"+chance+" random:"+random)
		endif
	endWhile

endFunction
