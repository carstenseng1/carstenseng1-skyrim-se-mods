Scriptname _ENEMY_COUNT_spawn extends Actor  
{Spawn an actor on load}

ActorBase Property spawnedActorBase  Auto  
ActorBase Property requiredActorBase  Auto 
_ENEMY_COUNT_QuestScript Property _ENEMY_COUNT_Quest  Auto  
Int Property spawnCountMod = 0 Auto  

Event OnLoad()
	if (_ENEMY_COUNT_Quest.difficulty != 0)
		Spawn()
	endIf
endevent

Function Spawn()
	;Require that the actor is alive
	if (self.isDead())
		return
	endif
	
	;Require that the actor equal the required actor base if set
	;This prevents subclasses of spawning actor bases to incorrecly spawn
	if (requiredActorBase == NONE || self.GetActorBase() == requiredActorBase)
		;Check passed
	else
		Notification("Did not spawn. Required ActorBase does not match.")
		return
	endif
	
	;All checks passed. Will attempt spawn
	Int count = 0
	Float chance = 0
	Int difficulty = _ENEMY_COUNT_Quest.difficulty
	if (self.isInInterior())
		count = _ENEMY_COUNT_Quest.spawnCountInterior[difficulty] + spawnCountMod
		chance = _ENEMY_COUNT_Quest.spawnChanceInterior[difficulty]
	else
		count = _ENEMY_COUNT_Quest.spawnCountExterior[difficulty] + spawnCountMod
		chance = _ENEMY_COUNT_Quest.spawnChanceExterior[difficulty]
	endif
	
	if (chance < 0)
		chance = 0
	elseIf (chance > 1)
		chance = 1
	endIf
	
	if (count == 0)
		Notification("Did not spawn. Attempt count is 0")
	endIf
	
	while count
		count -= 1
		float random = Utility.RandomFloat()
		if (chance >= random)
			self.PlaceActorAtMe(spawnedActorBase)
			Notification("Spawned enemy. chance:"+chance+" random:"+random)
		endif
	endwhile
endFunction

Function Notification(string aNotification)
	if (_ENEMY_COUNT_Quest.debugNotifications)
		Debug.Notification(aNotification)
	endIf
endFunction
