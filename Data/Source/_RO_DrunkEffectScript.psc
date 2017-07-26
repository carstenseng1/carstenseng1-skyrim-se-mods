Scriptname _RO_DrunkEffectScript extends activemagiceffect  

ImageSpaceModifier Property _RO_DrunkImod  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
  _RO_DrunkImod.Apply()
endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  _RO_DrunkImod.Remove()
endEvent