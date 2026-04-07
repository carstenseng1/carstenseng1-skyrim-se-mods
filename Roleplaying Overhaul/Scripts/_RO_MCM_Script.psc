Scriptname _RO_MCM_Script extends SKI_ConfigBase  

GlobalVariable Property _RO_Enabled  Auto
GlobalVariable Property _RO_Debug  Auto
GlobalVariable Property _RO_SlowSkillAdvancementEnabled  Auto
GlobalVariable Property _RO_DrunkEnabled  Auto
GlobalVariable Property _RO_EncumbranceEnabled  Auto
GlobalVariable Property _RO_RoleplayingEnabled  Auto
GlobalVariable Property _RO_UndeadCurseEnabled  Auto

Quest Property _RO_ManagerQuest  Auto
Quest Property _RO_DrunkQuest  Auto
Quest Property _RO_EncumbranceQuest  Auto
Quest Property _RO_RoleplayingQuest  Auto
Quest Property _RO_UndeadCurseQuest  Auto

; SCRIPT VERSION ----------------------------------------------------------------------------------

int function GetVersion()
	return 1 ; Default version
endFunction

; PRIVATE VARIABLES -------------------------------------------------------------------------------

Int iEnabledToggle
Bool bEnabled

Int iDebugToggle
Bool bDebug

Int iSlowSkillAdvancementToggle
Bool bSlowSkillAdvancementEnabled

Int iDrunkToggle
Bool bDrunkEnabled

Int iEncumbranceToggle
Bool bEncumbranceEnabled

Int iRoleplayingToggle
Bool bRoleplayingEnabled

Int iUndeadCurseToggle
Bool bUndeadCurseEnabled

; EVENTS ------------------------------------------------------------------------------------------

Event OnConfigClose()
{Called when this config menu is closed}
	
	; Update debugging befor all other updates
	_RO_Debug.SetValue(bDebug as Int)

	; Update the global variables. These will be reference by the manager quests
	_RO_Enabled.SetValue(bEnabled as Int)
	_RO_SlowSkillAdvancementEnabled.SetValue(bSlowSkillAdvancementEnabled as Int)
	_RO_DrunkEnabled.SetValue(bDrunkEnabled as Int)
	_RO_EncumbranceEnabled.SetValue(bEncumbranceEnabled as Int)
	_RO_RoleplayingEnabled.SetValue(bRoleplayingEnabled as Int)
	_RO_UndeadCurseEnabled.SetValue(bUndeadCurseEnabled as Int)

	; Run update functions to start/stop quests and related features
	UpdateManagerEnabled()
	UpdateDrunkEnabled()
	UpdateEncumbranceEnabled()
	UpdateRoleplayingEnabled()
	UpdateUndeadCurseEnabled()
endEvent

Event OnPageReset(string a_page)
	{Called when a new page is selected, including the initial empty page}
	
	; Initialize private variables for settings
	bEnabled = _RO_Enabled.GetValue() as Bool
	bDebug = _RO_Debug.GetValue() as Bool
	bSlowSkillAdvancementEnabled = _RO_SlowSkillAdvancementEnabled.GetValue() as Bool
	bDrunkEnabled = _RO_DrunkEnabled.GetValue() as Bool
	bEncumbranceEnabled = _RO_EncumbranceEnabled.GetValue() as Bool
	bRoleplayingEnabled = _RO_RoleplayingEnabled.GetValue() as Bool
	bUndeadCurseEnabled = _RO_UndeadCurseEnabled.GetValue() as Bool

	SetCursorFillMode(LEFT_TO_RIGHT)
	
	; Left 0 - General Heading
	AddHeaderOption("General")

	; Right 0 - Features Heading
	AddHeaderOption("Features")

	; Left 1 - Enabled Toggle
	iEnabledToggle = AddToggleOption("Enable Mod", bEnabled)

	; Right 1 - Slow Skill Advancement Toggle
	iSlowSkillAdvancementToggle = AddToggleOption("Slow Skill Advancement", bSlowSkillAdvancementEnabled)

	; Left 2 - Debug Toggle
	iDebugToggle = AddToggleOption("Debugging", bDebug)

	; Right 2 - Drunk Toggle
	iDrunkToggle = AddToggleOption("Enable Drunk Effects", bDrunkEnabled)

	; Left 3 - Version
	AddTextOption("Mod Version", "1.0.1")

	; Right 3 - Encumbrance Toggle
	iEncumbranceToggle = AddToggleOption("Enable Gradual Encumbrance", bEncumbranceEnabled)

	; Left 4
	AddEmptyOption()

	; Right 4 - Roleplaying Toggle
	iRoleplayingToggle = AddToggleOption("Enable Roleplaying Bonuses", bRoleplayingEnabled)

	; Left 5
	AddEmptyOption()

	; Right 5 - Undead Curse Toggle
	iUndeadCurseToggle = AddToggleOption("Enable Undead Curse", bUndeadCurseEnabled)
endEvent

Event OnOptionHighlight(int a_option)
{Called when highlighting an option}

	if a_option == iEnabledToggle
		SetInfoText("Enable/Disable all configurable mod features. Recommended to use this to disable the mod before uninstalling")
	elseIf a_option == iDebugToggle
		SetInfoText("Enable/Disable script debug notifications")
	elseIf a_option == iSlowSkillAdvancementToggle
		SetInfoText("Enable/Disable slow skill advancement. Skills advance at 50% rate when enabled.")
	elseIf a_option == iDrunkToggle
		SetInfoText("Enable/Disable visual effects from drinking alcohol")
	elseIf a_option == iEncumbranceToggle
		SetInfoText("Enable/Disable movement speed decrease from carrying items in inventory")
	elseIf a_option == iRoleplayingToggle
		SetInfoText("Enable/Disable bonuses from performing immersive actions")
	elseIf a_option == iUndeadCurseToggle
		SetInfoText("Enable/Disable curse from looting crypts")
	else
		SetInfoText("")
	endIf
endEvent

event OnOptionSelect(int a_option)
{Called when a non-interactive option has been selected}
	
	if a_option == iEnabledToggle
		bEnabled = !bEnabled
		SetToggleOptionValue(a_option, bEnabled)
	elseIf a_option == iDebugToggle
		bDebug = !bDebug
		SetToggleOptionValue(a_option, bDebug)
	elseIf a_option == iSlowSkillAdvancementToggle
		bSlowSkillAdvancementEnabled = !bSlowSkillAdvancementEnabled
		SetToggleOptionValue(a_option, bSlowSkillAdvancementEnabled)
	elseIf a_option == iDrunkToggle
		bDrunkEnabled = !bDrunkEnabled
		SetToggleOptionValue(a_option, bDrunkEnabled)
	elseIf a_option == iEncumbranceToggle
		bEncumbranceEnabled = !bEncumbranceEnabled
		SetToggleOptionValue(a_option, bEncumbranceEnabled)
	elseIf a_option == iRoleplayingToggle
		bRoleplayingEnabled = !bRoleplayingEnabled
		SetToggleOptionValue(a_option, bRoleplayingEnabled)
	elseIf a_option == iUndeadCurseToggle
		bUndeadCurseEnabled = !bUndeadCurseEnabled
		SetToggleOptionValue(a_option, bUndeadCurseEnabled)
	endIf
endEvent

Event OnOptionDefault(int a_option)
{Called when resetting an option to its default value}
	
	if a_option == iEnabledToggle
		bEnabled = true
		SetToggleOptionValue(a_option, true)
	elseIf a_option == iDebugToggle
		bDebug = false
		SetToggleOptionValue(a_option, false)
	elseIf a_option == iSlowSkillAdvancementToggle
		bSlowSkillAdvancementEnabled = true
		SetToggleOptionValue(a_option, true)
	elseIf a_option == iDrunkToggle
		bDrunkEnabled = true
		SetToggleOptionValue(a_option, true)
	elseIf a_option == iEncumbranceToggle
		bEncumbranceEnabled = true
		SetToggleOptionValue(a_option, true)
	elseIf a_option == iRoleplayingToggle
		bRoleplayingEnabled = true
		SetToggleOptionValue(a_option, true)
	elseIf a_option == iUndeadCurseToggle
		bUndeadCurseEnabled = true
		SetToggleOptionValue(a_option, true)
	endIf
endEvent

; FUNCTIONS ------------------------------------------------------------------------------------------

; Player Alias IDs
; Manager 0
; Drunk 7
; Encumbrance 0
; Roleplaying 0
; UnceadCurse 8

Function UpdateManagerEnabled()
	; Start/Stop the manager quest
	Bool bHasStateChanged = false
	if bEnabled
		if !_RO_ManagerQuest.isRunning()
			_RO_ManagerQuest.Start()
			bHasStateChanged = true
		endIf
	else
		if _RO_ManagerQuest.isRunning()
			_RO_ManagerQuest.Stop()
			bHasStateChanged = true
		endIf
	endIf
	
	; Enable/Disable functionality is handled in Maintenance function
	; Run maintenance if quest state has changed
	if bHasStateChanged
		DebugScriptQuestStatus(_RO_ManagerQuest, "Manager", bEnabled)

		; Reference the manager quest alias tab for player alias ID
		_RO_ManagerQuestPlayerAlias playerAlias = _RO_ManagerQuest.GetAlias(0) as _RO_ManagerQuestPlayerAlias
		playerAlias.Maintenance()
	endIf
endFunction

Function UpdateDrunkEnabled()
	; Start/Stop the manager quest
	Bool bHasStateChanged = false
	if bEnabled && bDrunkEnabled
		if !_RO_DrunkQuest.isRunning()
			_RO_DrunkQuest.Start()
			bHasStateChanged = true
		endIf
	else
		if _RO_DrunkQuest.isRunning()
			_RO_DrunkQuest.Stop()
			bHasStateChanged = true
		endIf
	endIf
	
	; Enable/Disable functionality is handled in Maintenance function
	; Run maintenance if quest state has changed
	if bHasStateChanged
		DebugScriptQuestStatus(_RO_DrunkQuest, "Drunk", bDrunkEnabled)

		; Reference the manager quest alias tab for player alias ID
		_RO_DrunkQuestPlayerAlias playerAlias = _RO_DrunkQuest.GetAlias(7) as _RO_DrunkQuestPlayerAlias
		playerAlias.Maintenance()
	endIf
endFunction

Function UpdateEncumbranceEnabled()
	; Start/Stop the manager quest
	Bool bHasStateChanged = false
	if bEnabled && bEncumbranceEnabled
		if !_RO_EncumbranceQuest.isRunning()
			_RO_EncumbranceQuest.Start()
			bHasStateChanged = true
		endIf
	else
		if _RO_EncumbranceQuest.isRunning()
			_RO_EncumbranceQuest.Stop()
			bHasStateChanged = true
		endIf
	endIf
	
	; Enable/Disable functionality is handled in Maintenance function
	if bHasStateChanged
		DebugScriptQuestStatus(_RO_EncumbranceQuest, "Encumbrance", bEncumbranceEnabled)

		; Reference the manager quest alias tab for player alias ID
		_RO_EncumbranceQuestPlayerAlias playerAlias = _RO_EncumbranceQuest.GetAlias(0) as _RO_EncumbranceQuestPlayerAlias
		playerAlias.Maintenance()
	endIf
endFunction

Function UpdateRoleplayingEnabled()
	; Start/Stop the manager quest
	Bool bHasStateChanged = false
	if bEnabled && bRoleplayingEnabled
		if !_RO_RoleplayingQuest.isRunning()
			_RO_RoleplayingQuest.Start()
			bHasStateChanged = true
		endIf
	else
		if _RO_RoleplayingQuest.isRunning()
			_RO_RoleplayingQuest.Stop()
			bHasStateChanged = true
		endIf
	endIf
	
	; Enable/Disable functionality is handled in Maintenance function
	if bHasStateChanged
		DebugScriptQuestStatus(_RO_RoleplayingQuest, "Releplaying", bRoleplayingEnabled)

		; Reference the manager quest alias tab for player alias ID
		_RO_RoleplayingQuestPlayerAlias playerAlias = _RO_RoleplayingQuest.GetAlias(0) as _RO_RoleplayingQuestPlayerAlias
		playerAlias.Maintenance()
	endIf
endFunction

Function UpdateUndeadCurseEnabled()
	; Start/Stop the manager quest
	Bool bHasStateChanged = false
	if bEnabled && bUndeadCurseEnabled
		if !_RO_UndeadCurseQuest.isRunning()
			_RO_UndeadCurseQuest.Start()
			bHasStateChanged = true
		endIf
	else
		if _RO_UndeadCurseQuest.isRunning()
			_RO_UndeadCurseQuest.Stop()
			bhasStateChanged = true
		endIf
	endIf
	
	; Enable/Disable functionality is handled in Maintenance function
	if bHasStateChanged
		DebugScriptQuestStatus(_RO_UndeadCurseQuest, "Undead Curse", bUndeadCurseEnabled)

		; Reference the manager quest alias tab for player alias ID
		_RO_UndeadCurseQuestPlayerAlias playerAlias = _RO_UndeadCurseQuest.GetAlias(8) as _RO_UndeadCurseQuestPlayerAlias
		playerAlias.Maintenance()
	endIf
endFunction

; UTILITY ------------------------------------------------------------------------------------------

Function DebugScript(String asMessage)
	if _RO_Debug.GetValue() as Bool
		Debug.Trace(asMessage)
		Debug.Notification("Fjør Tal: " + asMessage)
	endIf
endFunction

Function DebugScriptQuestStatus(Quest akQuest, String asQuestName, Bool abSetting)
	if _RO_Debug.GetValue() as Bool
		String sSetting = ""
		if abSetting
			sSetting = "Enabled"
		else
			sSetting = "Disabled"
		endIf
		String sStatus = ""
		if akQuest.isRunning()
			sStatus = "Running"
		else
			sStatus = "Stopped"
		endIf
		Debug.Notification(asQuestName + " " + sSetting + " " + sStatus)
	endIf
endFunction