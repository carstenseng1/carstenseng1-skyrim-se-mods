Scriptname _RO_PlayerAliasNutrition extends ReferenceAlias  


GlobalVariable Property _RO_Version  Auto
Float version = 0.0

GlobalVariable Property _RO_Debug  Auto

FormList Property _RO_FoodList Auto
FormList Property _RO_FoodListSmall Auto
FormList Property _RO_FoodListLarge Auto
FormList Property _RO_FoodListExtraLarge Auto
FormList Property _RO_FoodListDrink Auto
Float[] Property NutritionValue Auto

SPELL Property _RO_AbNutritionDetriment Auto
SPELL Property _RO_AbNutritionDetrimentMinor  Auto
SPELL Property _RO_AbNutritionDetrimentMajor  Auto
SPELL Property _RO_AbNutritionDetrimentSevere  Auto

Float Property nutritionInitValue Auto
Float Property nutritionWarnValue Auto
Float Property nutritionDetrimentValue Auto
Float Property nutritionDetrimentMajorValue  Auto
Float Property nutritionDetrimentSevereValue  Auto
Float Property nutritionLossPerDay  Auto
Float Property nutritionMax  Auto
Float Property minNutritionAfterEating  Auto

bool hasInitialized = false
float hunger ;the current hunger state
float lastUpdateTime ;game time of the last update to hunger
float nutrition ;Amount of applied nutrition in days on a scale of 0 to 1 at the time of the last update (when the player eats).


Event OnInit()
	Maintenance()
endEvent


Event OnPlayerLoadGame()
	Maintenance()
endEvent


Function Maintenance()
	
	if version != 0.0 && version == _RO_Version.GetValue()
		return
	endIf
	version = _RO_Version.GetValue()
	
	_RO_Note("Nutrition Maintenance")
	
	RemoveAllInventoryEventFilters()
	AddInventoryEventFilter(_RO_FoodList)
	
	if hasInitialized == true
		SetNutrition(nutrition)
	else
		hasInitialized = true
		SetNutrition(nutritionInitValue)
	endIf

endFunction


Event OnUpdateGameTime()

    ModNutrition(-GetNutritionUsage())

endEvent


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)

	int nutritionValueIndex = -1
	
	; Debug.Notification("Equipped " + akBaseObject)
	if  _RO_FoodListExtraLarge.Find(akBaseObject) >= 0
		_RO_Note("Food Consumed: Extra Large")
		nutritionValueIndex = 4
	elseIf  _RO_FoodListLarge.Find(akBaseObject) >= 0
		_RO_Note("Food Consumed: Large")
		nutritionValueIndex = 3
	elseIf  _RO_FoodList.Find(akBaseObject) >= 0
		_RO_Note("Food Consumed: Small")
		nutritionValueIndex = 2
	elseIf _RO_FoodListSmall.Find(akBaseObject) >= 0
		_RO_Note("Food Consumed: Standard")
		nutritionValueIndex = 1
	elseIf  _RO_FoodListDrink.Find(akBaseObject) >= 0
		_RO_Note("Food Consumed: Drink")
		nutritionValueIndex = 0
	endIf
	
	if nutritionValueIndex >= 0
		; Get the nutrition value change based on the food size
		float nutritionChange = NutritionValue[nutritionValueIndex]
		
		; Reduce value change by nutrition used
		nutritionChange = nutritionChange - GetNutritionUsage()
		
		; Make the adjustment
		ModNutrition(nutritionChange, true)
		
		; Notify player when full
		if nutrition >= nutritionMax
			Debug.Notification("You are completely full.")
		endIf
	endIf

endEvent


float Function GetNutritionUsage()

	float nutritionUsage = nutritionLossPerDay * (Utility.GetCurrentGameTime() -  lastUpdateTime)
	return nutritionUsage

endFunction


Function ModNutrition(float aValue, bool isEating = false)
	
	_RO_Note("Added " + aValue + " Nutrition")
	
	float newNutrition = nutrition + aValue

	; Apply lower limit if this modification to nutrition is from eating
	if (isEating && newNutrition < minNutritionAfterEating)
		newNutrition = minNutritionAfterEating
	endIf
	
	SetNutrition(newNutrition)

endFunction


Function SetNutrition(float aValue)

	; Limit value to min and max
	if (aValue< 0)
		aValue= 0
	elseIf (aValue> nutritionMax)
		aValue= nutritionMax
	endIf

	; Set nutrition and keep track of the time that this update occurred
	nutrition = aValue
	lastUpdateTime = Utility.GetCurrentGameTime()
	
	; Register to be notified every in-game hour
	UnregisterForUpdateGameTime()
	RegisterForUpdateGameTime(1.0)
	
	_RO_Note("Updated nutrition is " + nutrition )

	; Update hunger status with the current nutrition
	UpdateHunger()

endFunction


Function UpdateHunger()

	if (nutrition <= nutritionDetrimentSevereValue)
		SetHunger(4)
	elseIf (nutrition <= nutritionDetrimentMajorValue)
		SetHunger(3)
	elseIf (nutrition <= nutritionDetrimentValue)
		SetHunger(2)
	elseIf (nutrition <= nutritionWarnValue)
		SetHunger(1)
	else
		SetHunger(0)
	endIf

endFunction


Function SetHunger(int aiValue)

	if (hunger != aiValue)

		hunger = aiValue

		Actor Player = Game.GetPlayer()

		if (hunger == 0)
			Player.RemoveSpell(_RO_AbNutritionDetrimentMinor)
			Player.RemoveSpell(_RO_AbNutritionDetriment)
			Player.RemoveSpell(_RO_AbNutritionDetrimentMajor)
			Player.RemoveSpell(_RO_AbNutritionDetrimentSevere)
			Debug.Notification("Your hunger is sated.")
		elseIf (hunger == 1)
			;Set warning state
			Player.RemoveSpell(_RO_AbNutritionDetriment)
			Player.RemoveSpell(_RO_AbNutritionDetrimentMajor)
			Player.RemoveSpell(_RO_AbNutritionDetrimentSevere)
			Debug.Notification("You are somewhat hungry.")
		elseIf (hunger == 2)
			Player.RemoveSpell(_RO_AbNutritionDetrimentMinor)
			Player.RemoveSpell(_RO_AbNutritionDetrimentMajor)
			Player.RemoveSpell(_RO_AbNutritionDetrimentSevere)
			Player.AddSpell(_RO_AbNutritionDetriment, false)
			Debug.Notification("You are hungry.")
		elseif (hunger == 3)
			Player.RemoveSpell(_RO_AbNutritionDetrimentMinor)
			Player.RemoveSpell(_RO_AbNutritionDetriment)
			Player.RemoveSpell(_RO_AbNutritionDetrimentSevere)
			Player.AddSpell(_RO_AbNutritionDetrimentMajor, false)
			Debug.Notification("You are extremely hungry.")
		elseif (hunger == 4)
			Player.RemoveSpell(_RO_AbNutritionDetrimentMinor)
			Player.RemoveSpell(_RO_AbNutritionDetriment)
			Player.RemoveSpell(_RO_AbNutritionDetrimentMajor)
			Player.AddSpell(_RO_AbNutritionDetrimentSevere, false)
			Debug.Notification("You are starving.")
		endIf

	endIf

endFunction

Function _RO_Note(String text)

	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf

endFunction
