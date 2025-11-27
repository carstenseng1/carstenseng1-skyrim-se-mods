Scriptname _PlayerProtection_PlayerAliasScript extends ReferenceAlias  

Int version = 0

Spell Property _PlayerProtectionMassParalysis Auto

Quest Property DGIntimidateQuest Auto

EffectShader Property DragonPowerAbsorbFXS Auto
sound property NPCDragonDeathSequenceWind auto
sound property NPCDragonDeathSequenceExplosion auto

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
	UnregisterForUpdate()
	
	DebugScript("Immortal Dragonborn Maintenance")
	if (GetActorRef().GetAV("DragonSouls") > 0)
		ShowImmortality()
	else
		; Register for Update to check dragon soul count
		RegisterForSingleUpdate(60)
	endIf
endFunction

Event OnUpdate()
	; Stop repeated updates
	UnregisterForUpdate()
	
	; Don't show immortality if in a menu
	if (Utility.IsInMenuMode())
		DebugScript("no update: menu mode")
		return
	endIf
	
	; Show immortality if dragon souls > 0
	if (GetActorRef().GetAV("DragonSouls") > 0)
		ShowImmortality()
	else
		; Keep watching for dragon souls to increase
		RegisterForSingleUpdate(60)
	endIf
endEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	
	Actor PlayerRef = GetActorRef()

	Float health = PlayerRef.GetActorValuePercentage("Health")
	if (health > 0.1) ; Use 0.1 which is same as Avoid Death Perk health threshold
		return
	endIf

	; Don't revive if no dragon souls
	if (PlayerRef.GetAV("DragonSouls") <= 0)
		DebugScript("insufficient dragon souls")
		return
	endIf
	
	; Don't revive if in a killmove
	if (PlayerRef.IsInKillmove())
		DebugScript("player in killmove")
		return
	endIf

	; Don't revive when brawling
	if (DGIntimidateQuest.IsRunning())
		return
	endIf

	; All checks passed
	DebugScript("Revive")
	
	; Display dragon absorb effects
	DragonPowerAbsorbFXS.Play(PlayerRef, 3.0)
	
	; Sounds for dragon absorb
	NPCDragonDeathSequenceWind.Play(PlayerRef) 
	NPCDragonDeathSequenceExplosion.Play(PlayerRef)
	
	PlayerRef.ModAV("DragonSouls", -1)
	Debug.Notification("You lost a dragon soul.")
	
	PlayerRef.RestoreActorValue("Health", Game.GetPlayer().GetBaseActorValue("Health"))
	PlayerRef.RestoreActorValue("Magicka", Game.GetPlayer().GetBaseActorValue("Magicka"))
	PlayerRef.RestoreActorValue("Stamina", Game.GetPlayer().GetBaseActorValue("Stamina"))
	
	; Cast the paralysis spell if enabled and in combat
	if (PlayerRef.isInCombat())
		_PlayerProtectionMassParalysis.Cast(PlayerRef, NONE)
	endIf
	
	; Notify the player of mortality at 0 souls
	if (PlayerRef.GetAV("DragonSouls") == 0)
		Debug.Notification("You sense your mortality.")
	endIf
endEvent

Function ShowImmortality()
	Actor PlayerRef = GetActorRef()

	DragonPowerAbsorbFXS.Play(PlayerRef, 3.0)
	NPCDragonDeathSequenceWind.play(PlayerRef) 
	Debug.Notification("A great power stirs within you.")
endFunction


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Utility Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function DebugScript(String asMessage)
	Debug.Trace(asMessage)
	Debug.Notification(asMessage)
endFunction
 
