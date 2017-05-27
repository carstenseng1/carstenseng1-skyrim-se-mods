Scriptname _REAL_Nutrition_RawMeatEffectScript extends activemagiceffect

{This script causes a 10% chance to give the player a disease when eating raw meat.}



Event OnEffectStart(Actor akTarget, Actor akCaster)

	Debug.Trace("Magic effect was started on " + akTarget)

	if (akTarget == Game.GetPlayer())

		int random = Utility.RandomInt(0, 10)

		if (random <= 1)

			random = Utility.RandomInt(0, 100)

			if (random < 25)

				akTarget.AddSpell(DiseaseBoneBreakFever)

			elseif (random < 50)

				akTarget.AddSpell(DiseaseBrainRot)

			elseif (random < 75)

				akTarget.AddSpell(DiseaseRattles)

			else

				akTarget.AddSpell(DiseaseRockjoint)

			endif

		endif

	endif

endEvent



Spell Property DiseaseBoneBreakFever Auto

Spell Property DiseaseBrainRot Auto

Spell Property DiseaseRattles Auto

Spell Property DiseaseRockjoint Auto
