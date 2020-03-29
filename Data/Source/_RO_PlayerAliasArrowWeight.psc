Scriptname _RO_PlayerAliasArrowWeight extends ReferenceAlias  

GlobalVariable Property _RO_Version  Auto
Float version = 0.0

GlobalVariable Property _RO_Debug  Auto

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

	_RO_Note("Arrow Weight Maintenance")
	
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
	
	_RO_Note("Arrow Weight " + GetActorRef().GetItemCount(_RO_ArrowWeight))

endEvent


Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)

	; Inventory event filter should prevent anything but arrows sending this event, but just in case
	if _RO_ArrowList.Find(akBaseItem) == -1
		return
	endIf
	
	; Add weights based on the number of arrows for immediate update
	GetActorRef().AddItem(_RO_ArrowWeight, aiItemCount, true)

	; Register for a full update to correct any mismatch between arrow count and weight
	RegisterForSingleUpdate(1)

endEvent


Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)

	; Inventory event filter should prevent anything but arrows sending this event, but just in case
	if _RO_ArrowList.Find(akBaseItem) == -1
		return
	endIf
	
	; Remove weights based on the number of arrows for immediate update
	GetActorRef().RemoveItem(_RO_ArrowWeight, aiItemCount, true)

	; Register for a full update to correct any mismatch between arrow count and weight
	RegisterForSingleUpdate(1)

endEvent


Function _RO_Note(String text)

	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf

endFunction