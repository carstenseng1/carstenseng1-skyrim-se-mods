Scriptname _RO_PlayerAliasArrowWeight extends ReferenceAlias  

Int Property pScriptVersion Auto
FormList Property _RO_ArrowList Auto
MiscObject Property _RO_ArrowWeight Auto

Int scriptVersion = 0

Event OnInit()
	InitScript()
endEvent

; Event is only sent to the player actor. This would probably be on a magic effect or alias script
Event OnPlayerLoadGame()
	if scriptVersion != pScriptVersion
		InitScript()
	endIf
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


Function InitScript()
	scriptVersion = pScriptVersion
	AddInventoryEventFilter(_RO_ArrowList)
	RegisterForSingleUpdate(0)
endFunction