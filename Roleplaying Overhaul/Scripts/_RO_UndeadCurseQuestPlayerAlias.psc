Scriptname _RO_UndeadCurseQuestPlayerAlias extends ReferenceAlias  
{Player Alias script to manage Undead Curse}


Int Property pVersion  Auto
Int version = 0

FormList  Property _RO_UndeadCurseItems  Auto
FormList  Property _RO_UndeadCurseItemLists  Auto
FormList Property _RO_UndeadCurseContainers  Auto
SPELL Property _RO_UndeadCurse Auto


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
	
	RemoveAllInventoryEventFilters()
	AddInventoryEventFilter(_RO_UndeadCurseItems)
	
	Int iIndex = _RO_UndeadCurseItemLists.GetSize() ; Indices are offset by 1 relative to size
	While iIndex
		iIndex -= 1
		; Note that you must typecast the entry from the formlist using 'As'.
		FormList kList = _RO_UndeadCurseItemLists.GetAt(iIndex) As FormList
		AddInventoryEventFilter(kList)
	EndWhile

endFunction


Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)

	if _RO_UndeadCurseContainers.Find(akSourceContainer.GetBaseObject()) != -1
		Actor player = GetActorReference()
		player.AddSpell(_RO_UndeadCurse, false)
	endIf

endEvent
