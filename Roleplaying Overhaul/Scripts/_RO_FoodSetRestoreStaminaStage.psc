Scriptname _RO_FoodSetRestoreStaminaStage extends activemagiceffect  

_RO_FoodQuest Property pFoodQuest  Auto  
Float Property pValue  Auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	pFoodQuest.SetRestoreStaminaValue(pValue)
	
EndEvent


