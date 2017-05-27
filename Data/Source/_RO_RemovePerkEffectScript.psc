Scriptname _RO_RemovePerkEffectScript extends activemagiceffect  
{Removes the perk when the effect finishes.}

Perk Property pPerk  Auto  
{to be removed when the effect finishes}

Event OnEffectStart(Actor akTarget, Actor akCaster)

	akTarget.AddPerk(pPerk)

endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)

	akTarget.RemovePerk(pPerk)

endEvent