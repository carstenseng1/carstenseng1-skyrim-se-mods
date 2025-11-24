Scriptname EQD_DamageWeaponEffectScript extends ActiveMagicEffect  


Bool Property pIsBash = false  Auto

Quest Property EQD_DestructibleArmorQuest  Auto
Quest Property EQD_DestructibleWeaponQuest  Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	; Both caster and target are the hit actor when used with a Perk: Apply Combat Hit Spell
	; Therefore, we must just get a reference to the player and ensure this spell is only cast when the player's weapon should be damaged
	Actor player = Game.GetPlayer()
	
	
	if pIsBash
		if player.GetEquippedShield()
			HitShield()
		else
			HitWeapon()
		endIf
	else
		HitWeapon()
	endIf

endEvent


Function HitWeapon()

	; Call to damage weapon quest
	EQD_DestructibleWeaponQuestPlayerAlias playerAlias = EQD_DestructibleWeaponQuest.GetAlias(5) as EQD_DestructibleWeaponQuestPlayerAlias
	playerAlias.HitWeapon()

endFunction


Function HitShield()

	; Call to damage armor quest when bashing with a shield
	EQD_DestructibleArmorQuestPlayerAlias playerAlias = EQD_DestructibleArmorQuest.GetAlias(5) as EQD_DestructibleArmorQuestPlayerAlias
	playerAlias.HitShield()

endFunction