Scriptname _REAL_Nutrition_QuestScript extends Quest  
{This quest script is used to manage the hunger mechanic of the _REAL_Nutrition mod.}


float hunger ;the current hunger state
float lastUpdateTime ;game time of the last update to hunger
float nutrition ;Amount of applied nutrition in days on a scale of 0 to 1 at the time of the last update (when the player eats).

float modVersion ;Last run version of the mod which is checked to restart when an updated version is run

Event OnInit()
	
	modVersion = pModVersion
	
	if (enabled)
		; Enable with notification
		Enable(true)
	else
		; Silently disable
		Disable(false)
	endIf
	
endEvent


Event OnUpdateGameTime()
	
	; Silently disable if enabled status is no longer true
	if (!enabled)
		Disable(false)
		return
	endIf

	if (modVersion != pModVersion)
		modVersion = pModVersion
		Disable(false)
		Enable(true)
		return
	endIf

	; Update nutrition if at least an hour has passed and the player is not sleeping
	float currentGameTime =  Utility.GetCurrentGameTime()
	
	if (lastUpdateTime == 0)
		lastUpdateTime = currentGameTime
	else
		float elapsedTime = currentGameTime - lastUpdateTime
		
		; Only Update if the elapsed time is at least 1 hour in game time
		; Do not update when the player is sleeping. A single update will occur when the player wakes.
		if (elapsedTime * 24 >= 1 && Game.GetPlayer().GetSleepState() == 0)
			float nutritionLoss =  nutritionLossPerDay * elapsedTime
			if (debugEnabled)
				Debug.Notification("Elapsed time " + elapsedTime)
				Debug.Notification("Nutrition loss " + nutritionLoss)
			endIf

			SetNutrition(nutrition - nutritionLoss)

		endIf
	endIf

endEvent


Function SetEnabled(bool val)

	; Check if the value will change
	bool changed = false
	if (enabled != val)
		changed = true
	endIf
	
	; Set to the given value
	enabled = val
	
	; Enable or disable the mod if value was actually changed
	if (changed) 
		if (enabled)
			Enable(true)
		else
			Disable(true)
		endIf
	endIf
	
endFunction


Function Enable(bool notify)
	
	if (notify)
		Debug.Notification("The Belly Rules the Mind")
	endIf
	
	; Reset the quest to ensure it is not left in a quest state from a previous version
	Start()
	SetCurrentStageID(0)
	
	lastUpdateTime = Utility.GetCurrentGameTime()
	nutrition = nutritionInitValue
	
	if (debugEnabled)
		Debug.Notification("Initialized time " + lastUpdateTime)
		Debug.Notification("Initialized nutrition " + nutrition)
	endIf

	; Initialize hunger based on initial nutrition
	UpdateHunger()

	; Register to update every in-game hour
	RegisterForUpdateGameTime(1.0)

endFunction


Function Disable(bool notify)

	if (notify)
		Debug.Notification("You will never hunger")
	endIf

	; Stop updating when the game time changes
	UnregisterForUpdateGameTime()

	;Stop quest in case it has been started from a previous version of the mod
	if (isRunning())
		if (notify)
			Debug.Notification("Stopping The Belly Rules the Mind")
		endIf
		Stop()
	endIf

	; Reset nutrition to remove hunger effects
	SetNutrition(nutritionMax)

endFunction


Function AddNutrition(float aValue)
	if (debugEnabled)
		Debug.Notification("Added " + aValue + " Nutrition")
	endIf
	
	float nutritionUsage = nutritionLossPerDay * (Utility.GetCurrentGameTime() - lastUpdateTime)
	float newNutrition = nutrition - nutritionUsage + aValue

	if (newNutrition < minNutritionAfterEating)
		newNutrition = minNutritionAfterEating
	endIf

	; Limit nutrition to the maximum nutrition value
	if (newNutrition >= nutritionMax)
		Debug.Notification("I am completely full.")
		newNutrition = nutritionMax
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
	
	if (debugEnabled)
		Debug.Notification("Updated nutrition is " + nutrition )
	endIf

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
			Player.RemoveSpell(_AbNutritionDetriment)
			Player.RemoveSpell(_AbNutritionDetrimentMajor)
			Player.RemoveSpell(_AbNutritionDetrimentSevere)
			Debug.Notification("My hunger is sated.")
		elseIf (hunger == 1)
			;Set warning state
			Player.RemoveSpell(_AbNutritionDetriment)
			Player.RemoveSpell(_AbNutritionDetrimentMajor)
			Player.RemoveSpell(_AbNutritionDetrimentSevere)
			Debug.Notification("I am somewhat hungry.")
		elseIf (hunger == 2)
			Player.RemoveSpell(_AbNutritionDetrimentMajor)
			Player.RemoveSpell(_AbNutritionDetrimentSevere)
			Player.AddSpell(_AbNutritionDetriment, false)
			Debug.Notification("I really need to eat.")
		elseif (hunger == 3)
			Player.RemoveSpell(_AbNutritionDetriment)
			Player.RemoveSpell(_AbNutritionDetrimentSevere)
			Player.AddSpell(_AbNutritionDetrimentMajor, false)
			Debug.Notification("I feel so weak. I must eat soon.")
		elseif (hunger == 4)
			Player.RemoveSpell(_AbNutritionDetriment)
			Player.RemoveSpell(_AbNutritionDetrimentMajor)
			Player.AddSpell(_AbNutritionDetrimentSevere, false)
			Debug.Notification("I cannot go on like this. I must eat.")
		endIf

	endIf

endFunction


;PROPERTIES

Bool Property enabled Auto
Bool Property debugEnabled Auto

SPELL Property _AbNutritionDetriment Auto
SPELL Property _AbNutritionDetrimentMajor  Auto
SPELL Property _AbNutritionDetrimentSevere  Auto

Float Property pModVersion Auto

Float Property nutritionInitValue Auto
Float Property nutritionWarnValue Auto
Float Property nutritionDetrimentValue Auto
Float Property nutritionDetrimentMajorValue  Auto
Float Property nutritionDetrimentSevereValue  Auto
Float Property nutritionLossPerDay  Auto
Float Property nutritionMax  Auto
Float Property minNutritionAfterEating  Auto   

