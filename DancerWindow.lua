--
-- This file handles the window to display.
--

local wm = GetWindowManager()

if Dancer == nil then Dancer = {} end

--
--
--
function Dancer.MakeWindow()
	-- our primary window
	Dancer.window = wm:CreateTopLevelWindow("Dancer")

    local dancer = Dancer.window
	dancer:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, Dancer.settings.x, Dancer.settings.y)
	dancer:SetMovable(true)
	dancer:SetHidden(not Dancer.settings.shown)
	dancer:SetMouseEnabled(true)
	dancer:SetClampedToScreen(true)
	dancer:SetDimensions(0,0)
	dancer:SetResizeToFitDescendents(true)
	dancer:SetHandler("OnMoveStop", function()
		Dancer.settings.x = dancer:GetLeft()
		Dancer.settings.y = dancer:GetTop()
	end)
	
	-- give it a backdground (backdrop) for the frame
	dancer.bg = wm:CreateControl("HWSBackground", dancer, CT_BACKDROP)
	dancer.bg:SetAnchorFill(dancer)
	dancer.bg:SetCenterColor(0, 0, 0, Dancer.settings.alpha / 100)
	dancer.bg:SetEdgeColor(0, 0, 0, Dancer.settings.alpha / 100)
	dancer.bg:SetEdgeTexture(nil, 2, 2, 0, 0)
	dancer.bg:SetExcludeFromResizeToFitExtents(true)
	dancer.bg:SetDrawLayer(DL_BACKGROUND)
	
	-- give it a header
	dancer.title = wm:CreateControl("HWSTitle", dancer, CT_LABEL)
	dancer.title:SetAnchor(TOP, dancer, TOP, 0, 5)
	dancer.title:SetFont("EsoUi/Common/Fonts/Univers67.otf|18|soft-shadow-thin")
	dancer.title:SetColor(.9, .9, .7, 1)
	dancer.title:SetStyleColor(0, 0, 0, 1)
	dancer.title:SetText("Potato Extravaganza:")
	dancer.title:SetHidden(not Dancer.settings.showtitle)
	
	-- Give it a zone label
	dancer.zone = wm:CreateControl("HWSZone", dancer, CT_LABEL)
	if (Dancer.settings.showtitle) then
		dancer.zone:SetAnchor(TOP, dancer.title, BOTTOM, 0, 5)
	else
		dancer.zone:SetAnchor(TOP, dancer, TOP, 0, 5)
	end
	dancer.zone:SetFont("EsoUi/Common/Fonts/Univers67.otf|17|soft-shadow-thin")
	dancer.zone:SetColor(.9, .9, .7, 1)
	dancer.zone:SetStyleColor(0, 0, 0, 1)
	dancer.zone:SetText("Zone Name")

	-- TST
	dancer.ranking = wm:CreateControl("Ranking", dancer, CT_LABEL)
	if (Dancer.settings.showtitle) then
		dancer.ranking:SetAnchor(TOP, dancer.title, BOTTOM, 0, 20)
	else
		dancer.ranking:SetAnchor(TOP, dancer, TOP, 0, 20)
	end
	dancer.ranking:SetFont("EsoUi/Common/Fonts/Univers67.otf|17|soft-shadow-thin")
	dancer.ranking:SetColor(.9, .9, .7, 1)
	dancer.ranking:SetStyleColor(0, 0, 0, 1)
	dancer.ranking:SetText("Rankings")

	-- make a container for the list entries
	dancer.entries = wm:CreateControl("HWSEntries", dancer, CT_CONTROL)
	dancer.entries:SetAnchor(TOP, dancer.zone, BOTTOM, 0, 0)
	dancer.entries:SetHidden(false)
	dancer.entries:SetResizeToFitDescendents(true)

	-- add a bit of padding
	dancer.entries:SetResizeToFitPadding(20, 10)
	
	-- hide our window when the compass frame gets hidden, if it's not hidden already
	if ZO_CompassFrame:IsHandlerSet("OnShow") then
		local oldHandler = ZO_CompassFrame:GetHandler("OnShow")
		ZO_CompassFrame:SetHandler("OnShow", function(...) oldHandler(...) if Dancer.settings.shown then Dancer.window:SetHidden(false) end end)
	else
		ZO_CompassFrame:SetHandler("OnShow", function(...) if Dancer.settings.shown then Dancer.window:SetHidden(false) end end)
	end
	if ZO_CompassFrame:IsHandlerSet("OnHide") then
		local oldHandler = ZO_CompassFrame:GetHandler("OnHide")
		ZO_CompassFrame:SetHandler("OnHide", function(...) oldHandler(...) if Dancer.settings.shown then Dancer.window:SetHidden(true) end end)
	else
		ZO_CompassFrame:SetHandler("OnHide", function(...) if Dancer.settings.shown then Dancer.window:SetHidden(true) end end)
	end
end

--
--
--
function Dancer.PopulateWindow(dances, rank)
	if Dancer.window == nil then Dancer.MakeWindow() end
	Dancer.window.zone:SetText(dances)
	Dancer.window:SetHidden(ZO_CompassFrame:IsHidden() or not Dancer.settings.shown)
	Dancer.window.ranking:SetText(rank)
	Dancer.window:SetHidden(ZO_CompassFrame:IsHidden() or not Dancer.settings.shown)
end


--
-- Show or hide the window
--
function Dancer.ToggleWindow()
	local ishidden = Dancer.window:IsHidden()
	-- refresh the window if we're about to show it
	if ishidden then Dancer.RefreshWindow() end
	Dancer.settings.shown = ishidden
	Dancer.window:SetHidden(not ishidden)
end