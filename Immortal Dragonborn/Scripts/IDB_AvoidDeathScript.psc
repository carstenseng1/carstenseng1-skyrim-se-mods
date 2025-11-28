Scriptname IDB_AvoidDeathScript extends ActiveMagicEffect  

EffectShader Property DragonPowerAbsorbFXS Auto
Sound property NPCDragonDeathSequenceWind auto

Quest Property DGIntimidateQuest Auto

Spell Property PerkAvoidDeathAbility  Auto 
GlobalVariable Property PerkAvoidDeathTimer  Auto
GlobalVariable Property GameDaysPassed  Auto

Spell Property IDB_HealSpell  Auto 

Event OnEffectStart(Actor akTarget, Actor akCaster)
	DragonPowerAbsorbFXS.Play(akTarget, 3.0)
	NPCDragonDeathSequenceWind.play(akTarget) 
	Debug.Notification("A great power stirs within you.")
endEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked )
	; Don't revive when brawling
	if (DGIntimidateQuest.IsRunning())
		return
	endIf

	; Don't revive when the Avoid Death Perk should activate
	if GetTargetActor().HasSpell(PerkAvoidDeathAbility) && PerkAvoidDeathTimer.GetValue() < GameDaysPassed.GetValue()
		return
	endIf

	; Effect condition should already be checking Dragon Soul count
	; Cast heal spell if health is low
	if GetTargetActor().GetAVPercentage("Health") < 0.1
		IDB_HealSpell.Cast(GetTargetActor())
		
		; Remove 1 Dragon Soul
		GetTargetActor().ModAV("DragonSouls", -1.0)
	endIf
endEvent
