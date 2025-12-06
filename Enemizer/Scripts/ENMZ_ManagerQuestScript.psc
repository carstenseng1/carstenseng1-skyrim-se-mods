Scriptname ENMZ_ManagerQuestScript extends Quest  
{Quest Script to manage Enemizer}

GlobalVariable Property ENMZ_Enabled  Auto
GlobalVariable Property ENMZ_Debug  Auto
GlobalVariable Property ENMZ_SpawnCountInterior  Auto
GlobalVariable Property ENMZ_SpawnCountExterior  Auto
GlobalVariable Property ENMZ_SpawnChanceInterior  Auto
GlobalVariable Property ENMZ_SpawnChanceExterior  Auto

; SCRIPT VERSION ----------------------------------------------------------------------------------

Int version = 0
Int Function GetVersion()
	return 1 ; Default version
endFunction

; INITIALIZATION ----------------------------------------------------------------------------------

Event OnInit()
	; Run maintenance with version check
	; Version check prevents double init
	Maintenance(true)
endEvent

Function Maintenance(Bool bCheckVersion = false)
	; If version check is set, cancel if script version matches last updated
	if bCheckVersion
		if version == GetVersion()
			return ; Script up to date
		endIf
	endIf

	; Record last updated version
	version = GetVersion()

	ReferenceAlias playerAlias = GetAlias(0) as ReferenceAlias

	if ENMZ_Enabled.GetValue() as Bool
		DebugScript("Enabled")
		playerAlias.ForceRefTo(Game.GetPlayer())
	else
		DebugScript("Disabled")
		playerAlias.Clear()
	endIf
endFunction

; FUNCTIONS ------------------------------------------------------------------------------------------

Function Spawn(ENMZ_SpawnActor akActor)
	; Check if mod is enabled
	if !ENMZ_Enabled.GetValue() as Bool
		DebugScript("No spawn. Enemizer disabled.")
		return
	endIf

	if !akActor
		DebugScript("No spawn. Actor NONE")
		return
	endIf
	
	if !akActor.pSpawnedActorBase
		DebugScript("No spawn. pSpawnedActorBase NONE")
		return
	endIf
	
	; Prevent spawning multiple times for same actor
	if akActor.GetHasSpawned()
		DebugScript("No spawn. Actor already spawned.")
		return
	endIf
	
	;Require that the actor is alive
	if (akActor.isDead())
		DebugScript("No spawn. Actor dead.")
		return
	endIf
	
	;Require that the actor equal the required actor base if set
	;This prevents subclasses of spawning actor bases to incorrecly spawn
	if (akActor.pRequiredActorBase != NONE && akActor.GetActorBase() != akActor.pRequiredActorBase)
		DebugScript("No spawn. pRequiredActorBase mismatch.")
		return
	endIf
	
	;All checks passed. Will attempt spawn

	; Set the number of spawn attempts
	Int count = 0
	Float chance = 0.0
	if akActor.isInInterior()
		count = ENMZ_SpawnCountInterior.GetValueInt()
		chance = ENMZ_SpawnChanceInterior.GetValue()
	else
		count = ENMZ_SpawnCountExterior.GetValueInt()
		chance = ENMZ_SpawnChanceExterior.GetValue()
	endIf
	count += akActor.pAdditionalSpawnCount
	
	while count > 0
		count -= 1
		Float random = Utility.RandomFloat()
		if (chance >= random)
			akActor.PlaceActorAtMe(akActor.pSpawnedActorBase)
			DebugScript("Spawn. Chance:"+chance+" Random:"+random)
		else
			DebugScript("No spawn. Chance:"+chance+" Random:"+random)
		endif
	endWhile

endFunction

; UTILITY ------------------------------------------------------------------------------------------

Function DebugScript(String asMessage)
	if ENMZ_Debug.GetValue() as Bool
		Debug.Trace(asMessage)
		Debug.Notification("ENMZ: " + asMessage)
	endIf
endFunction