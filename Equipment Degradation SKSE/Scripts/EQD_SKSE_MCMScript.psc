Scriptname EQD_SKSE_MCMScript extends SKI_ConfigBase  

GlobalVariable Property EQD_Enabled  Auto
GlobalVariable Property EQD_Debug  Auto

GlobalVariable Property EQD_WeaponDurability1  Auto
GlobalVariable Property EQD_WeaponDurability2  Auto
GlobalVariable Property EQD_WeaponDurability3  Auto
GlobalVariable Property EQD_WeaponDurability4  Auto
GlobalVariable Property EQD_WeaponDurability5  Auto

GlobalVariable Property EQD_ArmorDurability1  Auto
GlobalVariable Property EQD_ArmorDurability2  Auto
GlobalVariable Property EQD_ArmorDurability3  Auto
GlobalVariable Property EQD_ArmorDurability4  Auto
GlobalVariable Property EQD_ArmorDurability5  Auto

Quest Property EQD_ManagerQuest  Auto

; SCRIPT VERSION ----------------------------------------------------------------------------------

int function GetVersion()
	return 1 ; Default version
endFunction

; PRIVATE VARIABLES -------------------------------------------------------------------------------

Int iEnabledToggle
Bool bEnabled

Int iDebugToggle
Bool bDebug

Int iWeaponDurability1Slider
Float fWeaponDurability1

Int iWeaponDurability2Slider
Float fWeaponDurability2

Int iWeaponDurability3Slider
Float fWeaponDurability3

Int iWeaponDurability4Slider
Float fWeaponDurability4

Int iWeaponDurability5Slider
Float fWeaponDurability5

Int iArmorDurability1Slider
Float fArmorDurability1

Int iArmorDurability2Slider
Float fArmorDurability2

Int iArmorDurability3Slider
Float fArmorDurability3

Int iArmorDurability4Slider
Float fArmorDurability4

Int iArmorDurability5Slider
Float fArmorDurability5

; EVENTS ------------------------------------------------------------------------------------------

Event OnConfigClose()
	{Called when this config menu is closed}
	
	; Check if a change was made
	if bEnabled != EQD_Enabled.GetValue() as Bool
		UpdateModEnabled()
	endIf

	EQD_Debug.SetValue(bDebug as Int)

	EQD_WeaponDurability1.SetValue(fWeaponDurability1 / 1000.0)
	EQD_WeaponDurability2.SetValue(fWeaponDurability2 / 1000.0)
	EQD_WeaponDurability3.SetValue(fWeaponDurability3 / 1000.0)
	EQD_WeaponDurability4.SetValue(fWeaponDurability4 / 1000.0)
	EQD_WeaponDurability5.SetValue(fWeaponDurability5 / 1000.0)

	EQD_ArmorDurability1.SetValue(fArmorDurability1 / 1000.0)
	EQD_ArmorDurability2.SetValue(fArmorDurability2 / 1000.0)
	EQD_ArmorDurability3.SetValue(fArmorDurability3 / 1000.0)
	EQD_ArmorDurability4.SetValue(fArmorDurability4 / 1000.0)
	EQD_ArmorDurability5.SetValue(fArmorDurability5 / 1000.0)
endEvent

Event OnPageReset(string a_page)
	{Called when a new page is selected, including the initial empty page}
	
	bEnabled = EQD_Enabled.GetValue() as Bool
	bDebug = EQD_Debug.GetValue() as Bool
	
	fWeaponDurability1 = EQD_WeaponDurability1.GetValue() * 1000.0
	fWeaponDurability2 = EQD_WeaponDurability2.GetValue() * 1000.0
	fWeaponDurability3 = EQD_WeaponDurability3.GetValue() * 1000.0
	fWeaponDurability4 = EQD_WeaponDurability4.GetValue() * 1000.0
	fWeaponDurability5 = EQD_WeaponDurability5.GetValue() * 1000.0

	fArmorDurability1 = EQD_ArmorDurability1.GetValue() * 1000.0
	fArmorDurability2 = EQD_ArmorDurability2.GetValue() * 1000.0
	fArmorDurability3 = EQD_ArmorDurability3.GetValue() * 1000.0
	fArmorDurability4 = EQD_ArmorDurability4.GetValue() * 1000.0
	fArmorDurability5 = EQD_ArmorDurability5.GetValue() * 1000.0
	
	SetCursorFillMode(LEFT_TO_RIGHT)
	
	; Left 0, Right 0 - General Settings Heading and Version
	AddHeaderOption("General")
	AddTextOption("Mod Version", "1.1.1")

	; Left 1 - Enabled Toggle
	iEnabledToggle = AddToggleOption("Enable Mod", bEnabled)
	AddEmptyOption()

	; Left 2 - Debug Toggle
	iDebugToggle = AddToggleOption("Debug Notifications", bDebug)
	AddEmptyOption()

	; Left 3, Right 3 - Durability Headings
	AddHeaderOption("Weapon Durability")
	AddHeaderOption("Armor Durability")

	; Left 4, Right 4 - Durability 1 Sliders
	iWeaponDurability1Slider = AddSliderOption("Weapon Durability Tier 1", fWeaponDurability1)
	iArmorDurability1Slider = AddSliderOption("Armor Durability Tier 1", fArmorDurability1)

	; Left 5, Right 5 - Durability 2 Sliders
	iWeaponDurability2Slider = AddSliderOption("Weapon Durability Tier 2", fWeaponDurability2)
	iArmorDurability2Slider = AddSliderOption("Armor Durability Tier 2", fArmorDurability2)

	; Left 6, Right 6 - Durability 3 Sliders
	iWeaponDurability3Slider = AddSliderOption("Weapon Durability Tier 3", fWeaponDurability3)
	iArmorDurability3Slider = AddSliderOption("Armor Durability Tier 3", fArmorDurability3)

	; Left 7, Right 7 - Durability 4 Sliders
	iWeaponDurability4Slider = AddSliderOption("Weapon Durability Tier 4", fWeaponDurability4)
	iArmorDurability4Slider = AddSliderOption("Armor Durability Tier 4", fArmorDurability4)

	; Left 8, Right 8 - Durability 5 Sliders
	iWeaponDurability5Slider = AddSliderOption("Weapon Durability Tier 5", fWeaponDurability5)
	iArmorDurability5Slider = AddSliderOption("Armor Durability Tier 5", fArmorDurability5)
endEvent

Event OnOptionHighlight(int a_option)
	{Called when highlighting an option}
	
	SetInfoTextForOption(a_option)
endEvent

Event OnOptionSelect(int a_option)
	{Called when a non-interactive option has been selected}
	
	if a_option == iEnabledToggle
		bEnabled = !bEnabled
		SetToggleOptionValue(iEnabledToggle, bEnabled)
	elseIf a_option == iDebugToggle
		bDebug = !bDebug
		SetToggleOptionValue(iDebugToggle, bDebug)
	endIf
endEvent

Event OnOptionDefault(int a_option)
	{Called when resetting an option to its default value}

	if a_option == iEnabledToggle
		bEnabled = true
		SetToggleOptionValue(a_option, bEnabled)
	elseIf a_option == iDebugToggle
		bDebug = false
		SetToggleOptionValue(a_option, bDebug)
	elseIf a_option == iWeaponDurability1Slider
		fWeaponDurability1 = GetDefaultSliderValue(a_option)
		SetSliderOptionValue(a_option, fWeaponDurability1)
	elseIf a_option == iWeaponDurability2Slider
		fWeaponDurability2 = GetDefaultSliderValue(a_option)
		SetSliderOptionValue(a_option, fWeaponDurability2)
	elseIf a_option == iWeaponDurability3Slider
		fWeaponDurability3 = GetDefaultSliderValue(a_option)
		SetSliderOptionValue(a_option, fWeaponDurability3)
	elseIf a_option == iWeaponDurability4Slider
		fWeaponDurability4 = GetDefaultSliderValue(a_option)
		SetSliderOptionValue(a_option, fWeaponDurability4)
	elseIf a_option == iWeaponDurability5Slider
		fWeaponDurability5 = GetDefaultSliderValue(a_option)
		SetSliderOptionValue(a_option, fWeaponDurability5)
	elseIf a_option == iArmorDurability1Slider
		fArmorDurability1 = GetDefaultSliderValue(a_option)
		SetSliderOptionValue(a_option, fArmorDurability1)
	elseIf a_option == iArmorDurability2Slider
		fArmorDurability2 = GetDefaultSliderValue(a_option)
		SetSliderOptionValue(a_option, fArmorDurability2)
	elseIf a_option == iArmorDurability3Slider
		fArmorDurability3 = GetDefaultSliderValue(a_option)
		SetSliderOptionValue(a_option, fArmorDurability3)
	elseIf a_option == iArmorDurability4Slider
		fArmorDurability4 = GetDefaultSliderValue(a_option)
		SetSliderOptionValue(a_option, fArmorDurability4)
	elseIf a_option == iArmorDurability5Slider
		fArmorDurability5 = GetDefaultSliderValue(a_option)
		SetSliderOptionValue(a_option, fArmorDurability5)
	endIf
	
	; Update the info text since information depends on set values
	Utility.WaitMenuMode(0.5)
	SetInfoTextForOption(a_option)
endEvent

Event OnOptionSliderOpen(int a_option)
	{Called when a slider option has been selected}
	
	If a_option == iWeaponDurability1Slider
		SetupSliderDialog(a_option, fWeaponDurability1)
	elseIf a_option == iWeaponDurability2Slider
		SetupSliderDialog(a_option, fWeaponDurability2)
	elseIf a_option == iWeaponDurability3Slider
		SetupSliderDialog(a_option, fWeaponDurability3)
	elseIf a_option == iWeaponDurability4Slider
		SetupSliderDialog(a_option, fWeaponDurability4)
	elseIf a_option == iWeaponDurability5Slider
		SetupSliderDialog(a_option, fWeaponDurability5)
	elseIf a_option == iArmorDurability1Slider
		SetupSliderDialog(a_option, fArmorDurability1)
	elseIf a_option == iArmorDurability2Slider
		SetupSliderDialog(a_option, fArmorDurability2)
	elseIf a_option == iArmorDurability3Slider
		SetupSliderDialog(a_option, fArmorDurability3)
	elseIf a_option == iArmorDurability4Slider
		SetupSliderDialog(a_option, fArmorDurability4)
	elseIf a_option == iArmorDurability5Slider
		SetupSliderDialog(a_option, fArmorDurability5)
	endIf
endEvent

Event OnOptionSliderAccept(int a_option, float a_value)
	{Called when a new slider value has been accepted}
	
	If a_option == iWeaponDurability1Slider
		fWeaponDurability1 = a_value
		SetSliderOptionValue(a_option, fWeaponDurability1)
	elseIf a_option == iWeaponDurability2Slider
		fWeaponDurability2 = a_value
		SetSliderOptionValue(a_option, fWeaponDurability2)
	elseIf a_option == iWeaponDurability3Slider
		fWeaponDurability3 = a_value
		SetSliderOptionValue(a_option, fWeaponDurability3)
	elseIf a_option == iWeaponDurability4Slider
		fWeaponDurability4 = a_value
		SetSliderOptionValue(a_option, fWeaponDurability4)
	elseIf a_option == iWeaponDurability5Slider
		fWeaponDurability5 = a_value
		SetSliderOptionValue(a_option, fWeaponDurability5)
	elseIf a_option == iArmorDurability1Slider
		fArmorDurability1 = a_value
		SetSliderOptionValue(a_option, fArmorDurability1)
	elseIf a_option == iArmorDurability2Slider
		fArmorDurability2 = a_value
		SetSliderOptionValue(a_option, fArmorDurability2)
	elseIf a_option == iArmorDurability3Slider
		fArmorDurability3 = a_value
		SetSliderOptionValue(a_option, fArmorDurability3)
	elseIf a_option == iArmorDurability4Slider
		fArmorDurability4 = a_value
		SetSliderOptionValue(a_option, fArmorDurability4)
	elseIf a_option == iArmorDurability5Slider
		fArmorDurability5 = a_value
		SetSliderOptionValue(a_option, fArmorDurability5)
	endIf

	; Update the info text since information depends on set values
	Utility.WaitMenuMode(0.5)
	SetInfoTextForOption(a_option)
endEvent

; FUNCTIONS ------------------------------------------------------------------------------------------

Function UpdateModEnabled()
	; Update the global variable. This will be reference by the manager quest
	EQD_Enabled.SetValue(bEnabled as Int)
	
	; Reference the manager quest alias tab for player alias ID
	EQD_SKSE_ManagerQuestPlayerAlias playerAlias = EQD_ManagerQuest.GetAlias(5) as EQD_SKSE_ManagerQuestPlayerAlias
	
	; Start the manager quest as needed if mod is being enabled
	if bEnabled
		EQD_ManagerQuest.Start()
		If !EQD_ManagerQuest.isRunning()
			DebugScript("Enemizer manager failed to start. Clean reinstall of mod recommended")
		endIf
	else
		EQD_ManagerQuest.Stop()
	endIf
	
	; Enable/Disable functionality is handled in Maintenance function
	playerAlias.Maintenance()
endFunction

Function SetInfoTextForOption(int a_option)
	{Sets the text for the info text field below the option panel}

	if a_option == iEnabledToggle
		SetInfoText("Enable/Disable the mod. Recommended to use this to disable the mod before uninstalling")
	elseIf a_option == iDebugToggle
		SetInfoText("Enable/Disable Debug Notifications")
	elseIf a_option == iWeaponDurability1Slider
		Float fDamagePercent = 100.0 - fWeaponDurability1 / 10.0
		SetInfoText(FloatToString(fDamagePercent, 1) + "% chance to damage on hit")
	elseIf a_option == iWeaponDurability2Slider
		Float fDamagePercent = 100.0 - fWeaponDurability2 / 10.0
		SetInfoText(FloatToString(fDamagePercent, 1) + "% chance to damage on hit")
	elseIf a_option == iWeaponDurability3Slider
		Float fDamagePercent = 100.0 - fWeaponDurability3 / 10.0
		SetInfoText(FloatToString(fDamagePercent, 1) + "% chance to damage on hit")
	elseIf a_option == iWeaponDurability4Slider
		Float fDamagePercent = 100.0 - fWeaponDurability4 / 10.0
		SetInfoText(FloatToString(fDamagePercent, 1) + "% chance to damage on hit")
	elseIf a_option == iWeaponDurability5Slider
		Float fDamagePercent = 100.0 - fWeaponDurability5 / 10.0
		SetInfoText(FloatToString(fDamagePercent, 1) + "% chance to damage on hit")
	elseIf a_option == iArmorDurability1Slider
		Float fDamagePercent = 100.0 - fArmorDurability1 / 10.0
		SetInfoText(FloatToString(fDamagePercent, 1) + "% chance to damage on hit")
	elseIf a_option == iArmorDurability2Slider
		Float fDamagePercent = 100.0 - fArmorDurability2 / 10.0
		SetInfoText(FloatToString(fDamagePercent, 1) + "% chance to damage on hit")
	elseIf a_option == iArmorDurability3Slider
		Float fDamagePercent = 100.0 - fArmorDurability3 / 10.0
		SetInfoText(FloatToString(fDamagePercent, 1) + "% chance to damage on hit")
	elseIf a_option == iArmorDurability4Slider
		Float fDamagePercent = 100.0 - fArmorDurability4 / 10.0
		SetInfoText(FloatToString(fDamagePercent, 1) + "% chance to damage on hit")
	elseIf a_option == iArmorDurability5Slider
		Float fDamagePercent = 100.0 - fArmorDurability5 / 10.0
		SetInfoText(FloatToString(fDamagePercent, 1) + "% chance to damage on hit")
	else
		SetInfoText("")
	endIf
endFunction

Float Function GetDefaultSliderValue(Int a_option)
	If a_option == iWeaponDurability1Slider
		return 970.0
	elseIf a_option == iWeaponDurability2Slider
		return 975.0
	elseIf a_option == iWeaponDurability3Slider
		return 980.0
	elseIf a_option == iWeaponDurability4Slider
		return 985.0
	elseIf a_option == iWeaponDurability5Slider
		return 990.0
	elseIf a_option == iArmorDurability1Slider
		return 950.0
	elseIf a_option == iArmorDurability2Slider
		return 960.0
	elseIf a_option == iArmorDurability3Slider
		return 970.0
	elseIf a_option == iArmorDurability4Slider
		return 980.0
	elseIf a_option == iArmorDurability5Slider
		return 990.0
	endIf

	return 0.0
endFunction

Function SetupSliderDialog(Int a_option, Float a_value)
	SetSliderDialogStartValue(a_value)
	SetSliderDialogDefaultValue(GetDefaultSliderValue(a_option))
	SetSliderDialogRange(500.0, 1000.0)
	SetSliderDialogInterval(5.0)
endFunction

; UTILITY ------------------------------------------------------------------------------------------

Function DebugScript(String asMessage)
	if EQD_Debug.GetValue() as Bool
		Debug.Trace(asMessage)
		Debug.Notification("EQD MCM: " + asMessage)
	endIf
endFunction

String Function FloatToString(Float f, Int precision)
    Int tempInt = f as Int
    String s = tempInt as String

    if (precision > 0)
        s += "."
        Float remainder = f - tempInt as Float
        Int i = 0
        While i < precision
            remainder *= 10.0
            i += 1
        EndWhile
        s += (remainder as Int) as String
    EndIf

    Return s
EndFunction