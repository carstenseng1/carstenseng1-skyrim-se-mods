Scriptname _RO_DrunkQuestPlayerAlias extends ReferenceAlias  
{Player Alias script to manage drunk effect}

GlobalVariable Property _RO_Enabled  Auto
GlobalVariable Property _RO_Debug  Auto
GlobalVariable Property _RO_DrunkEnabled  Auto

SPELL Property _RO_DrunkAbility  Auto  
FormList Property _RO_IntoxicantsList  Auto  

; SCRIPT VERSION ----------------------------------------------------------------------------------

Int version = 0
Int Function GetVersion()
	return 2 ; _RO_IntoxicantsList Updated
endFunction

; INITIALIZATION ----------------------------------------------------------------------------------

Event OnInit()
	if version == 0 || version != GetVersion()
		Maintenance()
	endIf
endEvent

Event OnPlayerLoadGame()
	if version == 0 || version != GetVersion()
		Maintenance()
	endIf
endEvent

Function Maintenance()
	version = GetVersion()

	; Clear all inventory event filters to set as needed for script version
	RemoveAllInventoryEventFilters()

	Actor player = Game.GetPlayer()

	if (_RO_Enabled.GetValue() as Bool) && (_RO_DrunkEnabled.GetValue() as Bool)
		; Set reference
		ForceRefTo(player)

		; Add inventory event filter to only receive for alcoholic drinks
		AddInventoryEventFilter(_RO_IntoxicantsList)

		DebugScript("Drunk effect enabled")
	else
		; Clear reference
		Clear()

		; Remove drunk effect
		player.RemoveSpell(_RO_DrunkAbility)

		DebugScript("Drunk effect disabled")
	endIf
endFunction

; EVENTS ------------------------------------------------------------------------------------------

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	if _RO_IntoxicantsList.Find(akBaseObject) != -1
		GetActorRef().AddSpell(_RO_DrunkAbility, false)
	endIf
endEvent

; UTILITY ------------------------------------------------------------------------------------------

Function DebugScript(String asMessage)
	if _RO_Debug.GetValue() as Bool
		Debug.Trace(asMessage)
		Debug.Notification(asMessage)
	endIf
endFunction