Scriptname _RO_UndeadCurseQuestPlayerAlias extends ReferenceAlias  
{Player Alias script to manage Undead Curse}

GlobalVariable Property _RO_Enabled  Auto
GlobalVariable Property _RO_Debug  Auto
GlobalVariable Property _RO_UndeadCurseEnabled  Auto

FormList  Property _RO_UndeadCurseItems  Auto
FormList  Property _RO_UndeadCurseItemLists  Auto
FormList Property _RO_UndeadCurseContainers  Auto
SPELL Property _RO_UndeadCurse Auto

; SCRIPT VERSION ------------------------------------------------------------------------------------------

Int version = 0
Int Function GetVersion()
	return 1
endFunction

; INITIALIZATION ------------------------------------------------------------------------------------------

Event OnInit()
	Maintenance()
endEvent

Event OnPlayerLoadGame()
	if version == 0 || version != GetVersion()
		Maintenance()
	endIf
endEvent

Function Maintenance()
	version = GetVersion()
	
	; Clean up inventory event filters regardless of enable/disable
	RemoveAllInventoryEventFilters()

	Actor player = Game.GetPlayer()

	if (_RO_Enabled.GetValue() as Bool) && (_RO_UndeadCurseEnabled.GetValue() as Bool)
		; Set alias reference to player
		ForceRefTo(player)

		; Add inventory filter for list of individual items
		AddInventoryEventFilter(_RO_UndeadCurseItems)
		
		; Add inventory filters for list of item lists
		Int iIndex = _RO_UndeadCurseItemLists.GetSize() ; Indices are offset by 1 relative to size
		While iIndex
			iIndex -= 1
			; Note that you must typecast the entry from the formlist using 'As'.
			FormList kList = _RO_UndeadCurseItemLists.GetAt(iIndex) As FormList
			AddInventoryEventFilter(kList)
		endWhile

		DebugScript("Undead Curse Enabled")
	else
		; Clear alias reference when disabling feature
		Clear()

		; Remove curse spell
		player.RemoveSpell(_RO_UndeadCurse)

		DebugScript("Undead Curse Disabled")
	endIf
endFunction

; EVENTS ------------------------------------------------------------------------------------------

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	if _RO_UndeadCurseContainers.Find(akSourceContainer.GetBaseObject()) != -1
		Actor player = GetActorReference()
		player.AddSpell(_RO_UndeadCurse, _RO_Debug.GetValue() as Bool)
	endIf
endEvent

; UTILITY ------------------------------------------------------------------------------------------

Function DebugScript(String asMessage)
	if _RO_Debug.GetValue() as Bool
		Debug.Trace(asMessage)
		Debug.Notification(asMessage)
	endIf
endFunction