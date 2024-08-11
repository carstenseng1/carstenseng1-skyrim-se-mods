Scriptname _PlayerProtection_PlayerAliasScript extends ReferenceAlias  

GlobalVariable Property _player_protection_enabled Auto
GlobalVariable Property _player_protection_stunEnabled  Auto  
GlobalVariable Property _player_protection_debugNotifications Auto

Actor Property PlayerRef  Auto  
SPELL Property _PlayerProtectionEnableSpell  Auto  
SPELL Property _PlayerProtectionDisableSpell  Auto 
Spell Property _PlayerProtectionMassParalysis Auto
Quest Property DGIntimidateQuest Auto

VisualEffect Property DragonAbsorbEffect Auto
VisualEffect Property DragonAbsorbManEffect Auto
EffectShader Property DragonPowerAbsorbFXS Auto
sound property NPCDragonDeathSequenceWind auto
sound property NPCDragonDeathSequenceExplosion auto

bool reviving
bool noBleedoutRecovery

Event OnInit()
	EnableImmortalDragonborn(_player_protection_enabled.GetValue())
EndEvent

Event OnEnterBleedout()
	Notification("start bleedout")
	
	if (_player_protection_enabled.GetValue() && IsDying())
		if (GetShouldRevive())
			Revive(GetShouldCastParalysis())
		else
			Notification("death")
			PlayerRef.KillEssential(NONE)
		endIf
	else
		Notification("normal bleedout")
		Debug.Notification("You can't continue fighting.")
	endIf
endEvent

Event OnUpdate()
	if (!_player_protection_enabled.GetValue())
		Notification("no update: mod is disabled")
		return
	endIf

	if (reviving)
		Notification("no update: reviving")
		return
	endIf
	
	if (Utility.IsInMenuMode())
		Notification("no update: menu mode")
		return
	endIf
	
	UpdateImmortality()
endEvent

Function EnableImmortalDragonborn(bool enable)

	if (DGIntimidateQuest.IsRunning())
		Notification("Cannot enable/disable Immortal Dragonborn while brawling")
		return
	endIf
	
	if (enable)
		_player_protection_enabled.SetValue(1)
		
		Debug.Notification("Immortal Dragonborn")
		UpdateImmortality()
		RegisterForUpdate(60)
		
		PlayerRef.RemoveSpell(_PlayerProtectionEnableSpell)
		PlayerRef.AddSpell(_PlayerProtectionDisableSpell)
	else
		_player_protection_enabled.SetValue(0)
		
		Debug.Notification("You are mortal.")
		PlayerRef.GetActorBase().SetEssential(false)
		PlayerRef.SetNoBleedoutRecovery(false)
		UnregisterForUpdate()
		
		PlayerRef.RemoveSpell(_PlayerProtectionDisableSpell)
		PlayerRef.AddSpell(_PlayerProtectionEnableSpell)
	endIf
	
	Notification("Immortal Dragonborn enabled:"+enable+" essential:"+PlayerRef.IsEssential())
endFunction

Function UpdateImmortality()
	if (_player_protection_enabled.GetValue() && PlayerRef.GetAV("DragonSouls") > 0)
		if (!PlayerRef.IsEssential())
			PlayerRef.GetActorBase().SetEssential(true)
			DragonPowerAbsorbFXS.Play(PlayerRef, 8)
			NPCDragonDeathSequenceWind.play(PlayerRef) 
			Debug.Notification("A great power stirs within you.")
		endIf
	else
		if (PlayerRef.IsEssential())
			PlayerRef.GetActorBase().SetEssential(false)
			Debug.Notification("You sense your mortality.")
		endIf
	endIf
	Notification("UpdateImmortality: essential:"+PlayerRef.IsEssential()+" dragonsouls:"+PlayerRef.GetAV("DragonSouls"))
endFunction

bool Function IsDying()
	;Test for brawl first in order to perform manual recovery
	if (DGIntimidateQuest.IsRunning())
		Notification("no revive:brawling")
		Utility.Wait(4)
		PlayerRef.RestoreActorValue("Health", Game.GetPlayer().GetBaseActorValue("Health")/2)
		return false
	endIf
	
	if (PlayerRef.GetAV("Health")> 0)
		Notification("not revive: health > 0")
		return false
	endIf
	
	Notification("dying")
	return true
endFunction

bool Function GetShouldRevive()
	if (PlayerRef.IsInKillmove())
		Notification("player in killmove")
		return false
	endIf
	
	if (PlayerRef.GetAV("DragonSouls") <= 0)
		Notification("insufficient dragon souls")
		return false
	endIf
	
	Notification("should revive")
	return true
endFunction

bool Function GetShouldCastParalysis()
	if (_player_protection_stunEnabled.GetValue() == 0)
		Notification("stun disabled")
		return false
	endIf
	
	bool ret = true
	if (!PlayerRef.isInCombat())
		Notification("stun cancelled: player not in combat")
		return false
	endIf
	
	Notification("should cast stun")
	return ret
endFunction

Function Revive(bool shouldCastParalysis)
	Notification("start revive")
	
	reviving = true
	noBleedoutRecovery = PlayerRef.GetNoBleedoutRecovery()
	PlayerRef.SetNoBleedoutRecovery(true)
	UnregisterForUpdate()
	
	;display dragon absorb effects
	DragonAbsorbEffect.Play(PlayerRef, 8)
	DragonAbsorbManEffect.Play(PlayerRef, 8)
	DragonPowerAbsorbFXS.Play(PlayerRef, 8)
	
	; Sounds for dragon absorb
	NPCDragonDeathSequenceWind.play(PlayerRef) 
	NPCDragonDeathSequenceExplosion.play(PlayerRef)
	
	Utility.Wait(4)
	Notification("finish revive")
	
	PlayerRef.SetNoBleedoutRecovery(noBleedoutRecovery)
	
	PlayerRef.ModAV("DragonSouls", -1)
	Debug.Notification("You lost a dragon soul.")
	
	PlayerRef.ResetHealthAndLimbs()
	PlayerRef.RestoreActorValue("Magicka", Game.GetPlayer().GetBaseActorValue("Magicka"))
	PlayerRef.RestoreActorValue("Stamina", Game.GetPlayer().GetBaseActorValue("Stamina"))
	
	if (shouldCastParalysis)
		_PlayerProtectionMassParalysis.Cast(PlayerRef, NONE)
	endIf
	
	reviving = false
	UpdateImmortality()
	RegisterForUpdate(60)
endFunction


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Utility Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function Notification(string aNotification)
	if (_player_protection_debugNotifications.GetValue())
		Debug.Notification(aNotification)
	endIf
endFunction
 
