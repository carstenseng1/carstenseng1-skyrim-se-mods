Scriptname _RO_RemovePerkEffectScript extends activemagiceffect  
{Removes the perk when the effect finishes.}

Perk Property pPerk  Auto
{to be removed when the effect finishes}

Bool Property pAddOnStart = true Auto


Event OnEffectStart(Actor akTarget, Actor akCaster)

	if pAddOnStart
		akTarget.AddPerk(pPerk)
	endIf

endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)

	akTarget.RemovePerk(pPerk)

endEvent