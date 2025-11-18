Scriptname _RO_DrunkQuestPlayerAlias extends ReferenceAlias  
{Player Alias script to manage drunk effect}


Int Property pVersion  Auto
Int version = 0

SPELL Property _RO_DrunkAbility  Auto  
FormList Property AlcoholicDrinksList  Auto  


Event OnInit()
	Maintenance()
endEvent


Event OnPlayerLoadGame()
	if version == 0 || version != pVersion
		Maintenance()
	endIf
endEvent


Function Maintenance()
	version = pVersion
	AddInventoryEventFilter(AlcoholicDrinksList)
endFunction


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)

	if AlcoholicDrinksList.Find(akBaseObject) != -1
		GetActorRef().AddSpell(_RO_DrunkAbility, false)
	endIf

endEvent
