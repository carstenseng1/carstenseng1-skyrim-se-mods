Scriptname _RO_GoldCursedScript extends ObjectReference  

SPELL Property _RO_UndeadCurse  Auto
MiscObject Property Gold001 Auto

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)

	if akNewContainer == Game.GetPlayer()
		; Debug.Trace("I just got put in the player's inventory!")
		Game.GetPlayer().RemoveSpell(_RO_UndeadCurse)
		Game.GetPlayer().AddSpell(_RO_UndeadCurse, false)
		
		; Remove this immediately
		Game.GetPlayer().RemoveItem(Self, 1, true)
		Game.GetPlayer().AddItem(Gold001, 1, true)
	endIf

endEvent

