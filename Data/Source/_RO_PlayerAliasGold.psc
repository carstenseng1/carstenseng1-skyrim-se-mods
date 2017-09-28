Scriptname _RO_PlayerAliasGold extends ReferenceAlias  

GlobalVariable Property _RO_Debug Auto
Int Property pScriptVersion Auto

MiscObject  Property GoldCursed  Auto
MiscObject Property Gold001  Auto
SPELL Property _RO_UndeadCurse Auto

Int scriptVersion = 0

Event OnInit()
	UpdateScript()
endEvent

Event OnPlayerLoadGame()
	UpdateScript()
endEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	if akBaseItem == GoldCursed
		_RO_DebugNotification("Player collected Cursed Gold")
		Game.GetPlayer().RemoveItem(akBaseItem, aiItemCount, true)
		Game.GetPlayer().AddItem(Gold001, aiItemCount, true)
		Game.GetPlayer().AddSpell(_RO_UndeadCurse, false)
	endIf
endEvent

Function UpdateScript()
	if scriptVersion != pScriptVersion
		scriptVersion = pScriptVersion
		AddInventoryEventFilter(GoldCursed)
	endIf
endFunction

Function _RO_DebugNotification(string text)
	if _RO_Debug.GetValue() == 1
		Debug.Notification(text)
	endIf
endFunction