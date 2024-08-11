Scriptname _ENEMY_COUNT_OptionsEffectScript extends activemagiceffect  
{Script to show the enemy count mod options}

Message Property _ENEMY_COUNT_MessageBox  Auto  
 _ENEMY_COUNT_QuestScript Property _ENEMY_COUNT_Quest  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	int iButton = _ENEMY_COUNT_MessageBox.show()

	if iButton == 0
		; off
		Debug.Notification("Enemizer disabled")
	elseIf iButton == 1
		; low
		Debug.Notification("Enemizer set to Low")
	elseIf iButton ==2
		; medium
		Debug.Notification("Enemizer set to Medium")
	elseIf iButton == 3
		; high
		Debug.Notification("Enemizer set to High")
	elseIf iButton == 4
		; toggle debugging
		if _ENEMY_COUNT_Quest.debugNotifications == true
			_ENEMY_COUNT_Quest.debugNotifications = false
			Debug.Notification("Enemizer debugging disabled")
		else
			_ENEMY_COUNT_Quest.debugNotifications = true
			Debug.Notification("Enemizer debugging enabled")
		endIf
	endIf

endEvent
