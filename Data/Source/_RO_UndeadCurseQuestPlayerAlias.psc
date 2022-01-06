Scriptname _RO_UndeadCurseQuestPlayerAlias extends ReferenceAlias  
{Player Alias script to manage Undead Curse}


GlobalVariable Property _RO_Version  Auto
Int version = 0

GlobalVariable Property _RO_Debug  Auto

FormList  Property _RO_UndeadCurseItems  Auto
FormList  Property _RO_UndeadCurseItemLists  Auto
FormList Property _RO_UndeadCurseContainers  Auto
SPELL Property _RO_UndeadCurse Auto


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
	
	_RO_Note("Undead Curse Maintenance")
	
	RemoveAllInventoryEventFilters()
	AddInventoryEventFilter(_RO_UndeadCurseItems)
	
	Int iIndex = _RO_UndeadCurseItemLists.GetSize() ; Indices are offset by 1 relative to size
	While iIndex
		iIndex -= 1
		FormList kList = _RO_UndeadCurseItemLists.GetAt(iIndex) As FormList ; Note that you must typecast the entry from the formlist using 'As'.
		AddInventoryEventFilter(kList)
	EndWhile

endFunction


Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)

	if _RO_UndeadCurseContainers.Find(akSourceContainer.GetBaseObject()) != -1
		_RO_Note("Player collected cursed item")
		Actor player = GetActorReference()
		player.AddSpell(_RO_UndeadCurse, false)
	endIf

endEvent


Function _RO_Note(String text)

	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf

endFunction