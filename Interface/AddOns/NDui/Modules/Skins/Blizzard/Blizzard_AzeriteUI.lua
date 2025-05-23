local _, ns = ...
local B, C, L, DB = unpack(ns)
local r, g, b = DB.r, DB.g, DB.b

C.themes["Blizzard_AzeriteUI"] = function()
	B.ReskinPortraitFrame(AzeriteEmpoweredItemUI)
	AzeriteEmpoweredItemUIBg:Hide()
	AzeriteEmpoweredItemUI.ClipFrame.BackgroundFrame.Bg:Hide()
end

local function updateEssenceButton(button)
	if not button.bg then
		local bg = B.CreateBDFrame(button, .25)
		bg:SetPoint("TOPLEFT", 1, 0)
		bg:SetPoint("BOTTOMRIGHT", 0, 2)

		if button.Icon then
			B.ReskinIcon(button.Icon)
			button.PendingGlow:SetTexture("")
			local hl = button:GetHighlightTexture()
			hl:SetColorTexture(r, g, b, .25)
			hl:SetInside(bg)
			button.Background:SetAlpha(0)
		end
		if button.ExpandedIcon then
			button:DisableDrawLayer("BACKGROUND")
			button:DisableDrawLayer("BORDER")
		end

		button.bg = bg
	end

	if button:IsShown() then
		if button.PendingGlow and button.PendingGlow:IsShown() then
			button.bg:SetBackdropBorderColor(1, .8, 0)
		else
			button.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end
end

C.themes["Blizzard_AzeriteEssenceUI"] = function()
	B.ReskinPortraitFrame(AzeriteEssenceUI)
	B.StripTextures(AzeriteEssenceUI.PowerLevelBadgeFrame)
	B.ReskinTrimScroll(AzeriteEssenceUI.EssenceList.ScrollBar)

	for _, milestoneFrame in pairs(AzeriteEssenceUI.Milestones) do
		if milestoneFrame.LockedState then
			milestoneFrame.LockedState.UnlockLevelText:SetTextColor(.6, .8, 1)
			milestoneFrame.LockedState.UnlockLevelText.SetTextColor = B.Dummy
		end
	end

	hooksecurefunc(AzeriteEssenceUI.EssenceList.ScrollBox, "Update", function(self)
		self:ForEachFrame(updateEssenceButton)
	end)
end

local function reskinReforgeUI(frame, index)
	B.StripTextures(frame, index)
	B.CreateBDFrame(frame.Background)
	B.SetBD(frame)
	B.ReskinClose(frame.CloseButton)
	B.ReskinIcon(frame.ItemSlot.Icon)

	local buttonFrame = frame.ButtonFrame
	B.StripTextures(buttonFrame)
	buttonFrame.MoneyFrameEdge:SetAlpha(0)
	local bg = B.CreateBDFrame(buttonFrame, .25)
	bg:SetPoint("TOPLEFT", buttonFrame.MoneyFrameEdge, 3, 0)
	bg:SetPoint("BOTTOMRIGHT", buttonFrame.MoneyFrameEdge, 0, 2)
	if buttonFrame.AzeriteRespecButton then B.Reskin(buttonFrame.AzeriteRespecButton) end
	if buttonFrame.ActionButton then B.Reskin(buttonFrame.ActionButton) end
	if buttonFrame.Currency then B.ReskinIcon(buttonFrame.Currency.Icon) end

	if frame.DescriptionCurrencies then
		hooksecurefunc(frame.DescriptionCurrencies, "SetCurrencies", B.SetCurrenciesHook)
	end
end

C.themes["Blizzard_AzeriteRespecUI"] = function()
	reskinReforgeUI(AzeriteRespecFrame, 15)
end

C.themes["Blizzard_ItemInteractionUI"] = function()
	reskinReforgeUI(ItemInteractionFrame)
end