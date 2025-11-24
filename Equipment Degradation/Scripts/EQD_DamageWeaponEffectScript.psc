Scriptname EQD_DamageWeaponEffectScript extends ActiveMagicEffect  


Bool Property pIsBash = false  Auto

Quest Property EQD_DestructibleArmorQuest  Auto
Quest Property EQD_DestructibleWeaponQuest  Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	; Both caster and target are the hit actor when used with a Perk: Apply Combat Hit Spell
	; Therefore, we must just get a reference to the player and ensure this spell is only cast when the player's weapon should be damaged
	Actor player = Game.GetPlayer()
	
	
	if pIsBash && player.GetEquippedShield()
		; Call to damage armor quest when bashing with a shield
		EQD_DestructibleArmorQuestPlayerAlias playerAlias = EQD_DestructibleArmorQuest.GetAlias(5) as EQD_DestructibleArmorQuestPlayerAlias
		playerAlias.HitShield()
		return
	else
		; Call to damage weapon quest
		EQD_DestructibleWeaponQuestPlayerAlias playerAlias = EQD_DestructibleWeaponQuest.GetAlias(5) as EQD_DestructibleWeaponQuestPlayerAlias
		playerAlias.HitWeapon()
	endIf

endEvent
