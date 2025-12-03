Scriptname _RO_DrunkQuestPlayerAlias extends ReferenceAlias  
{Player Alias script to manage drunk effect}

GlobalVariable Property _RO_Enabled  Auto
GlobalVariable Property _RO_Debug  Auto
GlobalVariable Property _RO_DrunkEnabled  Auto

SPELL Property _RO_DrunkAbility  Auto  
FormList Property AlcoholicDrinksList  Auto  

Int version = 0

Event OnInit()
	Maintenance()
endEvent

Event OnPlayerLoadGame()
	if version == 0 || version != 1
		Maintenance()
	endIf
endEvent

Function Maintenance()
	version = 1

	; Clear all inventory event filters to set as needed for script version
	RemoveAllInventoryEventFilters()

	Actor player = Game.GetPlayer()

	if (_RO_Enabled.GetValue() as Bool) && (_RO_DrunkEnabled.GetValue() as Bool)
		; Set reference
		ForceRefTo(player)

		; Add inventory event filter to only receive for alcoholic drinks
		AddInventoryEventFilter(AlcoholicDrinksList)

		DebugScript("Drunk effect enabled")
	else
		; Clear reference
		Clear()

		; Remove drunk effect
		player.RemoveSpell(_RO_DrunkAbility)

		DebugScript("Drunk effect disabled")
	endIf
endFunction

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	if AlcoholicDrinksList.Find(akBaseObject) != -1
		GetActorRef().AddSpell(_RO_DrunkAbility, false)
	endIf
endEvent

Function DebugScript(String akMessage)
	if _RO_Debug.GetValue() as Bool
		Debug.Trace(akMessage)
		Debug.Notification(akMessage)
	endIf
endFunction