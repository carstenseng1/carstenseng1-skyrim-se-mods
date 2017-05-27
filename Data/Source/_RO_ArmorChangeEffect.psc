Scriptname _RO_ArmorChangeEffect extends activemagiceffect  

Bool enableMovement

Event OnEffectStart(Actor akTarget, Actor akCaster)
	; Debug.Notification("Armor change started.")
	UnregisterForUpdate()
	
	; Can the player move?
	if Game.IsMovementControlsEnabled()
		enableMovement = true
		Game.DisablePlayerControls(true, false, false, false, false, false, false)
	endIf
endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; Debug.Notification("Armor change finished.")
	if enableMovement
		Game.EnablePlayerControls(true, false, false, false, false, false, false, false)
	endIf
endEvent