Scriptname _RO_SettingsEffectScript extends activemagiceffect  

Message Property _RO_SettingsMessage  Auto  


Event OnEffectStart(Actor akTarget, Actor akCaster)
	int iButton = _RO_SettingsMessage.show()

	if iButton == 0
		
	endIf

endEvent