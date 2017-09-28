Scriptname _RO_PlayerAliasUndeadCurse extends ReferenceAlias  

GlobalVariable Property _RO_Debug Auto
GlobalVariable Property _RO_Version Auto

FormList  Property _RO_UndeadCurseItems  Auto
FormList  Property _RO_UndeadCurseItemLists  Auto
FormList Property _RO_UndeadCurseContainers  Auto
SPELL Property _RO_UndeadCurse Auto

Float version = 0.0

Event OnInit()
	UpdateScript()
endEvent

Event OnPlayerLoadGame()
	UpdateScript()
endEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	if _RO_UndeadCurseContainers.Find(akSourceContainer.GetBaseObject()) != -1
		_RO_DebugNotification("Player collected cursed item")
		Actor player = GetActorReference()
		player.AddSpell(_RO_UndeadCurse, false)
	endIf
endEvent

Function UpdateScript()
	if version == _RO_Version.GetValue()
		return
	endIf
	
	RemoveAllInventoryEventFilters()
	AddInventoryEventFilter(_RO_UndeadCurseItems)
	
	Int iIndex = _RO_UndeadCurseItemLists.GetSize() ; Indices are offset by 1 relative to size
	While iIndex
		iIndex -= 1
		FormList kList = _RO_UndeadCurseItemLists.GetAt(iIndex) As FormList ; Note that you must typecast the entry from the formlist using 'As'.
		AddInventoryEventFilter(kList)
	EndWhile
	
endFunction

Function _RO_DebugNotification(string text)
	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf
endFunction
