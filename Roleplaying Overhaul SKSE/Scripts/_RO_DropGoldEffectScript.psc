Scriptname _RO_DropGoldEffectScript extends activemagiceffect  


MiscObject Property Gold001  Auto
Flora Property _RO_FloraCoinPurse100  Auto
Flora Property _RO_FloraCoinPurse500  Auto
Flora Property _RO_FloraCoinPurse1000  Auto

Message Property _RO_DropGoldMessage  Auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	int iButton = _RO_DropGoldMessage.Show()

	Actor player = Game.GetPlayer()

	If iButton == 1
		; Drop 100 Golde
		player.PlaceAtMe(_RO_FloraCoinPurse100)
		player.RemoveItem(Gold001, 100)
	ElseIf iButton == 2
		; Drop 500  Gold
		player.PlaceAtMe(_RO_FloraCoinPurse500)
		player.RemoveItem(Gold001, 500)
	ElseIf iButton == 3
		; Drop 1000 Gold
		player.PlaceAtMe(_RO_FloraCoinPurse1000)
		player.RemoveItem(Gold001, 1000)
	EndIf
	
EndEvent
