Scriptname _RO_BookCraftingScript extends ObjectReference  

SPELL Property _RO_CraftingFieldPower  Auto 

Event OnRead()
	
	Utility.Wait(0.1)
	Game.GetPlayer().AddSpell(_RO_CraftingFieldPower)
	
EndEvent