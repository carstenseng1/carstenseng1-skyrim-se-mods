Scriptname ENMZ_MCMScript extends SKI_ConfigBase  

GlobalVariable Property ENMZ_Enabled  Auto
GlobalVariable Property ENMZ_Debug  Auto
GlobalVariable Property ENMZ_SpawnCountInterior  Auto
GlobalVariable Property ENMZ_SpawnCountExterior  Auto
GlobalVariable Property ENMZ_SpawnChanceInterior  Auto
GlobalVariable Property ENMZ_SpawnChanceExterior  Auto
Quest Property ENMZ_ManagerQuest  Auto

; SCRIPT VERSION ----------------------------------------------------------------------------------

Int Function GetVersion()
	return 1 ; Default version
endFunction

; PRIVATE VARIABLES -------------------------------------------------------------------------------

Int iEnabledToggle
Bool bEnabled

Int iDebugToggle
Bool bDebug

Int iSpawnCountInteriorSlider
Int iSpawnCountInterior

Int iSpawnCountExteriorSlider
Int iSpawnCountExterior

Int iSpawnChanceInteriorSlider
Float fSpawnChanceInterior

Int iSpawnChanceExteriorSlider
Float fSpawnChanceExterior

; EVENTS ------------------------------------------------------------------------------------------

Event OnConfigClose()
	{Called when this config menu is closed}
	
	; Set debug first in to show messages from MCM
	ENMZ_Debug.SetValue(bDebug as Int)

	; Check if a change was made
	if bEnabled != ENMZ_Enabled.GetValue() as Bool
		UpdateModEnabled()
	endIf

	ENMZ_SpawnCountInterior.SetValue(iSpawnCountInterior)
	ENMZ_SpawnCountExterior.SetValue(iSpawnCountExterior)
	ENMZ_SpawnChanceInterior.SetValue(fSpawnChanceInterior / 100.0)
	ENMZ_SpawnChanceExterior.SetValue(fSpawnChanceExterior / 100.0)
endEvent

Event OnPageReset(String a_page)
	{Called when a new page is selected, including the initial empty page}
	
	bEnabled = ENMZ_Enabled.GetValue() as Bool
	bDebug = ENMZ_Debug.GetValue() as Bool
	iSpawnCountInterior = ENMZ_SpawnCountInterior.GetValueInt()
	iSpawnCountExterior = ENMZ_SpawnCountExterior.GetValueInt()
	fSpawnChanceInterior = ENMZ_SpawnChanceInterior.GetValue() * 100.0
	fSpawnChanceExterior = ENMZ_SpawnChanceExterior.GetValue() * 100.0
	
	SetCursorFillMode(LEFT_TO_RIGHT)
	
	; Left Heading
	AddHeaderOption("General")
	
	; Right Heading
	AddTextOption("Mod Version", "1.1.2")
	
	; Left 1 - Add Mod Enabled Toggle
	iEnabledToggle = AddToggleOption("Enable Mod", bEnabled)
	AddEmptyOption()

	; Left 2 - Debug
	iDebugToggle = AddToggleOption("Debug Notifications", bDebug)
	AddEmptyOption()
	
	; Left 3 - Heading
	AddHeaderOption("Enemy Spawn Interior")

	; Right 3 - Heading
	AddHeaderOption("Enemy Spawn Exterior")

	; Add sliders for spawn counts and chance

	; Left 4 - Spawn count intererior
	iSpawnCountInteriorSlider = AddSliderOption("Spawn Count Interior", iSpawnCountInterior)

	; Right 4 - Spawn count exterior
	iSpawnCountExteriorSlider = AddSliderOption("Spawn Count Exterior", iSpawnCountExterior)
	
	; Left 5 - Spawn chance interior
	iSpawnChanceInteriorSlider = AddSliderOption("Spawn Chance Interior", fSpawnChanceInterior, "{0}%")
	
	; Right 5 - Spawn chance exterior
	iSpawnChanceExteriorSlider = AddSliderOption("Spawn Chance Exterior", fSpawnChanceExterior, "{0}%")
endEvent

Event OnOptionHighlight(int a_option)
	{Called when highlighting an option}
	
	if a_option == iEnabledToggle
		SetInfoText("Enable/Disable mod. Recommended to use this to disable the mod before uninstalling")
	elseIf a_option == iDebugToggle
		SetInfoText("Enable/Disable script debug notifications")
	elseIf a_option == iSpawnCountInteriorSlider
		SetInfoText("Number of times to attempt to spawn additional enemy when enemy loads in iterior")
	elseIf a_option == iSpawnCountExteriorSlider
		SetInfoText("Number of times to attempt to spawn additional enemy when enemy loads in exterior")
	elseIf a_option == iSpawnChanceInteriorSlider
		SetInfoText("Chance to spawn an additional enemy each attempt when enemy loads in iterior")
	elseIf a_option == iSpawnChanceExteriorSlider
		SetInfoText("Chance to spawn an additional enemy each attempt when enemy loads in exterior")
	else
		SetInfoText("")
	endIf
endEvent

Event OnOptionSelect(int a_option)
	{Called when a non-interactive option has been selected}
	
	if a_option == iEnabledToggle
		bEnabled = !bEnabled
		SetToggleOptionValue(a_option, bEnabled)
	elseIf a_option == iDebugToggle
		bDebug = !bDebug
		SetToggleOptionValue(a_option, bDebug)
	endIf
endEvent

Event OnOptionDefault(int a_option)
	{Called when resetting an option to its default value}

	if a_option == iEnabledToggle
		bEnabled = true
		SetToggleOptionValue(iEnabledToggle, bEnabled)
	elseIf a_option == iDebugToggle
		bDebug = false
		SetToggleOptionValue(a_option, false)
	elseIf a_option == iSpawnCountInteriorSlider
		iSpawnCountInterior = 1
		SetSliderOptionValue(a_option, 1)
	elseIf a_option == iSpawnCountExteriorSlider
		iSpawnCountExterior = 1
		SetSliderOptionValue(a_option, 1)
	elseIf a_option == iSpawnChanceInteriorSlider
		fSpawnChanceInterior = 75.0
		SetSliderOptionValue(a_option, 75.0, "{0}%")
	elseIf a_option == iSpawnChanceExteriorSlider
		fSpawnChanceExterior = 50.0
		SetSliderOptionValue(a_option, 50.0, "{0}%")
	endIf
endEvent

Event OnOptionSliderOpen(int a_option)
	{Called when a slider option has been selected}

	If a_option == iSpawnCountInteriorSlider
		SetSliderDialogStartValue(iSpawnCountInterior)
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(0, 10)
		SetSliderDialogInterval(1)
	elseIf a_option == iSpawnCountExteriorSlider
		SetSliderDialogStartValue(iSpawnCountExterior)
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(0, 10)
		SetSliderDialogInterval(1)
	elseIf a_option == iSpawnChanceInteriorSlider
		SetSliderDialogStartValue(fSpawnChanceInterior)
		SetSliderDialogDefaultValue(75.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(5.0)
	elseIf a_option == iSpawnChanceExteriorSlider
		SetSliderDialogStartValue(fSpawnChanceExterior)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(5.0)
	endIf
endEvent

Event OnOptionSliderAccept(int a_option, float a_value)
	{Called when a new slider value has been accepted}

	If a_option == iSpawnCountInteriorSlider
		iSpawnCountInterior = a_value as Int
		SetSliderOptionValue(a_option, a_value)
	elseIf a_option == iSpawnCountExteriorSlider
		iSpawnCountExterior = a_value as Int
		SetSliderOptionValue(a_option, a_value)
	elseIf a_option == iSpawnChanceInteriorSlider
		fSpawnChanceInterior = a_value
		SetSliderOptionValue(a_option, a_value, "{0}%")
	elseIf a_option == iSpawnChanceExteriorSlider
		fSpawnChanceExterior = a_value
		SetSliderOptionValue(a_option, a_value, "{0}%")
	endIf
endEvent

Function UpdateModEnabled()
	; Update the global variable. This will be reference by the manager quest
	ENMZ_Enabled.SetValue(bEnabled as Int)
	
	; Start the manager quest as needed if mod is being enabled
	if bEnabled && !ENMZ_ManagerQuest.isRunning()
		ENMZ_ManagerQuest.Start()
		If !ENMZ_ManagerQuest.isRunning()
			DebugScript("Manager Quest failed to start. Clean reinstall recommended")
		endIf
	else
		ENMZ_ManagerQuest.Stop()
	endIf
	
	; Enable/Disable functionality
	(ENMZ_ManagerQuest as ENMZ_ManagerQuestScript).Maintenance()
endFunction

; UTILITY ------------------------------------------------------------------------------------------

Function DebugScript(String asMessage)
	if ENMZ_Debug.GetValue() as Bool
		Debug.Trace(asMessage)
		Debug.Notification("ENMZ: " + asMessage)
	endIf
endFunction