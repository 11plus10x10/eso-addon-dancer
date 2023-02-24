-- sentry to make sure Dancer is declared before use
if Dancer == nil then Dancer = {} end

--
-- Register with LibMenu and ESO
--
function Dancer.MakeMenu()
    -- load the settings->addons menu library
	local menu = LibAddonMenu2
	local set = Dancer.settings

    -- the panel for the addons menu
	local panel = {
		type = "panel",
		name = "Dancer",
		displayName = "Dancer",
		author = "11+10x10",
        version = "" .. Dancer.version,
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
				Dancer.window.bg:SetCenterColor(0, 0, 0, set.alpha / 100)
				Dancer.window.bg:SetEdgeColor(0, 0, 0, set.alpha / 100)
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
				Dancer.window.title:SetHidden(not set.showtitle)
				if (set.showtitle) then
					Dancer.window.zone:ClearAnchors()
					Dancer.window.zone:SetAnchor(TOP, Dancer.window.title, BOTTOM, 0, 5)
				else
					Dancer.window.zone:ClearAnchors()
					Dancer.window.zone:SetAnchor(TOP, Dancer.window, TOP, 0, 5)
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

	menu:RegisterAddonPanel("Dancer_", panel)
	menu:RegisterOptionControls("Dancer_", options)
end