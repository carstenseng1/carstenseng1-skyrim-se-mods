Scriptname _RO_UndeadCurseEffectScript extends activemagiceffect  

ImageSpaceModifier Property _RO_UndeadCurseImod  Auto  


Event OnEffectStart(Actor akTarget, Actor akCaster)

	Debug.Notification("You are cursed.")
	_RO_UndeadCurseImod.Apply()
	Game.ShakeCamera()

endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)

	_RO_UndeadCurseImod.Remove()

endEvent