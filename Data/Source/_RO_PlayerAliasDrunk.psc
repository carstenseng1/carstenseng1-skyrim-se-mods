Scriptname _RO_PlayerAliasDrunk extends ReferenceAlias  

GlobalVariable Property _RO_Version  Auto
Float version = 0.0

GlobalVariable Property _RO_Debug  Auto

SPELL Property _RO_DrunkAbility  Auto  
FormList Property AlcoholicDrinksList  Auto  


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
	
	_RO_Note("Drunk Maintenance")

endFunction


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)

	if AlcoholicDrinksList.Find(akBaseObject) != -1
		_RO_Note("Alcohol consumed")
		GetActorRef().AddSpell(_RO_DrunkAbility, false)
	endIf

endEvent


Function _RO_Note(String text)

	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf

endFunction