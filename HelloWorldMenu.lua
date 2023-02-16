-- sentry to make sure HWS is declared before use
if HWS == nil then HWS = {} end

--
-- Register with LibMenu and ESO
--
function HWS.MakeMenu()
    -- load the settings->addons menu library
	local menu = LibAddonMenu2
	local set = HWS.settings

    -- the panel for the addons menu
	local panel = {
		type = "panel",
		name = "Hello World",
		displayName = "Hello World",
		author = "GlassHalfFull",
        version = "" .. HWS.version,
	}

    -- this addons entries in the addon menu
	local options = {
		{
			type = "header",
			name = "Window Settings",
		},
		{
			type = "slider",
			name = "Window Background Alpha",
			tooltip = "How transparent or opaque should the window background be?",
			min = 0,
			max = 100,
			step = 5,
			getFunc = function() return set.alpha end,
			setFunc = function(value) 
				set.alpha = value
				HWS.window.bg:SetCenterColor(0, 0, 0, set.alpha / 100)
				HWS.window.bg:SetEdgeColor(0, 0, 0, set.alpha / 100)
			end,
			default = 60,
		},
		{
			type = "checkbox",
			name = "Show Title",
			tooltip = "Display the add-on title in the window?",
			getFunc = function() return set.showtitle end,
			setFunc = function(value)
				set.showtitle = value
				HWS.window.title:SetHidden(not set.showtitle)
				if (set.showtitle) then
					HWS.window.zone:ClearAnchors()
					HWS.window.zone:SetAnchor(TOP, HWS.window.title, BOTTOM, 0, 5)
				else
					HWS.window.zone:ClearAnchors()
					HWS.window.zone:SetAnchor(TOP, HWS.window, TOP, 0, 5)
				end
			end,
		},
		{
			type = "checkbox",
			name = "Show Window",
			tooltip = "Display the window?",
			getFunc = function() return set.shown end,
			setFunc = function(value)
				set.shown = value
			end,
		},
	}

	menu:RegisterAddonPanel("Hello_World", panel)
	menu:RegisterOptionControls("Hello_World", options)
end