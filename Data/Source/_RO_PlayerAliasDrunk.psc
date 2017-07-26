Scriptname _RO_PlayerAliasDrunk extends ReferenceAlias  

Int Property pScriptVersion Auto
SPELL Property _RO_DrunkAbility  Auto  
FormList Property AlcoholicDrinksList  Auto  

Int scriptVersion = 0

Event OnInit()
	UpdateScript()
endEvent

Event OnPlayerLoadGame()
	if scriptVersion != pScriptVersion
		UpdateScript()
	endIf
endEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	GetActorRef().AddSpell(_RO_DrunkAbility, true)
endEvent


Function updateScript()
	scriptVersion = pScriptVersion
	AddInventoryEventFilter(AlcoholicDrinksList)
endFunction