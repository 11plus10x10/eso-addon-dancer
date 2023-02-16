-- Hello World ESO AddOn by GlassHalfFull
-- see README.txt for description of this addon and change log
-- The ESO Wiki main page is at http://wiki.esoui.com/Main_Page
--

-- define local variables as much as possible, so scope is local
-- see http://lua-users.org/wiki/ScopeTutorial
local wm = GetWindowManager()
local em = GetEventManager()
local _

-- create a namespace for HWS by declaring a top-level table that will hold everything else.
if HWS == nil then HWS = {} end

-- The AddOn name
HWS.name = "HelloWorld"
HWS.version = "3.8"

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



--
-- RefreshWindow() is a callback for EVENT_ZONE_CHANGED. 
-- It populates the window with data about the new zone.
--
function HWS.RefreshWindow()
	HWS.zone = GetUnitZone('player')
	--d('Zone: '..HWS.zone)
	local achievement
	local searchZone = HWS.StripArticles(HWS.zone)
	--d("Search zone: "..searchZone)
	HWS.PopulateWindow(HWS.zone, achievement)
end


--
-- StripArticles() removes definite articles from the zone name, from Rare Fish Tracker
--
function HWS.StripArticles(fullName)
	local name = string.gsub(fullName, "^The ", "")
	name = string.gsub(name,"^Les ","")
	name = string.gsub(name,"^Le ","")
	name = string.gsub(name,"^La ","")
	name = string.gsub(name,"^Der ","")
	name = string.gsub(name,"^Die ","")
	name = string.gsub(name,"^Das ","")
	name = string.gsub(name,"%^.*","")
	name = string.gsub(name," Isle","")
	return name
end


--
-- This function that will initialize our addon with ESO
--
function HWS.Initialize(event, addon)
    -- filter for just HWS addon event
	if addon ~= HWS.name then return end

	em:UnregisterForEvent("HelloWorldInitialize", EVENT_ADD_ON_LOADED)

	-- load our saved variables
	HWS.settings = ZO_SavedVars:New("HelloWorldSavedVars", 1, nil, HWS.defaults)

	-- make a label for our keybinding
	ZO_CreateStringId("SI_BINDING_NAME_HELLO_WORLD_TOGGLE", "Toggle Window")

	-- make our options menu
	HWS.MakeMenu()

	-- also, do this last, to minimize the chance of problem zone transitions
	em:RegisterForEvent("HelloWorldStart", EVENT_PLAYER_ACTIVATED, function(...) HWS.RefreshWindow(...) end)
end



-- register our event handler function to be called to do initialization
em:RegisterForEvent("HelloWorldInitialize", EVENT_ADD_ON_LOADED, function(...) HWS.Initialize(...) end)
