Scriptname LastStandAbilityScriptEffect extends activemagiceffect  


Spell Property LastStandSlowTime  Auto

Actor playerRef


Event OnEffectStart(Actor akTarget, Actor akCaster)

	playerRef = akTarget

endEvent

Event onHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)

	if playerRef.isDead()
		return
	endIf

	if playerRef.getActorValuePercentage("Health") <= 0.25
		LastStandSlowTime.Cast(playerRef, playerRef)
	endif
	
endEVENT