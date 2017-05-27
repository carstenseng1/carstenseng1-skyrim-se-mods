Scriptname _REAL_Nutrition_EnableStarvationScript extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	_REAL_Nutrition_Quest.SetStarvationEnabled(pEnableStarvation)

	if (pEnableStarvation)
		Game.GetPlayer().AddSpell(_REAL_Nutrition_DisableStarvationSpell, false)
		Game.GetPlayer().EquipSpell(_REAL_Nutrition_DisableStarvationSpell, 2)
		Game.GetPlayer().RemoveSpell(_REAL_Nutrition_EnableStarvationSpell)
	else
		Game.GetPlayer().AddSpell(_REAL_Nutrition_EnableStarvationSpell, false)
		Game.GetPlayer().EquipSpell(_REAL_Nutrition_EnableStarvationSpell, 2)
		Game.GetPlayer().RemoveSpell(_REAL_Nutrition_DisableStarvationSpell)
	endIf
endEvent

_REAL_Nutrition_QuestScript Property _REAL_Nutrition_Quest  Auto  
SPELL Property _REAL_Nutrition_EnableStarvationSpell  Auto  
Bool Property pEnableStarvation  Auto  

SPELL Property _REAL_Nutrition_DisableStarvationSpell  Auto  
