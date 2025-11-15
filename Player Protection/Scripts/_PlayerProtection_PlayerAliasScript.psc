Scriptname _PlayerProtection_PlayerAliasScript extends ReferenceAlias  

GlobalVariable Property _player_protection_enabled Auto
GlobalVariable Property _player_protection_stunEnabled  Auto
GlobalVariable Property _player_protection_debugNotifications Auto
GlobalVariable Property _player_protection_activationHealth  Auto

Actor Property PlayerRef  Auto
Spell Property _PlayerProtectionMassParalysis Auto

Quest Property DGIntimidateQuest Auto

EffectShader Property DragonPowerAbsorbFXS Auto
sound property NPCDragonDeathSequenceWind auto
sound property NPCDragonDeathSequenceExplosion auto


Event OnInit()
	EnableImmortalDragonborn(_player_protection_enabled.GetValue())
EndEvent

Event OnUpdate()
	; Stop updating if mod is disabled
	if (!_player_protection_enabled.GetValue())
		Notification("no update: mod is disabled")
		UnregisterForUpdate()
		return
	endIf
	
	; Don't show immortality if in a menu
	if (Utility.IsInMenuMode())
		Notification("no update: menu mode")
		return
	endIf
	
	; Show immortality if dragon souls > 0
	if (PlayerRef.GetAV("DragonSouls") > 0)
		ShowImmortality()

		; Stop updating to show immortality
		UnregisterForUpdate()
	endIf
endEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	
	Float health = PlayerRef.GetActorValuePercentage("Health")
	if (health > _player_protection_activationHealth.GetValue())
		return
	endIf
	
	; Check if mod is enabled
	if (!_player_protection_enabled.GetValue())
		return
	endIf

	; Don't revive if no dragon souls
	if (PlayerRef.GetAV("DragonSouls") <= 0)
		Notification("insufficient dragon souls")
		return
	endIf
	
	; Don't revive if in a killmove
	if (PlayerRef.IsInKillmove())
		Notification("player in killmove")
		return
	endIf

	; Don't revive when brawling
	if (DGIntimidateQuest.IsRunning())
		return
	endIf

	; All checks passed
	Notification("Revive")
	
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
	if (_player_protection_stunEnabled.GetValue() == 1 && PlayerRef.isInCombat())
		_PlayerProtectionMassParalysis.Cast(PlayerRef, NONE)
	endIf
	
	; Notify the player of mortality at 0 souls
	if (PlayerRef.GetAV("DragonSouls") == 0)
		Debug.Notification("You sense your mortality.")
	endIf
endEvent

Function EnableImmortalDragonborn(bool enable)
	
	if (enable)
		_player_protection_enabled.SetValue(1)
		
		Debug.Notification("Immortal Dragonborn")
		if (PlayerRef.GetAV("DragonSouls") > 0)
			ShowImmortality()
		else
			; Register for Update to check dragon soul count
			RegisterForUpdate(60)
		endIf
	else
		_player_protection_enabled.SetValue(0)
		
		Debug.Notification("You are mortal.")
		UnregisterForUpdate()
	endIf
	
	Notification("Immortal Dragonborn enabled:" + enable)
endFunction

Function ShowImmortality()
	DragonPowerAbsorbFXS.Play(PlayerRef, 3.0)
	NPCDragonDeathSequenceWind.play(PlayerRef) 
	Debug.Notification("A great power stirs within you.")
endFunction


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Utility Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function Notification(string aNotification)
	if (_player_protection_debugNotifications.GetValue())
		Debug.Notification(aNotification)
	endIf
endFunction
 
