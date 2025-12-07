Scriptname IDB_MCMScript extends SKI_ConfigBase  

GlobalVariable Property IDB_Enabled  Auto
GlobalVariable Property IDB_Debug  Auto
GlobalVariable Property IDB_ParalysisEnabled  Auto
GlobalVariable Property IDB_FearEnabled  Auto
GlobalVariable Property IDB_PercentHealth  Auto
GlobalVariable Property IDB_DragonsoulCost  Auto
Quest Property IDB_ManagerQuest  Auto

; SCRIPT VERSION ----------------------------------------------------------------------------------

Int Function GetVersion()
	return 1 ; Default version
endFunction

; PRIVATE VARIABLES -------------------------------------------------------------------------------

Int iEnabledToggle
Bool bEnabled

Int iDebugToggle
Bool bDebug

Int iParalysisToggle
Bool bParalysisEnabled

Int iFearToggle
Bool bFearEnabled

Int iPercentHealthSlider
Float fPercentHealth

Int iDragonsoulCostSlider
Int iDragonsoulCost

; EVENTS ------------------------------------------------------------------------------------------

Event OnConfigClose()
{Called when this config menu is closed}
	
	; Set debug first in to show messages from MCM
	IDB_Debug.SetValue(bDebug as Int)

	; Check if a change was made
	if bEnabled != IDB_Enabled.GetValue() as Bool
		UpdateModEnabled()
	endIf
	
	IDB_ParalysisEnabled.SetValue(bParalysisEnabled as Int)
	IDB_FearEnabled.SetValue(bFearEnabled as Int)
	IDB_PercentHealth.SetValue(fPercentHealth/100)
	IDB_DragonsoulCost.SetValue(iDragonsoulCost)
endEvent

Event OnPageReset(String a_page)
{Called when a new page is selected, including the initial empty page}
	
	; Initialize option variables
	bEnabled = IDB_Enabled.GetValue() as Bool
	bDebug = IDB_Debug.GetValue() as Bool
	bParalysisEnabled = IDB_ParalysisEnabled.GetValue() as Bool
	bFearEnabled = IDB_FearEnabled.GetValue() as Bool
	fPercentHealth = IDB_PercentHealth.GetValue() * 100
	iDragonsoulCost = IDB_DragonsoulCost.GetValue() as Int
	
	SetCursorFillMode(LEFT_TO_RIGHT)
	
	; Left Heading
	AddHeaderOption("General")

	; Right Heading
	AddHeaderOption("Revival")

	; Left 1 - Enabled Toggle
	iEnabledToggle = AddToggleOption("Enable Mod", bEnabled)

	; Right 1 - Paralysis Toggle
	iParalysisToggle = AddToggleOption("Enable Paralysis", bParalysisEnabled)

	; Left 2 - Debug Toggle
	iDebugToggle = AddToggleOption("Debug Notifications", bDebug)

	; Right 2 - Paralysis Toggle
	iFearToggle = AddToggleOption("Enable Fear", bFearEnabled)
	
	; Left 3
	AddTextOption("Mod Version", "1.1.1")
	
	; Right 3 - Slider for setting HP threshold at which 25% Damage Resist is active
	iPercentHealthSlider = AddSliderOption("Activation Health Percentage", fPercentHealth, "{0}%")
	
	; Left 4
	AddEmptyOption()
	
	; Right 4 - Add Slider for setting the Dragonsoul cost to revive
	iDragonsoulCostSlider = AddSliderOption("Dragonsoul Cost", iDragonsoulCost)
endEvent

Event OnOptionHighlight(int a_option)
{Called when highlighting an option}
	
	if a_option == iEnabledToggle
		SetInfoText("Enable/Disable mod. Recommended to use this to disable the mod before uninstalling")
	elseIf a_option == iDebugToggle
		SetInfoText("Enable/Disable script debug notifications")
	elseIf a_option == iParalysisToggle
		SetInfoText("Cast Mass Paralysis spell when revived")
	elseIf a_option == iFearToggle
		SetInfoText("Cast Fear spell when revived")
	elseIf a_option == iPercentHealthSlider
		SetInfoText("Health Percentage at which revival will activate. Recommended 10% to match Avoid Death Perk")
	elseIf a_option == iDragonsoulCostSlider
		SetInfoText("Number of Dragon Souls it costs to revive")
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
	elseIf a_option == iParalysisToggle
		bParalysisEnabled = !bParalysisEnabled
		SetToggleOptionValue(a_option, bParalysisEnabled)
	elseIf a_option == iFearToggle
		bFearEnabled = !bFearEnabled
		SetToggleOptionValue(a_option, bFearEnabled)
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
	elseIf a_option == iParalysisToggle
		bParalysisEnabled = true
		SetToggleOptionValue(iParalysisToggle, bParalysisEnabled)
	elseIf a_option == iFearToggle
		bFearEnabled = true
		SetToggleOptionValue(iFearToggle, bFearEnabled)
	elseIf a_option == iPercentHealthSlider
		fPercentHealth = 10.0
		SetSliderOptionValue(a_option, 10.0, "{0}%")
	elseIf a_option == iDragonsoulCostSlider
		iDragonsoulCost = 1
		SetSliderOptionValue(a_option, 1)
	endIf
endEvent

Event OnOptionSliderOpen(int a_option)
{Called when a slider option has been selected}

	If a_option == iPercentHealthSlider
		SetSliderDialogStartValue(fPercentHealth)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(5.0)
	elseIf a_option == iDragonsoulCostSlider
		SetSliderDialogStartValue(iDragonsoulCost)
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(1, 10)
		SetSliderDialogInterval(1)
	endIf
endEvent

Event OnOptionSliderAccept(int a_option, float a_value)
{Called when a new slider value has been accepted}

	if a_option == iPercentHealthSlider
		fPercentHealth = a_value
		SetSliderOptionValue(a_option, a_value, "{0}%")
	elseIf a_option == iDragonsoulCostSlider
		iDragonsoulCost = a_value as Int
		SetSliderOptionValue(a_option, a_value)
	endIf
endEvent

; FUNCTIONS ------------------------------------------------------------------------------------------

Function UpdateModEnabled()
{Updates the mod enabled/disabled setting and performs startup/shutdown functions}
	
	; Update the global variable. This will be reference by the manager quest
	IDB_Enabled.SetValue(bEnabled as Int)
	
	IDB_ManagerQuestPlayerAlias playerAlias = IDB_ManagerQuest.GetAlias(0) as IDB_ManagerQuestPlayerAlias
	
	; Start the manager quest as needed if mod is being enabled
	if bEnabled && !IDB_ManagerQuest.isRunning()
		IDB_ManagerQuest.Start()
		If !IDB_ManagerQuest.isRunning()
			DebugScript("Manager Quest failed to start. Clean reinstall recommended")
		endIf
	else
		IDB_ManagerQuest.Stop()
	endIf
	
	; Enable/Disable functionality
	playerAlias.Maintenance()
endFunction

; UTILITY ------------------------------------------------------------------------------------------

Function DebugScript(String asMessage)
	if IDB_Debug.GetValue() as Bool
		Debug.Trace(asMessage)
		Debug.Notification("IDB: " + asMessage)
	endIf
endFunction