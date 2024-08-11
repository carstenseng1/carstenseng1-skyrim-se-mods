Scriptname _REAL_Nutrition_PlayerScript extends ReferenceAlias  


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)

	Potion akPotion = akBaseObject as Potion
	if akPotion
		
		;Debug.trace("No skse")
		
		; Debug.Notification("Equipped " + akBaseObject)
		if FoodExtraLargeArray.Find(akPotion) >= 0
			;Debug.Notification("Extra Large")
			_REAL_Nutrition_Quest.AddNutrition(NutritionValueExtraLarge)
		elseIf FoodLargeArray.Find(akPotion) >= 0
			;Debug.Notification("Large")
			_REAL_Nutrition_Quest.AddNutrition(NutritionValueLarge)
		elseIf FoodMediumArray.Find(akPotion) >= 0
			;Debug.Notification("Medium")
			_REAL_Nutrition_Quest.AddNutrition(NutritionValueMedium)
		elseIf FoodSmallArray.Find(akPotion) >= 0
			;Debug.Notification("Small")
			_REAL_Nutrition_Quest.AddNutrition(NutritionValueSmall)
		elseIf DrinkArray.Find(akPotion) >= 0
			;Debug.Notification("Drink")
			_REAL_Nutrition_Quest.AddNutrition(NutritionValueDrink)
		endIf
		
	endIf
endEvent


Potion[] Property FoodSmallArray Auto
Potion[] Property FoodMediumArray Auto
Potion[] Property FoodLargeArray Auto
Potion[] Property FoodExtraLargeArray Auto
Float Property NutritionValueDrink Auto
Float Property NutritionValueSmall Auto
Float Property NutritionValueMedium Auto
Float Property NutritionValueLarge Auto
Float Property NutritionValueExtraLarge Auto
 _REAL_Nutrition_QuestScript Property _REAL_Nutrition_Quest Auto

Potion[] Property DrinkArray  Auto  
