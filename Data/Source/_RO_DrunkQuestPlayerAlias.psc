Scriptname _RO_DrunkQuestPlayerAlias extends ReferenceAlias  
{Player Alias script to manage drunk effect}


GlobalVariable Property _RO_Version  Auto
Int version = 0

GlobalVariable Property _RO_Debug  Auto

SPELL Property _RO_DrunkAbility  Auto  
FormList Property AlcoholicDrinksList  Auto  


Event OnInit()
	Maintenance()
endEvent


Event OnPlayerLoadGame()
	if version == 0 || version != _RO_Version.GetValueInt()
		Maintenance()
	endIf
endEvent


Function Maintenance()
	
	version = _RO_Version.GetValueInt()
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