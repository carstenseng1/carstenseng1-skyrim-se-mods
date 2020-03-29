Scriptname _RO_SettingsEffectScript extends activemagiceffect  

GlobalVariable Property _RO_Debug  Auto
Message Property _RO_SettingsMessage  Auto  
Message Property _RO_SettingsCarryWeightMessage  Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	ShowRootMenu()

endEvent


Function ShowRootMenu()

	int iButton = _RO_SettingsMessage.show()

	if iButton == 0
		; toggle debugging
		if _RO_Debug.GetValue() == 1
			_RO_Debug.SetValue(0)
			Debug.Notification("Debugging disabled")
		else
			_RO_Debug.SetValue(1)
			Debug.Notification("Debugging enabled")
		endIf
	elseIf iButton == 1
		ShowCarryWeightMenu()
	endIf

endFunction


Function ShowCarryWeightMenu()

	int iButton = _RO_SettingsCarryWeightMessage.show()
	Actor player = Game.GetPlayer()

	if iButton > 6
		ShowRootMenu()
		return
	endIf
	
	if iButton == 0
		player.ModAV("CarryWeight", -50)
	elseIf iButton == 1
		player.ModAV("CarryWeight", -10)
	elseIf iButton == 2
		player.ModAV("CarryWeight", -5)
	elseIf iButton == 3
		player.ModAV("CarryWeight", 5)
	elseIf iButton == 4
		player.ModAV("CarryWeight", 10)
	elseIf iButton == 5
		player.ModAV("CarryWeight", 50)
	elseIf iButton == 6
		; Reset to base
		player.ForceAV("CarryWeight", player.GetBaseAV("CarryWeight"))
	endIf
	
	_RO_Note("Carray Weight: " + player.GetAV("CarryWeight") + "  Base: " + player.GetBaseAV("CarryWeight"))
	ShowCarryWeightMenu()

endFunction


Function _RO_Note(String text)
	
	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf
	
endFunction