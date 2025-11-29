Scriptname LastStandMCMScript extends SKI_ConfigBase  

GlobalVariable Property LastStandEnabled  Auto
GlobalVariable Property LastStandDamageResist25HP  Auto
GlobalVariable Property LastStandDamageResist50HP  Auto
GlobalVariable Property LastStandSlowTimeHP  Auto
Quest Property LastStandQuest  Auto

Int iEnabledToggle
Bool bEnabled

Int iDamageResist25HPSlider
Float fDamageResist25HP

Int iDamageResist50HPSlider
Float fDamageResist50HP

Int iSlowTimeHPSlider
Float fSlowTimeHP

; SCRIPT VERSION ----------------------------------------------------------------------------------

int function GetVersion()
	return 1 ; Default version
endFunction


; PRIVATE VARIABLES -------------------------------------------------------------------------------

; OIDs (T:Text B:Toggle S:Slider M:Menu, C:Color, K:Key)
int			_myTextOID_T
int			_myToggle_OID_B
int			_mySliderOID_S
int			_myMenuOID_M
int			_myColorOID_C
int			_myKeyOID_K
int			_myInputOID_I

; State

; ...

; Internal

; ...


; INITIALIZATION ----------------------------------------------------------------------------------

; @implements SKI_ConfigBase
event OnConfigInit()
	{Called when this config menu is initialized}
	
	; ...
endEvent

; @implements SKI_QuestBase
event OnVersionUpdate(int a_version)
	{Called when a version update of this script has been detected}

	; ...
endEvent


; EVENTS ------------------------------------------------------------------------------------------

event OnConfigClose()
	{Called when this config menu is closed}
	
	; Check if a change was made
	if bEnabled != LastStandEnabled.GetValue() as Bool
		UpdateModEnabled()
	endIf
	
	LastStandDamageResist25HP.SetValue(fDamageResist25HP/100)
	LastStandDamageResist50HP.SetValue(fDamageResist50HP/100)
	LastStandSlowTimeHP.SetValue(fSlowTimeHP/100)
endEvent

; @implements SKI_ConfigBase
event OnPageReset(string a_page)
	{Called when a new page is selected, including the initial empty page}
	
	bEnabled = LastStandEnabled.GetValue() as Bool
	fDamageResist25HP = LastStandDamageResist25HP.GetValue() * 100
	fDamageResist50HP = LastStandDamageResist50HP.GetValue() * 100
	fSlowTimeHP = LastStandSlowTimeHP.GetValue() * 100
	
	SetCursorFillMode(TOP_TO_BOTTOM)
	
	; Add Mod Enabled Toggle
	iEnabledToggle = AddToggleOption("Enable Mod", bEnabled)
	
	; Add Slider for setting HP threshold at which 25% Damage Resist is active
	iDamageResist25HPSlider = AddSliderOption("25% Damage Resist Health Percentage", fDamageResist25HP, "{0}%")
	
	; Add Slider for setting HP threshold at which 50% Damage Resist is active
	iDamageResist50HPSlider = AddSliderOption("50% Damage Resist Health Percentage", fDamageResist50HP, "{0}%")
	
	; Add Slider for setting HP threshold at which Slow Time is activated on hits
	iSlowTimeHPSlider = AddSliderOption("Slow Time Health Percentage", fSlowTimeHP, "{0}%")
	
	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionHighlight(int a_option)
	{Called when highlighting an option}
	
	if a_option == iEnabledToggle
		SetInfoText("Enable/Disable the mod. Recommended to use this to disable the mod before uninstalling")
	elseIf a_option == iDamageResist25HPSlider
		SetInfoText("Health Percentage below which 25% Damage Resist will activate. Set 0 to disable.")
	elseIf a_option == iDamageResist50HPSlider
		SetInfoText("Health Percentage below which 50% Damage Resist will activate. Set 0 to disable")
	elseIf a_option == iSlowTimeHPSlider
		SetInfoText("Health Percentage below which Slow Time effect will activate when hit. Set 0 to disable")
	else
		SetInfoText("")
	endIf
	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionSelect(int a_option)
	{Called when a non-interactive option has been selected}
	
	if a_option == iEnabledToggle
		bEnabled = !bEnabled
		SetToggleOptionValue(iEnabledToggle, bEnabled)
	endIf
	
	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionDefault(int a_option)
	{Called when resetting an option to its default value}

	if a_option == iEnabledToggle
		bEnabled = true
		SetToggleOptionValue(iEnabledToggle, bEnabled)
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
	
	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionSliderOpen(int a_option)
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
	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionSliderAccept(int a_option, float a_value)
	{Called when a new slider value has been accepted}

	if a_option == iDamageResist25HPSlider
		fDamageResist25HP = a_value
	elseIf a_option == iDamageResist50HPSlider
		fDamageResist50HP = a_value
	elseIf a_option == iSlowTimeHPSlider
		fSlowTimeHP = a_value
	endIf
	
	SetSliderOptionValue(a_option, a_value, "{0}%")
	
	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionMenuOpen(int a_option)
	{Called when a menu option has been selected}

	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionMenuAccept(int a_option, int a_index)
	{Called when a menu entry has been accepted}
	
	
	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionColorOpen(int a_option)
	{Called when a color option has been selected}

	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionColorAccept(int a_option, int a_color)
	{Called when a new color has been accepted}

	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionKeyMapChange(int a_option, int a_keyCode, string a_conflictControl, string a_conflictName)
	{Called when a key has been remapped}

	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionInputOpen(int a_option)
	{Called when a text input option has been selected}

	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionInputAccept(int a_option, string a_input)
	{Called when a new text input has been accepted}

	; ...
endEvent

Function UpdateModEnabled()
	; Update the global variable. This will be reference by the manager quest
	LastStandEnabled.SetValue(bEnabled as Int)
	
	ReferenceAlias playerAlias = LastStandQuest.GetAlias(1) as ReferenceAlias
	
	; Start the manager quest as needed if mod is being enabled
	if bEnabled && !LastStandQuest.isRunning()
		LastStandQuest.Start()
		playerAlias.ForceRefTo(Game.GetPlayer())
	endIf
	
	; Enable/Disable functionality is handled in the OnUpdate event of the manager quest
	playerAlias.RegisterForSingleUpdate(1.0)
endFunction
