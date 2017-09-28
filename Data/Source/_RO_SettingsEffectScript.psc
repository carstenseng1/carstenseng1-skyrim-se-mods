Scriptname _RO_SettingsEffectScript extends activemagiceffect  

GlobalVariable Property _RO_Debug  Auto
Message Property _RO_SettingsMessage  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
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
	endIf

endEvent

