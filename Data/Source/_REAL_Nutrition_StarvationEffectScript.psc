Scriptname _REAL_Nutrition_StarvationEffectScript extends activemagiceffect



Actor target



Event OnEffectStart(Actor akTarget, Actor akCaster)

	;Debug.Notification("Magic effect was started on " + akTarget)

	target = akTarget

	akTarget.PlayIdle(bleedOutStart)

	RegisterForUpdate(1)

endEvent



Event OnUpdate()

	;Debug.Notification("Starve effect update")

	target.DamageAV("health", healthDamage)

endEvent



Event OnEffectFinish(Actor akTarget, Actor akCaster)

	;Debug.Notification("Magic effect was ended on " + akTarget)

	akTarget.PlayIdle(bleedOutStop)

	UnregisterForUpdate()

endEvent



Float Property healthDamage  Auto  


Idle Property bleedOutStart  Auto  


Idle Property bleedOutStop  Auto  
