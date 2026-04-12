Scriptname _RO_CraftingFieldEffectScript extends activemagiceffect  

ObjectReference Property pStation  Auto  


Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	If (akCaster == Game.GetPlayer())
		pStation.Activate(akCaster)
	EndIf

EndEvent

