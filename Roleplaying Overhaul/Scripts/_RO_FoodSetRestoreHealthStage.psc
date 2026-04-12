Scriptname _RO_FoodSetRestoreHealthStage extends activemagiceffect  

_RO_FoodQuest Property pFoodQuest  Auto  
Float Property pValue  Auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	pFoodQuest.SetRestoreHealthValue(pValue)
	
EndEvent
