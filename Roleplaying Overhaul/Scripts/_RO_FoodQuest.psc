Scriptname _RO_FoodQuest extends Quest  

SPELL Property _RO_AbFoodRestoreHealthStage1  Auto  
SPELL Property _RO_AbFoodRestoreHealthStage2  Auto  
SPELL Property _RO_AbFoodRestoreHealthStage3  Auto  
SPELL Property _RO_AbFoodRestoreHealthStage4  Auto 

SPELL Property _RO_AbFoodRestoreMagickaStage1  Auto  
SPELL Property _RO_AbFoodRestoreMagickaStage2  Auto  
SPELL Property _RO_AbFoodRestoreMagickaStage3  Auto  
SPELL Property _RO_AbFoodRestoreMagickaStage4  Auto  

SPELL Property _RO_AbFoodRestoreStaminaStage1  Auto  
SPELL Property _RO_AbFoodRestoreStaminaStage2  Auto  
SPELL Property _RO_AbFoodRestoreStaminaStage3  Auto  
SPELL Property _RO_AbFoodRestoreStaminaStage4  Auto  

GlobalVariable Property _RO_FoodHealthValue  Auto  
GlobalVariable Property _RO_FoodMagickaValue  Auto  
GlobalVariable Property _RO_FoodStaminaValue  Auto  

Int Property pStageDurationHours Auto

Float fLastUpdateGameTime = 0.0


Event OnUpdate()

	; Set the current restore values based on change in time
	DepleteRestoreValues()
	
	; Set the current abilities based on the current values
	UpdateRestoreStages()
	
	; Restart timer
	RegisterForSingleUpdate(10.0)
	
EndEvent


Function DepleteRestoreValues()
	
	; Initialize last update time if necessary
	If fLastUpdateGameTime == 0
		fLastUpdateGameTime = Utility.GetCurrentGameTime()
	EndIf
	
	; Get the change in time since last update
	; Cancel operation if no time elapsed
	Float fTimeHoursDelta = (Utility.GetCurrentGameTime() - fLastUpdateGameTime) * 24.0
	If fTimeHoursDelta == 0
		return
	EndIf
	
	; Decrease the current restore values by change in hours
	Float fMod = - (fTimeHoursDelta / pStageDurationHours)
	
	; Health
	_RO_FoodHealthValue.Mod(fMod)
	ClampRestoreValue(_RO_FoodHealthValue)
	
	
	; Magicka
	_RO_FoodMagickaValue.Mod(fMod)
	ClampRestoreValue(_RO_FoodMagickaValue)
	
	; Stamina
	_RO_FoodStaminaValue.Mod(fMod)
	ClampRestoreValue(_RO_FoodStaminaValue)
	
	; Track the update time to calculate change in next update
	fLastUpdateGameTime = Utility.GetCurrentGameTime()

EndFunction


Function ClampRestoreValue(GlobalVariable pGlobal)
	
	if pGlobal.GetValue() < 0.0
		pGlobal.SetValue(0.0)
	ElseIf pGlobal.GetValue() > 4.0
		pGlobal.SetValue(4.0)
	EndIf

EndFunction


Function SetRestoreValue(Float aValue, GlobalVariable pGlobal)
	
	; Update all restore values based on change in time
	DepleteRestoreValues()
	
	; Increase only
	If aValue > pGlobal.GetValue()
		; Set the GlobalVariable value
		pGlobal.SetValue(aValue)
	EndIf
	
	; Update restore stages now that values are set
	UpdateRestoreStages()
	
	; Stop the current pending update
	UnregisterForUpdate()
	
	; Restart timer
	RegisterForSingleUpdate(10.0)
	
EndFunction


Function SetRestoreHealthValue(Float aValue)
	
	SetRestoreValue(aValue, _RO_FoodHealthValue)
	
EndFunction


Function SetRestoreMagickaValue(Float aValue)
	
	SetRestoreValue(aValue, _RO_FoodMagickaValue)
	
EndFunction


Function SetRestoreStaminaValue(Float aValue)
	
	SetRestoreValue(aValue, _RO_FoodStaminaValue)
	
EndFunction


Function UpdateRestoreStages()
	
	;Debug.Notification("Updating food stages")
	;Debug.Notification("Health " + _RO_FoodHealthValue.GetValue())
	;Debug.Notification("Magicka " + _RO_FoodMagickaValue.GetValue())
	;Debug.Notification("Stamina " + _RO_FoodStaminaValue.GetValue())
	
	; Health
	UpdateRestoreStage(\
			_RO_FoodHealthValue.GetValue(),\
			_RO_AbFoodRestoreHealthStage1,\
			_RO_AbFoodRestoreHealthStage2,\
			_RO_AbFoodRestoreHealthStage3,\
			_RO_AbFoodRestoreHealthStage4\
		)
	
	; Magicka
	UpdateRestoreStage(\
			_RO_FoodMagickaValue.GetValue(),\
			_RO_AbFoodRestoreMagickaStage1,\
			_RO_AbFoodRestoreMagickaStage2,\
			_RO_AbFoodRestoreMagickaStage3,\
			_RO_AbFoodRestoreMagickaStage4\
		)
	
	; Stamina
	UpdateRestoreStage(\
			_RO_FoodStaminaValue.GetValue(),\
			_RO_AbFoodRestoreStaminaStage1,\
			_RO_AbFoodRestoreStaminaStage2,\
			_RO_AbFoodRestoreStaminaStage3,\
			_RO_AbFoodRestoreStaminaStage4\
		)

EndFunction


Function UpdateRestoreStage(Float aValue, SPELL pStage1, SPELL pStage2, SPELL pStage3, SPELL pStage4)
	
	; Remove all restoration abilities for ActorValue to clean up
	Game.GetPlayer().RemoveSpell(pStage1)
	Game.GetPlayer().RemoveSpell(pStage2)
	Game.GetPlayer().RemoveSpell(pStage3)
	Game.GetPlayer().RemoveSpell(pStage4)
	
	Utility.WaitMenuMode(0.1)
	
	; Add the food restoration for the stage corresponding to value
	If aValue > 3.0
		Game.GetPlayer().AddSpell(pStage4, false)
	ElseIf aValue > 2.0
		Game.GetPlayer().AddSpell(pStage3, false)
	ElseIf aValue > 1.0
		Game.GetPlayer().AddSpell(pStage2, false)
	ElseIf aValue > 0.0
		Game.GetPlayer().AddSpell(pStage1, false)
	EndIf
	
EndFunction