Scriptname _RO_PlayerAliasArrowWeight extends ReferenceAlias  

GlobalVariable Property _RO_Version Auto
GlobalVariable Property _RO_Debug Auto
FormList Property _RO_ArrowList Auto
MiscObject Property _RO_ArrowWeight Auto

Float scriptVersion = 0.0

Event OnInit()
	UpdateScript()
endEvent

; Event is only sent to the player actor. This would probably be on a magic effect or alias script
Event OnPlayerLoadGame()
	UpdateScript()
endEvent

Event OnUpdate()
	; Remove all current arrow weights
	GetActorRef().RemoveItem(_RO_ArrowWeight, GetActorRef().GetItemCount(_RO_ArrowWeight), true)
	
	; Add weights based on the number of arrows
	GetActorRef().AddItem(_RO_ArrowWeight, GetActorRef().GetItemCount(_RO_ArrowList), true)
endEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	GetActorRef().AddItem(_RO_ArrowWeight, aiItemCount, true)
	RegisterForSingleUpdate(0)
endEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	GetActorRef().RemoveItem(_RO_ArrowWeight, aiItemCount, true)
	RegisterForSingleUpdate(0)
endEvent


Function UpdateScript()
	if scriptVersion != 0 && scriptVersion == _RO_Version.GetValue()
		return
	endIf

	scriptVersion = _RO_Version.GetValue()
	_RO_DebugNotification("Arrow Weight v" + scriptVersion)
	
	RemoveAllInventoryEventFilters()
	AddInventoryEventFilter(_RO_ArrowList)
	RegisterForSingleUpdate(0)
endFunction

Function _RO_DebugNotification(String text)
	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf
endFunction
