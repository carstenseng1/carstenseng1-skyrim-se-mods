Scriptname _RO_TimedAbilitySecondsScript extends ActiveMagicEffect  

Spell Property pAbilityToRemove Auto
Int Property pSecondsToWait Auto

Event OnUpdate()

; 	debug.trace(self + "OnUpdateGameTime")
	Game.GetPlayer().RemoveSpell(pAbilityToRemove)
	
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	; start timer
	RegisterForSingleUpdate(pSecondstoWait)
	
EndEvent