Scriptname ENMZ_ManagerQuestScript extends Quest  
{Quest Script to manage Enemizer}

GlobalVariable Property ENMZ_Enabled  Auto
GlobalVariable Property ENMZ_Debug  Auto
GlobalVariable Property ENMZ_SpawnCountInterior  Auto
GlobalVariable Property ENMZ_SpawnCountExterior  Auto
GlobalVariable Property ENMZ_SpawnChanceInterior  Auto
GlobalVariable Property ENMZ_SpawnChanceExterior  Auto


Event OnUpdate()
	DebugScript("Enemizer Update")
	
	ReferenceAlias playerAlias = GetAlias(0) as ReferenceAlias

	if ENMZ_Enabled.GetValue() as Bool
		playerAlias.ForceRefTo(Game.GetPlayer())
	else
		self.Stop()
		playerAlias.Clear()
	endIf
endEvent


Function Spawn(Actor akActor, ActorBase akSpawnedActorBase, Int aiAdditionalSpawnCount = 0, ActorBase akRequiredActorBase = NONE)
	; Check if mod is enabled
	if !(ENMZ_Enabled.GetValue() as Bool)
		return
	endIf
	
	;Require that the actor is alive
	if (akActor.isDead())
		return
	endIf
	
	;Require that the actor equal the required actor base if set
	;This prevents subclasses of spawning actor bases to incorrecly spawn
	if (akRequiredActorBase != NONE && akActor.GetActorBase() != akRequiredActorBase)
		DebugScript("Did not spawn. Required ActorBase does not match.")
		return
	endIf
	
	;All checks passed. Will attempt spawn

	; Set the number of spawn attempts
	Int count = 0
	Float chance = 0.0
	if (akActor.isInInterior())
		count = ENMZ_SpawnCountInterior.GetValueInt()
		chance = ENMZ_SpawnChanceInterior.GetValue()
	else
		count = ENMZ_SpawnCountExterior.GetValueInt()
		chance = ENMZ_SpawnChanceExterior.GetValue()
	endIf
	count += aiAdditionalSpawnCount
	
	while count > 0
		count -= 1
		Float random = Utility.RandomFloat()
		if (chance >= random)
			akActor.PlaceActorAtMe(akSpawnedActorBase)
			DebugScript("Spawned enemy. Chance:"+chance+" Random:"+random)
		endif
	endWhile

endFunction


Function DebugScript(String asMessage)
	if ENMZ_Debug.GetValue() as Bool
		Debug.Trace(asMessage)
		Debug.Notification(asMessage)
	endIf
endFunction