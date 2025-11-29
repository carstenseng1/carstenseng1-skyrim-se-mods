Scriptname IDB_MCMScript extends SKI_ConfigBase  

GlobalVariable Property IDB_Enabled  Auto
GlobalVariable Property IDB_ParalysisEnabled  Auto
GlobalVariable Property IDB_PercentHealth  Auto
Quest Property IDB_ManagerQuest  Auto

Int iEnabledToggle
Bool bEnabled

Int iParalysisToggle
Bool bParalysisEnabled

Int iPercentHealthSlider
Float fPercentHealth

; SCRIPT VERSION ----------------------------------------------------------------------------------

Int Function GetVersion()
	return 1 ; Default version
endFunction

; EVENTS ------------------------------------------------------------------------------------------

Event OnConfigClose()
	{Called when this config menu is closed}
	
	; Check if a change was made
	if bEnabled != IDB_Enabled.GetValue() as Bool
		UpdateModEnabled()
	endIf
	
	IDB_ParalysisEnabled.SetValue(bParalysisEnabled as Int)
	IDB_PercentHealth.SetValue(fPercentHealth/100)

endEvent


Event OnPageReset(String a_page)
	{Called when a new page is selected, including the initial empty page}
	
	bEnabled = IDB_Enabled.GetValue() as Bool
	bParalysisEnabled = IDB_ParalysisEnabled.GetValue() as Bool
	fPercentHealth = IDB_PercentHealth.GetValue() * 100
	
	SetCursorFillMode(TOP_TO_BOTTOM)
	
	; Add Mod Enabled Toggle
	iEnabledToggle = AddToggleOption("Enable Immortal Dragonborn", bEnabled)

	; Add Paralysis Toggle
	iParalysisToggle = AddToggleOption("Enable Paralysis on Revive", bParalysisEnabled)
	
	; Add Slider for setting HP threshold at which 25% Damage Resist is active
	iPercentHealthSlider = AddSliderOption("Activation Health Percentage", fPercentHealth, "{0}%")
	
endEvent


Event OnOptionHighlight(int a_option)
	{Called when highlighting an option}
	
	if a_option == iEnabledToggle
		SetInfoText("Enable/Disable Immortal Dragonborn. Recommended to use this to disable the mod before uninstalling")
	elseIf a_option == iParalysisToggle
		SetInfoText("Enable/Disable the Mass Paralysis spell cast when revived")
	elseIf a_option == iPercentHealthSlider
		SetInfoText("Health Percentage at which revival will activate. Recommended 10% to match Avoid Death Perk")
	else
		SetInfoText("")
	endIf
	
endEvent


Event OnOptionSelect(int a_option)
	{Called when a non-interactive option has been selected}
	
	if a_option == iEnabledToggle
		bEnabled = !bEnabled
		SetToggleOptionValue(a_option, bEnabled)
	elseIf a_option == iParalysisToggle
		bParalysisEnabled = !bParalysisEnabled
		SetToggleOptionValue(a_option, bParalysisEnabled)
	endIf

endEvent


Event OnOptionDefault(int a_option)
	{Called when resetting an option to its default value}

	if a_option == iEnabledToggle
		bEnabled = true
		SetToggleOptionValue(iEnabledToggle, bEnabled)
	elseIf a_option == iParalysisToggle
		bParalysisEnabled = true
		SetToggleOptionValue(iParalysisToggle, bParalysisEnabled)
	elseIf a_option == iPercentHealthSlider
		fPercentHealth = 10.0
		SetSliderOptionValue(a_option, 10.0, "{0}%")
	endIf
	
endEvent


Event OnOptionSliderOpen(int a_option)
	{Called when a slider option has been selected}

	If a_option == iPercentHealthSlider
		SetSliderDialogStartValue(fPercentHealth)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(5.0)
	endIf
	
endEvent


Event OnOptionSliderAccept(int a_option, float a_value)
	{Called when a new slider value has been accepted}

	if a_option == iPercentHealthSlider
		fPercentHealth = a_value
		SetSliderOptionValue(a_option, a_value, "{0}%")
	endIf
	
endEvent


Function UpdateModEnabled()
	; Update the global variable. This will be reference by the manager quest
	IDB_Enabled.SetValue(bEnabled as Int)
	
	ReferenceAlias playerAlias = IDB_ManagerQuest.GetAlias(0) as ReferenceAlias
	
	; Start the manager quest as needed if mod is being enabled
	if bEnabled && !IDB_ManagerQuest.isRunning()
		IDB_ManagerQuest.Start()
		playerAlias.ForceRefTo(Game.GetPlayer())
	endIf
	
	; Enable/Disable functionality is handled in the OnUpdate event
	playerAlias.RegisterForSingleUpdate(1.0)

endFunction