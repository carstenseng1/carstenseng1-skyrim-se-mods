Scriptname _RO_PlayerAliasArrowWeight extends ReferenceAlias  

GlobalVariable Property _RO_Version  Auto
Float version = 0.0

_RO_QuestScript Property _RO_Quest  Auto
FormList Property _RO_ArrowList Auto
MiscObject Property _RO_ArrowWeight Auto


Event OnInit()
	Maintenance()
endEvent


Event OnPlayerLoadGame()
	Maintenance()
endEvent


Function Maintenance()
	
	if version != 0.0 && version == _RO_Version.GetValue()
		return
	endIf
	version = _RO_Version.GetValue()

	_RO_Quest.Notification("Arrow Weight Maintenance")
	
	RemoveAllInventoryEventFilters()
	AddInventoryEventFilter(_RO_ArrowList)
	
	RegisterForSingleUpdate(1)

endFunction


Event OnUpdate()

	; Stop any other pending updates
	UnregisterForUpdate()
	
	; Remove all current arrow weights
	GetActorRef().RemoveItem(_RO_ArrowWeight, GetActorRef().GetItemCount(_RO_ArrowWeight), true)
	
	; Add weights based on the number of arrows
	GetActorRef().AddItem(_RO_ArrowWeight, GetActorRef().GetItemCount(_RO_ArrowList), true)
	
	_RO_Quest.Notification("Arrow Weight " + GetActorRef().GetItemCount(_RO_ArrowWeight))

endEvent


Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)

	RegisterForSingleUpdate(1)

endEvent


Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)

	RegisterForSingleUpdate(1)

endEvent
