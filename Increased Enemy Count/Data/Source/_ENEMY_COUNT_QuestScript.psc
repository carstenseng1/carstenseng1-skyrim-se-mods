Scriptname _ENEMY_COUNT_QuestScript extends Quest  

Int Property difficulty Auto
Bool Property debugNotifications Auto  
Int[] Property spawnCountInterior  Auto  
Int[] Property spawnCountExterior  Auto  
Float[] Property spawnChanceInterior  Auto  
Float[] Property spawnChanceExterior  Auto  
SPELL Property _ENEMY_COUNT_OptionsSpell  Auto  

Event OnInit()
	Debug.Notification("Enemizer")
	Game.GetPlayer().AddSpell(_ENEMY_COUNT_OptionsSpell, false)
endEvent
