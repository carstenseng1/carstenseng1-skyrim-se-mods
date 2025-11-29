Scriptname LastStandMCMScript extends SKI_ConfigBase  

GlobalVariable Property LastStandEnabled  Auto
Quest Property LastStandQuest  Auto

Int iEnabledToggle

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

; @implements SKI_ConfigBase
event OnPageReset(string a_page)
	{Called when a new page is selected, including the initial empty page}
	
	SetCursorFillMode(TOP_TO_BOTTOM)
	
	; Create Mod Enabled Toggle
	Bool enabledVal = LastStandEnabled.GetValue() as Bool
	iEnabledToggle = AddToggleOption("Enable Mod", enabledVal)
	;SetToggleOptionValue(iEnabledToggle, enabledVal)
	
	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionHighlight(int a_option)
	{Called when highlighting an option}

	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionSelect(int a_option)
	{Called when a non-interactive option has been selected}
	
	if a_option == iEnabledToggle
		Bool enabledVal = LastStandEnabled.GetValue() as Bool
		enabledVal = !enabledVal
		SetToggleOptionValue(iEnabledToggle, enabledVal)
		SetModEnabled(enabledVal)
	endIf
	
	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionDefault(int a_option)
	{Called when resetting an option to its default value}

	if a_option == iEnabledToggle
		Bool enabledVal = true
		SetToggleOptionValue(iEnabledToggle, enabledVal)
		SetModEnabled(enabledVal)
	endIf
	
	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionSliderOpen(int a_option)
	{Called when a slider option has been selected}

	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionSliderAccept(int a_option, float a_value)
	{Called when a new slider value has been accepted}

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

Function SetModEnabled(Bool bEnabled)
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
