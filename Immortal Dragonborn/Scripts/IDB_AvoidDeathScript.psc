Scriptname IDB_AvoidDeathScript extends ActiveMagicEffect  

GlobalVariable Property IDB_PercentHealth  Auto
GlobalVariable Property IDB_DragonsoulCost  Auto
GlobalVariable Property IDB_ParalysisEnabled  Auto
GlobalVariable Property IDB_FearEnabled  Auto

EffectShader Property DragonPowerAbsorbFXS Auto
Sound property NPCDragonDeathSequenceWind auto

Quest Property DGIntimidateQuest Auto

Spell Property PerkAvoidDeathAbility  Auto 
GlobalVariable Property PerkAvoidDeathTimer  Auto
GlobalVariable Property GameDaysPassed  Auto

Spell Property IDB_HealSpell  Auto 
Spell Property IDB_ParalyzeSpell  Auto
Spell Property IDB_FearSpell  Auto

; PRIVATE VARIABLES -------------------------------------------------------------------------------

Bool bIsUpdating = false

; EVENTS ------------------------------------------------------------------------------------------

;Event OnEffectStart(Actor akTarget, Actor akCaster)
;	DragonPowerAbsorbFXS.Play(akTarget, 3.0)
;	NPCDragonDeathSequenceWind.play(akTarget) 
;	Debug.Notification("A great power stirs within you.")
;endEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked )
	; Rate-limit hit detection by registering for a single update
	if bIsUpdating
		return
	else
		bIsUpdating = true
		RegisterForSingleUpdate(0.1)
	endIf
endEvent

Event OnUpdate()
	; Reset flag to allow subsequent updates
	bIsUpdating = false

	; Don't revive when brawling
	if (DGIntimidateQuest.IsRunning())
		return
	endIf
	
	Actor player = GetTargetActor()
	
	; Don't revive when the Avoid Death Perk should activate
	if player.HasSpell(PerkAvoidDeathAbility) && PerkAvoidDeathTimer.GetValue() < GameDaysPassed.GetValue()
		return
	endIf

	; Effect condition should already be checking Dragon Soul count
	; Cast heal spell if health is low
	if player.GetAVPercentage("Health") < IDB_PercentHealth.GetValue()
		; Cast healing
		IDB_HealSpell.Cast(player)
		
		; Cast Paralysis if enabled
		if IDB_ParalysisEnabled.GetValue() as Bool
			IDB_ParalyzeSpell.Cast(player)
		endIf
		
		; Cast Fear if enabled
		if IDB_FearEnabled.GetValue() as Bool
			IDB_FearSpell.Cast(player)
		endIf
		
		; Remove Dragon Souls
		int iCost = IDB_DragonsoulCost.GetValueInt()
		player.ModAV("DragonSouls", -iCost)
		
		; Play FX and sound
		DragonPowerAbsorbFXS.Play(player, 2.0)
		NPCDragonDeathSequenceWind.play(player) 
	endIf
endEvent
