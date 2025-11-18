Scriptname _RO_EncumbranceQuestPlayerAlias extends ReferenceAlias  


SPELL Property _RO_EncumbranceStage1 Auto
SPELL Property _RO_EncumbranceStage2 Auto
SPELL Property _RO_EncumbranceStage3 Auto

Float Property pEncumbrance1  Auto
Float Property pEncumbrance2  Auto
Float Property pEncumbrance3  Auto

Float armorWeight = -1.0

Event OnInit()
	Maintenance()
endEvent


Event OnPlayerLoadGame()
	Maintenance()
endEvent


Function Maintenance()
	armorWeight = -1.0
	RegisterForSingleUpdate(0.5)
endFunction


Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	
	RegisterForSingleUpdate(0.5)
	;UpdateEncumbrance()
	
endEvent


Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	
	RegisterForSingleUpdate(0.5)
	;UpdateEncumbrance()
	
endEvent


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)

	armorWeight = -1.0
	
	RegisterForSingleUpdate(0.5)
	;UpdateEncumbrance()

endEvent


Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	
	armorWeight = -1.0
	
	RegisterForSingleUpdate(0.5)
	;UpdateEncumbrance()

endEvent


Event OnUpdate()

	UpdateEncumbrance()

endEvent


Function UpdateEncumbrance()
	
	Actor player = GetActorRef()
	
	; Get % of Carry Weight ignoring worn armor weight. Armor already has a movement penalty.
	Float inventoryWeight = player.GetActorValue("InventoryWeight")
	Float carryWeight = player.GetActorValue("CarryWeight")

	if armorWeight == -1.0
		
		armorWeight = 0.0
		
		Form head = player.GetWornForm(0x00000001)
		if head
			armorWeight += head.GetWeight()
		endIf

		Form body = player.GetWornForm(0x00000004)
		if body
			armorWeight += body .GetWeight()
		endIf

		Form feet = player.GetWornForm(0x00000080)
		if feet
			armorWeight += feet .GetWeight()
		endIf

		Form hands = player.GetWornForm(0x00000008)
		if hands
			armorWeight += hands .GetWeight()
		endIf
	endIf
	
	Float carryWeightPercent =  (inventoryWeight - armorWeight) / carryWeight
	
	;Debug.Notification("Carry: " + carryWeight + " Inventory: " + inventoryWeight + " Armor: " + armorWeight)
	
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
