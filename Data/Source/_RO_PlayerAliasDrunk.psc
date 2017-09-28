Scriptname _RO_PlayerAliasDrunk extends ReferenceAlias  

GlobalVariable Property _RO_Version Auto
GlobalVariable Property _RO_Debug Auto
SPELL Property _RO_DrunkAbility  Auto  
FormList Property AlcoholicDrinksList  Auto  

Float version = 0.0

Event OnInit()
	UpdateScript()
endEvent

Event OnPlayerLoadGame()
	UpdateScript()
endEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	if AlcoholicDrinksList.Find(akBaseObject) != -1
		GetActorRef().AddSpell(_RO_DrunkAbility, _RO_Debug.GetValue())
	endIf
endEvent


Function updateScript()
	if version == _RO_Version.GetValue()
		return
	endIf
	
	version = _RO_Version.GetValue()
	RO_DebugNotification("Drunk Script: v" + version)
	
	RemoveAllInventoryEventFilters()
	AddInventoryEventFilter(AlcoholicDrinksList)
endFunction

Function RO_DebugNotification(String text)
	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf
endFunction