--
-- This file handles the window to display.
--

local wm = GetWindowManager()

if HWS == nil then HWS = {} end

--
--
--
function HWS.MakeWindow()
	-- our primary window
	HWS.window = wm:CreateTopLevelWindow("Dancer")

    local hws = HWS.window
	hws:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, HWS.settings.x, HWS.settings.y)
	hws:SetMovable(true)
	hws:SetHidden(not HWS.settings.shown)
	hws:SetMouseEnabled(true)
	hws:SetClampedToScreen(true)
	hws:SetDimensions(0,0)
	hws:SetResizeToFitDescendents(true)
	hws:SetHandler("OnMoveStop", function()
		HWS.settings.x = hws:GetLeft()
		HWS.settings.y = hws:GetTop()
	end)
	
	-- give it a backdground (backdrop) for the frame
	hws.bg = wm:CreateControl("HWSBackground", hws, CT_BACKDROP)
	hws.bg:SetAnchorFill(hws)
	hws.bg:SetCenterColor(0, 0, 0, HWS.settings.alpha / 100)
	hws.bg:SetEdgeColor(0, 0, 0, HWS.settings.alpha / 100)
	hws.bg:SetEdgeTexture(nil, 2, 2, 0, 0)
	hws.bg:SetExcludeFromResizeToFitExtents(true)
	hws.bg:SetDrawLayer(DL_BACKGROUND)
	
	-- give it a header
	hws.title = wm:CreateControl("HWSTitle", hws, CT_LABEL)
	hws.title:SetAnchor(TOP, hws, TOP, 0, 5)
	hws.title:SetFont("EsoUi/Common/Fonts/Univers67.otf|18|soft-shadow-thin")
	hws.title:SetColor(.9, .9, .7, 1)
	hws.title:SetStyleColor(0, 0, 0, 1)
	hws.title:SetText("Potato Extravaganza:")
	hws.title:SetHidden(not HWS.settings.showtitle)
	
	-- Give it a zone label
	hws.zone = wm:CreateControl("HWSZone", hws, CT_LABEL)
	if (HWS.settings.showtitle) then
		hws.zone:SetAnchor(TOP, hws.title, BOTTOM, 0, 5)
	else
		hws.zone:SetAnchor(TOP, hws, TOP, 0, 5)
	end
	hws.zone:SetFont("EsoUi/Common/Fonts/Univers67.otf|17|soft-shadow-thin")
	hws.zone:SetColor(.9, .9, .7, 1)
	hws.zone:SetStyleColor(0, 0, 0, 1)
	hws.zone:SetText("Zone Name")

	-- TST
	hws.ranking = wm:CreateControl("Ranking", hws, CT_LABEL)
	if (HWS.settings.showtitle) then
		hws.ranking:SetAnchor(TOP, hws.title, BOTTOM, 0, 20)
	else
		hws.ranking:SetAnchor(TOP, hws, TOP, 0, 20)
	end
	hws.ranking:SetFont("EsoUi/Common/Fonts/Univers67.otf|17|soft-shadow-thin")
	hws.ranking:SetColor(.9, .9, .7, 1)
	hws.ranking:SetStyleColor(0, 0, 0, 1)
	hws.ranking:SetText("Rankings")

	-- make a container for the list entries
	hws.entries = wm:CreateControl("HWSEntries", hws, CT_CONTROL)
	hws.entries:SetAnchor(TOP, hws.zone, BOTTOM, 0, 0)
	hws.entries:SetHidden(false)
	hws.entries:SetResizeToFitDescendents(true)

	-- add a bit of padding
	hws.entries:SetResizeToFitPadding(20, 10)
	
	-- hide our window when the compass frame gets hidden, if it's not hidden already
	if ZO_CompassFrame:IsHandlerSet("OnShow") then
		local oldHandler = ZO_CompassFrame:GetHandler("OnShow")
		ZO_CompassFrame:SetHandler("OnShow", function(...) oldHandler(...) if HWS.settings.shown then HWS.window:SetHidden(false) end end)
	else
		ZO_CompassFrame:SetHandler("OnShow", function(...) if HWS.settings.shown then HWS.window:SetHidden(false) end end)
	end
	if ZO_CompassFrame:IsHandlerSet("OnHide") then
		local oldHandler = ZO_CompassFrame:GetHandler("OnHide")
		ZO_CompassFrame:SetHandler("OnHide", function(...) oldHandler(...) if HWS.settings.shown then HWS.window:SetHidden(true) end end)
	else
		ZO_CompassFrame:SetHandler("OnHide", function(...) if HWS.settings.shown then HWS.window:SetHidden(true) end end)
	end
end

--
--
--
function HWS.PopulateWindow(dances, rank)
	if HWS.window == nil then HWS.MakeWindow() end
	HWS.window.zone:SetText(dances)
	HWS.window:SetHidden(ZO_CompassFrame:IsHidden() or not HWS.settings.shown)
	HWS.window.ranking:SetText(rank)
	HWS.window:SetHidden(ZO_CompassFrame:IsHidden() or not HWS.settings.shown)
end


--
-- Show or hide the window
--
function HWS.ToggleWindow()
	local ishidden = HWS.window:IsHidden()
	-- refresh the window if we're about to show it
	if ishidden then HWS.RefreshWindow() end
	HWS.settings.shown = ishidden
	HWS.window:SetHidden(not ishidden)
end