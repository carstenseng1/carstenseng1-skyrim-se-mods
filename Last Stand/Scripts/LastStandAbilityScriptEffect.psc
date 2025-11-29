Scriptname LastStandAbilityScriptEffect extends activemagiceffect  


Spell Property LastStandSlowTime  Auto
GlobalVariable Property LastStandSlowTimeHP  Auto

Actor playerRef


Event OnEffectStart(Actor akTarget, Actor akCaster)

	playerRef = akTarget

endEvent

Event onHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)

	if playerRef.isDead()
		return
	endIf

	if playerRef.getActorValuePercentage("Health") <= LastStandSlowTimeHP.GetValue()
		LastStandSlowTime.Cast(playerRef, playerRef)
	endif
	
endEVENT