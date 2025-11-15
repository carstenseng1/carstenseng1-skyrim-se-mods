Scriptname _RO_LastStandScript extends ActiveMagicEffect  


Spell Property _RO_LastStandSpell  Auto  

bool isActive = true
float Property pHealthThreshold = 100.0 Auto  


Event OnUpdate()

	isActive = true

endEvent


Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked )

	If isActive
		float PercentHealth = GetTargetActor().GetAVPercentage("Health")
		If PercentHealth < pHealthThreshold
			_RO_LastStandSpell.Cast(GetTargetActor())
			isActive = false
			RegisterForSingleUpdate(10)
		EndIf
	EndIf

endEvent



