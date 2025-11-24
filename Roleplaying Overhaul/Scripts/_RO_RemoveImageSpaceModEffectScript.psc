Scriptname _RO_RemoveImageSpaceModEffectScript extends ActiveMagicEffect  
{Removes the given ImageSpaceModifier when the effect ends}

ImageSpaceModifier Property pImageSpaceModifier  Auto  
{to be removed when effect ends}

Event OnEffectStart(Actor akTarget, Actor akCaster)

	pImageSpaceModifier.Apply()

endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)

	pImageSpaceModifier.Remove()

endEvent