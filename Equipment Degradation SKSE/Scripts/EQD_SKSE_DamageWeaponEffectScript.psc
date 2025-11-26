Scriptname EQD_SKSE_DamageWeaponEffectScript extends ActiveMagicEffect  

Bool Property pIsBash = false  Auto

Quest Property EQD_ManagerQuest  Auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	; Both caster and target are the hit actor when used with a Perk: Apply Combat Hit Spell
	; Therefore, we must just get a reference to the player and ensure this spell is only cast when the player's weapon should be damaged
	Actor player = Game.GetPlayer()
	
	; Get a reference to the player alias of the manager quest to handle damaging weapon/shield
	EQD_SKSE_ManagerQuestPlayerAlias playerAlias = EQD_ManagerQuest.GetAlias(5) as EQD_SKSE_ManagerQuestPlayerAlias
	
	; Call to manager quest player alias to damage weapon/shield
	if pIsBash
		if player.GetEquippedShield()
			playerAlias.HitShield()
		else
			; Only the right hand weapon can bash
			playerAlias.HitWeaponRH()
		endIf
	else
		playerAlias.HitWeapon()
	endIf
	
endEvent
