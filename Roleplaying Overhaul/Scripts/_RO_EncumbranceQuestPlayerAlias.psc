Scriptname _RO_EncumbranceQuestPlayerAlias extends ReferenceAlias  

GlobalVariable Property _RO_Enabled  Auto
GlobalVariable Property _RO_Debug  Auto
GlobalVariable Property _RO_EncumbranceEnabled  Auto

SPELL Property _RO_EncumbranceStage1 Auto
SPELL Property _RO_EncumbranceStage2 Auto
SPELL Property _RO_EncumbranceStage3 Auto

Float Property pEncumbrance1  Auto
Float Property pEncumbrance2  Auto
Float Property pEncumbrance3  Auto

Int version = 0

; INITIALIZATION ------------------------------------------------------------------------------------------

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

	Actor player = Game.GetPlayer()
	if (_RO_Enabled.GetValue() as Bool) && (_RO_EncumbranceEnabled.GetValue() as Bool)
		ForceRefTo(player)
		RegisterForSingleUpdate(0.5)
		DebugScript("Gradual Encumbrance Enabled")
	else
		Clear()
		UnregisterForUpdate()
		player.RemoveSpell(_RO_EncumbranceStage1)
		player.RemoveSpell(_RO_EncumbranceStage2)
		player.RemoveSpell(_RO_EncumbranceStage3)
		DebugScript("Gradual Encumbrance Disabled")
	endIf
endFunction

; EVENTS ------------------------------------------------------------------------------------------

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	RegisterForSingleUpdate(0.5)
endEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	RegisterForSingleUpdate(0.5)
endEvent

Event OnUpdate()
	UpdateEncumbrance()
endEvent

; FUNCTIONS ------------------------------------------------------------------------------------------

Function UpdateEncumbrance()
	
	Actor player = GetActorRef()
	
	; Get % of Carry Weight ignoring worn armor weight. Armor already has a movement penalty.
	Float inventoryWeight = player.GetActorValue("InventoryWeight")
	Float carryWeight = player.GetActorValue("CarryWeight")
	
	Float carryWeightPercent =  inventoryWeight / carryWeight
	
	DebugScript("Carry: " + carryWeight + " Inventory: " + inventoryWeight)
	
	player.RemoveSpell(_RO_EncumbranceStage1)
	player.RemoveSpell(_RO_EncumbranceStage2)
	player.RemoveSpell(_RO_EncumbranceStage3)
	
	if carryWeightPercent < pEncumbrance1 || player.IsOverEncumbered()
		; No encumbrance penalty
	elseIf carryWeightPercent >= pEncumbrance3
		; Encumbrance stage 3
		player.AddSpell(_RO_EncumbranceStage3, false)
	elseIf carryWeightPercent > pEncumbrance2
		;Encumbrance stage 2
		player.AddSpell(_RO_EncumbranceStage2, false)
	else
		;Encumbrance stage 1
		player.AddSpell(_RO_EncumbranceStage1, false)
	endIf
	
endFunction

Function DebugScript(String akMessage)
	if _RO_Debug.GetValue() as Bool
		Debug.Trace(akMessage)
		Debug.Notification(akMessage)
	endIf
endFunction