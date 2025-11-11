Scriptname _RO_DropGoldEffectScript extends activemagiceffect  

Potion Property _RO_DropGoldALC  Auto

MiscObject Property Gold001  Auto
Flora Property _RO_FloraCoinPurse100  Auto
Flora Property _RO_FloraCoinPurse500  Auto
Flora Property _RO_FloraCoinPurse1000  Auto

Message Property _RO_DropGoldMessage  Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)

	; Drop 100 gold
	; Place a new coin purse
	;akTarget.PlaceAtMe(_RO_FloraCoinPurse100)
	;akTarget.RemoveItem(Gold001, 100)
	
	int iButton = _RO_DropGoldMessage.Show()

	Actor player = Game.GetPlayer()

	If iButton == 1
		; Drop 100 Golde
		akTarget.PlaceAtMe(_RO_FloraCoinPurse100)
		akTarget.RemoveItem(Gold001, 100)
	ElseIf iButton == 2
		; Drop 500  Gold
		akTarget.PlaceAtMe(_RO_FloraCoinPurse500)
		akTarget.RemoveItem(Gold001, 500)
	ElseIf iButton == 3
		; Drop 1000 Gold
		akTarget.PlaceAtMe(_RO_FloraCoinPurse1000)
		akTarget.RemoveItem(Gold001, 1000)
	EndIf
	
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)

	If akTarget.GetItemCount(Gold001) >= 100
		akTarget.AddItem(_RO_DropGoldALC, 1, true)
	EndIf

EndEvent