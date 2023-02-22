-- define local variables as much as possible, so scope is local
-- see http://lua-users.org/wiki/ScopeTutorial
local wm = GetWindowManager()
local em = GetEventManager()
local _
local isBlocking = false
local danceCounter = 0

-- create a namespace for HWS by declaring a top-level table that will hold everything else.
if HWS == nil then HWS = {} end

-- The AddOn name
HWS.name = "Dancer"
HWS.version = "1.0"

HWS.settings = {}

-- default values for saved variables
-- see http://wiki.esoui.com/AddOn_Quick_Questions#How_do_I_save_settings_on_the_local_machine.3F
HWS.defaults = {
	alpha = 50,
	x = 40,
	y = 450,
	showtitle = true,
	shown = true,
}

function HWS.OnCombatEvent(eventCode, ActionResult, isError, abilityName, abilityGraphic, ActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId, overflow)
	danceCounter = danceCounter + 1
	HWS.RefreshWindow(danceCounter)
end

function HWS.RefreshWindow(counter)
	HWS.PopulateWindow("Dance moves performed : "..counter)
end

--
-- This function that will initialize our addon with ESO
--
function HWS.Initialize(event, addon)
    -- filter for just HWS addon event
	if addon ~= HWS.name then return end

	em:UnregisterForEvent("DancerInitialize", EVENT_ADD_ON_LOADED)

	-- load our saved variables
	HWS.settings = ZO_SavedVars:New("DancerSavedVars", 1, nil, HWS.defaults)

	-- make a label for our keybinding
	ZO_CreateStringId("SI_BINDING_NAME_DANCER_TOGGLE", "Toggle Window")

	-- make our options menu
	HWS.MakeMenu()

	em:RegisterForEvent("Dancer_CombatEvent", EVENT_COMBAT_EVENT, function(...) HWS.OnCombatEvent(...) end)
	em:AddFilterForEvent("Dancer_CombatEvent", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, 55146)
	em:RegisterForEvent("Dancer_Start", EVENT_PLAYER_ACTIVATED, function(...) HWS.RefreshWindow(0) end)
end



-- register our event handler function to be called to do initialization
em:RegisterForEvent("DancerInitialize", EVENT_ADD_ON_LOADED, function(...) HWS.Initialize(...) end)
