Scriptname _RO_PlayerAliasGold extends ReferenceAlias  

Int Property pScriptVersion Auto
MiscObject  Property GoldCursed  Auto
MiscObject Property Gold001  Auto
SPELL Property _RO_UndeadCurse Auto

Int scriptVersion = 0

Event OnInit()
	InitScript()
	RegisterForSleep()
endEvent

Event OnSleepStop(bool abInterrupted)
	if scriptVersion != pScriptVersion
		InitScript()
	endIf
endEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	if akBaseItem == GoldCursed
		Debug.Notification("Player collected Cursed Gold")
		Game.GetPlayer().RemoveItem(akBaseItem, aiItemCount, true)
		Game.GetPlayer().AddItem(Gold001, aiItemCount, true)
		Game.GetPlayer().AddSpell(_RO_UndeadCurse, false)
	endIf
endEvent

Function InitScript()
	scriptVersion = pScriptVersion
	AddInventoryEventFilter(GoldCursed)
endFunction