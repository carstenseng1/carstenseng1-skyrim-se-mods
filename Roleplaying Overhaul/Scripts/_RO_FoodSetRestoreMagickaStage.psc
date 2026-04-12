Scriptname _RO_FoodSetRestoreMagickaStage extends activemagiceffect  

_RO_FoodQuest Property pFoodQuest  Auto  
Float Property pValue  Auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	pFoodQuest.SetRestoreMagickaValue(pValue)
	
EndEvent
