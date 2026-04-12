Scriptname _RO_TorchCraftingScript extends ObjectReference  

MiscObject Property _RO_TorchDummy  Auto  
Light Property Torch01  Auto  
Int Property Count  Auto

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
  if akNewContainer == Game.GetPlayer()
    Game.GetPlayer().AddItem(Torch01, Count, true)
    Game.GetPlayer().RemoveItem(_RO_TorchDummy, 1, true)
  endif
endEvent