Scriptname LastStandAbilityScriptEffect extends activemagiceffect  

GlobalVariable Property LastStandDebug  Auto
Spell Property LastStandSlowTime  Auto
GlobalVariable Property LastStandSlowTimeHP  Auto

; PRIVATE VARIABLES -------------------------------------------------------------------------------

Actor player
Bool bIsWaitingOnHit = false
Bool bIsWaitingSlowTime = false

; EVENTS ------------------------------------------------------------------------------------------

Event OnEffectStart(Actor akTarget, Actor akCaster)
	; Set reference to player for faster processing OnHit
	player = akTarget
endEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	; Rate limit with wait and flag
	if bIsWaitingOnHit
		DebugScript("OnHit Waiting")
		return
	endIf
	bIsWaitingOnHit = true
	Utility.Wait(0.1)
	bIsWaitingOnHit = false

	; Stop! He's already dead!
	if player.isDead()
		return
	endIf

	; Apply slow time effect if rate-limit wait elapsed and health is low
	if !bIsWaitingSlowTime && player.getActorValuePercentage("Health") <= LastStandSlowTimeHP.GetValue()
		LastStandSlowTime.Cast(player, player)

		; Rate limit 1.0 sec
		bIsWaitingSlowTime = true
		Utility.Wait(1.0)
		bIsWaitingSlowTime = false
	endif
endEVENT

; UTILITY ------------------------------------------------------------------------------------------

Function DebugScript(String asMessage)
	if LastStandDebug.GetValue() as Bool
		Debug.Trace(asMessage)
		Debug.Notification("Last Stand: " + asMessage)
	endIf
endFunction