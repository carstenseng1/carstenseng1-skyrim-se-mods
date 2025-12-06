Scriptname LastStandMCMScript extends SKI_ConfigBase  

GlobalVariable Property LastStandEnabled  Auto
GlobalVariable Property LastStandDebug  Auto
GlobalVariable Property LastStandDamageResist25HP  Auto
GlobalVariable Property LastStandDamageResist50HP  Auto
GlobalVariable Property LastStandSlowTimeHP  Auto
Quest Property LastStandQuest  Auto

; SCRIPT VERSION ----------------------------------------------------------------------------------

int function GetVersion()
	return 1 ; Default version
endFunction

; PRIVATE VARIABLES -------------------------------------------------------------------------------

Int iEnabledToggle
Bool bEnabled

Int iDebugToggle
Bool bDebug

Int iDamageResist25HPSlider
Float fDamageResist25HP

Int iDamageResist50HPSlider
Float fDamageResist50HP

Int iSlowTimeHPSlider
Float fSlowTimeHP

; EVENTS ------------------------------------------------------------------------------------------

Event OnConfigClose()
{Called when this config menu is closed}
	; Update debug setting first
	LastStandDebug.SetValue(bDebug as Int)

	; Check if a change was made
	if bEnabled != LastStandEnabled.GetValue() as Bool
		UpdateModEnabled()
	endIf
	
	LastStandDamageResist25HP.SetValue(fDamageResist25HP/100)
	LastStandDamageResist50HP.SetValue(fDamageResist50HP/100)
	LastStandSlowTimeHP.SetValue(fSlowTimeHP/100)
endEvent

Event OnPageReset(string a_page)
{Called when a new page is selected, including the initial empty page}
	
	bEnabled = LastStandEnabled.GetValue() as Bool
	bDebug = LastStandDebug.GetValue() as Bool

	fDamageResist25HP = LastStandDamageResist25HP.GetValue() * 100
	fDamageResist50HP = LastStandDamageResist50HP.GetValue() * 100
	fSlowTimeHP = LastStandSlowTimeHP.GetValue() * 100
	
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

	; Left 3 Damage Resist Heading, Right 3 - Slow Time Heading
	AddHeaderOption("Damage Resist")
	AddHeaderOption("Slow Time")
	
	; Left 4 - Damage Resist 25%
	; Add Slider for setting HP threshold at which 25% Damage Resist is active
	iDamageResist25HPSlider = AddSliderOption("25% Damage Resist Health Percentage", fDamageResist25HP, "{0}%")
	
	; Right 4 - Slow Time
	; Add Slider for setting HP threshold at which Slow Time is activated on hits
	iSlowTimeHPSlider = AddSliderOption("Slow Time Health Percentage", fSlowTimeHP, "{0}%")

	; Left 5 - Damage Resist 50%
	; Add Slider for setting HP threshold at which 50% Damage Resist is active
	iDamageResist50HPSlider = AddSliderOption("50% Damage Resist Health Percentage", fDamageResist50HP, "{0}%")
endEvent

Event OnOptionHighlight(int a_option)
{Called when highlighting an option}
	
	if a_option == iEnabledToggle
		SetInfoText("Enable/Disable  mod. Recommended to use this to disable the mod before uninstalling")
	elseIf a_option == iDebugToggle
		SetInfoText("Enable/Disable Debug Notifications")
	elseIf a_option == iDamageResist25HPSlider
		SetInfoText("Health Percentage below which 25% Damage Resist will activate. Set 0 to disable.")
	elseIf a_option == iDamageResist50HPSlider
		SetInfoText("Health Percentage below which 50% Damage Resist will activate. Set 0 to disable")
	elseIf a_option == iSlowTimeHPSlider
		SetInfoText("Health Percentage below which Slow Time effect will activate when hit. Set 0 to disable")
	else
		SetInfoText("")
	endIf
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
		SetToggleOptionValue(iEnabledToggle, bEnabled)
	elseIf a_option == iDebugToggle
		bDebug = false
		SetToggleOptionValue(a_option, bDebug)
	elseIf a_option == iDamageResist25HPSlider
		fDamageResist25HP = 50.0
		SetSliderOptionValue(a_option, 50.0, "{0}%")
	elseIf a_option == iDamageResist50HPSlider
		fDamageResist50HP = 25.0
		SetSliderOptionValue(a_option, 25.0, "{0}%")
	elseIf a_option == iSlowTimeHPSlider
		fSlowTimeHP = 25.0
		SetSliderOptionValue(a_option, 25.0, "{0}%")
	endIf
endEvent

Event OnOptionSliderOpen(int a_option)
	{Called when a slider option has been selected}

	If a_option == iDamageResist25HPSlider
		SetSliderDialogStartValue(fDamageResist25HP)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(5.0)
	elseIf a_option == iDamageResist50HPSlider
		SetSliderDialogStartValue(fDamageResist50HP)
		SetSliderDialogDefaultValue(25.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(5.0)
	elseIf a_option == iSlowTimeHPSlider
		SetSliderDialogStartValue(fSlowTimeHP)
		SetSliderDialogDefaultValue(25.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(5.0)
	endIf
endEvent

Event OnOptionSliderAccept(int a_option, float a_value)
	{Called when a new slider value has been accepted}

	if a_option == iDamageResist25HPSlider
		fDamageResist25HP = a_value
	elseIf a_option == iDamageResist50HPSlider
		fDamageResist50HP = a_value
	elseIf a_option == iSlowTimeHPSlider
		fSlowTimeHP = a_value
	endIf
	
	SetSliderOptionValue(a_option, a_value, "{0}%")
endEvent

; FUNCTIONS ------------------------------------------------------------------------------------------

Function UpdateModEnabled()
	; Update the global variable. This will be reference by the manager quest
	LastStandEnabled.SetValue(bEnabled as Int)
	
	; Reference the manager quest alias tab for player alias ID
	LastStandPlayerAlias playerAlias = LastStandQuest.GetAlias(1) as LastStandPlayerAlias
	
	; Start the manager quest as needed if mod is being enabled
	if bEnabled
		LastStandQuest.Start()
		If !LastStandQuest.isRunning()
			DebugScript("Manager Quest failed to start. Clean reinstall recommended")
		endIf
	else
		LastStandQuest.Stop()
	endIf
	
	; Enable/Disable functionality is handled in Maintenance
	playerAlias.Maintenance()
endFunction

; UTILITY ------------------------------------------------------------------------------------------

Function DebugScript(String asMessage)
	if LastStandDebug.GetValue() as Bool
		Debug.Trace(asMessage)
		Debug.Notification("Last Stand: " + asMessage)
	endIf
endFunction