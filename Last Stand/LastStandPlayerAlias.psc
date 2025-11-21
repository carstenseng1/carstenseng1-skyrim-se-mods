Scriptname LastStandPlayerAlias extends ReferenceAlias
{Reference Alias Script for Player to manage Last Stand}

actor property selfRef auto hidden
float property HPthreshold = 0.20 auto
Spell Property LastStand  Auto  


EVENT OnInit()
	
	selfRef = GetActorRef()
	
endEVENT


EVENT onHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)

	if (selfRef.getActorValuePercentage("Health") < HPthreshold) && !(selfRef.isDead())
		LastStand.Cast(selfRef, selfRef)
	endif
	
endEVENT